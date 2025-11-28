import 'package:flutter/widgets.dart';

/// Брейкпоинты для адаптивной вёрстки
class Breakpoints {
  static const double mobileSmall = 360;
  static const double mobile = 390;
  static const double mobileLarge = 430;
  static const double tablet = 768;
  static const double desktop = 1024;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < tablet;

  static bool isTablet(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    return w >= tablet && w < desktop;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktop;
}

/// Адаптивные отступы/размеры
class ResponsiveSpacing {
  static double adaptive(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    final double width = MediaQuery.of(context).size.width;
    if (width >= Breakpoints.desktop) return desktop ?? tablet ?? mobile;
    if (width >= Breakpoints.tablet) return tablet ?? mobile;
    return mobile;
  }
}


