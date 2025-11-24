import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bizlevel/models/lesson_model.dart';
import 'package:bizlevel/providers/lessons_provider.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart' as sentry;
import 'package:bizlevel/providers/lesson_progress_provider.dart';
import 'package:bizlevel/widgets/lesson_widget.dart';
import 'package:bizlevel/screens/leo_dialog_screen.dart';
// import 'package:bizlevel/widgets/quiz_widget.dart';
import 'package:bizlevel/widgets/leo_quiz_widget.dart';
import 'package:bizlevel/widgets/quiz_widget.dart';
import 'package:bizlevel/utils/constant.dart';
import 'package:bizlevel/widgets/artifact_viewer.dart';
import 'package:bizlevel/providers/levels_provider.dart';
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/widgets/common/bizlevel_text_field.dart';
import 'package:bizlevel/services/auth_service.dart';
import 'package:bizlevel/providers/user_skills_provider.dart';
// import 'package:bizlevel/providers/goals_repository_provider.dart';
// import 'package:bizlevel/providers/goals_providers.dart';
import 'package:go_router/go_router.dart';
import 'package:bizlevel/widgets/common/breadcrumb.dart';
import 'package:bizlevel/widgets/common/bizlevel_button.dart';
import 'package:bizlevel/theme/ui_strings.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/widgets/common/milestone_celebration.dart';
import 'package:bizlevel/providers/gp_providers.dart';
import 'package:bizlevel/widgets/common/bizlevel_card.dart';
import 'package:bizlevel/theme/typography.dart';

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

  // Флаг сохранения v1 «Семя» (для уровня 1)
  bool _goalV1Saved = false;

  // --- Состояние формы профиля уровня 0 (поднято из блока для сохранения ввода) ---
  final TextEditingController _profileNameCtrl = TextEditingController();
  final TextEditingController _profileAboutCtrl = TextEditingController();
  final TextEditingController _profileGoalCtrl = TextEditingController();
  int _profileAvatarId = 1;
  bool _isProfileEditing = true; // после сохранения переключим в read-only
  bool _profileInitialized =
      false; // чтобы не переписывать контроллеры на каждом билде

  // Leo chat (создаётся при первом сообщении пользователя)
  String? _chatId;

  @override
  void initState() {
    super.initState();
    // Берём последнюю разблокированную страницу, чтобы открывать уровень там, где пользователь остановился.
    _pageController = PageController();
    // Гарантируем разблокировку Intro (0) и следующей страницы (1)
    _progressNotifier.unlockPage(1);
    // Listen for page changes to rebuild so that chat bubble visibility updates
    _pageController.addListener(() {
      if (mounted) setState(() {});
    });
    
    // Инициализируем флаг _goalV1Saved для уровня 1
    if ((widget.levelNumber ?? -1) == 1) {
      _initializeGoalV1Flag();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _profileNameCtrl.dispose();
    _profileAboutCtrl.dispose();
    _profileGoalCtrl.dispose();
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

          // Одноразовый префилл формы профиля из текущего пользователя
          if (isLevelZero && !_profileInitialized) {
            final user = ref.watch(currentUserProvider).value;
            if (user != null) {
              _profileNameCtrl.text = user.name;
              _profileAboutCtrl.text = (user.about ?? '');
              _profileGoalCtrl.text = (user.goal ?? '');
              _profileAvatarId = (user.avatarId ?? 1);
              // Если профиль уже заполнен – открываем в режиме просмотра
              _isProfileEditing = user.name.isEmpty ||
                      (user.about ?? '').isEmpty ||
                      (user.goal ?? '').isEmpty
                  ? true
                  : false;
              _profileInitialized = true;
            }
          }

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
                        backgroundColor: AppColor.surface,
                        barrierColor: Colors.black.withValues(alpha: 0.54),
                        builder: (_) => FractionallySizedBox(
                          heightFactor: 0.9,
                          child: LeoDialogScreen(chatId: _chatId),
                        ),
                      );
                    },
                  ),
                // Нижний блок с кнопкой в SafeArea: учёт клавиатуры/индикаторов
                const SizedBox(height: 6),
                if ((widget.levelNumber ?? -1) != 0)
                  BizLevelButton(
                    label: (widget.levelNumber ?? -1) == 1
                        ? 'Перейти к Цели'
                        : 'Завершить уровень',
                    icon: const Icon(Icons.check, size: 20),
                    // тёплый вариант CTA
                    backgroundColorOverride: const Color(0xFFF59E0B),
                    foregroundColorOverride: Colors.white,
                    onPressed: _isLevelCompleted(lessons)
                        ? () async {
                            try {
                              // breadcrumb: попытка завершения уровня
                              try {
                                sentry.Sentry.addBreadcrumb(sentry.Breadcrumb(
                                  category: 'level',
                                  level: sentry.SentryLevel.info,
                                  message: 'level_complete_attempt',
                                  data: {
                                    'levelId': widget.levelId,
                                    'levelNumber': widget.levelNumber
                                  },
                                ));
                              } catch (_) {}
                              await SupabaseService.completeLevel(
                                  widget.levelId);
                              // Обновляем карту уровней
                              ref.invalidate(levelsProvider);
                              ref.invalidate(currentUserProvider);
                              // Инвалидация навыков для обновления древа навыков в профиле
                              ref.invalidate(userSkillsProvider);
                              try {
                                sentry.Sentry.addBreadcrumb(sentry.Breadcrumb(
                                  category: 'level',
                                  level: sentry.SentryLevel.info,
                                  message: 'level_completed',
                                  data: {
                                    'levelId': widget.levelId,
                                    'levelNumber': widget.levelNumber
                                  },
                                ));
                              } catch (_) {}
                              if (context.mounted) {
                                // Праздничное уведомление о бонусе за уровень (+20 GP)
                                await showDialog(
                                  context: context,
                                  builder: (_) => Dialog(
                                    backgroundColor: Colors.transparent,
                                    insetPadding: const EdgeInsets.all(16),
                                    child: MilestoneCelebration(
                                        gpGain: 20,
                                        onClose: () =>
                                            Navigator.of(context).maybePop()),
                                  ),
                                );
                                // Обновим баланс GP (SWR провайдер)
                                ref.invalidate(gpBalanceProvider);
                                if ((widget.levelNumber ?? -1) == 1) {
                                  if (context.mounted) {
                                    context.go('/goal');
                                  }
                                } else {
                                  if (!context.mounted) return;
                                  Navigator.of(context).pop();
                                }
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
                  ),
              ],
            ),
          );

          // Wrap with Stack to overlay chat bubble
          final stack = Stack(
            children: [
              mainContent,
              // Тонкая полоса прогресса уроков вверху
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  bottom: false,
                  child: LinearProgressIndicator(
                    value: (_currentIndex + 1) / (_blocks.length),
                    minHeight: 3,
                    backgroundColor: Colors.black.withValues(alpha: 0.06),
                    valueColor: const AlwaysStoppedAnimation(AppColor.primary),
                  ),
                ),
              ),
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

  Future<bool> _isGoalV1AlreadySaved() async {
    final prefs = await SharedPreferences.getInstance();
    final user = ref.read(currentUserProvider).value;
    final key = 'goal_v1_saved_${user?.id ?? 'anonymous'}_${widget.levelId}';
    return prefs.getBool(key) ?? false;
  }

  Future<void> _markGoalV1AsSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final user = ref.read(currentUserProvider).value;
    final key = 'goal_v1_saved_${user?.id ?? 'anonymous'}_${widget.levelId}';
    await prefs.setBool(key, true);
  }

  Future<void> _initializeGoalV1Flag() async {
    final isSaved = await _isGoalV1AlreadySaved();
    if (mounted) {
      setState(() {
        _goalV1Saved = isSaved;
      });
    }
  }

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
    // Для уровня 1 требуется также заполнение v1 «Семя»
    if ((widget.levelNumber ?? -1) == 1) {
      // Проверяем только локальный флаг, так как асинхронная проверка не подходит для синхронного метода
      return _goalV1Saved;
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
        _ProfileFormBlock(
          levelId: widget.levelId,
          nameController: _profileNameCtrl,
          aboutController: _profileAboutCtrl,
          goalController: _profileGoalCtrl,
          selectedAvatarId: _profileAvatarId,
          isEditing: _isProfileEditing,
          onAvatarChanged: (id) => setState(() => _profileAvatarId = id),
          onEdit: () => setState(() => _isProfileEditing = true),
          onSaved: () => setState(() {
            _isProfileEditing = false;
            _profileSaved = true;
          }),
        ),
      ];
      return;
    }

    // Уровень 1: Intro → (Видео → Квиз?)* → Семя (v1)
    if ((widget.levelNumber ?? -1) == 1) {
      _blocks = [
        _IntroBlock(
            levelId: widget.levelId,
            levelNumber: widget.levelNumber ?? widget.levelId),
        for (final lesson in lessons) ...[
          _LessonBlock(lesson: lesson, onWatched: _videoWatched),
          if (lesson.quizQuestions.isNotEmpty)
            _QuizBlock(
              lesson: lesson,
              onCorrect: _quizPassed,
              levelNumber: widget.levelNumber ?? widget.levelId,
            ),
        ],
        _GoalV1Block(
          onSaved: () async {
            if (mounted) {
              setState(() => _goalV1Saved = true);
              await _markGoalV1AsSaved();
              // Инвалидация провайдеров целей для синхронизации страницы «Цель»
              // legacy invalidates removed
            }
          },
        ),
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
          _QuizBlock(
            lesson: lesson,
            onCorrect: _quizPassed,
            levelNumber: widget.levelNumber ?? widget.levelId,
          ),
      ],
      _ArtifactBlock(levelId: widget.levelId, levelNumber: widget.levelNumber),
    ];
  }
}

// Artifact ----------------------------------------------------------
class _ArtifactBlock extends _PageBlock {
  final int levelId;
  final int? levelNumber;
  _ArtifactBlock({required this.levelId, this.levelNumber});

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

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              if (description.isNotEmpty)
                Text(description, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              _ArtifactPreview(levelId: levelId, levelNumber: levelNumber),
            ],
          ),
        );
      },
    );
  }
}

class _ArtifactPreview extends StatelessWidget {
  const _ArtifactPreview({required this.levelId, this.levelNumber});
  final int levelId;
  final int? levelNumber;

  @override
  Widget build(BuildContext context) {
    Widget buildCard(int ln) {
      if (ln < 1 || ln > 10) return const SizedBox.shrink();
      final front = 'assets/images/artefacts/art-$ln-1.png';
      final back = 'assets/images/artefacts/art-$ln-2.png';
      return LayoutBuilder(builder: (context, constraints) {
        final double maxW = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;
        final double cardWidth = (maxW * 0.55).clamp(0, 220);
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false,
                barrierColor: Colors.black.withValues(alpha: 0.85),
                pageBuilder: (ctx, _, __) => ArtifactViewer(
                  front: front,
                  back: back,
                ),
              ),
            );
          },
          child: Align(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: cardWidth,
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(front, fit: BoxFit.cover),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.touch_app,
                                  color: Colors.white, size: 14),
                              SizedBox(width: 4),
                              Text('Тапните',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
    }

    if (levelNumber != null) {
      return buildCard(levelNumber!);
    }

    return FutureBuilder<int>(
      future: SupabaseService.levelNumberFromId(levelId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        return buildCard(snapshot.data ?? 0);
      },
    );
  }
}

// Abstract block ----------------------------------------------------
abstract class _PageBlock {
  Widget build(BuildContext context, int index);
}

// Goal v1 (Draft) block for Level 1 ------------------------------------------
class _GoalV1Block extends _PageBlock {
  final VoidCallback onSaved;
  _GoalV1Block({required this.onSaved});

  // bool _isValid(String v) => v.trim().length >= 10;

  @override
  Widget build(BuildContext context, int index) {
    final TextEditingController goalInitialCtrl = TextEditingController();
    final TextEditingController goalWhyCtrl = TextEditingController();
    final TextEditingController mainObstacleCtrl = TextEditingController();

    return Consumer(builder: (context, ref, _) {
      // legacy versions provider removed
      const versionsAsync =
          AsyncValue<List<Map<String, dynamic>>>.data(<Map<String, dynamic>>[]);
      return versionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, __) => Center(child: Text('Ошибка загрузки цели: $e')),
        data: (all) {
          final byVersion = {
            for (final m in all)
              m['version'] as int: Map<String, dynamic>.from(m)
          };
          final v1 = byVersion[1]?['version_data'];
          if (v1 is Map) {
            final data = Map<String, dynamic>.from(v1);
            goalInitialCtrl.text = (data['goal_initial'] ?? '') as String;
            goalWhyCtrl.text = (data['goal_why'] ?? '') as String;
            mainObstacleCtrl.text = (data['main_obstacle'] ?? '') as String;
          }

          // legacy save() удалён — вместо формы показываем CTA

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BizLevelCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Куда дальше?',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Сформулируйте цель и начните дневник применений на странице «Цель». Это поможет Максу давать точные рекомендации.',
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: BizLevelButton(
                          label: 'Открыть страницу «Цель»',
                          onPressed: () {
                            GoRouter.of(context).push('/goal');
                            onSaved();
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 24),
                      Text(
                        'Артефакт: Ядро целей',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Откройте артефакт «Ядро целей», чтобы пошагово сформулировать первую цель. Это поможет Максу давать точные рекомендации.',
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              GoRouter.of(context).push('/artifacts'),
                          icon: const Icon(Icons.auto_stories_outlined),
                          label: const Text('Открыть артефакт'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}

// Profile form (First Step level only) ----------------------------------------
class _ProfileFormBlock extends _PageBlock {
  final int levelId;
  final TextEditingController nameController;
  final TextEditingController aboutController;
  final TextEditingController goalController;
  final int selectedAvatarId;
  final bool isEditing;
  final VoidCallback onEdit;
  final VoidCallback onSaved;
  final void Function(int) onAvatarChanged;

  _ProfileFormBlock({
    required this.levelId,
    required this.nameController,
    required this.aboutController,
    required this.goalController,
    required this.selectedAvatarId,
    required this.isEditing,
    required this.onEdit,
    required this.onSaved,
    required this.onAvatarChanged,
  });

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
          itemCount: 12,
          itemBuilder: (_, index) {
            final id = index + 1;
            final asset = 'assets/images/avatars/avatar_$id.png';
            final isSelected = id == selectedAvatarId;
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
      onAvatarChanged(selectedId);
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
            const SnackBar(content: Text(UIS.confirmEmailFirst)),
          );
          return;
        }

        final name = nameController.text.trim();
        final about = aboutController.text.trim();
        final goal = goalController.text.trim();
        if (name.isEmpty || about.isEmpty || goal.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(UIS.pleaseFillAllFields)),
          );
          return;
        }

        try {
          await ref.read(authServiceProvider).updateProfile(
                name: name,
                about: about,
                goal: goal,
                avatarId: selectedAvatarId,
                onboardingCompleted: true,
              );
          // onSaved будет вызван кнопкой ниже, с передачей целевого индекса
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(UIS.profileSaved)),
            );
          }
          onSaved();
        } on AuthFailure catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.message)),
            );
          }
        } catch (_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(UIS.saveErrorGeneric)),
            );
          }
        }
      }

      return LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              // Верхняя панель с иконкой «Редактировать» (показываем, если не в режиме редактирования)
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.edit, color: AppColor.onSurfaceSubtle),
                  onPressed: isEditing ? null : onEdit,
                  tooltip: 'Редактировать',
                ),
              ),
              GestureDetector(
                onTap: () => _showAvatarPicker(context),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        'assets/images/avatars/avatar_$selectedAvatarId.png',
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
                          color: AppColor.surface,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColor.shadow,
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
              BizLevelTextField(
                label: 'Как к вам обращаться?',
                hint: 'Имя',
                controller: nameController,
                readOnly: !isEditing,
                prefix: const Icon(Icons.person_outline),
              ),
              const SizedBox(height: 16),
              BizLevelTextField(
                label: 'Кратко о себе',
                hint: 'О себе',
                controller: aboutController,
                readOnly: !isEditing,
                prefix: const Icon(Icons.info_outline),
              ),
              const SizedBox(height: 16),
              BizLevelTextField(
                label: 'Ваша цель обучения',
                hint: 'Цель',
                controller: goalController,
                readOnly: !isEditing,
                prefix: const Icon(Icons.flag_outlined),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: BizLevelButton(
                  label: 'Перейти на Уровень 1',
                  onPressed: () async {
                    await save();
                    if (!context.mounted) return;
                    try {
                      await SupabaseService.completeLevel(levelId);
                      if (!context.mounted) return;
                      ref.invalidate(levelsProvider);
                      ref.invalidate(currentUserProvider);
                      ref.invalidate(userSkillsProvider);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text(UIS.firstStepDone)),
                      );
                      // Надёжная навигация: в башню к Уровню 1
                      GoRouter.of(context).go('/tower?scrollTo=1');
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ошибка: $e')),
                      );
                    }
                  },
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

    return Padding(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(builder: (context, constraints) {
        final String assetPath = 'assets/images/lvls/level_$levelNumber.png';
        final double imageHeight = constraints.maxHeight * 0.45;
        return Stack(
          children: [
            // Хлебные крошки
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Breadcrumb(
                    items: [
                      BreadcrumbItem(
                        label: 'Главная',
                        onTap: () => context.go('/home'),
                      ),
                      BreadcrumbItem(
                        label: 'Башня',
                        onTap: () => context.go('/tower?scrollTo=$levelNumber'),
                      ),
                      BreadcrumbItem(
                        label: 'Уровень $levelNumber',
                        isCurrent: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Кнопка «Назад к башне» в левом верхнем углу
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  tooltip: 'К башне',
                  onPressed: () {
                    try {
                      if (levelNumber > 0) {
                        GoRouter.of(context).go('/tower?scrollTo=$levelNumber');
                      } else {
                        GoRouter.of(context).go('/tower');
                      }
                    } catch (_) {}
                  },
                ),
              ),
            ),

            // Основной контент по центру
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Картинка уровня (для уровня 0 изображения может не быть)
                    if (!isFirstStep)
                      _ParallaxImage(
                        assetPath: assetPath,
                        height: imageHeight.clamp(160, 360),
                      ),
                    if (!isFirstStep) const SizedBox(height: 16),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineLarge ??
                          AppTypography.textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        description,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
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

class _ParallaxImage extends StatelessWidget {
  final String assetPath;
  final double height;
  const _ParallaxImage({required this.assetPath, required this.height});

  bool _isLowEnd(BuildContext context) {
    final mq = MediaQuery.of(context);
    final disableAnimations = View.of(context)
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;
    return mq.devicePixelRatio < 2.0 || disableAnimations;
  }

  @override
  Widget build(BuildContext context) {
    final lowEnd = _isLowEnd(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: NotificationListener<ScrollNotification>(
          onNotification: (_) => false,
          child: LayoutBuilder(builder: (context, c) {
            // Параллакс: малая амплитуда по вертикали
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 1),
              builder: (context, v, child) {
                final dy = lowEnd ? 0.0 : 6.0; // амплитуда
                return Transform.translate(
                  offset: Offset(0, -dy),
                  child: child,
                );
              },
              child: Image.asset(
                assetPath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) =>
                    const SizedBox.shrink(),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// Quiz --------------------------------------------------------------
class _QuizBlock extends _PageBlock {
  final LessonModel lesson;
  final void Function(int) onCorrect;
  final int? levelNumber;
  _QuizBlock({required this.lesson, required this.onCorrect, this.levelNumber});
  @override
  Widget build(BuildContext context, int index) {
    return Consumer(builder: (context, ref, _) {
      final progress = ref.watch(lessonProgressProvider(lesson.levelId));
      final alreadyPassed = progress.passedQuizzes.contains(index);
      if (lesson.quizQuestions.isEmpty) {
        return const Center(child: Text('Тест отсутствует для этого урока'));
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Center(
          child: Builder(builder: (context) {
            final user = ref.watch(currentUserProvider).value;
            final parts = <String>[];
            if (user != null) {
              if (user.name.isNotEmpty) parts.add('Имя: ${user.name}');
              if ((user.goal ?? '').isNotEmpty) parts.add('Цель: ${user.goal}');
              if ((user.about ?? '').isNotEmpty) {
                parts.add('О себе: ${user.about}');
              }
            }
            final userCtx = parts.isEmpty ? null : parts.join('. ');
            if (kUseLeoQuiz) {
              return LeoQuizWidget(
                questionData: {
                  'question': lesson.quizQuestions.first['question'],
                  'options':
                      List<String>.from(lesson.quizQuestions.first['options']),
                  'correct': lesson.correctAnswers.first,
                  'script': lesson.quizQuestions.first['script'],
                  'explanation': lesson.quizQuestions.first['explanation'],
                },
                initiallyPassed: alreadyPassed,
                onCorrect: () => onCorrect(index),
                userContext: userCtx,
                levelNumber: levelNumber ?? lesson.levelId,
                questionIndex: lesson.order,
              );
            } else {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: QuizWidget(
                  questionData: {
                    'question': lesson.quizQuestions.first['question'],
                    'options': List<String>.from(
                        lesson.quizQuestions.first['options']),
                    'correct': lesson.correctAnswers.first,
                  },
                  initiallyPassed: alreadyPassed,
                  onCorrect: () => onCorrect(index),
                ),
              );
            }
          }),
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
          BizLevelButton(
            label: 'Назад',
            onPressed: canBack ? onBack : null,
          ),
          if (showDiscuss)
            BizLevelButton(
              label: 'Обсудить с Лео',
              onPressed: onDiscuss,
            ),
          BizLevelButton(
            label: 'Далее',
            onPressed: canNext ? onNext : null,
          ),
        ],
      ),
    );
  }
}
