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

    return Column(
      crossAxisAlignment:
          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
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
