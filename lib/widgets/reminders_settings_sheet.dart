import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:bizlevel/services/notifications_service.dart';

/// Common content for configuring practice reminders (time + weekdays)
class RemindersSettingsContent extends StatefulWidget {
  const RemindersSettingsContent({super.key});

  @override
  State<RemindersSettingsContent> createState() =>
      _RemindersSettingsContentState();
}

class _RemindersSettingsContentState extends State<RemindersSettingsContent> {
  TimeOfDay _time = const TimeOfDay(hour: 19, minute: 0);
  final Set<int> _days = <int>{
    DateTime.monday,
    DateTime.wednesday,
    DateTime.friday
  };
  bool _loaded = false;

  String _fmt(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  void initState() {
    super.initState();
    // Prefill from persisted settings
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs =
          await NotificationsService.instance.getPracticeReminderPrefs();
      if (!mounted) return;
      setState(() {
        _days
          ..clear()
          ..addAll(prefs.$1);
        _time = TimeOfDay(hour: prefs.$2, minute: prefs.$3);
        _loaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Настройка напоминаний',
            style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Row(children: [
          const Text('Время:'),
          const SizedBox(width: 12),
          OutlinedButton(
            onPressed: () async {
              final picked =
                  await showTimePicker(context: context, initialTime: _time);
              if (picked != null) setState(() => _time = picked);
            },
            child: Text(_fmt(_time)),
          ),
        ]),
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
                selected: _days.contains(e.$2),
                onSelected: (v) => setState(() {
                  if (v) {
                    _days.add(e.$2);
                  } else {
                    _days.remove(e.$2);
                  }
                }),
              )
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: !_loaded
                ? null
                : () async {
                    try {
                      await NotificationsService.instance.cancelWeeklyPlan();
                      await NotificationsService.instance
                          .schedulePracticeReminders(
                        weekdays: _days.toList(),
                        hour: _time.hour,
                      );
                      Sentry.addBreadcrumb(Breadcrumb(
                        category: 'notif',
                        message: 'reminders_saved',
                        level: SentryLevel.info,
                      ));
                    } catch (_) {}
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Напоминания настроены')),
                      );
                      Navigator.of(context).maybePop();
                    }
                  },
            child: const Text('Сохранить'),
          ),
        ),
      ],
    );
  }
}

Future<void> showRemindersSettingsSheet(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          top: 8,
        ),
        child: const RemindersSettingsContent(),
      ),
    ),
  );
}
