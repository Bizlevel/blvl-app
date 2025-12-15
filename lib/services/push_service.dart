import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bizlevel/constants/push_flags.dart';
import 'package:bizlevel/services/notifications_service.dart';
import 'package:bizlevel/utils/env_helper.dart';
import 'package:timezone/timezone.dart' as tz;

// Топ-левел background handler обязателен для Android
class PushService {
  PushService._();
  static final PushService instance = PushService._();

  // OneSignal имеет собственное состояние инициализации.
  // Мы держим флаг, чтобы:
  // - не вызывать logout/login до initialize (иначе warning: "logout before app ID has been set")
  // - не дублировать initialize при повторных логинах в рамках одного процесса.
  bool _oneSignalInitialized = false;
  String? _pendingExternalId;
  String? _linkedExternalId;

  Future<void> initialize() async {
    // В вебе этот сервис не должен работать
    if (kIsWeb) return;

    // OneSignal для обеих платформ
    if (!kEnableIosPush && Platform.isIOS) {
      Sentry.addBreadcrumb(Breadcrumb(
        category: 'push_service',
        level: SentryLevel.info,
        message: 'Skip PushService on iOS (kEnableIosPush=false)',
      ));
      return;
    }

    // Не блокируем первый кадр: OneSignal в фоне
    if (_oneSignalInitialized) {
      // OneSignal уже поднят — просто обновим привязку External ID (если нужно).
      _pendingExternalId = Supabase.instance.client.auth.currentUser?.id;
      _tryLinkExternalIdIfReady();
      return;
    }
    unawaited(_initializeOneSignal());
  }

  Future<void> _initializeOneSignal() async {
    final appId = envOrDefine('ONESIGNAL_APP_ID');
    if (appId.isEmpty) {
      Sentry.addBreadcrumb(Breadcrumb(
        category: 'push_service',
        level: SentryLevel.warning,
        message: 'ONESIGNAL_APP_ID is empty, skip OneSignal init',
      ));
      return;
    }

    try {
      OneSignal.initialize(appId);
      _oneSignalInitialized = true;

      // ВАЖНО: не делаем OneSignal.login() сразу после initialize.
      // В свежих логах это приводит к:
      // - "null OneSignal ID"
      // - "OSUserExecutor.executePendingRequests() is blocked by unexecutable request"
      // Поэтому ждём появления OneSignal ID (pushSubscription.id) и только потом логиним External ID.
      _pendingExternalId = Supabase.instance.client.auth.currentUser?.id;
      // ВАЖНО: не запрашиваем permission на cold start / при инициализации.
      // В свежих логах это давало:
      // - "Requesting authorization with options ..."
      // - Hang detected / деактивацию сцены / UI-фризы.
      // Разрешение просим только по явному действию пользователя (например, на экране "Напоминания").

      OneSignal.Notifications.addForegroundWillDisplayListener((event) {
        final payload = event.notification;
        event.preventDefault(); // покажем сами
        Sentry.addBreadcrumb(Breadcrumb(
          category: 'notif_push_received',
          data: {'from': 'foreground', 'hasData': payload.additionalData != null},
          level: SentryLevel.info,
        ));
        final title = payload.title ?? 'Сообщение BizLevel';
        final body = payload.body ?? 'Откройте приложение';
        final route = payload.additionalData?['route']?.toString();
        final type = payload.additionalData?['type']?.toString();
        final channel = switch (type) {
          'goal_reminder' => 'goal_reminder',
          'gp_economy' => 'gp_economy',
          'chat_messages' => 'chat_messages',
          _ => 'education',
        };
        NotificationsService.instance.showNow(
          title: title,
          body: body,
          channelId: channel,
          route: route,
        );
      });

      OneSignal.Notifications.addClickListener((event) {
        final route = event.notification.additionalData?['route']?.toString();
        if (route != null && route.isNotEmpty) {
          Sentry.addBreadcrumb(Breadcrumb(
            category: 'notif_push_tap',
            data: {'route': route},
            level: SentryLevel.info,
          ));
          _storeLaunchRoute(route);
        }
      });

      final sub = OneSignal.User.pushSubscription;
      final playerId = sub.id;
      final token = sub.token;

      final primaryToken = playerId ?? token;
      if (primaryToken != null && primaryToken.isNotEmpty) {
        await _registerToken(primaryToken, provider: 'onesignal');
      }

      _tryLinkExternalIdIfReady();

      OneSignal.User.pushSubscription.addObserver((state) async {
        final newId = state.current.id;
        final newToken = state.current.token;
        final refreshed = newId ?? newToken;
        if (refreshed != null && refreshed.isNotEmpty) {
          await _registerToken(refreshed, provider: 'onesignal');
        }
        _tryLinkExternalIdIfReady();
      });

      Sentry.addBreadcrumb(Breadcrumb(
        category: 'push_service',
        level: SentryLevel.info,
        message: 'OneSignal initialization completed',
      ));
    } catch (e, st) {
      await Sentry.captureException(e, stackTrace: st);
    }
  }

  void _tryLinkExternalIdIfReady() {
    final externalId = _pendingExternalId;
    if (externalId == null || externalId.isEmpty) return;

    // OneSignal ID должен быть задан, иначе login() приводит к блокировке identify-запроса.
    final oneSignalId = OneSignal.User.pushSubscription.id;
    if (oneSignalId == null || oneSignalId.isEmpty) return;

    if (_linkedExternalId == externalId) {
      _pendingExternalId = null;
      return;
    }

    try {
      OneSignal.login(externalId);
      _linkedExternalId = externalId;
      _pendingExternalId = null;
    } catch (e, st) {
      unawaited(Sentry.captureException(e, stackTrace: st));
    }
  }

  /// Сбрасывает External ID в OneSignal при logout.
  ///
  /// Важно: вызываем при переходе auth-сессии в null (signOut), иначе OneSignal
  /// может сохранять связь устройства с предыдущим пользователем.
  void onLogout() {
    if (kIsWeb) return;
    // Нельзя вызывать logout до initialize — SDK пишет warning и делает лишний main-thread I/O.
    if (!_oneSignalInitialized) return;
    try {
      OneSignal.logout();
      _pendingExternalId = null;
      _linkedExternalId = null;
    } catch (e, st) {
      unawaited(Sentry.captureException(e, stackTrace: st));
    }
  }

  Future<void> _registerToken(String token, {required String provider}) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return; // не логиним — не регистрируем

      if (!_isValidToken(token)) {
        await Sentry.captureMessage(
          'push_service: invalid token, skip',
          level: SentryLevel.warning,
          withScope: (scope) {
            scope.setContexts('push_token', {
              'provider': provider,
              'length': token.length,
              'sample': token.substring(0, token.length > 64 ? 64 : token.length),
            });
            scope.setUser(SentryUser(id: user.id));
          },
        );
        return;
      }

      final platform = Platform.isAndroid
          ? 'android'
          : Platform.isIOS
              ? 'ios'
              : 'web';
      final localeTag = ui.PlatformDispatcher.instance.locale.toLanguageTag();
      final timezone = tz.local.name.isNotEmpty ? tz.local.name : 'UTC';

      await Supabase.instance.client.from('push_tokens').upsert({
        'user_id': user.id,
        'token': token,
        'platform': platform,
        'provider': provider,
        'timezone': timezone,
        'locale': localeTag,
        'enabled': true,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e, st) {
      await Sentry.captureException(e, stackTrace: st);
    }
  }

  Future<void> unregisterCurrentToken() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;
      final sub = OneSignal.User.pushSubscription;
      final token = sub.id ?? sub.token;
      if (token == null) return;
      await Supabase.instance.client
          .from('push_tokens')
          .delete()
          .match({'user_id': user.id, 'token': token});
    } catch (e, st) {
      await Sentry.captureException(e, stackTrace: st);
    }
  }

  Future<void> _storeLaunchRoute(String route) async {
    await NotificationsService.instance.persistLaunchRoute(route);
  }

  bool _isValidToken(String token) {
    if (token.isEmpty) return false;
    // Отсекаем явные мусорные значения, которые ломают uuid/text поля
    const disallowed = ['{', '}', ',', ' '];
    if (disallowed.any(token.contains)) return false;
    // UUID / OneSignal player id и FCM токены длиннее 20 символов
    if (token.length < 20) return false;
    return true;
  }
}
