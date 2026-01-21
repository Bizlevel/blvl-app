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
import 'package:bizlevel/utils/custom_modal_route.dart';
import 'package:bizlevel/providers/goals_providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bizlevel/services/context_service.dart';

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

  bool _autoCompletingLevel = false;
  bool _autoCompletedLevel = false;

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

  bool _caseGateChecked = false;

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
    
    // Для уровня 1: проверка наличия цели будет выполнена в build через watch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeGuardCaseAccess();
    });
  }

  Future<void> _maybeGuardCaseAccess() async {
    if (_caseGateChecked || !mounted) return;
    _caseGateChecked = true;

    int levelNumber = widget.levelNumber ?? 0;
    if (levelNumber <= 0) {
      try {
        levelNumber = await SupabaseService.levelNumberFromId(widget.levelId);
      } catch (_) {
        return;
      }
    }
    if (levelNumber <= 0) return;

    final supa = Supabase.instance.client;
    final int afterLevel = levelNumber - 1;
    try {
      final caseRow = await supa
          .from('mini_cases')
          .select('id, title, is_required')
          .eq('active', true)
          .eq('after_level', afterLevel)
          .maybeSingle();
      if (caseRow == null) return;

      final bool isRequired = caseRow['is_required'] as bool? ?? true;
      if (!isRequired) return;

      final uid = supa.auth.currentUser?.id;
      if (uid == null || uid.isEmpty) return;

      final progress = await supa
          .from('user_case_progress')
          .select('status')
          .eq('user_id', uid)
          .eq('case_id', caseRow['id'])
          .maybeSingle();
      final status = (progress?['status'] as String?)?.toLowerCase();
      final bool done = status == 'completed' || status == 'skipped';
      if (done || !mounted) return;

      final String caseTitle =
          (caseRow['title'] as String?) ?? 'Мини‑кейс';
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: const Text('Сначала мини‑кейс'),
          content: Text(
            'Для открытия уровня $levelNumber нужно пройти мини‑кейс: $caseTitle.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                if (mounted) context.go('/tower?scrollTo=$levelNumber');
              },
              child: const Text('Вернуться в Башню'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                if (mounted) {
                  final caseId = caseRow['id'] as int;
                  context.go('/case/$caseId');
                }
              },
              child: const Text('Открыть кейс'),
            ),
          ],
        ),
      );
    } catch (_) {
      // Если не смогли проверить гейтинг, не блокируем доступ
    }
  }

  Future<String?> _buildUserContext() async {
    final user = ref.read(currentUserProvider).value;
    return ContextService.buildUserContext(user);
  }

  String _buildLevelContext() {
    final parts = <String>[];
    final levelNumber = widget.levelNumber;
    if (levelNumber != null && levelNumber > 0) {
      parts.add('level_number: $levelNumber');
    }
    parts.add('level_id: ${widget.levelId}');
    return parts.join(', ');
  }
  
  /// Проверяет наличие сохраненной цели v1 в БД и устанавливает флаг
  Future<void> _checkGoalV1Saved() async {
    try {
      // Используем ref.read чтобы не создавать подписку, только одноразовая проверка
      final goal = await ref.read(userGoalProvider.future);
      if (goal != null) {
        final goalText = (goal['goal_text'] as String? ?? '').trim();
        // Если цель сохранена (непустой goal_text), считаем что v1 сохранена
        if (goalText.isNotEmpty && mounted) {
          setState(() {
            _goalV1Saved = true;
          });
        }
      }
    } catch (_) {
      // Игнорируем ошибки при проверке - не критично
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
              onDiscuss: () async {
                // ВАЖНО: Получаем ProviderContainer из текущего контекста,
                // чтобы передать его в UncontrolledProviderScope для диалога
                // Это гарантирует, что провайдеры будут доступны даже если родитель умрет
                final container = ProviderScope.containerOf(context);
                final userContext = await _buildUserContext();
                final levelContext = _buildLevelContext();
                if (!mounted) return;
                
                final router = GoRouter.of(context);
                final origin =
                    router.routeInformationProvider.value.uri.toString();
                try {
                  sentry.Sentry.addBreadcrumb(
                    sentry.Breadcrumb(
                      category: 'chat',
                      level: sentry.SentryLevel.info,
                      message: 'leo_dialog_open_requested',
                      data: {'origin': origin},
                    ),
                  );
                } catch (_) {}
                
                final result = await Navigator.of(context, rootNavigator: true)
                    .push(
                  CustomModalBottomSheetRoute(
                    barrierDismissible: false,
                    child: UncontrolledProviderScope(
                      container: container,
                      child: Scaffold(
                        backgroundColor: Colors.transparent,
                        // ВАЖНО: resizeToAvoidBottomInset: true, чтобы Flutter поднимал контент при появлении клавиатуры
                        resizeToAvoidBottomInset: true,
                        body: Stack(
                          children: [
                            Positioned.fill(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    final navigator = Navigator.of(
                                      context,
                                      rootNavigator: true,
                                    );
                                    if (navigator.canPop()) {
                                      navigator.pop();
                                    }
                                  },
                                  child: Container(color: Colors.transparent),
                                ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Material(
                                color: Colors.transparent,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight: MediaQuery.of(context).size.height * 0.9,
                                  ),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: AppColor.surface,
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                  child: Column(
                                    children: [
                                      Container(
                                        color: AppColor.primary,
                                        child: SafeArea(
                                          bottom: false,
                                          child: AppBar(
                                            backgroundColor: AppColor.primary,
                                            automaticallyImplyLeading: false,
                                            leading: Builder(
                                              builder: (context) => IconButton(
                                                tooltip: 'Закрыть',
                                                icon: const Icon(Icons.close),
                                                onPressed: () {
                                                  // Скрываем клавиатуру перед закрытием диалога
                                                  FocusManager.instance.primaryFocus?.unfocus();
                                                  final navigator = Navigator.of(
                                                    context,
                                                    rootNavigator: true,
                                                  );
                                                  if (navigator.canPop()) {
                                                    navigator.pop();
                                                  }
                                                },
                                              ),
                                            ),
                                            title: const Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 14,
                                                  backgroundImage: AssetImage('assets/images/avatars/avatar_leo.png'),
                                                  backgroundColor: Colors.transparent,
                                                ),
                                                SizedBox(width: 8),
                                                Text('Лео'),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: LeoDialogScreen(
                                          chatId: _chatId,
                                          userContext: userContext,
                                          levelContext: levelContext,
                                          onChatIdChanged: (id) {
                                            if (mounted && id.isNotEmpty) {
                                              setState(() => _chatId = id);
                                            }
                                          },
                                          embedded: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
                if (!mounted) return;
                final current =
                    router.routeInformationProvider.value.uri.toString();
                if (origin.startsWith('/tower') && current != origin) {
                  router.go(origin);
                }
                assert(() {
                  debugPrint(
                      'leo_dialog_closed origin=$origin current=$current result=$result');
                  return true;
                }());
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
                        // Для уровня 1: дополнительная проверка наличия цели в БД перед завершением
                        if ((widget.levelNumber ?? -1) == 1 && !_goalV1Saved) {
                          await _checkGoalV1Saved();
                          // Если после проверки цель все еще не найдена, не завершаем уровень
                          if (!_goalV1Saved) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Сначала сохраните цель в чекпоинте L1'),
                                ),
                              );
                            }
                            return;
                          }
                        }
                        
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
                        if (!_autoCompletedLevel) {
                          await SupabaseService.completeLevel(widget.levelId);
                          ref.invalidate(levelsProvider);
                          ref.invalidate(towerNodesProvider);
                          ref.invalidate(currentUserProvider);
                          ref.invalidate(userSkillsProvider);
                          ref.invalidate(gpBalanceProvider);
                        }
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
                          if (!_autoCompletedLevel) {
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
                          }

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

                              // ВАЖНО: Используем rootNavigator: true, чтобы диалог не уничтожался
                              // при пересоздании вложенного навигатора
                              await Navigator.of(context, rootNavigator: true).push(
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

  Future<void> _maybeAutoCompleteLevel1(List<LessonModel> lessons) async {
    if ((widget.levelNumber ?? -1) != 1) return;
    if (_autoCompletingLevel || _autoCompletedLevel) return;
    if (!_isLevelCompleted(lessons)) return;
    _autoCompletingLevel = true;
    try {
      await SupabaseService.completeLevel(widget.levelId);
      ref.invalidate(levelsProvider);
      ref.invalidate(towerNodesProvider);
      ref.invalidate(currentUserProvider);
      ref.invalidate(userSkillsProvider);
      ref.invalidate(gpBalanceProvider);
      _autoCompletedLevel = true;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Уровень завершён')),
        );
      }
    } catch (_) {
      // Ошибка автозавершения не должна блокировать прохождение.
    } finally {
      _autoCompletingLevel = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lessonsAsync = ref.watch(lessonsProvider(widget.levelId));

    return Scaffold(
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
          
          // Для уровня 1: отслеживаем изменения цели и обновляем флаг
          if ((widget.levelNumber ?? -1) == 1) {
            final goalAsync = ref.watch(userGoalProvider);
            goalAsync.when(
              data: (goal) {
                if (goal != null) {
                  final goalText = (goal['goal_text'] as String? ?? '').trim();
                  if (goalText.isNotEmpty && !_goalV1Saved && mounted) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() {
                          _goalV1Saved = true;
                        });
                        // Авто-завершение уровня после сохранения цели.
                        _maybeAutoCompleteLevel1(lessons);
                      }
                    });
                  }
                }
              },
              loading: () {},
              error: (_, __) {},
            );
          }

          final mainContent =
              _buildMainColumn(context, lessons, isLevelZero, isProfilePage);
          final stack = _buildOverlays(context, mainContent);
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
      if (!_areLevelZeroVideosCompleted(lessons)) return false;
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

  bool _areLevelZeroVideosCompleted(List<LessonModel> lessons) {
    for (var i = 0; i < lessons.length; i++) {
      final videoPage = videoPageFor(i);
      if (!_progress.watchedVideos.contains(videoPage)) {
        return false;
      }
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
          canCompleteLevel: () => _areLevelZeroVideosCompleted(lessons),
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
              _maybeAutoCompleteLevel1(lessons);
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
