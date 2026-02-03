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

  void _debugNav(String message, Map<String, Object?> data) {
    assert(() {
      final tagNeeded = message == 'location_change' ||
          message == 'tab_tap' ||
          message == 'tab_anim_complete' ||
          message == 'tab_go_immediate' ||
          message == 'page_changed_go' ||
          message == 'page_changed_ignored';
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
      if (_currentIndex != activeTab && _pageController != null && !_isSyncing) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
             if (mounted && _pageController != null && _pageController!.hasClients) {
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

    return Scaffold(
      bottomNavigationBar: (isDesktop || !isBaseRoute)
          ? null
          : Container(
              height: 75,
              width: double.infinity,
              decoration: BoxDecoration(
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
                  children: List.generate(_routes.length, (index) {
                    final (icon, label) = switch (index) {
                      0 => (Icons.home, 'Главная'),
                      1 => (Icons.map, 'Уровни'),
                      2 => (Icons.smart_toy, 'Менторы'),
                      _ => (Icons.person, 'Профиль'),
                    };
                    
                    Widget iconWidget;
                    if (index == 1) {
                      iconWidget = SvgPicture.asset(
                        'assets/icons/icon_map.svg',
                        width: 22, height: 22,
                        colorFilter: ColorFilter.mode(
                          activeTab == index ? AppColor.primary : AppColor.onSurfaceSubtle,
                          BlendMode.srcIn,
                        ),
                      );
                    } else if (index == 2) {
                      iconWidget = SvgPicture.asset(
                        'assets/icons/icon_ai.svg',
                        width: 22, height: 22,
                        colorFilter: ColorFilter.mode(
                          activeTab == index ? AppColor.primary : AppColor.onSurfaceSubtle,
                          BlendMode.srcIn,
                        ),
                      );
                    } else {
                      iconWidget = Icon(
                        icon,
                        size: 22,
                        color: activeTab == index ? AppColor.primary : AppColor.onSurfaceSubtle,
                      );
                    }

                    return BottomBarItem(
                      icon,
                      label: label,
                      isActive: activeTab == index,
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
                    final currentUri = GoRouter.of(context).routeInformationProvider.value.uri.toString();
                    final isCurrentBase = _routes.contains(Uri.parse(currentUri).path);
                    
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
                    
                    try { HapticFeedback.selectionClick(); } catch (_) {}
                    
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
    );
  }
}