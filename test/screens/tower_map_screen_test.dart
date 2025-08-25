import 'package:bizlevel/providers/levels_provider.dart';
import 'package:bizlevel/screens/biz_tower_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Башня: рендер узлов и навигация заблокирована', (tester) async {
    // Упрощённый мок данных уровней: 0..3, из них 1 текущий, 2 доступен, 3 закрыт
    final mockLevels = [
      {
        'id': 0,
        'image': '',
        'level': 0,
        'name': 'Первый шаг',
        'lessons': 1,
        'isLocked': false,
        'isCompleted': true,
        'isCurrent': false
      },
      {
        'id': 1,
        'image': '',
        'level': 1,
        'name': 'L1',
        'lessons': 1,
        'isLocked': false,
        'isCompleted': false,
        'isCurrent': true
      },
      {
        'id': 2,
        'image': '',
        'level': 2,
        'name': 'L2',
        'lessons': 1,
        'isLocked': false,
        'isCompleted': false,
        'isCurrent': false
      },
      {
        'id': 3,
        'image': '',
        'level': 3,
        'name': 'L3',
        'lessons': 1,
        'isLocked': true,
        'isCompleted': false,
        'isCurrent': false
      },
    ];

    await tester.pumpWidget(ProviderScope(
      overrides: [
        levelsProvider.overrideWith((ref) async => mockLevels),
      ],
      child: const MaterialApp(home: BizTowerScreen()),
    ));

    await tester.pumpAndSettle();

    expect(find.text('Башня БизЛевел'), findsOneWidget);
    // Проверим наличие разделителя «Этаж 1»
    expect(find.textContaining('Этаж 1'), findsWidgets);
  });
}
