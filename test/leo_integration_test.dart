import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:online_course/services/auth_service.dart';
import 'package:online_course/services/leo_service.dart';
import 'package:online_course/services/supabase_service.dart';

void main() {
  setUpAll(() async {
    await SupabaseService.initialize();
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

      final res = await AuthService.signUp(email: email, password: password);
      expect(res.user, isNotNull);

      // после регистрации лимит должен быть 30 (Free)
      initialLimit = await LeoService.checkMessageLimit();
      expect(initialLimit, greaterThan(0));
    });

    test('2) Отправка сообщения и получение ответа', () async {
      // создаём пустой чат
      chatId = await LeoService.saveConversation(
          role: 'user', content: 'Привет, Leo!');

      final response = await LeoService.sendMessage(messages: [
        {'role': 'user', 'content': 'Привет, Leo! Расскажи шутку из бизнеса.'}
      ]);

      expect(response['message'], isNotNull);
      expect(response['message']['content'], isNotEmpty);

      // сохраняем ответ в историю
      await LeoService.saveConversation(
        chatId: chatId,
        role: 'assistant',
        content: response['message']['content'],
      );
    });

    test('3) Проверка уменьшения лимита', () async {
      final afterLimit = await LeoService.checkMessageLimit();
      expect(afterLimit, equals(initialLimit - 1));
    });

    test('4) Проверка истории сообщений', () async {
      final history = await SupabaseService.client
          .from('leo_messages')
          .select()
          .eq('chat_id', chatId);

      // должно быть как минимум 2 сообщения
      expect((history as List).length, greaterThanOrEqualTo(2));
    });

    test('5) Ошибка при пустом массиве messages', () async {
      expect(
        () => LeoService.sendMessage(messages: []),
        throwsA(isA<LeoFailure>()),
      );
    });
  });
}
