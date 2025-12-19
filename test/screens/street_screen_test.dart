import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/providers/gp_providers.dart';
import 'package:bizlevel/providers/library_providers.dart';
import 'package:bizlevel/providers/levels_provider.dart';
import 'package:bizlevel/screens/main_street_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  final mockLevels = <Map<String, dynamic>>[
    {
      'id': 1,
      'level': 1,
      'floor': 1,
      'name': 'Уровень 1',
      'isLocked': false,
      'isCompleted': true,
      'isCurrent': false,
    },
    {
      'id': 2,
      'level': 2,
      'floor': 1,
      'name': 'Уровень 2',
      'isLocked': false,
      'isCompleted': false,
      'isCurrent': true,
    },
  ];

  final mockNext = <String, dynamic>{
    'levelId': 2,
    'levelNumber': 2,
    'floorId': 1,
    'requiresPremium': false,
    'isLocked': false,
    'targetScroll': 2,
    'label': 'Уровень 2',
    'levelTitle': 'Стресс-Менеджмент',
  };

  ProviderScope wrap(Widget child) {
    return ProviderScope(
      overrides: [
        // Убираем тяжелые цепочки (Supabase/Hive) — эти тесты про UI главного экрана.
        levelsProvider.overrideWith((ref) async => mockLevels),
        nextLevelToContinueProvider.overrideWith((ref) async => mockNext),
        libraryTotalCountProvider.overrideWith((ref) async => 10),
        gpBalanceProvider.overrideWith((ref) async => const {
              'balance': 5,
              'total_earned': 5,
              'total_spent': 0,
            }),
        userGoalProvider.overrideWith((ref) async => <String, dynamic>{
              'goal_text': 'Тестовая цель',
            }),
        practiceLogProvider
            .overrideWith((ref) async => const <Map<String, dynamic>>[]),
        // Цитата дня в этих тестах не важна — фиксируем null для стабильности.
        dailyQuoteProvider.overrideWith((ref) async => null),
      ],
      child: child,
    );
  }

  testWidgets('MainStreetScreen рендерит ключевые блоки (smoke)', (tester) async {
    await tester.pumpWidget(wrap(const MaterialApp(home: MainStreetScreen())));
    await tester.pump(); // resolve FutureProvider microtasks
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.byType(MainStreetScreen), findsOneWidget);
    expect(find.text('Продолжить обучение'), findsOneWidget);
    expect(find.text('Библиотека'), findsOneWidget);
    expect(find.text('Артефакты'), findsOneWidget);
  });

  testWidgets('Quick tile «Библиотека» ведёт на /library', (tester) async {
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const MainStreetScreen(),
        ),
        GoRoute(
          path: '/library',
          builder: (context, state) =>
              const Scaffold(body: Text('LIBRARY_SCREEN')),
        ),
      ],
    );

    await tester.pumpWidget(wrap(MaterialApp.router(routerConfig: router)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    await tester.tap(find.text('Библиотека'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('LIBRARY_SCREEN'), findsOneWidget);
  });
}
