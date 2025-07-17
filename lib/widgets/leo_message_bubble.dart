import 'package:flutter/material.dart';
import 'package:online_course/theme/color.dart';

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
    final bubbleColor =
        isUser ? AppColor.primary.withOpacity(0.9) : Colors.grey.shade200;
    final textColor = isUser ? Colors.white : Colors.black87;
    final alignment =
        isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.circular(12).copyWith(
              topLeft: Radius.circular(isUser ? 12 : 0),
              topRight: Radius.circular(isUser ? 0 : 12),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 15),
          ),
        ),
      ],
    );
  }
}
