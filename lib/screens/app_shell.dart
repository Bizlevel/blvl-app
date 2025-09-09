import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/widgets/bottombar_item.dart';
import 'package:bizlevel/widgets/desktop_nav_bar.dart';
import 'package:bizlevel/screens/main_street_screen.dart';
import 'package:bizlevel/screens/leo_chat_screen.dart';
import 'package:bizlevel/screens/goal_screen.dart';
import 'package:bizlevel/screens/profile_screen.dart';
import 'package:bizlevel/providers/auth_provider.dart';

class AppShell extends ConsumerStatefulWidget {
  final Widget child;
  const AppShell({required this.child, super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  static const _routes = ['/home', '/chat', '/goal', '/profile'];
  PageController? _pageController;
  int _currentIndex = 0;
  bool _isSyncing = false;

  int _locationToTab(String location) {
    for (int i = 0; i < _routes.length; i++) {
      if (location.startsWith(_routes[i])) return i;
    }
    return 0;
  }

  void _ensureController(int initialPage) {
    _pageController ??=
        PageController(initialPage: initialPage, keepPage: true);
  }

  @override
  Widget build(BuildContext context) {
    final String location =
        GoRouter.of(context).routeInformationProvider.value.location;
    final int activeTab = _locationToTab(location);

    final width = MediaQuery.of(context).size.width;
    final bool isDesktop = width >= 1024;

    void _goTab(int index) {
      if (_pageController != null && _pageController!.positions.isNotEmpty) {
        _pageController!.animateToPage(index,
            duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      } else {
        context.go(_routes[index]);
      }
    }

    final bool isBaseRoute = _routes.any((r) => location.startsWith(r));

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
      backgroundColor: AppColor.appBgColor,
      bottomNavigationBar: isDesktop
          ? null
          : Container(
              height: 75,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColor.bottomBarColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.shadowColor.withValues(alpha: 0.1),
                    blurRadius: 1,
                    spreadRadius: 1,
                    offset: const Offset(1, 1),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(_routes.length, (index) {
                    final icon = index == 0
                        ? Icons.map
                        : index == 1
                            ? Icons.chat_bubble
                            : index == 2
                                ? Icons.flag
                                : Icons.person;
                    return BottomBarItem(
                      icon,
                      isActive: activeTab == index,
                      activeColor: AppColor.primary,
                      onTap: () => _goTab(index),
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
                    {'icon': Icons.map, 'label': 'Главная'},
                    {'icon': Icons.chat_bubble, 'label': 'База тренеров'},
                    {'icon': Icons.flag, 'label': 'Цель'},
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
                      context.go(_routes[i]);
                    });
                  },
                  children: [
                    const MainStreetScreen(key: PageStorageKey('tab_home')),
                    const LeoChatScreen(key: PageStorageKey('tab_chat')),
                    _GoalTabGate(key: const PageStorageKey('tab_goal')),
                    const ProfileScreen(key: PageStorageKey('tab_profile')),
                  ],
                )
              : widget.child,
    );
  }
}

class _GoalTabGate extends ConsumerWidget {
  const _GoalTabGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).asData?.value;
    final currentLevel = user?.currentLevel ?? 0;
    final allowed = currentLevel >= 2;
    if (!allowed) {
      return Center(
        child: Semantics(
          label: 'Вкладка Недоступна',
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock, color: AppColor.labelColor, size: 36),
              SizedBox(height: 8),
              Text('Раздел "Цель" откроется после Уровня 1',
                  style: TextStyle(color: AppColor.onSurfaceSubtle)),
            ],
          ),
        ),
      );
    }
    return const GoalScreen();
  }
}
