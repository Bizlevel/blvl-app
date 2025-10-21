import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/providers/goals_repository_provider.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/screens/leo_dialog_screen.dart';

class GoalCompactCard extends ConsumerStatefulWidget {
  const GoalCompactCard({super.key});

  @override
  ConsumerState<GoalCompactCard> createState() => _GoalCompactCardState();
}

class _GoalCompactCardState extends ConsumerState<GoalCompactCard> {
  final TextEditingController _goalCtrl = TextEditingController();
  final TextEditingController _metricTypeCtrl = TextEditingController();
  final TextEditingController _metricCurrentCtrl = TextEditingController();
  final TextEditingController _metricTargetCtrl = TextEditingController();
  final TextEditingController _targetDateCtrl = TextEditingController();
  DateTime? _selectedTargetDate;
  bool _isEditing = false;

  @override
  void dispose() {
    _goalCtrl.dispose();
    _metricTypeCtrl.dispose();
    _metricCurrentCtrl.dispose();
    _metricTargetCtrl.dispose();
    _targetDateCtrl.dispose();
    super.dispose();
  }

  String _unitForMetricType(String? metricType) {
    final s = (metricType ?? '').toLowerCase();
    if (s.contains('день') || s.contains('/день')) return '/день';
    if (s.contains('нед')) return '/нед.';
    if (s.contains('выруч') || s.contains('₸') || s.contains('тен')) return '₸';
    if (s.contains('клиент')) return 'ед.';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final userGoalAsync = ref.watch(userGoalProvider);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: userGoalAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Text('Не удалось загрузить цель'),
        data: (goal) {
          if (goal != null) {
            _goalCtrl.text = (goal['goal_text'] ?? '').toString();
            _metricTypeCtrl.text = (goal['metric_type'] ?? '').toString();
            _metricCurrentCtrl.text = (goal['metric_current'] ?? '').toString();
            _metricTargetCtrl.text = (goal['metric_target'] ?? '').toString();
            final String td = (goal['target_date'] ?? '').toString();
            try {
              final dt = DateTime.tryParse(td)?.toLocal();
              _selectedTargetDate = dt;
              _targetDateCtrl.text =
                  dt == null ? '' : dt.toIso8601String().split('T').first;
            } catch (_) {
              _selectedTargetDate = null;
              _targetDateCtrl.text = '';
            }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Моя цель',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              if (goal == null || (goal['goal_text'] ?? '').toString().isEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.flag_outlined, color: Colors.black54),
                      const SizedBox(width: 8),
                      const Expanded(
                          child: Text(
                              'Пока цель не задана. Начните с простого описания и метрики.')),
                    ],
                  ),
                ),
              TextField(
                controller: _goalCtrl,
                decoration:
                    const InputDecoration(labelText: 'Короткое описание цели'),
              ),
              const SizedBox(height: 8),
              if (_isEditing)
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _metricTypeCtrl,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Метрика (например, Клиенты/Выручка)',
                          suffixIcon: Tooltip(
                            message:
                                'Метрика — показатель, который меняется от ваших действий (напр. клиенты/день, выручка).',
                            child: Icon(Icons.help_outline),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 8),
              if (_isEditing)
                Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _targetDateCtrl,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Дедлайн (YYYY-MM-DD) — необязательно',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            final now = DateTime.now();
                            final initial = _selectedTargetDate ?? now;
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: initial,
                              firstDate: now.subtract(const Duration(days: 0)),
                              lastDate: now.add(const Duration(days: 365 * 3)),
                            );
                            if (picked != null) {
                              setState(() {
                                _selectedTargetDate = picked;
                                _targetDateCtrl.text = picked
                                    .toLocal()
                                    .toIso8601String()
                                    .split('T')
                                    .first;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ]),
              const SizedBox(height: 8),
              Builder(builder: (context) {
                final num? start =
                    num.tryParse((goal?['metric_start'] ?? '').toString());
                final num? cur = num.tryParse(_metricCurrentCtrl.text.trim());
                final num? tgt = num.tryParse(_metricTargetCtrl.text.trim());
                final String td = (goal?['target_date'] ?? '').toString();
                DateTime? target;
                try {
                  target = DateTime.tryParse(td)?.toLocal();
                } catch (_) {}
                double perc = 0;
                if (start != null && tgt != null && tgt != start) {
                  final double nume =
                      (cur == null ? 0 : (cur - start).toDouble());
                  final double deno = (tgt - start).toDouble();
                  perc = (nume / deno).clamp(0, 1);
                }
                String left = '';
                if (target != null) {
                  final int d = target.difference(DateTime.now()).inDays;
                  if (d > 0) {
                    final String form = (d % 10 == 1 && d % 100 != 11)
                        ? 'день'
                        : ((d % 10 >= 2 &&
                                d % 10 <= 4 &&
                                (d % 100 < 10 || d % 100 >= 20))
                            ? 'дня'
                            : 'дней');
                    left = '$d $form';
                  }
                }
                if (perc == 0 && left.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SizedBox(
                        height: 12,
                        child: LinearProgressIndicator(
                          value: perc,
                          backgroundColor:
                              Colors.blueGrey.withValues(alpha: 0.15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(children: [
                      Expanded(
                        child: Text(
                          left.isEmpty
                              ? 'Прогресс: ${(perc * 100).toStringAsFixed(0)}%'
                              : 'Прогресс: ${(perc * 100).toStringAsFixed(0)}%  •  Осталось: $left',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ]),
                  ],
                );
              }),
              const SizedBox(height: 8),
              LayoutBuilder(builder: (ctx, cons) {
                final double w = cons.maxWidth;
                final bool twoCols = w >= 600;
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    SizedBox(
                      width: twoCols ? (w - 8) / 3 : w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Старт',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black54)),
                          const SizedBox(height: 6),
                          Text(
                            '${(goal?['metric_start'] ?? '').toString()} ${_unitForMetricType(_metricTypeCtrl.text.isNotEmpty ? _metricTypeCtrl.text : (goal?['metric_type'] ?? '').toString())}'
                                .trim(),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: twoCols ? (w - 8) / 3 : w,
                      child: TextField(
                        controller: _metricCurrentCtrl,
                        readOnly: !_isEditing,
                        decoration: InputDecoration(
                          labelText: 'Текущее',
                          hintText: 'Например: 5',
                          suffixText: _unitForMetricType(
                              _metricTypeCtrl.text.isNotEmpty
                                  ? _metricTypeCtrl.text
                                  : (goal?['metric_type'] ?? '').toString()),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(
                      width: twoCols ? (w - 8) / 3 : w,
                      child: TextField(
                        controller: _metricTargetCtrl,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Цель',
                          suffixText: _unitForMetricType(
                              _metricTypeCtrl.text.isNotEmpty
                                  ? _metricTypeCtrl.text
                                  : (goal?['metric_type'] ?? '').toString()),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 12),
              Row(children: [
                if (!_isEditing)
                  TextButton(
                    onPressed: () {
                      setState(() => _isEditing = true);
                    },
                    child: const Text('Редактировать'),
                  )
                else ...[
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        try {
                          Sentry.addBreadcrumb(Breadcrumb(
                              category: 'goal',
                              message: 'goal_edit_saved',
                              level: SentryLevel.info));
                        } catch (_) {}
                        final repo = ref.read(goalsRepositoryProvider);
                        await repo.upsertUserGoal(
                          goalText: _goalCtrl.text.trim(),
                          metricType: _metricTypeCtrl.text.trim().isEmpty
                              ? null
                              : _metricTypeCtrl.text.trim(),
                          metricStart: num.tryParse(
                                  (goal?['metric_start'] ?? '').toString())
                              ?.toDouble(),
                          metricCurrent:
                              double.tryParse(_metricCurrentCtrl.text.trim()),
                          metricTarget:
                              double.tryParse(_metricTargetCtrl.text.trim()),
                          targetDate: _selectedTargetDate,
                        );
                        ref.invalidate(userGoalProvider);
                        if (!mounted) return;
                        setState(() => _isEditing = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Цель сохранена')));
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Ошибка: $e')));
                      }
                    },
                    child: const Text('Сохранить'),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () {
                      setState(() => _isEditing = false);
                    },
                    child: const Text('Отмена'),
                  ),
                ],
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => LeoDialogScreen(
                        bot: 'max',
                        chatId: null,
                        userContext: [
                          'goal_text: ${_goalCtrl.text.trim()}',
                          if (_metricTypeCtrl.text.trim().isNotEmpty)
                            'metric_type: ${_metricTypeCtrl.text.trim()}',
                          if (_metricCurrentCtrl.text.trim().isNotEmpty)
                            'metric_current: ${_metricCurrentCtrl.text.trim()}',
                          if (_metricTargetCtrl.text.trim().isNotEmpty)
                            'metric_target: ${_metricTargetCtrl.text.trim()}',
                        ].join('\n'),
                        levelContext: '',
                      ),
                    ));
                  },
                  child: const Text('Обсудить с Максом'),
                ),
              ]),
            ],
          );
        },
      ),
    );
  }
}

// LEGACY BELOW — удалить при полной миграции на новую карточку цели
/*
import 'package:flutter/material.dart';

import 'package:bizlevel/theme/color.dart';

class GoalCompactCard extends StatelessWidget {
  const GoalCompactCard({
    super.key,
    required this.versions,
    required this.expanded,
    required this.onToggle,
    required this.onOpenChat,
    this.metricActual,
  });

  final Map<int, Map<String, dynamic>> versions;
  final bool expanded;
  final VoidCallback onToggle;
  final VoidCallback onOpenChat;
  final double? metricActual;

  @override
  Widget build(BuildContext context) {
    final hasAny = versions.isNotEmpty;
    final latestVersion =
        hasAny ? versions.keys.reduce((a, b) => a > b ? a : b) : 0;
    final data = hasAny
        ? Map<String, dynamic>.from(
            (versions[latestVersion]?['version_data'] as Map?) ?? {})
        : <String, dynamic>{};

    final String title = latestVersion == 4
        ? ((data['first_three_days'] ?? '').toString().trim())
        : latestVersion == 3
            ? ((data['goal_smart'] ?? '').toString().trim())
            : latestVersion == 2
                ? ((data['concrete_result'] ?? '').toString().trim())
                : ((data['concrete_result'] ?? '').toString().trim());

    final String? metricName =
        latestVersion >= 2 ? (data['metric_type'])?.toString() : null;
    final String? fromV =
        latestVersion >= 2 ? (data['metric_current'])?.toString() : null;
    final String? toV =
        latestVersion >= 2 ? (data['metric_target'])?.toString() : null;
    final String? startDate = latestVersion >= 4
        ? (versions[4]?['sprint_start_date'])?.toString()
        : null;
    final Map<String, dynamic> v4 =
        (versions[4]?['version_data'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{};
    final int readinessScore =
        int.tryParse('${v4['readiness_score'] ?? ''}') ?? 0;
    final String sprintStatus =
        (versions[4]?['sprint_status'] ?? '').toString().trim();

    final double progress = _calcOverallProgressPercent(versions, metricActual);

    return InkWell(
      onTap: onToggle,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowColor.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.isEmpty ? 'Цель пока не сформулирована' : title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              maxLines: expanded ? null : 1,
              overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            if (fromV != null && toV != null && metricActual != null)
              LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.grey.shade200,
                color: AppColor.primary,
              ),
            const SizedBox(height: 8),
            if (metricName != null &&
                metricName.isNotEmpty &&
                fromV != null &&
                toV != null)
              Text('Метрика: $metricName • Сейчас: $fromV → Цель: $toV',
                  style: Theme.of(context).textTheme.bodySmall),
            if (startDate != null && startDate.isNotEmpty)
              Text('Дней осталось: ${_daysLeft(startDate)} из 28',
                  style: Theme.of(context).textTheme.bodySmall),
            if (expanded) ...[
              if (expanded) ...[
                Text('Готовность: $readinessScore/10',
                    style: Theme.of(context).textTheme.bodySmall),
                if (sprintStatus.isNotEmpty)
                  Text('Статус: ${_statusRu(sprintStatus)}',
                      style: Theme.of(context).textTheme.bodySmall),
              ],
            ],
            if (expanded) ...[
              const SizedBox(height: 12),
              if (latestVersion >= 3) ...[
                const _GroupHeader('План по неделям'),
                _bullet(context, 'Неделя 1: ${data['week1_focus'] ?? '—'}'),
                _bullet(context, 'Неделя 2: ${data['week2_focus'] ?? '—'}'),
                _bullet(context, 'Неделя 3: ${data['week3_focus'] ?? '—'}'),
                _bullet(context, 'Неделя 4: ${data['week4_focus'] ?? '—'}'),
                const SizedBox(height: 8),
              ],
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text('Обсудить с Максом'),
                  onPressed: onOpenChat,
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  static Widget _bullet(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• '),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }

  static double _calcOverallProgressPercent(
      Map<int, Map<String, dynamic>> versions, double? metricActual) {
    final v2 =
        (versions[2]?['version_data'] as Map?)?.cast<String, dynamic>() ?? {};
    final double? from =
        double.tryParse('${v2['metric_current'] ?? ''}'.trim());
    final double? to = double.tryParse('${v2['metric_target'] ?? ''}'.trim());
    final double? current = metricActual;
    if (from != null && to != null && current != null && to != from) {
      final pct = ((current - from) / (to - from)).clamp(0.0, 1.0);
      return pct.isNaN ? 0.0 : pct;
    }
    return 0.0;
  }

  static int _daysLeft(String startDateIso) {
    try {
      final start = DateTime.tryParse(startDateIso)?.toUtc();
      if (start == null) return 28;
      final diff = DateTime.now().toUtc().difference(start).inDays;
      final left = 28 - diff;
      return left.clamp(0, 28);
    } catch (_) {
      return 28;
    }
  }

  static String _statusRu(String s) {
    switch (s) {
      case 'active':
        return 'В процессе';
      case 'completed':
        return 'Завершён';
      case 'paused':
        return 'Пауза';
      default:
        return 'Не начат';
    }
  }
}
*/

// _GroupHeader больше не используется (оставлено в комментарии для будущего расширения карточки)
