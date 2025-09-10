import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/widgets/bottombar_item.dart';
import 'package:bizlevel/widgets/desktop_nav_bar.dart';
import 'package:bizlevel/screens/main_street_screen.dart';
import 'package:bizlevel/screens/goal_screen.dart';
import 'package:bizlevel/screens/profile_screen.dart';
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bizlevel/screens/leo_dialog_screen.dart';

class AppShell extends ConsumerStatefulWidget {
  final Widget child;
  const AppShell({required this.child, super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  static const _routes = ['/home', '/goal', '/profile'];
  PageController? _pageController;
  int _currentIndex = 0;
  bool _isSyncing = false;

  String? _buildUserContext(WidgetRef ref) {
    final user = ref.read(currentUserProvider).value;
    if (user != null) {
      final parts = <String>[];
      if (user.goal?.isNotEmpty == true) parts.add('Цель: ${user.goal}');
      if (user.about?.isNotEmpty == true) parts.add('О себе: ${user.about}');
      if (user.businessArea?.isNotEmpty == true) {
        parts.add('Сфера: ${user.businessArea}');
      }
      if (user.experienceLevel?.isNotEmpty == true) {
        parts.add('Опыт: ${user.experienceLevel}');
      }
      if (user.businessSize?.isNotEmpty == true) {
        parts.add('Размер бизнеса: ${user.businessSize}');
      }
      if ((user.keyChallenges ?? const []).isNotEmpty) {
        parts.add('Вызовы: ${(user.keyChallenges!).join(', ')}');
      }
      if (user.learningStyle?.isNotEmpty == true) {
        parts.add('Стиль: ${user.learningStyle}');
      }
      if (user.businessRegion?.isNotEmpty == true) {
        parts.add('Регион: ${user.businessRegion}');
      }
      parts.add('Текущий уровень: ${user.currentLevel}');
      return parts.isNotEmpty ? parts.join('. ') : null;
    }
    return null;
  }

  String? _buildLevelContext(WidgetRef ref) {
    final user = ref.read(currentUserProvider).value;
    if (user != null) return 'Уровень ${user.currentLevel}';
    return null;
  }

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
                  children: [
                    ...List.generate(_routes.length, (index) {
                      final icon = index == 0
                          ? Icons.map
                          : index == 1
                              ? Icons.flag
                              : Icons.person;
                      return BottomBarItem(
                        icon,
                        isActive: activeTab == index,
                        activeColor: AppColor.primary,
                        onTap: () => _goTab(index),
                        iconWidget: index == 1
                            ? Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child:
                                    _GoalSvgIcon(isActive: activeTab == index),
                              )
                            : null,
                      );
                    }),
                    // Четвёртая кнопка: быстрый чат с Лео, наполовину торчит над баром
                    if (!isDesktop && isBaseRoute)
                      Transform.translate(
                        offset: const Offset(0, -18),
                        child: _LeoBottomActionButton(
                          onTap: () {
                            try {
                              HapticFeedback.lightImpact();
                            } catch (_) {}
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => LeoDialogScreen(
                                  userContext: _buildUserContext(ref),
                                  levelContext: _buildLevelContext(ref),
                                  bot: 'leo',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
      body: isDesktop
          ? Row(
              children: [
                DesktopNavBar(
                  tabs: const [
                    {'icon': Icons.map, 'label': 'Главная'},
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

class _GoalSvgIcon extends StatelessWidget {
  const _GoalSvgIcon({required this.isActive});
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/goal.svg',
      width: 26,
      height: 26,
      colorFilter: ColorFilter.mode(
        isActive ? AppColor.primary : Colors.grey,
        BlendMode.srcIn,
      ),
    );
  }
}

class _LeoBottomActionButton extends StatelessWidget {
  const _LeoBottomActionButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Новый диалог с Лео',
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColor.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColor.shadowColor.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.chat_bubble, color: AppColor.onPrimary),
        ),
      ),
    );
  }
}
