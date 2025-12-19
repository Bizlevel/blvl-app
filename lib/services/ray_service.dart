import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:bizlevel/services/gp_service.dart';
import 'package:bizlevel/utils/env_helper.dart';

/// Typed failure for any Ray related errors.
class RayFailure implements Exception {
  final String message;
  final int? statusCode;
  final String? code;

  RayFailure(this.message, {this.statusCode, this.code});

  @override
  String toString() => 'RayFailure($statusCode/$code): $message';
}

class RayPricing {
  final int priceGp;
  final bool isFree;

  const RayPricing({required this.priceGp, required this.isFree});
}

/// Service for interacting with Ray (idea validator) via Edge Function `ray-chat`
/// and related Supabase tables (`idea_validations`, `leo_chats`, `leo_messages`).
///
/// IMPORTANT:
/// - Database bot id is `ray`.
class RayService {
  RayService(this._client);

  final SupabaseClient _client;

  static const String kBotDbId = 'ray';
  static const int kValidationCostGp = 20;

  // We use Dio because Edge Functions require custom headers/timeouts.
  static final Dio _edgeDio = Dio(BaseOptions(
    baseUrl:
        '${envOrDefine('SUPABASE_URL', defaultValue: 'https://acevqbdpzgbtqznbpgzr.supabase.co')}/functions/v1',
    connectTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 30),
  ));

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

  Future<Response<dynamic>> _postRayChat(String dataStr) async {
    try {
      return await _edgeDio.post(
        '/ray-chat',
        data: dataStr,
        options: Options(headers: _edgeHeaders()),
      );
    } on DioException catch (e) {
      if (_isAuthError(e)) {
        try {
          await _client.auth.refreshSession();
        } catch (_) {}
        return await _edgeDio.post(
          '/ray-chat',
          data: dataStr,
          options: Options(headers: _edgeHeaders()),
        );
      }
      rethrow;
    }
  }

  /// Returns whether the next validation is free and its price.
  ///
  /// Note: server (`ray-chat`) is the source of truth; this is only for UI labels.
  Future<RayPricing> getValidationPrice() async {
    final user = _client.auth.currentUser;
    if (user == null) throw RayFailure('Пользователь не авторизован');

    try {
      final resp = await _client
          .from('idea_validations')
          .select('id')
          .eq('user_id', user.id)
          .eq('status', 'completed')
          .limit(1)
          .count(CountOption.exact);

      final count = resp.count;
      final isFree = count == 0;
      return RayPricing(priceGp: isFree ? 0 : kValidationCostGp, isFree: isFree);
    } catch (e) {
      // Fail closed: if we can't determine, show paid to avoid "free" expectations.
      return const RayPricing(priceGp: kValidationCostGp, isFree: false);
    }
  }

  /// Creates a new chat row for Ray in `leo_chats` (bot='ray').
  Future<String> createChat() async {
    final user = _client.auth.currentUser;
    if (user == null) throw RayFailure('Пользователь не авторизован');

    try {
      final inserted = await _client
          .from('leo_chats')
          .insert({
            'user_id': user.id,
            'title': 'Проверка идеи (Ray)',
            'bot': kBotDbId,
          })
          .select('id')
          .single();

      return inserted['id'] as String;
    } on PostgrestException catch (e) {
      throw RayFailure(e.message);
    } catch (_) {
      throw RayFailure('Не удалось создать чат Ray');
    }
  }

  /// Creates a new validation linked to a chat. Minimal insert is enough
  /// because table has defaults (status=in_progress, current_step=0, gp_spent=0).
  Future<String> createValidation({required String chatId}) async {
    final user = _client.auth.currentUser;
    if (user == null) throw RayFailure('Пользователь не авторизован');

    try {
      final inserted = await _client
          .from('idea_validations')
          .insert({
            'user_id': user.id,
            'chat_id': chatId,
          })
          .select('id')
          .single();
      return inserted['id'] as String;
    } on PostgrestException catch (e) {
      throw RayFailure(e.message);
    } catch (_) {
      throw RayFailure('Не удалось создать проверку идеи');
    }
  }

  Future<String?> getValidationIdByChatId(String chatId) async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    try {
      final row = await _client
          .from('idea_validations')
          .select('id')
          .eq('user_id', user.id)
          .eq('chat_id', chatId)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();
      return (row == null) ? null : (row['id'] as String?);
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getValidation(String validationId) async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    try {
      final row = await _client
          .from('idea_validations')
          .select(
              'id, status, current_step, report_markdown, total_score, archetype, recommended_levels, one_thing, slots_state')
          .eq('id', validationId)
          .eq('user_id', user.id)
          .maybeSingle();
      if (row == null) return null;
      return Map<String, dynamic>.from(row as Map);
    } catch (_) {
      return null;
    }
  }

  /// Loads messages for a chat from `leo_messages`.
  Future<List<Map<String, dynamic>>> loadChatMessages(String chatId) async {
    try {
      final rows = await _client
          .from('leo_messages')
          .select('id, role, content, created_at')
          .eq('chat_id', chatId)
          .order('created_at', ascending: true);

      return List<Map<String, dynamic>>.from(
        rows.map((e) => Map<String, dynamic>.from(e as Map)),
      );
    } on PostgrestException catch (e) {
      throw RayFailure(e.message);
    } catch (_) {
      throw RayFailure('Не удалось загрузить историю сообщений');
    }
  }

  /// Saves one message in `leo_messages` and updates `leo_chats.message_count/updated_at`.
  Future<void> saveConversationMessage({
    required String chatId,
    required String role,
    required String content,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw RayFailure('Пользователь не авторизован');

    try {
      await _client.from('leo_messages').insert({
        'chat_id': chatId,
        'user_id': user.id,
        'role': role,
        'content': content,
      });

      final chatRow = await _client
          .from('leo_chats')
          .select('message_count')
          .eq('id', chatId)
          .single();
      final currentCount = chatRow['message_count'] as int? ?? 0;

      await _client.from('leo_chats').update({
        'message_count': currentCount + 1,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', chatId);
    } on PostgrestException catch (e) {
      throw RayFailure(e.message);
    } catch (_) {
      throw RayFailure('Не удалось сохранить сообщение');
    }
  }

  /// Calls Edge Function `ray-chat` in dialog mode.
  ///
  /// `messages` uses chat completion format: [{role: 'user'|'assistant', content: '...'}]
  Future<Map<String, dynamic>> dialog({
    required String validationId,
    required List<Map<String, dynamic>> messages,
    String? action,
  }) async {
    final session = _client.auth.currentSession;
    if (session == null) throw RayFailure('Пользователь не авторизован');

    return _withRetry(() async {
      try {
        final payload = jsonEncode({
          'mode': 'dialog',
          'validationId': validationId,
          'messages': messages,
          if (action != null) 'action': action,
        });

        final response = await _postRayChat(payload);

        if (response.statusCode == 200 && response.data is Map) {
          return Map<String, dynamic>.from(response.data as Map);
        }

        final msg = _parseServerMessage(response.data) ?? 'Неизвестная ошибка Ray';
        throw RayFailure(msg, statusCode: response.statusCode);
      } on DioException catch (e) {
        try {
          await Sentry.captureException(e);
        } catch (_) {}

        if (e.error is SocketException) {
          throw RayFailure('Нет соединения с интернетом');
        }

        final status = e.response?.statusCode;
        final parsed = _parseServerMessage(e.response?.data);

        if (status == 402) {
          throw RayFailure(
            'Недостаточно GP',
            statusCode: 402,
            code: 'insufficient_gp',
          );
        }
        if (parsed != null) {
          throw RayFailure(parsed, statusCode: status);
        }
        if ((status ?? 0) >= 500) {
          throw RayFailure('Сервер Ray временно недоступен. Попробуйте позже.');
        }
        throw RayFailure('Сетевая ошибка при обращении к Ray');
      } catch (e) {
        try {
          await Sentry.captureException(e);
        } catch (_) {
          debugPrint('DEBUG: Exception (Sentry not configured): $e');
        }
        if (e is RayFailure) rethrow;
        throw RayFailure('Не удалось получить ответ Ray');
      }
    });
  }

  /// Calls Edge Function `ray-chat` in score mode and returns report markdown.
  Future<Map<String, dynamic>> score({
    required String validationId,
    required List<Map<String, dynamic>> messages,
  }) async {
    final session = _client.auth.currentSession;
    if (session == null) throw RayFailure('Пользователь не авторизован');

    return _withRetry(() async {
      try {
        final payload = jsonEncode({
          'mode': 'score',
          'validationId': validationId,
          'messages': messages,
        });
        final response = await _postRayChat(payload);
        if (response.statusCode == 200 && response.data is Map) {
          return Map<String, dynamic>.from(response.data as Map);
        }
        final msg =
            _parseServerMessage(response.data) ?? 'Неизвестная ошибка отчёта Ray';
        throw RayFailure(msg, statusCode: response.statusCode);
      } on DioException catch (e) {
        try {
          await Sentry.captureException(e);
        } catch (_) {}
        if (e.error is SocketException) {
          throw RayFailure('Нет соединения с интернетом');
        }
        final status = e.response?.statusCode;
        final parsed = _parseServerMessage(e.response?.data);
        if (parsed != null) {
          throw RayFailure(parsed, statusCode: status);
        }
        if ((status ?? 0) >= 500) {
          throw RayFailure(
              'Сервер отчёта Ray временно недоступен. Попробуйте позже.');
        }
        throw RayFailure('Сетевая ошибка при формировании отчёта');
      } catch (e) {
        try {
          await Sentry.captureException(e);
        } catch (_) {
          debugPrint('DEBUG: Exception (Sentry not configured): $e');
        }
        if (e is RayFailure) rethrow;
        throw RayFailure('Не удалось сформировать отчёт');
      }
    });
  }

  /// Spends GP is performed on server, but we refresh local cached balance after start.
  Future<void> refreshGpBalanceCache() async {
    try {
      final gp = GpService(_client);
      final fresh = await gp.getBalance();
      await GpService.saveBalanceCache(fresh);
      _addBreadcrumb('gp', 'gp_balance_refreshed_after_ray', {
        'balance_after': fresh,
      });
    } catch (_) {}
  }

  /// Generic retry with exponential backoff (300ms, 600ms)
  Future<T> _withRetry<T>(Future<T> Function() action, {int retries = 2}) async {
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
}


