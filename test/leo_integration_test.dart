@Skip('requires real Supabase env')
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:bizlevel/services/auth_service.dart';
import 'package:bizlevel/services/leo_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bizlevel/services/supabase_service.dart'; // for initialize

void main() {
  late AuthService authService;

  setUpAll(() async {
    await SupabaseService.initialize();
    authService = AuthService(Supabase.instance.client);
  });

  group('Интеграция Leo AI', () {
    late String email;
    const password = 'Passw0rd!';
    late String chatId;
    int initialLimit = 0;

    test('1) Регистрация пользователя', () async {
      final rng = Random();
      email =
          'leo_test_${DateTime.now().millisecondsSinceEpoch}${rng.nextInt(999)}@example.com';

      final res = await authService.signUp(email: email, password: password);
      expect(res.user, isNotNull);

      // после регистрации лимит должен быть 30 (Free)
      final leo = LeoService(Supabase.instance.client);
      initialLimit = await leo.checkMessageLimit();
      expect(initialLimit, greaterThan(0));
    });

    test('2) Отправка сообщения и получение ответа', () async {
      // создаём пустой чат
      final leo = LeoService(Supabase.instance.client);
      chatId =
          await leo.saveConversation(role: 'user', content: 'Привет, Leo!');

      final response = await leo.sendMessage(messages: [
        {'role': 'user', 'content': 'Привет, Leo! Расскажи шутку из бизнеса.'}
      ]);

      expect(response['message'], isNotNull);
      expect(response['message']['content'], isNotEmpty);

      // сохраняем ответ в историю
      await leo.saveConversation(
        chatId: chatId,
        role: 'assistant',
        content: response['message']['content'],
      );
    });

    test('3) Проверка уменьшения лимита', () async {
      final leo = LeoService(Supabase.instance.client);
      final afterLimit = await leo.checkMessageLimit();
      expect(afterLimit, equals(initialLimit - 1));
    });

    test('4) Проверка истории сообщений', () async {
      final history = await Supabase.instance.client
          .from('leo_messages')
          .select()
          .eq('chat_id', chatId);

      // должно быть как минимум 2 сообщения
      expect((history as List).length, greaterThanOrEqualTo(2));
    });

    test('5) Ошибка при пустом массиве messages', () async {
      final leo = LeoService(Supabase.instance.client);
      expect(
        () => leo.sendMessage(messages: []),
        throwsA(isA<LeoFailure>()),
      );
    });
  });
}
