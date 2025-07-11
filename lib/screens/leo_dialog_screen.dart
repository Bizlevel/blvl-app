import 'dart:async';
import 'package:flutter/material.dart';
import 'package:online_course/services/leo_service.dart';
import 'package:online_course/services/supabase_service.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/widgets/leo_message_bubble.dart';

class LeoDialogScreen extends StatefulWidget {
  final String chatId;
  const LeoDialogScreen({Key? key, required this.chatId}) : super(key: key);

  @override
  State<LeoDialogScreen> createState() => _LeoDialogScreenState();
}

class _LeoDialogScreenState extends State<LeoDialogScreen> {
  final _scrollController = ScrollController();
  final _inputController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final data = await SupabaseService.client
        .from('leo_messages')
        .select('role, content, created_at')
        .eq('chat_id', widget.chatId)
        .order('created_at');

    setState(() {
      _messages
        ..clear()
        ..addAll(data.map((e) => Map<String, dynamic>.from(e as Map)));
    });

    _scrollToBottom();
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
    final text = _inputController.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() {
      _isSending = true;
      _messages.add({
        'role': 'user',
        'content': text,
      });
    });
    _inputController.clear();
    _scrollToBottom();

    try {
      await LeoService.saveConversation(
        chatId: widget.chatId,
        role: 'user',
        content: text,
      );
      await LeoService.decrementMessageCount();

      final response =
          await LeoService.sendMessage(messages: _buildChatContext());
      final assistantMsg = response['message']['content'] as String? ?? '';

      await LeoService.saveConversation(
        chatId: widget.chatId,
        role: 'assistant',
        content: assistantMsg,
      );

      setState(() {
        _messages.add({'role': 'assistant', 'content': assistantMsg});
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _isSending = false);
      _scrollToBottom();
    }
  }

  List<Map<String, dynamic>> _buildChatContext() {
    return _messages
        .map((m) => {
              'role': m['role'],
              'content': m['content'],
            })
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
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final msg = _messages[index];
        final isUser = msg['role'] == 'user';
        return LeoMessageBubble(
            text: msg['content'] as String? ?? '', isUser: isUser);
      },
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
            IconButton(
              icon: _isSending
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.send),
              color: AppColor.primary,
              onPressed: _isSending ? null : _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
