import 'dart:io';

import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bizlevel/utils/hive_box_helper.dart';

/// Репозиторий прогресса мини‑кейсов (user_case_progress) с SWR‑кешем (Hive).
class CasesRepository {
  final SupabaseClient _client;
  CasesRepository(this._client);

  Future<Map<String, dynamic>?> getCaseStatus(int caseId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Пользователь не авторизован');
    }

    final String cacheKey = 'user_${userId}_case_$caseId';

    Future<Map<String, dynamic>?> readCached() async {
      final cached = await HiveBoxHelper.readValue('cases_progress', cacheKey);
      if (cached == null) return null;
      return Map<String, dynamic>.from(cached as Map);
    }

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

      HiveBoxHelper.putDeferred('cases_progress', cacheKey, result);
      return result;
    } on PostgrestException catch (e, st) {
      await Sentry.captureException(e, stackTrace: st);
      final cached = await readCached();
      if (cached != null) return cached;
      rethrow;
    } on SocketException {
      final cached = await readCached();
      if (cached != null) return cached;
      rethrow;
    } catch (_) {
      final cached = await readCached();
      if (cached != null) return cached;
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

      final String cacheKey = 'user_${userId}_case_$caseId';
      HiveBoxHelper.deleteValue('cases_progress', cacheKey);
    } on PostgrestException catch (e, st) {
      await Sentry.captureException(e, stackTrace: st);
      rethrow;
    }
  }
}
