import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/widgets/bottombar_item.dart';
import 'package:bizlevel/widgets/desktop_nav_bar.dart';

class AppShell extends ConsumerWidget {
  final Widget child;
  const AppShell({required this.child, super.key});

  static const _routes = ['/home', '/chat', '/profile'];

  int _locationToTab(String location) {
    for (int i = 0; i < _routes.length; i++) {
      if (location.startsWith(_routes[i])) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String location =
        GoRouter.of(context).routeInformationProvider.value.location ?? '/home';
    final int activeTab = _locationToTab(location);

    final width = MediaQuery.of(context).size.width;
    final bool isDesktop = width >= 1024;

    void _goTab(int index) {
      context.go(_routes[index]);
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
                    color: AppColor.shadowColor.withOpacity(0.1),
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
                  children: List.generate(
                    _routes.length,
                    (index) => BottomBarItem(
                      index == 0
                          ? 'assets/icons/home.svg'
                          : index == 1
                              ? 'assets/icons/chat.svg'
                              : 'assets/icons/profile.svg',
                      isActive: activeTab == index,
                      activeColor: AppColor.primary,
                      onTap: () => _goTab(index),
                    ),
                  ),
                ),
              ),
            ),
      body: isDesktop
          ? Row(
              children: [
                DesktopNavBar(
                  tabs: [
                    {'icon': 'assets/icons/home.svg'},
                    {'icon': 'assets/icons/chat.svg'},
                    {'icon': 'assets/icons/profile.svg'},
                  ],
                  activeIndex: activeTab,
                  onTabSelected: _goTab,
                ),
                const VerticalDivider(width: 1),
                Expanded(child: child),
              ],
            )
          : child,
    );
  }
}
