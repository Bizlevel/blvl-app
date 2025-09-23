import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/widgets/custom_textfield.dart';

class GoalVersionForm extends StatelessWidget {
  const GoalVersionForm({
    super.key,
    required this.version,
    required this.editing,
    this.editableFields,
    this.completedFields,
    this.fieldKeys,
    // v1
    this.goalInitialCtrl,
    this.goalWhyCtrl,
    this.mainObstacleCtrl,
    // v2
    this.goalRefinedCtrl,
    this.metricNameCtrl,
    this.metricFromCtrl,
    this.metricToCtrl,
    this.financialGoalCtrl,
    // v3
    this.goalSmartCtrl,
    this.s1Ctrl,
    this.s2Ctrl,
    this.s3Ctrl,
    this.s4Ctrl,
    // v4
    this.finalWhatCtrl,
    this.finalWhenCtrl,
    this.finalHowCtrl,
    this.commitment,
    this.onCommitmentChanged,
    this.readinessScore,
    this.onReadinessScoreChanged,
  });

  final int version;
  final bool editing;
  final Set<String>?
      editableFields; // список редактируемых ключей (обычно один активный)
  final Set<String>? completedFields; // завершённые ключи (галочка)
  final Map<String, Key>? fieldKeys; // ключи виджетов для автоскролла

  // v1
  final TextEditingController? goalInitialCtrl;
  final TextEditingController? goalWhyCtrl;
  final TextEditingController? mainObstacleCtrl;

  // v2
  final TextEditingController? goalRefinedCtrl;
  final TextEditingController? metricNameCtrl;
  final TextEditingController? metricFromCtrl;
  final TextEditingController? metricToCtrl;
  final TextEditingController? financialGoalCtrl;

  // v3
  final TextEditingController? goalSmartCtrl;
  final TextEditingController? s1Ctrl;
  final TextEditingController? s2Ctrl;
  final TextEditingController? s3Ctrl;
  final TextEditingController? s4Ctrl;

  // v4
  final TextEditingController? finalWhatCtrl;
  final TextEditingController? finalWhenCtrl;
  final TextEditingController? finalHowCtrl;
  final bool? commitment;
  final ValueChanged<bool>? onCommitmentChanged;
  final int? readinessScore;
  final ValueChanged<int>? onReadinessScoreChanged;

  @override
  Widget build(BuildContext context) {
    switch (version) {
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _groupHeader(context, 'Основная цель',
                completed: _isCompleted('concrete_result')),
            CustomTextBox(
              key: fieldKeys?['concrete_result'],
              controller: goalInitialCtrl,
              readOnly: !editing || !_isEditable('concrete_result'),
              readOnlySoftBackground: true,
              hint: 'Чего хочу достичь за 28 дней',
            ),
            const SizedBox(height: 16),
            _groupHeader(context, 'Почему сейчас',
                completed: _isCompleted('main_pain')),
            CustomTextBox(
              key: fieldKeys?['main_pain'],
              controller: goalWhyCtrl,
              readOnly: !editing || !_isEditable('main_pain'),
              readOnlySoftBackground: true,
              hint: 'Почему это важно именно сейчас*',
            ),
            const SizedBox(height: 16),
            _groupHeader(context, 'Препятствие',
                completed: _isCompleted('first_action')),
            CustomTextBox(
              key: fieldKeys?['first_action'],
              controller: mainObstacleCtrl,
              readOnly: !editing || !_isEditable('first_action'),
              readOnlySoftBackground: true,
              hint: 'Главное препятствие*',
            ),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _groupHeader(context, 'Уточненная цель',
                completed: _isCompleted('concrete_result')),
            CustomTextBox(
              key: fieldKeys?['concrete_result'],
              controller: goalRefinedCtrl,
              readOnly: !editing || !_isEditable('concrete_result'),
              readOnlySoftBackground: true,
              hint: 'Конкретная цель*',
            ),
            const SizedBox(height: 16),
            _groupHeader(context, 'Метрика',
                completed: _isCompleted('metric_type')),
            if (editing && _isEditable('metric_type'))
              DropdownButtonFormField<String>(
                key: fieldKeys?['metric_type'],
                value: (metricNameCtrl?.text.isNotEmpty ?? false)
                    ? metricNameCtrl!.text
                    : null,
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
                  if (v != null) metricNameCtrl?.text = v;
                },
                decoration: const InputDecoration(
                  hintText: 'Что измеряем*',
                  border: OutlineInputBorder(),
                ),
              )
            else
              CustomTextBox(
                key: fieldKeys?['metric_type'],
                controller: metricNameCtrl,
                readOnly: true,
                readOnlySoftBackground: true,
                hint: 'Что измеряем*',
              ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: CustomTextBox(
                  key: fieldKeys?['metric_current'],
                  controller: metricFromCtrl,
                  readOnly: !editing || !_isEditable('metric_current'),
                  readOnlySoftBackground: true,
                  keyboardType: TextInputType.number,
                  hint: 'Текущее значение*',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomTextBox(
                  key: fieldKeys?['metric_target'],
                  controller: metricToCtrl,
                  readOnly: !editing || !_isEditable('metric_target'),
                  readOnlySoftBackground: true,
                  keyboardType: TextInputType.number,
                  hint: 'Целевое значение*',
                ),
              ),
            ]),
            const SizedBox(height: 8),
            _buildGrowthIndicator(context),
            const SizedBox(height: 16),
            _groupHeader(context, 'Финансовая цель',
                completed: _isCompleted('financial_goal')),
            CustomTextBox(
              key: fieldKeys?['financial_goal'],
              controller: financialGoalCtrl,
              readOnly: !editing || !_isEditable('financial_goal'),
              readOnlySoftBackground: true,
              keyboardType: TextInputType.number,
              hint: 'Финансовый результат в ₸*',
            ),
          ],
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _groupHeader(context, 'SMART-план',
                completed: _isCompleted('goal_smart')),
            CustomTextBox(
              key: fieldKeys?['goal_smart'],
              controller: goalSmartCtrl,
              readOnly: !editing || !_isEditable('goal_smart'),
              readOnlySoftBackground: true,
              hint: 'SMART-формулировка цели*',
            ),
            const SizedBox(height: 16),
            _groupHeader(context, 'План спринтов',
                completed: _isCompleted('week1_focus') &&
                    _isCompleted('week2_focus') &&
                    _isCompleted('week3_focus') &&
                    _isCompleted('week4_focus')),
            CustomTextBox(
              key: fieldKeys?['week1_focus'],
              controller: s1Ctrl,
              hint: 'Спринт 1 (1–7 дни)*',
              readOnly: !editing || !_isEditable('week1_focus'),
              readOnlySoftBackground: true,
            ),
            const SizedBox(height: 12),
            CustomTextBox(
              key: fieldKeys?['week2_focus'],
              controller: s2Ctrl,
              hint: 'Спринт 2 (8–14 дни)*',
              readOnly: !editing || !_isEditable('week2_focus'),
              readOnlySoftBackground: true,
            ),
            const SizedBox(height: 12),
            CustomTextBox(
              key: fieldKeys?['week3_focus'],
              controller: s3Ctrl,
              hint: 'Спринт 3 (15–21 дни)*',
              readOnly: !editing || !_isEditable('week3_focus'),
              readOnlySoftBackground: true,
            ),
            const SizedBox(height: 12),
            CustomTextBox(
              key: fieldKeys?['week4_focus'],
              controller: s4Ctrl,
              hint: 'Спринт 4 (22–28 дни)*',
              readOnly: !editing || !_isEditable('week4_focus'),
              readOnlySoftBackground: true,
            ),
          ],
        );
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _groupHeader(context, 'Финальный план',
                completed: _isCompleted('first_three_days')),
            CustomTextBox(
              key: fieldKeys?['first_three_days'],
              controller: finalWhatCtrl,
              readOnly: !editing || !_isEditable('first_three_days'),
              readOnlySoftBackground: true,
              hint: 'Что именно достигну*',
            ),
            const SizedBox(height: 12),
            CustomTextBox(
              key: fieldKeys?['start_date'],
              controller: finalWhenCtrl,
              readOnly: !editing || !_isEditable('start_date'),
              readOnlySoftBackground: true,
              hint: 'К какой дате (28 дней)*',
            ),
            const SizedBox(height: 12),
            CustomTextBox(
              key: fieldKeys?['accountability_person'],
              controller: finalHowCtrl,
              readOnly: !editing || !_isEditable('accountability_person'),
              readOnlySoftBackground: true,
              hint: 'Через какие ключевые действия*',
            ),
            const SizedBox(height: 16),
            _groupHeader(context, 'Готовность (1–10)'),
            Row(children: [
              Expanded(
                child: Slider(
                  value: (readinessScore ?? ((commitment ?? false) ? 8 : 5))
                      .toDouble(),
                  onChanged: editing && onReadinessScoreChanged != null
                      ? (v) => onReadinessScoreChanged!(v.round())
                      : null,
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: '${readinessScore ?? ((commitment ?? false) ? 8 : 5)}',
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${readinessScore ?? ((commitment ?? false) ? 8 : 5)}/10',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ]),
          ],
        );
    }
  }

  bool _isEditable(String fieldKey) {
    if (editableFields == null) return true;
    return editableFields!.contains(fieldKey);
  }

  Widget _buildGrowthIndicator(BuildContext context) {
    double? curr = double.tryParse((metricFromCtrl?.text.trim() ?? ''));
    double? targ = double.tryParse((metricToCtrl?.text.trim() ?? ''));
    if (curr == null || targ == null || curr == 0) {
      return const SizedBox.shrink();
    }
    final double growth = ((targ - curr) / curr) * 100.0;
    Color c;
    String label;
    if (growth < 20) {
      c = Colors.grey;
      label = 'Рост ${growth.toStringAsFixed(0)}% — низкий';
    } else if (growth <= 50) {
      c = Colors.green;
      label = 'Рост ${growth.toStringAsFixed(0)}% — реалистично';
    } else {
      c = Colors.orange;
      label = 'Рост ${growth.toStringAsFixed(0)}% — слишком высокий?';
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: c.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: c)),
      ),
    );
  }

  bool _isCompleted(String fieldKey) {
    if (completedFields == null) return false;
    return completedFields!.contains(fieldKey);
  }

  Widget _groupHeader(BuildContext context, String title,
      {bool completed = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColor.primary,
                  ),
            ),
          ),
          if (completed)
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 18,
            ),
        ],
      ),
    );
  }
}
