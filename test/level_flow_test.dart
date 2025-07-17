import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:online_course/models/lesson_model.dart';
import 'package:online_course/screens/level_detail_screen.dart';
import 'package:online_course/providers/lessons_provider.dart';
import 'package:online_course/providers/lesson_progress_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Полный поток LevelDetailScreen', (tester) async {
    // 1️⃣ Подготавливаем фейковые данные
    const lesson1 = LessonModel(
      id: 1,
      levelId: 99,
      order: 1,
      title: 'Урок 1',
      description: 'Описание 1',
      vimeoId: null,
      videoUrl: null,
      durationMinutes: 1,
      quizQuestions: [
        {
          'question': '2+2?',
          'options': ['3', '4'],
        }
      ],
      correctAnswers: [1],
      createdAt: null,
    );

    const lesson2 = LessonModel(
      id: 2,
      levelId: 99,
      order: 2,
      title: 'Урок 2',
      description: 'Описание 2',
      vimeoId: null,
      videoUrl: null,
      durationMinutes: 1,
      quizQuestions: [],
      correctAnswers: [],
      createdAt: null,
    );

    final lessons = [lesson1, lesson2];

    // 2️⃣ Создаём тестовый LessonProgressNotifier, который сразу открывает все страницы
    final testProgressNotifier = LessonProgressNotifier(99)
      ..unlockPage(5)
      ..markVideoWatched(1)
      ..markQuizPassed(2)
      ..markVideoWatched(3);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          lessonsProvider(99).overrideWithProvider(
            FutureProvider<List<LessonModel>>((_) async => lessons),
          ),
          lessonProgressProvider(99).overrideWithProvider(
            StateNotifierProvider<LessonProgressNotifier, LessonProgressState>(
                (ref) => testProgressNotifier),
          ),
        ],
        child: const MaterialApp(
          home: LevelDetailScreen(levelId: 99),
        ),
      ),
    );

    // Ждём загрузку
    await tester.pumpAndSettle();

    // Проверяем наличие кнопок
    expect(find.text('Назад'), findsOneWidget);
    expect(find.text('Далее'), findsOneWidget);

    // Переходим к следующему блоку
    await tester.tap(find.text('Далее'));
    await tester.pumpAndSettle();

    // Переходим к следующему (квиз) и отвечаем правильно
    await tester.tap(find.text('Далее'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(RadioListTile<int>).last);
    await tester.tap(find.text('Проверить'));
    await tester.pumpAndSettle();

    // Доходим до кнопки завершения
    await tester.scrollUntilVisible(find.text('Завершить уровень'), 500);
    expect(find.text('Завершить уровень'), findsOneWidget);
  });
}
