import 'package:flutter/animation.dart';

class AppAnimations {
  // Длительности
  static const Duration quick = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 600);
  static const Duration verySlow = Duration(milliseconds: 800);

  // Кривые
  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve smoothCurve = Curves.fastOutSlowIn;
}
