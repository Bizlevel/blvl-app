import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:bizlevel/models/reminder_prefs.dart';
import 'package:bizlevel/providers/reminder_prefs_provider.dart';
import 'package:bizlevel/services/notifications_service.dart';
import 'package:bizlevel/services/reminder_prefs_cache.dart';

/// Common content for configuring practice reminders (time + weekdays)
class RemindersSettingsContent extends ConsumerStatefulWidget {
  const RemindersSettingsContent({super.key});

  @override
  ConsumerState<RemindersSettingsContent> createState() =>
      _RemindersSettingsContentState();
}

class _RemindersSettingsContentState
    extends ConsumerState<RemindersSettingsContent> {
  static const Set<int> _defaultDays = {
    DateTime.monday,
    DateTime.wednesday,
    DateTime.friday
  };
  TimeOfDay? _time;
  Set<int>? _days;
  bool _dirty = false;
  bool _saving = false;
  String? _error;

  String _fmt(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final prefsAsync = ref.watch(reminderPrefsProvider);
    final resolvedPrefs =
        prefsAsync.valueOrNull ?? ReminderPrefsCache.instance.current;

    if (resolvedPrefs == null) {
      if (prefsAsync.hasError) {
        return _ReminderError(
          message: 'Не удалось загрузить настройки',
          onRetry: () =>
              ref.read(reminderPrefsProvider.notifier).refreshPrefs(),
        );
      }
      return const _RemindersLoading();
    }

    final selectedDays = _resolveDays(resolvedPrefs);
    final selectedTime = _resolveTime(resolvedPrefs);
    final next = _computeNextOccurrence(selectedDays, selectedTime);
    final bool syncing = prefsAsync.isLoading && prefsAsync.valueOrNull != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (syncing)
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: LinearProgressIndicator(minHeight: 3),
          ),
        const Text(
          'Настройка напоминаний',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        if (prefsAsync.hasError)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Не удалось синхронизировать с облаком, '
              'показаны локальные данные.',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.error),
            ),
          ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Text('Время:'),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: _saving
                  ? null
                  : () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (picked != null) {
                        setState(() {
                          _time = picked;
                          _dirty = true;
                        });
                      }
                    },
              child: Text(_fmt(selectedTime)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text('Дни недели:'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            for (final e in const <(String, int)>[
              ('Пн', DateTime.monday),
              ('Вт', DateTime.tuesday),
              ('Ср', DateTime.wednesday),
              ('Чт', DateTime.thursday),
              ('Пт', DateTime.friday),
              ('Сб', DateTime.saturday),
              ('Вс', DateTime.sunday),
            ])
              FilterChip(
                label: Text(e.$1),
                selected: selectedDays.contains(e.$2),
                onSelected: _saving
                    ? null
                    : (v) => setState(() {
                          final update = {...selectedDays};
                          if (v) {
                            update.add(e.$2);
                          } else {
                            update.remove(e.$2);
                          }
                          _days = update.isEmpty ? _defaultDays : update;
                          _dirty = true;
                        }),
              )
          ],
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            'Следующее напоминание: '
            '${next.day.toString().padLeft(2, '0')}.'
            '${next.month.toString().padLeft(2, '0')}.'
            '${next.year} ${_fmt(selectedTime)}',
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              _error!,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.error),
            ),
          ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed:
                _saving ? null : () => _onSave(selectedDays, selectedTime),
            child: _saving
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Сохранить'),
          ),
        ),
        const SizedBox(height: 16),
        const _ReminderStatus(),
      ],
    );
  }

  Set<int> _resolveDays(ReminderPrefs prefs) {
    if (!_dirty || _days == null) {
      _days = {
        ...(prefs.weekdays.isEmpty ? _defaultDays : prefs.weekdays),
      };
    }
    return _days!;
  }

  TimeOfDay _resolveTime(ReminderPrefs prefs) {
    if (!_dirty || _time == null) {
      _time = TimeOfDay(hour: prefs.hour, minute: prefs.minute);
    }
    return _time!;
  }

  DateTime _computeNextOccurrence(Set<int> days, TimeOfDay time) {
    final now = DateTime.now();
    if (days.isEmpty) return now;
    int addDays = 0;
    while (addDays < 14) {
      final cand = now.add(Duration(days: addDays));
      final matchDay = days.contains(cand.weekday);
      final at = DateTime(
        cand.year,
        cand.month,
        cand.day,
        time.hour,
        time.minute,
      );
      if (matchDay && at.isAfter(now)) return at;
      addDays++;
    }
    return now.add(const Duration(days: 1));
  }

  Future<void> _onSave(Set<int> days, TimeOfDay time) async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await NotificationsService.instance.cancelWeeklyPlan();
      await NotificationsService.instance.cancelDailyPracticeReminder();
      await NotificationsService.instance.schedulePracticeReminders(
        weekdays: days.toList(),
        hour: time.hour,
        minute: time.minute,
      );
      await ref.read(reminderPrefsProvider.notifier).refreshPrefs();
      Sentry.addBreadcrumb(
        Breadcrumb(
          category: 'notif',
          message: 'reminders_saved',
          level: SentryLevel.info,
        ),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Напоминания настроены')),
      );
      Navigator.of(context).maybePop();
    } catch (error) {
      setState(() {
        _error = 'Не удалось сохранить: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
          _dirty = false;
        });
      }
    }
  }
}

Future<void> showRemindersSettingsSheet(BuildContext context) async {
  try {
    Sentry.addBreadcrumb(
      Breadcrumb(
        category: 'notif.ui',
        message: 'open_reminder_sheet',
        level: SentryLevel.info,
      ),
    );
  } catch (_) {}
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(ctx).viewInsets.bottom +
            MediaQuery.of(ctx).padding.bottom +
            16,
        top: 8,
      ),
      child: const RemindersSettingsContent(),
    ),
  );
}

class _RemindersLoading extends StatelessWidget {
  const _RemindersLoading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _ReminderError extends StatelessWidget {
  const _ReminderError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Theme.of(context).colorScheme.error),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: onRetry,
          child: const Text('Повторить'),
        ),
      ],
    );
  }
}

class _ReminderStatus extends StatelessWidget {
  const _ReminderStatus();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.cloud_outlined, size: 18, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Синхронизация через BizLevel — пуши придут даже после смены устройства.',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.phone_android, size: 18, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Локальные напоминания продолжают работать офлайн и повторяют расписание.',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
