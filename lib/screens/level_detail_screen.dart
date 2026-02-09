import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/models/lesson_model.dart';
import 'package:bizlevel/providers/lessons_provider.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/theme/effects.dart';
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
import 'package:bizlevel/providers/gp_providers.dart';
import 'package:bizlevel/widgets/common/gp_balance_widget.dart';
import 'package:bizlevel/theme/typography.dart';
import 'package:bizlevel/utils/level_page_index.dart';
import 'package:bizlevel/widgets/level/blocks/level_page_block.dart';
import 'package:bizlevel/widgets/level/blocks/intro_block.dart';
import 'package:bizlevel/widgets/level/blocks/lesson_block.dart';
import 'package:bizlevel/widgets/level/blocks/quiz_block.dart';
import 'package:bizlevel/widgets/level/blocks/artifact_block.dart';
import 'package:bizlevel/widgets/level/blocks/profile_form_block.dart';
import 'package:bizlevel/screens/ray_dialog_screen.dart';
import 'package:bizlevel/utils/custom_modal_route.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bizlevel/services/context_service.dart';
import 'package:bizlevel/services/level_input_guard.dart';
import 'package:bizlevel/widgets/common/discuss_bubble.dart';

/// Shows a level as full-screen blocks (Intro → Lesson → Quiz → …).
class LevelDetailScreen extends ConsumerStatefulWidget {
  final int levelId;
  final int? levelNumber;
  const LevelDetailScreen({super.key, required this.levelId, this.levelNumber});

  @override
  ConsumerState<LevelDetailScreen> createState() => _LevelDetailScreenState();
}

class _LevelDetailScreenState extends ConsumerState<LevelDetailScreen> {
  bool _isCompleting = false;
  late final PageController _pageController;

  late List<LevelPageBlock> _blocks;
  LessonProgressState get _progress =>
      ref.watch(lessonProgressProvider(widget.levelId));

  // Флаг сохранения профиля (для уровня 0)
  bool _profileSaved = false;

  // --- Состояние формы профиля уровня 0 (поднято из блока для сохранения ввода) ---
  final TextEditingController _profileNameCtrl = TextEditingController();
  final TextEditingController _profileAboutCtrl = TextEditingController();
  final TextEditingController _profileGoalCtrl = TextEditingController();
  final FocusNode _profileNameFocus = FocusNode();
  final FocusNode _profileAboutFocus = FocusNode();
  final FocusNode _profileGoalFocus = FocusNode();
  int _profileAvatarId = 1;
  bool _isProfileEditing = true; // после сохранения переключим в read-only
  bool _profileInitialized =
      false; // чтобы не переписывать контроллеры на каждом билде
  bool _blockPopWhileEditing = false;

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

    LevelInputGuard.instance.setCurrentLevelRoute(
        '/levels/${widget.levelId}?num=${widget.levelNumber ?? 0}');

    _profileNameFocus.addListener(_syncInputPopGuard);
    _profileAboutFocus.addListener(_syncInputPopGuard);
    _profileGoalFocus.addListener(_syncInputPopGuard);
  }

  void _syncInputPopGuard() {
    if (!mounted) return;
    final bool hasFocus = _profileNameFocus.hasFocus ||
        _profileAboutFocus.hasFocus ||
        _profileGoalFocus.hasFocus;
    if (_blockPopWhileEditing == hasFocus) return;
    setState(() => _blockPopWhileEditing = hasFocus);
    if (hasFocus) {
      LevelInputGuard.instance.activate();
    } else {
      LevelInputGuard.instance.deactivate();
    }
    assert(() {
      final field = _profileNameFocus.hasFocus
          ? 'name'
          : _profileAboutFocus.hasFocus
              ? 'about'
              : _profileGoalFocus.hasFocus
                  ? 'goal'
                  : 'none';
      debugPrint('[focus] field_focus_change field=$field hasFocus=$hasFocus');
      return true;
    }());
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

      final String caseTitle = (caseRow['title'] as String?) ?? 'Мини‑кейс';
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

  Widget _buildMainColumn(BuildContext context, List<LessonModel> lessons,
      bool isLevelZero, bool isProfilePage) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(child: _buildPageView()),
          if (!isProfilePage)
            _buildBottomCta(
              context,
              lessons: lessons,
              isLevelZero: isLevelZero,
            ),
        ],
      ),
    );
  }

  Widget _buildOverlays(BuildContext context, Widget mainContent) {
    return Stack(
      children: [
        // Сдвигаем основное содержимое вниз, чтобы прогресс‑бар и заголовок
        // не перекрывали видео/контент первого блока.
        Padding(
          padding: const EdgeInsets.only(top: 36),
          child: mainContent,
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: AppSpacing.insetsSymmetric(
                h: AppSpacing.lg,
                v: AppSpacing.xs,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: (_currentIndex + 1) / (_blocks.length),
                    minHeight: 3,
                    backgroundColor: Colors.black.withValues(alpha: 0.06),
                    valueColor: const AlwaysStoppedAnimation(AppColor.primary),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Урок ${_currentIndex + 1} из ${_blocks.length}',
                    style: AppTypography.caption
                        .copyWith(color: AppColor.colorTextSecondary),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.surface.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  tooltip: 'К башне',
                  onPressed: () => _goBackToTower(context),
                ),
              ),
            ),
          ),
        ),
        if ((widget.levelNumber ?? 0) > 0)
          Positioned(
            top: 4,
            right: AppSpacing.lg,
            child: SafeArea(
              bottom: false,
              child: Hero(
                tag: 'level-hero-${widget.levelNumber}',
                child: _LevelHeroBadge(levelNumber: widget.levelNumber ?? 0),
              ),
            ),
          ),
        if ((widget.levelNumber ?? -1) != 0)
          Positioned(
            right: AppSpacing.lg,
            bottom: _floatingDiscussBottom(context),
            child: DiscussBubble.leo(
              onTap: () => _openDiscussSheet(context),
              pulse: (widget.levelNumber ?? -1) == 1 && _currentIndex <= 3,
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
    _profileNameFocus.dispose();
    _profileAboutFocus.dispose();
    _profileGoalFocus.dispose();
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
      canPop: !_blockPopWhileEditing,
      onPopInvoked: (didPop) {
        if (didPop) return;
        if (_blockPopWhileEditing) {
          FocusManager.instance.primaryFocus?.unfocus();
          assert(() {
            debugPrint(
                '[nav] pop_blocked reason=profile_focus level=${widget.levelNumber}');
            return true;
          }());
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

  void _goNext() {
    if (_currentIndex + 1 < _blocks.length &&
        _currentIndex < _progress.unlockedPage) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _goBackToTower(BuildContext context) {
    try {
      LevelInputGuard.instance.clear();
      final levelNumber = widget.levelNumber ?? 0;
      if (levelNumber > 0) {
        context.go('/tower?scrollTo=$levelNumber');
      } else {
        context.go('/tower');
      }
    } catch (_) {}
  }

  double _floatingDiscussBottom(BuildContext context) {
    final safe = MediaQuery.of(context).padding.bottom;
    // Увеличен отступ, чтобы FAB не перекрывал кнопку "Повторить" в квизе
    return AppDimensions.buttonPrimaryLargeHeight + safe + AppSpacing.lg * 3 + 16;
  }

  Widget _buildBottomCta(
    BuildContext context, {
    required List<LessonModel> lessons,
    required bool isLevelZero,
  }) {
    final bool isLast = _currentIndex == _blocks.length - 1;
    final bool canComplete = _isLevelCompleted(lessons) && !_isCompleting;
    final bool canNext = _currentIndex < _progress.unlockedPage;
    final bool showFinish = isLast && canComplete && !isLevelZero;

    final String label = showFinish ? 'Завершить уровень ✓' : 'Далее';
    final Color bg = showFinish ? AppColor.colorSuccess : AppColor.primary;

    return SafeArea(
      top: false,
      child: Container(
        padding: AppSpacing.insetsSymmetric(
          h: AppSpacing.lg,
          v: AppSpacing.sm,
        ),
        decoration: const BoxDecoration(
          color: Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 12,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BizLevelButton(
          label: label,
          size: BizLevelButtonSize.lg,
          fullWidth: true,
          backgroundColorOverride: bg,
          foregroundColorOverride: AppColor.onPrimary,
          onPressed: showFinish
              ? () => _completeLevel(context)
              : (canNext ? _goNext : null),
        ),
      ),
    );
  }

  Future<void> _openDiscussSheet(BuildContext context) async {
    // ВАЖНО: Получаем ProviderContainer из текущего контекста,
    // чтобы передать его в UncontrolledProviderScope для диалога
    // Это гарантирует, что провайдеры будут доступны даже если родитель умрет
    final container = ProviderScope.containerOf(context);
    final userContext = await _buildUserContext();
    final levelContext = _buildLevelContext();
    if (!mounted) return;

    final router = GoRouter.of(context);
    final origin = router.routeInformationProvider.value.uri.toString();
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

    final result = await Navigator.of(context, rootNavigator: true).push(
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
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Column(
                          children: [
                            Container(
                              color: AppColor.primary,
                              child: SafeArea(
                                bottom: false,
                                child: SizedBox(
                                  height: 56,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        tooltip: 'Закрыть',
                                        icon: const Icon(Icons.close),
                                        onPressed: () {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          final navigator = Navigator.of(
                                            context,
                                            rootNavigator: true,
                                          );
                                          if (navigator.canPop()) {
                                            navigator.pop();
                                          }
                                        },
                                      ),
                                      const CircleAvatar(
                                        radius: 14,
                                        backgroundImage: AssetImage(
                                            'assets/images/avatars/avatar_leo.png'),
                                        backgroundColor: Colors.transparent,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text('Лео'),
                                      const Spacer(),
                                      const Padding(
                                        padding: EdgeInsets.only(right: 12),
                                        child: Center(child: GpBalanceWidget()),
                                      ),
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
    final current = router.routeInformationProvider.value.uri.toString();
    if (origin.startsWith('/tower') && current != origin) {
      router.go(origin);
    }
    assert(() {
      debugPrint(
          'leo_dialog_closed origin=$origin current=$current result=$result');
      return true;
    }());
  }

  Future<void> _completeLevel(BuildContext context) async {
    if (!mounted) return;
    setState(() => _isCompleting = true);
    try {
      try {
        sentry.Sentry.addBreadcrumb(sentry.Breadcrumb(
          category: 'level',
          level: sentry.SentryLevel.info,
          message: 'level_complete_attempt',
          data: {'levelId': widget.levelId, 'levelNumber': widget.levelNumber},
        ));
      } catch (_) {}
      await SupabaseService.completeLevel(widget.levelId);
      ref.invalidate(levelsProvider);
      ref.invalidate(towerNodesProvider);
      ref.invalidate(currentUserProvider);
      ref.invalidate(userSkillsProvider);
      ref.invalidate(gpBalanceProvider);
      try {
        sentry.Sentry.addBreadcrumb(sentry.Breadcrumb(
          category: 'level',
          level: sentry.SentryLevel.info,
          message: 'level_completed',
          data: {'levelId': widget.levelId, 'levelNumber': widget.levelNumber},
        ));
      } catch (_) {}
      if (context.mounted) {
        // Предложение проверить идею после завершения Уровня 5 (Ray)
        final isLevel5 = (widget.levelNumber ?? -1) == 5;
        if (isLevel5 && context.mounted) {
          final shouldOpenRay = await showDialog<bool>(
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

            await Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (_) => const RayDialogScreen(),
              ),
            );
          }
        }
        // Переход в башню: для уровня 1 — к 2-му, иначе общий возврат
        if (!context.mounted) return;
        final nextScroll =
            (widget.levelNumber ?? 0) == 1 ? 2 : (widget.levelNumber ?? 0);
        context.go('/tower?scrollTo=$nextScroll');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isCompleting = false);
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
          nameFocusNode: _profileNameFocus,
          aboutFocusNode: _profileAboutFocus,
          goalFocusNode: _profileGoalFocus,
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
        // Последний блок — артефакт, как в остальных уровнях.
        // Цель заполняется отдельно в чекпоинте L1 после завершения уровня.
        ArtifactBlock(levelId: widget.levelId, levelNumber: widget.levelNumber),
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

class _LevelHeroBadge extends StatelessWidget {
  final int levelNumber;
  const _LevelHeroBadge({required this.levelNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.insetsSymmetric(h: AppSpacing.sm, v: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColor.colorPrimaryLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColor.colorPrimary),
        boxShadow: const [AppEffects.shadowSm],
      ),
      child: Text(
        'Уровень $levelNumber',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColor.colorPrimary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
