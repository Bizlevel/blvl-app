import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/repositories/lessons_repository.dart';
import 'auth_provider.dart';

final lessonsRepositoryProvider = Provider<LessonsRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return LessonsRepository(client);
});
