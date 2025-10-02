import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Репозиторий для работы с фичей «Цель»: версии цели, спринты, напоминания, цитаты.
///
/// Следует паттерну существующих репозиториев (SWR через Hive, graceful offline).
class GoalsRepository {
  final SupabaseClient _client;
  GoalsRepository(this._client);

  // ============================
  // Goals (core_goals)
  // ============================

  Future<Map<String, dynamic>?> fetchLatestGoal(String userId) async {
    final Box cache = Hive.box('goals');
    final String cacheKey = 'latest_$userId';

    try {
      final data = await _client
          .from('core_goals')
          .select('id, user_id, version, goal_text, version_data, updated_at')
          .eq('user_id', userId)
          .order('version', ascending: false)
          .limit(1)
          .maybeSingle();

      if (data != null) {
        await cache.put(cacheKey, data);
      }
      return data;
    } on SocketException {
      final cached = cache.get(cacheKey);
      return cached == null ? null : Map<String, dynamic>.from(cached);
    } catch (_) {
      final cached = cache.get(cacheKey);
      if (cached != null) {
        return Map<String, dynamic>.from(cached);
      }
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllGoals(String userId) async {
    final Box cache = Hive.box('goals');
    final String cacheKey = 'all_$userId';

    try {
      final List data = await _client
          .from('core_goals')
          .select('id, user_id, version, goal_text, version_data, updated_at')
          .eq('user_id', userId)
          .order('version', ascending: true);

      await cache.put(cacheKey, data);
      return List<Map<String, dynamic>>.from(data);
    } on SocketException {
      final cached = cache.get(cacheKey);
      if (cached != null) {
        return List<Map<String, dynamic>>.from(cached);
      }
      rethrow;
    } catch (_) {
      final cached = cache.get(cacheKey);
      if (cached != null) {
        return List<Map<String, dynamic>>.from(cached);
      }
      rethrow;
    }
  }

  /// Создать или обновить версию цели (upsert). user_id проставится триггером.
  Future<Map<String, dynamic>> upsertGoalVersion({
    required int version,
    required String goalText,
    required Map<String, dynamic> versionData,
  }) async {
    try {
      final resp = await _client.rpc('upsert_goal_version', params: {
        'p_version': version,
        'p_goal_text': goalText,
        'p_version_data': versionData,
      });
      if (resp is List && resp.isNotEmpty) {
        return Map<String, dynamic>.from(resp.first as Map);
      }
      if (resp is Map) {
        return Map<String, dynamic>.from(resp);
      }
      // fallback: старый путь (на случай отсутствия RPC в окружении dev)
      final String? userId = _client.auth.currentUser?.id;
      final payload = {
        'version': version,
        'goal_text': goalText,
        'version_data': versionData,
        if (userId != null) 'user_id': userId,
      };
      final result = await _client
          .from('core_goals')
          .upsert(payload, onConflict: 'user_id,version')
          .select()
          .single();
      return Map<String, dynamic>.from(result);
    } catch (e) {
      rethrow;
    }
  }

  /// Обновляет текущую (последнюю) версию v1 по id записи.
  Future<Map<String, dynamic>> updateGoalById({
    required String id,
    required String goalText,
    required Map<String, dynamic> versionData,
  }) async {
    final Map<String, dynamic> payload = {
      'goal_text': goalText,
      // не перезаписываем version_data, если передан пустой объект
      if (versionData.isNotEmpty) 'version_data': versionData,
    };
    final updated = await _client
        .from('core_goals')
        .update(payload)
        .eq('id', id)
        .select()
        .single();
    return Map<String, dynamic>.from(updated);
  }

  /// Возвращает агрегированное состояние цели пользователя и next_action
  Future<Map<String, dynamic>> fetchGoalState() async {
    final resp = await _client.rpc('fetch_goal_state');
    if (resp is List && resp.isNotEmpty) {
      return Map<String, dynamic>.from(resp.first as Map);
    }
    if (resp is Map) {
      return Map<String, dynamic>.from(resp);
    }
    return <String, dynamic>{};
  }

  /// Универсальная RPC‑обёртка для статуса спринта.
  Future<Map<String, dynamic>> _updateGoalSprint({
    required String action, // 'start'|'complete'|'pause'|'resume'
    DateTime? startDate,
  }) async {
    final String? iso = startDate?.toUtc().toIso8601String();
    final resp = await _client.rpc('update_goal_sprint', params: {
      'p_action': action,
      if (iso != null) 'p_start_date': iso,
    });
    if (resp is Map) return Map<String, dynamic>.from(resp);
    if (resp is List && resp.isNotEmpty) {
      return Map<String, dynamic>.from(resp.first as Map);
    }
    return <String, dynamic>{};
  }

  /// Старт 28‑дневного режима (RPC → fallback: upsert version_data.start_date)
  Future<Map<String, dynamic>> startSprint({DateTime? startDate}) async {
    try {
      return await _updateGoalSprint(
          action: 'start', startDate: startDate ?? DateTime.now());
    } catch (_) {
      final String iso =
          (startDate ?? DateTime.now().toUtc()).toIso8601String();
      return upsertGoalField(version: 4, field: 'start_date', value: iso);
    }
  }

  /// Завершение 28‑дневного режима (RPC, без fallback изменений данных)
  Future<Map<String, dynamic>> completeSprint() async {
    return _updateGoalSprint(action: 'complete');
  }

  /// 🆕 Проверяет серии выполненных дней и автоматически начисляет GP-бонусы (7/14/21/28)
  Future<Map<String, dynamic>> checkAndGrantStreakBonus() async {
    try {
      final resp = await _client.rpc('check_and_grant_streak_bonus');
      if (resp is Map) return Map<String, dynamic>.from(resp);
      return <String, dynamic>{};
    } catch (e) {
      debugPrint('checkAndGrantStreakBonus error: $e');
      return <String, dynamic>{};
    }
  }

  /// Получить daily_progress пользователя (MVP): если в БД нет таблицы,
  /// используем локальный Hive-кеш 'daily_progress_local'.
  Future<List<Map<String, dynamic>>> fetchDailyProgress() async {
    try {
      final List rows = await _client
          .from('daily_progress')
          .select(
              'id, user_id, day_number, date, task_text, completion_status, user_note, max_suggestion, created_at, updated_at')
          .order('day_number', ascending: true);
      return List<Map<String, dynamic>>.from(
          rows.map((e) => Map<String, dynamic>.from(e as Map)));
    } on PostgrestException {
      // Fallback на локальный кэш
      final Box cache = Hive.isBoxOpen('daily_progress_local')
          ? Hive.box('daily_progress_local')
          : await Hive.openBox('daily_progress_local');
      final List data = (cache.get('items') as List?) ?? const <dynamic>[];
      return List<Map<String, dynamic>>.from(
          data.map((e) => Map<String, dynamic>.from(e as Map)));
    } on SocketException {
      final Box cache = Hive.isBoxOpen('daily_progress_local')
          ? Hive.box('daily_progress_local')
          : await Hive.openBox('daily_progress_local');
      final List data = (cache.get('items') as List?) ?? const <dynamic>[];
      return List<Map<String, dynamic>>.from(
          data.map((e) => Map<String, dynamic>.from(e as Map)));
    }
  }

  Future<Map<String, dynamic>?> fetchDailyDay(int dayNumber) async {
    try {
      final row = await _client
          .from('daily_progress')
          .select(
              'id, user_id, day_number, date, task_text, completion_status, user_note, max_suggestion, created_at, updated_at')
          .eq('day_number', dayNumber)
          .maybeSingle();
      return row == null ? null : Map<String, dynamic>.from(row);
    } on PostgrestException {
      final Box cache = Hive.isBoxOpen('daily_progress_local')
          ? Hive.box('daily_progress_local')
          : await Hive.openBox('daily_progress_local');
      final List data = (cache.get('items') as List?) ?? const <dynamic>[];
      for (final e in data) {
        final m = Map<String, dynamic>.from(e as Map);
        if ((m['day_number'] as int?) == dayNumber) return m;
      }
      return null;
    } on SocketException {
      final Box cache = Hive.isBoxOpen('daily_progress_local')
          ? Hive.box('daily_progress_local')
          : await Hive.openBox('daily_progress_local');
      final List data = (cache.get('items') as List?) ?? const <dynamic>[];
      for (final e in data) {
        final m = Map<String, dynamic>.from(e as Map);
        if ((m['day_number'] as int?) == dayNumber) return m;
      }
      return null;
    }
  }

  Future<Map<String, dynamic>> upsertDailyProgress({
    required int dayNumber,
    String? taskText,
    String? status, // 'completed'|'partial'|'missed'|'pending'
    String? note,
    DateTime? date,
  }) async {
    final payload = <String, dynamic>{
      'day_number': dayNumber,
      if (taskText != null) 'task_text': taskText,
      if (status != null) 'completion_status': status,
      if (note != null) 'user_note': note,
      if (date != null) 'date': date.toUtc().toIso8601String(),
    };
    try {
      final upserted = await _client
          .from('daily_progress')
          .upsert(payload, onConflict: 'user_id,day_number')
          .select()
          .single();

      // 🆕 Проверяем серии и автоначисляем GP-бонусы (если день выполнен)
      if (status == 'completed' || status == 'partial') {
        try {
          await checkAndGrantStreakBonus();
        } catch (e) {
          // Игнорируем ошибки начисления бонусов - не критично
          debugPrint('Streak bonus check failed: $e');
        }
      }

      return Map<String, dynamic>.from(upserted);
    } on PostgrestException {
      // Локальный fallback: сохраняем в Hive и возвращаем сохранённое
      final Box cache = Hive.isBoxOpen('daily_progress_local')
          ? Hive.box('daily_progress_local')
          : await Hive.openBox('daily_progress_local');
      final List data = (cache.get('items') as List?)?.toList() ?? <dynamic>[];
      bool found = false;
      for (int i = 0; i < data.length; i++) {
        final m = Map<String, dynamic>.from(data[i] as Map);
        if ((m['day_number'] as int?) == dayNumber) {
          m.addAll(payload);
          data[i] = m;
          found = true;
          break;
        }
      }
      if (!found) data.add(payload);
      await cache.put('items', data);
      return Map<String, dynamic>.from(payload);
    } on SocketException {
      final Box cache = Hive.isBoxOpen('daily_progress_local')
          ? Hive.box('daily_progress_local')
          : await Hive.openBox('daily_progress_local');
      final List data = (cache.get('items') as List?)?.toList() ?? <dynamic>[];
      bool found = false;
      for (int i = 0; i < data.length; i++) {
        final m = Map<String, dynamic>.from(data[i] as Map);
        if ((m['day_number'] as int?) == dayNumber) {
          m.addAll(payload);
          data[i] = m;
          found = true;
          break;
        }
      }
      if (!found) data.add(payload);
      await cache.put('items', data);
      return Map<String, dynamic>.from(payload);
    }
  }

  /// Partial update of a single field in core_goals.version_data via RPC.
  /// Server ensures editing only latest version and merges JSONB atomically.
  Future<Map<String, dynamic>> upsertGoalField({
    required int version,
    required String field,
    required dynamic value,
  }) async {
    return _withRetry<Map<String, dynamic>>(() async {
      try {
        final result = await _client.rpc(
          'upsert_goal_field',
          params: {
            'p_version': version,
            'p_field': field,
            'p_value': value,
          },
        );
        if (result is Map<String, dynamic>) {
          return result;
        }
        return Map<String, dynamic>.from(result as Map);
      } on PostgrestException {
        // Fallback: если RPC отсутствует/недоступно — делаем client-side merge последней версии
        // 1) Находим последнюю запись версии для текущего пользователя
        final String? userId = _client.auth.currentUser?.id;
        if (userId == null) rethrow;
        final row = await _client
            .from('core_goals')
            .select('id, version, user_id, version_data')
            .eq('user_id', userId)
            .eq('version', version)
            .order('updated_at', ascending: false)
            .limit(1)
            .maybeSingle();

        Map<String, dynamic> vdata = <String, dynamic>{};
        String? goalId;
        if (row != null) {
          goalId = row['id'] as String?;
          final raw = row['version_data'];
          if (raw is Map) {
            vdata = Map<String, dynamic>.from(raw);
          }
        }

        // 2) Мержим поле и сохраняем
        vdata[field] = value;

        if (goalId != null) {
          final updated = await _client
              .from('core_goals')
              .update({'version_data': vdata})
              .eq('id', goalId)
              .select()
              .single();
          return Map<String, dynamic>.from(updated);
        } else {
          // Если записи нет — создаём новую оболочку версии
          final created = await _client
              .from('core_goals')
              .insert({
                'user_id': userId,
                'version': version,
                'goal_text': '',
                'version_data': vdata,
              })
              .select()
              .single();
          return Map<String, dynamic>.from(created);
        }
      }
    });
  }

  /// Собирает прогресс заполнения полей версии цели:
  /// - completedFields: список имён полей из goal_checkpoint_progress
  /// - versionData: текущий jsonb core_goals.version_data (если есть)
  Future<Map<String, dynamic>> fetchGoalProgress(int version) async {
    // Получаем version_data для указанной версии (если есть запись)
    Map<String, dynamic> versionRow = {};
    try {
      final String? userId = _client.auth.currentUser?.id;
      final data = await _client
          .from('core_goals')
          .select('version, version_data, user_id')
          .eq('version', version)
          .eq('user_id', userId as Object)
          .order('updated_at', ascending: false)
          .limit(1)
          .maybeSingle();
      if (data != null) {
        versionRow = Map<String, dynamic>.from(data);
      }
    } catch (_) {}

    // Поля прогресса из goal_checkpoint_progress (RLS owner-only)
    List<String> completed = <String>[];
    try {
      final String? userId = _client.auth.currentUser?.id;
      final rows = await _client
          .from('goal_checkpoint_progress')
          .select('field_name, user_id')
          .eq('version', version)
          .eq('user_id', userId as Object);
      // rows уже List по контракту PostgREST; лишняя проверка типа не нужна
      completed = (rows as List)
          .map((e) => (e as Map)['field_name'])
          .whereType<String>()
          .toList();
    } catch (_) {}

    return {
      'version': version,
      'versionData': (versionRow['version_data'] is Map)
          ? Map<String, dynamic>.from(versionRow['version_data'] as Map)
          : const <String, dynamic>{},
      'completedFields': completed,
    };
  }

  // ============================
  // Weekly Progress (weekly_progress)
  // ============================

  // New API
  Future<Map<String, dynamic>?> fetchWeek(int weekNumber) async {
    final Box cache = Hive.box('weekly_progress');
    final String cacheKey = 'week_$weekNumber';

    try {
      final data = await _client
          .from('weekly_progress')
          .select(
              'id, user_id, week_number, planned_actions, completed_actions, completion_status, metric_value, metric_progress_percent, max_feedback, chat_session_id, achievement, metric_actual, used_artifacts, consulted_leo, applied_techniques, key_insight, artifacts_details, consulted_benefit, techniques_details, created_at, updated_at')
          .eq('week_number', weekNumber)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (data != null) {
        await cache.put(cacheKey, data);
      }
      return data == null ? null : Map<String, dynamic>.from(data);
    } on SocketException {
      final cached = cache.get(cacheKey);
      return cached == null ? null : Map<String, dynamic>.from(cached);
    } catch (_) {
      final cached = cache.get(cacheKey);
      if (cached != null) {
        return Map<String, dynamic>.from(cached);
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> upsertWeek({
    required int weekNumber,
    Map<String, dynamic>? plannedActions,
    Map<String, dynamic>? completedActions,
    String? completionStatus, // 'full'|'partial'|'failed'
    num? metricValue,
    num? metricProgressPercent,
    String? maxFeedback,
    String? chatSessionId,
    String? achievement,
    String? metricActual,
    bool? usedArtifacts,
    bool? consultedLeo,
    bool? appliedTechniques,
    String? keyInsight,
    String? artifactsDetails,
    String? consultedBenefit,
    String? techniquesDetails,
  }) async {
    final payload = <String, dynamic>{
      'week_number': weekNumber,
      if (plannedActions != null) 'planned_actions': plannedActions,
      if (completedActions != null) 'completed_actions': completedActions,
      if (completionStatus != null) 'completion_status': completionStatus,
      if (metricValue != null) 'metric_value': metricValue,
      if (metricProgressPercent != null)
        'metric_progress_percent': metricProgressPercent,
      if (maxFeedback != null) 'max_feedback': maxFeedback,
      if (chatSessionId != null) 'chat_session_id': chatSessionId,
      if (achievement != null) 'achievement': achievement,
      if (metricActual != null) 'metric_actual': metricActual,
      if (usedArtifacts != null) 'used_artifacts': usedArtifacts,
      if (consultedLeo != null) 'consulted_leo': consultedLeo,
      if (appliedTechniques != null) 'applied_techniques': appliedTechniques,
      if (keyInsight != null) 'key_insight': keyInsight,
      if (artifactsDetails != null) 'artifacts_details': artifactsDetails,
      if (consultedBenefit != null) 'consulted_benefit': consultedBenefit,
      if (techniquesDetails != null) 'techniques_details': techniquesDetails,
    };

    return _withRetry<Map<String, dynamic>>(() async {
      final inserted = await _client
          .from('weekly_progress')
          .insert(payload)
          .select()
          .single();
      return Map<String, dynamic>.from(inserted);
    });
  }

  Future<Map<String, dynamic>> updateWeek({
    required String id,
    Map<String, dynamic>? plannedActions,
    Map<String, dynamic>? completedActions,
    String? completionStatus,
    num? metricValue,
    num? metricProgressPercent,
    String? maxFeedback,
    String? chatSessionId,
    String? achievement,
    String? metricActual,
    bool? usedArtifacts,
    bool? consultedLeo,
    bool? appliedTechniques,
    String? keyInsight,
    String? artifactsDetails,
    String? consultedBenefit,
    String? techniquesDetails,
  }) async {
    final payload = <String, dynamic>{
      if (plannedActions != null) 'planned_actions': plannedActions,
      if (completedActions != null) 'completed_actions': completedActions,
      if (completionStatus != null) 'completion_status': completionStatus,
      if (metricValue != null) 'metric_value': metricValue,
      if (metricProgressPercent != null)
        'metric_progress_percent': metricProgressPercent,
      if (maxFeedback != null) 'max_feedback': maxFeedback,
      if (chatSessionId != null) 'chat_session_id': chatSessionId,
      if (achievement != null) 'achievement': achievement,
      if (metricActual != null) 'metric_actual': metricActual,
      if (usedArtifacts != null) 'used_artifacts': usedArtifacts,
      if (consultedLeo != null) 'consulted_leo': consultedLeo,
      if (appliedTechniques != null) 'applied_techniques': appliedTechniques,
      if (keyInsight != null) 'key_insight': keyInsight,
      if (artifactsDetails != null) 'artifacts_details': artifactsDetails,
      if (consultedBenefit != null) 'consulted_benefit': consultedBenefit,
      if (techniquesDetails != null) 'techniques_details': techniquesDetails,
    };

    return _withRetry<Map<String, dynamic>>(() async {
      final updated = await _client
          .from('weekly_progress')
          .update(payload)
          .eq('id', id)
          .select()
          .single();
      return Map<String, dynamic>.from(updated);
    });
  }

  // Deprecated wrappers for backward compatibility
  @Deprecated('Use fetchWeek')
  Future<Map<String, dynamic>?> fetchSprint(int sprintNumber) =>
      fetchWeek(sprintNumber);

  @Deprecated('Use upsertWeek')
  Future<Map<String, dynamic>> upsertSprint({
    required int sprintNumber,
    String? achievement,
    String? metricActual,
    bool? usedArtifacts,
    bool? consultedLeo,
    bool? appliedTechniques,
    String? keyInsight,
    String? artifactsDetails,
    String? consultedBenefit,
    String? techniquesDetails,
  }) =>
      upsertWeek(
        weekNumber: sprintNumber,
        achievement: achievement,
        metricActual: metricActual,
        usedArtifacts: usedArtifacts,
        consultedLeo: consultedLeo,
        appliedTechniques: appliedTechniques,
        keyInsight: keyInsight,
        artifactsDetails: artifactsDetails,
        consultedBenefit: consultedBenefit,
        techniquesDetails: techniquesDetails,
      );

  // ============================
  // Reminders (reminder_checks)
  // ============================

  /// Рилтайм-поток напоминаний пользователя (через Supabase Realtime).
  Stream<List<Map<String, dynamic>>> streamReminderChecks(String userId) {
    return _client
        .from('reminder_checks')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('day_number', ascending: true)
        .map((rows) => rows.map((e) => Map<String, dynamic>.from(e)).toList());
  }

  Future<Map<String, dynamic>> upsertReminder({
    required int dayNumber,
    required bool isCompleted,
    String? reminderText,
  }) async {
    final payload = <String, dynamic>{
      'day_number': dayNumber,
      'is_completed': isCompleted,
      'completed_at':
          isCompleted ? DateTime.now().toUtc().toIso8601String() : null,
      if (reminderText != null) 'reminder_text': reminderText,
    };

    final upserted = await _client
        .from('reminder_checks')
        .upsert(payload, onConflict: 'user_id,day_number')
        .select()
        .single();
    return Map<String, dynamic>.from(upserted);
  }

  // ============================
  // Quotes (motivational_quotes)
  // ============================

  /// Возвращает случайную цитату из активных. Кэширует список активных.
  Future<Map<String, dynamic>?> getDailyQuote() async {
    final Box cache = Hive.box('quotes');
    const String cacheKey = 'active';

    List<Map<String, dynamic>> active;
    try {
      // Запрос и явное приведение к типу List<Map<String, dynamic>>
      final resp = await _client
          .from('motivational_quotes')
          .select('id, quote_text, author, category')
          .eq('is_active', true);
      final list = (resp as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
      active = list;
      await cache.put(cacheKey, list);
    } on SocketException {
      final cached = cache.get(cacheKey);
      if (cached == null) return null;
      active = List<Map<String, dynamic>>.from(
          (cached as List).map((e) => Map<String, dynamic>.from(e as Map)));
    } on PostgrestException {
      final cached = cache.get(cacheKey);
      if (cached == null) return null;
      active = List<Map<String, dynamic>>.from(
          (cached as List).map((e) => Map<String, dynamic>.from(e as Map)));
    } catch (_) {
      final cached = cache.get(cacheKey);
      // Не кидаем исключение: если кеш есть — используем, иначе вернём null ниже
      active = cached == null
          ? <Map<String, dynamic>>[]
          : List<Map<String, dynamic>>.from(
              (cached as List).map((e) => Map<String, dynamic>.from(e as Map)));
    }

    if (active.isEmpty) return null;
    // Детерминированный выбор по UTC-дню: стабильная «цитата дня» без перезапуска
    final int dayIndex =
        DateTime.now().toUtc().difference(DateTime.utc(1970)).inDays;
    final int pick = dayIndex % active.length;
    return active[pick];
  }
}

extension on GoalsRepository {
  Future<T> _withRetry<T>(Future<T> Function() op) async {
    final List<Duration> delays = <Duration>[
      const Duration(milliseconds: 300),
      const Duration(milliseconds: 1000),
      const Duration(milliseconds: 2500),
    ];
    int attempt = 0;
    while (true) {
      try {
        return await op();
      } on SocketException {
        if (attempt >= delays.length) rethrow;
      } on PostgrestException {
        if (attempt >= delays.length) rethrow;
      }
      await Future.delayed(delays[attempt]);
      attempt += 1;
    }
  }
}
