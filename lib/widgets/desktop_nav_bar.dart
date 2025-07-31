import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';
import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;

class DesktopNavBar extends StatelessWidget {
  const DesktopNavBar({
    super.key,
    required this.tabs,
    required this.activeIndex,
    required this.onTabSelected,
  });

  final List<Map<String, Object>> tabs; // {icon: IconData, label: String}
  final int activeIndex;
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final navRail = NavigationRail(
      extended: true,
      backgroundColor: Colors.white.withOpacity(0.8),
      selectedIndex: activeIndex,
      onDestinationSelected: onTabSelected,
      labelType: NavigationRailLabelType.none,
      selectedIconTheme: const IconThemeData(color: AppColor.primary),
      destinations: [
        for (final tab in tabs)
          NavigationRailDestination(
            icon: Icon(tab['icon'] as IconData, color: Colors.grey, size: 24),
            selectedIcon: Icon(tab['icon'] as IconData,
                color: AppColor.primary, size: 24),
            label: Text(tab['label'] as String? ?? ''),
          ),
      ],
    );

    // Эффект blur оставляем только для Web, чтобы избежать проблем с производительностью
    if (!kIsWeb) return navRail;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: navRail,
      ),
    );
  }
}
