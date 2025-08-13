import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:bizlevel/providers/leo_service_provider.dart';
import 'package:bizlevel/widgets/chat_item.dart';
import 'package:bizlevel/screens/leo_dialog_screen.dart';

import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/providers/auth_provider.dart';

class LeoChatScreen extends ConsumerStatefulWidget {
  const LeoChatScreen({super.key});

  @override
  ConsumerState<LeoChatScreen> createState() => _LeoChatScreenState();
}

class _LeoChatScreenState extends ConsumerState<LeoChatScreen> {
  String _activeBot = 'leo'; // 'leo' | 'alex'
  late Future<void> _loadFuture;
  int _messagesLeft = 0;
  List<Map<String, dynamic>> _chats = [];

  @override
  void initState() {
    super.initState();
    _loadFuture = _loadData();
  }

  Future<void> _loadData() async {
    try {
      final leo = ref.read(leoServiceProvider);
      // Параллельно получаем лимит сообщений и список чатов
      final limitFuture = leo.checkMessageLimit();
      final chatsFuture = Supabase.instance.client
          .from('leo_chats')
          .select('id, title, updated_at, message_count, bot')
          .eq('bot', _activeBot)
          .gt('message_count', 0)
          .order('updated_at', ascending: false);

      _messagesLeft = await limitFuture;
      final rawChats = await chatsFuture;
      _chats =
          rawChats.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      // silently ignore, UI отобразит пустые данные
    }
    if (mounted) setState(() {});
  }

  String? _getUserContext() {
    final user = ref.read(currentUserProvider).value;
    if (user != null) {
      return '${user.name} ${user.about} ${user.goal}'.trim();
    }
    return null;
  }

  String? _getLevelContext() {
    // Получить текущий уровень пользователя
    final user = ref.read(currentUserProvider).value;
    if (user != null) return 'Уровень ${user.currentLevel}';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColor.primary,
        onPressed: _onNewChat,
        icon: const Icon(Icons.add_comment),
        label: Text(
          _activeBot == 'alex' ? 'Новый диалог с Алекс' : 'Новый диалог с Лео',
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: FutureBuilder<void>(
        future: _loadFuture,
        builder: (context, snapshot) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                _buildHeader(context),
                const SizedBox(height: 8),
                _buildBotSwitcher(),
                const SizedBox(height: 10),
                _buildChats(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 60, 0, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Блок с аватаром и подзаголовком
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: const AssetImage(
                        'assets/images/avatars/avatar_leo.png'),
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Leo AI',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Твой бизнес-ментор',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                _activeBot == 'alex'
                    ? '$_messagesLeft сообщений Алекс'
                    : '$_messagesLeft сообщений Leo',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
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
          // без image, чтобы не отображать иконку в списке
          'notify': 0,
        };
        return ChatItem(
          chatData,
          isNotified: false,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => LeoDialogScreen(
                  chatId: chat['id'],
                  userContext: _getUserContext(),
                  levelContext: _getLevelContext(),
                  bot: _activeBot,
                ),
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
        builder: (_) => LeoDialogScreen(
          userContext: _getUserContext(),
          levelContext: _getLevelContext(),
          bot: _activeBot,
        ),
      ),
    );
  }

  Widget _buildBotSwitcher() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChoiceChip(
          label: const Text('Лео'),
          selected: _activeBot == 'leo',
          onSelected: (sel) {
            if (!sel) return;
            setState(() => _activeBot = 'leo');
            _loadData();
          },
        ),
        const SizedBox(width: 8),
        ChoiceChip(
          label: const Text('Алекс'),
          selected: _activeBot == 'alex',
          onSelected: (sel) {
            if (!sel) return;
            setState(() => _activeBot = 'alex');
            _loadData();
          },
        ),
      ],
    );
  }
}
