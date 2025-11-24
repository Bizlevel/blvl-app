import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bizlevel/utils/env_helper.dart';

// Private options holder for building Edge headers in a type-safe way
class _EdgeHeadersOptions {
  const _EdgeHeadersOptions({
    required this.authorization,
    required this.apikey,
    this.idempotencyKey,
    this.xUserJwt,
    this.json = true,
  });

  final String authorization;
  final String apikey;
  final String? idempotencyKey;
  final String? xUserJwt;
  final bool json;
}

class GpFailure implements Exception {
  final String message;
  GpFailure(this.message);
  @override
  String toString() => 'GpFailure: $message';
}

class GpService {
  GpService(this._client);

  final SupabaseClient _client;
  static const int _kDefaultFloorPrice = 1000;

  static final Dio _edgeDio = Dio(BaseOptions(
    baseUrl:
        '${const String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://acevqbdpzgbtqznbpgzr.supabase.co')}/functions/v1',
    connectTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
  ));

  // ----------------- Small safety helpers -----------------
  Session _requireSession() {
    final session = _client.auth.currentSession;
    if (session == null) throw GpFailure('Не авторизован');
    return session;
  }

  void _addBreadcrumb(String message,
      {SentryLevel level = SentryLevel.info,
      Map<String, Object?> data = const {}}) {
    try {
      Sentry.addBreadcrumb(
        Breadcrumb(message: message, level: level, data: data),
      );
    } catch (_) {}
  }

  // Breadcrumb wrappers
  void _bcBalanceLoaded(int balance) =>
      _addBreadcrumb('gp_balance_loaded', data: {'balance': balance});
  void _bcSpent(String type, int amount) =>
      _addBreadcrumb('gp_spent', data: {'type': type, 'amount': amount});
  void _bcFloorUnlocked(int floor) =>
      _addBreadcrumb('gp_floor_unlocked', data: {'floor': floor});
  void _bcBonusGranted(String ruleKey) =>
      _addBreadcrumb('gp_bonus_granted', data: {'rule_key': ruleKey});

  Map<String, String> _edgeHeaders(_EdgeHeadersOptions o) {
    final headers = <String, String>{
      'Authorization': o.authorization,
      'apikey': o.apikey,
    };
    if (o.json) headers['Content-Type'] = 'application/json';
    if (o.idempotencyKey != null && o.idempotencyKey!.isNotEmpty) {
      headers['Idempotency-Key'] = o.idempotencyKey!;
    }
    if (o.xUserJwt != null && o.xUserJwt!.isNotEmpty) {
      headers['x-user-jwt'] = o.xUserJwt!;
    }
    return headers;
  }

  // Header wrappers
  Map<String, String> _edgeHeadersForSession(Session session,
          {String? idempotencyKey, bool json = true}) =>
      _edgeHeaders(_EdgeHeadersOptions(
        authorization: 'Bearer ${session.accessToken}',
        apikey: envOrDefine('SUPABASE_ANON_KEY'),
        idempotencyKey: idempotencyKey,
        json: json,
      ));

  Map<String, String> _edgeHeadersAnonWithUserJwt(Session session,
          {bool json = true}) =>
      _edgeHeaders(_EdgeHeadersOptions(
        authorization: 'Bearer ${envOrDefine('SUPABASE_ANON_KEY')}',
        apikey: envOrDefine('SUPABASE_ANON_KEY'),
        xUserJwt: session.accessToken,
        json: json,
      ));

  // reserved for future use

  Future<Map<String, int>> _getBalanceViaEdge(Session session) async {
    final resp = await _edgeDio.get('/gp-balance',
        options: Options(headers: _edgeHeadersForSession(session)));
    if (resp.statusCode == 200 && resp.data is Map<String, dynamic>) {
      final m = Map<String, dynamic>.from(resp.data);
      return {
        'balance': (m['balance'] as num?)?.toInt() ?? 0,
        'total_earned': (m['total_earned'] as num?)?.toInt() ?? 0,
        'total_spent': (m['total_spent'] as num?)?.toInt() ?? 0,
      };
    }
    throw GpFailure('Не удалось загрузить баланс');
  }

  Future<int> _spendViaEdge(
    Session session, {
    required String type,
    required int amount,
    required String referenceId,
    String? idempotencyKey,
  }) async {
    final resp = await _edgeDio.post('/gp-spend',
        data: jsonEncode({
          'type': type,
          'amount': amount,
          'reference_id': referenceId,
        }),
        options: Options(
            headers: _edgeHeadersForSession(session,
                idempotencyKey: idempotencyKey)));
    if (resp.statusCode == 200 && resp.data is Map<String, dynamic>) {
      final m = Map<String, dynamic>.from(resp.data);
      return (m['balance_after'] as num?)?.toInt() ?? 0;
    }
    throw GpFailure('Не удалось списать GP');
  }

  int? _parseBalanceAfter(dynamic data) {
    final scalar = _asFirstInt(data);
    if (scalar != null) return scalar;
    final row = _asRow(data);
    if (row != null) {
      final r = row; // promote to non-nullable for analyzer
      return (r['balance_after'] as num?)?.toInt();
    }
    return null;
  }

  bool _shouldEdgeFallback(PostgrestException e) {
    return !kReleaseMode && _isFunctionMissing(e);
  }

  // _rethrowWithCapture: не используется, удалено

  T _handlePostgrestException<T>(
    PostgrestException e, {
    void Function()? onInsufficient,
    T Function()? devFallback,
  }) {
    final msg = e.message.toString();
    if (msg.contains('gp_insufficient_balance')) {
      if (onInsufficient != null) onInsufficient();
    }
    if (devFallback != null && _shouldEdgeFallback(e)) {
      return devFallback();
    }
    // ignore: only_throw_errors
    throw e;
  }

  Future<int> getFloorPrice({required int floorNumber}) async {
    // Возвращает цену пакета доступа к этажу из таблицы packages;
    // при ошибке/отсутствии записи — дефолтная цена
    try {
      final code = _packageCodeForFloor(floorNumber);
      final res = await _client
          .from('packages')
          .select('price_gp, active')
          .eq('code', code)
          .limit(1)
          .maybeSingle();
      if (res != null) {
        final m = Map<String, dynamic>.from(res as Map);
        final bool isActive = (m['active'] as bool?) ?? true;
        final int? price = (m['price_gp'] as num?)?.toInt();
        if (isActive && price != null && price > 0) {
          return price;
        }
      }
    } catch (e) {
      await _capture(e);
    }
    return _kDefaultFloorPrice;
  }

  Future<int> _unlockFloorViaEdge(
    Session session, {
    required int floorNumber,
    required String idempotencyKey,
  }) async {
    final resp = await _edgeDio.post('/gp-floor-unlock',
        data: jsonEncode({'floor_number': floorNumber}),
        options: Options(
            headers: _edgeHeadersForSession(session,
                idempotencyKey: idempotencyKey)));
    if (resp.statusCode == 200 && resp.data is Map<String, dynamic>) {
      final m = Map<String, dynamic>.from(resp.data);
      return (m['balance_after'] as num?)?.toInt() ?? 0;
    }
    throw GpFailure('Не удалось открыть этаж');
  }

  Future<int> _bonusViaEdge(Session session, {required String ruleKey}) async {
    final resp = await _edgeDio.post('/gp-bonus-claim',
        data: jsonEncode({'rule_key': ruleKey}),
        options: Options(headers: _edgeHeadersForSession(session)));
    if (resp.statusCode == 200 && resp.data is Map<String, dynamic>) {
      final m = Map<String, dynamic>.from(resp.data);
      return (m['balance_after'] as num?)?.toInt() ?? 0;
    }
    throw GpFailure('Не удалось получить бонус');
  }

  Future<Map<String, int>> getBalance() async {
    return _withRetry(() async {
      try {
        _requireSession();
        final data = await _client.rpc('gp_balance');
        final row = _asRow(data);
        if (row != null) {
          _bcBalanceLoaded((row['balance'] as num?)?.toInt() ?? 0);
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
            final session = _requireSession();
            return await _getBalanceViaEdge(session);
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
    Map<String, dynamic> buildSpendParams() => {
          'p_type': type,
          'p_amount': amount,
          'p_reference_id': referenceId,
          'p_idempotency_key': idempotencyKey ?? '',
        };
    return _withRetry(() async {
      try {
        _requireSession();
        final data = await _client.rpc('gp_spend', params: buildSpendParams());
        final parsed = _parseBalanceAfter(data);
        if (parsed != null) {
          _bcSpent(type, amount);
          return parsed;
        }
        throw GpFailure('Не удалось списать GP');
      } on PostgrestException catch (e) {
        return _handlePostgrestException<int>(e,
            onInsufficient: () => _throwInsufficientBalanceBreadcrumb(
                  source: 'spend',
                  extra: {'type': type, 'amount': amount},
                ),
            devFallback: () async {
              try {
                final session = _requireSession();
                return await _spendViaEdge(
                  session,
                  type: type,
                  amount: amount,
                  referenceId: referenceId,
                  idempotencyKey: idempotencyKey,
                );
              } catch (_) {
                // ignore and rethrow below
              }
              // ignore: use_rethrow_when_possible, only_throw_errors
              throw e;
            } as int Function());
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
          options: Options(headers: _edgeHeadersAnonWithUserJwt(session)));
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
      return await _postVerify(session, body: {'purchase_id': purchaseId});
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

  /// Верификация покупки через IAP (App Store / Google Play)
  /// platform: 'ios' | 'android'
  /// token: iOS receipt (base64) либо Android purchaseToken
  Future<int> verifyIapPurchase({
    required String platform,
    required String productId,
    required String token,
    String? packageName,
  }) async {
    final session = _client.auth.currentSession;
    if (session == null) throw GpFailure('Не авторизован');
    try {
      final body = <String, dynamic>{
        'platform': platform,
        'product_id': productId,
        'token': token,
      };
      // Для Android передаём фактическое имя пакета, чтобы исключить рассинхрон с env
      if (platform == 'android' &&
          packageName != null &&
          packageName.isNotEmpty) {
        body['package_name'] = packageName;
      }
      return await _postVerify(session, body: body);
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

  Future<int> _postVerify(Session session,
      {required Map<String, dynamic> body}) async {
    try {
      final resp = await _edgeDio.post('/gp-purchase-verify',
          data: jsonEncode(body),
          options: Options(headers: _edgeHeadersAnonWithUserJwt(session)));
      if (resp.statusCode == 200 && resp.data is Map<String, dynamic>) {
        final m = Map<String, dynamic>.from(resp.data);
        return (m['balance_after'] as num?)?.toInt() ?? 0;
      }
      // Попробуем отдать код ошибки от Edge (например: google_purchase_failed, android_package_missing)
      try {
        final data = resp.data;
        if (data is Map &&
            data['error'] is String &&
            (data['error'] as String).isNotEmpty) {
          throw GpFailure('Ошибка подтверждения: ${data['error']}');
        }
      } catch (_) {}
      throw GpFailure('Не удалось подтвердить покупку');
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map &&
          data['error'] is String &&
          (data['error'] as String).isNotEmpty) {
        throw GpFailure('Ошибка подтверждения: ${data['error']}');
      }
      rethrow;
    }
  }

  Future<int> unlockFloor({
    required int floorNumber,
    required String idempotencyKey,
  }) async {
    _requireSession();
    try {
      // Переход на модель пакетов: покупка пакета доступа к этажу
      final packageCode = _packageCodeForFloor(floorNumber);
      final data = await _client.rpc('gp_package_buy', params: {
        'p_package_code': packageCode,
        'p_idempotency_key': idempotencyKey,
      });
      final parsed = _parseBalanceAfter(data);
      if (parsed != null) {
        _bcFloorUnlocked(floorNumber);
        return parsed;
      }
      throw GpFailure('Не удалось открыть этаж');
    } on PostgrestException catch (e) {
      return _handlePostgrestException<int>(e,
          onInsufficient: () => _throwInsufficientBalanceBreadcrumb(
                source: 'unlock_floor',
                extra: {'amount': _kDefaultFloorPrice, 'floor': floorNumber},
              ),
          devFallback: () async {
            try {
              final session = _requireSession();
              return await _unlockFloorViaEdge(
                session,
                floorNumber: floorNumber,
                idempotencyKey: idempotencyKey,
              );
            } catch (_) {
              // ignore and rethrow below
            }
            // ignore: use_rethrow_when_possible, only_throw_errors
            throw e;
          } as int Function());
    } on SocketException {
      throw GpFailure('Нет соединения с интернетом');
    } catch (e) {
      await _capture(e);
      throw GpFailure('Не удалось открыть этаж');
    }
  }

  Future<int> claimBonus({required String ruleKey}) async {
    _requireSession();
    try {
      final data = await _client.rpc('gp_bonus_claim', params: {
        'p_rule_key': ruleKey,
      });
      final parsed = _parseBalanceAfter(data);
      if (parsed != null) {
        _bcBonusGranted(ruleKey);
        return parsed;
      }
      throw GpFailure('Не удалось получить бонус');
    } on PostgrestException catch (e) {
      return _handlePostgrestException<int>(e,
          devFallback: () async {
            try {
              final session = _requireSession();
              return await _bonusViaEdge(session, ruleKey: ruleKey);
            } catch (_) {
              // ignore and rethrow below
            }
            // ignore: use_rethrow_when_possible, only_throw_errors
            throw e;
          } as int Function());
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
