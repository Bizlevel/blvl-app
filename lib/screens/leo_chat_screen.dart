import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:bizlevel/providers/leo_service_provider.dart';
import 'package:bizlevel/widgets/chat_item.dart';
import 'package:bizlevel/screens/leo_dialog_screen.dart';

import 'package:bizlevel/theme/color.dart' show AppColor;
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/theme/spacing.dart';

class LeoChatScreen extends ConsumerStatefulWidget {
  const LeoChatScreen({super.key});

  @override
  ConsumerState<LeoChatScreen> createState() => _LeoChatScreenState();
}

class _LeoChatScreenState extends ConsumerState<LeoChatScreen> {
  String _activeBot = 'leo'; // 'leo' | 'max'
  late Future<void> _loadFuture;
  // int _messagesLeft = 0; // удалено из UI, поле оставлено закомментированным для возможного возврата
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

      await limitFuture; // лимит более не выводится в UI
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
      final contextParts = <String>[];

      if (user.goal?.isNotEmpty == true) {
        contextParts.add('Цель: ${user.goal}');
      }
      if (user.about?.isNotEmpty == true) {
        contextParts.add('О себе: ${user.about}');
      }
      final currentLevel = user.currentLevel;
      contextParts.add('Текущий уровень: $currentLevel');

      return contextParts.isNotEmpty ? contextParts.join('. ') : null;
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
      appBar: AppBar(title: const Text('База тренеров')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColor.primary,
        onPressed: _onNewChat,
        icon: CircleAvatar(
          radius: 12,
          backgroundImage: AssetImage(_activeBot == 'max'
              ? 'assets/images/avatars/avatar_max.png'
              : 'assets/images/avatars/avatar_leo.png'),
          backgroundColor: Colors.transparent,
        ),
        label: Text(
          _activeBot == 'max' ? 'Новый чат с Максом' : 'Новый чат с Лео',
          style: const TextStyle(
              color: AppColor.onPrimary, fontWeight: FontWeight.w600),
        ),
      ),
      body: FutureBuilder<void>(
        future: _loadFuture,
        builder: (context, snapshot) {
          return SingleChildScrollView(
            padding: AppSpacing.insetsSymmetric(h: 15, v: 8),
            child: Column(
              children: [
                AppSpacing.gapH(4),
                _buildBotSelectorCards(),
                AppSpacing.gapH(10),
                _buildChats(),
              ],
            ),
          );
        },
      ),
    );
  }

  // Header with avatar/subtitle was removed (duplicated UX)

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

  Widget _buildBotSelectorCards() {
    Widget buildCard(
        {required String bot,
        required String name,
        required String subtitle,
        required String avatar}) {
      final bool active = _activeBot == bot;
      return Expanded(
        child: GestureDetector(
          onTap: () {
            if (_activeBot == bot) return;
            setState(() => _activeBot = bot);
            _loadData();
          },
          child: Container(
            padding: AppSpacing.insetsAll(12),
            margin: AppSpacing.insetsSymmetric(h: 6),
            constraints: const BoxConstraints(minHeight: 100),
            decoration: BoxDecoration(
              color: active ? AppColor.surface : AppColor.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: active ? AppColor.primary : Colors.grey.shade300,
                  width: active ? 2 : 1),
              boxShadow: const [
                BoxShadow(
                  color: AppColor.shadowColor,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: AssetImage(avatar),
                  backgroundColor: Colors.transparent,
                ),
                AppSpacing.gapW(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      AppSpacing.gapH(2),
                      Text(
                        subtitle,
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, color: AppColor.labelColor),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildCard(
          bot: 'leo',
          name: 'Leo AI',
          subtitle: 'Твой бизнес‑ментор',
          avatar: 'assets/images/avatars/avatar_leo.png',
        ),
        buildCard(
          bot: 'max',
          name: 'Max AI',
          subtitle: 'Твой помощник в достижении цели',
          avatar: 'assets/images/avatars/avatar_max.png',
        ),
      ],
    );
  }
}
