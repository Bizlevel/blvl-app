import 'dart:async';
import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bizlevel/services/gp_service.dart';
import 'package:bizlevel/services/supabase_service.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:bizlevel/models/goal_update.dart';

/// Репозиторий для работы с фичей «Цель»: версии цели, спринты, напоминания, цитаты.
///
/// Следует паттерну существующих репозиториев (SWR через Hive, graceful offline).
class GoalsRepository {
  final SupabaseClient _client;
  GoalsRepository(this._client);
  // Column sets
  static const String _userGoalColumns =
      'user_id, goal_text, metric_start, metric_current, metric_target, start_date, target_date, updated_at, financial_focus, action_plan_note, current_history_id';
  static const String _practiceLogColumns =
      'id, user_id, applied_at, applied_tools, note, created_at, updated_at, goal_history_id';
  // ---------- small helpers to reduce duplication ----------
  void _ensureAnonApikey() {
    try {
      Supabase.instance.client.rest.headers['apikey'] = SupabaseService.anonKey;
    } catch (_) {}
  }

  String _requireUserId() {
    final String? userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw const PostgrestException(message: 'Not authorized', code: '401');
    }
    return userId;
  }

  Future<Box> _getBox(String name) async {
    return Hive.isBoxOpen(name) ? Hive.box(name) : await Hive.openBox(name);
  }

  // ============================
  // Generic кеширование (DRY)
  // ============================

  /// Generic метод для кеширования с offline-fallback
  /// Устраняет дублирование паттерна try-cache-fallback в 6+ методах
  Future<T?> _cachedQuery<T>({
    required Box cache,
    required String cacheKey,
    required Future<T?> Function() query,
    required T Function(dynamic) fromCache,
  }) async {
    try {
      final data = await query();
      if (data != null) {
        await cache.put(cacheKey, data);
      }
      return data;
    } on SocketException {
      final cached = cache.get(cacheKey);
      return cached == null ? null : fromCache(cached);
    } catch (_) {
      final cached = cache.get(cacheKey);
      if (cached != null) return fromCache(cached);
      rethrow;
    }
  }

  // ============================
  // New flat Goal (user_goal)
  // ============================

  Future<Map<String, dynamic>?> fetchUserGoal() async {
    final String? userId = _client.auth.currentUser?.id;
    if (userId == null) return null;
    final Box cache = await _getBox('user_goal');
    const String cacheKey = 'self';

    return _cachedQuery<Map<String, dynamic>>(
      cache: cache,
      cacheKey: cacheKey,
      query: () {
        _ensureAnonApikey();
        return _client
            .from('user_goal')
            .select(_userGoalColumns)
            .eq('user_id', userId)
            .limit(1)
            .maybeSingle();
      },
      fromCache: (cached) => Map<String, dynamic>.from(cached),
    );
  }

  Future<Map<String, dynamic>> upsertUserGoalRequest(
      GoalUpsertRequest r) async {
    _ensureAnonApikey();
    final Map<String, dynamic> payload = _buildUserGoalPayloadFrom(r);

    Map<String, dynamic> row = await _client
        .from('user_goal')
        .upsert(payload, onConflict: 'user_id')
        .select()
        .single();

    // Ensure goal history exists and is activated
    try {
      // If no pointer or goal changed — create new history row
      final String? currentHistoryId = (row['current_history_id'] as String?);
      final bool noPointer =
          currentHistoryId == null || currentHistoryId.isEmpty;
      final bool goalChanged =
          ((row['goal_text'] ?? '') as String).trim().isNotEmpty;
      if (noPointer && goalChanged) {
        final Map<String, dynamic> hist = {
          'user_id': r.userId,
          'goal_text': (row['goal_text'] ?? '').toString(),
          if (row['metric_start'] != null) 'metric_start': row['metric_start'],
          if (row['metric_current'] != null)
            'metric_current': row['metric_current'],
          if (row['metric_target'] != null)
            'metric_target': row['metric_target'],
          if (row['start_date'] != null) 'start_date': row['start_date'],
          if (row['target_date'] != null) 'target_date': row['target_date'],
          'status': 'active',
        };
        final Map<String, dynamic> inserted = await _client
            .from('user_goal_history')
            .insert(hist)
            .select('id')
            .single();
        final String newId = inserted['id'] as String;
        // pointer
        row = await _client
            .from('user_goal')
            .update({'current_history_id': newId})
            .eq('user_id', r.userId)
            .select()
            .single();
      }
    } catch (_) {}

    // refresh cache
    try {
      final Box cache = Hive.box('user_goal');
      await cache.put('self', row);
    } catch (_) {}

    return Map<String, dynamic>.from(row);
  }

  /// Начать новую цель: закрыть текущую историю, создать новую; задать стартовые метрики при наличии.
  Future<Map<String, dynamic>> startNewGoalRequest(
      StartNewGoalRequest r) async {
    _ensureAnonApikey();
    // 1) закрыть текущую history (best-effort)
    try {
      final Map<String, dynamic>? ug = await _client
          .from('user_goal')
          .select('current_history_id')
          .eq('user_id', r.userId)
          .maybeSingle();
      final String? hid = ug?['current_history_id'] as String?;
      if (hid != null && hid.isNotEmpty) {
        await _client
            .from('user_goal_history')
            .update({
              'status': 'completed',
              'closed_at': DateTime.now().toUtc().toIso8601String()
            })
            .eq('id', hid)
            .eq('user_id', r.userId);
      }
    } catch (_) {}
    // 2) создать новую history (active)
    final Map<String, dynamic> histPayload = {
      'user_id': r.userId,
      'goal_text': r.goalText,
      if (r.metricStart != null) 'metric_start': r.metricStart,
      if (r.metricCurrent != null) 'metric_current': r.metricCurrent,
      if (r.metricTarget != null) 'metric_target': r.metricTarget,
      if (r.targetDate != null)
        'target_date': r.targetDate!.toUtc().toIso8601String(),
      'status': 'active',
    };
    final Map<String, dynamic> insertedHist = await _client
        .from('user_goal_history')
        .insert(histPayload)
        .select('id')
        .single();
    final String newHistoryId = insertedHist['id'] as String;
    // 3) обновить user_goal: текст/дедлайн, стартовые метрики (если переданы), привязать pointer
    final Map<String, dynamic> row = await _client
        .from('user_goal')
        .upsert({
          'user_id': r.userId,
          'goal_text': r.goalText,
          'metric_type': null,
          'metric_start': r.metricStart,
          'metric_current': r.metricCurrent,
          'metric_target': r.metricTarget,
          if (r.targetDate != null)
            'target_date': r.targetDate!.toUtc().toIso8601String(),
          'current_history_id': newHistoryId,
        }, onConflict: 'user_id')
        .select()
        .single();
    // refresh cache
    try {
      final Box cache = Hive.box('user_goal');
      await cache.put('self', row);
    } catch (_) {}
    return Map<String, dynamic>.from(row);
  }

  Map<String, dynamic> _buildUserGoalPayloadFrom(GoalUpsertRequest r) {
    return <String, dynamic>{
      'user_id': r.userId,
      'goal_text': r.goalText,
      if (r.metricType != null) 'metric_type': r.metricType,
      if (r.metricStart != null) 'metric_start': r.metricStart,
      if (r.metricCurrent != null) 'metric_current': r.metricCurrent,
      if (r.metricTarget != null) 'metric_target': r.metricTarget,
      if (r.startDate != null)
        'start_date': r.startDate!.toUtc().toIso8601String(),
      if (r.targetDate != null)
        'target_date': r.targetDate!.toUtc().toIso8601String(),
      if (r.financialFocus != null) 'financial_focus': r.financialFocus,
      if (r.actionPlanNote != null) 'action_plan_note': r.actionPlanNote,
    };
  }

  // reserved for future refactor: GoalUpdate DTO usage (kept minimal to avoid API breaks)

  // ============================
  // Practice log (was daily_progress)
  // ============================

  @Deprecated(
      'Use fetchPracticeLogForHistory to avoid mixing old and new goals')
  Future<List<Map<String, dynamic>>> fetchPracticeLog({int limit = 20}) async {
    final String? userId = _client.auth.currentUser?.id;
    if (userId == null) return <Map<String, dynamic>>[];
    final Box cache = await _getBox('practice_log');
    final String cacheKey = 'list_$limit';

    final result = await _cachedQuery<List>(
      cache: cache,
      cacheKey: cacheKey,
      query: () async => _fetchPracticeRows(userId: userId, limit: limit),
      fromCache: (cached) => List.from(cached),
    );

    return result == null
        ? <Map<String, dynamic>>[]
        : List<Map<String, dynamic>>.from(
            result.map((e) => Map<String, dynamic>.from(e)));
  }

  Future<List<Map<String, dynamic>>> fetchPracticeLogForHistory({
    required String? historyId,
    int limit = 100,
  }) async {
    final String? userId = _client.auth.currentUser?.id;
    if (userId == null) return <Map<String, dynamic>>[];
    _ensureAnonApikey();
    final dynamic base = _client
        .from('practice_log')
        .select(_practiceLogColumns)
        .eq('user_id', userId)
        .order('applied_at', ascending: false)
        .limit(limit);
    // Для текущей цели показываем как "новые" записи (привязанные к истории),
    // так и legacy-записи, сделанные до появления goal_history_id.
    final List rows = await ((historyId != null && historyId.isNotEmpty)
        ? base.or('goal_history_id.eq.$historyId,goal_history_id.is.null')
        : base);
    return List<Map<String, dynamic>>.from(
        rows.map((e) => Map<String, dynamic>.from(e as Map)));
  }

  Future<void> updateMetricCurrent(num value) async {
    final String userId = _requireUserId();
    _ensureAnonApikey();
    // 1) Обновляем активную историю, если есть указатель
    String? currentHistoryId;
    try {
      final ug = await _client
          .from('user_goal')
          .select('current_history_id')
          .eq('user_id', userId)
          .maybeSingle();
      currentHistoryId = (ug?['current_history_id'] as String?);
    } catch (_) {}
    if (currentHistoryId != null && currentHistoryId.isNotEmpty) {
      await _client
          .from('user_goal_history')
          .update({'metric_current': value}).eq('id', currentHistoryId);
    }
    // 2) Обновляем основную запись user_goal
    final updated = await _client
        .from('user_goal')
        .update({
          'metric_current': value,
          'updated_at': DateTime.now().toUtc().toIso8601String()
        })
        .eq('user_id', userId)
        .select()
        .maybeSingle();
    // 3) Обновляем кеш, если получилось получить запись
    try {
      if (updated != null) {
        final Box cache = Hive.box('user_goal');
        await cache.put('self', updated);
      }
    } catch (_) {}
  }

  Future<List> _fetchPracticeRows(
      {required String userId, required int limit}) async {
    _ensureAnonApikey();
    return await _client
        .from('practice_log')
        .select(_practiceLogColumns)
        .eq('user_id', userId)
        .order('applied_at', ascending: false)
        .limit(limit);
  }

  Future<Map<String, dynamic>> addPracticeEntry({
    List<String> appliedTools = const <String>[],
    String? note,
    DateTime? appliedAt,
  }) async {
    final String userId = _requireUserId();
    // Try attach current history pointer
    String? historyId;
    try {
      final Map<String, dynamic>? ug = await _client
          .from('user_goal')
          .select('current_history_id')
          .eq('user_id', userId)
          .maybeSingle();
      final String? cid = ug?['current_history_id'] as String?;
      if (cid != null && cid.isNotEmpty) historyId = cid;
    } catch (_) {}
    final Map<String, dynamic> payload = <String, dynamic>{
      'user_id': userId,
      'applied_tools': appliedTools,
      if (note != null) 'note': note,
      if (appliedAt != null) 'applied_at': appliedAt.toUtc().toIso8601String(),
      if (historyId != null) 'goal_history_id': historyId,
    };

    _ensureAnonApikey();
    final inserted =
        await _client.from('practice_log').insert(payload).select().single();

    try {
      Sentry.addBreadcrumb(Breadcrumb(
        category: 'practice',
        level: SentryLevel.info,
        message: 'practice_entry_saved',
        data: {
          'tools_count': (appliedTools).length,
          if (appliedAt != null) 'applied_at': appliedAt.toIso8601String(),
        },
      ));
    } catch (_) {}

    // Бонус/обновление GP — best-effort, не должен блокировать UX сохранения записи.
    unawaited(_claimDailyBonusAndRefresh());

    // Invalidate/refresh cache roughly
    try {
      final Box cache = Hive.box('practice_log');
      await cache.delete('list_20');
    } catch (_) {}

    return Map<String, dynamic>.from(inserted);
  }

  Future<void> logPracticeAndUpdateMetricTx({
    List<String> appliedTools = const <String>[],
    String? note,
    DateTime? appliedAt,
    num? metricCurrent,
  }) async {
    _ensureAnonApikey();
    final params = <String, dynamic>{
      'p_applied_tools': appliedTools,
      if (note != null) 'p_note': note,
      if (appliedAt != null)
        'p_applied_at': appliedAt.toUtc().toIso8601String(),
      if (metricCurrent != null) 'p_metric_current': metricCurrent,
    };
    await _client.rpc('log_practice_and_update_metric', params: params);
    try {
      // Бонус/обновление GP — best-effort, не должен блокировать UX сохранения записи.
      unawaited(_claimDailyBonusAndRefresh());
      final Box cache = Hive.box('practice_log');
      await cache.delete('list_20');
    } catch (_) {}
  }

  Future<void> _claimDailyBonusAndRefresh() async {
    // Best-effort: claim daily bonus (idempotent server-side)
    try {
      await _client.rpc('gp_claim_daily_application');
      try {
        final gp = GpService(Supabase.instance.client);
        final fresh = await gp.getBalance();
        await GpService.saveBalanceCache(fresh);
      } catch (_) {}
    } catch (_) {}
  }

  Map<String, dynamic> aggregatePracticeLog(List<Map<String, dynamic>> items) {
    // daysApplied = количество уникальных дат с записями
    final Set<String> dates = <String>{};
    final Map<String, int> toolCount = <String, int>{};
    int total = 0;
    for (final m in items) {
      total++;
      final String tsStr = (m['applied_at'] ?? '').toString();
      if (tsStr.isNotEmpty) {
        // Считаем уникальные дни, а не уникальные отметки времени
        final DateTime? ts = DateTime.tryParse(tsStr);
        final String dayKey = ts == null
            ? tsStr.substring(0, tsStr.length.clamp(0, 10))
            : '${ts.year.toString().padLeft(4, '0')}-${ts.month.toString().padLeft(2, '0')}-${ts.day.toString().padLeft(2, '0')}';
        dates.add(dayKey);
      }
      final List tools = (m['applied_tools'] as List?) ?? const <dynamic>[];
      for (final t in tools) {
        final String label = t.toString();
        toolCount[label] = (toolCount[label] ?? 0) + 1;
      }
    }
    // top tools (up to 5)
    final List<MapEntry<String, int>> sorted = toolCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final List<Map<String, dynamic>> top = sorted
        .take(5)
        .map((e) => <String, dynamic>{'label': e.key, 'count': e.value})
        .toList();
    return <String, dynamic>{
      'totalApplied': total,
      'daysApplied': dates.length,
      'topTools': top,
    };
  }

  /// Вычисляет текущий темп применений Z за окно windowDays.
  /// Z = количество применений за окно / windowDays.
  double computeRecentPace(
    List<Map<String, dynamic>> items, {
    int windowDays = 14,
    DateTime? now,
  }) {
    final DateTime pivot = (now ?? DateTime.now());
    final DateTime from = pivot.subtract(Duration(days: windowDays));
    int recent = 0;
    for (final m in items) {
      final ts = DateTime.tryParse((m['applied_at'] ?? '').toString());
      if (ts != null && ts.isAfter(from)) recent++;
    }
    return recent / windowDays;
  }

  /// Вычисляет требуемый темп W до дедлайна цели.
  /// W = max(0, (target-current)) / daysLeft; если дедлайн отсутствует или прошёл — 0.
  double computeRequiredPace(
    Map<String, dynamic>? goal, {
    DateTime? now,
  }) {
    if (goal == null) return 0;
    final DateTime pivot = (now ?? DateTime.now());
    final double cur = (goal['metric_current'] as num?)?.toDouble() ?? 0;
    final double tgt = (goal['metric_target'] as num?)?.toDouble() ?? 0;
    final String tdStr = (goal['target_date'] ?? '').toString();
    final DateTime? td = DateTime.tryParse(tdStr)?.toLocal();
    final int daysLeft = td == null ? 0 : td.difference(pivot).inDays;
    if (daysLeft <= 0) return 0;
    final double remain = (tgt - cur);
    return remain <= 0 ? 0 : remain / daysLeft;
  }

  /// Возвращает прогресс к цели (0..1) с безопасными гвардами.
  /// null — если невозможно посчитать (нет чисел или target == start).
  double? computeGoalProgressPercent(Map<String, dynamic>? goal) {
    if (goal == null) return null;
    final num? startRaw = goal['metric_start'] as num?;
    final num? currentRaw = goal['metric_current'] as num?;
    final num? targetRaw = goal['metric_target'] as num?;
    if (startRaw == null || currentRaw == null || targetRaw == null) {
      return null;
    }
    final double start = startRaw.toDouble();
    final double current = currentRaw.toDouble();
    final double target = targetRaw.toDouble();
    final double denom = (target - start);
    if (denom.abs() < 1e-9) {
      return null;
    }
    final double value = (current - start) / denom;
    // clamp 0..1 на клиенте для чистоты UI
    if (value.isNaN) {
      return null;
    }
    return value.clamp(0.0, 1.0);
  }

  // ===== Legacy core_goals/weekly/daily APIs удалены окончательно =====

  // Удалено: fetchGoalProgress/goal_checkpoint_progress — legacy таблицы отсутствуют

  // Удалено: weekly_progress API (fetchWeek/upsertWeek/updateWeek) и обёртки sprint — legacy

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

  /// Возвращает «цитату дня» из активных.
  ///
  /// ВАЖНО: не используем Hive для цитат.
  /// Исторически `Hive.openBox(...)` на iOS мог быть дорогим и провоцировать фризы на старте
  /// (см. docs/ios-debug-nov-dec.md). Цитат немного (≈50), поэтому держим простой запрос в Supabase.
  Future<Map<String, dynamic>?> getDailyQuote() async {
    try {
      _ensureAnonApikey();
    } catch (_) {}

    try {
      final resp = await _client
          .from('motivational_quotes')
          .select('id, quote_text, author, category')
          .eq('is_active', true);

      final active = (resp as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
      if (active.isEmpty) return null;

      // Детерминированный выбор по UTC-дню: стабильная «цитата дня» без перезапуска
      final int dayIndex =
          DateTime.now().toUtc().difference(DateTime.utc(1970)).inDays;
      final int pick = dayIndex % active.length;
      return active[pick];
    } catch (error, stackTrace) {
      // UI сам решает как отображать отсутствие цитаты.
      try {
        await Sentry.captureException(error, stackTrace: stackTrace);
      } catch (_) {}
      return null;
    }
  }

  // buildMaxContext (v1–v4) удалён как legacy — используем buildMaxUserContext helper на клиенте
}
