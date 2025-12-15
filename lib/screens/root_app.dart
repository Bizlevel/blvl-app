import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:bizlevel/screens/profile_screen.dart';
import 'package:bizlevel/screens/leo_chat_screen.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/theme/effects.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/utils/constant.dart';
import 'package:bizlevel/widgets/bottombar_item.dart';
import 'package:bizlevel/screens/levels_map_screen.dart';
import 'package:bizlevel/widgets/desktop_nav_bar.dart';

// Provider to hold index of active tab
final _rootTabProvider = StateProvider<int>((ref) => 0);

class RootApp extends ConsumerWidget {
  const RootApp({super.key});

  static final _tabs = [
    {
      "icon": Icons.school_outlined,
      "page": const LevelsMapScreen(),
    },
    {
      "icon": Icons.chat_bubble_outline,
      "page": const LeoChatScreen(),
    },
    {
      "icon": Icons.person_outline,
      "page": const ProfileScreen(),
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(_rootTabProvider);
    final width = MediaQuery.of(context).size.width;
    // desktop breakpoint >1024 (см. main.dart)
    final bool isDesktop = width >= 1024;

    final pageWidget = _tabs[activeTab]["page"] as Widget;

    return Scaffold(
      bottomNavigationBar: isDesktop ? null : _buildBottomBar(ref, activeTab),
      body: isDesktop
          ? Row(
              children: [
                DesktopNavBar(
                  tabs: _tabs,
                  activeIndex: activeTab,
                  onTabSelected: (index) =>
                      ref.read(_rootTabProvider.notifier).state = index,
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: animatedBodyMs),
                    child: pageWidget,
                  ),
                ),
              ],
            )
          : AnimatedSwitcher(
              duration: const Duration(milliseconds: animatedBodyMs),
              child: pageWidget,
            ),
    );
  }

  Widget _buildBottomBar(WidgetRef ref, int activeTab) {
    return Container(
      height: 75,
      width: double.infinity,
      decoration: BoxDecoration(
        // Liquid glass: стеклянная панель поверх общего фона приложения.
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
          children: List.generate(
            _tabs.length,
            (index) => BottomBarItem(
              _tabs[index]["icon"] as IconData,
              isActive: activeTab == index,
              onTap: () => ref.read(_rootTabProvider.notifier).state = index,
            ),
          ),
        ),
      ),
    );
  }
}
