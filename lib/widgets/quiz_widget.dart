import 'package:flutter/material.dart';

class QuizWidget extends StatefulWidget {
  final Map<String, dynamic>
      questionData; // {'question': String, 'options': List<String>, 'correct': int}
  final VoidCallback onCorrect;
  final bool initiallyPassed;
  const QuizWidget(
      {Key? key,
      required this.questionData,
      required this.onCorrect,
      this.initiallyPassed = false})
      : super(key: key);

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
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ...List.generate(options.length, (idx) {
          return RadioListTile<int>(
            value: idx,
            groupValue: _selected,
            onChanged: _checked ? null : (v) => setState(() => _selected = v),
            title: Text(options[idx]),
          );
        }),
        const SizedBox(height: 8),
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
                style: const TextStyle(
                    color: Colors.green, fontWeight: FontWeight.w600))
          else
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Неправильный ответ. Попробуйте ещё раз.',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
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
