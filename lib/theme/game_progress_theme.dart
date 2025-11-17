import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';

class GameProgressTheme extends ThemeExtension<GameProgressTheme> {
  final Color progressBg;
  final Color progressFg;
  final Color milestone;

  const GameProgressTheme({
    required this.progressBg,
    required this.progressFg,
    required this.milestone,
  });

  static GameProgressTheme light(ColorScheme cs) => GameProgressTheme(
        progressBg: cs.surfaceContainerHighest,
        progressFg: cs.primary,
        milestone: AppColor.premium,
      );

  static GameProgressTheme dark(ColorScheme cs) => GameProgressTheme(
        progressBg: cs.surfaceContainerHighest,
        progressFg: cs.primary,
        milestone: cs.tertiary,
      );

  @override
  GameProgressTheme copyWith({
    Color? progressBg,
    Color? progressFg,
    Color? milestone,
  }) {
    return GameProgressTheme(
      progressBg: progressBg ?? this.progressBg,
      progressFg: progressFg ?? this.progressFg,
      milestone: milestone ?? this.milestone,
    );
  }

  @override
  GameProgressTheme lerp(ThemeExtension<GameProgressTheme>? other, double t) {
    if (other is! GameProgressTheme) return this;
    return GameProgressTheme(
      progressBg: Color.lerp(progressBg, other.progressBg, t)!,
      progressFg: Color.lerp(progressFg, other.progressFg, t)!,
      milestone: Color.lerp(milestone, other.milestone, t)!,
    );
  }
}
