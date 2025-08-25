import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_provider.dart';
import 'package:bizlevel/repositories/cases_repository.dart';

final casesRepositoryProvider = Provider<CasesRepository>((ref) {
  final SupabaseClient client = ref.watch(supabaseClientProvider);
  return CasesRepository(client);
});

