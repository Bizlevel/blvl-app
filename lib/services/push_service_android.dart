import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'push_service_platform.dart';

class AndroidPushPlatformHooks implements PushPlatformHooks {
  const AndroidPushPlatformHooks();

  @override
  Future<void> beforePermissionRequest() async {}

  @override
  Future<void> setupBackgroundHandling(FirebaseMessaging fm) async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
    Sentry.addBreadcrumb(
      Breadcrumb(
        category: 'notif_push_received',
        data: {'from': 'background', 'hasData': message.data.isNotEmpty},
        level: SentryLevel.info,
      ),
    );
  } catch (_) {}
}
