import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/repositories/levels_repository.dart';
import 'auth_provider.dart';

final levelsRepositoryProvider = Provider<LevelsRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return LevelsRepository(client);
});
