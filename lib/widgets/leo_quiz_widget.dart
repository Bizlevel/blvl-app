import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/providers/leo_service_provider.dart';
import 'package:bizlevel/widgets/leo_message_bubble.dart';
import 'package:bizlevel/widgets/typing_indicator.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/animations.dart';

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
  // Убрано: ответ пользователя не дублируется отдельным баблом
  bool _isSending = false; // Блокировка повторных тапов до ответа Лео
  final ScrollController _scrollController = ScrollController();

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
      _scrollToBottom();
    } catch (_) {
      // Фолбэк: локальная формулировка без сети
      setState(() {
        _checked = true;
        _isCorrect = isRight;
        _assistantMessage = _composeAssistantReply(isRight);
        _isSending = false;
      });
      _scrollToBottom();
    }

    if (isRight) {
      widget.onCorrect();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      try {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: AppAnimations.normal,
          curve: Curves.easeOut,
        );
      } catch (_) {}
    });
  }

  String _composeAssistantReply(bool correct) {
    final String? explanation = _safeString(widget.questionData['explanation']);
    final String? ctx = widget.userContext?.trim().isEmpty == true
        ? null
        : widget.userContext?.trim();

    if (correct) {
      const String base = 'Верно! 👍 Отличная работа.';
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
    final int correctIndex = (widget.questionData['correct'] as int);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(
          levelNumber: widget.levelNumber,
          questionIndex: widget.questionIndex,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.only(bottom: 12),
            itemCount: 1 /* header */ +
                options.length /* options */ +
                1 /* spacing */ +
                (_isSending ? 1 : 0) +
                (_assistantMessage != null ? 1 : 0) +
                ((_assistantMessage != null && _isCorrect) ? 1 : 0) +
                ((_assistantMessage != null && !_isCorrect) ? 1 : 0) +
                (_checked ? 1 : 0),
            itemBuilder: (context, idx) {
              int cursor = 0;
              if (idx == cursor) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LeoMessageBubble(text: _initialMessage, isUser: false),
                    LeoMessageBubble(text: question, isUser: false),
                    const SizedBox(height: 12),
                  ],
                );
              }
              cursor += 1;
              if (idx < cursor + options.length) {
                final i = idx - cursor;
                final bool isSelected = _selectedIndex == i;
                final bool isCorrectOption = i == correctIndex;
                final bool isRightSelected =
                    _checked && _isCorrect && isSelected;
                final bool isWrongSelected =
                    _checked && !_isCorrect && isSelected;
                final bool showCorrectHighlight =
                    _checked && !_isCorrect && isCorrectOption;
                final bool isPending = _isSending && isSelected;

                Color bgColor = AppColor.surface;
                Color borderColor = AppColor.borderSubtle;
                Color textColor = AppColor.onSurface;

                if (isRightSelected) {
                  bgColor = AppColor.colorSuccessLight;
                  borderColor = AppColor.colorSuccess;
                  textColor = AppColor.colorTextPrimary;
                } else if (isWrongSelected) {
                  bgColor = AppColor.colorErrorLight;
                  borderColor = AppColor.colorError;
                  textColor = AppColor.colorTextPrimary;
                } else if (showCorrectHighlight) {
                  bgColor = AppColor.colorSuccessLight;
                  borderColor = AppColor.colorSuccess;
                  textColor = AppColor.colorTextPrimary;
                } else if (isPending) {
                  bgColor = AppColor.colorPrimaryLight;
                  borderColor = AppColor.colorPrimary;
                  textColor = AppColor.colorTextPrimary;
                } else if (isSelected) {
                  bgColor = AppColor.colorPrimaryLight;
                  borderColor = AppColor.colorPrimary;
                  textColor = AppColor.colorTextPrimary;
                }

                final Widget optionContent = AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          options[i],
                          style: TextStyle(color: textColor),
                        ),
                      ),
                      if (isRightSelected || showCorrectHighlight)
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.check_circle,
                              size: 20, color: AppColor.colorSuccess),
                        ),
                      if (isWrongSelected)
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.cancel,
                              size: 20, color: AppColor.colorError),
                        ),
                    ],
                  ),
                );
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.8),
                      child: InkWell(
                        key: Key('leo_quiz_option_$i'),
                        onTap: (_checked || _isSending)
                            ? null
                            : () {
                                setState(() {
                                  _selectedIndex = i;
                                });
                                _checkAnswer();
                              },
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusLg),
                        child: isWrongSelected
                            ? TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0, end: 1),
                                duration: const Duration(milliseconds: 300),
                                builder: (context, v, child) {
                                  final dx = math.sin(v * math.pi * 6) * 4.0;
                                  return Transform.translate(
                                    offset: Offset(dx, 0),
                                    child: child,
                                  );
                                },
                                child: optionContent,
                              )
                            : AnimatedScale(
                                scale: isRightSelected ? 1.02 : 1.0,
                                duration: const Duration(milliseconds: 200),
                                child: optionContent,
                              ),
                      ),
                    ),
                  ),
                );
              }
              cursor += options.length;
              if (idx == cursor) {
                return const SizedBox(height: 8);
              }
              cursor += 1;
              if (_isSending && idx == cursor) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TypingIndicator.small(),
                  ),
                );
              }
              if (_isSending) cursor += 1;
              if (_assistantMessage != null && idx == cursor) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child:
                      LeoMessageBubble(text: _assistantMessage!, isUser: false),
                );
              }
              if (_assistantMessage != null) cursor += 1;
              if (_assistantMessage != null && _isCorrect && idx == cursor) {
                return const LeoMessageBubble(
                  text:
                      'Если хочешь обсудить более подробно, нажми на кнопку ниже «Обсудить с Лео».',
                  isUser: false,
                );
              }
              if (_assistantMessage != null && _isCorrect) cursor += 1;
              if (_assistantMessage != null && !_isCorrect && idx == cursor) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _checked = false;
                        _selectedIndex = null;
                        _assistantMessage = null;
                        _isSending = false;
                      });
                    },
                    borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusLg),
                      ),
                      child: Text(
                        'Попробовать снова',
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: AppColor.onPrimary),
                      ),
                    ),
                  ),
                );
              }
              if (_assistantMessage != null && !_isCorrect) cursor += 1;
              if (_checked && idx == cursor) {
                if (_isCorrect) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Тест пройден ✅',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColor.success, fontWeight: FontWeight.w600),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }
              return const SizedBox.shrink();
            },
          ),
        ),
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

    return Container(
      padding: AppSpacing.insetsSymmetric(h: AppSpacing.md, v: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColor.primary, // тот же цвет, что и AppBar чата
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage('assets/images/avatars/avatar_leo.png'),
            backgroundColor: AppColor.onPrimary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Лео',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600, color: AppColor.onPrimary),
          ),
          const Spacer(),
          Container(
            padding:
                AppSpacing.insetsSymmetric(h: AppSpacing.s10, v: AppSpacing.s6),
            decoration: BoxDecoration(
              color: AppColor.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            ),
            child: Text(
              chipText,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColor.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
