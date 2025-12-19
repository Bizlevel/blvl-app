import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/screens/checkpoints/checkpoint_l7_screen.dart';

void main() {
  testWidgets('L7 CTA «Завершить чекпоинт» ведёт в башню', (tester) async {
    // На дефолтном тестовом viewport L7 может давать RenderFlex overflow из-за высокого чата.
    // Делаем экран "высоким", ближе к реальным мобилкам.
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1080, 1920);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final goal = <String, dynamic>{
      'goal_text': 'Цель',
      'metric_type': 'Клиенты/день',
      'metric_current': 1,
      'metric_target': 10,
      'target_date':
          DateTime.now().add(const Duration(days: 14)).toIso8601String(),
    };

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const CheckpointL7Screen(),
        ),
        GoRoute(
          path: '/tower',
          builder: (context, state) =>
              const Scaffold(body: Text('TOWER_SCREEN')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userGoalProvider.overrideWith((ref) async => goal),
          practiceLogProvider
              .overrideWith((ref) async => const <Map<String, dynamic>>[]),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump(); // первый кадр
    await tester.pump(const Duration(milliseconds: 50));

    await tester.tap(find.text('Завершить чекпоинт →'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('TOWER_SCREEN'), findsOneWidget);
  });
}
