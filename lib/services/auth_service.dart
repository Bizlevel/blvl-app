import 'dart:developer';
import 'dart:io';

import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// No longer importing SupabaseService directly to enable dependency injection.

/// Centralized authentication service.
/// Wraps Supabase Auth calls and provides typed error handling.
class AuthService {
  final SupabaseClient _client;

  AuthService(this._client);

  /// Generic wrapper to unify error handling for Supabase auth calls.
  /// [unknownErrorMessage] – сообщение по умолчанию, если исключение не классифицировано.
  Future<T> _handleAuthCall<T>(
    Future<T> Function() action, {
    required String unknownErrorMessage,
  }) async {
    try {
      return await action();
    } on AuthException catch (e, st) {
      log('AuthException caught in AuthService', error: e, stackTrace: st);
      await Sentry.captureException(e, stackTrace: st);
      throw AuthFailure(e.message);
    } on PostgrestException catch (e, st) {
      log('PostgrestException caught in AuthService', error: e, stackTrace: st);
      await Sentry.captureException(e, stackTrace: st);
      throw AuthFailure(e.message);
    } on SocketException catch (e, st) {
      log('SocketException caught in AuthService', error: e, stackTrace: st);
      throw AuthFailure('Нет соединения с интернетом');
    } catch (e, st) {
      log('Unknown error caught in AuthService', error: e, stackTrace: st);
      await Sentry.captureException(e, stackTrace: st);
      throw AuthFailure(unknownErrorMessage);
    }
  }

  /// Signs in a user with email & password.
  /// Throws [AuthFailure] on known errors.
  Future<AuthResponse> signIn(
      {required String email, required String password}) async {
    return _handleAuthCall(() async {
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
    }, unknownErrorMessage: 'Неизвестная ошибка входа');
  }

  /// Registers a new user with email & password.
  Future<AuthResponse> signUp(
      {required String email, required String password}) async {
    return _handleAuthCall(() async {
      final response =
          await _client.auth.signUp(email: email, password: password);
      return response;
    }, unknownErrorMessage: 'Неизвестная ошибка регистрации');
  }

  /// Signs the current user out.
  Future<void> signOut() async {
    await _handleAuthCall(() async {
      await _client.auth.signOut();
      // Clear Sentry user context
      Sentry.configureScope((scope) => scope.setUser(null));
    }, unknownErrorMessage: 'Неизвестная ошибка выхода');
  }

  /// Returns the currently authenticated [User] or `null` if not signed in.
  User? getCurrentUser() => _client.auth.currentUser;

  /// Stream of authentication state changes.
  Stream<User?> get authStateChanges =>
      _client.auth.onAuthStateChange.map((event) => event.session?.user);

  /// Updates profile fields in `users` table for the current user.
  /// All parameters are optional for partial updates.
  Future<void> updateProfile({
    String? name,
    String? about,
    String? goal,
    int? avatarId,
    bool? onboardingCompleted,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw AuthFailure('Пользователь не авторизован');
    }

    // Если e-mail не подтверждён/отсутствует – блокируем сохранение профиля,
    // чтобы избежать NOT-NULL нарушения в базе (#21.6.1).
    if (user.email == null) {
      throw AuthFailure('Подтвердите e-mail, прежде чем продолжить');
    }

    await _handleAuthCall(() async {
      // Формируем payload динамически, добавляя только переданные поля
      final Map<String, dynamic> payload = {
        'id': user.id,
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Добавляем email, только если он гарантированно не null.
      if (user.email != null) {
        payload['email'] = user.email;
      }

      // Добавляем только переданные поля
      if (name != null) payload['name'] = name;
      if (about != null) payload['about'] = about;
      if (goal != null) payload['goal'] = goal;
      if (avatarId != null) payload['avatar_id'] = avatarId;
      if (onboardingCompleted != null) {
        payload['onboarding_completed'] = onboardingCompleted;
      }

      await _client.from('users').upsert(payload);
    }, unknownErrorMessage: 'Не удалось сохранить профиль');
  }

  /// Updates the avatar id (1..7) for current user.
  /// Deprecated: Use updateProfile(avatarId: id) instead.
  Future<void> updateAvatar(int avatarId) async {
    await updateProfile(avatarId: avatarId);
  }
}

/// A typed failure returned by [AuthService] methods.
class AuthFailure implements Exception {
  final String message;
  AuthFailure(this.message);

  @override
  String toString() => 'AuthFailure: $message';
}
