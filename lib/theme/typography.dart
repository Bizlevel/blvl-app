import 'package:flutter/material.dart';

/// Базовая типографика BizLevel
class AppTypography {
  AppTypography._();

  static TextTheme textTheme = const TextTheme(
    displayLarge:
        TextStyle(fontSize: 34, fontWeight: FontWeight.w700, height: 1.2),
    displayMedium:
        TextStyle(fontSize: 30, fontWeight: FontWeight.w700, height: 1.25),
    displaySmall:
        TextStyle(fontSize: 26, fontWeight: FontWeight.w700, height: 1.25),
    headlineLarge:
        TextStyle(fontSize: 24, fontWeight: FontWeight.w600, height: 1.25),
    headlineMedium:
        TextStyle(fontSize: 22, fontWeight: FontWeight.w600, height: 1.25),
    headlineSmall:
        TextStyle(fontSize: 20, fontWeight: FontWeight.w600, height: 1.25),
    titleLarge:
        TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 1.3),
    titleMedium:
        TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.3),
    titleSmall:
        TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.3),
    bodyLarge:
        TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5),
    bodyMedium:
        TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5),
    bodySmall:
        TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.5),
    labelLarge:
        TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.2),
    labelMedium:
        TextStyle(fontSize: 12, fontWeight: FontWeight.w600, height: 1.2),
    labelSmall:
        TextStyle(fontSize: 11, fontWeight: FontWeight.w600, height: 1.2),
  );

  // Семантические стили под дизайн-документ
  static const TextStyle headingScreen =
      TextStyle(fontSize: 22, fontWeight: FontWeight.w700, height: 1.3);
  static const TextStyle headingSection =
      TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 1.3);
  static const TextStyle headingCard =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.4);
  static const TextStyle bodyDefault =
      TextStyle(fontSize: 15, fontWeight: FontWeight.w400, height: 1.5);
  static const TextStyle bodySmall =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.4);
  static const TextStyle caption =
      TextStyle(fontSize: 13, fontWeight: FontWeight.w400, height: 1.3);
  static const TextStyle captionSmall =
      TextStyle(fontSize: 11, fontWeight: FontWeight.w500, height: 1.2);
  static const TextStyle quote = TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w400,
      height: 1.5,
      fontStyle: FontStyle.italic);
  static const TextStyle number =
      TextStyle(fontFeatures: [FontFeature.tabularFigures()]);

  // ==========================================================================
  // Premium 2.0: Enhanced Typography
  // ==========================================================================

  /// Заголовок экрана (28-32px, Bold) — для AppBar и hero sections.
  static const TextStyle screenTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
  );

  /// Заголовок карточки (18-20px, Semibold) — для BizLevelCard titles.
  static const TextStyle cardTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  /// Overline (11px, CAPS, Semibold) — для меток категорий и тегов.
  static const TextStyle overline = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 1.2,
  );

  /// Большие числа (для статистики, прогресса).
  static const TextStyle statNumber = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.1,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// Мелкий текст для подсказок.
  static const TextStyle hint = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );
}
