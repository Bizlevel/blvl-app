import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bizlevel/theme/color.dart';

class DesktopNavBar extends StatelessWidget {
  const DesktopNavBar({
    super.key,
    required this.tabs,
    required this.activeIndex,
    required this.onTabSelected,
  });

  final List<Map<String, Object>> tabs;
  final int activeIndex;
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      backgroundColor: AppColor.bottomBarColor,
      selectedIndex: activeIndex,
      onDestinationSelected: onTabSelected,
      labelType: NavigationRailLabelType.selected,
      selectedIconTheme: const IconThemeData(color: AppColor.primary),
      destinations: List.generate(
        tabs.length,
        (index) {
          final iconPath = tabs[index]['icon'] as String;
          return NavigationRailDestination(
            icon: SvgPicture.asset(
              iconPath,
              color: Colors.grey,
              width: 24,
              height: 24,
            ),
            selectedIcon: SvgPicture.asset(
              iconPath,
              color: AppColor.primary,
              width: 24,
              height: 24,
            ),
            label: const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
