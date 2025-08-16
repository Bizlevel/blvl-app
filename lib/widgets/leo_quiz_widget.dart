import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/providers/leo_service_provider.dart';
import 'package:bizlevel/widgets/leo_message_bubble.dart';
import 'package:bizlevel/theme/color.dart';

class LeoQuizWidget extends ConsumerStatefulWidget {
  final Map<String, dynamic>
      questionData; // {question, options[], correct, script?, explanation?}
  final VoidCallback onCorrect;
  final bool initiallyPassed;
  final String? userContext;
  final int? levelNumber;
  final int? questionIndex;

  const LeoQuizWidget({
    super.key,
    required this.questionData,
    required this.onCorrect,
    this.initiallyPassed = false,
    this.userContext,
    this.levelNumber,
    this.questionIndex,
  });

  @override
  ConsumerState<LeoQuizWidget> createState() => _LeoQuizWidgetState();
}

class _LeoQuizWidgetState extends ConsumerState<LeoQuizWidget> {
  int? _selectedIndex;
  bool _checked = false;
  bool _isCorrect = false;
  String? _assistantMessage; // Сообщение Лео после проверки ответа
  late String _initialMessage; // Стартовое приветствие Лео
  String? _userAnswer; // Текст выбранного пользователем варианта
  bool _isSending = false; // Блокировка повторных тапов до ответа Лео

  @override
  void initState() {
    super.initState();
    _checked = widget.initiallyPassed;
    _isCorrect = widget.initiallyPassed;
    _initialMessage = _buildInitialAssistantMessage();
    // Если тест уже пройден, показываем короткое подтверждение
    _assistantMessage = widget.initiallyPassed ? 'Тест уже пройден ✅' : null;
  }

  String _buildInitialAssistantMessage() {
    final dynamic raw = widget.questionData['script'];
    final String? script = raw is String ? raw : null;
    return script ??
        'Давай проверим, как ты понял материал. Выбери верный ответ ниже.';
  }

  void _checkAnswer() {
    if (_selectedIndex == null) return;
    final int correctIndex = (widget.questionData['correct'] as int);

    final bool isRight = _selectedIndex == correctIndex;
    _sendAssistantReply(isRight, correctIndex);
  }

  Future<void> _sendAssistantReply(bool isRight, int correctIndex) async {
    // Пытаемся получить короткий ответ ассистента (без лимитов/создания чата).
    try {
      setState(() => _isSending = true);
      final service = ref.read(leoServiceProvider);
      final question = widget.questionData['question'] as String;
      final options = List<String>.from(widget.questionData['options'] as List);
      final reply = await service.sendQuizFeedback(
        question: question,
        options: options,
        selectedIndex: _selectedIndex!,
        correctIndex: correctIndex,
        userContext: widget.userContext ?? '',
      );
      final content = (reply['message']?['content'] as String?) ?? '';
      setState(() {
        _checked = true;
        _isCorrect = isRight;
        _assistantMessage =
            content.isNotEmpty ? content : _composeAssistantReply(isRight);
        _isSending = false;
      });
    } catch (_) {
      // Фолбэк: локальная формулировка без сети
      setState(() {
        _checked = true;
        _isCorrect = isRight;
        _assistantMessage = _composeAssistantReply(isRight);
        _isSending = false;
      });
    }

    if (isRight) {
      widget.onCorrect();
    }
  }

  String _composeAssistantReply(bool correct) {
    final String? explanation = _safeString(widget.questionData['explanation']);
    final String? ctx = widget.userContext?.trim().isEmpty == true
        ? null
        : widget.userContext?.trim();

    if (correct) {
      final String base = 'Верно! 👍 Отличная работа.';
      final String contextLine =
          ctx != null ? '\nПрименение к твоему контексту: $ctx' : '';
      final String extra =
          explanation != null ? '\nПодсказка: $explanation' : '';
      return '$base$contextLine$extra'.trim();
    } else {
      final String hint = explanation != null
          ? 'Подумай ещё: $explanation'
          : 'Подумай, что именно делает ответ верным в контексте урока, и попробуй снова.';
      return 'Не совсем. Ничего страшного — попробуем ещё раз.\n$hint';
    }
  }

  String? _safeString(dynamic v) =>
      v is String && v.trim().isNotEmpty ? v : null;

  @override
  Widget build(BuildContext context) {
    final String question = widget.questionData['question'] as String;
    final List<String> options =
        List<String>.from(widget.questionData['options'] as List);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(
          levelNumber: widget.levelNumber,
          questionIndex: widget.questionIndex,
        ),
        const SizedBox(height: 12),
        // Лента сообщений в стиле чата
        LeoMessageBubble(text: _initialMessage, isUser: false),
        LeoMessageBubble(text: question, isUser: false),
        if (_assistantMessage != null)
          LeoMessageBubble(text: _assistantMessage!, isUser: false),
        const SizedBox(height: 12),
        // Варианты ответа — карточки (не кнопки), нейтральная палитра
        ...List.generate(options.length, (i) {
          final bool isSelected = _selectedIndex == i && !_checked;
          final Color borderColor = isSelected
              ? AppColor.primary
              : Colors.grey.shade300;
          final Color bgColor = isSelected
              ? Colors.blue.shade50
              : Colors.white;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: InkWell(
              key: Key('leo_quiz_option_$i'),
              onTap: (_checked || _isSending)
                  ? null
                  : () {
                      setState(() {
                        _selectedIndex = i;
                        _userAnswer = options[i];
                      });
                      _checkAnswer();
                    },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    Expanded(child: Text(options[i])),
                    if (isSelected)
                      Icon(Icons.check_circle,
                          size: 20, color: AppColor.primary),
                  ],
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
        if (_userAnswer != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: LeoMessageBubble(
              key: const Key('leo_quiz_user_bubble'),
              text: _userAnswer!,
              isUser: true,
            ),
          ),
        if (_checked) ...[
          if (_isCorrect)
            const Text(
              'Тест пройден ✅',
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _checked = false;
                      _selectedIndex = null;
                      _assistantMessage = null;
                      _userAnswer = null;
                    });
                  },
                  child: const Text('Попробовать снова'),
                ),
              ],
            ),
        ],
      ],
    );
  }
}

/// Верхний хедер «как в чате»: слева аватар Лео и имя, справа бейдж с номером вопроса
class _Header extends StatelessWidget {
  final int? levelNumber;
  final int? questionIndex;
  const _Header({required this.levelNumber, required this.questionIndex});

  @override
  Widget build(BuildContext context) {
    final String chipText = (levelNumber != null && questionIndex != null)
        ? 'Вопрос ${levelNumber!.toString()}.${questionIndex!.toString()}'
        : 'Вопрос';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 16,
          backgroundImage: AssetImage('assets/images/avatars/avatar_leo.png'),
          backgroundColor: Colors.transparent,
        ),
        const SizedBox(width: 8),
        const Text(
          'Лео',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColor.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            chipText,
            style: TextStyle(
              color: AppColor.primary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
