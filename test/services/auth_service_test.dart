import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:online_course/services/auth_service.dart';

// -------------------- Моки --------------------
class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockAuthResponse extends Fake implements AuthResponse {}

class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}

class MockUser extends Mock implements User {}

void main() {
  setUpAll(() {
    // Регистрируем значения по умолчанию для параметров-мэпов,
    // иначе mocktail не сможет сопоставить generic-типы.
    registerFallbackValue(<String, dynamic>{});
  });

  late MockSupabaseClient client;
  late MockGoTrueClient auth;
  late AuthService service;

  setUp(() {
    client = MockSupabaseClient();
    auth = MockGoTrueClient();

    // Связываем client.auth → mock auth
    when(() => client.auth).thenReturn(auth);

    service = AuthService(client);
  });

  group('signIn', () {
    test('вызывает signInWithPassword и возвращает результат', () async {
      final response = MockAuthResponse();
      when(() => response.user).thenReturn(null);

      when(() => auth.signInWithPassword(email: 'e', password: 'p'))
          .thenAnswer((_) async => response);

      final result = await service.signIn(email: 'e', password: 'p');

      expect(result, same(response));
      verify(() => auth.signInWithPassword(email: 'e', password: 'p'))
          .called(1);
    });

    test('преобразует AuthException в AuthFailure', () async {
      when(() => auth.signInWithPassword(
              email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(AuthException('Invalid'));

      expect(
        () => service.signIn(email: 'e', password: 'p'),
        throwsA(
            isA<AuthFailure>().having((e) => e.message, 'message', 'Invalid')),
      );
    });
  });

  group('signOut', () {
    test('делегирует вызов auth.signOut', () async {
      when(() => auth.signOut()).thenAnswer((_) async => {});

      await service.signOut();

      verify(() => auth.signOut()).called(1);
    });
  });

  group('updateProfile', () {
    late MockUser user;
    late dynamic builder;

    setUp(() {
      // Мокаем текущего пользователя
      user = MockUser();
      when(() => user.id).thenReturn('uid');
      when(() => user.email).thenReturn('test@example.com');
      when(() => auth.currentUser).thenReturn(user);

      // Мокаем builder для upsert
      builder = MockSupabaseQueryBuilder();
      when(() => client.from('users')).thenReturn(builder as dynamic);
      when(() => (builder as dynamic).upsert(any<dynamic>()))
          .thenAnswer((_) async => Future.value());
    });

    test('формирует payload без onboarding_completed по умолчанию', () async {
      await service.updateProfile(name: 'N', about: 'A', goal: 'G');

      final captured = verify(() => (builder as dynamic).upsert(captureAny()))
          .captured
          .single as Map<String, dynamic>;

      expect(captured['name'], 'N');
      expect(captured.containsKey('onboarding_completed'), isFalse);
    });

    test('добавляет onboarding_completed, если передано', () async {
      await service.updateProfile(
          name: 'N', about: 'A', goal: 'G', onboardingCompleted: true);

      final captured = verify(() => (builder as dynamic).upsert(captureAny()))
          .captured
          .single as Map<String, dynamic>;

      expect(captured['onboarding_completed'], true);
    });

    test('бросает AuthFailure, если пользователь не авторизован', () async {
      when(() => auth.currentUser).thenReturn(null);

      expect(
        () => service.updateProfile(name: 'N', about: 'A', goal: 'G'),
        throwsA(isA<AuthFailure>()),
      );
    });
  });
}
