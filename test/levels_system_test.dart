import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:online_course/providers/levels_provider.dart';
import 'package:online_course/providers/lessons_provider.dart';
import 'package:online_course/screens/level_detail_screen.dart';
import 'package:online_course/screens/levels_map_screen.dart';
import 'package:online_course/widgets/level_card.dart';

void main() {
  group('Levels system', () {
    final mockLevels = [
      {
        'id': 1,
        'image': '',
        'level': 1,
        'name': 'Level 1',
        'lessons': 2,
        'isLocked': false,
      },
      {
        'id': 4,
        'image': '',
        'level': 4,
        'name': 'Level 4',
        'lessons': 3,
        'isLocked': true,
      },
    ];

    testWidgets('Levels list loads and displays, lock shown for paid',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            levelsProvider.overrideWith((ref) => mockLevels),
            lessonsProvider.overrideWithProvider(
              (levelId) => FutureProvider((_) async => []),
            ),
          ],
          child: const MaterialApp(home: LevelsMapScreen()),
        ),
      );

      await tester.pumpAndSettle();

      // Should render two LevelCards
      expect(find.byType(LevelCard), findsNWidgets(2));

      // Locked level should show lock icon
      expect(find.byIcon(Icons.lock), findsOneWidget);
    });

    testWidgets('Navigation to LevelDetailScreen works', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            levelsProvider.overrideWith((ref) => mockLevels),
            lessonsProvider.overrideWithProvider(
              (levelId) => FutureProvider((_) async => []),
            ),
          ],
          child: const MaterialApp(home: LevelsMapScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Tap on first unlocked LevelCard
      await tester.tap(find.byType(LevelCard).first);
      await tester.pumpAndSettle();

      expect(find.byType(LevelDetailScreen), findsOneWidget);
    });
  });
}
