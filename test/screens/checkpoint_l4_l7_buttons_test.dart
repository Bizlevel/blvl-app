import 'package:bizlevel/screens/checkpoints/checkpoint_l4_screen.dart';
import 'package:bizlevel/screens/checkpoints/checkpoint_l7_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bizlevel/providers/goals_providers.dart';

void main() {
  testWidgets('L4 shows action buttons', (tester) async {
    await tester.pumpWidget(const ProviderScope(
      child: MaterialApp(home: CheckpointL4Screen()),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Добавить метрику'), findsOneWidget);
    expect(find.text('Оставить как есть'), findsOneWidget);
  });

  testWidgets('L7 shows three options', (tester) async {
    final mockGoal = <String, dynamic>{
      'goal_text': 'Тестовая цель',
      'metric_type': 'клиенты/день',
      'metric_current': 1,
      'metric_target': 10,
      'target_date':
          DateTime.now().add(const Duration(days: 14)).toIso8601String(),
    };
    await tester.pumpWidget(ProviderScope(
      overrides: [
        userGoalProvider.overrideWith((ref) async => mockGoal),
        practiceLogProvider
            .overrideWith((ref) async => const <Map<String, dynamic>>[]),
      ],
      child: const MaterialApp(home: CheckpointL7Screen()),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Усилить применение'), findsOneWidget);
    expect(find.text('Скорректировать цель'), findsOneWidget);
    expect(find.text('Продолжить текущий темп'), findsOneWidget);
  });
}

