import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/providers/goals_repository_provider.dart';
import 'package:bizlevel/screens/leo_dialog_screen.dart';
import 'package:go_router/go_router.dart';

class CheckpointL7Screen extends ConsumerWidget {
  const CheckpointL7Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalAsync = ref.watch(userGoalProvider);
    final practiceAsync = ref.watch(practiceLogProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Чекпоинт: Проверка реальности')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: goalAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Не удалось загрузить цель'),
            ),
            data: (goal) {
              return practiceAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Не удалось загрузить историю применений'),
                ),
                data: (items) {
                  // Z: текущий темп (за последние 14 дней)
                  final DateTime now = DateTime.now();
                  final DateTime from = now.subtract(const Duration(days: 14));
                  int recent = 0;
                  for (final m in items) {
                    final ts =
                        DateTime.tryParse((m['applied_at'] ?? '').toString());
                    if (ts != null && ts.isAfter(from)) recent++;
                  }
                  final double Z = recent / 14.0;

                  // W: нужный темп до дедлайна
                  final String metricType =
                      (goal?['metric_type'] ?? '').toString();
                  final double cur =
                      (goal?['metric_current'] as num?)?.toDouble() ?? 0;
                  final double tgt =
                      (goal?['metric_target'] as num?)?.toDouble() ?? 0;
                  final DateTime? td = _parseDate(goal?['target_date']);
                  final int daysLeft =
                      td == null ? 0 : td.difference(now).inDays;
                  final double remain = (tgt - cur).clamp(0, double.infinity);
                  final double W = (daysLeft > 0) ? remain / daysLeft : 0;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                              'Легенда: Z — ваш средний темп за 14 дней, W — нужный темп, чтобы успеть к дедлайну.'),
                        ),
                        const SizedBox(height: 12),
                        // Превью «Моя цель»
                        if (goal != null &&
                            (goal['goal_text'] ?? '')
                                .toString()
                                .trim()
                                .isNotEmpty)
                          _card(
                            title: 'Текущая цель',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text((goal['goal_text'] ?? '').toString()),
                                const SizedBox(height: 6),
                                Text(
                                    'Метрика: $metricType • Осталось: ${remain.toStringAsFixed(0)} • Дней: ${daysLeft < 0 ? 0 : daysLeft}',
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),
                        Text('Текущая цель:',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 6),
                        Text((goal?['goal_text'] ?? '').toString()),
                        const SizedBox(height: 12),
                        _statRow('Текущий темп (Z):',
                            Z.isFinite ? Z.toStringAsFixed(2) : '—'),
                        _statRow('Нужный темп (W):',
                            W.isFinite ? W.toStringAsFixed(2) : '—'),
                        if (metricType.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                                'Метрика: $metricType • Осталось: ${remain.toStringAsFixed(0)} • Дней: ${daysLeft < 0 ? 0 : daysLeft}'),
                          ),
                        const SizedBox(height: 16),
                        // Primary: усилить применение
                        _optionButton(
                          context,
                          label: 'Усилить применение',
                          onTap: () async {
                            _breadcrumb('l7_strengthen');
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Совет Макса: увеличь частоту и масштаб действий на ближайшую неделю — выбери 1–2 инструмента и применяй каждый день.')));
                            // Системная запись в журнал для видимости действия
                            try {
                              await ref
                                  .read(goalsRepositoryProvider)
                                  .addPracticeEntry(
                                appliedTools: const ['Интенсивное применение'],
                                note:
                                    'Решение L7: усилить применение инструментов',
                                appliedAt: DateTime.now(),
                              );
                              // Сохраним решение в цель
                              await ref
                                  .read(goalsRepositoryProvider)
                                  .upsertUserGoal(
                                    goalText:
                                        (goal?['goal_text'] ?? '').toString(),
                                    metricType: (goal?['metric_type'] ?? '')
                                            .toString()
                                            .isEmpty
                                        ? null
                                        : (goal?['metric_type'] ?? '')
                                            .toString(),
                                    metricCurrent:
                                        (goal?['metric_current'] as num?)
                                            ?.toDouble(),
                                    metricTarget:
                                        (goal?['metric_target'] as num?)
                                            ?.toDouble(),
                                    targetDate:
                                        _parseDate(goal?['target_date']),
                                    actionPlanNote:
                                        'Усилить применение инструментов',
                                  );
                              ref.invalidate(practiceLogProvider);
                              _breadcrumb('l7_system_entry_logged');
                            } catch (_) {}
                            if (!context.mounted) return;
                            // Переход на страницу «Цель» с префиллом формы журнала и прокруткой
                            GoRouter.of(context)
                                .push('/goal?prefill=intensive&scroll=journal');
                            // Откроем короткий совет Макса без списаний (в фоне)
                            try {
                              await Future.delayed(
                                  const Duration(milliseconds: 300));
                              if (!context.mounted) return;
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => const LeoDialogScreen(
                                  bot: 'max',
                                  chatId: null,
                                  userContext:
                                      'auto: план усиления на 7 дней; сделай краткий список ежедневных действий без RAG',
                                  levelContext: '',
                                  skipSpend: true,
                                  initialAssistantMessage:
                                      'Предлагаю краткий план на 7 дней, чтобы усилить применение и приблизиться к цели. Готов?',
                                ),
                              ));
                            } catch (_) {}
                          },
                        ),
                        // Secondary: скорректировать
                        _optionButton(
                          context,
                          label: 'Скорректировать цель',
                          outlined: true,
                          onTap: () async {
                            try {
                              // Пример корректировки: продлить дедлайн на 14 дней при нехватке темпа
                              DateTime? newTd = td;
                              if (td != null && W > 0 && Z < W) {
                                newTd = td.add(const Duration(days: 14));
                              }
                              await ref
                                  .read(goalsRepositoryProvider)
                                  .upsertUserGoal(
                                    goalText:
                                        (goal?['goal_text'] ?? '').toString(),
                                    metricType:
                                        metricType.isEmpty ? null : metricType,
                                    metricCurrent: cur,
                                    metricTarget: tgt,
                                    targetDate: newTd,
                                    actionPlanNote:
                                        'Скорректировать цель (дедлайн/план действий)',
                                  );
                              ref.invalidate(userGoalProvider);
                              _breadcrumb('l7_adjust_goal');
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Цель скорректирована — откроем страницу Цель для правок')));
                              if (!context.mounted) return;
                              GoRouter.of(context).push('/goal');
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Ошибка: $e')));
                            }
                          },
                        ),
                        // Text: продолжить темп
                        _optionButton(
                          context,
                          label: 'Продолжить текущий темп',
                          outlined: true,
                          onTap: () async {
                            _breadcrumb('l7_keep_pace');
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Отличная динамика! Продолжаем в том же темпе, ты на верном пути 🚀')));
                            try {
                              await ref
                                  .read(goalsRepositoryProvider)
                                  .addPracticeEntry(
                                appliedTools: const ['Поддержание темпа'],
                                note: 'Решение L7: продолжаю текущий темп',
                                appliedAt: DateTime.now(),
                              );
                              await ref
                                  .read(goalsRepositoryProvider)
                                  .upsertUserGoal(
                                    goalText:
                                        (goal?['goal_text'] ?? '').toString(),
                                    metricType: (goal?['metric_type'] ?? '')
                                            .toString()
                                            .isEmpty
                                        ? null
                                        : (goal?['metric_type'] ?? '')
                                            .toString(),
                                    metricCurrent:
                                        (goal?['metric_current'] as num?)
                                            ?.toDouble(),
                                    metricTarget:
                                        (goal?['metric_target'] as num?)
                                            ?.toDouble(),
                                    targetDate:
                                        _parseDate(goal?['target_date']),
                                    actionPlanNote: 'Продолжить текущий темп',
                                  );
                              ref.invalidate(practiceLogProvider);
                              _breadcrumb('l7_system_entry_logged');
                            } catch (_) {}
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _card({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
              color: Color(0x14000000), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  DateTime? _parseDate(dynamic d) {
    try {
      final s = (d ?? '').toString();
      return DateTime.tryParse(s)?.toLocal();
    } catch (_) {
      return null;
    }
  }

  Widget _statRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(children: [
        Expanded(child: Text(label)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ]),
    );
  }

  Widget _optionButton(BuildContext context,
      {required String label,
      required VoidCallback onTap,
      bool outlined = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: double.infinity,
        child: outlined
            ? OutlinedButton(onPressed: onTap, child: Text(label))
            : ElevatedButton(onPressed: onTap, child: Text(label)),
      ),
    );
  }

  void _breadcrumb(String message) {
    try {
      Sentry.addBreadcrumb(Breadcrumb(
          category: 'checkpoint', message: message, level: SentryLevel.info));
    } catch (_) {}
  }
}
