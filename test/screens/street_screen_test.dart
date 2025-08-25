import 'package:bizlevel/screens/main_street_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('MainStreetScreen: фон и 5 карточек присутствуют',
      (tester) async {
    await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: MainStreetScreen())));

    await tester.pump();

    expect(find.byType(MainStreetScreen), findsOneWidget);

    // Карточки 3-х рядов
    expect(find.text('Библиотека'), findsOneWidget);
    expect(find.text('Маркетплейс'), findsOneWidget);
    expect(find.text('База тренеров'), findsOneWidget);
    expect(find.text('Коворкинг'), findsOneWidget);
    expect(find.text('Башня БизЛевел'), findsOneWidget);

    // Нет старого индикатора «Этаж 1 •»
    expect(find.textContaining('Этаж 1 •'), findsNothing);
  });

  testWidgets('MainStreetScreen: клики по «Скоро» показывают SnackBar',
      (tester) async {
    await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: MainStreetScreen())));
    await tester.pump();

    await tester.tap(find.text('Библиотека'));
    await tester.pump();
    expect(find.text('Скоро'), findsOneWidget);

    // Закрыть и проверить другую карточку «Скоро»
    ScaffoldMessenger.maybeOf(tester.element(find.byType(MainStreetScreen)))
        ?.clearSnackBars();
    await tester.pump();

    await tester.tap(find.text('Маркетплейс'));
    await tester.pump();
    expect(find.text('Скоро'), findsOneWidget);
  });

  testWidgets(
      'MainStreetScreen: навигация по активным карточкам ведёт на маршруты',
      (tester) async {
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const MainStreetScreen(),
        ),
        GoRoute(
          path: '/chat',
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('CHAT_SCREEN'))),
        ),
        GoRoute(
          path: '/tower',
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('TOWER_SCREEN'))),
        ),
      ],
    );

    await tester.pumpWidget(ProviderScope(
      child: MaterialApp.router(routerConfig: router),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('База тренеров'));
    await tester.pumpAndSettle();
    expect(find.text('CHAT_SCREEN'), findsOneWidget);

    // Вернёмся на /home и проверим переход на /tower
    router.go('/home');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Башня БизЛевел'));
    await tester.pumpAndSettle();
    expect(find.text('TOWER_SCREEN'), findsOneWidget);
  });
}
