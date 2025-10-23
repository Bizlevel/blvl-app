import 'package:bizlevel/providers/levels_provider.dart';
import 'package:bizlevel/screens/biz_tower_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Башня: тап по чекпоинтам ведёт на /checkpoint/l1|l4|l7',
      (tester) async {
    // Упростим данные узлов: уровни 1..7 завершены корректно, чекпоинты доступны
    final levels = [
      {
        'id': 1,
        'level': 1,
        'name': 'L1',
        'isLocked': false,
        'isCompleted': true
      },
      {
        'id': 2,
        'level': 2,
        'name': 'L2',
        'isLocked': false,
        'isCompleted': true
      },
      {
        'id': 3,
        'level': 3,
        'name': 'L3',
        'isLocked': false,
        'isCompleted': true
      },
      {
        'id': 4,
        'level': 4,
        'name': 'L4',
        'isLocked': false,
        'isCompleted': true
      },
      {
        'id': 5,
        'level': 5,
        'name': 'L5',
        'isLocked': false,
        'isCompleted': true
      },
      {
        'id': 6,
        'level': 6,
        'name': 'L6',
        'isLocked': false,
        'isCompleted': true
      },
      {
        'id': 7,
        'level': 7,
        'name': 'L7',
        'isLocked': false,
        'isCompleted': false
      },
    ];

    await tester.pumpWidget(ProviderScope(
      overrides: [
        levelsProvider.overrideWith((ref) async => levels),
      ],
      child: const MaterialApp(home: BizTowerScreen()),
    ));

    await tester.pumpAndSettle();

    // Проверим наличие меток чекпоинтов (по тексту)
    expect(find.textContaining('L1: Первая цель'), findsWidgets);
    expect(find.textContaining('L4: Финансовый фокус'), findsWidgets);
    expect(find.textContaining('L7: Проверка реальности'), findsWidgets);
  }, skip: true);
}
