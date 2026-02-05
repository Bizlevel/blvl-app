import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/theme/effects.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/widgets/bottombar_item.dart';
import 'package:bizlevel/widgets/desktop_nav_bar.dart';
import 'package:bizlevel/screens/main_street_screen.dart';
import 'package:bizlevel/screens/profile_screen.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bizlevel/screens/biz_tower_screen.dart';
import 'package:bizlevel/screens/leo_chat_screen.dart';
import 'package:bizlevel/utils/hive_box_helper.dart';
import 'package:bizlevel/widgets/onboarding/coach_mark_targets.dart';
import 'package:bizlevel/widgets/onboarding/coach_marks_overlay.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bizlevel/models/user_model.dart';
import 'dart:async';
// Удалил импорт guard, он здесь вреден
// import 'package:bizlevel/services/level_input_guard.dart';

class AppShell extends ConsumerStatefulWidget {
  final Widget child;
  const AppShell({required this.child, super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  static const _routes = ['/home', '/tower', '/chat', '/profile'];
  PageController? _pageController;
  int _currentIndex = 0;
  bool _isSyncing = false;
  String? _lastLocation;
  bool _showCoachMarks = false;
  bool _onboardingChecked = false;
  bool _isOffline = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  @override
  void initState() {
    super.initState();
    _refreshOnboardingState(ref.read(currentUserProvider));
    ref.listen<AsyncValue<UserModel?>>(currentUserProvider, (_, next) {
      _refreshOnboardingState(next);
    });
    _initConnectivity();
  }

  Future<void> _refreshOnboardingState(
    AsyncValue<UserModel?> userAsync,
  ) async {
    final authUser = Supabase.instance.client.auth.currentUser;
    if (authUser == null) {
      if (!mounted) return;
      setState(() {
        _showCoachMarks = false;
        _onboardingChecked = true;
      });
      return;
    }

    final user = userAsync.asData?.value;
    final String userId = user?.id ?? authUser.id;
    final String localKey = 'hasSeenOnboarding_$userId';
    final seen = await HiveBoxHelper.readValue('onboarding', localKey);
    final bool serverCompleted = user?.onboardingCompleted ?? false;
    final bool shouldShow = !(seen == true) && !serverCompleted;
    if (!mounted) return;
    setState(() {
      _showCoachMarks = shouldShow;
      _onboardingChecked = true;
    });
    if (serverCompleted && seen != true) {
      HiveBoxHelper.putDeferred('onboarding', localKey, true);
    }
  }

  Future<void> _initConnectivity() async {
    try {
      final connectivity = Connectivity();
      final result = await connectivity.checkConnectivity();
      if (!mounted) return;
      _isOffline = result.contains(ConnectivityResult.none);
      setState(() {});
      _connectivitySub?.cancel();
      _connectivitySub = connectivity.onConnectivityChanged.listen((results) {
        if (!mounted) return;
        final offline = results.contains(ConnectivityResult.none);
        if (offline != _isOffline) {
          setState(() => _isOffline = offline);
        }
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    super.dispose();
  }

  void _debugNav(String message, Map<String, Object?> data) {
    assert(() {
      debugPrint('[nav] $message ${data.toString()}');
      return true;
    }());
  }

  int _locationToTab(String location) {
    final path = Uri.parse(location).path;
    for (int i = 0; i < _routes.length; i++) {
      if (path == _routes[i]) return i;
    }
    return 0;
  }

  void _ensureController(int initialPage) {
    _pageController ??= PageController(initialPage: initialPage);
  }

  @override
  Widget build(BuildContext context) {
    // ВАЖНО: Мы больше не трогаем LevelInputGuard здесь.
    // Вся логика защиты маршрутов должна быть ТОЛЬКО в app_router.dart -> redirect.
    // Дублирование логики в build() виджета приводило к конфликтам при ресайзе (клавиатура).

    final String location =
        GoRouter.of(context).routeInformationProvider.value.uri.toString();

    if (_lastLocation != location) {
      _debugNav('location_change', {
        'from': _lastLocation,
        'to': location,
      });
      _lastLocation = location;
    }

    final int activeTab = _locationToTab(location);
    final width = MediaQuery.of(context).size.width;
    final bool isDesktop = width >= 1024;
    final bool isBaseRoute = _routes.contains(Uri.parse(location).path);

    void goTab(int index) {
      try {
        final fromIndex = activeTab;
        final from = _routes[fromIndex];
        final to = _routes[index];
        _debugNav('tab_tap', {
          'from': from,
          'to': to,
          'activeTab': activeTab,
          'targetIndex': index,
          'location': location,
        });
        if (from != to) {
          Sentry.addBreadcrumb(Breadcrumb(
            category: 'nav',
            level: SentryLevel.info,
            message: 'tab_switch',
            data: {'from': from, 'to': to},
          ));
        }
      } catch (_) {}

      if (_pageController != null && _pageController!.hasClients) {
        final router = GoRouter.of(context);
        _isSyncing = true;
        _pageController!
            .animateToPage(index,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut)
            .then((_) {
          if (!mounted) return;
          _isSyncing = false;
          final target = _routes[index];
          final current = router.routeInformationProvider.value.uri.toString();
          _debugNav('tab_anim_complete', {
            'target': target,
            'current': current,
            'index': index,
          });
          if (current != target) {
            router.go(target);
          }
        });
      } else {
        _debugNav('tab_go_immediate', {
          'target': _routes[index],
          'index': index,
        });
        context.go(_routes[index]);
      }
    }

    if (!isDesktop && isBaseRoute) {
      _ensureController(activeTab);
      if (_currentIndex != activeTab &&
          _pageController != null &&
          !_isSyncing) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted &&
              _pageController != null &&
              _pageController!.hasClients) {
            _isSyncing = true;
            _pageController!.jumpToPage(activeTab);
            _currentIndex = activeTab;
            _isSyncing = false;
          }
        });
      }
    } else {
      _pageController = null;
    }

    return Stack(
      children: [
        Scaffold(
          bottomNavigationBar: isDesktop
              ? null
              : Container(
                  height: 72,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor.colorSurface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppDimensions.radius24),
                      topRight: Radius.circular(AppDimensions.radius24),
                    ),
                    border: Border.all(color: AppColor.colorBorder),
                    boxShadow: const [AppEffects.shadowSm],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: AppSpacing.s20,
                      right: AppSpacing.s20,
                      bottom: AppSpacing.s10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(_routes.length, (index) {
                        final (icon, label) = switch (index) {
                          0 => (Icons.home, 'Главная'),
                          1 => (Icons.map, 'Уровни'),
                          2 => (Icons.smart_toy, 'Менторы'),
                          _ => (Icons.person, 'Профиль'),
                        };

                        const inactive = AppColor.colorTextTertiary;
                        const active = AppColor.colorPrimary;

                        Widget iconWidget;
                        if (index == 1) {
                          iconWidget = SvgPicture.asset(
                            'assets/icons/icon_map.svg',
                            width: 22,
                            height: 22,
                            colorFilter: ColorFilter.mode(
                              activeTab == index ? active : inactive,
                              BlendMode.srcIn,
                            ),
                          );
                        } else if (index == 2) {
                          iconWidget = SvgPicture.asset(
                            'assets/icons/icon_ai.svg',
                            width: 22,
                            height: 22,
                            colorFilter: ColorFilter.mode(
                              activeTab == index ? active : inactive,
                              BlendMode.srcIn,
                            ),
                          );
                        } else {
                          iconWidget = Icon(
                            icon,
                            size: 22,
                            color: activeTab == index ? active : inactive,
                          );
                        }

                        return BottomBarItem(
                          icon,
                          key: index == 1
                              ? CoachMarkTargets.tabLevels
                              : (index == 2
                                  ? CoachMarkTargets.tabMentors
                                  : null),
                          label: label,
                          isActive: activeTab == index,
                          isNotified: index == 2,
                          onTap: () => goTab(index),
                          iconBuilder: (_, __, ___) => iconWidget,
                        );
                      }),
                    ),
                  ),
                ),
          body: isDesktop
              ? Row(
                  children: [
                    DesktopNavBar(
                      tabs: const [
                        {'icon': Icons.home, 'label': 'Главная'},
                        {'icon': Icons.map, 'label': 'Уровни'},
                        {'icon': Icons.smart_toy, 'label': 'Менторы'},
                        {'icon': Icons.person, 'label': 'Профиль'},
                      ],
                      activeIndex: activeTab,
                      onTabSelected: (index) => context.go(_routes[index]),
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(child: widget.child),
                  ],
                )
              : isBaseRoute
                  ? PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (i) {
                        final currentUri = GoRouter.of(context)
                            .routeInformationProvider
                            .value
                            .uri
                            .toString();
                        final isCurrentBase =
                            _routes.contains(Uri.parse(currentUri).path);

                        if (!isCurrentBase) {
                          _debugNav('page_changed_ignored', {
                            'index': i,
                            'reason': 'not_base_route',
                            'currentUri': currentUri
                          });
                          return;
                        }

                        _currentIndex = i;
                        if (_isSyncing) return;

                        try {
                          HapticFeedback.selectionClick();
                        } catch (_) {}

                        _debugNav('page_changed_go', {
                          'index': i,
                          'target': _routes[i],
                          'location': location,
                        });
                        context.go(_routes[i]);
                      },
                      children: const [
                        MainStreetScreen(key: PageStorageKey('tab_home')),
                        BizTowerScreen(key: PageStorageKey('tab_tower')),
                        LeoChatScreen(key: PageStorageKey('tab_trainers')),
                        ProfileScreen(key: PageStorageKey('tab_profile')),
                      ],
                    )
                  : widget.child,
        ),
        if (_isOffline)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Container(
                padding: AppSpacing.insetsSymmetric(
                    h: AppSpacing.lg, v: AppSpacing.s6),
                decoration: BoxDecoration(
                  color: AppColor.colorWarningLight,
                  border: Border(
                    bottom: BorderSide(
                        color: AppColor.colorWarning.withValues(alpha: 0.4)),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.wifi_off,
                        size: 18, color: AppColor.colorWarning),
                    const SizedBox(width: AppSpacing.s6),
                    Expanded(
                      child: Text(
                        'Нет соединения. Некоторые функции недоступны.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColor.colorTextPrimary,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (_onboardingChecked &&
            _showCoachMarks &&
            Uri.parse(location).path == '/home')
          CoachMarksOverlay(
            steps: [
              CoachMarkStep(
                targetKey: CoachMarkTargets.continueCard,
                title: 'Продолжить обучение',
                description:
                    'Быстрый переход к следующему уровню и рекомендациям.',
              ),
              CoachMarkStep(
                targetKey: CoachMarkTargets.tabLevels,
                title: 'Уровни',
                description: 'Все этапы обучения и прогресс по Башне.',
              ),
              CoachMarkStep(
                targetKey: CoachMarkTargets.tabMentors,
                title: 'Менторы',
                description: 'Чат с Лео, Максом и Рэем — задавайте вопросы.',
              ),
              CoachMarkStep(
                targetKey: CoachMarkTargets.gpBadge,
                title: 'Баланс GP',
                description: 'GP тратятся на чаты и открывают новые этажи.',
              ),
            ],
            onFinish: () {
              setState(() => _showCoachMarks = false);
              final authUser = Supabase.instance.client.auth.currentUser;
              if (authUser == null) return;
              final localKey = 'hasSeenOnboarding_${authUser.id}';
              HiveBoxHelper.putDeferred(
                'onboarding',
                localKey,
                true,
              );
            },
          ),
      ],
    );
  }
}
