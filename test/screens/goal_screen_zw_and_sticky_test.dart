import 'package:bizlevel/screens/goal_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bizlevel/providers/goals_providers.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('GoalScreen shows Z/W string and sticky CTA on mobile',
      (tester) async {
    // Эмуляция узкого экрана
    tester.view.physicalSize = const Size(375, 800);
    tester.view.devicePixelRatio = 1.0;

    final goal = <String, dynamic>{
      'goal_text': 'Клиенты: 200 → 220 к 2025-11-30',
      'metric_type': 'Клиенты/день',
      'metric_start': 200,
      'metric_current': 200,
      'metric_target': 220,
      'target_date':
          DateTime.now().add(const Duration(days: 69)).toIso8601String(),
    };
    final practice = <Map<String, dynamic>>[
      {
        'applied_at':
            DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        'applied_tools': const ['Матрица приоритетов']
      }
    ];

    await tester.pumpWidget(ProviderScope(
      overrides: [
        userGoalProvider.overrideWith((ref) async => goal),
        practiceLogProvider.overrideWith((ref) async => practice),
        usedToolsOptionsProvider
            .overrideWith((ref) async => const ['Матрица приоритетов']),
      ],
      child: const MaterialApp(home: GoalScreen()),
    ));

    await tester.pumpAndSettle();

    expect(find.textContaining('Z:'), findsOneWidget);
    expect(find.textContaining('W:'), findsOneWidget);
    // sticky‑панель содержит две кнопки
    expect(find.text('Добавить запись'), findsOneWidget);
    expect(find.text('Обсудить с Максом'), findsOneWidget);

    // Вернуть размер
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });

  testWidgets('GoalScreen empty journal shows friendly state', (tester) async {
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

    expect(find.textContaining('Пока записей нет'), findsOneWidget);
  });
}
