import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/models/lesson_model.dart';
import 'package:bizlevel/providers/lesson_progress_provider.dart';
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/widgets/leo_quiz_widget.dart';
import 'package:bizlevel/widgets/quiz_widget.dart';
import 'package:bizlevel/utils/constant.dart';
import 'package:bizlevel/widgets/level/blocks/level_page_block.dart';

class QuizBlock extends LevelPageBlock {
  final LessonModel lesson;
  final void Function(int) onCorrect;
  final int? levelNumber;
  QuizBlock({required this.lesson, required this.onCorrect, this.levelNumber});
  @override
  Widget build(BuildContext context, int index) {
    return Consumer(builder: (context, ref, _) {
      final progress = ref.watch(lessonProgressProvider(lesson.levelId));
      final alreadyPassed = progress.passedQuizzes.contains(index);
      if (lesson.quizQuestions.isEmpty) {
        return const Center(child: Text('Тест отсутствует для этого урока'));
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Center(
          child: Builder(builder: (context) {
            final user = ref.watch(currentUserProvider).value;
            final parts = <String>[];
            if (user != null) {
              if (user.name.isNotEmpty) parts.add('Имя: ${user.name}');
              if ((user.goal ?? '').isNotEmpty) parts.add('Цель: ${user.goal}');
              if ((user.about ?? '').isNotEmpty) {
                parts.add('О себе: ${user.about}');
              }
            }
            final userCtx = parts.isEmpty ? null : parts.join('. ');
            if (kUseLeoQuiz) {
              return LeoQuizWidget(
                questionData: {
                  'question': lesson.quizQuestions.first['question'],
                  'options':
                      List<String>.from(lesson.quizQuestions.first['options']),
                  'correct': lesson.correctAnswers.first,
                  'script': lesson.quizQuestions.first['script'],
                  'explanation': lesson.quizQuestions.first['explanation'],
                },
                initiallyPassed: alreadyPassed,
                onCorrect: () => onCorrect(index),
                userContext: userCtx,
                levelNumber: levelNumber ?? lesson.levelId,
                questionIndex: lesson.order,
              );
            } else {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: QuizWidget(
                  questionData: {
                    'question': lesson.quizQuestions.first['question'],
                    'options': List<String>.from(
                        lesson.quizQuestions.first['options']),
                    'correct': lesson.correctAnswers.first,
                  },
                  initiallyPassed: alreadyPassed,
                  onCorrect: () => onCorrect(index),
                ),
              );
            }
          }),
        ),
      );
    });
  }
}
