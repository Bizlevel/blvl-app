import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/services/notifications_service.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/widgets/common/bizlevel_button.dart';

class NotificationsSettingsScreen extends ConsumerStatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  ConsumerState<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends ConsumerState<NotificationsSettingsScreen> {
  TimeOfDay _mon = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _wed = const TimeOfDay(hour: 14, minute: 0);
  TimeOfDay _fri = const TimeOfDay(hour: 16, minute: 0);
  final List<TimeOfDay> _sunSlots = <TimeOfDay>[
    const TimeOfDay(hour: 10, minute: 0),
    const TimeOfDay(hour: 13, minute: 0),
    const TimeOfDay(hour: 18, minute: 0)
  ];
  bool _saving = false;

  Future<void> _pickTime(BuildContext context, TimeOfDay initial,
      ValueChanged<TimeOfDay> onPicked) async {
    final res = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (ctx, child) {
        return MediaQuery(
          data: MediaQuery.of(ctx).copyWith(alwaysUse24HourFormat: true),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (res != null) onPicked(res);
  }

  String _fmt(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Напоминания')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColor.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                            color: AppColor.shadowColor,
                            blurRadius: 8,
                            offset: Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Еженедельные напоминания',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        _RowTimePicker(
                          label: 'Пн — план недели',
                          value: _fmt(_mon),
                          onTap: () => _pickTime(
                              context, _mon, (v) => setState(() => _mon = v)),
                        ),
                        _RowTimePicker(
                          label: 'Ср — середина недели',
                          value: _fmt(_wed),
                          onTap: () => _pickTime(
                              context, _wed, (v) => setState(() => _wed = v)),
                        ),
                        _RowTimePicker(
                          label: 'Пт — напоминание',
                          value: _fmt(_fri),
                          onTap: () => _pickTime(
                              context, _fri, (v) => setState(() => _fri = v)),
                        ),
                        const SizedBox(height: 8),
                        Text('Вс — чекин (до 3 напоминаний)',
                            style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: 8),
                        Wrap(spacing: 8, runSpacing: 8, children: [
                          for (int i = 0; i < _sunSlots.length; i++)
                            _SunChip(
                              time: _fmt(_sunSlots[i]),
                              onTap: () => _pickTime(context, _sunSlots[i],
                                  (v) => setState(() => _sunSlots[i] = v)),
                              onRemove: _sunSlots.length > 1
                                  ? () => setState(() => _sunSlots.removeAt(i))
                                  : null,
                            ),
                          if (_sunSlots.length < 3)
                            ActionChip(
                              label: const Text('Добавить'),
                              onPressed: () => setState(() => _sunSlots
                                  .add(const TimeOfDay(hour: 12, minute: 0))),
                            ),
                        ]),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 44,
                          child: BizLevelButton(
                            label: 'Сохранить напоминания',
                            onPressed: _saving
                                ? null
                                : () async {
                                    setState(() => _saving = true);
                                    try {
                                      await NotificationsService.instance
                                          .rescheduleWeekly(
                                        mon: (_mon.hour, _mon.minute),
                                        wed: (_wed.hour, _wed.minute),
                                        fri: (_fri.hour, _fri.minute),
                                        sunTimes: _sunSlots
                                            .map(((t) => (t.hour, t.minute)))
                                            .toList(),
                                      );
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Расписание обновлено')));
                                    } catch (e) {
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text('Ошибка: $e')));
                                    } finally {
                                      if (mounted)
                                        setState(() => _saving = false);
                                    }
                                  },
                            variant: BizLevelButtonVariant.primary,
                            size: BizLevelButtonSize.md,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RowTimePicker extends StatelessWidget {
  const _RowTimePicker(
      {required this.label, required this.value, required this.onTap});
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          TextButton(onPressed: onTap, child: Text(value)),
        ],
      ),
    );
  }
}

class _SunChip extends StatelessWidget {
  const _SunChip({required this.time, required this.onTap, this.onRemove});
  final String time;
  final VoidCallback onTap;
  final VoidCallback? onRemove;
  @override
  Widget build(BuildContext context) {
    return InputChip(
      label: Text(time),
      onPressed: onTap,
      onDeleted: onRemove,
    );
  }
}
