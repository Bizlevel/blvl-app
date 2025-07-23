import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/supabase_service.dart';
import '../repositories/user_repository.dart';

/// Провайдер, отдающий инстанс `SupabaseService` для DI.
final supabaseServiceProvider =
    Provider<SupabaseService>((_) => SupabaseService());

/// Provides access to the global [SupabaseClient].
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  final service = ref.watch(supabaseServiceProvider);
  return service.client;
});

/// Instantiable [AuthService] that depends on [SupabaseClient].
final authServiceProvider = Provider<AuthService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthService(client);
});

/// Репозиторий доступа к таблице `users`.
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return UserRepository(client);
});

/// Emits [AuthState] updates from Supabase.
final authStateProvider = StreamProvider<AuthState>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client.auth.onAuthStateChange;
});

/// Loads current user profile from `users` table or returns null if not signed in.
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  // Ждём актуальное состояние аутентификации.
  final auth = await ref.watch(authStateProvider.future);
  final supabaseUser = auth.session?.user;

  if (kDebugMode) {
    debugPrint(
        'currentUserProvider: auth session = ${auth.session != null}, user = ${supabaseUser?.id}');
  }

  if (supabaseUser == null) return null;

  // Загружаем профиль через репозиторий.
  final repository = ref.read(userRepositoryProvider);
  final profile = await repository.fetchProfile(supabaseUser.id);

  if (kDebugMode) {
    debugPrint('currentUserProvider: repository returned ${profile != null}');
  }

  return profile;
});
