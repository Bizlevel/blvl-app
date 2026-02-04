import 'package:flutter/animation.dart';

class AppAnimations {
  // Длительности — базовые
  static const Duration micro = Duration(milliseconds: 150);
  static const Duration quick = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration medium = Duration(milliseconds: 500);
  static const Duration slow = Duration(milliseconds: 600);
  static const Duration verySlow = Duration(milliseconds: 800);
  static const Duration pulse = Duration(milliseconds: 900);
  static const Duration celebration = Duration(milliseconds: 1600);

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

  // ==========================================================================
  // Premium 2.0: Purposeful Motion
  // ==========================================================================

  /// Tap feedback (scale 0.98 → 1.0).
  static const Duration durationTap = Duration(milliseconds: 100);

  /// Transition между экранами.
  static const Duration durationTransition = Duration(milliseconds: 300);

  /// Progress counters и bars.
  static const Duration durationProgress = Duration(milliseconds: 400);

  /// Success celebrations.
  static const Duration durationSuccess = Duration(milliseconds: 600);

  /// Standard ease-in-out curve.
  static const Curve curveStandard = Curves.easeInOut;

  /// Emphasize появление (ease-out).
  static const Curve curveEmphasize = Curves.easeOut;

  /// Decelerate для затухания.
  static const Curve curveDecelerate = Curves.decelerate;

  /// Bounce для success/celebration.
  static const Curve curveBounce = Curves.elasticOut;

  /// Scale для tap feedback.
  static const double tapScaleDown = 0.98;
  static const double tapScaleUp = 1.0;
}
