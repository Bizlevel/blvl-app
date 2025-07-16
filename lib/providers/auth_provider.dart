import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../services/supabase_service.dart';

/// Emits [AuthState] updates from Supabase.
final authStateProvider = StreamProvider<AuthState>((ref) {
  return SupabaseService.client.auth.onAuthStateChange;
});

/// Loads current user profile from `users` table or returns null if not signed in.
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  // Ensure we have a session.
  final auth = await ref.watch(authStateProvider.stream).first;
  final user = auth.session?.user;

  if (kDebugMode) {
    debugPrint(
        'currentUserProvider: auth session = ${auth.session != null}, user = ${user?.id}');
  }

  if (user == null) return null;

  try {
    final response = await SupabaseService.client
        .from('users')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (kDebugMode) {
      debugPrint('currentUserProvider: users query response = $response');
    }

    if (response == null) return null; // профиль ещё не заполнен
    return UserModel.fromJson(response);
  } on PostgrestException catch (e) {
    if (kDebugMode) {
      debugPrint('currentUserProvider: PostgrestException = ${e.message}');
    }
    // table exists but запись отсутствует – вернём null
    return null;
  }
});
