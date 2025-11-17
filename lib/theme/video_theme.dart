import 'package:flutter/material.dart';

class VideoColors {
  final Color controlsBg;
  final Color controlsIcon;
  final Color progressFg;
  final Color progressBg;
  final Color scrim;
  const VideoColors({
    required this.controlsBg,
    required this.controlsIcon,
    required this.progressFg,
    required this.progressBg,
    required this.scrim,
  });
}

class VideoTheme extends ThemeExtension<VideoTheme> {
  final VideoColors colors;

  const VideoTheme({
    required this.colors,
  });

  static VideoTheme light(ColorScheme cs) => VideoTheme(
        colors: VideoColors(
          controlsBg: cs.surface.withValues(alpha: 0.9),
          controlsIcon: cs.onSurface,
          progressFg: cs.primary,
          progressBg: cs.surfaceContainerHighest,
          scrim: Colors.black.withValues(alpha: 0.35),
        ),
      );

  static VideoTheme dark(ColorScheme cs) => VideoTheme(
        colors: VideoColors(
          controlsBg: cs.surface.withValues(alpha: 0.9),
          controlsIcon: cs.onSurface,
          progressFg: cs.primary,
          progressBg: cs.surfaceContainerHighest,
          scrim: Colors.black.withValues(alpha: 0.5),
        ),
      );

  @override
  VideoTheme copyWith({
    VideoColors? colors,
  }) {
    return VideoTheme(
      colors: colors ?? this.colors,
    );
  }

  @override
  VideoTheme lerp(ThemeExtension<VideoTheme>? other, double t) {
    if (other is! VideoTheme) return this;
    return VideoTheme(
      colors: VideoColors(
        controlsBg: Color.lerp(colors.controlsBg, other.colors.controlsBg, t)!,
        controlsIcon:
            Color.lerp(colors.controlsIcon, other.colors.controlsIcon, t)!,
        progressFg: Color.lerp(colors.progressFg, other.colors.progressFg, t)!,
        progressBg: Color.lerp(colors.progressBg, other.colors.progressBg, t)!,
        scrim: Color.lerp(colors.scrim, other.colors.scrim, t)!,
      ),
    );
  }
}
