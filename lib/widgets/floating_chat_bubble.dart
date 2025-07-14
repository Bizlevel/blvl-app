import 'package:flutter/material.dart';
import 'package:online_course/screens/leo_dialog_screen.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/services/leo_service.dart';

/// Floating chat bubble that opens the LeoDialogScreen.
/// Place this widget inside a [Stack] so that it can be positioned
/// at the bottom-right of the screen:
/// ```
/// Stack(
///   children: [
///     ...content,
///     const Positioned(bottom: 20, right: 20, child: FloatingChatBubble(chatId: 'your_chat_id')),
///   ],
/// );
/// ```
class FloatingChatBubble extends StatefulWidget {
  /// Supabase chat identifier. Must be non-empty.
  final String chatId;
  final String systemPrompt;

  /// Number of unread messages. If > 0, a badge is shown.
  final int unreadCount;

  const FloatingChatBubble({Key? key, required this.chatId, required this.systemPrompt, this.unreadCount = 0}) : super(key: key);

  @override
  State<FloatingChatBubble> createState() => _FloatingChatBubbleState();
}

class _FloatingChatBubbleState extends State<FloatingChatBubble> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat(reverse: true);
    _pulse = Tween<double>(begin: 1.0, end: 1.1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openDialog() async {
    if (!mounted) return;

    // Save context prompt before opening
    try {
      await LeoService.saveConversation(role: 'system', content: widget.systemPrompt, chatId: widget.chatId);
    } catch (_) {}

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.9,
        child: LeoDialogScreen(chatId: widget.chatId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _pulse,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          FloatingActionButton(
            backgroundColor: AppColor.primary,
            onPressed: _openDialog,
            child: const Icon(Icons.chat_bubble_outline),
          ),
          if (widget.unreadCount > 0)
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: Text(
                  '${widget.unreadCount}',
                  style: const TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
