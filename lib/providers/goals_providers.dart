import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_provider.dart';
import 'goals_repository_provider.dart';
import 'levels_provider.dart';

// Удалены провайдеры legacy версий/weekly

// Поток напоминаний
final remindersStreamProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) async* {
  final client = ref.watch(supabaseClientProvider);
  final User? user = client.auth.currentUser;
  if (user == null) {
    yield <Map<String, dynamic>>[];
    return;
  }
  final repo = ref.read(goalsRepositoryProvider);
  yield* repo.streamReminderChecks(user.id);
});

// Цитата дня
// Чтобы цитата реально менялась раз в сутки без перезапуска приложения,
// добавляем зависимость от «индекса текущего дня», который эмитится раз в час.
final _todayIndexProvider = StreamProvider<int>((ref) async* {
  int last = _dayIndex();
  yield last;
  // Пуллим раз в час: при смене календарного дня значение изменится
  while (true) {
    await Future.delayed(const Duration(hours: 1));
    final nowIdx = _dayIndex();
    if (nowIdx != last) {
      last = nowIdx;
      yield nowIdx;
    }
  }
});

int _dayIndex() => DateTime.now().toUtc().difference(DateTime.utc(1970)).inDays;

final dailyQuoteProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  // Подписка нужна только для инвалидации провайдера при смене дня
  ref.watch(_todayIndexProvider);
  final repo = ref.read(goalsRepositoryProvider);
  return repo.getDailyQuote();
});

/// Проверяет наличие версии цели у текущего пользователя
// Удалён

/// Прогресс активного чекпоинта (version): собранные поля и текущие данные версии
// Удалён

/// Динамический label метрики из v2 для чек-ина недели
// Удалён

/// Список опций «инструментов недели» для чек-ина (SWR через уровни)
final usedToolsOptionsProvider = FutureProvider<List<String>>((ref) async {
  // Берём только артефакты как названия навыков из levels.artifact_title
  final levels = await ref.watch(levelsProvider.future);
  final List<String> tools = <String>[];
  for (final lv in levels) {
    final String art = (lv['artifact_title'] ?? '') as String? ?? '';
    if (art.isNotEmpty) tools.add(art);
  }
  if (tools.isEmpty) {
    return const <String>[
      'Матрица Эйзенхауэра',
      'Финансовый учёт',
      'УТП',
      'SMART‑планирование',
    ];
  }
  final seen = <String>{};
  final deduped = <String>[];
  for (final t in tools) {
    final s = t.trim();
    if (s.isEmpty) continue;
    if (seen.add(s)) deduped.add(s);
  }
  return deduped.take(64).toList();
});

// Удалён блок 28‑дневного режима

// ============================
// Новая единая цель (user_goal)
// ============================

final userGoalProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final repo = ref.read(goalsRepositoryProvider);
  return repo.fetchUserGoal();
});

// ============================
// Журнал применений (practice_log)
// ============================

/// Список последних записей журнала применений (дефолт 20)
final practiceLogProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.read(goalsRepositoryProvider);
  return repo.fetchPracticeLog(limit: 20);
});

/// Список journal с параметром лимита
final practiceLogWithLimitProvider =
    FutureProvider.family<List<Map<String, dynamic>>, int>((ref, limit) async {
  final repo = ref.read(goalsRepositoryProvider);
  return repo.fetchPracticeLog(limit: limit);
});

/// Агрегаты журнала: дни с применениями, топ‑инструменты
final practiceLogAggregatesProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final repo = ref.read(goalsRepositoryProvider);
  final items = await ref.watch(practiceLogProvider.future);
  return repo.aggregatePracticeLog(items);
});

// ============================
// Состояние цели (флаги L1/L4/L7)
// ============================

final goalStateProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final goal = await ref.watch(userGoalProvider.future);
  final bool l1Done =
      goal != null && (goal['goal_text'] ?? '').toString().trim().isNotEmpty;

  final bool l4Done = goal != null &&
      (goal['financial_focus'] ?? '').toString().trim().isNotEmpty;

  final bool l7Done = goal != null &&
      (goal['action_plan_note'] ?? '').toString().trim().isNotEmpty;

  return <String, dynamic>{
    'l1Done': l1Done,
    'l4Done': l4Done,
    'l7Done': l7Done,
  };
});
