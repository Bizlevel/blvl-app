import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/theme/spacing.dart';

class ChatColors {
  final Color userBg;
  final Color aiBg;
  final Color systemBg;
  final Color userText;
  final Color aiText;
  const ChatColors({
    required this.userBg,
    required this.aiBg,
    required this.systemBg,
    required this.userText,
    required this.aiText,
  });
}

class BubbleStyle {
  final BorderRadius radius;
  final EdgeInsets padding;
  const BubbleStyle({required this.radius, required this.padding});
}

class ChatTheme extends ThemeExtension<ChatTheme> {
  final ChatColors colors;
  final BubbleStyle bubbleStyle;

  const ChatTheme({
    required this.colors,
    required this.bubbleStyle,
  });

  static ChatTheme light(ColorScheme cs) => ChatTheme(
        colors: ChatColors(
          userBg: cs.primaryContainer,
          aiBg: AppColor.surface,
          systemBg: cs.surfaceContainerHighest,
          userText: cs.onPrimaryContainer,
          aiText: cs.onSurface,
        ),
        bubbleStyle: BubbleStyle(
          radius: BorderRadius.circular(AppDimensions.radiusLg),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
      );

  static ChatTheme dark(ColorScheme cs) => ChatTheme(
        colors: ChatColors(
          userBg: cs.primaryContainer,
          aiBg: AppColor.surfaceDark,
          systemBg: cs.surfaceContainerHighest,
          userText: cs.onPrimaryContainer,
          aiText: AppColor.textDark,
        ),
        bubbleStyle: BubbleStyle(
          radius: BorderRadius.circular(AppDimensions.radiusLg),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
      );

  @override
  ChatTheme copyWith({
    ChatColors? colors,
    BubbleStyle? bubbleStyle,
  }) {
    return ChatTheme(
      colors: colors ?? this.colors,
      bubbleStyle: bubbleStyle ?? this.bubbleStyle,
    );
  }

  @override
  ChatTheme lerp(ThemeExtension<ChatTheme>? other, double t) {
    if (other is! ChatTheme) return this;
    return ChatTheme(
      colors: ChatColors(
        userBg: Color.lerp(colors.userBg, other.colors.userBg, t)!,
        aiBg: Color.lerp(colors.aiBg, other.colors.aiBg, t)!,
        systemBg: Color.lerp(colors.systemBg, other.colors.systemBg, t)!,
        userText: Color.lerp(colors.userText, other.colors.userText, t)!,
        aiText: Color.lerp(colors.aiText, other.colors.aiText, t)!,
      ),
      bubbleStyle: BubbleStyle(
        radius:
            BorderRadius.lerp(bubbleStyle.radius, other.bubbleStyle.radius, t)!,
        padding:
            EdgeInsets.lerp(bubbleStyle.padding, other.bubbleStyle.padding, t)!,
      ),
    );
  }
}
