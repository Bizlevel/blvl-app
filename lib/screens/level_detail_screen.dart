import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/models/lesson_model.dart';
import 'package:bizlevel/providers/lessons_provider.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bizlevel/providers/lesson_progress_provider.dart';
import 'package:bizlevel/widgets/lesson_widget.dart';
import 'package:bizlevel/screens/leo_dialog_screen.dart';
import 'package:bizlevel/widgets/quiz_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bizlevel/providers/levels_provider.dart';
import 'package:bizlevel/providers/levels_repository_provider.dart';
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/widgets/custom_textfield.dart';
import 'package:bizlevel/services/auth_service.dart';
import 'package:bizlevel/providers/user_skills_provider.dart';

/// Shows a level as full-screen blocks (Intro → Lesson → Quiz → …).
class LevelDetailScreen extends ConsumerStatefulWidget {
  final int levelId;
  final int? levelNumber;
  const LevelDetailScreen({super.key, required this.levelId, this.levelNumber});

  @override
  ConsumerState<LevelDetailScreen> createState() => _LevelDetailScreenState();
}

class _LevelDetailScreenState extends ConsumerState<LevelDetailScreen> {
  late final PageController _pageController;

  late List<_PageBlock> _blocks;
  LessonProgressState get _progress =>
      ref.watch(lessonProgressProvider(widget.levelId));

  // Флаг сохранения профиля (для уровня 0)
  bool _profileSaved = false;

  // Leo chat (создаётся при первом сообщении пользователя)
  String? _chatId;

  @override
  void initState() {
    super.initState();
    // Берём последнюю разблокированную страницу, чтобы открывать уровень там, где пользователь остановился.
    _pageController = PageController(initialPage: 0);
    // Гарантируем разблокировку Intro (0) и следующей страницы (1)
    _progressNotifier.unlockPage(1);
    // Listen for page changes to rebuild so that chat bubble visibility updates
    _pageController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Helpers to interact with progress provider
  LessonProgressNotifier get _progressNotifier =>
      ref.read(lessonProgressProvider(widget.levelId).notifier);

  void _unlockNext(int current) {
    // Не выходим за пределы списка блоков
    if (current + 1 < _blocks.length) {
      _progressNotifier.unlockPage(current + 1);
    }
  }

  void _videoWatched(int page) {
    // Отложим обновление, чтобы избежать модификации провайдера во время билда
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _progressNotifier.markVideoWatched(page);
      _unlockNext(page);
    });
  }

  void _quizPassed(int page) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _progressNotifier.markQuizPassed(page);
      _unlockNext(page);
    });
  }

  @override
  Widget build(BuildContext context) {
    final lessonsAsync = ref.watch(lessonsProvider(widget.levelId));

    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      body: lessonsAsync.when(
        data: (lessons) {
          _buildBlocks(lessons);

          final bool isLevelZero = (widget.levelNumber ?? -1) == 0;
          final bool isProfilePage =
              isLevelZero && _blocks[_currentIndex] is _ProfileFormBlock;

          final mainContent = SafeArea(
            child: Column(
              children: [
                Expanded(child: _buildPageView()),
                if (!isProfilePage)
                  _NavBar(
                    showDiscuss: !isLevelZero,
                    canBack: (_pageController.hasClients
                        ? (_pageController.page ??
                                _pageController.initialPage.toDouble()) >
                            0
                        : false),
                    // Кнопка «Далее» активна, если текущая страница разблокирована
                    // или следующая страница уже открыта.
                    canNext: _currentIndex < _progress.unlockedPage ||
                        _currentIndex + 1 == _progress.unlockedPage,
                    onBack: _goBack,
                    onNext: _goNext,
                    onDiscuss: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        barrierColor: Colors.black54,
                        builder: (_) => FractionallySizedBox(
                          heightFactor: 0.9,
                          child: LeoDialogScreen(chatId: _chatId),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 10),
                if ((widget.levelNumber ?? -1) != 0)
                  ElevatedButton.icon(
                    onPressed: _isLevelCompleted(lessons)
                        ? () async {
                            try {
                              await SupabaseService.completeLevel(
                                  widget.levelId);
                              // Обновляем карту уровней
                              ref.invalidate(levelsProvider);
                              ref.invalidate(currentUserProvider);
                              // Инвалидация навыков для обновления древа навыков в профиле
                              ref.invalidate(userSkillsProvider);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Уровень завершён!')),
                                );
                                Navigator.of(context).pop();
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Ошибка: $e')),
                                );
                              }
                            }
                          }
                        : null,
                    icon: const Icon(Icons.check),
                    label: const Text('Завершить уровень'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary),
                  ),
              ],
            ),
          );

          // Wrap with Stack to overlay chat bubble
          final stack = Stack(
            children: [
              mainContent,
              // Vertical progress dots on right side center
              Positioned(
                top: MediaQuery.of(context).size.height * 0.3,
                right: 8,
                child: _ProgressDots(
                  current: _currentIndex,
                  total: _blocks.length,
                  vertical: true,
                ),
              ),
            ],
          );
          return stack;
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Ошибка: ${e.toString()}')),
      ),
    );
  }

  // Helpers ---------------------------------------------------------

  int get _currentIndex {
    if (!_pageController.hasClients) return 0;
    // Используем фактическую позицию страницы, а не только целые индексы,
    // чтобы во время анимации «Назад» кнопка не блокировалась преждевременно.
    final current =
        _pageController.page ?? _pageController.initialPage.toDouble();
    return current.round();
  }

  // --- Leo chat helpers --------------------------------------------
  // ignore: unused_element
  String _buildSystemPrompt() {
    if (_currentIndex == 0) {
      return 'Пользователь читает вводный блок уровня ${widget.levelId}. Помогите разобраться со структурой уровня.';
    }
    final block = _blocks[_currentIndex];
    if (block is _LessonBlock) {
      return 'Пользователь сейчас просматривает урок "${block.lesson.title}". Дайте совет или пояснение по содержанию урока.';
    } else if (block is _QuizBlock) {
      return 'Пользователь проходит тест по уроку "${block.lesson.title}". Помогите объяснить правильные ответы, не раскрывая их напрямую.';
    } else {
      return 'Пользователь работает с уровнем ${widget.levelId}. Помогите при необходимости.';
    }
  }

  void _goBack() {
    final pos = _pageController.page ?? _pageController.initialPage.toDouble();
    if (pos > 0) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _goNext() {
    if (_currentIndex + 1 < _blocks.length &&
        _currentIndex < _progress.unlockedPage) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  Widget _buildPageView() {
    // SizedBox.expand гарантирует, что PageView получает валидные вертикальные constraints
    // даже на раннем этапе компоновки (особенно в iOS debug-сборке), исключая создание
    // горизонтального Viewport и неправильную ориентацию свайпа.
    return SizedBox.expand(
      child: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _blocks.length,
        itemBuilder: (context, index) {
          final locked = index > _progress.unlockedPage;
          return AbsorbPointer(
            absorbing: locked,
            child: Opacity(
              opacity: locked ? 0.3 : 1,
              child: _blocks[index].build(context, index),
            ),
          );
        },
      ),
    );
  }

  bool _isLevelCompleted(List<LessonModel> lessons) {
    // Для уровня 0: достаточно просмотра всех видео уроков этого уровня
    // и сохранения профиля в блоке ProfileForm.
    if ((widget.levelNumber ?? -1) == 0) {
      for (var i = 0; i < lessons.length; i++) {
        final videoPage = 1 + i * 2;
        if (!_progress.watchedVideos.contains(videoPage)) {
          return false;
        }
      }
      return _profileSaved;
    }

    // Для остальных уровней: видео + квизы (если есть) по текущей логике
    for (var i = 0; i < lessons.length; i++) {
      final videoPage = 1 + i * 2; // первый блок каждого урока
      final quizPage = videoPage + 1;

      if (!_progress.watchedVideos.contains(videoPage)) {
        return false;
      }
      final hasQuiz = lessons[i].quizQuestions.isNotEmpty;
      if (hasQuiz && !_progress.passedQuizzes.contains(quizPage)) {
        return false;
      }
    }
    return true;
  }

  void _buildBlocks(List<LessonModel> lessons) {
    // Уровень 0: Intro → Видео(ы) → Профиль → Финальный блок
    if ((widget.levelNumber ?? -1) == 0) {
      _blocks = [
        _IntroBlock(
            levelId: widget.levelId,
            levelNumber: widget.levelNumber ?? widget.levelId),
        for (final lesson in lessons)
          _LessonBlock(lesson: lesson, onWatched: _videoWatched),
        _ProfileFormBlock(levelId: widget.levelId),
      ];
      return;
    }

    // Остальные уровни: Intro → (Видео → Квиз?)* → Артефакт
    _blocks = [
      _IntroBlock(
          levelId: widget.levelId,
          levelNumber: widget.levelNumber ?? widget.levelId),
      for (final lesson in lessons) ...[
        _LessonBlock(lesson: lesson, onWatched: _videoWatched),
        if (lesson.quizQuestions.isNotEmpty)
          _QuizBlock(lesson: lesson, onCorrect: _quizPassed),
      ],
      _ArtifactBlock(levelId: widget.levelId),
    ];
  }
}

// Artifact ----------------------------------------------------------
class _ArtifactBlock extends _PageBlock {
  final int levelId;
  _ArtifactBlock({required this.levelId});

  Future<Map<String, dynamic>?> _fetchArtifact() async {
    final rows = await Supabase.instance.client
        .from('levels')
        .select('artifact_title, artifact_description, artifact_url')
        .eq('id', levelId)
        .maybeSingle();
    if (rows == null) return null;
    return Map<String, dynamic>.from(rows as Map);
  }

  @override
  Widget build(BuildContext context, int index) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _fetchArtifact(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data?['artifact_url'] == null) {
          return const Center(child: Text('Артефакт отсутствует'));
        }

        final data = snapshot.data!;
        final title = (data['artifact_title'] as String?) ?? 'Артефакт';
        final description = (data['artifact_description'] as String?) ?? '';
        final relativePath = data['artifact_url'] as String;

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              if (description.isNotEmpty)
                Text(description, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () async {
                  final repo = ProviderScope.containerOf(context, listen: false)
                      .read(levelsRepositoryProvider);
                  final url = await repo.getArtifactSignedUrl(relativePath);
                  if (url != null && await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url),
                        mode: LaunchMode.externalApplication);
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Не удалось открыть артефакт')));
                    }
                  }
                },
                icon: const Icon(Icons.download),
                label: const Text('Скачать'),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Abstract block ----------------------------------------------------
abstract class _PageBlock {
  Widget build(BuildContext context, int index);
}

// Profile form (First Step level only) ----------------------------------------
class _ProfileFormBlock extends _PageBlock {
  final int levelId;
  _ProfileFormBlock({required this.levelId});

  final _nameController = TextEditingController();
  final _aboutController = TextEditingController();
  final _goalController = TextEditingController();
  int _selectedAvatarId = 1;

  Future<void> _showAvatarPicker(BuildContext context) async {
    final selectedId = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.white,
      builder: (ctx) {
        return GridView.builder(
          padding: const EdgeInsets.all(AppSpacing.medium),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: AppSpacing.medium,
            crossAxisSpacing: AppSpacing.medium,
          ),
          itemCount: 7,
          itemBuilder: (_, index) {
            final id = index + 1;
            final asset = 'assets/images/avatars/avatar_${id}.png';
            final isSelected = id == _selectedAvatarId;
            return GestureDetector(
              onTap: () => Navigator.of(ctx).pop(id),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.asset(asset, fit: BoxFit.cover),
                  ),
                  if (isSelected)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.primary, width: 3),
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );

    if (selectedId != null) {
      _selectedAvatarId = selectedId;
    }
  }

  @override
  Widget build(BuildContext context, int index) {
    return Consumer(builder: (context, ref, _) {
      Future<void> save() async {
        final svc = ref.read(authServiceProvider);
        final sessionUser = svc.getCurrentUser();
        if (sessionUser?.email == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Подтвердите e-mail, прежде чем продолжить')),
          );
          return;
        }

        final name = _nameController.text.trim();
        final about = _aboutController.text.trim();
        final goal = _goalController.text.trim();
        if (name.isEmpty || about.isEmpty || goal.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Пожалуйста, заполните все поля')),
          );
          return;
        }

        try {
          await ref.read(authServiceProvider).updateProfile(
                name: name,
                about: about,
                goal: goal,
                avatarId: _selectedAvatarId,
              );
          // onSaved будет вызван кнопкой ниже, с передачей целевого индекса
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Профиль сохранён')),
            );
          }
        } on AuthFailure catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.message)),
            );
          }
        } catch (_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ошибка сохранения профиля')),
            );
          }
        }
      }

      return LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _showAvatarPicker(context),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        'assets/images/avatars/avatar_$_selectedAvatarId.png',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: AppColor.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Как к вам обращаться?',
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 8),
              CustomTextBox(
                hint: 'Имя',
                controller: _nameController,
                prefix: const Icon(Icons.person_outline),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Кратко о себе'),
              ),
              const SizedBox(height: 8),
              CustomTextBox(
                hint: 'О себе',
                controller: _aboutController,
                prefix: const Icon(Icons.info_outline),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Ваша цель обучения'),
              ),
              const SizedBox(height: 8),
              CustomTextBox(
                hint: 'Цель',
                controller: _goalController,
                prefix: const Icon(Icons.flag_outlined),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary),
                  onPressed: () async {
                    await save();
                    try {
                      await SupabaseService.completeLevel(levelId);
                      ref.invalidate(levelsProvider);
                      ref.invalidate(currentUserProvider);
                      ref.invalidate(userSkillsProvider);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Первый шаг завершён!')),
                        );
                        Navigator.of(context).pop();
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Ошибка: $e')),
                        );
                      }
                    }
                  },
                  child: const Text('Перейти на Уровень 1'),
                ),
              ),
            ],
          ),
        );
      });
    });
  }
}

// Дополнительные блоки уровня 0 больше не используются

// Intro -------------------------------------------------------------
class _IntroBlock extends _PageBlock {
  final int levelId;
  final int levelNumber;
  _IntroBlock({required this.levelId, required this.levelNumber});
  @override
  Widget build(BuildContext context, int index) {
    final bool isFirstStep = levelNumber == 0;
    final String title = isFirstStep ? 'Первый шаг' : 'Уровень $levelNumber';
    final String description = isFirstStep
        ? 'Привет! 👋\nЯ Leo, ваш персональный AI-ментор по бизнесу.\nЗа следующие пару минут Вы:\n- Узнаете, как получить максимум от BizLevel\n- Настроите свой профиль, чтобы я мог давать Вам персонализированные советы и рекомендации.\nГотовы начать свой путь в бизнесе?'
        : 'Проходите уроки по порядку и выполняйте тесты, чтобы продвигаться дальше.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(description, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// Lesson ------------------------------------------------------------
class _LessonBlock extends _PageBlock {
  final LessonModel lesson;
  final void Function(int) onWatched;
  _LessonBlock({required this.lesson, required this.onWatched});
  @override
  Widget build(BuildContext context, int index) {
    return LessonWidget(
      lesson: lesson,
      onWatched: () => onWatched(index),
    );
  }
}

// Quiz --------------------------------------------------------------
class _QuizBlock extends _PageBlock {
  final LessonModel lesson;
  final void Function(int) onCorrect;
  _QuizBlock({required this.lesson, required this.onCorrect});
  @override
  Widget build(BuildContext context, int index) {
    return Consumer(builder: (context, ref, _) {
      final progress = ref.watch(lessonProgressProvider(lesson.levelId));
      final alreadyPassed = progress.passedQuizzes.contains(index);
      if (lesson.quizQuestions.isEmpty) {
        return const Center(child: Text('Тест отсутствует для этого урока'));
      }
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Center(
          child: QuizWidget(
            questionData: {
              'question': lesson.quizQuestions.first['question'],
              'options':
                  List<String>.from(lesson.quizQuestions.first['options']),
              'correct': lesson.correctAnswers.first,
            },
            initiallyPassed: alreadyPassed,
            onCorrect: () => onCorrect(index),
          ),
        ),
      );
    });
  }
}

// Progress dots -----------------------------------------------------
class _ProgressDots extends StatelessWidget {
  final int current;
  final int total;
  final bool vertical;
  const _ProgressDots(
      {required this.current, required this.total, this.vertical = false});
  @override
  Widget build(BuildContext context) {
    final dots = List.generate(
      total,
      (i) => Container(
        margin: const EdgeInsets.all(4),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: i <= current ? AppColor.primary : Colors.grey.shade300,
          shape: BoxShape.circle,
        ),
      ),
    );

    return vertical
        ? Column(mainAxisSize: MainAxisSize.min, children: dots)
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: dots,
            ),
          );
  }
}

// Navigation bar ----------------------------------------------------
class _NavBar extends StatelessWidget {
  final bool canBack;
  final bool canNext;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onDiscuss;
  final bool showDiscuss;
  const _NavBar({
    required this.canBack,
    required this.canNext,
    required this.onBack,
    required this.onNext,
    required this.onDiscuss,
    this.showDiscuss = true,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: canBack ? onBack : null,
            style: ElevatedButton.styleFrom(backgroundColor: AppColor.primary),
            child: const Text('Назад'),
          ),
          if (showDiscuss)
            ElevatedButton(
              onPressed: onDiscuss,
              style:
                  ElevatedButton.styleFrom(backgroundColor: AppColor.primary),
              child: const Text('Обсудить с Лео',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ElevatedButton(
            onPressed: canNext ? onNext : null,
            style: ElevatedButton.styleFrom(backgroundColor: AppColor.primary),
            child: const Text('Далее'),
          ),
        ],
      ),
    );
  }
}
