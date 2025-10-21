import 'package:bizlevel/screens/goal_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bizlevel/providers/goals_providers.dart';

void main() {
  testWidgets('Top-3 tools buttons select tool and sync with dropdown',
      (tester) async {
    final goal = <String, dynamic>{
      'goal_text': 'Клиенты: 100 → 150 к 2025-12-31',
      'metric_type': 'Клиенты/день',
      'metric_start': 100,
      'metric_current': 110,
      'metric_target': 150,
      'target_date':
          DateTime.now().add(const Duration(days: 60)).toIso8601String(),
    };
    final practice = <Map<String, dynamic>>[
      {
        'applied_at': DateTime.now().toIso8601String(),
        'applied_tools': const ['Матрица Эйзенхауэра']
      },
      {
        'applied_at': DateTime.now().toIso8601String(),
        'applied_tools': const ['Финансовый учёт']
      },
      {
        'applied_at': DateTime.now().toIso8601String(),
        'applied_tools': const ['УТП']
      },
    ];

    await tester.pumpWidget(ProviderScope(
      overrides: [
        userGoalProvider.overrideWith((ref) async => goal),
        practiceLogProvider.overrideWith((ref) async => practice),
        usedToolsOptionsProvider.overrideWith((ref) async => const [
              'Матрица Эйзенхауэра',
              'Финансовый учёт',
              'УТП',
              'SMART‑планирование',
            ]),
      ],
      child: const MaterialApp(home: GoalScreen()),
    ));

    await tester.pumpAndSettle();

    // Кнопки топ-3 должны отрендериться и быть кликабельными
    expect(find.text('Матрица Эйзенхауэра'), findsWidgets);
    await tester
        .tap(find.widgetWithText(OutlinedButton, 'Матрица Эйзенхауэра').first);
    await tester.pumpAndSettle();

    // Dropdown присутствует и может переключаться на "Другие навыки"
    expect(find.text('Другие навыки'), findsOneWidget);
  });
}
