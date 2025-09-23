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
}
