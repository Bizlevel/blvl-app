import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/screens/auth/register_screen.dart';
import 'package:bizlevel/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  Future<void> _pumpRegisterScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authServiceProvider.overrideWithValue(mockService),
        ],
        child: const MaterialApp(home: RegisterScreen()),
      ),
    );
  }

  testWidgets('показывает SnackBar при ошибке регистрации',
      (WidgetTester tester) async {
    // arrange: signUp бросает AuthFailure
    when(() => mockService.signUp(
        email: any(named: 'email'),
        password: any(named: 'password'))).thenThrow(AuthFailure('Ошибка'));

    await _pumpRegisterScreen(tester);

    // Заполняем поля
    await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password');
    await tester.enterText(find.byType(TextField).at(2), 'password');

    // Tap create account button
    await tester.tap(find.text('Создать аккаунт'));
    await tester.pump(); // начало анимации SnackBar

    // assert
    expect(find.text('Ошибка'), findsOneWidget);
  });

  testWidgets('кнопка показывает CircularProgressIndicator во время загрузки',
      (WidgetTester tester) async {
    // arrange: signUp завершается через 100мс
    when(() => mockService.signUp(
        email: any(named: 'email'),
        password: any(named: 'password'))).thenAnswer((_) async {
      await Future.delayed(const Duration(milliseconds: 100));
      return MockAuthResponse();
    });

    await _pumpRegisterScreen(tester);

    await tester.enterText(find.byType(TextField).at(0), 'a@b.com');
    await tester.enterText(find.byType(TextField).at(1), 'pass');
    await tester.enterText(find.byType(TextField).at(2), 'pass');

    await tester.tap(find.text('Создать аккаунт'));
    await tester.pump(); // rebuild после смены состояния -> loading

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // после завершения Future индикатор исчезает
    await tester.pump(const Duration(milliseconds: 120));
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Создать аккаунт'), findsOneWidget);
  });
}
