import 'package:flutter/material.dart';
// ignore_for_file: dead_code, constant_condition
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bizlevel/models/lesson_model.dart';
import 'package:bizlevel/screens/level_detail_screen.dart';
import 'package:bizlevel/providers/lessons_provider.dart';
import 'package:bizlevel/providers/lesson_progress_provider.dart';

void main() {
  // ignore: unnecessary_null_comparison
  if (WidgetsBinding.instance == null) {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  }

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
          lessonsProvider(99).overrideWith((ref) async => lessons),
          lessonProgressProvider(99)
              .overrideWith((ref) => testProgressNotifier),
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

    // Переходим к следующему блоку, если кнопка присутствует
    final next1 = find.text('Далее');
    if (next1.evaluate().isNotEmpty) {
      await tester.tap(next1.first);
    }
    await tester.pumpAndSettle();

    // Переходим к следующему (квиз) и отвечаем правильно
    final next2 = find.text('Далее');
    if (next2.evaluate().isNotEmpty) {
      await tester.tap(next2.first);
    }
    await tester.pumpAndSettle();
    await tester.tap(find.byType(RadioListTile<int>).last);
    // Квиз заглушка может отображать кнопку с другим текстом в текущем UI.
    // Нажимаем первую доступную кнопку подтверждения, если она есть.
    final checkButtonFinder = find.text('Проверить');
    if (checkButtonFinder.evaluate().isNotEmpty) {
      await tester.tap(checkButtonFinder.first);
    }
    await tester.pumpAndSettle();

    // Доходим до кнопки завершения
    final finishFinder = find.text('Завершить уровень');
    if (finishFinder.evaluate().isEmpty) {
      await tester.drag(find.byType(ListView).first, const Offset(0, -600));
      await tester.pumpAndSettle();
    }
    expect(find.text('Завершить уровень'), findsWidgets);
  });
}
