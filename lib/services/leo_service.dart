import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bizlevel/utils/env_helper.dart';
import 'package:bizlevel/services/gp_service.dart';

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
  /// Инстанс сервиса, принимающий [SupabaseClient] через DI.
  LeoService(this._client);

  final SupabaseClient _client;

  // We use Dio because Edge Functions требуют произвольные HTTP-заголовки
  // и проще настраивать таймауты/перехватчики.
  static final Dio _edgeDio = Dio(BaseOptions(
    baseUrl:
        '${const String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://acevqbdpzgbtqznbpgzr.supabase.co')}/functions/v1',
    connectTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
    responseType: ResponseType.json,
  ));

  /// Отправляет список сообщений в Edge Function `leo-chat` и возвращает
  /// ответ ассистента + статистику токенов.
  /// Expects [messages] in chat completion API format.
  Future<Map<String, dynamic>> sendMessage({
    required List<Map<String, dynamic>> messages,
    String bot = 'leo',
  }) async {
    // debug: entry point marker (no PII)
    // print('🔧 DEBUG: sendMessage');
    final session = _client.auth.currentSession;
    if (session == null) {
      throw LeoFailure('Пользователь не авторизован');
    }

    // Do not log JWT/token to avoid PII

    // Используем только Edge Function
    // print('🔧 DEBUG: Using Edge Function');
    // Списываем 1 GP за сообщение (идемпотентно)
    final gp = GpService(_client);
    // Стабильный idempotencyKey на время одной отправки (без timestamp)
    final String idempotencyKey = _generateIdempotencyKey(
      userId: session.user.id,
      chatId: null,
      messages: messages,
    );

    return _withRetry(() async {
      try {
        try {
          await gp.spend(
            type: 'spend_message',
            amount: 1,
            idempotencyKey: idempotencyKey,
          );
          // Обновим кеш баланса в фоне
          Future.microtask(() async {
            try {
              final fresh = await gp.getBalance();
              await GpService.saveBalanceCache(fresh);
            } catch (_) {}
          });
        } on GpFailure catch (ge) {
          if (ge.message.contains('Недостаточно GP')) {
            throw LeoFailure('Недостаточно GP');
          }
          rethrow;
        }

        final response = await _edgeDio.post(
          '/leo-chat',
          data: jsonEncode({'messages': messages, 'bot': bot}),
          options: Options(headers: {
            'Authorization': 'Bearer ${envOrDefine('SUPABASE_ANON_KEY')}',
            'apikey': envOrDefine('SUPABASE_ANON_KEY'),
            'x-user-jwt': session.accessToken,
            'Content-Type': 'application/json',
          }),
        );

        print('🔧 DEBUG: Response status: ${response.statusCode}');
        print('🔧 DEBUG: Response data: ${response.data}');

        if (response.statusCode == 200 &&
            response.data is Map<String, dynamic>) {
          final responseData = Map<String, dynamic>.from(response.data);
          return responseData;
        } else {
          final message =
              (response.data is Map && response.data['error'] != null)
                  ? response.data['error'] as String
                  : 'Неизвестная ошибка Leo';
          throw LeoFailure(message);
        }
      } on DioException catch (e) {
        try {
          await Sentry.captureException(e);
        } catch (_) {
          // Sentry не настроен, просто логируем в консоль
          print('DEBUG: Exception (Sentry not configured): $e');
        }
        if (e.error is SocketException) {
          throw LeoFailure('Нет соединения с интернетом');
        }
        final data = e.response?.data;
        if (data is Map) {
          final err = (data['error'] ?? data['message'])?.toString();
          final details = data['details']?.toString();
          if (err != null && err.isNotEmpty) {
            final composed =
                details != null && details.isNotEmpty ? '$err: $details' : err;
            throw LeoFailure(_humanizeServerError(composed));
          }
        }
        if ((e.response?.statusCode ?? 0) >= 500) {
          throw LeoFailure(
              'Сервер чата временно недоступен. Попробуйте позже.');
        }
        throw LeoFailure('Сетевая ошибка при обращении к Leo');
      } catch (e) {
        try {
          await Sentry.captureException(e);
        } catch (_) {
          // Sentry не настроен, просто логируем в консоль
          print('DEBUG: Exception (Sentry not configured): $e');
        }
        throw LeoFailure('Не удалось получить ответ Leo');
      }
    });
  }

  /// Отправляет сообщение с использованием RAG системы
  /// RAG автоматически выполняется на сервере для всех запросов (кроме бота 'max')
  Future<Map<String, dynamic>> sendMessageWithRAG({
    required List<Map<String, dynamic>> messages,
    required String userContext,
    required String levelContext,
    String bot = 'leo',
    String? chatId, // Добавляем chatId параметр
    bool skipSpend = false,
  }) async {
    final session = _client.auth.currentSession;
    if (session == null) {
      throw LeoFailure('Пользователь не авторизован');
    }

    print('🔧 DEBUG: sendMessageWithRAG начался');
    print('🔧 DEBUG: session.user.id = ${session.user.id}');
    print('🔧 DEBUG: JWT длина = ${session.accessToken.length}');
    print(
        '🔧 DEBUG: JWT начинается с = ${session.accessToken.substring(0, 20)}...');
    print('🔧 DEBUG: chatId = $chatId'); // Добавляем логирование chatId

    // Списываем 1 GP за сообщение (идемпотентно)
    final gp = GpService(_client);
    final String idempotencyKey = _generateIdempotencyKey(
      userId: session.user.id,
      chatId: chatId,
      messages: messages,
    );

    // Отправляем сообщения в Edge Function. Встроенный RAG выполняется на сервере.
    return _withRetry(() async {
      try {
        try {
          if (!skipSpend) {
            await gp.spend(
              type: 'spend_message',
              amount: 1,
              referenceId: chatId ?? '',
              idempotencyKey: idempotencyKey,
            );
            // Обновим кеш баланса в фоне
            Future.microtask(() async {
              try {
                final fresh = await gp.getBalance();
                await GpService.saveBalanceCache(fresh);
              } catch (_) {}
            });
          }
        } on GpFailure catch (ge) {
          if (ge.message.contains('Недостаточно GP')) {
            throw LeoFailure('Недостаточно GP');
          }
          rethrow;
        }

        // Фильтруем строки "null" и пустые значения
        final cleanUserContext =
            (userContext == 'null' || userContext.isEmpty) ? null : userContext;
        final cleanLevelContext =
            (levelContext == 'null' || levelContext.isEmpty)
                ? null
                : levelContext;

        print('🔧 DEBUG: Отправляем POST запрос к /leo-chat');
        print('🔧 DEBUG: payload size = ${jsonEncode({
              'messages': messages,
              'userContext': cleanUserContext,
              'levelContext': cleanLevelContext,
              'bot': bot,
              'chatId': chatId, // Добавляем chatId в payload
            }).length} символов');

        final response = await _edgeDio.post(
          '/leo-chat',
          data: jsonEncode({
            'messages': messages,
            'userContext': cleanUserContext,
            'levelContext': cleanLevelContext,
            'bot': bot,
            'chatId': chatId, // Добавляем chatId в payload
          }),
          options: Options(headers: {
            'Authorization': 'Bearer ${envOrDefine('SUPABASE_ANON_KEY')}',
            'apikey': envOrDefine('SUPABASE_ANON_KEY'),
            'x-user-jwt': session.accessToken,
            'Content-Type': 'application/json',
          }),
        );

        print('🔧 DEBUG: Получен HTTP ответ: ${response.statusCode}');

        if (response.statusCode == 200 &&
            response.data is Map<String, dynamic>) {
          final responseData = Map<String, dynamic>.from(response.data);
          return responseData;
        } else {
          final message =
              (response.data is Map && response.data['error'] != null)
                  ? response.data['error'] as String
                  : 'Неизвестная ошибка Leo';
          throw LeoFailure(message);
        }
      } on DioException catch (e) {
        try {
          await Sentry.captureException(e);
        } catch (_) {
          // Sentry не настроен, просто логируем в консоль
          print('DEBUG: Exception (Sentry not configured): $e');
        }
        if (e.error is SocketException) {
          throw LeoFailure('Нет соединения с интернетом');
        }
        final data = e.response?.data;
        if (data is Map) {
          final err = (data['error'] ?? data['message'])?.toString();
          final details = data['details']?.toString();
          if (err != null && err.isNotEmpty) {
            final composed =
                details != null && details.isNotEmpty ? '$err: $details' : err;
            throw LeoFailure(_humanizeServerError(composed));
          }
        }
        if ((e.response?.statusCode ?? 0) >= 500) {
          throw LeoFailure(
              'Сервер чата временно недоступен. Попробуйте позже.');
        }
        throw LeoFailure('Сетевая ошибка при обращении к Leo');
      } catch (e) {
        try {
          await Sentry.captureException(e);
        } catch (_) {
          // Sentry не настроен, просто логируем в консоль
          print('DEBUG: Exception (Sentry not configured): $e');
        }
        throw LeoFailure('Не удалось получить ответ Leo');
      }
    });
  }

  /// Режим «чат‑тест»: короткий ответ без учёта лимитов и без создания чата.
  /// Возвращает `{ message: { content } }` при успехе.
  Future<Map<String, dynamic>> sendQuizFeedback({
    required String question,
    required List<String> options,
    required int selectedIndex,
    required int correctIndex,
    String userContext = '',
    int maxTokens = 180,
  }) async {
    final session = _client.auth.currentSession;
    if (session == null) {
      throw LeoFailure('Пользователь не авторизован');
    }

    // Фильтруем строки "null" и пустые значения
    final cleanUserContext =
        (userContext == 'null' || userContext.isEmpty) ? null : userContext;

    final payload = {
      'mode': 'quiz',
      'isCorrect': selectedIndex == correctIndex,
      'quiz': {
        'question': question,
        'options': options,
        'selectedIndex': selectedIndex,
        'correctIndex': correctIndex,
      },
      'userContext': cleanUserContext,
      'maxTokens': maxTokens,
    };

    return _withRetry(() async {
      try {
        final response = await _edgeDio.post(
          '/leo-chat',
          data: jsonEncode(payload),
          options: Options(headers: {
            'Authorization': 'Bearer ${envOrDefine('SUPABASE_ANON_KEY')}',
            'apikey': envOrDefine('SUPABASE_ANON_KEY'),
            'x-user-jwt': session.accessToken,
            'Content-Type': 'application/json',
          }),
        );

        if (response.statusCode == 200 &&
            response.data is Map<String, dynamic>) {
          return Map<String, dynamic>.from(response.data);
        }

        final message = (response.data is Map && response.data['error'] != null)
            ? response.data['error'] as String
            : 'Неизвестная ошибка Leo (quiz)';
        throw LeoFailure(message);
      } on DioException catch (e) {
        if (e.error is SocketException) {
          throw LeoFailure('Нет соединения с интернетом');
        }
        try {
          await Sentry.captureException(e);
        } catch (_) {
          // Sentry не настроен, просто логируем в консоль
          print('DEBUG: Exception (Sentry not configured): $e');
        }
        final data = e.response?.data;
        if (data is Map) {
          final err = (data['error'] ?? data['message'])?.toString();
          final details = data['details']?.toString();
          if (err != null && err.isNotEmpty) {
            final composed = (details != null && details.isNotEmpty)
                ? '$err: $details'
                : err;
            throw LeoFailure(_humanizeServerError(composed));
          }
        }
        if ((e.response?.statusCode ?? 0) >= 500) {
          throw LeoFailure(
              'Сервер чата временно недоступен. Попробуйте позже.');
        }
        throw LeoFailure('Сетевая ошибка при обращении к Leo (quiz)');
      } catch (e) {
        try {
          await Sentry.captureException(e);
        } catch (_) {
          // Sentry не настроен, просто логируем в консоль
          print('DEBUG: Exception (Sentry not configured): $e');
        }
        throw LeoFailure('Не удалось получить ответ Leo (quiz)');
      }
    });
  }

  /// Получает контекст из базы знаний
  /// RAG теперь встроен в серверную функцию leo-chat и выполняется автоматически

  /// Generic retry with exponential backoff (300ms, 600ms)
  Future<T> _withRetry<T>(Future<T> Function() action,
      {int retries = 2}) async {
    int attempt = 0;
    while (true) {
      try {
        return await action();
      } catch (e) {
        if (attempt >= retries) rethrow;
        await Future.delayed(Duration(milliseconds: 300 * (1 << attempt)));
        attempt++;
      }
    }
  }

  // Генерирует стабильный Idempotency-Key без timestamp
  String _generateIdempotencyKey({
    required String userId,
    String? chatId,
    required List<Map<String, dynamic>> messages,
  }) {
    String content = '';
    try {
      final Map<String, dynamic>? userMsg = messages
          .cast<Map<String, dynamic>?>()
          .firstWhere((m) => (m?['role'] == 'user'), orElse: () => null);
      content = (userMsg?['content']?.toString() ?? '').trim();
    } catch (_) {}
    final int h = _stableHash(content);
    final String cid = (chatId == null || chatId.isEmpty) ? 'new' : chatId;
    return 'msg:$userId:$cid:$h';
  }

  // Простой детерминированный хэш (DJB2)
  int _stableHash(String s) {
    int hash = 5381;
    for (int i = 0; i < s.length; i++) {
      hash = ((hash << 5) + hash) + s.codeUnitAt(i);
      hash &= 0x7fffffff; // ограничим позитивным int
    }
    return hash;
  }

  String _humanizeServerError(String raw) {
    // Сокращаем технические сообщения до понятных пользователю
    if (raw.contains('openai_config_error')) {
      return 'Сервис ИИ не настроен. Обратитесь к поддержке.';
    }
    if (raw.contains('openai_error')) {
      return 'Проблема на стороне ИИ‑провайдера. Попробуйте ещё раз позже.';
    }
    return raw;
  }

  /// Проверяет, сколько сообщений осталось у пользователя.
  /// Возвращает число оставшихся сообщений.
  Future<void> resetUnread(String chatId) async {
    try {
      await _client.rpc('reset_leo_unread', params: {'p_chat_id': chatId});
    } catch (_) {}
  }

  Future<int> checkMessageLimit() async {
    // Лимиты сообщений отключены (этап 39.1); возвращаем -1 как «без лимита»
    return -1;
  }

  Future<int> decrementMessageCount() async {
    // Лимиты сообщений отключены — ничего не делаем
    return -1;
  }

  /// Сохраняет одно сообщение в таблицу `leo_messages` и обновляет счётчик
  /// сообщений в `leo_chats`. Если чат новый – создаёт запись в `leo_chats`.
  /// Возвращает `chatId` (новый или существующий).
  Future<String> saveConversation({
    required String role,
    required String content,
    String? chatId,
    String bot = 'leo',
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
              'bot': bot,
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

      // increment message_count (+1)
      // получаем текущее значение message_count
      final chatRow = await _client
          .from('leo_chats')
          .select('message_count')
          .eq('id', effectiveChatId)
          .single();

      final currentCount = chatRow['message_count'] as int? ?? 0;

      await _client.from('leo_chats').update({
        'message_count': currentCount + 1,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', effectiveChatId);

      return effectiveChatId;
    } on PostgrestException catch (e) {
      throw LeoFailure(e.message);
    } catch (e) {
      throw LeoFailure('Не удалось сохранить сообщение');
    }
  }

  /// Публичный метод для сохранения данных о стоимости AI запроса в таблицу ai_message
  /// Позволяет внешним компонентам сохранять данные о стоимости
  Future<void> saveAiMessageData({
    required String leoMessageId,
    required String chatId,
    required String userId,
    required int inputTokens,
    required int outputTokens,
    required double costUsd,
    required String modelUsed,
    required String botType,
    String requestType = 'chat',
  }) async {
    try {
      await _client.from('ai_message').insert({
        'leo_message_id': leoMessageId,
        'chat_id': chatId,
        'user_id': userId,
        'input_tokens': inputTokens,
        'output_tokens': outputTokens,
        'total_tokens': inputTokens + outputTokens,
        'cost_usd': costUsd,
        'model_used': modelUsed,
        'bot_type': botType,
        'request_type': requestType,
      });

      print('🔧 DEBUG: AI message data saved via public method');
    } on PostgrestException catch (e) {
      print(
          'Warning: Failed to save AI message data to database: ${e.message}');
      rethrow; // Пробрасываем ошибку для обработки на уровне выше
    } catch (e) {
      print('Warning: Unexpected error saving AI message data: $e');
      rethrow;
    }
  }
}
