import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:bizlevel/screens/level_detail_screen.dart';
import 'package:bizlevel/providers/lessons_provider.dart';
import 'package:bizlevel/models/lesson_model.dart';
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/services/auth_service.dart';

class _MockAuthService extends Mock implements AuthService {}

void main() {
  setUpAll(() {
    registerFallbackValue(<LessonModel>[]);
  });

  testWidgets('Level 0: Intro → Next → Profile save calls updateProfile',
      (tester) async {
    final mockAuth = _MockAuthService();
    when(() => mockAuth.getCurrentUser()).thenReturn(null);
    when(() => mockAuth.updateProfile(
          name: any(named: 'name'),
          about: any(named: 'about'),
          goal: any(named: 'goal'),
          avatarId: any(named: 'avatarId'),
        )).thenAnswer((_) async {});

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          lessonsProvider.overrideWithProvider(
            FutureProvider.family<List<LessonModel>, int>((ref, levelId) async {
              return <LessonModel>[];
            }),
          ),
          authServiceProvider.overrideWithValue(mockAuth),
        ],
        child: const MaterialApp(
          home: LevelDetailScreen(levelId: 1000, levelNumber: 0),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Нажать «Далее» (из навигации уровня) для перехода со вступления на следующий блок
    final nextButtonFinder = find.text('Далее');
    if (nextButtonFinder.evaluate().isNotEmpty) {
      await tester.tap(nextButtonFinder.first);
    }
    await tester.pumpAndSettle();

    // В форме профиля три текстовых поля
    final textFields = find.byType(TextField);
    expect(textFields, findsNWidgets(3));
    await tester.enterText(textFields.at(0), 'Иван');
    await tester.enterText(textFields.at(1), 'О себе');
    await tester.enterText(textFields.at(2), 'Цель');

    // Кнопка «Далее» внутри формы профиля
    await tester.tap(find.text('Далее'));
    await tester.pumpAndSettle();

    verify(() => mockAuth.updateProfile(
          name: any(named: 'name'),
          about: any(named: 'about'),
          goal: any(named: 'goal'),
          avatarId: any(named: 'avatarId'),
        )).called(1);
  });
}
