import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/theme/typography.dart';

enum ChatBubbleRole { user, assistant, system, error }

class BizLevelChatBubble extends StatelessWidget {
  const BizLevelChatBubble({
    super.key,
    required this.text,
    required this.role,
  });

  final String text;
  final ChatBubbleRole role;

  @override
  Widget build(BuildContext context) {
    final bool isUser = role == ChatBubbleRole.user;
    final Color bg = switch (role) {
      ChatBubbleRole.user => AppColor.primary,
      ChatBubbleRole.assistant => AppColor.surface,
      ChatBubbleRole.system => AppColor.info.withValues(alpha: 0.08),
      ChatBubbleRole.error => AppColor.error.withValues(alpha: 0.08),
    };
    final Color fg = switch (role) {
      ChatBubbleRole.user => AppColor.onPrimary,
      ChatBubbleRole.assistant => AppColor.onSurface,
      ChatBubbleRole.system => AppColor.onSurface,
      ChatBubbleRole.error => AppColor.error,
    };

    // Поддержка лёгкой «эмо‑реакции» у ассистентских сообщений (без шума)
    final bool showReaction =
        role == ChatBubbleRole.assistant && text.length > 40;
    return Column(
      crossAxisAlignment:
          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (showReaction)
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.xs, bottom: 2),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              builder: (context, v, child) => Opacity(opacity: v, child: child),
              child: Text('💡', style: AppTypography.textTheme.bodySmall),
            ),
          ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          padding:
              AppSpacing.insetsSymmetric(h: AppSpacing.md, v: AppSpacing.md),
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
          decoration: BoxDecoration(
            color: role == ChatBubbleRole.assistant
                ? bg.withValues(alpha: 0.98)
                : bg,
            borderRadius:
                BorderRadius.circular(AppDimensions.radiusLg).copyWith(
              topLeft: Radius.circular(isUser ? AppDimensions.radiusLg : 0),
              topRight: Radius.circular(isUser ? 0 : AppDimensions.radiusLg),
            ),
          ),
          child: role == ChatBubbleRole.assistant
              ? MarkdownBody(
                  data: text,
                  styleSheet: MarkdownStyleSheet(
                    p: AppTypography.textTheme.bodyMedium?.copyWith(color: fg),
                    strong: AppTypography.textTheme.bodyMedium?.copyWith(
                      color: fg,
                      fontWeight: FontWeight.bold,
                    ),
                    listBullet: AppTypography.textTheme.bodyMedium?.copyWith(color: fg),
                    // Минимальные отступы для списков
                    listIndent: 16.0,
                    blockquotePadding: const EdgeInsets.all(8.0),
                    blockquoteDecoration: BoxDecoration(
                      color: bg.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  selectable: true,
                )
              : Text(
                  text,
                  style:
                      AppTypography.textTheme.bodyMedium?.copyWith(color: fg),
                ),
        ),
      ],
    );
  }
}
