import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/screens/leo_dialog_screen.dart';
import 'package:bizlevel/providers/leo_unread_provider.dart';
import 'package:bizlevel/providers/leo_service_provider.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/utils/custom_modal_route.dart';

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
    // ВАЖНО: Получаем все нужные данные ДО открытия диалога,
    // чтобы они не зависели от жизненного цикла FloatingChatBubble
    final leoService = ref.read(leoServiceProvider);
    
    // Сбрасываем счётчик непрочитанных, только если диалог уже создан
    if (widget.chatId != null) {
      try {
        await leoService.resetUnread(widget.chatId!);
      } catch (_) {}
    }

    if (!mounted) return;

    // ВАЖНО: Используем rootNavigator: true, чтобы диалог не уничтожался
    // при пересоздании вложенного навигатора (например, при открытии клавиатуры)
    
    // ВАЖНО: Получаем ProviderContainer из текущего контекста,
    // чтобы передать его в UncontrolledProviderScope для диалога
    // Это гарантирует, что провайдеры будут доступны даже если FloatingChatBubble умрет
    final container = ProviderScope.containerOf(context);
    
    await Navigator.of(context, rootNavigator: true).push(
      CustomModalBottomSheetRoute(
        child: UncontrolledProviderScope(
          container: container,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            // ВАЖНО: resizeToAvoidBottomInset: true, чтобы Flutter поднимал контент при появлении клавиатуры
            resizeToAvoidBottomInset: true,
            body: Stack(
              children: [
                // 1. Прозрачный слой для закрытия по тапу мимо окна
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: Container(color: Colors.transparent),
                  ),
                ),
                // 2. Контент диалога - должен перехватывать тапы и не пропускать их к прозрачному слою
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Material(
                    color: Colors.transparent,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.9,
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColor.surface,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        clipBehavior: Clip.hardEdge,
                      child: Column(
                        children: [
                          // Заголовок
                          Container(
                            color: AppColor.primary,
                            child: SafeArea(
                              bottom: false,
                              child: AppBar(
                                backgroundColor: AppColor.primary,
                                automaticallyImplyLeading: false,
                                leading: Builder(
                                  builder: (context) => IconButton(
                                    tooltip: 'Закрыть',
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      // Скрываем клавиатуру перед закрытием диалога
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      // Закрываем диалог с небольшой задержкой для закрытия клавиатуры
                                      Future.microtask(() {
                                        final navigator = Navigator.of(context, rootNavigator: true);
                                        if (navigator.canPop()) {
                                          navigator.pop();
                                        }
                                      });
                                    },
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 14,
                                      backgroundImage: AssetImage(widget.bot == 'max'
                                          ? 'assets/images/avatars/avatar_max.png'
                                          : 'assets/images/avatars/avatar_leo.png'),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(widget.bot == 'max' ? 'Макс' : 'Лео'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Тело диалога
                          Expanded(
                            child: LeoDialogScreen(
                              chatId: widget.chatId,
                              userContext: widget.userContext,
                              levelContext: widget.levelContext,
                              bot: widget.bot,
                              embedded: true, // Встроенный режим без собственного Scaffold
                            ),
                          ),
                        ],
                      ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
                  color: AppColor.onPrimary, fontWeight: FontWeight.w600),
            ),
          ),
          if (unread > 0)
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                    color: AppColor.error, shape: BoxShape.circle),
                child: Text(
                  '$unread',
                  style:
                      const TextStyle(fontSize: 10, color: AppColor.onPrimary),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
