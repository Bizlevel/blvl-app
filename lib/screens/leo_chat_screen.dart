import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:bizlevel/providers/leo_service_provider.dart';
import 'package:bizlevel/widgets/chat_item.dart';
import 'package:bizlevel/screens/leo_dialog_screen.dart';
import 'package:bizlevel/screens/ray_dialog_screen.dart';
import 'package:bizlevel/widgets/common/bizlevel_card.dart';

import 'package:bizlevel/theme/color.dart' show AppColor;
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/services/context_service.dart';
import 'package:bizlevel/theme/spacing.dart';

class LeoChatScreen extends ConsumerStatefulWidget {
  const LeoChatScreen({super.key});

  @override
  ConsumerState<LeoChatScreen> createState() => _LeoChatScreenState();
}

class _LeoChatScreenState extends ConsumerState<LeoChatScreen> {
  late Future<void> _loadFuture;
  // int _messagesLeft = 0; // удалено из UI, поле оставлено закомментированным для возможного возврата
  List<Map<String, dynamic>> _chats = [];

  @override
  void initState() {
    super.initState();
    try {
      Sentry.addBreadcrumb(Breadcrumb(
        category: 'ui.screen',
        level: SentryLevel.info,
        message: 'mentors_opened',
      ));
    } catch (_) {}
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

  Future<String?> _getUserContext() async =>
      ContextService.buildUserContext(ref.read(currentUserProvider).value);

  Future<String?> _getLevelContext() async =>
      ContextService.buildLevelContext(ref.read(currentUserProvider).value);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Менторы')),
      body: FutureBuilder<void>(
        future: _loadFuture,
        builder: (context, snapshot) {
          return SingleChildScrollView(
            padding:
                AppSpacing.insetsSymmetric(h: AppSpacing.lg, v: AppSpacing.sm),
            child: Column(
              children: [
                AppSpacing.gapH(AppSpacing.xs),
                _buildBotSelectorCards(),
                AppSpacing.gapH(AppSpacing.s10),
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

        final String botRaw = (chat['bot'] as String?)?.toLowerCase() ?? 'leo';
        final String bot = ['leo', 'max', 'ray'].contains(botRaw) ? botRaw : 'leo';
        final String botLabel =
            bot == 'max'
                ? 'Max AI'
                : bot == 'ray'
                    ? 'Ray AI'
                    : 'Leo AI';
        final String avatarPath = bot == 'max'
            ? 'assets/images/avatars/avatar_max.png'
            : bot == 'ray'
                ? 'assets/images/avatars/avatar_12.png'
                : 'assets/images/avatars/avatar_leo.png';

        final chatData = {
          'name': chat['title'] ?? 'Диалог',
          'last_text': '${chat['message_count']} сообщений',
          'date': formattedDate,
          'image': avatarPath,
          'botLabel': botLabel,
          'notify': 0,
        };
        return ChatItem(
          chatData,
          isNotified: false,
          onTap: () {
            try {
              Sentry.addBreadcrumb(Breadcrumb(
                category: 'chat',
                level: SentryLevel.info,
                message: 'chat_opened',
                data: {
                  'bot': bot,
                  'chatId': chat['id']?.toString() ?? '',
                },
              ));
            } catch (_) {}
            if (bot == 'ray') {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RayDialogScreen(chatId: chat['id'] as String?),
                ),
              );
              return;
            }

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => FutureBuilder<List<String?>>(
                    future:
                        Future.wait([_getUserContext(), _getLevelContext()]),
                    builder: (context, snap) {
                      final userCtx =
                          (snap.data != null) ? snap.data![0] : null;
                      final lvlCtx = (snap.data != null) ? snap.data![1] : null;
                      return LeoDialogScreen(
                        chatId: chat['id'],
                        userContext: userCtx,
                        levelContext: lvlCtx,
                        bot: bot,
                      );
                    }),
              ),
            );
          },
        );
      },
    );
  }

  void _onNewChat(String bot) {
    try {
      Sentry.addBreadcrumb(Breadcrumb(
        category: 'chat',
        level: SentryLevel.info,
        message: 'chat_new_started',
        data: {'bot': bot},
      ));
    } catch (_) {}
    if (bot == 'ray') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const RayDialogScreen(),
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FutureBuilder<List<String?>>(
          future: Future.wait([_getUserContext(), _getLevelContext()]),
          builder: (context, snap) {
            final userCtx = (snap.data != null) ? snap.data![0] : null;
            final lvlCtx = (snap.data != null) ? snap.data![1] : null;
            return LeoDialogScreen(
              userContext: userCtx,
              levelContext: lvlCtx,
              bot: bot,
            );
          },
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
      return Padding(
        padding: AppSpacing.insetsSymmetric(v: AppSpacing.s6),
        child: BizLevelCard(
          onTap: () => _onNewChat(bot),
          outlined: true,
          tonal: true,
          padding: AppSpacing.insetsAll(AppSpacing.md),
          semanticsLabel: 'Начать чат с $name',
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 112),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundImage: AssetImage(avatar),
                  backgroundColor: AppColor.surface.withValues(alpha: 0.0),
                ),
                AppSpacing.gapW(AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      AppSpacing.gapH(AppSpacing.xxs),
                      Text(
                        subtitle,
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: AppColor.labelColor),
                      ),
                      AppSpacing.gapH(AppSpacing.sm),
                      Text(
                        'Начать чат',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColor.primary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
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
        buildCard(
          bot: 'ray',
          name: 'Ray AI',
          subtitle: 'Проверь идею на прочность',
          avatar: 'assets/images/avatars/avatar_12.png',
        ),
      ],
    );
  }
}
