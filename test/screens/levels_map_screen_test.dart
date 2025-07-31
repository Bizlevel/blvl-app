import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:bizlevel/providers/levels_repository_provider.dart';
import 'package:bizlevel/screens/levels_map_screen.dart';
import 'package:bizlevel/repositories/levels_repository.dart';

// -------------------- Моки --------------------
class MockLevelsRepository extends Mock implements LevelsRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  testWidgets('LevelsMapScreen отображает уровни из репозитория',
      (tester) async {
    final repo = MockLevelsRepository();
    when(() => repo.fetchLevels(userId: any(named: 'userId'))).thenAnswer(
      (_) async => [
        {
          'id': 1,
          'level': 1,
          'name': 'Intro',
          'description': '',
          'image_url': '',
          'is_free': true,
          'lessons': 3,
          'user_progress': []
        },
        {
          'id': 2,
          'level': 2,
          'name': 'Next',
          'description': '',
          'image_url': '',
          'is_free': true,
          'lessons': 4,
          'user_progress': []
        }
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          levelsRepositoryProvider.overrideWithValue(repo),
        ],
        child: const MaterialApp(home: LevelsMapScreen()),
      ),
    );

    // Первоначальный кадр (loading)
    await tester.pumpAndSettle();

    // Ожидаем появления текста названий уровней
    expect(find.text('Intro'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });
}
