import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:bizlevel/screens/auth/login_screen.dart';
import 'package:bizlevel/services/auth_service.dart';
import 'package:bizlevel/providers/auth_provider.dart';

// -------------------- Моки --------------------
class MockAuthService extends Mock implements AuthService {}

class MockAuthResponse extends Fake implements AuthResponse {}

void main() {
  setUpAll(() {
    registerFallbackValue(MockAuthResponse());
  });

  late MockAuthService mockService;
  late GoRouter router;

  setUp(() {
    mockService = MockAuthService();
    router = GoRouter(
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
      ],
      initialLocation: '/login',
    );
  });

  Future<void> pumpLoginScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authServiceProvider.overrideWithValue(mockService),
        ],
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );
  }

  testWidgets('показывает SnackBar при ошибке авторизации',
      (WidgetTester tester) async {
    // arrange: signIn бросает AuthFailure
    when(() => mockService.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'))).thenThrow(AuthFailure('Ошибка'));

    await pumpLoginScreen(tester);

    // Заполняем поля
    await tester.enterText(
        find.byKey(const ValueKey('email_field')), 'test@example.com');
    await tester.enterText(
        find.byKey(const ValueKey('password_field')), 'password');

    // Tap login button
    await tester.tap(find.text('Войти'));
    // pumpAndSettle здесь может зависать из-за фоновых анимаций/виджетов на экране.
    // Для SnackBar достаточно прокачать несколько кадров и дать время анимации появления.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));

    // assert
    expect(find.text('Ошибка'), findsOneWidget);
  });

  testWidgets('кнопка меняет label на «Входим…» во время загрузки',
      (WidgetTester tester) async {
    // arrange: signIn завершается через 100мс
    when(() => mockService.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'))).thenAnswer((_) async {
      await Future.delayed(const Duration(milliseconds: 100));
      return MockAuthResponse();
    });

    await pumpLoginScreen(tester);

    await tester.enterText(
        find.byKey(const ValueKey('email_field')), 'a@b.com');
    await tester.enterText(
        find.byKey(const ValueKey('password_field')), 'pass');

    await tester.tap(find.text('Войти'));
    await tester.pump(); // rebuild после смены состояния -> loading

    expect(find.text('Входим…'), findsOneWidget);

    // после завершения Future label возвращается
    await tester.pump(const Duration(milliseconds: 120));
    expect(find.text('Входим…'), findsNothing);
    expect(find.text('Войти'), findsOneWidget);
  });
}
