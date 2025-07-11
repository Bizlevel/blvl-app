import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_service.dart';

/// Typed failure for any Leo related errors.
class LeoFailure implements Exception {
  final String message;
  LeoFailure(this.message);

  @override
  String toString() => 'LeoFailure: $message';
}

/// Centralised service for interacting with Leo AI mentor Edge Function
/// and related Supabase data (лимиты, чаты).
class LeoService {
  LeoService._();

  static final SupabaseClient _client = SupabaseService.client;

  // We use Dio because Edge Functions требуют произвольные HTTP-заголовки
  // и проще настраивать таймауты/перехватчики.
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: const String.fromEnvironment('SUPABASE_URL',
            defaultValue: 'https://acevqbdpzgbtqznbpgzr.supabase.co') +
        '/functions/v1',
    connectTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
    responseType: ResponseType.json,
  ));

  /// Отправляет список сообщений в Edge Function `leo-chat` и возвращает
  /// ответ ассистента + статистику токенов.
  /// Expects [messages] in chat completion API format.
  static Future<Map<String, dynamic>> sendMessage(
      {required List<Map<String, dynamic>> messages}) async {
    final session = _client.auth.currentSession;
    if (session == null) {
      throw LeoFailure('Пользователь не авторизован');
    }

    try {
      final response = await _dio.post(
        '/leo-chat',
        data: jsonEncode({'messages': messages}),
        options: Options(headers: {
          'Authorization': 'Bearer ${session.accessToken}',
          'Content-Type': 'application/json',
        }),
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return Map<String, dynamic>.from(response.data);
      } else {
        final message = (response.data is Map && response.data['error'] != null)
            ? response.data['error'] as String
            : 'Неизвестная ошибка Leo';
        throw LeoFailure(message);
      }
    } on DioException catch (e) {
      throw LeoFailure(e.message ?? 'Сетевая ошибка при обращении к Leo');
    } catch (e) {
      throw LeoFailure('Не удалось получить ответ Leo');
    }
  }

  /// Проверяет, сколько сообщений осталось у пользователя.
  /// Возвращает число оставшихся сообщений.
  static Future<int> checkMessageLimit() async {
    final user = _client.auth.currentUser;
    if (user == null) throw LeoFailure('Не авторизован');

    try {
      final data = await _client
          .from('users')
          .select(
              'is_premium, leo_messages_total, leo_messages_today, leo_reset_at')
          .eq('id', user.id)
          .single();

      final isPremium = data['is_premium'] as bool? ?? false;
      if (isPremium) {
        // если истек дневной лимит, сервер уже сбросил. Просто вернуть текущее
        return data['leo_messages_today'] as int? ?? 0;
      } else {
        return data['leo_messages_total'] as int? ?? 0;
      }
    } on PostgrestException catch (e) {
      throw LeoFailure(e.message);
    } catch (e) {
      throw LeoFailure('Не удалось проверить лимит сообщений');
    }
  }

  /// Декрементирует счётчик сообщений пользователя. Для Premium – суточный,
  /// для Free – общий.
  static Future<void> decrementMessageCount() async {
    final user = _client.auth.currentUser;
    if (user == null) throw LeoFailure('Не авторизован');

    try {
      final profile = await _client
          .from('users')
          .select('is_premium, leo_messages_total, leo_messages_today')
          .eq('id', user.id)
          .single();

      final isPremium = profile['is_premium'] as bool? ?? false;

      if (isPremium) {
        final today = (profile['leo_messages_today'] as int? ?? 0) - 1;
        await _client.from('users').update(
            {'leo_messages_today': today.clamp(0, 999)}).eq('id', user.id);
      } else {
        final total = (profile['leo_messages_total'] as int? ?? 0) - 1;
        await _client.from('users').update(
            {'leo_messages_total': total.clamp(0, 999)}).eq('id', user.id);
      }
    } on PostgrestException catch (e) {
      throw LeoFailure(e.message);
    } catch (e) {
      throw LeoFailure('Не удалось обновить счётчик сообщений');
    }
  }

  /// Сохраняет одно сообщение в таблицу `leo_messages` и обновляет счётчик
  /// сообщений в `leo_chats`. Если чат новый – создаёт запись в `leo_chats`.
  /// Возвращает `chatId` (новый или существующий).
  static Future<String> saveConversation({
    required String role,
    required String content,
    String? chatId,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw LeoFailure('Не авторизован');

    try {
      // Создаём новый чат при необходимости и берём его id из ответа Supabase.
      String effectiveChatId = chatId ?? '';

      if (chatId == null) {
        final inserted = await _client
            .from('leo_chats')
            .insert({
              'user_id': user.id,
              'title': content.length > 40 ? content.substring(0, 40) : content,
            })
            .select('id')
            .single();

        effectiveChatId = inserted['id'] as String;
      }

      // insert message
      await _client.from('leo_messages').insert({
        'chat_id': effectiveChatId,
        'user_id': user.id,
        'role': role,
        'content': content,
      });

      // increment message_count
      await _client.rpc('increment_chat_messages', params: {
        'p_chat_id': effectiveChatId,
      });

      return effectiveChatId;
    } on PostgrestException catch (e) {
      throw LeoFailure(e.message);
    } catch (e) {
      throw LeoFailure('Не удалось сохранить сообщение');
    }
  }
}
