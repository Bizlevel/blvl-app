import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bizlevel/screens/level_detail_screen.dart';
import 'package:bizlevel/providers/lessons_repository_provider.dart';
import 'package:bizlevel/repositories/lessons_repository.dart';

// -------------------- Моки --------------------
class MockLessonsRepository extends Mock implements LessonsRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  testWidgets('LevelDetailScreen отображает интро и кнопку Далее',
      (tester) async {
    // SharedPreferences заглушка
    SharedPreferences.setMockInitialValues({});

    final repo = MockLessonsRepository();

    when(() => repo.fetchLessons(1)).thenAnswer((_) async => [
          {
            'id': 10,
            'level_id': 1,
            'order': 1,
            'title': 'Урок 1',
            'description': 'Desc',
            'video_url': 'video.mp4',
            'vimeo_id': null,
            'duration_minutes': 3,
            'quiz_questions': [
              {
                'question': 'Q',
                'options': ['A', 'B']
              }
            ],
            'correct_answers': [0],
          }
        ]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          lessonsRepositoryProvider.overrideWithValue(repo),
        ],
        child: const MaterialApp(
            home: LevelDetailScreen(levelId: 1, levelNumber: 1)),
      ),
    );

    // initial frame
    await tester.pumpAndSettle();

    // IntroBlock и Breadcrumb оба содержат "Уровень 1", поэтому допускаем несколько совпадений.
    expect(find.text('Уровень 1'), findsWidgets);

    // Кнопка «Далее» активна
    expect(find.text('Далее'), findsOneWidget);
  });
}
