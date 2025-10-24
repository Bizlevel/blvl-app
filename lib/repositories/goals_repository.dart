import 'dart:io';

import 'package:flutter/foundation.dart';
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
      throw const PostgrestException(
          message: 'Not authorized', code: '401');
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

    final Map<String, dynamic> row = await _client
        .from('user_goal')
        .upsert(payload, onConflict: 'user_id')
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
    final Map<String, dynamic> payload = <String, dynamic>{
      'user_id': userId,
      'applied_tools': appliedTools,
      if (note != null) 'note': note,
      if (appliedAt != null) 'applied_at': appliedAt.toUtc().toIso8601String(),
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

  // ===== Legacy core_goals/weekly/daily APIs удалены в новой концепции =====

  // streak-бонусы удалены по новой концепции

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

  /// Заполняет daily_progress.task_text из week*_focus версии v3
  /// Не перезаписывает существующие task_text.
  Future<void> backfillDailyTasksFromV3() async {
    try {
      final String? userId = _client.auth.currentUser?.id;
      if (userId == null) return;

      // 1) Получаем v3.version_data
      final Map<String, dynamic>? v3row = await _client
          .from('core_goals')
          .select('version, version_data')
          .eq('user_id', userId)
          .eq('version', 3)
          .order('updated_at', ascending: false)
          .limit(1)
          .maybeSingle();
      final Map<String, dynamic> v3data = (v3row?['version_data'] is Map)
          ? Map<String, dynamic>.from(v3row!['version_data'] as Map)
          : const <String, dynamic>{};

      if (v3data.isEmpty) return;

      // 2) Получаем уже созданные daily_progress
      final existing = await fetchDailyProgress();
      final Map<int, String> hasTask = <int, String>{};
      for (final m in existing) {
        final int? d = m['day_number'] as int?;
        if (d != null) {
          hasTask[d] = (m['task_text'] ?? '').toString();
        }
      }

      // 3) Для 1..28 устанавливаем task_text из соответствующего weekN_focus, если пусто
      for (int day = 1; day <= 28; day++) {
        final bool empty = (hasTask[day] ?? '').trim().isEmpty;
        if (!empty) continue;
        final int week = ((day - 1) ~/ 7) + 1;
        final String key = 'week${week}_focus';
        final String text = (v3data[key] ?? '').toString().trim();
        if (text.isEmpty) continue;
        // Обновляем только task_text
        await upsertDailyProgress(dayNumber: day, taskText: text);
      }
    } catch (e) {
      // swallow — не критично для UX
      debugPrint('backfillDailyTasksFromV3 error: $e');
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
    final payload = _buildDailyProgressPayload(
      dayNumber: dayNumber,
      taskText: taskText,
      status: status,
      note: note,
      date: date,
    );

    try {
      final result = await _upsertDailyProgressRemote(payload);
      await _checkStreakBonusIfCompleted(status);
      return result;
    } catch (e) {
      return await _upsertDailyProgressLocal(payload, dayNumber);
    }
  }

  /// Строит payload для daily_progress
  Map<String, dynamic> _buildDailyProgressPayload({
    required int dayNumber,
    String? taskText,
    String? status,
    String? note,
    DateTime? date,
  }) {
    return <String, dynamic>{
      'day_number': dayNumber,
      if (taskText != null) 'task_text': taskText,
      if (status != null) 'completion_status': status,
      if (note != null) 'user_note': note,
      if (date != null) 'date': date.toUtc().toIso8601String(),
    };
  }

  /// Remote upsert в daily_progress
  Future<Map<String, dynamic>> _upsertDailyProgressRemote(
    Map<String, dynamic> payload,
  ) async {
    final upserted = await _client
        .from('daily_progress')
        .upsert(payload, onConflict: 'user_id,day_number')
        .select()
        .single();
    return Map<String, dynamic>.from(upserted);
  }

  /// Проверяет и начисляет GP-бонусы за серии выполненных дней
  Future<void> _checkStreakBonusIfCompleted(String? status) async {
    if (status == 'completed' || status == 'partial') {
      // streak-бонусы удалены
    }
  }

  /// Fallback: сохранение в локальный Hive при отсутствии сети
  Future<Map<String, dynamic>> _upsertDailyProgressLocal(
    Map<String, dynamic> payload,
    int dayNumber,
  ) async {
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
