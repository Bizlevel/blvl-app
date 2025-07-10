import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_service.dart';

/// Centralized authentication service.
/// Wraps Supabase Auth calls and provides typed error handling.
class AuthService {
  AuthService._();

  static SupabaseClient get _client => SupabaseService.client;

  /// Signs in a user with email & password.
  /// Throws [AuthFailure] on known errors.
  static Future<AuthResponse> signIn(
      {required String email, required String password}) async {
    try {
      final response = await _client.auth
          .signInWithPassword(email: email, password: password);
      return response;
    } on AuthException catch (e) {
      throw AuthFailure(e.message ?? 'Не удалось войти.');
    } catch (e) {
      throw AuthFailure('Неизвестная ошибка входа');
    }
  }

  /// Registers a new user with email & password.
  static Future<AuthResponse> signUp(
      {required String email, required String password}) async {
    try {
      final response =
          await _client.auth.signUp(email: email, password: password);
      return response;
    } on AuthException catch (e) {
      throw AuthFailure(e.message ?? 'Не удалось зарегистрироваться.');
    } catch (e) {
      throw AuthFailure('Неизвестная ошибка регистрации');
    }
  }

  /// Signs the current user out.
  static Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } on AuthException catch (e) {
      throw AuthFailure(e.message ?? 'Не удалось выйти из аккаунта.');
    } catch (e) {
      throw AuthFailure('Неизвестная ошибка выхода');
    }
  }

  /// Returns the currently authenticated [User] or `null` if not signed in.
  static User? getCurrentUser() => _client.auth.currentUser;

  /// Updates profile fields in `users` table for the current user.
  static Future<void> updateProfile({
    required String name,
    required String about,
    required String goal,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw AuthFailure('Пользователь не авторизован');
    }

    try {
      await _client.from('users').upsert({
        'id': user.id,
        'name': name,
        'about': about,
        'goal': goal,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } on PostgrestException catch (e) {
      throw AuthFailure(e.message);
    } catch (e) {
      throw AuthFailure('Не удалось сохранить профиль');
    }
  }
}

/// A typed failure returned by [AuthService] methods.
class AuthFailure implements Exception {
  final String message;
  AuthFailure(this.message);

  @override
  String toString() => 'AuthFailure: $message';
}
