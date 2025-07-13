import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  if (user == null) return null;

  try {
    final response = await SupabaseService.client
        .from('users')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (response == null) return null; // профиль ещё не заполнен
    return UserModel.fromJson(response as Map<String, dynamic>);
  } on PostgrestException {
    // table exists but запись отсутствует – вернём null
    return null;
  }
});
