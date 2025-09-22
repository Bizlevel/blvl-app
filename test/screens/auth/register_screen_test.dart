import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/screens/auth/register_screen.dart';
import 'package:bizlevel/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// -------------------- Моки --------------------
class MockAuthService extends Mock implements AuthService {}

class MockAuthResponse extends Fake implements AuthResponse {}

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  setUpAll(() {
    registerFallbackValue(MockAuthResponse());
  });

  late MockAuthService mockService;
  late MockGoRouter mockGoRouter;

  setUp(() {
    mockService = MockAuthService();
    mockGoRouter = MockGoRouter();
  });

  Future<void> pumpRegisterScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authServiceProvider.overrideWithValue(mockService),
        ],
        child: MaterialApp(
          home: InheritedGoRouter(
            goRouter: mockGoRouter,
            child: const RegisterScreen(),
          ),
        ),
      ),
    );
  }

  testWidgets('показывает SnackBar при ошибке регистрации',
      (WidgetTester tester) async {
    // arrange: signUp бросает AuthFailure
    when(() => mockService.signUp(
        email: any(named: 'email'),
        password: any(named: 'password'))).thenThrow(AuthFailure('Ошибка'));

    await pumpRegisterScreen(tester);

    // Заполняем поля
    await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password');
    await tester.enterText(find.byType(TextField).at(2), 'password');

    // Tap create account button
    await tester.tap(find.text('Создать аккаунт'));
    await tester.pumpAndSettle(); // дожидаемся завершения всех анимаций

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

    await pumpRegisterScreen(tester);

    await tester.enterText(find.byType(TextField).at(0), 'a@b.com');
    await tester.enterText(find.byType(TextField).at(1), 'pass');
    await tester.enterText(find.byType(TextField).at(2), 'pass');

    await tester.tap(find.text('Создать аккаунт'));
    await tester.pump(); // rebuild после смены состояния -> loading

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // после завершения Future индикатор исчезает
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('показывает сообщение о подтверждении после успешной регистрации',
      (WidgetTester tester) async {
    // arrange: signUp успешно завершается
    when(() => mockService.signUp(
            email: any(named: 'email'), password: any(named: 'password')))
        .thenAnswer((_) async => MockAuthResponse());

    await pumpRegisterScreen(tester);

    // Act
    await tester.enterText(
        find.byKey(const Key('email_field')), 'test@test.com');
    await tester.enterText(find.byKey(const Key('password_field')), 'password');
    await tester.enterText(
        find.byKey(const Key('confirm_password_field')), 'password');

    await tester.tap(find.text('Создать аккаунт'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Регистрация успешна!'), findsOneWidget);
    expect(find.textContaining('Проверьте почту'), findsOneWidget);
    expect(find.text('Уже подтвердили? Войти'), findsOneWidget);
    expect(find.text('Создать аккаунт'), findsNothing); // Форма скрыта
  });

  testWidgets(
      'кнопка "Уже подтвердили? Войти" перенаправляет на /login?registered=true',
      (WidgetTester tester) async {
    // arrange: signUp успешно
    when(() => mockService.signUp(
            email: any(named: 'email'), password: any(named: 'password')))
        .thenAnswer((_) async => MockAuthResponse());

    await pumpRegisterScreen(tester);

    // Act: проходим регистрацию
    await tester.enterText(
        find.byKey(const Key('email_field')), 'test@test.com');
    await tester.enterText(find.byKey(const Key('password_field')), 'password');
    await tester.enterText(
        find.byKey(const Key('confirm_password_field')), 'password');
    await tester.tap(find.text('Создать аккаунт'));
    await tester.pumpAndSettle();

    // Act: нажимаем на кнопку входа
    await tester.tap(find.text('Уже подтвердили? Войти'));
    await tester.pumpAndSettle();

    // Assert: проверяем вызов GoRouter
    verify(() => mockGoRouter.go('/login?registered=true')).called(1);
  });
}
