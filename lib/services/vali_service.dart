import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bizlevel/utils/env_helper.dart';

/// Typed failure for any Vali related errors.
class ValiFailure implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? data;
  
  ValiFailure(this.message, {this.statusCode, this.data});

  @override
  String toString() => 'ValiFailure: $message';
}

/// Централизованный сервис для взаимодействия с Edge Function val-chat
/// и связанными данными Supabase (валидации идей, чаты).
class ValiService {
  /// Инстанс сервиса, принимающий [SupabaseClient] через DI.
  ValiService(this._client);

  final SupabaseClient _client;

  /// Стоимость валидации в GP (для повторных валидаций, первая бесплатна)
  static const int kValidationCostGp = 20;

  // Используем Dio для Edge Functions
  static final Dio _edgeDio = Dio(BaseOptions(
    baseUrl:
        '${const String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://acevqbdpzgbtqznbpgzr.supabase.co')}/functions/v1',
    connectTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  // =============== Private helpers ===============

  Map<String, String> _edgeHeaders() {
    return {
      'Authorization': 'Bearer ${envOrDefine('SUPABASE_ANON_KEY')}',
      'apikey': envOrDefine('SUPABASE_ANON_KEY'),
      'x-user-jwt': _client.auth.currentSession?.accessToken ?? '',
      'Content-Type': 'application/json',
    };
  }

  bool _isAuthError(DioException e) {
    final status = e.response?.statusCode ?? 0;
    final body = e.response?.data;
    final msg =
        body is Map ? (body['error'] ?? body['message'])?.toString() : null;
    return status == 401 || (msg != null && msg.contains('Invalid JWT'));
  }

  bool _isInsufficientGpError(DioException e) {
    final status = e.response?.statusCode ?? 0;
    final body = e.response?.data;
    if (status == 402) return true;
    if (body is Map) {
      final error = body['error']?.toString() ?? '';
      return error.contains('insufficient_gp') || error.contains('Недостаточно GP');
    }
    return false;
  }

  Future<Response<dynamic>> _postValChat(String dataStr) async {
    try {
      return await _edgeDio.post(
        '/val-chat',
        data: dataStr,
        options: Options(headers: _edgeHeaders()),
      );
    } on DioException catch (e) {
      if (_isAuthError(e)) {
        try {
          await _client.auth.refreshSession();
        } catch (_) {}
        return await _edgeDio.post(
          '/val-chat',
          data: dataStr,
          options: Options(headers: _edgeHeaders()),
        );
      }
      rethrow;
    }
  }

  String? _parseServerMessage(dynamic data) {
    if (data is Map) {
      final err = (data['error'] ?? data['message'])?.toString();
      final details = data['details']?.toString();
      if (err != null && err.isNotEmpty) {
        return details != null && details.isNotEmpty ? '$err: $details' : err;
      }
    }
    return null;
  }

  void _addBreadcrumb(String category, String message,
      [Map<String, dynamic>? data]) {
    try {
      Sentry.addBreadcrumb(Breadcrumb(
        category: category,
        message: message,
        level: SentryLevel.info,
        data: data,
      ));
    } catch (_) {}
  }

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

  String _humanizeServerError(String raw) {
    if (raw.contains('insufficient_gp')) {
      return 'Недостаточно GP для валидации. Нужно ${ValiService.kValidationCostGp} GP.';
    }
    if (raw.contains('openai_config_error') || raw.contains('xai')) {
      return 'Сервис ИИ не настроен. Обратитесь к поддержке.';
    }
    if (raw.contains('openai_error')) {
      return 'Проблема на стороне ИИ‑провайдера. Попробуйте ещё раз позже.';
    }
    return raw;
  }

  // =============== Public API Methods ===============

  /// Отправляет сообщение в режиме диалога (mode='dialog').
  /// Возвращает ответ ассистента + usage статистику.
  /// 
  /// GP-экономика: первая валидация бесплатно, повторные — [kValidationCostGp] GP.
  /// При недостаточном балансе выбрасывается [ValiFailure] с кодом 402.
  /// 
  /// [action] - опциональный параметр для специальных действий:
  ///   - 'start_validation' - начать валидацию (списать GP и перейти на Step 1)
  Future<Map<String, dynamic>> sendMessage({
    required List<Map<String, dynamic>> messages,
    String? validationId,
    String? action,
  }) async {
    final session = _client.auth.currentSession;
    if (session == null) {
      throw ValiFailure('Пользователь не авторизован');
    }

    _addBreadcrumb('vali', 'send_message_start', {
      'validationId': validationId ?? 'new',
      'messageCount': messages.length,
    });

    return _withRetry(() async {
      try {
        final payload = jsonEncode({
          'messages': messages,
          'validationId': validationId,
          'mode': 'dialog',
          if (action != null) 'action': action,
        });

        final response = await _postValChat(payload);

        if (response.statusCode == 200 &&
            response.data is Map<String, dynamic>) {
          final responseData = Map<String, dynamic>.from(response.data);
          _addBreadcrumb('vali', 'send_message_success', {
            'validationId': validationId ?? 'new',
          });
          return responseData;
        } else {
          final message =
              (response.data is Map && response.data['error'] != null)
                  ? response.data['error'] as String
                  : 'Неизвестная ошибка Валли';
          throw ValiFailure(message, statusCode: response.statusCode);
        }
      } on DioException catch (e) {
        try {
          await Sentry.captureException(e);
        } catch (_) {}

        // Обработка 402 — недостаточно GP
        if (_isInsufficientGpError(e)) {
          _addBreadcrumb('vali', 'insufficient_gp', {
            'validationId': validationId ?? 'new',
            'required': ValiService.kValidationCostGp,
          });
          throw ValiFailure(
            'Недостаточно GP. Нужно ${ValiService.kValidationCostGp} GP для валидации идеи.',
            statusCode: 402,
            data: {'required': ValiService.kValidationCostGp},
          );
        }

        if (e.error is SocketException) {
          throw ValiFailure('Нет соединения с интернетом');
        }

        final parsed = _parseServerMessage(e.response?.data);
        if (parsed != null) {
          throw ValiFailure(_humanizeServerError(parsed), 
            statusCode: e.response?.statusCode);
        }

        if ((e.response?.statusCode ?? 0) >= 500) {
          throw ValiFailure(
              'Сервер временно недоступен. Попробуйте позже.');
        }

        throw ValiFailure('Сетевая ошибка при обращении к Валли');
      } catch (e) {
        try {
          await Sentry.captureException(e);
        } catch (_) {
          debugPrint('DEBUG: Exception (Sentry not configured): $e');
        }
        throw ValiFailure('Не удалось получить ответ Валли');
      }
    });
  }

  /// Запрашивает скоринг валидации (mode='score').
  /// Возвращает результаты оценки и markdown отчёт.
  /// 
  /// [messages] — полная история диалога (все 7 вопросов).
  /// [validationId] — ID валидации для сохранения результатов.
  Future<Map<String, dynamic>> scoreValidation({
    required List<Map<String, dynamic>> messages,
    required String validationId,
  }) async {
    final session = _client.auth.currentSession;
    if (session == null) {
      throw ValiFailure('Пользователь не авторизован');
    }

    _addBreadcrumb('vali', 'score_validation_start', {
      'validationId': validationId,
      'messageCount': messages.length,
    });

    return _withRetry(() async {
      try {
        final payload = jsonEncode({
          'messages': messages,
          'validationId': validationId,
          'mode': 'score',
        });

        final response = await _postValChat(payload);

        if (response.statusCode == 200 &&
            response.data is Map<String, dynamic>) {
          final responseData = Map<String, dynamic>.from(response.data);
          _addBreadcrumb('vali', 'score_validation_success', {
            'validationId': validationId,
            'total_score': responseData['scores']?['total'],
          });
          return responseData;
        } else {
          final message =
              (response.data is Map && response.data['error'] != null)
                  ? response.data['error'] as String
                  : 'Неизвестная ошибка скоринга';
          throw ValiFailure(message, statusCode: response.statusCode);
        }
      } on DioException catch (e) {
        try {
          await Sentry.captureException(e);
        } catch (_) {}

        if (e.error is SocketException) {
          throw ValiFailure('Нет соединения с интернетом');
        }

        final parsed = _parseServerMessage(e.response?.data);
        if (parsed != null) {
          throw ValiFailure(_humanizeServerError(parsed),
            statusCode: e.response?.statusCode);
        }

        if ((e.response?.statusCode ?? 0) >= 500) {
          throw ValiFailure(
              'Сервер временно недоступен. Попробуйте позже.');
        }

        throw ValiFailure('Сетевая ошибка при скоринге валидации');
      } catch (e) {
        try {
          await Sentry.captureException(e);
        } catch (_) {
          debugPrint('DEBUG: Exception (Sentry not configured): $e');
        }
        throw ValiFailure('Не удалось выполнить скоринг валидации');
      }
    });
  }

  /// Создаёт новую запись валидации в таблице idea_validations.
  /// Возвращает ID созданной валидации.
  Future<String> createValidation({
    String? chatId,
    String? ideaSummary,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw ValiFailure('Не авторизован');

    try {
      _addBreadcrumb('vali', 'create_validation_start', {
        'chatId': chatId ?? 'none',
      });

      final inserted = await _client
          .from('idea_validations')
          .insert({
            'user_id': user.id,
            if (chatId != null) 'chat_id': chatId,
            'status': 'in_progress',
            'current_step': 0, // Начинаем с Step 0 (онбординг)
            if (ideaSummary != null) 'idea_summary': ideaSummary,
          })
          .select('id')
          .single();

      final validationId = inserted['id'] as String;
      
      _addBreadcrumb('vali', 'create_validation_success', {
        'validationId': validationId,
      });

      return validationId;
    } on PostgrestException catch (e) {
      throw ValiFailure(e.message);
    } catch (e) {
      throw ValiFailure('Не удалось создать валидацию');
    }
  }

  /// Получает валидацию по ID.
  /// Возвращает данные валидации или null, если не найдена.
  Future<Map<String, dynamic>?> getValidation(String validationId) async {
    final user = _client.auth.currentUser;
    if (user == null) throw ValiFailure('Не авторизован');

    try {
      final result = await _client
          .from('idea_validations')
          .select()
          .eq('id', validationId)
          .eq('user_id', user.id)
          .maybeSingle();

      if (result == null) return null;
      return Map<String, dynamic>.from(result);
    } on PostgrestException catch (e) {
      throw ValiFailure(e.message);
    } catch (e) {
      throw ValiFailure('Не удалось загрузить валидацию');
    }
  }

  /// Получает валидацию по chatId.
  /// Возвращает данные валидации или null, если не найдена.
  Future<Map<String, dynamic>?> getValidationByChatId(String chatId) async {
    final user = _client.auth.currentUser;
    if (user == null) throw ValiFailure('Не авторизован');

    try {
      final result = await _client
          .from('idea_validations')
          .select()
          .eq('chat_id', chatId)
          .eq('user_id', user.id)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (result == null) return null;
      return Map<String, dynamic>.from(result);
    } on PostgrestException catch (e) {
      throw ValiFailure(e.message);
    } catch (e) {
      throw ValiFailure('Не удалось загрузить валидацию по chatId');
    }
  }

  /// Обновляет прогресс валидации (current_step).
  Future<void> updateValidationProgress({
    required String validationId,
    required int currentStep,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw ValiFailure('Не авторизован');

    try {
      await _client
          .from('idea_validations')
          .update({
            'current_step': currentStep,
          })
          .eq('id', validationId)
          .eq('user_id', user.id);

      _addBreadcrumb('vali', 'update_progress', {
        'validationId': validationId,
        'currentStep': currentStep,
      });
    } on PostgrestException catch (e) {
      throw ValiFailure(e.message);
    } catch (e) {
      throw ValiFailure('Не удалось обновить прогресс');
    }
  }

  /// Сохраняет результаты скоринга в таблицу idea_validations.
  /// Вызывается после успешного скоринга в режиме 'score'.
  Future<void> saveValidationResults({
    required String validationId,
    required Map<String, dynamic> scores,
    required int totalScore,
    required String archetype,
    required String reportMarkdown,
    String? oneThing,
    List<Map<String, dynamic>>? recommendedLevels,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw ValiFailure('Не авторизован');

    try {
      _addBreadcrumb('vali', 'save_results_start', {
        'validationId': validationId,
        'totalScore': totalScore,
      });

      await _client
          .from('idea_validations')
          .update({
            'scores': scores,
            'total_score': totalScore,
            'archetype': archetype,
            'report_markdown': reportMarkdown,
            if (oneThing != null) 'one_thing': oneThing,
            if (recommendedLevels != null)
              'recommended_levels': recommendedLevels,
            'status': 'completed',
            'completed_at': DateTime.now().toIso8601String(),
          })
          .eq('id', validationId)
          .eq('user_id', user.id);

      _addBreadcrumb('vali', 'save_results_success', {
        'validationId': validationId,
      });
    } on PostgrestException catch (e) {
      throw ValiFailure(e.message);
    } catch (e) {
      throw ValiFailure('Не удалось сохранить результаты валидации');
    }
  }

  /// Получает список всех валидаций пользователя.
  /// Сортировка по дате создания (новые первыми).
  Future<List<Map<String, dynamic>>> getUserValidations({
    int limit = 50,
    int offset = 0,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw ValiFailure('Не авторизован');

    try {
      final result = await _client
          .from('idea_validations')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return List<Map<String, dynamic>>.from(
        result.map((e) => Map<String, dynamic>.from(e)),
      );
    } on PostgrestException catch (e) {
      throw ValiFailure(e.message);
    } catch (e) {
      throw ValiFailure('Не удалось загрузить список валидаций');
    }
  }

  /// Проверяет, является ли валидация первой для пользователя.
  /// Используется для определения, нужно ли списывать GP.
  Future<bool> isFirstValidation() async {
    final user = _client.auth.currentUser;
    if (user == null) throw ValiFailure('Не авторизован');

    try {
      // Проверяем наличие хотя бы одной завершённой валидации.
      // Запрашиваем только один id, чтобы не тянуть все строки.
      final List<dynamic> result = await _client
          .from('idea_validations')
          .select('id')
          .eq('user_id', user.id)
          .eq('status', 'completed')
          .limit(1);

      // Если записей нет — это первая валидация.
      return result.isEmpty;
    } on PostgrestException catch (e) {
      debugPrint('Warning: Failed to check first validation: ${e.message}');
      return false; // При ошибке считаем, что не первая (безопаснее)
    } catch (e) {
      debugPrint('Warning: Failed to check first validation: $e');
      return false;
    }
  }

  /// Помечает валидацию как заброшенную (abandoned).
  Future<void> abandonValidation(String validationId) async {
    final user = _client.auth.currentUser;
    if (user == null) throw ValiFailure('Не авторизован');

    try {
      await _client
          .from('idea_validations')
          .update({'status': 'abandoned'})
          .eq('id', validationId)
          .eq('user_id', user.id);

      _addBreadcrumb('vali', 'validation_abandoned', {
        'validationId': validationId,
      });
    } on PostgrestException catch (e) {
      throw ValiFailure(e.message);
    } catch (e) {
      throw ValiFailure('Не удалось обновить статус валидации');
    }
  }

  /// Сохраняет одно сообщение в таблицу `leo_messages` с bot='vali'
  /// и обновляет счётчик сообщений в `leo_chats`.
  /// Возвращает `chatId` (новый или существующий).
  Future<String> saveConversation({
    required String role,
    required String content,
    String? chatId,
    String? validationId,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw ValiFailure('Не авторизован');

    try {
      String effectiveChatId = chatId ?? '';

      // Создаём новый чат при необходимости
      if (chatId == null) {
        final inserted = await _client
            .from('leo_chats')
            .insert({
              'user_id': user.id,
              'title': content.length > 40 ? content.substring(0, 40) : content,
              'bot': 'vali',
            })
            .select('id')
            .single();

        effectiveChatId = inserted['id'] as String;

        // Связываем валидацию с чатом
        if (validationId != null) {
          await _client
              .from('idea_validations')
              .update({'chat_id': effectiveChatId})
              .eq('id', validationId)
              .eq('user_id', user.id);
        }
      }

      // Сохраняем сообщение
      await _client.from('leo_messages').insert({
        'chat_id': effectiveChatId,
        'user_id': user.id,
        'role': role,
        'content': content,
      });

      // Обновляем счётчик сообщений
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
      throw ValiFailure(e.message);
    } catch (e) {
      throw ValiFailure('Не удалось сохранить сообщение');
    }
  }
}
