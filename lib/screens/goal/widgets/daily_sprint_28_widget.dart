import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/providers/goals_repository_provider.dart';
import 'package:bizlevel/screens/goal/widgets/daily_card.dart';
import 'package:bizlevel/screens/goal/widgets/daily_calendar.dart';
import 'package:bizlevel/services/notifications_service.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/utils/friendly_messages.dart';

/// Виджет для отображения 28-дневного sprint режима
///
/// Показывает:
/// - Прогресс-бар "День N • Неделя W"
/// - Карточку текущего дня с задачей и статусом
/// - Календарь всех 28 дней
/// - CTA: помощь от Макса и завершение спринта
class DailySprint28Widget extends ConsumerWidget {
  const DailySprint28Widget({
    super.key,
    required this.startDate,
    required this.versions,
    required this.onOpenMaxChat,
    this.completed = false,
  });

  final DateTime startDate;
  final Map<int, Map<String, dynamic>> versions;
  // Позволяет открыть чат Макса с опц. авто‑сообщением
  final void Function({String? autoMessage, List<String>? chips}) onOpenMaxChat;
  // Режим read-only после завершения спринта
  final bool completed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Вычисляем текущий день (1..28)
    final int days = DateTime.now().toUtc().difference(startDate).inDays;
    final int currentDay = (days + 1).clamp(1, 28);

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Хедер дня с линейным прогрессом N/28
          _buildDayHeader(context, currentDay),

          // Карточка «Сегодня»
          _buildTodayCard(context, ref, currentDay),
          const SizedBox(height: 12),

          // Календарь 28 дней
          _buildCalendar(context, ref),
          const SizedBox(height: 12),

          // Контекстные CTA: помощь Макса и завершение 28 дней
          _buildActionButtons(context, ref),
        ],
      ),
    );
  }

  Widget _buildDayHeader(BuildContext context, int currentDay) {
    final int weekNum = ((currentDay - 1) ~/ 7) + 1;
    final double progress = (currentDay / 28.0).clamp(0.0, 1.0);
    final DateTime endDate = startDate.add(const Duration(days: 27));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'День $currentDay • Неделя $weekNum',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: AppColor.surface,
                    color: AppColor.primary,
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Настроить напоминания',
              icon: const Icon(Icons.notifications_active_outlined),
              onPressed: () => GoRouter.of(context).push('/notifications'),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Старт: ${startDate.toLocal().toString().substring(0, 10)} • Финиш: ${endDate.toLocal().toString().substring(0, 10)}',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildTodayCard(BuildContext context, WidgetRef ref, int currentDay) {
    final listAsync = ref.watch(dailyProgressListProvider);

    return listAsync.when(
      data: (list) {
        final Map<int, String> statusByDay = {};
        for (final m in list) {
          final int? dn = m['day_number'] as int?;
          if (dn != null) {
            statusByDay[dn] = (m['completion_status'] ?? 'pending').toString();
          }
        }

        final String status = statusByDay[currentDay] ?? 'pending';

        // Вычисление текущей серии (streak)
        int streak = 0;
        for (int day = currentDay - 1; day >= 1; day--) {
          final dayStatus = statusByDay[day] ?? 'pending';
          if (dayStatus == 'completed' || dayStatus == 'partial') {
            streak++;
          } else {
            break; // Прерываем серию при первом пропуске
          }
        }

        // Задача дня из v3 weekN_focus | sprintN_goal
        final String taskText = _extractTaskText(currentDay);

        return DailyTodayCard(
          dayNumber: currentDay,
          taskText: taskText,
          status: status,
          currentStreak: streak,
          onChangeStatus: (code) async {
            if (completed) return; // read-only режим
            Sentry.addBreadcrumb(Breadcrumb(
              category: 'ui',
              type: 'click',
              message: 'mark_day_tap',
              data: {'day_number': currentDay, 'new_status': code},
              level: SentryLevel.info,
            ));
            await ref.read(goalsRepositoryProvider).upsertDailyProgress(
                  dayNumber: currentDay,
                  status: code,
                );

            // Breadcrumb: День завершен
            if (code == 'completed' || code == 'partial') {
              Sentry.addBreadcrumb(Breadcrumb(
                level: SentryLevel.info,
                category: 'goal',
                message: '28_days_day_completed',
                data: {
                  'day_number': currentDay,
                  'status': code,
                },
              ));

              // Проверка milestone (7/14/21/28)
              if (currentDay == 7 ||
                  currentDay == 14 ||
                  currentDay == 21 ||
                  currentDay == 28) {
                Sentry.addBreadcrumb(Breadcrumb(
                  level: SentryLevel.info,
                  category: 'goal',
                  message: '28_days_streak_milestone',
                  data: {
                    'days': currentDay,
                    'milestone': currentDay == 7
                        ? '1 week'
                        : currentDay == 14
                            ? '2 weeks'
                            : currentDay == 21
                                ? '3 weeks'
                                : '4 weeks (complete)',
                  },
                ));

                // Показать дружелюбное сообщение о бонусе
                if (context.mounted) {
                  final bonusMessage =
                      FriendlyMessages.getStreakBonusMessage(currentDay);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(bonusMessage),
                      backgroundColor: AppColor.primary,
                      duration: const Duration(seconds: 4),
                      action: SnackBarAction(
                        label: 'Круто!',
                        textColor: Colors.white,
                        onPressed: () {},
                      ),
                    ),
                  );
                }
              }
            }

            ref.invalidate(dailyProgressListProvider);
          },
          onSaveNote: (note) async {
            await ref.read(goalsRepositoryProvider).upsertDailyProgress(
                  dayNumber: currentDay,
                  note: note,
                );
            // Вызвать реакцию Макса (тонкая реакция)
            onOpenMaxChat(autoMessage: 'daily_note: ${note.trim()}');
          },
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildCalendar(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(dailyProgressListProvider);

    return listAsync.when(
      data: (list) {
        final Map<int, String> statusByDay = {};
        final Map<int, String> noteByDay = {};
        final Map<int, String> dateByDay = {};
        for (final m in list) {
          final int? dn = m['day_number'] as int?;
          if (dn != null) {
            statusByDay[dn] = (m['completion_status'] ?? 'pending').toString();
            noteByDay[dn] = (m['user_note'] ?? '').toString();
            dateByDay[dn] = (m['date'] ?? '').toString();
          }
        }

        return DailyCalendar28(
          statusByDay: statusByDay,
          onTapDay: (day) async {
            final int days =
                DateTime.now().toUtc().difference(startDate).inDays;
            final int currentDay = (days + 1).clamp(1, 28);
            if (completed || day != currentDay) {
              if (context.mounted) {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('День $day'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Статус: ${statusByDay[day] ?? '—'}'),
                        const SizedBox(height: 8),
                        Text('Заметка:'),
                        const SizedBox(height: 4),
                        Text((noteByDay[day] ?? '').isEmpty
                            ? '—'
                            : (noteByDay[day] ?? '')),
                        const SizedBox(height: 8),
                        if ((dateByDay[day] ?? '').isNotEmpty)
                          Text('Дата: ${dateByDay[day]}',
                              style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('ОК'),
                      ),
                    ],
                  ),
                );
              }
              return;
            }

            final cur = statusByDay[day] ?? 'pending';
            final next = cur == 'completed' ? 'pending' : 'completed';
            await ref.read(goalsRepositoryProvider).upsertDailyProgress(
                  dayNumber: day,
                  status: next,
                );
            ref.invalidate(dailyProgressListProvider);
          },
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        TextButton(
          onPressed: onOpenMaxChat,
          child: const Text('Нужна помощь от Макса'),
        ),
        const Spacer(),
        TextButton(
          onPressed: () => _completeSprint(context, ref),
          child: const Text('Завершить 28 дней'),
        ),
      ],
    );
  }

  /// Извлекает текст задачи для текущего дня из v3
  String _extractTaskText(int currentDay) {
    try {
      final Map<String, dynamic> v3 =
          ((versions[3]?['version_data'] as Map?)?.cast<String, dynamic>()) ??
              const {};

      final int weekNumber = ((currentDay - 1) ~/ 7) + 1;
      final String key = 'week${weekNumber}_focus';
      return (v3[key] ?? v3['sprint${weekNumber}_goal'] ?? '').toString();
    } catch (_) {
      return '';
    }
  }

  /// Завершает sprint с подтверждением
  Future<void> _completeSprint(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(goalsRepositoryProvider).completeSprint();
      await NotificationsService.instance.cancelDailySprint();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('28 дней завершены')),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка завершения: $e')),
      );
    }
  }
}
