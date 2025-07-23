import 'dart:io';

import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// No longer importing SupabaseService directly to enable dependency injection.

/// Centralized authentication service.
/// Wraps Supabase Auth calls and provides typed error handling.
class AuthService {
  final SupabaseClient _client;

  AuthService(this._client);

  /// Signs in a user with email & password.
  /// Throws [AuthFailure] on known errors.
  Future<AuthResponse> signIn(
      {required String email, required String password}) async {
    try {
      final response = await _client.auth
          .signInWithPassword(email: email, password: password);
      // Set Sentry user context
      final user = response.user;
      if (user != null) {
        Sentry.configureScope((scope) {
          scope.setUser(SentryUser(id: user.id, email: user.email));
        });
      }
      return response;
    } on AuthException catch (e, st) {
      await Sentry.captureException(e, stackTrace: st);
      throw AuthFailure(e.message);
    } on SocketException {
      throw AuthFailure('Нет соединения с интернетом');
    } catch (e, st) {
      await Sentry.captureException(e, stackTrace: st);
      throw AuthFailure('Неизвестная ошибка входа');
    }
  }

  /// Registers a new user with email & password.
  Future<AuthResponse> signUp(
      {required String email, required String password}) async {
    try {
      final response =
          await _client.auth.signUp(email: email, password: password);
      return response;
    } on AuthException catch (e, st) {
      await Sentry.captureException(e, stackTrace: st);
      throw AuthFailure(e.message);
    } on SocketException {
      throw AuthFailure('Нет соединения с интернетом');
    } catch (e, st) {
      await Sentry.captureException(e, stackTrace: st);
      throw AuthFailure('Неизвестная ошибка регистрации');
    }
  }

  /// Signs the current user out.
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
      // Clear Sentry user context
      Sentry.configureScope((scope) => scope.setUser(null));
    } on AuthException catch (e, st) {
      await Sentry.captureException(e, stackTrace: st);
      throw AuthFailure(e.message);
    } on SocketException {
      throw AuthFailure('Нет соединения с интернетом');
    } catch (e, st) {
      await Sentry.captureException(e, stackTrace: st);
      throw AuthFailure('Неизвестная ошибка выхода');
    }
  }

  /// Returns the currently authenticated [User] or `null` if not signed in.
  User? getCurrentUser() => _client.auth.currentUser;

  /// Updates profile fields in `users` table for the current user.
  Future<void> updateProfile({
    required String name,
    required String about,
    required String goal,
    bool? onboardingCompleted,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw AuthFailure('Пользователь не авторизован');
    }

    try {
      // Build payload dynamically to avoid overwriting onboarding status when not provided.
      final Map<String, dynamic> payload = {
        'id': user.id,
        'email': user.email,
        'name': name,
        'about': about,
        'goal': goal,
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Only update onboarding flag when explicitly specified.
      if (onboardingCompleted != null) {
        payload['onboarding_completed'] = onboardingCompleted;
      }

      await _client.from('users').upsert(payload);
    } on PostgrestException catch (e, st) {
      await Sentry.captureException(e, stackTrace: st);
      throw AuthFailure(e.message);
    } on SocketException {
      throw AuthFailure('Нет соединения с интернетом');
    } catch (e, st) {
      await Sentry.captureException(e, stackTrace: st);
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
