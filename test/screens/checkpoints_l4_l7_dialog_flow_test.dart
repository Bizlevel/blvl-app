import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/screens/checkpoints/checkpoint_l4_screen.dart';
import 'package:bizlevel/screens/checkpoints/checkpoint_l7_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('L4 shows dialog button and finish button', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        userGoalProvider.overrideWith((ref) async => {
              'goal_text': 'Клиенты: 100 → 150 к 2025-12-31',
            }),
      ],
      child: const MaterialApp(home: CheckpointL4Screen()),
    ));

    await tester.pumpAndSettle();
    expect(find.text('Обсудить с Максом'), findsOneWidget);
    expect(find.text('Завершить чекпоинт →'), findsOneWidget);
  });

  testWidgets('L7 shows added actions', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        userGoalProvider.overrideWith((ref) async => {
              'goal_text': 'Клиенты: 100 → 150 к 2025-12-31',
              'metric_type': 'Клиенты/день',
              'metric_current': 110,
              'metric_target': 150,
              'target_date': DateTime.now()
                  .add(const Duration(days: 30))
                  .toIso8601String(),
            }),
        practiceLogProvider
            .overrideWith((ref) async => const <Map<String, dynamic>>[]),
      ],
      child: const MaterialApp(home: CheckpointL7Screen()),
    ));

    await tester.pumpAndSettle();
    expect(find.text('Обсудить с Максом'), findsOneWidget);
    expect(find.text('Настроить напоминания'), findsOneWidget);
  });
}
