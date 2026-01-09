import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/models/lesson_model.dart';
import 'package:bizlevel/providers/lessons_provider.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/services/supabase_service.dart';
import 'package:sentry_flutter/sentry_flutter.dart' as sentry;
import 'package:bizlevel/providers/lesson_progress_provider.dart';
import 'package:bizlevel/screens/leo_dialog_screen.dart';
import 'package:bizlevel/providers/levels_provider.dart';
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/providers/user_skills_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:bizlevel/widgets/common/bizlevel_button.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/widgets/common/milestone_celebration.dart';
import 'package:bizlevel/providers/gp_providers.dart';
import 'package:bizlevel/widgets/level/level_nav_bar.dart';
import 'package:bizlevel/widgets/level/level_progress_dots.dart';
import 'package:bizlevel/utils/level_page_index.dart';
import 'package:bizlevel/widgets/level/blocks/level_page_block.dart';
import 'package:bizlevel/widgets/level/blocks/intro_block.dart';
import 'package:bizlevel/widgets/level/blocks/lesson_block.dart';
import 'package:bizlevel/widgets/level/blocks/quiz_block.dart';
import 'package:bizlevel/widgets/level/blocks/goal_v1_block.dart';
import 'package:bizlevel/widgets/level/blocks/artifact_block.dart';
import 'package:bizlevel/widgets/level/blocks/profile_form_block.dart';
import 'package:bizlevel/screens/ray_dialog_screen.dart';

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

  late List<LevelPageBlock> _blocks;
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

  // Защита от "вылета в Башню" при фокусе TextField внутри уровня:
  // когда открыт чат bottom-sheet или когда видна клавиатура,
  // блокируем pop уровня (иначе /levels может закрыться и вернёмся на /tower).
  bool _leoSheetOpen = false;

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
  }

  bool _shouldBlockLevelPop(BuildContext context) {
    // Если чат-шторка открыта — точно не должны закрывать уровень по pop.
    if (_leoSheetOpen) return true;
    // Если клавиатура видна, безопаснее сначала убрать фокус/клавиатуру, а не закрывать экран.
    final kb = MediaQuery.of(context).viewInsets.bottom;
    return kb > 0;
  }

  Future<void> _openLeoChatSheet() async {
    if (_leoSheetOpen) return;
    // Закрываем любой фокус до открытия — снижает вероятность конфликтов клавиатуры/route pop.
    try {
      FocusManager.instance.primaryFocus?.unfocus();
    } catch (_) {}

    if (!mounted) return;
    setState(() => _leoSheetOpen = true);
    try {
      try {
        sentry.Sentry.addBreadcrumb(sentry.Breadcrumb(
          category: 'nav',
          level: sentry.SentryLevel.info,
          message: 'level_leo_sheet_open',
          data: {'levelId': widget.levelId, 'levelNumber': widget.levelNumber},
        ));
      } catch (_) {}

      // Важно: показываем bottom-sheet на root navigator.
      // Иначе он живёт в shell navigator рядом с /levels и при баге может "попнуть" сам уровень.
      await showModalBottomSheet<void>(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        // Лечим "случайные" dismiss/drag, которые на отдельных устройствах могут приводить
        // к цепочке pop и возврату на /tower.
        isDismissible: false,
        enableDrag: false,
        backgroundColor: AppColor.surface,
        barrierColor: Colors.black.withValues(alpha: 0.54),
        builder: (ctx) {
          final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
          return AnimatedPadding(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(bottom: bottomInset),
            child: FractionallySizedBox(
              heightFactor: 0.92,
              child: Column(
                children: [
                  SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 16,
                            backgroundImage: AssetImage(
                              'assets/images/avatars/avatar_leo.png',
                            ),
                            backgroundColor: Colors.transparent,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Лео',
                            style: Theme.of(ctx)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          IconButton(
                            tooltip: 'Закрыть',
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              try {
                                FocusManager.instance.primaryFocus?.unfocus();
                              } catch (_) {}
                              Navigator.of(ctx).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    // embedded=true: не вкладываем ещё один Scaffold/PopScope внутрь sheet.
                    child: LeoDialogScreen(
                      chatId: _chatId,
                      bot: 'leo',
                      embedded: true,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e, st) {
      try {
        await sentry.Sentry.captureException(e, stackTrace: st);
      } catch (_) {}
    } finally {
      if (mounted) {
        setState(() => _leoSheetOpen = false);
      }
      try {
        sentry.Sentry.addBreadcrumb(sentry.Breadcrumb(
          category: 'nav',
          level: sentry.SentryLevel.info,
          message: 'level_leo_sheet_closed',
          data: {'levelId': widget.levelId, 'levelNumber': widget.levelNumber},
        ));
      } catch (_) {}
    }
  }

  Widget _buildMainColumn(BuildContext context, List<LessonModel> lessons,
      bool isLevelZero, bool isProfilePage) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(child: _buildPageView()),
          if (!isProfilePage)
            LevelNavBar(
              showDiscuss: !isLevelZero,
              canBack: (_pageController.hasClients
                  ? (_pageController.page ??
                          _pageController.initialPage.toDouble()) >
                      0
                  : false),
              canNext: _currentIndex < _progress.unlockedPage ||
                  _currentIndex + 1 == _progress.unlockedPage,
              onBack: _goBack,
              onNext: _goNext,
              onDiscuss: () {
                _openLeoChatSheet();
              },
            ),
          AppSpacing.gapH(AppSpacing.s6),
          if ((widget.levelNumber ?? -1) != 0)
            BizLevelButton(
              label: (widget.levelNumber ?? -1) == 1
                  ? 'Перейти к Цели'
                  : 'Завершить уровень',
              icon: const Icon(Icons.check, size: 20),
              backgroundColorOverride: AppColor.warning,
              foregroundColorOverride: AppColor.onPrimary,
              onPressed: _isLevelCompleted(lessons)
                  ? () async {
                      try {
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
                        await SupabaseService.completeLevel(widget.levelId);
                        ref.invalidate(levelsProvider);
                        ref.invalidate(currentUserProvider);
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
                          await showDialog(
                            context: context,
                            builder: (_) => Dialog(
                              backgroundColor: Colors.transparent,
                              insetPadding: AppSpacing.insetsAll(AppSpacing.lg),
                              child: MilestoneCelebration(
                                  gpGain: 20,
                                  onClose: () =>
                                      Navigator.of(context).maybePop()),
                            ),
                          );
                          ref.invalidate(gpBalanceProvider);

                          // Предложение проверить идею после завершения Уровня 5 (Ray)
                          final isLevel5 = (widget.levelNumber ?? -1) == 5;
                          if (isLevel5 && context.mounted) {
                            final shouldOpenRay =
                                await showDialog<bool>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (dialogCtx) => AlertDialog(
                                        title: const Text('Проверь свою идею'),
                                        content: const Text(
                                          'Ты прошёл Уровень 5. Готов проверить свою бизнес‑идею с Ray?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(dialogCtx).pop(false);
                                            },
                                            child: const Text('Позже'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(dialogCtx).pop(true);
                                            },
                                            child: const Text('Проверить идею'),
                                          ),
                                        ],
                                      ),
                                    ) ??
                                    false;

                            if (shouldOpenRay && context.mounted) {
                              try {
                                sentry.Sentry.addBreadcrumb(
                                  sentry.Breadcrumb(
                                    category: 'ui.tap',
                                    message: 'level_5_cta_tap:ray',
                                    level: sentry.SentryLevel.info,
                                  ),
                                );
                              } catch (_) {}

                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const RayDialogScreen(),
                                ),
                              );
                            }
                          }

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
  }

  Widget _buildOverlays(BuildContext context, Widget mainContent) {
    return Stack(
      children: [
        mainContent,
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
        Positioned(
          top: MediaQuery.of(context).size.height * 0.3,
          right: 8,
          child: LevelProgressDots(
            current: _currentIndex,
            total: _blocks.length,
            vertical: true,
          ),
        ),
      ],
    );
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

    return PopScope(
      canPop: !_shouldBlockLevelPop(context),
      onPopInvokedWithResult: (didPop, result) {
        // Если pop был заблокирован — аккуратно закрываем клавиатуру/фокус.
        if (!didPop) {
          try {
            FocusManager.instance.primaryFocus?.unfocus();
          } catch (_) {}
        }
      },
      child: Scaffold(
        body: lessonsAsync.when(
          data: (lessons) {
            _buildBlocks(lessons);

            final bool isLevelZero = (widget.levelNumber ?? -1) == 0;
            final bool isProfilePage =
                isLevelZero && _blocks[_currentIndex] is ProfileFormBlock;

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

            final mainContent =
                _buildMainColumn(context, lessons, isLevelZero, isProfilePage);
            final stack = _buildOverlays(context, mainContent);
            return stack;
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Ошибка: ${e.toString()}')),
        ),
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

  // --- Leo chat helpers (legacy prompt удалён)

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
        final videoPage = videoPageFor(i);
        if (!_progress.watchedVideos.contains(videoPage)) {
          return false;
        }
      }
      return _profileSaved;
    }

    // Для остальных уровней: видео + квизы (если есть) по текущей логике
    for (var i = 0; i < lessons.length; i++) {
      final videoPage = videoPageFor(i); // первый блок каждого урока
      final quizPage = quizPageFor(i);

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
      return _goalV1Saved;
    }
    return true;
  }

  void _buildBlocks(List<LessonModel> lessons) {
    // Уровень 0: Intro → Видео(ы) → Профиль → Финальный блок
    if ((widget.levelNumber ?? -1) == 0) {
      _blocks = [
        IntroBlock(
            levelId: widget.levelId,
            levelNumber: widget.levelNumber ?? widget.levelId),
        for (final lesson in lessons)
          LessonBlock(lesson: lesson, onWatched: _videoWatched),
        ProfileFormBlock(
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
        IntroBlock(
            levelId: widget.levelId,
            levelNumber: widget.levelNumber ?? widget.levelId),
        for (final lesson in lessons) ...[
          LessonBlock(lesson: lesson, onWatched: _videoWatched),
          if (lesson.quizQuestions.isNotEmpty)
            QuizBlock(
              lesson: lesson,
              onCorrect: _quizPassed,
              levelNumber: widget.levelNumber ?? widget.levelId,
            ),
        ],
        GoalV1Block(
          onSaved: () {
            if (mounted) {
              setState(() => _goalV1Saved = true);
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
      IntroBlock(
          levelId: widget.levelId,
          levelNumber: widget.levelNumber ?? widget.levelId),
      for (final lesson in lessons) ...[
        LessonBlock(lesson: lesson, onWatched: _videoWatched),
        if (lesson.quizQuestions.isNotEmpty)
          QuizBlock(
            lesson: lesson,
            onCorrect: _quizPassed,
            levelNumber: widget.levelNumber ?? widget.levelId,
          ),
      ],
      ArtifactBlock(levelId: widget.levelId, levelNumber: widget.levelNumber),
    ];
  }
}
