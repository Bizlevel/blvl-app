import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/screens/goal_checkpoint_screen.dart';
import 'package:bizlevel/providers/goals_providers.dart';

void main() {
  testWidgets('GoalCheckpointScreen shows step indicator', (tester) async {
    final container = ProviderContainer(overrides: [
      goalVersionsProvider.overrideWith((ref) async => []),
      goalProgressProvider
          .overrideWithProvider((version) => FutureProvider((ref) async => {
                'version': version,
                'versionData': <String, dynamic>{},
                'completedFields': <String>[],
              })),
    ]);
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: GoalCheckpointScreen(version: 2)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Поле '), findsOneWidget);
  });
}
