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
import 'package:bizlevel/utils/max_context_helper.dart';
import 'package:bizlevel/utils/date_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bizlevel/models/goal_update.dart';
import 'package:bizlevel/utils/input_bottom_sheet.dart';

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
  DateTime? _selectedTargetDate;
  bool _isEditing = false;

  @override
  void dispose() {
    _goalCtrl.dispose();
    _metricCurrentCtrl.dispose();
    _metricTargetCtrl.dispose();
    _targetDateCtrl.dispose();
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
              AppSpacing.gapH(AppSpacing.md),
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
                                padding:
                                    const EdgeInsets.only(top: AppSpacing.xs),
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
                                padding:
                                    const EdgeInsets.only(top: AppSpacing.xs),
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
                  padding: EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    children: [
                      Icon(Icons.flag_outlined,
                          color: AppColor.onSurfaceSubtle),
                      SizedBox(width: AppSpacing.sm),
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
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: true,
                  enableSuggestions: true,
                  enableIMEPersonalizedLearning: true,
                  onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                ),
                AppSpacing.gapH(AppSpacing.sm),
                Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _metricCurrentCtrl,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Текущее значение'),
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      enableSuggestions: false,
                      enableIMEPersonalizedLearning: false,
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextField(
                      controller: _metricTargetCtrl,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Целевое значение'),
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      enableSuggestions: false,
                      enableIMEPersonalizedLearning: false,
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    ),
                  ),
                ]),
                AppSpacing.gapH(AppSpacing.sm),
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
                            final first = DateTime(now.year - 5);
                            final last = DateTime(now.year + 5, 12, 31);
                            final initial = _selectedTargetDate == null
                                ? now
                                : _selectedTargetDate!.isBefore(first)
                                    ? first
                                    : _selectedTargetDate!.isAfter(last)
                                        ? last
                                        : _selectedTargetDate!;
                            final picked = await showRuDatePicker(
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
              AppSpacing.gapH(AppSpacing.sm),
              AppSpacing.gapH(AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: !_isEditing
                        ? BizLevelButton(
                            variant: BizLevelButtonVariant.outline,
                            label: 'Редактировать',
                            onPressed: () => setState(() => _isEditing = true),
                          )
                        : BizLevelButton(
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
                                  final curParsed = num.tryParse(
                                      _metricCurrentCtrl.text.trim());
                                  if (!hasStart && curParsed != null) {
                                    metricStartParam = curParsed;
                                  }
                                } catch (_) {}
                                final userId = Supabase
                                        .instance.client.auth.currentUser?.id ??
                                    '';
                                await repo
                                    .upsertUserGoalRequest(GoalUpsertRequest(
                                  userId: userId,
                                  goalText: _goalCtrl.text.trim(),
                                  targetDate: _selectedTargetDate,
                                  metricCurrent: num.tryParse(
                                      _metricCurrentCtrl.text.trim().isEmpty
                                          ? ''
                                          : _metricCurrentCtrl.text.trim()),
                                  metricTarget: num.tryParse(
                                      _metricTargetCtrl.text.trim().isEmpty
                                          ? ''
                                          : _metricTargetCtrl.text.trim()),
                                  metricStart: metricStartParam,
                                ));
                                if (!context.mounted) return;
                                final messenger = ScaffoldMessenger.of(context);
                                ref.invalidate(userGoalProvider);
                                setState(() => _isEditing = false);
                                messenger.showSnackBar(const SnackBar(
                                    content: Text('Цель сохранена')));
                              } catch (e) {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Ошибка: $e')));
                              }
                            },
                          ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: BizLevelButton(
                      icon: const Icon(Icons.chat_bubble_outline),
                      label: 'Обсудить с Максом',
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => LeoDialogScreen(
                            bot: 'max',
                            userContext: buildMaxUserContext(goal: {
                              'goal_text': _goalCtrl.text.trim(),
                              'metric_current': _metricCurrentCtrl.text.trim(),
                              'metric_target': _metricTargetCtrl.text.trim(),
                              'target_date':
                                  _selectedTargetDate?.toIso8601String(),
                            }),
                            levelContext: '',
                          ),
                        ));
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: !_isEditing
                        ? BizLevelButton(
                            variant: BizLevelButtonVariant.outline,
                            label: 'Новая цель',
                            onPressed: () => _showStartNewGoalSheet(context),
                          )
                        : BizLevelButton(
                            variant: BizLevelButtonVariant.text,
                            label: 'Отмена',
                            onPressed: () => setState(() => _isEditing = false),
                          ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  // Удалён sheet обновления текущего значения: теперь обновляем через Журнал применений

  Future<void> _showStartNewGoalSheet(BuildContext context) async {
    final TextEditingController textCtrl = TextEditingController();
    DateTime? newTarget;
    final TextEditingController currentCtrl = TextEditingController();
    final TextEditingController targetCtrl = TextEditingController();
    await showBizLevelInputBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
              Text('Новая цель',
                  style: Theme.of(ctx)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              AppSpacing.gapH(AppSpacing.md),
              TextField(
                controller: textCtrl,
                decoration:
                    const InputDecoration(labelText: 'Опишите новую цель'),
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => FocusScope.of(ctx).nextFocus(),
                onTapOutside: (_) => FocusScope.of(ctx).unfocus(),
              ),
              AppSpacing.gapH(AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: currentCtrl,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Текущая метрика'),
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) => FocusScope.of(ctx).nextFocus(),
                      onTapOutside: (_) => FocusScope.of(ctx).unfocus(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextField(
                      controller: targetCtrl,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Целевая метрика'),
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) => FocusScope.of(ctx).nextFocus(),
                      onTapOutside: (_) => FocusScope.of(ctx).unfocus(),
                    ),
                  ),
                ],
              ),
              AppSpacing.gapH(AppSpacing.sm),
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
                      final picked = await showRuDatePicker(
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
              AppSpacing.gapH(AppSpacing.md),
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
                  final num? cur = num.tryParse(currentCtrl.text.trim());
                  final num? tgt = num.tryParse(targetCtrl.text.trim());
                  if (cur == null || tgt == null) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      const SnackBar(content: Text('Заполните метрики')),
                    );
                    return;
                  }
                  try {
                    final repo = ref.read(goalsRepositoryProvider);
                    final userId =
                        Supabase.instance.client.auth.currentUser?.id ?? '';
                    await repo.startNewGoalRequest(StartNewGoalRequest(
                      userId: userId,
                      goalText: txt,
                      targetDate: newTarget,
                      metricStart: cur,
                      metricCurrent: cur,
                      metricTarget: tgt,
                    ));
                    if (!context.mounted || !ctx.mounted) return;
                    if (mounted) {
                      ref.invalidate(userGoalProvider);
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Новая цель сохранена')),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
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
  _GradientColor({required this.colors})
      : super(colors.first.toARGB32());
}
