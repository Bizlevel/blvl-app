import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/providers/goals_repository_provider.dart';
import 'package:bizlevel/screens/goal/widgets/daily_card.dart';
import 'package:bizlevel/screens/goal/widgets/daily_calendar.dart';
import 'package:bizlevel/services/notifications_service.dart';
import 'package:bizlevel/theme/color.dart';

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
  });

  final DateTime startDate;
  final Map<int, Map<String, dynamic>> versions;
  final VoidCallback onOpenMaxChat;

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

    return Row(
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

        // Задача дня из v3 weekN_focus | sprintN_goal
        final String taskText = _extractTaskText(currentDay);

        return DailyTodayCard(
          dayNumber: currentDay,
          taskText: taskText,
          status: status,
          onChangeStatus: (code) async {
            await ref.read(goalsRepositoryProvider).upsertDailyProgress(
                  dayNumber: currentDay,
                  status: code,
                );
            ref.invalidate(dailyProgressListProvider);
          },
          onSaveNote: (note) async {
            await ref.read(goalsRepositoryProvider).upsertDailyProgress(
                  dayNumber: currentDay,
                  note: note,
                );
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
        for (final m in list) {
          final int? dn = m['day_number'] as int?;
          if (dn != null) {
            statusByDay[dn] = (m['completion_status'] ?? 'pending').toString();
          }
        }

        return DailyCalendar28(
          statusByDay: statusByDay,
          onTapDay: (day) async {
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

