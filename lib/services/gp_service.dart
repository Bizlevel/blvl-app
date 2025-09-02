import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bizlevel/utils/env_helper.dart';

class GpFailure implements Exception {
  final String message;
  GpFailure(this.message);
  @override
  String toString() => 'GpFailure: $message';
}

class GpService {
  GpService(this._client);

  final SupabaseClient _client;

  static final Dio _edgeDio = Dio(BaseOptions(
    baseUrl:
        '${const String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://acevqbdpzgbtqznbpgzr.supabase.co')}/functions/v1',
    connectTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
    responseType: ResponseType.json,
  ));

  Future<Map<String, int>> getBalance() async {
    return _withRetry(() async {
      try {
        final session = _client.auth.currentSession;
        if (session == null) throw GpFailure('Не авторизован');
        final data = await _client.rpc('gp_balance');
        final row = _asRow(data);
        if (row != null) {
          try {
            await Sentry.addBreadcrumb(Breadcrumb(
              message: 'gp_balance_loaded',
              level: SentryLevel.info,
              data: {
                'balance': (row['balance'] as num?)?.toInt() ?? 0,
              },
            ));
          } catch (_) {}
          return {
            'balance': (row['balance'] as num?)?.toInt() ?? 0,
            'total_earned': (row['total_earned'] as num?)?.toInt() ?? 0,
            'total_spent': (row['total_spent'] as num?)?.toInt() ?? 0,
          };
        }
        throw GpFailure('Не удалось загрузить баланс');
      } on PostgrestException catch (e) {
        // dev-fallback: если RPC ещё не доставлены
        if (!kReleaseMode && _isFunctionMissing(e)) {
          try {
            final session = _client.auth.currentSession;
            if (session == null) throw GpFailure('Не авторизован');
            final resp = await _edgeDio.get(
              '/gp-balance',
              options: Options(
                headers: _edgeHeaders(
                  authorization: 'Bearer ${session.accessToken}',
                  apikey: envOrDefine('SUPABASE_ANON_KEY'),
                ),
              ),
            );
            if (resp.statusCode == 200 && resp.data is Map<String, dynamic>) {
              final m = Map<String, dynamic>.from(resp.data);
              return {
                'balance': (m['balance'] as num?)?.toInt() ?? 0,
                'total_earned': (m['total_earned'] as num?)?.toInt() ?? 0,
                'total_spent': (m['total_spent'] as num?)?.toInt() ?? 0,
              };
            }
          } catch (_) {}
        }
        await _capture(e);
        throw GpFailure('Ошибка сервера при загрузке баланса');
      } on SocketException {
        throw GpFailure('Нет соединения с интернетом');
      } catch (e) {
        await _capture(e);
        throw GpFailure('Не удалось загрузить баланс');
      }
    });
  }

  Future<int> spend({
    required String type,
    required int amount,
    String referenceId = '',
    String? idempotencyKey,
  }) async {
    return _withRetry(() async {
      try {
        final session = _client.auth.currentSession;
        if (session == null) throw GpFailure('Не авторизован');
        final params = {
          'p_type': type,
          'p_amount': amount,
          'p_reference_id': referenceId,
          'p_idempotency_key': idempotencyKey ?? '',
        };
        final data = await _client.rpc('gp_spend', params: params);
        final row = _asRow(data);
        if (row != null) {
          try {
            await Sentry.addBreadcrumb(Breadcrumb(
              message: 'gp_spent',
              level: SentryLevel.info,
              data: {
                'type': type,
                'amount': amount,
              },
            ));
          } catch (_) {}
          return (row['balance_after'] as num?)?.toInt() ?? 0;
        }
        throw GpFailure('Не удалось списать GP');
      } on PostgrestException catch (e) {
        if (!kReleaseMode && _isFunctionMissing(e)) {
          try {
            final session = _client.auth.currentSession;
            if (session == null) throw GpFailure('Не авторизован');
            final resp = await _edgeDio.post(
              '/gp-spend',
              data: jsonEncode({
                'type': type,
                'amount': amount,
                'reference_id': referenceId,
              }),
              options: Options(
                headers: _edgeHeaders(
                  authorization: 'Bearer ${session.accessToken}',
                  apikey: envOrDefine('SUPABASE_ANON_KEY'),
                  idempotencyKey: idempotencyKey,
                ),
              ),
            );
            if (resp.statusCode == 200 && resp.data is Map<String, dynamic>) {
              final m = Map<String, dynamic>.from(resp.data);
              return (m['balance_after'] as num?)?.toInt() ?? 0;
            }
          } on DioException catch (de) {
            final data = de.response?.data;
            if (data is Map && data['error'] == 'gp_insufficient_balance') {
              _throwInsufficientBalanceBreadcrumb(
                source: 'spend',
                extra: {'type': type, 'amount': amount},
              );
            }
          } catch (_) {}
        }
        final msg = e.message.toString();
        if (msg.contains('gp_insufficient_balance')) {
          _throwInsufficientBalanceBreadcrumb(
            source: 'spend',
            extra: {'type': type, 'amount': amount},
          );
        }
        await _capture(e);
        throw GpFailure('Ошибка сервера при списании GP');
      } on SocketException {
        throw GpFailure('Нет соединения с интернетом');
      } catch (e) {
        await _capture(e);
        throw GpFailure('Не удалось списать GP');
      }
    });
  }

  Future<Map<String, String>> initPurchase({
    required String packageId,
    String provider = 'epay',
  }) async {
    final session = _client.auth.currentSession;
    if (session == null) throw GpFailure('Не авторизован');
    try {
      final resp = await _edgeDio.post('/gp-purchase-init',
          data: jsonEncode({
            'package_id': packageId,
            'provider': provider,
          }),
          options: Options(headers: {
            'Authorization': 'Bearer ${envOrDefine('SUPABASE_ANON_KEY')}',
            'apikey': envOrDefine('SUPABASE_ANON_KEY'),
            'x-user-jwt': session.accessToken,
            'Content-Type': 'application/json',
          }));
      if (resp.statusCode == 200 && resp.data is Map<String, dynamic>) {
        final m = Map<String, dynamic>.from(resp.data);
        // Сохраним purchase_id локально для кнопки «Проверить покупку»
        try {
          if (m['purchase_id'] != null) {
            final box = Hive.box(_boxName);
            await box.put('last_purchase_id', m['purchase_id'].toString());
          }
        } catch (_) {}
        return {
          'payment_url':
              (m['payment_url'] as String?) ?? (m['url'] as String? ?? ''),
          if (m['purchase_id'] != null)
            'purchase_id': m['purchase_id'].toString(),
        };
      }
      throw GpFailure('Не удалось создать покупку');
    } on DioException catch (e) {
      try {
        await Sentry.captureException(e);
      } catch (_) {}
      if (e.error is SocketException) {
        throw GpFailure('Нет соединения с интернетом');
      }
      await _capture(e);
      throw GpFailure('Ошибка сети при создании покупки');
    } catch (e) {
      await _capture(e);
      throw GpFailure('Не удалось создать покупку');
    }
  }

  Future<int> verifyPurchase({required String purchaseId}) async {
    final session = _client.auth.currentSession;
    if (session == null) throw GpFailure('Не авторизован');
    try {
      final resp = await _edgeDio.post('/gp-purchase-verify',
          data: jsonEncode({'purchase_id': purchaseId}),
          options: Options(headers: {
            'Authorization': 'Bearer ${envOrDefine('SUPABASE_ANON_KEY')}',
            'apikey': envOrDefine('SUPABASE_ANON_KEY'),
            'x-user-jwt': session.accessToken,
            'Content-Type': 'application/json',
          }));
      if (resp.statusCode == 200 && resp.data is Map<String, dynamic>) {
        final m = Map<String, dynamic>.from(resp.data);
        return (m['balance_after'] as num?)?.toInt() ?? 0;
      }
      throw GpFailure('Не удалось подтвердить покупку');
    } on DioException catch (e) {
      if (e.error is SocketException) {
        throw GpFailure('Нет соединения с интернетом');
      }
      await _capture(e);
      throw GpFailure('Ошибка сети при подтверждении покупки');
    } catch (e) {
      await _capture(e);
      throw GpFailure('Не удалось подтвердить покупку');
    }
  }

  Future<int> unlockFloor({
    required int floorNumber,
    required String idempotencyKey,
  }) async {
    final session = _client.auth.currentSession;
    if (session == null) throw GpFailure('Не авторизован');
    try {
      // Переход на модель пакетов: покупка пакета доступа к этажу
      final packageCode = _packageCodeForFloor(floorNumber);
      final data = await _client.rpc('gp_package_buy', params: {
        'p_package_code': packageCode,
        'p_idempotency_key': idempotencyKey,
      });
      // Поддерживаем оба формата ответа: record {balance_after} и скалярный int
      final scalar = _asFirstInt(data);
      if (scalar != null) {
        try {
          await Sentry.addBreadcrumb(Breadcrumb(
            message: 'gp_floor_unlocked',
            level: SentryLevel.info,
            data: {'floor': floorNumber},
          ));
        } catch (_) {}
        return scalar;
      }
      final row = _asRow(data);
      if (row != null) {
        try {
          await Sentry.addBreadcrumb(Breadcrumb(
            message: 'gp_floor_unlocked',
            level: SentryLevel.info,
            data: {'floor': floorNumber},
          ));
        } catch (_) {}
        return (row['balance_after'] as num?)?.toInt() ?? 0;
      }
      throw GpFailure('Не удалось открыть этаж');
    } on PostgrestException catch (e) {
      if (!kReleaseMode && _isFunctionMissing(e)) {
        try {
          final session = _client.auth.currentSession;
          if (session == null) throw GpFailure('Не авторизован');
          // Дев-фолбэк: старый edge эндпоинт
          final resp = await _edgeDio.post(
            '/gp-floor-unlock',
            data: jsonEncode({'floor_number': floorNumber}),
            options: Options(
              headers: _edgeHeaders(
                authorization: 'Bearer ${session.accessToken}',
                apikey: envOrDefine('SUPABASE_ANON_KEY'),
                idempotencyKey: idempotencyKey,
              ),
            ),
          );
          if (resp.statusCode == 200 && resp.data is Map<String, dynamic>) {
            final m = Map<String, dynamic>.from(resp.data);
            return (m['balance_after'] as num?)?.toInt() ?? 0;
          }
        } catch (_) {}
      }
      final msg = e.message.toString();
      if (msg.contains('gp_insufficient_balance')) {
        _throwInsufficientBalanceBreadcrumb(
          source: 'unlock_floor',
          extra: {'amount': 1000, 'floor': floorNumber},
        );
      }
      await _capture(e);
      throw GpFailure('Ошибка сервера при открытии этажа');
    } on SocketException {
      throw GpFailure('Нет соединения с интернетом');
    } catch (e) {
      await _capture(e);
      throw GpFailure('Не удалось открыть этаж');
    }
  }

  Future<int> claimBonus({required String ruleKey}) async {
    final session = _client.auth.currentSession;
    if (session == null) throw GpFailure('Не авторизован');
    try {
      final data = await _client.rpc('gp_bonus_claim', params: {
        'p_rule_key': ruleKey,
      });
      final row = _asRow(data);
      if (row != null) {
        try {
          await Sentry.addBreadcrumb(Breadcrumb(
            message: 'gp_bonus_granted',
            level: SentryLevel.info,
            data: {'rule_key': ruleKey},
          ));
        } catch (_) {}
        return (row['balance_after'] as num?)?.toInt() ?? 0;
      }
      throw GpFailure('Не удалось получить бонус');
    } on PostgrestException catch (e) {
      if (!kReleaseMode && _isFunctionMissing(e)) {
        try {
          final session = _client.auth.currentSession;
          if (session == null) throw GpFailure('Не авторизован');
          final resp = await _edgeDio.post(
            '/gp-bonus-claim',
            data: jsonEncode({'rule_key': ruleKey}),
            options: Options(
              headers: _edgeHeaders(
                authorization: 'Bearer ${session.accessToken}',
                apikey: envOrDefine('SUPABASE_ANON_KEY'),
              ),
            ),
          );
          if (resp.statusCode == 200 && resp.data is Map<String, dynamic>) {
            final m = Map<String, dynamic>.from(resp.data);
            return (m['balance_after'] as num?)?.toInt() ?? 0;
          }
        } catch (_) {}
      }
      await _capture(e);
      throw GpFailure('Ошибка сервера при получении бонуса');
    } on SocketException {
      throw GpFailure('Нет соединения с интернетом');
    } catch (e) {
      await _capture(e);
      throw GpFailure('Не удалось получить бонус');
    }
  }

  bool _isFunctionMissing(PostgrestException e) {
    final msg = e.message.toString().toLowerCase();
    return msg.contains('function') &&
        (msg.contains('not found') ||
            msg.contains('does not exist') ||
            msg.contains('missing'));
  }

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

  Future<void> _capture(Object e) async {
    try {
      await Sentry.captureException(e);
    } catch (_) {}
  }

  // ----------------- Internal helpers (unify parsing/headers/errors) -----------------

  Map<String, dynamic>? _asRow(dynamic data) {
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    if (data is List && data.isNotEmpty) {
      final first = data.first;
      if (first is Map) {
        return Map<String, dynamic>.from(first);
      }
    }
    return null;
  }

  int? _asFirstInt(dynamic data) {
    if (data is num) return data.toInt();
    if (data is List && data.isNotEmpty && data.first is num) {
      return (data.first as num).toInt();
    }
    return null;
  }

  Map<String, String> _edgeHeaders({
    required String authorization,
    required String apikey,
    String? idempotencyKey,
    String? xUserJwt,
    bool json = true,
  }) {
    final headers = <String, String>{
      'Authorization': authorization,
      'apikey': apikey,
    };
    if (json) headers['Content-Type'] = 'application/json';
    if (idempotencyKey != null && idempotencyKey.isNotEmpty) {
      headers['Idempotency-Key'] = idempotencyKey;
    }
    if (xUserJwt != null && xUserJwt.isNotEmpty) {
      headers['x-user-jwt'] = xUserJwt;
    }
    return headers;
  }

  String _packageCodeForFloor(int floorNumber) => 'FLOOR_$floorNumber';

  Never _throwInsufficientBalanceBreadcrumb({
    required String source,
    Map<String, Object?> extra = const {},
  }) {
    try {
      Sentry.addBreadcrumb(Breadcrumb(
        message: 'gp_insufficient',
        level: SentryLevel.warning,
        data: {'source': source, ...extra},
      ));
    } catch (_) {}
    throw GpFailure('Недостаточно GP');
  }

  // Helpers for local SWR cache
  static const String _boxName = 'gp';
  static const String _keyBalance = 'balance_cache';

  static Future<void> saveBalanceCache(Map<String, int> data) async {
    try {
      final box = Hive.box(_boxName);
      await box.put(_keyBalance, data);
    } catch (_) {}
  }

  static Map<String, int>? readBalanceCache() {
    try {
      final box = Hive.box(_boxName);
      final raw = box.get(_keyBalance);
      if (raw is Map) {
        final m = Map<String, dynamic>.from(raw);
        return {
          'balance': (m['balance'] as num?)?.toInt() ?? 0,
          'total_earned': (m['total_earned'] as num?)?.toInt() ?? 0,
          'total_spent': (m['total_spent'] as num?)?.toInt() ?? 0,
        };
      }
    } catch (_) {}
    return null;
  }
}
