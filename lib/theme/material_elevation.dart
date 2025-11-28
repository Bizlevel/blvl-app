import 'package:flutter/material.dart';

/// Тональное «возвышение» поверхностей (Material 3):
/// добавляет примесь primary к surface.
class MaterialElevation {
  static Color surfaceAt(ColorScheme cs, int level) {
    final double opacity = (level.clamp(0, 4)) * 0.06; // 6% на уровень
    return Color.alphaBlend(cs.primary.withValues(alpha: opacity), cs.surface);
  }
}


