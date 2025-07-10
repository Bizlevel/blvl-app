import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_course/providers/lessons_provider.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/widgets/lesson_widget.dart';
import 'package:online_course/widgets/quiz_widget.dart';

class LevelDetailScreen extends ConsumerStatefulWidget {
  final int levelId;
  const LevelDetailScreen({Key? key, required this.levelId}) : super(key: key);

  @override
  ConsumerState<LevelDetailScreen> createState() => _LevelDetailScreenState();
}

class _LevelDetailScreenState extends ConsumerState<LevelDetailScreen> {
  // индекс текущего завершённого блока (видео+тест)
  int _completedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final lessonsAsync = ref.watch(lessonsProvider(widget.levelId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Уроки уровня'),
        backgroundColor: AppColor.appBarColor,
      ),
      backgroundColor: AppColor.appBgColor,
      body: lessonsAsync.when(
        data: (lessons) {
          if (lessons.isEmpty) {
            return const Center(child: Text('Уроки отсутствуют'));
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 100),
            itemCount: lessons.length,
            itemBuilder: (context, index) {
              final lesson = lessons[index];
              final enabled = index == _completedIndex + 1;

              return Opacity(
                opacity: enabled ? 1.0 : 0.4,
                child: AbsorbPointer(
                  absorbing: !enabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LessonWidget(
                        lesson: lesson,
                        onWatched: () {
                          setState(() {
                            _completedIndex = index; // разрешаем викторину
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      if (index <= _completedIndex)
                        QuizWidget(
                          questionData: {
                            'question': lesson.quizQuestions.first['question'],
                            'options': List<String>.from(
                                lesson.quizQuestions.first['options']),
                            'correct': lesson.correctAnswers.first,
                          },
                          onCorrect: () {
                            // По завершению теста разблокируем следующий урок
                            setState(() {
                              _completedIndex = index;
                            });
                          },
                        ),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Ошибка: ${error.toString()}')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColor.primary,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Уровень завершён (заглушка)')),
          );
        },
        label: const Text('Завершить уровень'),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
