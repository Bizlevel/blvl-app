import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/providers/leo_service_provider.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/widgets/leo_message_bubble.dart';
import 'package:bizlevel/services/leo_service.dart';

/// Dialog screen for chatting with Leo assistant.
/// Supports pagination (30 messages per page), unread counter reset,
/// message limit enforcement and auto-scroll to bottom.
class LeoDialogScreen extends ConsumerStatefulWidget {
  final String? chatId;
  final String? userContext;
  final String? levelContext;
  final String bot; // 'leo' | 'alex'

  const LeoDialogScreen({
    super.key,
    this.chatId,
    this.userContext,
    this.levelContext,
    this.bot = 'leo',
  });

  @override
  ConsumerState<LeoDialogScreen> createState() => _LeoDialogScreenState();
}

class _LeoDialogScreenState extends ConsumerState<LeoDialogScreen> {
  static const _pageSize = 30;

  String? _chatId;

  final _scrollController = ScrollController();
  final _inputController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  bool _isSending = false;
  bool _isLoadingMore = false;
  bool _hasMore =
      false; // включаем пагинацию только после реальной загрузки из БД
  int _page = 0; // 0-based page counter
  int _remaining = -1; // −1 unknown

  late final LeoService _leo;

  @override
  void initState() {
    super.initState();
    _leo = ref.read(leoServiceProvider);
    _fetchRemaining();
    _chatId = widget.chatId;
    // Автоприветствие для Алекса при открытии нового диалога (не сохраняем в БД)
    if (widget.bot == 'alex' && _chatId == null && _messages.isEmpty) {
      _messages.add({
        'role': 'assistant',
        'content':
            'Я — Алекс, трекер цели BizLevel. Помогаю кристаллизовать цель и держать темп 28 дней. Напишите, чего хотите добиться — предложу ближайший шаг.',
      });
    }
    if (_chatId != null) {
      _loadMessages();
    }
  }

  Future<void> _fetchRemaining() async {
    try {
      final remaining = await _leo.checkMessageLimit();
      if (!mounted) return;
      setState(() => _remaining = remaining);
    } catch (_) {
      // ignore failure – treat as unlimited (will fail on send anyway)
    }
  }

  Future<void> _loadMessages() async {
    if (_chatId == null) return;
    final rangeStart = _page * _pageSize;
    final rangeEnd = rangeStart + _pageSize - 1;

    final data = await Supabase.instance.client
        .from('leo_messages')
        .select('role, content, created_at')
        .eq('chat_id', _chatId!)
        .order('created_at', ascending: false)
        .range(rangeStart, rangeEnd);

    final fetched = List<Map<String, dynamic>>.from(
        data.map((e) => Map<String, dynamic>.from(e as Map)));

    if (!mounted) return;
    setState(() {
      _hasMore = fetched.length == _pageSize;
      _page += 1;
      // Reverse to chronological order и добавить только новые (по роли+контенту), чтобы не дублировать
      final chronological = fetched.reversed
          .map((e) => {'role': e['role'], 'content': e['content']})
          .toList();
      final existingKeys =
          _messages.map((m) => '${m['role']}::${m['content']}').toSet();
      final toAdd = <Map<String, dynamic>>[];
      for (final m in chronological) {
        final key = '${m['role']}::${m['content']}';
        if (!existingKeys.contains(key)) {
          toAdd.add(m);
          existingKeys.add(key);
        }
      }
      if (toAdd.isNotEmpty) {
        _messages.insertAll(0, toAdd);
      }
    });

    // Auto-scroll only after first page load
    if (_page == 1) _scrollToBottom();
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() => _isLoadingMore = true);
    await _loadMessages();
    if (mounted) setState(() => _isLoadingMore = false);
  }

  void _scrollToBottom() => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });

  Future<void> _sendMessage() async {
    print('🔧 DEBUG: _sendMessage вызван');
    print('🔧 DEBUG: text = "${_inputController.text.trim()}"');
    print('🔧 DEBUG: _isSending = $_isSending');
    print('🔧 DEBUG: _remaining = $_remaining');

    // Check limit
    if (_remaining == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Лимит сообщений исчерпан')));
      return;
    }

    final text = _inputController.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() {
      _isSending = true;
      _messages.add({'role': 'user', 'content': text});
    });
    _inputController.clear();
    _scrollToBottom();

    try {
      // Save user message & decrement limit atomically
      if (_chatId == null) {
        // создаём диалог при первом сообщении
        _chatId = await _leo.saveConversation(
            role: 'user', content: text, bot: widget.bot);
        // сразу загрузим (чтобы появился счётчик и т.д.)
      } else {
        await _leo.saveConversation(
            chatId: _chatId, role: 'user', content: text);
      }
      final rem = await _leo.decrementMessageCount();
      if (mounted) setState(() => _remaining = rem);

      // Get assistant response with RAG if context is available
      String assistantMsg;

      print('🔧 DEBUG: userContext = "${widget.userContext}"');
      print('🔧 DEBUG: levelContext = "${widget.levelContext}"');
      print(
          '🔧 DEBUG: userContext.isNotEmpty = ${widget.userContext?.isNotEmpty}');
      print(
          '🔧 DEBUG: levelContext.isNotEmpty = ${widget.levelContext?.isNotEmpty}');

      // Единый вызов: сервер выполнит RAG + персонализацию при необходимости
      final response = await _leo.sendMessageWithRAG(
        messages: _buildChatContext(),
        userContext: widget.userContext ?? '',
        levelContext: widget.levelContext ?? '',
        bot: widget.bot,
      );
      assistantMsg = response['message']['content'] as String? ?? '';

      await _leo.saveConversation(
          chatId: _chatId, role: 'assistant', content: assistantMsg);

      if (!mounted) return;
      setState(() {
        _messages.add({'role': 'assistant', 'content': assistantMsg});
      });
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  List<Map<String, dynamic>> _buildChatContext() {
    return _messages
        .map((m) => {'role': m['role'], 'content': m['content']})
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        title: Text(widget.bot == 'alex' ? 'Диалог с Алекс' : 'Диалог с Leo'),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return NotificationListener<ScrollNotification>(
      onNotification: (notif) {
        if (notif.metrics.pixels <= 50 && _hasMore) {
          _loadMore();
        }
        return false;
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: _messages.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (_hasMore && index == 0) {
            return Center(
              child: _isLoadingMore
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator())
                  : TextButton(
                      onPressed: _loadMore, child: const Text('Загрузить ещё')),
            );
          }
          final msgIndex = _hasMore ? index - 1 : index;
          final msg = _messages[msgIndex];
          final isUser = msg['role'] == 'user';
          return LeoMessageBubble(
              text: msg['content'] as String? ?? '', isUser: isUser);
        },
      ),
    );
  }

  Widget _buildInput() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _inputController,
                minLines: 1,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Введите сообщение...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _isSending
                ? const SizedBox(
                    width: 24, height: 24, child: CircularProgressIndicator())
                : IconButton(
                    icon: const Icon(Icons.send),
                    color: AppColor.primary,
                    onPressed: _sendMessage,
                  ),
          ],
        ),
      ),
    );
  }
}
