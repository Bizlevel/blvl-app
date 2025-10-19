import 'package:bizlevel/screens/checkpoints/checkpoint_l7_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bizlevel/providers/goals_providers.dart';

void main() {
  testWidgets('L7 primary CTA navigates to Goal with prefill', (tester) async {
    final goal = <String, dynamic>{
      'goal_text': 'Цель',
      'metric_type': 'Клиенты/день',
      'metric_current': 1,
      'metric_target': 10,
      'target_date':
          DateTime.now().add(const Duration(days: 14)).toIso8601String(),
    };
    await tester.pumpWidget(ProviderScope(
      overrides: [
        userGoalProvider.overrideWith((ref) async => goal),
        practiceLogProvider
            .overrideWith((ref) async => const <Map<String, dynamic>>[]),
      ],
      child: MaterialApp(
        routes: {
          '/goal': (_) => const Scaffold(body: Text('GOAL_SCREEN')),
        },
        home: const CheckpointL7Screen(),
      ),
    ));

    await tester.pumpAndSettle();

    await tester.tap(find.text('Усилить применение'));
    await tester.pumpAndSettle();

    // Так как мы навигируем на /goal, должен появиться виджет с текстом
    expect(find.text('GOAL_SCREEN'), findsOneWidget);
  });
}
