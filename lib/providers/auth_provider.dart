import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/supabase_service.dart';
import '../repositories/user_repository.dart';
import 'package:sentry_flutter/sentry_flutter.dart' as sentry;
import 'package:bizlevel/utils/constant.dart';

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

/// Нормализованный номер текущего уровня пользователя (0..max+1).
/// Использует `SupabaseService.resolveCurrentLevelNumber`, чтобы
/// абстрагироваться от legacy-хранения `users.current_level` (id/number).
final currentLevelNumberProvider = FutureProvider<int>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  final int normalized =
      await SupabaseService.resolveCurrentLevelNumber(user?.currentLevel);

  // Фича‑флаг: поэтапное включение нормализации
  if (!kNormalizeCurrentLevel) {
    // Возвращаем сырое число, если оно валидное, иначе нормализованное
    try {
      final map = await SupabaseService.levelMap();
      final maxNumber =
          map.values.isEmpty ? 0 : map.values.reduce((a, b) => a > b ? a : b);
      final raw = user?.currentLevel;
      if (raw != null && raw >= 0 && raw <= maxNumber + 1) {
        return raw;
      }
    } catch (_) {}
    return normalized;
  }

  // Breadcrumb при подозрительном значении current_level (ни число, ни известный level_id)
  try {
    final map = await SupabaseService.levelMap();
    final maxNumber =
        map.values.isEmpty ? 0 : map.values.reduce((a, b) => a > b ? a : b);
    final raw = user?.currentLevel;
    final bool isValidNumber = raw != null && raw >= 0 && raw <= maxNumber + 1;
    final bool isValidId = raw != null && map.containsKey(raw);
    if (raw != null && !(isValidNumber || isValidId)) {
      sentry.Sentry.addBreadcrumb(sentry.Breadcrumb(
        category: 'level',
        level: sentry.SentryLevel.warning,
        message: 'client_level_mismatch',
        data: {
          'stored_current_level': raw,
          'normalized_number': normalized,
          'max_number': maxNumber,
        },
      ));
    }
  } catch (_) {}

  return normalized;
});
