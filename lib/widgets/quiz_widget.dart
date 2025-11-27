import 'package:flutter/material.dart';
import 'package:bizlevel/theme/typography.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/color.dart';

class QuizWidget extends StatefulWidget {
  final Map<String, dynamic>
      questionData; // {'question': String, 'options': List<String>, 'correct': int}
  final VoidCallback onCorrect;
  final bool initiallyPassed;
  const QuizWidget(
      {super.key,
      required this.questionData,
      required this.onCorrect,
      this.initiallyPassed = false});

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  int? _selected;
  late bool _checked;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    _checked = widget.initiallyPassed;
    _isCorrect = widget.initiallyPassed;
  }

  @override
  Widget build(BuildContext context) {
    final options = List<String>.from(widget.questionData['options'] as List);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.questionData['question'] as String,
          style: AppTypography.textTheme.titleMedium,
        ),
        AppSpacing.gapH(AppSpacing.sm),
        Column(
          children: List.generate(options.length, (idx) {
            return RadioListTile<int>(
              value: idx,
              groupValue: _selected,
              onChanged: _checked
                  ? null
                  : (value) {
                      if (value == null) return;
                      setState(() => _selected = value);
                    },
              title: Text(options[idx]),
            );
          }),
        ),
        AppSpacing.gapH(AppSpacing.sm),
        if (!_checked)
          ElevatedButton(
            onPressed: _selected == null
                ? null
                : () {
                    setState(() {
                      _checked = true;
                      _isCorrect =
                          _selected == (widget.questionData['correct'] as int);
                    });
                    if (_isCorrect) widget.onCorrect();
                  },
            child: const Text('Проверить'),
          )
        else ...{
          if (_isCorrect)
            Text('Верно! 👍',
                style: AppTypography.textTheme.bodyMedium?.copyWith(
                    color: AppColor.success, fontWeight: FontWeight.w600))
          else
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Неправильный ответ. Попробуйте ещё раз.',
                  style: AppTypography.textTheme.bodyMedium?.copyWith(
                      color: AppColor.error, fontWeight: FontWeight.w600)),
              AppSpacing.gapH(AppSpacing.sm),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _checked = false;
                    _selected = null;
                  });
                },
                child: const Text('Попробовать снова'),
              ),
            ]),
        },
      ],
    );
  }
}
