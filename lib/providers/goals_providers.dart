import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_provider.dart';
import 'goals_repository_provider.dart';

// Последняя версия цели пользователя
final goalLatestProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final auth = await ref.watch(authStateProvider.future);
  final user = auth.session?.user;
  if (user == null) return null;
  final repo = ref.read(goalsRepositoryProvider);
  return repo.fetchLatestGoal(user.id);
});

// Все версии цели
final goalVersionsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final auth = await ref.watch(authStateProvider.future);
  final user = auth.session?.user;
  if (user == null) return [];
  final repo = ref.read(goalsRepositoryProvider);
  return repo.fetchAllGoals(user.id);
});

// Текущий спринт (по номеру)
final sprintProvider = FutureProvider.family<Map<String, dynamic>?, int>(
    (ref, sprintNumber) async {
  final repo = ref.read(goalsRepositoryProvider);
  return repo.fetchSprint(sprintNumber);
});

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
final hasGoalVersionProvider =
    FutureProvider.family<bool, int>((ref, version) async {
  final all = await ref.watch(goalVersionsProvider.future);
  for (final m in all) {
    final int? v = m['version'] as int?;
    if (v == version) return true;
  }
  return false;
});
