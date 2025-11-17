import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';

/// Сборщик ColorScheme с фолбэком по контрасту.
/// Если динамическая схема (Android 12+) даёт низкий контраст текста по поверхности,
/// возвращаем безопасную схему из seed.
class DynamicThemeBuilder {
  static ColorScheme buildColorScheme(
    ColorScheme? dynamicScheme,
    Brightness brightness,
  ) {
    final ColorScheme fallback = ColorScheme.fromSeed(
        seedColor: AppColor.primary, brightness: brightness);
    if (dynamicScheme == null) return fallback;
    final ColorScheme harmonized = dynamicScheme;
    // Проверяем контраст пары onSurface/surface
    final double contrast =
        _contrastRatio(harmonized.onSurface, harmonized.surface);
    if (contrast < 4.5) {
      return fallback;
    }
    return harmonized;
  }

  /// Контраст по WCAG (примерно): (L1+0.05)/(L2+0.05), L — относительная яркость.
  static double _contrastRatio(Color a, Color b) {
    final double la = _relativeLuminance(a);
    final double lb = _relativeLuminance(b);
    final double l1 = max(la, lb);
    final double l2 = min(la, lb);
    return (l1 + 0.05) / (l2 + 0.05);
  }

  static double _relativeLuminance(Color c) {
    final int argb = c.toARGB32();
    final int r8 = (argb >> 16) & 0xff;
    final int g8 = (argb >> 8) & 0xff;
    final int b8 = (argb) & 0xff;
    double transform(int channel8bit) {
      final double s = channel8bit / 255.0;
      return s <= 0.03928
          ? s / 12.92
          : pow((s + 0.055) / 1.055, 2.4).toDouble();
    }

    final double r = transform(r8);
    final double g = transform(g8);
    final double b = transform(b8);
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }
}
