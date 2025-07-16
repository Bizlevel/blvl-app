import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:online_course/services/auth_service.dart';
import 'package:online_course/services/supabase_service.dart';

void main() {
  setUpAll(() async {
    await SupabaseService.initialize();
  });

  group('Полный флоу авторизации', () {
    late String email;
    const password = 'Passw0rd!';
    const name = 'Tester';
    const about = 'Integration test user';
    const goal = 'Learn Biz';

    test('1) Регистрация пользователя', () async {
      final rng = Random();
      email =
          'test_${DateTime.now().millisecondsSinceEpoch}${rng.nextInt(999)}@example.com';

      final response =
          await AuthService.signUp(email: email, password: password);
      expect(response.user, isNotNull);
      expect(response.session, isNotNull);
    });

    test('2) Сохранение онбординга', () async {
      await AuthService.updateProfile(name: name, about: about, goal: goal);

      final user = AuthService.getCurrentUser();
      expect(user, isNotNull);
      final data = await SupabaseService.client
          .from('users')
          .select()
          .eq('id', user!.id)
          .single();

      expect(data['name'], equals(name));
      expect(data['about'], equals(about));
      expect(data['goal'], equals(goal));
    });

    test('3) Выход и повторный вход', () async {
      await AuthService.signOut();
      expect(AuthService.getCurrentUser(), isNull);

      final signIn = await AuthService.signIn(email: email, password: password);
      expect(signIn.user, isNotNull);
    });

    test('4) Ошибка при неверном пароле', () async {
      await AuthService.signOut();
      expect(
        () => AuthService.signIn(email: email, password: 'wrong-pass'),
        throwsA(isA<AuthFailure>()),
      );
    });
  });
}
