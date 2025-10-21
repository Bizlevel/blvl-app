import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/screens/checkpoints/checkpoint_l7_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CheckpointL7Screen renders Z/W and options', (tester) async {
    final mockGoal = <String, dynamic>{
      'goal_text': 'Увеличить выручку через改善 процессов отдела продаж',
      'metric_type': 'денег/день',
      'metric_current': 5,
      'metric_target': 20,
      'target_date':
          DateTime.now().add(const Duration(days: 30)).toIso8601String(),
    };
    final now = DateTime.now();
    final mockItems = List.generate(8, (i) {
      return <String, dynamic>{
        'applied_at': now.subtract(Duration(days: i)).toIso8601String(),
        'applied_tools': <String>['tool_$i'],
        'note': 'n$i',
      };
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userGoalProvider.overrideWith((ref) async => mockGoal),
          practiceLogProvider.overrideWith((ref) async => mockItems),
        ],
        child: const MaterialApp(
          home: CheckpointL7Screen(),
        ),
      ),
    );

    // Initial frame
    await tester.pumpAndSettle();

    expect(find.text('Чекпоинт: Проверка реальности'), findsOneWidget);
    expect(find.textContaining('Текущий темп (Z):'), findsOneWidget);
    expect(find.textContaining('Нужный темп (W):'), findsOneWidget);
    expect(find.text('Усилить применение'), findsOneWidget);
    expect(find.text('Скорректировать цель'), findsOneWidget);
    expect(find.text('Продолжить текущий темп'), findsOneWidget);
  });
}
