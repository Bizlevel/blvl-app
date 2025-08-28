import 'dart:io';

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

  /// Создать новую версию цели (insert новой записи). user_id проставится триггером.
  Future<Map<String, dynamic>> upsertGoalVersion({
    required int version,
    required String goalText,
    required Map<String, dynamic> versionData,
  }) async {
    final payload = {
      'version': version,
      'goal_text': goalText,
      'version_data': versionData,
    };

    final inserted =
        await _client.from('core_goals').insert(payload).select().single();
    return Map<String, dynamic>.from(inserted);
  }

  /// Обновляет текущую (последнюю) версию v1 по id записи.
  Future<Map<String, dynamic>> updateGoalById({
    required String id,
    required String goalText,
    required Map<String, dynamic> versionData,
  }) async {
    final updated = await _client
        .from('core_goals')
        .update({
          'goal_text': goalText,
          'version_data': versionData,
        })
        .eq('id', id)
        .select()
        .single();
    return Map<String, dynamic>.from(updated);
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

    final inserted =
        await _client.from('weekly_progress').insert(payload).select().single();
    return Map<String, dynamic>.from(inserted);
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

    final updated = await _client
        .from('weekly_progress')
        .update(payload)
        .eq('id', id)
        .select()
        .single();
    return Map<String, dynamic>.from(updated);
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
