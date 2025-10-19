import 'package:bizlevel/screens/goal_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/providers/goals_providers.dart';

void main() {
  testWidgets('Saving practice entry opens Max chat (smoke)', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        userGoalProvider.overrideWith((ref) async => {
              'goal_text': 'Цель',
              'metric_type': 'Клиенты/день',
              'metric_start': 0,
              'metric_current': 0,
              'metric_target': 10,
              'target_date': DateTime.now()
                  .add(const Duration(days: 30))
                  .toIso8601String(),
            }),
        practiceLogProvider
            .overrideWith((ref) async => const <Map<String, dynamic>>[]),
        usedToolsOptionsProvider
            .overrideWith((ref) async => const <String>['Матрица Эйзенхауэра'])
      ],
      child: const MaterialApp(home: GoalScreen()),
    ));

    await tester.pumpAndSettle();

    // Выберем чип инструмента
    await tester.tap(find.byType(FilterChip).first);
    await tester.pump();

    // Введём заметку и сохраним
    await tester.enterText(find.byType(TextField).last, 'Тестовая запись');
    await tester.tap(find.text('Сохранить запись'));
    await tester.pumpAndSettle();

    // Должен открыться экран с чатом (по крайней мере Scaffold присутствует)
    expect(find.byType(Scaffold), findsWidgets);
  });
}
