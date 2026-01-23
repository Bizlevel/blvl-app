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
import 'package:bizlevel/services/level_input_guard.dart';

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

  void _debugNav(String message, Map<String, Object?> data) {
    assert(() {
      debugPrint('[nav] $message ${data.toString()}');
      return true;
    }());
  }

  // context helpers удалены с плавающей кнопкой чата

  int _locationToTab(String location) {
    for (int i = 0; i < _routes.length; i++) {
      if (location.startsWith(_routes[i])) return i;
    }
    return 0;
  }

  void _ensureController(int initialPage) {
    _pageController ??= PageController(initialPage: initialPage);
  }

  @override
  Widget build(BuildContext context) {
    final String location =
        GoRouter.of(context).routeInformationProvider.value.uri.toString();
    final guard = LevelInputGuard.instance;
    if (guard.isActive &&
        guard.lastLevelRoute != null &&
        (location == '/tower' || location.startsWith('/tower?'))) {
      _debugNav('guarded_tower_redirect', {
        'from': location,
        'to': guard.lastLevelRoute!,
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        GoRouter.of(context).go(guard.lastLevelRoute!);
      });
    }
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
            data: {
              'from': from,
              'to': to,
            },
          ));
        }
      } catch (_) {}
      if (_pageController != null && _pageController!.positions.isNotEmpty) {
        final router = GoRouter.of(context);
        _isSyncing = true;
        _pageController!
            .animateToPage(index,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut)
            .whenComplete(() {
          if (!mounted) return;
          _isSyncing = false;
          // Финализируем маршрут после завершения анимации на целевой вкладке
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
          'location': location,
        });
        context.go(_routes[index]);
      }
    }

    // Базовые табы только на точных путях '/home' | '/tower' | '/chat' | '/profile'.
    // Вложенные маршруты (например, '/goal-checkpoint/:v') не должны попадать в PageView.
    final bool isBaseRoute = location == '/home' ||
        location == '/tower' ||
        location == '/chat' ||
        location == '/profile';

    // Создаём/синхронизируем контроллер для PageView на базовых табах
    if (!isDesktop && isBaseRoute) {
      _ensureController(activeTab);
      if (_currentIndex != activeTab && _pageController != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          if (_pageController != null &&
              _pageController!.positions.isNotEmpty) {
            _isSyncing = true;
            _pageController!.jumpToPage(activeTab);
            _currentIndex = activeTab;
            // Сброс флага после кадра, чтобы onPageChanged не триггерил go
            Future.microtask(() => _isSyncing = false);
          }
        });
      }
    } else {
      // На небазовых маршрутах не держим контроллер привязанным
      _pageController = null;
    }

    return Scaffold(
      // На небазовых маршрутах (например, /levels/*) скрываем таб-бар,
      // чтобы избежать случайных переходов при вводе.
      bottomNavigationBar: (isDesktop || !isBaseRoute)
          ? null
          : Container(
              height: 75,
              width: double.infinity,
              decoration: BoxDecoration(
                // Liquid glass: стеклянная панель навигации поверх общего фона
                color: AppColor.glassSurfaceStrong,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppDimensions.radius24),
                  topRight: Radius.circular(AppDimensions.radius24),
                ),
                border: Border.all(color: AppColor.glassBorder),
                boxShadow: AppEffects.glassCardShadowSm,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: AppSpacing.s25,
                  right: AppSpacing.s25,
                  bottom: AppSpacing.s15,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ...List.generate(_routes.length, (index) {
                      final (icon, label) = index == 0
                          ? (Icons.home, 'Главная')
                          : index == 1
                              ? (Icons.map, 'Уровни')
                              : index == 2
                                  ? (Icons.smart_toy, 'Менторы')
                                  : (Icons.person, 'Профиль');
                      return BottomBarItem(
                        icon,
                        label: label,
                        isActive: activeTab == index,
                        onTap: () => goTab(index),
                        iconBuilder: (isActive, color, activeColor) {
                          if (index == 1) {
                            return SvgPicture.asset(
                              'assets/icons/icon_map.svg',
                              width: 22,
                              height: 22,
                              // fix: заменить Colors.grey на семантический токен
                              colorFilter: ColorFilter.mode(
                                isActive
                                    ? AppColor.primary
                                    : AppColor.onSurfaceSubtle,
                                BlendMode.srcIn,
                              ),
                            );
                          }
                          if (index == 2) {
                            return SvgPicture.asset(
                              'assets/icons/icon_ai.svg',
                              width: 22,
                              height: 22,
                              // fix: заменить Colors.grey на семантический токен
                              colorFilter: ColorFilter.mode(
                                isActive
                                    ? AppColor.primary
                                    : AppColor.onSurfaceSubtle,
                                BlendMode.srcIn,
                              ),
                            );
                          }
                          return Icon(
                            icon,
                            size: 22,
                            color: isActive ? activeColor : color,
                          );
                        },
                      );
                    }),
                  ],
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
                  onPageChanged: (i) {
                    _currentIndex = i;
                    if (_isSyncing) return;
                    try {
                      HapticFeedback.selectionClick();
                    } catch (_) {}
                    // Навигацию откладываем на пост-кадр, чтобы не вызывать go в build/скролле
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!mounted) return;
                    _debugNav('page_changed_go', {
                      'index': i,
                      'target': _routes[i],
                      'location': location,
                    });
                      context.go(_routes[i]);
                    });
                  },
                  children: const [
                    MainStreetScreen(key: PageStorageKey('tab_home')),
                    BizTowerScreen(key: PageStorageKey('tab_tower')),
                    LeoChatScreen(key: PageStorageKey('tab_trainers')),
                    ProfileScreen(key: PageStorageKey('tab_profile')),
                  ],
                )
              : widget.child,
    );
  }
}

// goal tab gate and custom goal svg icon removed as navigation was updated to Tower/Trainers

// Удалён плавающий чат‑баттон в боттом‑баре

// painter удалён вместе с плавающей кнопкой
