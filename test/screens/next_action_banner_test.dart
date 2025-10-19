import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bizlevel/screens/goal/widgets/next_action_banner.dart';
import 'package:bizlevel/providers/goals_providers.dart';

void main() {
  Widget _wrap(Widget child,
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

  testWidgets('L1 suggested', (tester) async {
    await tester.pumpWidget(_wrap(const NextActionBanner(currentLevel: 1)));
    await tester.pump();
    expect(find.textContaining('Сформулируйте первую цель'), findsOneWidget);
  });

  testWidgets('L4 suggested', (tester) async {
    final goal = {'goal_text': 'Цель'};
    final state = {'l1Done': true, 'l4Done': false, 'l7Done': false};
    await tester.pumpWidget(_wrap(const NextActionBanner(currentLevel: 1),
        goal: goal, state: state));
    await tester.pump();
    expect(find.textContaining('Добавьте финансовый фокус'), findsOneWidget);
  });

  testWidgets('L7 suggested when deadline exists', (tester) async {
    final goal = {
      'goal_text': 'Цель',
      'target_date':
          DateTime.now().add(const Duration(days: 10)).toIso8601String(),
    };
    final state = {'l1Done': true, 'l4Done': true, 'l7Done': false};
    await tester.pumpWidget(_wrap(const NextActionBanner(currentLevel: 1),
        goal: goal, state: state));
    await tester.pump();
    expect(find.textContaining('Перейти к чекпоинту L7'), findsOneWidget);
  });

  testWidgets('Journal CTA when all done', (tester) async {
    final goal = {
      'goal_text': 'Цель',
      'target_date':
          DateTime.now().add(const Duration(days: 10)).toIso8601String(),
    };
    final state = {'l1Done': true, 'l4Done': true, 'l7Done': true};
    int scrolled = 0;
    await tester.pumpWidget(ProviderScope(
      overrides: [
        userGoalProvider.overrideWith((ref) async => goal),
        goalStateProvider.overrideWith((ref) async => state),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: NextActionBanner(
            currentLevel: 2,
            onScrollToSprint: () => scrolled++,
          ),
        ),
      ),
    ));
    await tester.pump();
    expect(find.textContaining('Добавить запись в журнал'), findsOneWidget);
    await tester.tap(find.text('Добавить запись в журнал'));
    expect(scrolled, 1);
  });
}
