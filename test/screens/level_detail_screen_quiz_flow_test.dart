import 'package:bizlevel/providers/leo_service_provider.dart';
import 'package:bizlevel/providers/lessons_repository_provider.dart';
import 'package:bizlevel/repositories/lessons_repository.dart';
import 'package:bizlevel/screens/level_detail_screen.dart';
import 'package:bizlevel/services/leo_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockLeoService extends Mock implements LeoService {}

class _MockLessonsRepository extends Mock implements LessonsRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  testWidgets(
      'После верного ответа разблокируется «Далее» и можно перейти к следующему блоку',
      (tester) async {
    // SharedPreferences заглушка для провайдера прогресса
    SharedPreferences.setMockInitialValues({});

    final mockService = _MockLeoService();
    when(() => mockService.sendQuizFeedback(
          question: any(named: 'question'),
          options: any(named: 'options'),
          selectedIndex: any(named: 'selectedIndex'),
          correctIndex: any(named: 'correctIndex'),
          userContext: any(named: 'userContext'),
          maxTokens: any(named: 'maxTokens'),
        )).thenAnswer((_) async => {
          'message': {'content': 'Хорошая работа!'}
        });

    final lessonsRepo = _MockLessonsRepository();
    when(() => lessonsRepo.fetchLessons(1)).thenAnswer((_) async => [
          {
            'id': 10,
            'level_id': 1,
            'order': 1,
            'title': 'Урок 1',
            'description': 'Desc',
            'video_url': 'lesson_10.mp4',
            'vimeo_id': null,
            'duration_minutes': 3,
            'quiz_questions': [
              {
                'question': 'Q',
                'options': ['A', 'B'],
              }
            ],
            'correct_answers': [1],
          }
        ]);

    await tester.pumpWidget(ProviderScope(
      overrides: [
        leoServiceProvider.overrideWithValue(mockService),
        lessonsRepositoryProvider.overrideWithValue(lessonsRepo),
      ],
      child: const MaterialApp(
        home: LevelDetailScreen(levelId: 1, levelNumber: 1),
      ),
    ));

    // Ждём прогрузки
    await tester.pumpAndSettle();

    // Стартуем с Intro, кнопка «Далее» активна — переходим на видео
    await tester.tap(find.widgetWithText(ElevatedButton, 'Далее'));
    await tester.pumpAndSettle();

    // На видео блоке «Далее» станет активной после onWatched (отправляется LessonWidget'ом по таймеру в проде)
    // В тесте сразу переходим на квиз (эмулируем, что видео просмотрено и разблокировано)
    await tester.tap(find.widgetWithText(ElevatedButton, 'Далее'));
    await tester.pumpAndSettle();

    // На экране квиза выбираем правильный ответ (index 1)
    await tester.tap(find.byType(RadioListTile<int>).at(1));
    await tester.pumpAndSettle();

    // Нажимаем «Проверить»
    await tester.tap(find.widgetWithText(ElevatedButton, 'Проверить'));
    await tester.pumpAndSettle();

    // После верного ответа появится «Тест пройден ✅», и «Далее» станет активна
    expect(find.text('Тест пройден ✅'), findsOneWidget);

    // Нажимаем «Далее» — переходим на следующий блок (Артефакт)
    await tester.tap(find.widgetWithText(ElevatedButton, 'Далее'));
    await tester.pumpAndSettle();

    // Убедимся, что дошли до артефакта/финала (может быть текст «Артефакт отсутствует» из заглушки)
    expect(find.textContaining('Артефакт'), findsWidgets);
  });
}


