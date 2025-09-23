import 'package:flutter/material.dart';
import 'package:bizlevel/widgets/common/bizlevel_chat_bubble.dart';

/// Бабл сообщения в диалоге с Leo
class LeoMessageBubble extends StatelessWidget {
  const LeoMessageBubble({
    super.key,
    required this.text,
    required this.isUser,
  });

  final String text;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return BizLevelChatBubble(
      text: text,
      role: isUser ? ChatBubbleRole.user : ChatBubbleRole.assistant,
    );
  }
}
