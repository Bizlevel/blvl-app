import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';

class GpColors {
  final Color positive;
  final Color negative;
  final Color badgeBg;
  final Color badgeText;
  final Color highlight;
  const GpColors({
    required this.positive,
    required this.negative,
    required this.badgeBg,
    required this.badgeText,
    required this.highlight,
  });
}

class GpTheme extends ThemeExtension<GpTheme> {
  final GpColors colors;

  const GpTheme({
    required this.colors,
  });

  static GpTheme light(ColorScheme cs) => const GpTheme(
        colors: GpColors(
          positive: AppColor.success,
          negative: AppColor.error,
          badgeBg: AppColor.backgroundInfo,
          badgeText: AppColor.info,
          highlight: AppColor.premium,
        ),
      );

  static GpTheme dark(ColorScheme cs) => GpTheme(
        colors: GpColors(
          positive: AppColor.success.withValues(alpha: 0.9),
          negative: AppColor.error.withValues(alpha: 0.9),
          badgeBg: cs.secondaryContainer,
          badgeText: cs.onSecondaryContainer,
          highlight: cs.tertiary,
        ),
      );

  @override
  GpTheme copyWith({
    GpColors? colors,
  }) {
    return GpTheme(
      colors: colors ?? this.colors,
    );
  }

  @override
  GpTheme lerp(ThemeExtension<GpTheme>? other, double t) {
    if (other is! GpTheme) return this;
    return GpTheme(
      colors: GpColors(
        positive: Color.lerp(colors.positive, other.colors.positive, t)!,
        negative: Color.lerp(colors.negative, other.colors.negative, t)!,
        badgeBg: Color.lerp(colors.badgeBg, other.colors.badgeBg, t)!,
        badgeText: Color.lerp(colors.badgeText, other.colors.badgeText, t)!,
        highlight: Color.lerp(colors.highlight, other.colors.highlight, t)!,
      ),
    );
  }
}
