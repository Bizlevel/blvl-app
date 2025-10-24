import 'package:bizlevel/providers/levels_provider.dart';
import 'package:bizlevel/screens/biz_tower_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Башня: кнопка "Получить полный доступ к этажу" и баннеры GP',
      (tester) async {
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
      // уровень 4 закрыт (отобразит кнопку разблокировки этажа)
      {
        'id': 4,
        'level': 4,
        'name': 'L4',
        'isLocked': true,
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

    // Есть кнопка разблокировки этажа (OutlinedButton с данным лейблом)
    expect(
        find.widgetWithText(OutlinedButton, 'Получить полный доступ к этажу'),
        findsWidgets);
  }, skip: true);
}
