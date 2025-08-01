import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bizlevel/models/lesson_model.dart';
import 'package:bizlevel/screens/level_detail_screen.dart';
import 'package:bizlevel/providers/lessons_provider.dart';
import 'package:bizlevel/providers/lesson_progress_provider.dart';
import 'package:flutter/widgets.dart';

void main() {
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
