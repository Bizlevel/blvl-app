import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/providers/leo_service_provider.dart';
import 'package:bizlevel/widgets/chat_item.dart';
import 'package:bizlevel/screens/leo_dialog_screen.dart';

class LeoChatScreen extends ConsumerStatefulWidget {
  const LeoChatScreen({super.key});

  @override
  ConsumerState<LeoChatScreen> createState() => _LeoChatScreenState();
}

class _LeoChatScreenState extends ConsumerState<LeoChatScreen> {
  late Future<void> _loadFuture;
  int _messagesLeft = 0;
  List<Map<String, dynamic>> _chats = [];

  @override
  void initState() {
    super.initState();
    _loadFuture = _loadData();
  }

  Future<void> _loadData() async {
    // Fetch messages limit & chats in parallel
    try {
      final leo = ref.read(leoServiceProvider);
      final limitFuture = leo.checkMessageLimit();
      _messagesLeft = await limitFuture;
      final rawChats = await Supabase.instance.client
          .from('leo_chats')
          .select('id, title, updated_at, message_count')
          .gt('message_count', 0)
          .order('updated_at', ascending: false);
      _chats =
          rawChats.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      // ignore errors for now
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadFuture,
      builder: (context, snapshot) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 10),
              _buildChats(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 60, 0, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Leo AI',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ElevatedButton(
                onPressed: _onNewChat,
                child: const Text('Новый диалог'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Осталось $_messagesLeft сообщений',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildChats() {
    if (_chats.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 50),
        child: Text('История диалогов пуста'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 10),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _chats.length,
      itemBuilder: (context, index) {
        final chat = _chats[index];
        final dt = DateTime.tryParse(chat['updated_at'] as String? ?? '') ??
            DateTime.now();
        final formattedDate =
            '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}';

        final chatData = {
          'name': chat['title'] ?? 'Диалог',
          'last_text': '${chat['message_count']} сообщений',
          'date': formattedDate,
          'image': 'assets/icons/chat.svg',
          'notify': 0,
        };
        return ChatItem(
          chatData,
          isNotified: false,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => LeoDialogScreen(chatId: chat['id']),
              ),
            );
          },
        );
      },
    );
  }

  void _onNewChat() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const LeoDialogScreen(),
      ),
    );
  }
}
