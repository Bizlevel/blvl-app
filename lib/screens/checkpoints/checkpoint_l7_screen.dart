import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/providers/checkpoints_provider.dart';
import 'package:bizlevel/screens/leo_dialog_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:bizlevel/widgets/reminders_settings_sheet.dart';
import 'package:bizlevel/widgets/common/bizlevel_card.dart';
import 'package:bizlevel/widgets/common/bizlevel_button.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/color.dart';

class CheckpointL7Screen extends ConsumerWidget {
  const CheckpointL7Screen({super.key});

  String _pluralDays(int d) {
    if (d % 10 == 1 && d % 100 != 11) return 'день';
    if (d % 10 >= 2 && d % 10 <= 4 && (d % 100 < 10 || d % 100 >= 20)) {
      return 'дня';
    }
    return 'дней';
  }

  String _goalLine(Map<String, dynamic>? goal) {
    final String goalText = (goal?['goal_text'] ?? '').toString().trim();
    final String tdStr = (goal?['target_date'] ?? '').toString();
    final DateTime? td = DateTime.tryParse(tdStr)?.toLocal();
    if (goalText.isEmpty) return 'цель пока не задана';
    if (td == null) return goalText;
    final left = td.difference(DateTime.now()).inDays;
    final leftRu = left > 0 ? '$left ${_pluralDays(left)}' : 'срок не задан';
    return '$goalText (дедлайн: ${td.toIso8601String().split('T').first}, осталось: $leftRu)';
  }

  String _recentSkillsComment(List<Map<String, dynamic>> items) {
    final DateTime now = DateTime.now();
    final DateTime from = now.subtract(const Duration(days: 7));
    int recent = 0;
    for (final m in items) {
      final DateTime? ts =
          DateTime.tryParse((m['applied_at'] ?? '').toString());
      if (ts != null && ts.isAfter(from)) recent++;
    }
    if (recent >= 5)
      return 'За последнюю неделю ты применял навыки $recent раз. Отличный темп!';
    if (recent >= 2)
      return 'За последнюю неделю навыки применялись $recent раза — хороший старт.';
    if (recent == 1)
      return 'За последнюю неделю отмечено 1 применение — давай усилим регулярность.';
    return 'За последнюю неделю применений навыков не видно — начнём с небольших, но ежедневных шагов.';
  }

  List<String> _initialMessages({
    required Map<String, dynamic>? goal,
    required List<Map<String, dynamic>>? practice,
  }) {
    final g = _goalLine(goal);
    final rc = practice == null ? '' : _recentSkillsComment(practice);
    return <String>[
      [
        'Привет! Это Макс.',
        'Твоя цель $g.',
        if (rc.isNotEmpty) rc,
      ].join('\n'),
      'Регулярность — ключ к результату. Напоминания помогут удерживать фокус, а навыки презентации и планирования усилят прогресс.',
      'Настрой напоминания, чтобы каждый день двигаться к цели. \n Есть сложности с достижением твоей цели?'
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalAsync = ref.watch(userGoalProvider);
    final practiceAsync = ref.watch(practiceLogProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Чекпоинт: Система поддержки')),
      body: goalAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) =>
            const Center(child: Text('Не удалось загрузить цель')),
        data: (goal) {
          final initialMsgs = _initialMessages(
            goal: goal,
            practice: practiceAsync.maybeWhen(
                data: (list) => list, orElse: () => null),
          );
          final String userCtx = [
            if ((goal?['goal_text'] ?? '').toString().trim().isNotEmpty)
              'goal_text: ${(goal?['goal_text'] ?? '').toString().trim()}',
            if ((goal?['metric_type'] ?? '').toString().trim().isNotEmpty)
              'metric_type: ${(goal?['metric_type'] ?? '').toString().trim()}',
            if ((goal?['metric_current'] as num?) != null)
              'metric_current: ${(goal?['metric_current']).toString()}',
            if ((goal?['metric_target'] as num?) != null)
              'metric_target: ${(goal?['metric_target']).toString()}',
            if ((goal?['target_date'] ?? '').toString().isNotEmpty)
              'target_date: ${(goal?['target_date']).toString()}',
          ].join('\n');

          return Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                // Чат (как в L4)
                LayoutBuilder(
                  builder: (ctx, constraints) {
                    final screenH = MediaQuery.of(context).size.height;
                    double h = screenH * 0.7;
                    if (h < 460) h = 460;
                    if (h > 800) h = 800;
                    return SizedBox(
                      height: h,
                      child: BizLevelCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _CheckpointHeader(title: 'Чекпоинт L7'),
                            const SizedBox(height: 8),
                            Expanded(
                              child: LeoDialogScreen(
                                bot: 'max',
                                chatId: null,
                                embedded: true,
                                skipSpend: false,
                                userContext: userCtx,
                                levelContext: '',
                                initialAssistantMessages: initialMsgs,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                // Кнопки действий
                Row(
                  children: [
                    Expanded(
                      child: BizLevelButton(
                        label: 'Настроить напоминания',
                        onPressed: () => showRemindersSettingsSheet(context),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: BizLevelButton(
                        variant: BizLevelButtonVariant.outline,
                        label: 'Завершить чекпоинт →',
                        onPressed: () async {
                          try {
                            Sentry.addBreadcrumb(Breadcrumb(
                              category: 'checkpoint',
                              message: 'l7_completed',
                              level: SentryLevel.info,
                            ));
                          } catch (_) {}
                          
                          // Отмечаем чекпойнт как завершенный
                          await ref.read(checkpointsProvider.notifier).completeCheckpoint('l7');
                          
                          GoRouter.of(context).push('/tower');
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CheckpointHeader extends StatelessWidget {
  final String title;
  const _CheckpointHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage('assets/images/avatars/avatar_max.png'),
            backgroundColor: AppColor.onPrimary,
          ),
          const SizedBox(width: 8),
          Text(
            'Макс',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600, color: AppColor.onPrimary),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColor.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: AppColor.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
