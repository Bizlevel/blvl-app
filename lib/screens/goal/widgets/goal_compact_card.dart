import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/providers/goals_repository_provider.dart';
import 'package:bizlevel/screens/leo_dialog_screen.dart';
import 'package:bizlevel/widgets/common/bizlevel_button.dart';
import 'package:bizlevel/widgets/common/bizlevel_card.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/color.dart';

class GoalCompactCard extends ConsumerStatefulWidget {
  const GoalCompactCard({super.key});

  @override
  ConsumerState<GoalCompactCard> createState() => _GoalCompactCardState();
}

class _GoalCompactCardState extends ConsumerState<GoalCompactCard> {
  final TextEditingController _goalCtrl = TextEditingController();
  final TextEditingController _metricCurrentCtrl = TextEditingController();
  final TextEditingController _metricTargetCtrl = TextEditingController();
  final TextEditingController _targetDateCtrl = TextEditingController();
  final TextEditingController _metricTypeCtrl = TextEditingController();
  DateTime? _selectedTargetDate;
  bool _isEditing = false;

  @override
  void dispose() {
    _goalCtrl.dispose();
    _metricCurrentCtrl.dispose();
    _metricTargetCtrl.dispose();
    _targetDateCtrl.dispose();
    _metricTypeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userGoalAsync = ref.watch(userGoalProvider);
    return BizLevelCard(
      padding: AppSpacing.insetsAll(AppSpacing.lg),
      child: userGoalAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Text('Не удалось загрузить цель'),
        data: (goal) {
          if (goal != null && !_isEditing) {
            _goalCtrl.text = (goal['goal_text'] ?? '').toString();
            _metricCurrentCtrl.text = (goal['metric_current'] ?? '').toString();
            _metricTargetCtrl.text = (goal['metric_target'] ?? '').toString();
            _metricTypeCtrl.text = (goal['metric_type'] ?? '').toString();
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

          final metricType = (_metricTypeCtrl.text).toString();

          // Прогресс и дни до дедлайна (герой-блок)
          double? progress;
          int? daysLeft;
          try {
            final repo = ref.read(goalsRepositoryProvider);
            progress = repo.computeGoalProgressPercent(goal);
            if (_selectedTargetDate != null) {
              final int d =
                  _selectedTargetDate!.difference(DateTime.now()).inDays;
              daysLeft = d;
            }
          } catch (_) {}

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Моя цель',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              // Hero-прогресс: круг + дни до дедлайна (показываем только при наличии данных)
              if (!_isEditing && (progress != null || daysLeft != null))
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Row(
                    children: [
                      if (progress != null)
                        _GoalProgressCircle(value: progress),
                      if (progress != null)
                        const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (daysLeft != null)
                              Text(
                                daysLeft < 0
                                    ? 'Дедлайн прошёл'
                                    : 'Осталось $daysLeft дн.',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            // Пояснение формулы прогресса
                            if (progress != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  'Прогресс = (Текущее − Старт) / (Цель − Старт)',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: AppColor.labelColor),
                                ),
                              ),
                            if (progress != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  'Прогресс к цели',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: AppColor.labelColor),
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (progress == null)
                        Expanded(
                          child: Text(
                            'Метрика не настроена. Нажмите «Редактировать», чтобы указать тип, текущее и целевое значения.',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColor.labelColor),
                          ),
                        ),
                    ],
                  ),
                ),
              if (goal == null || (goal['goal_text'] ?? '').toString().isEmpty)
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(Icons.flag_outlined,
                          color: AppColor.onSurfaceSubtle),
                      SizedBox(width: 8),
                      Expanded(
                          child: Text(
                              'Пока цель не задана. Начните с простого описания и метрики.')),
                    ],
                  ),
                ),
              // Нередактируемое представление
              if (!_isEditing)
                Text(
                  _goalCtrl.text.isEmpty ? 'Цель не задана' : _goalCtrl.text,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              // Режим редактирования — только поле описания и (опц.) дедлайн
              if (_isEditing) ...[
                TextField(
                  controller: _goalCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Короткое описание цели'),
                ),
                const SizedBox(height: 8),
                // Блок метрики
                DropdownButtonFormField<String>(
                  value: () {
                    const opts = [
                      'Выручка (тенге)',
                      'Количество клиентов',
                      'Количество продаж',
                      'Часы работы',
                      'Конверсия (%)',
                      'Другое',
                    ];
                    final t = _metricTypeCtrl.text.trim();
                    return (t.isEmpty || !opts.contains(t)) ? null : t;
                  }(),
                  items: const [
                    'Выручка (тенге)',
                    'Количество клиентов',
                    'Количество продаж',
                    'Часы работы',
                    'Конверсия (%)',
                    'Другое',
                  ]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) _metricTypeCtrl.text = v;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Метрика (тип)',
                  ),
                ),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _metricCurrentCtrl,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Текущее значение'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _metricTargetCtrl,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Целевое значение'),
                    ),
                  ),
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _targetDateCtrl,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Дедлайн (YYYY-MM-DD) — необязательно',
                        suffixIcon: IconButton(
                          tooltip: 'Выбрать дату',
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            final now = DateTime.now();
                            final first = DateTime(now.year - 5, 1, 1);
                            final last = DateTime(now.year + 5, 12, 31);
                            final initial = _selectedTargetDate == null
                                ? now
                                : _selectedTargetDate!.isBefore(first)
                                    ? first
                                    : _selectedTargetDate!.isAfter(last)
                                        ? last
                                        : _selectedTargetDate!;
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: initial,
                              firstDate: first,
                              lastDate: last,
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
              ],
              const SizedBox(height: 8),
              const SizedBox(height: 12),
              Wrap(spacing: 12, runSpacing: 8, children: [
                if (!_isEditing)
                  BizLevelButton(
                    variant: BizLevelButtonVariant.text,
                    label: 'Редактировать',
                    onPressed: () => setState(() => _isEditing = true),
                  )
                else ...[
                  BizLevelButton(
                    label: 'Сохранить',
                    onPressed: () async {
                      try {
                        try {
                          Sentry.addBreadcrumb(Breadcrumb(
                              category: 'goal',
                              message: 'goal_edit_saved',
                              level: SentryLevel.info));
                        } catch (_) {}
                        final repo = ref.read(goalsRepositoryProvider);
                        // Авто‑старт: если не задан metric_start и задано текущее
                        num? metricStartParam;
                        try {
                          final hasStart =
                              (goal?['metric_start'] as num?) != null;
                          final curParsed =
                              num.tryParse(_metricCurrentCtrl.text.trim());
                          if (!hasStart && curParsed != null) {
                            metricStartParam = curParsed;
                          }
                        } catch (_) {}
                        await repo.upsertUserGoal(
                          goalText: _goalCtrl.text.trim(),
                          targetDate: _selectedTargetDate,
                          metricType: _metricTypeCtrl.text.trim().isEmpty
                              ? null
                              : _metricTypeCtrl.text.trim(),
                          metricCurrent: num.tryParse(
                              _metricCurrentCtrl.text.trim().isEmpty
                                  ? ''
                                  : _metricCurrentCtrl.text.trim()),
                          metricTarget: num.tryParse(
                              _metricTargetCtrl.text.trim().isEmpty
                                  ? ''
                                  : _metricTargetCtrl.text.trim()),
                          metricStart: metricStartParam,
                        );
                        if (!context.mounted) return;
                        final messenger = ScaffoldMessenger.of(context);
                        ref.invalidate(userGoalProvider);
                        setState(() => _isEditing = false);
                        messenger.showSnackBar(
                            const SnackBar(content: Text('Цель сохранена')));
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Ошибка: $e')));
                      }
                    },
                  ),
                  BizLevelButton(
                    variant: BizLevelButtonVariant.text,
                    label: 'Отмена',
                    onPressed: () => setState(() => _isEditing = false),
                  ),
                ],
                if (!_isEditing)
                  BizLevelButton(
                    variant: BizLevelButtonVariant.text,
                    label: 'Новая цель',
                    onPressed: () => _showStartNewGoalSheet(context),
                  ),
                if (!_isEditing)
                  BizLevelButton(
                    variant: BizLevelButtonVariant.text,
                    label: 'Обновить текущее',
                    onPressed: () => _showUpdateCurrentSheet(context),
                  ),
                BizLevelButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: 'Обсудить с Максом',
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => LeoDialogScreen(
                        bot: 'max',
                        userContext: [
                          'goal_text: ${_goalCtrl.text.trim()}',
                          if (metricType.isNotEmpty) 'metric_type: $metricType',
                          if (_metricCurrentCtrl.text.trim().isNotEmpty)
                            'metric_current: ${_metricCurrentCtrl.text.trim()}',
                          if (_metricTargetCtrl.text.trim().isNotEmpty)
                            'metric_target: ${_metricTargetCtrl.text.trim()}',
                        ].join('\n'),
                        levelContext: '',
                      ),
                    ));
                  },
                ),
              ]),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showUpdateCurrentSheet(BuildContext context) async {
    final TextEditingController currentCtrl =
        TextEditingController(text: _metricCurrentCtrl.text.trim());
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Обновить текущее значение',
                  style: Theme.of(ctx)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              TextField(
                controller: currentCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Текущее значение',
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final repo = ref.read(goalsRepositoryProvider);
                    await repo.upsertUserGoal(
                      goalText: _goalCtrl.text.trim(),
                      metricType: _metricTypeCtrl.text.trim().isEmpty
                          ? null
                          : _metricTypeCtrl.text.trim(),
                      metricCurrent: num.tryParse(currentCtrl.text.trim()),
                      metricTarget: num.tryParse(_metricTargetCtrl.text.trim()),
                      targetDate: _selectedTargetDate,
                    );
                    _metricCurrentCtrl.text = currentCtrl.text.trim();
                    if (mounted) {
                      ref.invalidate(userGoalProvider);
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Значение обновлено')),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ошибка: $e')),
                      );
                    }
                  }
                },
                child: const Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showStartNewGoalSheet(BuildContext context) async {
    final TextEditingController textCtrl = TextEditingController();
    DateTime? newTarget;
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Новая цель',
                  style: Theme.of(ctx)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              TextField(
                controller: textCtrl,
                decoration:
                    const InputDecoration(labelText: 'Опишите новую цель'),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      newTarget == null
                          ? 'Дедлайн не выбран'
                          : newTarget!
                              .toLocal()
                              .toIso8601String()
                              .split('T')
                              .first,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final now = DateTime.now();
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: newTarget ?? now,
                        firstDate: now,
                        lastDate: now.add(const Duration(days: 365 * 3)),
                      );
                      if (picked != null) {
                        newTarget = picked;
                        // ignore: use_build_context_synchronously
                        (ctx as Element).markNeedsBuild();
                      }
                    },
                    child: const Text('Выбрать дату'),
                  )
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  final String txt = textCtrl.text.trim();
                  if (txt.isEmpty) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      const SnackBar(
                          content: Text('Введите формулировку цели')),
                    );
                    return;
                  }
                  try {
                    final repo = ref.read(goalsRepositoryProvider);
                    await repo.startNewGoal(
                        goalText: txt, targetDate: newTarget);
                    if (mounted) {
                      ref.invalidate(userGoalProvider);
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Новая цель сохранена')),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ошибка: $e')),
                      );
                    }
                  }
                },
                child: const Text('Сохранить новую цель'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoalProgressCircle extends StatelessWidget {
  final double value; // 0..1
  const _GoalProgressCircle({required this.value});

  @override
  Widget build(BuildContext context) {
    final double clamped = value.clamp(0.0, 1.0);
    // Подбор мягкого градиента по фазе прогресса
    List<Color> colors;
    if (clamped < 0.31) {
      colors = AppColor.warmGradient.colors; // тёплый старт
    } else if (clamped < 0.71) {
      colors = AppColor.achievementGradient.colors; // работа
    } else {
      colors = AppColor.growthGradient.colors; // финиш
    }
    return SizedBox(
      width: 72,
      height: 72,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: CircularProgressIndicator(
              strokeWidth: 6,
              value: clamped,
              strokeCap: StrokeCap.round,
              valueColor: AlwaysStoppedAnimation(
                _GradientColor(colors: colors),
              ),
              backgroundColor: AppColor.borderSubtle,
            ),
          ),
          Text('${(clamped * 100).round()}%',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

// Простая обёртка, чтобы прокинуть цвет в индикатор (без кастомного painter)
class _GradientColor extends Color {
  final List<Color> colors;
  // Используем значение первого цвета как прокси для Color — линтер ругается из-за value,
  // но нам нужен только числовой ARGB для базового Color. Градиент остаётся в логике выше.
  // ignore: deprecated_member_use
  _GradientColor({required this.colors}) : super(colors.first.value);
}
