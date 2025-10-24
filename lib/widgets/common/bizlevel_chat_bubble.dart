import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';

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
            padding: const EdgeInsets.only(left: 4, bottom: 2),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              builder: (context, v, child) => Opacity(opacity: v, child: child),
              child: const Text('💡', style: TextStyle(fontSize: 14)),
            ),
          ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
          decoration: BoxDecoration(
            color: role == ChatBubbleRole.assistant
                ? bg.withValues(alpha: 0.98)
                : bg,
            borderRadius: BorderRadius.circular(12).copyWith(
              topLeft: Radius.circular(isUser ? 12 : 0),
              topRight: Radius.circular(isUser ? 0 : 12),
            ),
          ),
          child: role == ChatBubbleRole.assistant
              ? SelectableText(
                  text,
                  style: TextStyle(color: fg, fontSize: 15),
                )
              : Text(
                  text,
                  style: TextStyle(color: fg, fontSize: 15),
                ),
        ),
      ],
    );
  }
}
