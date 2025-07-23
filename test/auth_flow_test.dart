import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:online_course/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:online_course/services/supabase_service.dart'; // for initialize

void main() {
  late AuthService authService;

  setUpAll(() async {
    await SupabaseService.initialize();
    authService = AuthService(Supabase.instance.client);
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
          await authService.signUp(email: email, password: password);
      expect(response.user, isNotNull);
      expect(response.session, isNotNull);
    });

    test('2) Сохранение онбординга', () async {
      await authService.updateProfile(name: name, about: about, goal: goal);

      final user = authService.getCurrentUser();
      expect(user, isNotNull);
      final data = await Supabase.instance.client
          .from('users')
          .select()
          .eq('id', user!.id)
          .single();

      expect(data['name'], equals(name));
      expect(data['about'], equals(about));
      expect(data['goal'], equals(goal));
    });

    test('3) Выход и повторный вход', () async {
      await authService.signOut();
      expect(authService.getCurrentUser(), isNull);

      final signIn = await authService.signIn(email: email, password: password);
      expect(signIn.user, isNotNull);
    });

    test('4) Ошибка при неверном пароле', () async {
      await authService.signOut();
      expect(
        () => authService.signIn(email: email, password: 'wrong-pass'),
        throwsA(isA<AuthFailure>()),
      );
    });
  });
}
