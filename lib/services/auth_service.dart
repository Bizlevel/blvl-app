import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bizlevel/services/gp_service.dart';
import 'package:bizlevel/services/notifications_service.dart';
import 'package:bizlevel/services/timezone_gate.dart';
import '../utils/env_helper.dart';

// No longer importing SupabaseService directly to enable dependency injection.

/// Centralized authentication service.
/// Wraps Supabase Auth calls and provides typed error handling.
class AuthService {
  final SupabaseClient _client;
  static bool _googleSdkInitialized = false;

  AuthService(this._client);

  Future<void> _syncUserTimezoneBestEffort() async {
    try {
      final tz = await TimezoneGate.tryGetLocalTimezoneIdentifier();
      if (tz == null) return;
      await _client.rpc('user_set_timezone', params: {'p_timezone': tz});
    } catch (_) {
      // Best-effort: timezone sync should never break auth UX.
    }
  }

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
        // Бонус за первый вход: идемпотентно, ошибки не пробрасываем
        try {
          final gp = GpService(_client);
          await gp.claimBonus(ruleKey: 'signup_bonus');
          // Обновим кеш баланса в фоне
          try {
            final fresh = await gp.getBalance();
            await GpService.saveBalanceCache(fresh);
          } catch (_) {}
        } catch (_) {}

        // Локальные уведомления: инициализируем ядро (без запроса permissions).
        // Разрешения и расписание напоминаний — только по явному действию пользователя
        // (экран "Напоминания"), чтобы избежать фризов/неожиданных системных диалогов.
        try {
          await NotificationsService.instance.initialize();
        } catch (_) {}

        // Синхронизация таймзоны пользователя (IANA) для server-side логики (например, daily-бонусов).
        unawaited(_syncUserTimezoneBestEffort());
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
      // Отменяем локальные уведомления пользователя
      try {
        final notif = NotificationsService.instance;
        // ВАЖНО: не блокируем UX выхода.
        // Отмена уведомлений на iOS может быть дорогой (много cancel(id) → фризы/таймауты жестов),
        // поэтому делаем best-effort в фоне.
        unawaited(() async {
          try {
            await notif.cancelAllNotifications();
          } catch (_) {}
        }());
      } catch (_) {}
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
    // Новые поля персонализации
    String? businessArea,
    String? experienceLevel,
    String? businessSize,
    List<String>? keyChallenges,
    String? learningStyle,
    String? businessRegion,
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
      // Для избегания 23502 (NOT NULL name) используем UPDATE по id вместо UPSERT.
      final Map<String, dynamic> payload = {
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
      // Персонализация
      if (businessArea != null) payload['business_area'] = businessArea;
      if (experienceLevel != null) {
        payload['experience_level'] = experienceLevel;
      }
      if (businessSize != null) payload['business_size'] = businessSize;
      if (keyChallenges != null) payload['key_challenges'] = keyChallenges;
      if (learningStyle != null) payload['learning_style'] = learningStyle;
      if (businessRegion != null) payload['business_region'] = businessRegion;

      await _client.from('users').update(payload).eq('id', user.id);
      // Попытка выдать бонус за заполненный профиль (идемпотентно)
      try {
        final row = await _client
            .from('users')
            .select('name, goal, about, avatar_id')
            .eq('id', user.id)
            .single();
        final hasName = ((row['name'] as String?)?.trim().isNotEmpty ?? false);
        final hasGoal = ((row['goal'] as String?)?.trim().isNotEmpty ?? false);
        final hasAbout =
            ((row['about'] as String?)?.trim().isNotEmpty ?? false);
        final hasAvatar = (row['avatar_id'] as int?) != null;
        if (hasName && hasGoal && hasAbout && hasAvatar) {
          final gp = GpService(_client);
          await gp.claimBonus(ruleKey: 'profile_completed');
          try {
            final fresh = await gp.getBalance();
            await GpService.saveBalanceCache(fresh);
          } catch (_) {}
          // Показать уведомление о бонусе профиля (UI ответственность — экран профиля)
        }
      } catch (_) {}
    }, unknownErrorMessage: 'Не удалось сохранить профиль');
  }

  /// Updates the avatar id (1..12) for current user.
  /// Deprecated: Use updateProfile(avatarId: id) instead.
  Future<void> updateAvatar(int avatarId) async {
    await updateProfile(avatarId: avatarId);
  }

  /// Sign in with Google for Web and Mobile.
  Future<AuthResponse> signInWithGoogle() async {
    return _handleAuthCall(() async {
      if (kIsWeb) {
        final redirectTo = envOrDefine('WEB_REDIRECT_ORIGIN');
        await _client.auth.signInWithOAuth(
          OAuthProvider.google,
          redirectTo: redirectTo.isNotEmpty ? redirectTo : null,
        );
        // На web произойдёт редирект, сессия подхватится onAuthStateChange
        return AuthResponse();
      } else if (Platform.isAndroid || Platform.isIOS) {
        final googleWebClientId = envOrDefine('GOOGLE_WEB_CLIENT_ID');
        final iosClientId = envOrDefine('IOS_GOOGLE_CLIENT_ID');
        final googleSignIn = GoogleSignIn.instance;
        if (!_googleSdkInitialized) {
          await googleSignIn.initialize(
            clientId:
                Platform.isIOS && iosClientId.isNotEmpty ? iosClientId : null,
            serverClientId:
                googleWebClientId.isNotEmpty ? googleWebClientId : null,
          );
          _googleSdkInitialized = true;
        }

        final account = await googleSignIn.authenticate(
          scopeHint: const <String>['email', 'profile'],
        );

        final auth = account.authentication;
        final authorization = await account.authorizationClient.authorizeScopes(
          const <String>['email', 'profile'],
        );

        final idToken = auth.idToken;
        final accessToken = authorization.accessToken;
        if (idToken == null || accessToken.isEmpty) {
          throw AuthFailure('Не удалось получить токены Google');
        }

        final response = await _client.auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: idToken,
          accessToken: accessToken,
        );

        final user = response.user;
        if (user != null) {
          // Set Sentry user context
          Sentry.configureScope((scope) {
            scope.setUser(SentryUser(id: user.id, email: user.email));
          });

          // Бонус за первый вход: идемпотентно, ошибки не пробрасываем
          try {
            final gp = GpService(_client);
            await gp.claimBonus(ruleKey: 'signup_bonus');
            // Обновим кеш баланса в фоне
            try {
              final fresh = await gp.getBalance();
              await GpService.saveBalanceCache(fresh);
            } catch (_) {}
          } catch (_) {}

          // Локальные уведомления: инициализируем ядро (без запроса permissions).
          try {
            await NotificationsService.instance.initialize();
          } catch (_) {}

          // Синхронизация таймзоны пользователя
          unawaited(_syncUserTimezoneBestEffort());
        }

        return response;
      }
      throw AuthFailure('Платформа не поддерживается для входа через Google');
    }, unknownErrorMessage: 'Неизвестная ошибка входа через Google');
  }

  /// Sign in with Apple for iOS and Web.
  /// Note: Apple Sign In is only available on iOS 13+ and Web.
  Future<AuthResponse> signInWithApple() async {
    return _handleAuthCall(() async {
      if (kIsWeb) {
        // Для web используем OAuth редирект
        final redirectTo = envOrDefine('WEB_REDIRECT_ORIGIN');
        await _client.auth.signInWithOAuth(
          OAuthProvider.apple,
          redirectTo: redirectTo.isNotEmpty ? redirectTo : null,
        );
        // На web произойдёт редирект, сессия подхватится onAuthStateChange
        return AuthResponse();
      } else if (Platform.isIOS) {
        // Проверка доступности (iOS 13+)
        if (!await SignInWithApple.isAvailable()) {
          throw AuthFailure('Sign in with Apple недоступен на этом устройстве');
        }

        // Запрос авторизации
        final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );

        // Получение identity token
        final identityToken = credential.identityToken;
        if (identityToken == null) {
          throw AuthFailure('Не удалось получить токен от Apple');
        }

        // Вход через Supabase
        final response = await _client.auth.signInWithIdToken(
          provider: OAuthProvider.apple,
          idToken: identityToken,
        );

        // Обработка данных пользователя
        final user = response.user;
        if (user != null) {
          // Set Sentry user context
          Sentry.configureScope((scope) {
            scope.setUser(SentryUser(id: user.id, email: user.email));
          });

          // Apple предоставляет имя только при первом входе — сохраняем в профиль
          if (credential.givenName != null || credential.familyName != null) {
            try {
              final fullName =
                  '${credential.givenName ?? ''} ${credential.familyName ?? ''}'
                      .trim();
              if (fullName.isNotEmpty) {
                await updateProfile(name: fullName);
              }
            } catch (_) {
              // Игнорируем ошибки обновления профиля
            }
          }

          // Бонус за первый вход (идемпотентно)
          try {
            final gp = GpService(_client);
            await gp.claimBonus(ruleKey: 'signup_bonus');
            try {
              final fresh = await gp.getBalance();
              await GpService.saveBalanceCache(fresh);
            } catch (_) {}
          } catch (_) {}

          // Локальные уведомления: инициализируем ядро (без запроса permissions).
          // Разрешения и расписание — только по явному действию пользователя.
          try {
            await NotificationsService.instance.initialize();
          } catch (_) {}

          // Синхронизация таймзоны пользователя (IANA) для server-side логики.
          unawaited(_syncUserTimezoneBestEffort());
        }

        return response;
      }
      throw AuthFailure('Sign in with Apple доступен только на iOS и Web');
    }, unknownErrorMessage: 'Неизвестная ошибка входа через Apple');
  }
}

/// A typed failure returned by [AuthService] methods.
class AuthFailure implements Exception {
  final String message;
  AuthFailure(this.message);

  @override
  String toString() => 'AuthFailure: $message';
}
