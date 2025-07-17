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
  final auth = await ref.watch(authStateProvider.future);
  final user = auth.session?.user;

  if (kDebugMode) {
    debugPrint(
        'currentUserProvider: auth session = ${auth.session != null}, user = ${user?.id}');
  }

  if (user == null) return null;

  try {
    if (kDebugMode) {
      debugPrint(
          'currentUserProvider: querying users table for user ${user.id}');
    }

    final response = await SupabaseService.client
        .from('users')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (kDebugMode) {
      debugPrint('currentUserProvider: users query response = $response');
      debugPrint(
          'currentUserProvider: response type = ${response.runtimeType}');
    }

    if (response == null) {
      if (kDebugMode) {
        debugPrint(
            'currentUserProvider: no user found in users table for ${user.id}');
      }
      return null; // профиль ещё не заполнен
    }

    final userModel = UserModel.fromJson(response);
    if (kDebugMode) {
      debugPrint(
          'currentUserProvider: successfully loaded user ${userModel.id}, onboardingCompleted = ${userModel.onboardingCompleted}');
    }

    return userModel;
  } on PostgrestException catch (e) {
    if (kDebugMode) {
      debugPrint(
          'currentUserProvider: PostgrestException = ${e.message}, code = ${e.code}');
    }
    // table exists but запись отсутствует – вернём null
    return null;
  } catch (e) {
    if (kDebugMode) {
      debugPrint('currentUserProvider: unexpected error = $e');
    }
    return null;
  }
});
