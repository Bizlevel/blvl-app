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

/// Расширенная система Motion для согласованных анимаций
class MotionSystem {
  // Stagger
  static const Duration staggerDelay = Duration(milliseconds: 50);
  static const Duration listItemStagger = Duration(milliseconds: 30);

  // Микро‑интеракции
  static const Duration microInteraction = Duration(milliseconds: 150);
  static const Duration hapticFeedback = Duration(milliseconds: 10);

  // Переходы
  static const Duration pageTransition = Duration(milliseconds: 300);
  static const Duration modalTransition = Duration(milliseconds: 250);
  static const Duration bottomSheetTransition = Duration(milliseconds: 200);

  // Кривые
  static const Curve entering = Curves.easeOutCubic;
  static const Curve exiting = Curves.easeInCubic;
  static const Curve emphasized = Curves.easeInOutCubic;
}
