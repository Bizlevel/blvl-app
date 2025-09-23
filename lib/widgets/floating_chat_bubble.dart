import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/screens/leo_dialog_screen.dart';
import 'package:bizlevel/providers/leo_unread_provider.dart';
import 'package:bizlevel/providers/leo_service_provider.dart';
import 'package:bizlevel/theme/color.dart';

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
class FloatingChatBubble extends ConsumerStatefulWidget {
  /// Идентификатор диалога Leo. Может быть null, если диалог ещё не создан.
  final String? chatId;

  /// Системный промпт для контекста (не сохраняется автоматически).
  final String systemPrompt;

  /// Кол-во непрочитанных сообщений (если chatId == null, бейдж не показывается).
  final int unreadCount;

  /// Дополнительный пользовательский контекст (для режима трекера и т.п.)
  final String? userContext;

  /// Дополнительный контекст уровня/экрана (опционально)
  final String? levelContext;

  /// Какого бота открыть: 'leo' (по умолчанию) или 'max'
  final String bot;

  const FloatingChatBubble(
      {super.key,
      required this.chatId,
      required this.systemPrompt,
      this.unreadCount = 0,
      this.userContext,
      this.levelContext,
      this.bot = 'leo'});

  @override
  ConsumerState<FloatingChatBubble> createState() => _FloatingChatBubbleState();
}

class _FloatingChatBubbleState extends ConsumerState<FloatingChatBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat(reverse: true);
    _pulse = Tween<double>(begin: 1.0, end: 1.1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openDialog() async {
    // Сбрасываем счётчик непрочитанных, только если диалог уже создан
    if (widget.chatId != null) {
      try {
        final service = ref.read(leoServiceProvider);
        await service.resetUnread(widget.chatId!);
      } catch (_) {}
    }

    if (!mounted) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      barrierColor: Colors.black54,
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.9,
        child: LeoDialogScreen(
          chatId: widget.chatId,
          userContext: widget.userContext,
          levelContext: widget.levelContext,
          bot: widget.bot,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int unread = 0;
    if (widget.chatId != null) {
      final unreadAsync = ref.watch(leoUnreadProvider(widget.chatId!));
      unread = unreadAsync.when(
        data: (v) => v,
        loading: () => widget.unreadCount,
        error: (_, __) => widget.unreadCount,
      );
    }
    return ScaleTransition(
      scale: _pulse,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          FloatingActionButton.extended(
            backgroundColor: AppColor.primary,
            onPressed: _openDialog,
            icon: CircleAvatar(
              radius: 10,
              backgroundImage: AssetImage(widget.bot == 'max'
                  ? 'assets/images/avatars/avatar_max.png'
                  : 'assets/images/avatars/avatar_leo.png'),
              backgroundColor: Colors.transparent,
            ),
            label: Text(
              widget.bot == 'max' ? 'Новый чат с Максом' : 'Новый чат с Лео',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
          if (unread > 0)
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                    color: Colors.red, shape: BoxShape.circle),
                child: Text(
                  '$unread',
                  style: const TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
