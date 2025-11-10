import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bizlevel/services/gp_service.dart';
import 'package:bizlevel/services/supabase_service.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Репозиторий для работы с фичей «Цель»: версии цели, спринты, напоминания, цитаты.
///
/// Следует паттерну существующих репозиториев (SWR через Hive, graceful offline).
class GoalsRepository {
  final SupabaseClient _client;
  GoalsRepository(this._client);
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
            .select(
                'user_id, goal_text, metric_type, metric_start, metric_current, metric_target, start_date, target_date, updated_at, financial_focus, action_plan_note')
            .eq('user_id', userId)
            .limit(1)
            .maybeSingle();
      },
      fromCache: (cached) => Map<String, dynamic>.from(cached),
    );
  }

  Future<Map<String, dynamic>> upsertUserGoal({
    required String goalText,
    String? metricType,
    num? metricStart,
    num? metricCurrent,
    num? metricTarget,
    DateTime? startDate,
    DateTime? targetDate,
    String? financialFocus,
    String? actionPlanNote,
  }) async {
    final String userId = _requireUserId();
    _ensureAnonApikey();
    final Map<String, dynamic> payload = _buildUserGoalPayload(
      userId: userId,
      goalText: goalText,
      metricType: metricType,
      metricStart: metricStart,
      metricCurrent: metricCurrent,
      metricTarget: metricTarget,
      startDate: startDate,
      targetDate: targetDate,
      financialFocus: financialFocus,
      actionPlanNote: actionPlanNote,
    );

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
          'user_id': userId,
          'goal_text': (row['goal_text'] ?? '').toString(),
          if (row['metric_type'] != null) 'metric_type': row['metric_type'],
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
            .eq('user_id', userId)
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

  /// Начать новую цель: закрыть текущую историю, создать новую, обнулить метрики.
  Future<Map<String, dynamic>> startNewGoal({
    required String goalText,
    DateTime? targetDate,
  }) async {
    final String userId = _requireUserId();
    _ensureAnonApikey();
    // 1) закрыть текущую history (best-effort)
    try {
      final Map<String, dynamic>? ug = await _client
          .from('user_goal')
          .select('current_history_id')
          .eq('user_id', userId)
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
            .eq('user_id', userId);
      }
    } catch (_) {}
    // 2) создать новую history (active)
    final Map<String, dynamic> histPayload = {
      'user_id': userId,
      'goal_text': goalText,
      if (targetDate != null)
        'target_date': targetDate.toUtc().toIso8601String(),
      'status': 'active',
    };
    final Map<String, dynamic> insertedHist = await _client
        .from('user_goal_history')
        .insert(histPayload)
        .select('id')
        .single();
    final String newHistoryId = insertedHist['id'] as String;
    // 3) обновить user_goal: текст/дедлайн, очистить метрики, привязать pointer
    Map<String, dynamic> row = await _client
        .from('user_goal')
        .upsert({
          'user_id': userId,
          'goal_text': goalText,
          'metric_type': null,
          'metric_start': null,
          'metric_current': null,
          'metric_target': null,
          if (targetDate != null)
            'target_date': targetDate.toUtc().toIso8601String(),
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

  Map<String, dynamic> _buildUserGoalPayload({
    required String userId,
    required String goalText,
    String? metricType,
    num? metricStart,
    num? metricCurrent,
    num? metricTarget,
    DateTime? startDate,
    DateTime? targetDate,
    String? financialFocus,
    String? actionPlanNote,
  }) {
    return <String, dynamic>{
      'user_id': userId,
      'goal_text': goalText,
      if (metricType != null) 'metric_type': metricType,
      if (metricStart != null) 'metric_start': metricStart,
      if (metricCurrent != null) 'metric_current': metricCurrent,
      if (metricTarget != null) 'metric_target': metricTarget,
      if (startDate != null) 'start_date': startDate.toUtc().toIso8601String(),
      if (targetDate != null)
        'target_date': targetDate.toUtc().toIso8601String(),
      if (financialFocus != null) 'financial_focus': financialFocus,
      if (actionPlanNote != null) 'action_plan_note': actionPlanNote,
    };
  }

  // ============================
  // Practice log (was daily_progress)
  // ============================

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
        .select(
            'id, user_id, applied_at, applied_tools, note, created_at, updated_at')
        .eq('user_id', userId)
        .order('applied_at', ascending: false)
        .limit(limit);
    final List rows = await ((historyId != null && historyId.isNotEmpty)
        ? base.eq('goal_history_id', historyId)
        : base);
    return List<Map<String, dynamic>>.from(
        rows.map((e) => Map<String, dynamic>.from(e as Map)));
  }

  Future<List> _fetchPracticeRows(
      {required String userId, required int limit}) async {
    _ensureAnonApikey();
    return await _client
        .from('practice_log')
        .select(
            'id, user_id, applied_at, applied_tools, note, created_at, updated_at')
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

    await _claimDailyBonusAndRefresh();

    // Invalidate/refresh cache roughly
    try {
      final Box cache = Hive.box('practice_log');
      await cache.delete('list_20');
    } catch (_) {}

    return Map<String, dynamic>.from(inserted);
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

  /// Возвращает случайную цитату из активных. Кэширует список активных.
  Future<Map<String, dynamic>?> getDailyQuote() async {
    final Box cache = Hive.box('quotes');
    const String cacheKey = 'active';

    final result = await _cachedQuery<List>(
      cache: cache,
      cacheKey: cacheKey,
      query: () async {
        final resp = await _client
            .from('motivational_quotes')
            .select('id, quote_text, author, category')
            .eq('is_active', true);
        return (resp as List)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      },
      fromCache: (cached) => List<Map<String, dynamic>>.from(
          (cached as List).map((e) => Map<String, dynamic>.from(e as Map))),
    );

    final active = result ?? <Map<String, dynamic>>[];
    if (active.isEmpty) return null;

    // Детерминированный выбор по UTC-дню: стабильная «цитата дня» без перезапуска
    final int dayIndex =
        DateTime.now().toUtc().difference(DateTime.utc(1970)).inDays;
    final int pick = dayIndex % active.length;
    return active[pick];
  }

  /// Формирует контекст для Макса на основе данных версии цели
  ///
  /// Использование:
  /// ```dart
  /// final context = await goalsRepo.buildMaxContext(
  ///   version: 2,
  ///   versionData: {'concrete_result': 'Увеличить выручку...', ...}
  /// );
  /// ```
  String buildMaxContext({
    required int version,
    required Map<String, dynamic> versionData,
  }) {
    final sb = StringBuffer('goal_version: $version\n');

    if (version == 1) {
      // v1: Семя цели
      sb.writeln('concrete_result: ${versionData['concrete_result'] ?? ''}');
      sb.writeln('main_pain: ${versionData['main_pain'] ?? ''}');
      sb.writeln('first_action: ${versionData['first_action'] ?? ''}');
    } else if (version == 2) {
      // v2: Метрики
      sb.writeln('concrete_result: ${versionData['concrete_result'] ?? ''}');
      sb.writeln('metric_type: ${versionData['metric_type'] ?? ''}');
      sb.writeln('metric_current: ${versionData['metric_current'] ?? ''}');
      sb.writeln('metric_target: ${versionData['metric_target'] ?? ''}');
      sb.writeln('financial_goal: ${versionData['financial_goal'] ?? ''}');
    } else if (version == 3) {
      // v3: План на 4 недели
      sb.writeln('goal_smart: ${versionData['goal_smart'] ?? ''}');
      sb.writeln('week1_focus: ${versionData['week1_focus'] ?? ''}');
      sb.writeln('week2_focus: ${versionData['week2_focus'] ?? ''}');
      sb.writeln('week3_focus: ${versionData['week3_focus'] ?? ''}');
      sb.writeln('week4_focus: ${versionData['week4_focus'] ?? ''}');
    } else if (version == 4) {
      // v4: Готовность к старту
      sb.writeln('first_three_days: ${versionData['first_three_days'] ?? ''}');
      sb.writeln('start_date: ${versionData['start_date'] ?? ''}');
      sb.writeln(
          'accountability_person: ${versionData['accountability_person'] ?? ''}');
      sb.writeln('readiness_score: ${versionData['readiness_score'] ?? 5}');
    }

    return sb.toString();
  }
}
