import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/repositories/goals_repository.dart';
import 'auth_provider.dart';

final goalsRepositoryProvider = Provider<GoalsRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return GoalsRepository(client);
});
