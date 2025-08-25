import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/widgets/custom_textfield.dart';

class GoalVersionForm extends StatelessWidget {
  const GoalVersionForm({
    super.key,
    required this.version,
    required this.editing,
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
  });

  final int version;
  final bool editing;

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

  @override
  Widget build(BuildContext context) {
    switch (version) {
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _groupHeader(context, 'Основная цель'),
            CustomTextBox(
              controller: goalInitialCtrl,
              readOnly: !editing,
              readOnlySoftBackground: true,
              hint: 'Чего хочу достичь за 28 дней',
            ),
            const SizedBox(height: 16),
            _groupHeader(context, 'Почему сейчас'),
            CustomTextBox(
              controller: goalWhyCtrl,
              readOnly: !editing,
              readOnlySoftBackground: true,
              hint: 'Почему это важно именно сейчас*',
            ),
            const SizedBox(height: 16),
            _groupHeader(context, 'Препятствие'),
            CustomTextBox(
              controller: mainObstacleCtrl,
              readOnly: !editing,
              readOnlySoftBackground: true,
              hint: 'Главное препятствие*',
            ),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _groupHeader(context, 'Уточненная цель'),
            CustomTextBox(
              controller: goalRefinedCtrl,
              readOnly: !editing,
              readOnlySoftBackground: true,
              hint: 'Конкретная цель*',
            ),
            const SizedBox(height: 16),
            _groupHeader(context, 'Метрика'),
            CustomTextBox(
              controller: metricNameCtrl,
              readOnly: !editing,
              readOnlySoftBackground: true,
              hint: 'Ключевая метрика*',
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: CustomTextBox(
                  controller: metricFromCtrl,
                  readOnly: !editing,
                  readOnlySoftBackground: true,
                  keyboardType: TextInputType.number,
                  hint: 'Текущее значение*',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomTextBox(
                  controller: metricToCtrl,
                  readOnly: !editing,
                  readOnlySoftBackground: true,
                  keyboardType: TextInputType.number,
                  hint: 'Целевое значение*',
                ),
              ),
            ]),
            const SizedBox(height: 16),
            _groupHeader(context, 'Финансовая цель'),
            CustomTextBox(
              controller: financialGoalCtrl,
              readOnly: !editing,
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
            _groupHeader(context, 'SMART-план'),
            CustomTextBox(
              controller: goalSmartCtrl,
              readOnly: !editing,
              readOnlySoftBackground: true,
              hint: 'SMART-формулировка цели*',
            ),
            const SizedBox(height: 16),
            _groupHeader(context, 'План спринтов'),
            CustomTextBox(
              controller: s1Ctrl,
              hint: 'Спринт 1 (1–7 дни)*',
              readOnly: !editing,
              readOnlySoftBackground: true,
            ),
            const SizedBox(height: 12),
            CustomTextBox(
              controller: s2Ctrl,
              hint: 'Спринт 2 (8–14 дни)*',
              readOnly: !editing,
              readOnlySoftBackground: true,
            ),
            const SizedBox(height: 12),
            CustomTextBox(
              controller: s3Ctrl,
              hint: 'Спринт 3 (15–21 дни)*',
              readOnly: !editing,
              readOnlySoftBackground: true,
            ),
            const SizedBox(height: 12),
            CustomTextBox(
              controller: s4Ctrl,
              hint: 'Спринт 4 (22–28 дни)*',
              readOnly: !editing,
              readOnlySoftBackground: true,
            ),
          ],
        );
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _groupHeader(context, 'Финальный план'),
            CustomTextBox(
              controller: finalWhatCtrl,
              readOnly: !editing,
              readOnlySoftBackground: true,
              hint: 'Что именно достигну*',
            ),
            const SizedBox(height: 12),
            CustomTextBox(
              controller: finalWhenCtrl,
              readOnly: !editing,
              readOnlySoftBackground: true,
              hint: 'К какой дате (28 дней)*',
            ),
            const SizedBox(height: 12),
            CustomTextBox(
              controller: finalHowCtrl,
              readOnly: !editing,
              readOnlySoftBackground: true,
              hint: 'Через какие ключевые действия*',
            ),
            const SizedBox(height: 16),
            _groupHeader(context, 'Готовность'),
            Row(children: [
              Switch(
                value: commitment ?? false,
                onChanged: editing ? onCommitmentChanged : null,
              ),
              const SizedBox(width: 12),
              const Expanded(child: Text('Я готов к реализации')),
            ]),
          ],
        );
    }
  }

  Widget _groupHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColor.primary,
            ),
      ),
    );
  }
}
