import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/theme/spacing.dart';

class QuizColors {
  final Color optionBg;
  final Color selectedBg;
  final Color correctBg;
  final Color incorrectBg;
  final Color borderColor;
  const QuizColors({
    required this.optionBg,
    required this.selectedBg,
    required this.correctBg,
    required this.incorrectBg,
    required this.borderColor,
  });
}

class OptionStyle {
  final BorderRadius radius;
  final EdgeInsets padding;
  const OptionStyle({required this.radius, required this.padding});
}

class QuizTheme extends ThemeExtension<QuizTheme> {
  final QuizColors colors;
  final OptionStyle optionStyle;

  const QuizTheme({
    required this.colors,
    required this.optionStyle,
  });

  static QuizTheme light(ColorScheme cs) => QuizTheme(
        colors: QuizColors(
          optionBg: cs.surface,
          selectedBg: cs.secondaryContainer,
          correctBg: AppColor.backgroundSuccess,
          incorrectBg: AppColor.backgroundError,
          borderColor: AppColor.borderStrong,
        ),
        optionStyle: OptionStyle(
          radius: BorderRadius.circular(AppDimensions.radiusMd),
          padding: const EdgeInsets.all(AppSpacing.md),
        ),
      );

  static QuizTheme dark(ColorScheme cs) => QuizTheme(
        colors: QuizColors(
          optionBg: cs.surface,
          selectedBg: cs.secondaryContainer,
          correctBg: AppColor.success.withValues(alpha: 0.15),
          incorrectBg: AppColor.error.withValues(alpha: 0.15),
          borderColor: cs.outlineVariant,
        ),
        optionStyle: OptionStyle(
          radius: BorderRadius.circular(AppDimensions.radiusMd),
          padding: const EdgeInsets.all(AppSpacing.md),
        ),
      );

  @override
  QuizTheme copyWith({
    QuizColors? colors,
    OptionStyle? optionStyle,
  }) {
    return QuizTheme(
      colors: colors ?? this.colors,
      optionStyle: optionStyle ?? this.optionStyle,
    );
  }

  @override
  QuizTheme lerp(ThemeExtension<QuizTheme>? other, double t) {
    if (other is! QuizTheme) return this;
    return QuizTheme(
      colors: QuizColors(
        optionBg: Color.lerp(colors.optionBg, other.colors.optionBg, t)!,
        selectedBg: Color.lerp(colors.selectedBg, other.colors.selectedBg, t)!,
        correctBg: Color.lerp(colors.correctBg, other.colors.correctBg, t)!,
        incorrectBg:
            Color.lerp(colors.incorrectBg, other.colors.incorrectBg, t)!,
        borderColor:
            Color.lerp(colors.borderColor, other.colors.borderColor, t)!,
      ),
      optionStyle: OptionStyle(
        radius:
            BorderRadius.lerp(optionStyle.radius, other.optionStyle.radius, t)!,
        padding:
            EdgeInsets.lerp(optionStyle.padding, other.optionStyle.padding, t)!,
      ),
    );
  }
}
