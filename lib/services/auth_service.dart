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
}

/// A typed failure returned by [AuthService] methods.
class AuthFailure implements Exception {
  final String message;
  AuthFailure(this.message);

  @override
  String toString() => 'AuthFailure: $message';
}
