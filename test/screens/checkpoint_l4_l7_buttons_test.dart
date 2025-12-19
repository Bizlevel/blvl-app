import 'package:bizlevel/screens/checkpoints/checkpoint_l4_screen.dart';
import 'package:bizlevel/screens/checkpoints/checkpoint_l7_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:bizlevel/providers/goals_providers.dart';

void main() {
  testWidgets('L4: кнопка «Завершить чекпоинт →» ведёт в башню', (tester) async {
    final mockGoal = <String, dynamic>{
      'goal_text': 'Тестовая цель',
      'metric_type': 'клиенты/день',
      'metric_current': 1,
      'metric_target': 10,
      'target_date':
          DateTime.now().add(const Duration(days: 14)).toIso8601String(),
    };

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (_, __) => const CheckpointL4Screen()),
        GoRoute(
          path: '/tower',
          builder: (_, __) => const Scaffold(body: Text('TOWER_SCREEN')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userGoalProvider.overrideWith((ref) async => mockGoal),
          practiceLogProvider
              .overrideWith((ref) async => const <Map<String, dynamic>>[]),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Чекпоинт: Регулярность'), findsOneWidget);
    expect(find.text('Завершить чекпоинт →'), findsOneWidget);

    await tester.tap(find.text('Завершить чекпоинт →'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('TOWER_SCREEN'), findsOneWidget);
  });

  testWidgets('L7: показывает кнопки действий (напоминания + завершение)',
      (tester) async {
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
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Чекпоинт: Система поддержки'), findsOneWidget);
    expect(find.text('Настроить напоминания'), findsOneWidget);
    expect(find.text('Завершить чекпоинт →'), findsOneWidget);
  });
}

