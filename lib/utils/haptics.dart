import 'package:flutter/services.dart';

/// Утилита для тактильной обратной связи (Premium 2.0).
///
/// Использует системные haptic patterns для создания
/// премиального тактильного опыта.
class AppHaptics {
  AppHaptics._();

  /// Лёгкий тап (для кнопок и карточек).
  static Future<void> tap() async {
    await HapticFeedback.lightImpact();
  }

  /// Средний тап (для важных действий).
  static Future<void> mediumTap() async {
    await HapticFeedback.mediumImpact();
  }

  /// Тяжёлый тап (для критических действий).
  static Future<void> heavyTap() async {
    await HapticFeedback.heavyImpact();
  }

  /// Success feedback (завершение уровня, достижение).
  static Future<void> success() async {
    // На iOS это вызывает success notification pattern
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.lightImpact();
  }

  /// Warning feedback (предупреждение).
  static Future<void> warning() async {
    await HapticFeedback.heavyImpact();
  }

  /// Error feedback (ошибка).
  static Future<void> error() async {
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.heavyImpact();
  }

  /// Selection changed (переключение табов, выбор опции).
  static Future<void> selection() async {
    await HapticFeedback.selectionClick();
  }

  /// GP earned (получение очков).
  static Future<void> gpEarned() async {
    await HapticFeedback.lightImpact();
  }

  /// Level complete (завершение уровня).
  static Future<void> levelComplete() async {
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 150));
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.lightImpact();
  }

  /// Achievement unlocked (разблокировка достижения).
  static Future<void> achievement() async {
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 200));
    await HapticFeedback.heavyImpact();
  }
}
