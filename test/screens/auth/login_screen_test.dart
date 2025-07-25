import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:bizlevel/screens/auth/login_screen.dart';
import 'package:bizlevel/services/auth_service.dart';
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/providers/login_controller.dart';

// -------------------- Моки --------------------
class MockAuthService extends Mock implements AuthService {}

class MockAuthResponse extends Fake implements AuthResponse {}

void main() {
  setUpAll(() {
    registerFallbackValue(MockAuthResponse());
  });

  late MockAuthService mockService;

  setUp(() {
    mockService = MockAuthService();
  });

  Future<void> _pumpLoginScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authServiceProvider.overrideWithValue(mockService),
        ],
        child: const MaterialApp(home: LoginScreen()),
      ),
    );
  }

  testWidgets('показывает SnackBar при ошибке авторизации',
      (WidgetTester tester) async {
    // arrange: signIn бросает AuthFailure
    when(() => mockService.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'))).thenThrow(AuthFailure('Ошибка'));

    await _pumpLoginScreen(tester);

    // Заполняем поля
    await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password');

    // Tap login button
    await tester.tap(find.text('Войти'));
    await tester.pump(); // начало анимации SnackBar

    // assert
    expect(find.text('Ошибка'), findsOneWidget);
  });

  testWidgets('кнопка показывает CircularProgressIndicator во время загрузки',
      (WidgetTester tester) async {
    // arrange: signIn завершается через 100мс
    when(() => mockService.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'))).thenAnswer((_) async {
      await Future.delayed(const Duration(milliseconds: 100));
      return MockAuthResponse();
    });

    await _pumpLoginScreen(tester);

    await tester.enterText(find.byType(TextField).at(0), 'a@b.com');
    await tester.enterText(find.byType(TextField).at(1), 'pass');

    await tester.tap(find.text('Войти'));
    await tester.pump(); // rebuild после смены состояния -> loading

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // после завершения Future индикатор исчезает
    await tester.pump(const Duration(milliseconds: 120));
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Войти'), findsOneWidget);
  });
}
