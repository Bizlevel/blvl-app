import 'package:flutter/widgets.dart';

/// Простые helpers для адаптивной логики без зависимости от внешних пакетов
class Responsive {
  Responsive._();

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w >= 600 && w < 1024;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;
}

class ResponsiveBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double desktop = 1400;
}

bool isMobile(BuildContext context) =>
    MediaQuery.of(context).size.width < ResponsiveBreakpoints.mobile;

bool isTablet(BuildContext context) =>
    MediaQuery.of(context).size.width >= ResponsiveBreakpoints.mobile &&
    MediaQuery.of(context).size.width < ResponsiveBreakpoints.tablet;

bool isDesktop(BuildContext context) =>
    MediaQuery.of(context).size.width >= ResponsiveBreakpoints.tablet;

double clampWidth(BuildContext context, {double min = 280, double max = 900}) {
  final w = MediaQuery.of(context).size.width;
  if (w < min) return min;
  if (w > max) return max;
  return w;
}

double adaptiveHeight(BuildContext context,
    {required double fraction, double min = 160, double max = 360}) {
  final h = MediaQuery.of(context).size.height * fraction;
  if (h < min) return min;
  if (h > max) return max;
  return h;
}
