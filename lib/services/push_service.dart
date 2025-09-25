import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bizlevel/services/notifications_service.dart';

// Топ-левел background handler обязателен для Android
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
    Sentry.addBreadcrumb(Breadcrumb(
      category: 'notif_push_received',
      data: {'from': 'background', 'hasData': message.data.isNotEmpty},
      level: SentryLevel.info,
    ));
  } catch (_) {}
}

class PushService {
  PushService._();
  static final PushService instance = PushService._();

  late final FirebaseMessaging _fm;

  Future<void> initialize() async {
    // В вебе этот сервис не должен работать
    if (kIsWeb) return;

    try {
      // Пытаемся инициализировать Firebase безопасно
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
      _fm = FirebaseMessaging.instance;

      // Mobile permissions
      if (Platform.isIOS || Platform.isAndroid) {
        await _fm.requestPermission(alert: true, badge: true, sound: true);
      }

      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // Foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        Sentry.addBreadcrumb(Breadcrumb(
          category: 'notif_push_received',
          data: {'from': 'foreground', 'hasData': message.data.isNotEmpty},
          level: SentryLevel.info,
        ));
        // Показываем системное уведомление в фореграунде (минимальный контент)
        final title = message.notification?.title ?? 'Сообщение BizLevel';
        final body = message.notification?.body ?? 'Откройте приложение';
        final route = message.data['route']?.toString();
        final type = message.data['type']?.toString();
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

      // Taps from background/killed
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        final route = message.data['route']?.toString();
        if (route != null && route.isNotEmpty) {
          Sentry.addBreadcrumb(Breadcrumb(
            category: 'notif_push_tap',
            data: {'route': route},
            level: SentryLevel.info,
          ));
          _storeLaunchRoute(route);
        }
      });

      // Cold start
      final initial =
          (Firebase.apps.isNotEmpty) ? await _fm.getInitialMessage() : null;
      if (initial != null) {
        final route = initial.data['route']?.toString();
        if (route != null && route.isNotEmpty) {
          _storeLaunchRoute(route);
        }
      }

      // Token lifecycle
      await _syncToken();
      _fm.onTokenRefresh.listen((t) => _registerToken(t));
    } catch (e, st) {
      await Sentry.captureException(e, stackTrace: st);
    }
  }

  Future<void> _syncToken() async {
    try {
      final token = await _fm.getToken();
      if (token != null && token.isNotEmpty) {
        await _registerToken(token);
      }
    } catch (e, st) {
      await Sentry.captureException(e, stackTrace: st);
    }
  }

  Future<void> _registerToken(String token) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return; // не логиним — не регистрируем

      final platform = Platform.isAndroid
          ? 'android'
          : Platform.isIOS
              ? 'ios'
              : 'web';

      await Supabase.instance.client.from('push_tokens').upsert({
        'user_id': user.id,
        'token': token,
        'platform': platform,
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
      final token = await _fm.getToken();
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
    try {
      final box = await Hive.openBox('notifications');
      await box.put('launch_route', route);
    } catch (_) {}
  }
}
