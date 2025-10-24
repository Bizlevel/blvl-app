import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/screens/goal/widgets/next_action_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child,
      {Map<String, dynamic>? goal, Map<String, dynamic>? state}) {
    return ProviderScope(
      overrides: [
        userGoalProvider.overrideWith((ref) async => goal),
        goalStateProvider.overrideWith((ref) async =>
            state ?? const {'l1Done': false, 'l4Done': false, 'l7Done': false}),
      ],
      child: MaterialApp(home: Scaffold(body: child)),
    );
  }

  testWidgets('NextActionBanner: предлагает L1, когда цель не задана',
      (tester) async {
    await tester.pumpWidget(wrap(const NextActionBanner(currentLevel: 1)));
    await tester.pump();
    expect(find.textContaining('Сформулируйте первую цель'), findsOneWidget);
    expect(find.textContaining('Перейти к чекпоинту L1'), findsOneWidget);
  });

  testWidgets('NextActionBanner: предлагает L4 после L1', (tester) async {
    final goal = {'goal_text': 'Цель'};
    final state = {'l1Done': true, 'l4Done': false, 'l7Done': false};
    await tester.pumpWidget(wrap(const NextActionBanner(currentLevel: 1),
        goal: goal, state: state));
    await tester.pump();
    expect(find.textContaining('Добавьте финансовый фокус'), findsOneWidget);
    expect(find.textContaining('Перейти к чекпоинту L4'), findsOneWidget);
  });

  testWidgets('NextActionBanner: предлагает L7 при наличии дедлайна',
      (tester) async {
    final goal = {
      'goal_text': 'Цель',
      'target_date':
          DateTime.now().add(const Duration(days: 10)).toIso8601String(),
    };
    final state = {'l1Done': true, 'l4Done': true, 'l7Done': false};
    await tester.pumpWidget(wrap(const NextActionBanner(currentLevel: 1),
        goal: goal, state: state));
    await tester.pump();
    expect(
        find.textContaining('Проверьте реалистичность цели'), findsOneWidget);
    expect(find.textContaining('Перейти к чекпоинту L7'), findsOneWidget);
  });

  testWidgets(
      'NextActionBanner: когда всё сделано — предлагает запись в журнал',
      (tester) async {
    final goal = {
      'goal_text': 'Цель',
      'financial_focus': 'Фокус',
      'action_plan_note': 'План',
      'target_date': DateTime.now().toIso8601String(),
    };
    final state = {'l1Done': true, 'l4Done': true, 'l7Done': true};
    await tester.pumpWidget(wrap(const NextActionBanner(currentLevel: 1),
        goal: goal, state: state));
    await tester.pump();
    expect(find.textContaining('Двигайте цель ежедневными применениями'),
        findsOneWidget);
    expect(find.textContaining('Добавить запись в журнал'), findsOneWidget);
  });
}
