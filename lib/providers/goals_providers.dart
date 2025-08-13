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
final dailyQuoteProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final repo = ref.read(goalsRepositoryProvider);
  return repo.getDailyQuote();
});
