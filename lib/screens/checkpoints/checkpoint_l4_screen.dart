import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/providers/goals_providers.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:bizlevel/screens/leo_dialog_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:bizlevel/widgets/common/bizlevel_card.dart';
import 'package:bizlevel/widgets/common/bizlevel_button.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/color.dart';

class CheckpointL4Screen extends ConsumerStatefulWidget {
  const CheckpointL4Screen({super.key});

  @override
  ConsumerState<CheckpointL4Screen> createState() => _CheckpointL4ScreenState();
}

class _CheckpointL4ScreenState extends ConsumerState<CheckpointL4Screen> {
  String _buildGoalLine(Map<String, dynamic>? goal) {
    final String goalText = (goal?['goal_text'] ?? '').toString().trim();
    final String tdStr = (goal?['target_date'] ?? '').toString();
    final DateTime? td = DateTime.tryParse(tdStr)?.toLocal();
    String timePart = '';
    if (td != null) {
      final left = td.difference(DateTime.now()).inDays;
      final String leftRu =
          left > 0 ? '$left ${_pluralDays(left)}' : 'срок не задан';
      timePart =
          ' (дедлайн: ${td.toIso8601String().split('T').first}, осталось: $leftRu)';
    }
    return goalText.isEmpty ? 'цель пока не задана' : '$goalText$timePart';
  }

  String _pluralDays(int d) {
    if (d % 10 == 1 && d % 100 != 11) return 'день';
    if (d % 10 >= 2 && d % 10 <= 4 && (d % 100 < 10 || d % 100 >= 20)) {
      return 'дня';
    }
    return 'дней';
  }

  String _regularityComment(List<Map<String, dynamic>> items) {
    final DateTime now = DateTime.now();
    final DateTime from = now.subtract(const Duration(days: 7));
    int recent = 0;
    for (final m in items) {
      final DateTime? ts =
          DateTime.tryParse((m['applied_at'] ?? '').toString());
      if (ts != null && ts.isAfter(from)) recent++;
    }
    if (recent >= 4) {
      return 'Вижу, что навыки отмечались $recent раз за последние 7 дней — это хороший темп.';
    } else if (recent > 0) {
      return 'Вижу небольшую активность по навыкам: $recent раз за последние 7 дней — усилим регулярность.';
    } else {
      return 'Не вижу применений навыков за последнюю неделю — начнём с мини‑шагов и ежедневной отметки.';
    }
  }

  List<String> _composeInitialMessages({
    required Map<String, dynamic>? goal,
    required List<Map<String, dynamic>>? practice,
  }) {
    final goalLine = _buildGoalLine(goal);
    final regLine = practice == null ? '' : _regularityComment(practice);
    return <String>[
      // 1: про цель и навыки
      [
        'Привет!',
        'Твоя цель $goalLine.',
        if (regLine.isNotEmpty) regLine,
      ].join('\n'),
      // 2: guidance
      'Помни, для достижения твоей цели нужно больше времени уделять квадранту В — Не срочно-Важно (Развитие), регулярно вести учёт и делать практики по управлению стрессом каждый день перед важными действиями.',
      // 3: вопрос
      'Отмечай на странице «Цель» использованные навыки — это поможет закрепить привычку и отслеживать прогресс.\nЕсть ли у тебя сложности при движении к цели?'
    ];
  }

  @override
  Widget build(BuildContext context) {
    final goalAsync = ref.watch(userGoalProvider);
    final practiceAsync = ref.watch(practiceLogProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Чекпоинт: Регулярность')),
      body: goalAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) =>
            const Center(child: Text('Не удалось загрузить цель')),
        data: (goal) {
          final List<String> initialMsgs = _composeInitialMessages(
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
                // Чат
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
                            const _CheckpointHeader(title: 'Чекпоинт L4'),
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
                                onAssistantMessage: (msg) async {
                                  try {
                                    await Sentry.addBreadcrumb(Breadcrumb(
                                      category: 'checkpoint',
                                      message: 'l4_dialog_message',
                                      level: SentryLevel.info,
                                    ));
                                  } catch (_) {}
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                // Кнопка «Завершить чекпоинт →»
                SizedBox(
                  width: double.infinity,
                  child: BizLevelButton(
                    label: 'Завершить чекпоинт →',
                    onPressed: () async {
                      try {
                        await Sentry.addBreadcrumb(Breadcrumb(
                          category: 'checkpoint',
                          message: 'l4_completed',
                          level: SentryLevel.info,
                        ));
                      } catch (_) {}
                      if (!mounted) return;
                      GoRouter.of(context).push('/tower');
                    },
                  ),
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
