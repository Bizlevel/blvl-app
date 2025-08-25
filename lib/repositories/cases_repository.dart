import 'dart:io';

import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Репозиторий прогресса мини‑кейсов (user_case_progress) с SWR‑кешем (Hive).
class CasesRepository {
  final SupabaseClient _client;
  CasesRepository(this._client);

  Future<Map<String, dynamic>?> getCaseStatus(int caseId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Пользователь не авторизован');
    }

    final Box cache = await Hive.openBox('cases_progress');
    final String cacheKey = 'user_${userId}_case_$caseId';

    try {
      final response = await _client
          .from('user_case_progress')
          .select(
              'user_id, case_id, status, steps_completed, hints_used, started_at, updated_at, completed_at')
          .eq('case_id', caseId)
          .order('updated_at', ascending: false)
          .limit(1);

      final rows = (response as List<dynamic>)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
      final result = rows.isEmpty ? null : rows.first;

      await cache.put(cacheKey, result);
      return result;
    } on PostgrestException catch (e, st) {
      await Sentry.captureException(e, stackTrace: st);
      // Фолбэк на кеш
      final cached = cache.get(cacheKey);
      if (cached != null) {
        return Map<String, dynamic>.from(cached as Map);
      }
      rethrow;
    } on SocketException {
      final cached = cache.get(cacheKey);
      if (cached != null) {
        return Map<String, dynamic>.from(cached as Map);
      }
      rethrow;
    } catch (_) {
      final cached = cache.get(cacheKey);
      if (cached != null) {
        return Map<String, dynamic>.from(cached as Map);
      }
      rethrow;
    }
  }

  Future<void> startCase(int caseId) async {
    await _upsertStatus(caseId, 'started', startedNow: true);
  }

  Future<void> skipCase(int caseId) async {
    await _upsertStatus(caseId, 'skipped', completeNow: true);
  }

  Future<void> completeCase(int caseId) async {
    await _upsertStatus(caseId, 'completed', completeNow: true);
  }

  Future<void> incrementHint(int caseId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Пользователь не авторизован');
    }

    try {
      // Пытаемся инкрементировать; если записи нет — создаём started с hints_used = 1
      final current = await _client
          .from('user_case_progress')
          .select('hints_used, status')
          .eq('user_id', userId)
          .eq('case_id', caseId)
          .maybeSingle();

      final int newHints = (current?['hints_used'] as int? ?? 0) + 1;
      await _client.from('user_case_progress').upsert({
        'user_id': userId,
        'case_id': caseId,
        'status':
            current == null ? 'started' : (current['status'] ?? 'started'),
        'hints_used': newHints,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'user_id,case_id');
    } on PostgrestException catch (e, st) {
      await Sentry.captureException(e, stackTrace: st);
      rethrow;
    }
  }

  Future<void> _upsertStatus(int caseId, String status,
      {bool startedNow = false, bool completeNow = false}) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Пользователь не авторизован');
    }

    try {
      final payload = <String, dynamic>{
        'user_id': userId,
        'case_id': caseId,
        'status': status,
        'updated_at': DateTime.now().toIso8601String(),
      };
      if (startedNow) {
        payload['started_at'] = DateTime.now().toIso8601String();
      }
      if (completeNow) {
        payload['completed_at'] = DateTime.now().toIso8601String();
      }

      await _client
          .from('user_case_progress')
          .upsert(payload, onConflict: 'user_id,case_id');

      // Обновим кеш
      final Box cache = await Hive.openBox('cases_progress');
      final String cacheKey = 'user_${userId}_case_$caseId';
      final cached = await getCaseStatus(caseId);
      await cache.put(cacheKey, cached);
    } on PostgrestException catch (e, st) {
      await Sentry.captureException(e, stackTrace: st);
      rethrow;
    }
  }
}
