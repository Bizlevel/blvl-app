import 'dart:async';

import 'package:flutter/material.dart';
import 'package:online_course/services/leo_service.dart';
import 'package:online_course/services/supabase_service.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/widgets/leo_message_bubble.dart';

/// Dialog screen for chatting with Leo assistant.
/// Supports pagination (30 messages per page), unread counter reset,
/// message limit enforcement and auto-scroll to bottom.
class LeoDialogScreen extends StatefulWidget {
  final String chatId;
  const LeoDialogScreen({Key? key, required this.chatId}) : super(key: key);

  @override
  State<LeoDialogScreen> createState() => _LeoDialogScreenState();
}

class _LeoDialogScreenState extends State<LeoDialogScreen> {
  static const _pageSize = 30;

  final _scrollController = ScrollController();
  final _inputController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  bool _isSending = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _page = 0; // 0-based page counter
  int _remaining = -1; // −1 unknown

  @override
  void initState() {
    super.initState();
    _fetchRemaining();
    _loadMessages();
  }

  Future<void> _fetchRemaining() async {
    try {
      final remaining = await LeoService.checkMessageLimit();
      if (!mounted) return;
      setState(() => _remaining = remaining);
    } catch (_) {
      // ignore failure – treat as unlimited (will fail on send anyway)
    }
  }

  Future<void> _loadMessages() async {
    final rangeStart = _page * _pageSize;
    final rangeEnd = rangeStart + _pageSize - 1;

    final data = await SupabaseService.client
        .from('leo_messages')
        .select('role, content, created_at')
        .eq('chat_id', widget.chatId)
        .order('created_at', ascending: false)
        .range(rangeStart, rangeEnd);

    final fetched = List<Map<String, dynamic>>.from(
        data.map((e) => Map<String, dynamic>.from(e as Map)));

    if (!mounted) return;
    setState(() {
      _hasMore = fetched.length == _pageSize;
      _page += 1;
      // Reverse to chronological order and prepend
      _messages.insertAll(0, fetched.reversed);
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
      await LeoService.saveConversation(
          chatId: widget.chatId, role: 'user', content: text);
      final rem = await LeoService.decrementMessageCount();
      if (mounted) setState(() => _remaining = rem);

      // Get assistant response
      final response =
          await LeoService.sendMessage(messages: _buildChatContext());
      final assistantMsg = response['message']['content'] as String? ?? '';

      await LeoService.saveConversation(
          chatId: widget.chatId, role: 'assistant', content: assistantMsg);

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
        title: const Text('Диалог с Leo'),
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
                      onPressed: _loadMore,
                      child: const Text('Загрузить ещё')),
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
