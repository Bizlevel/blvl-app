import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'push_service_platform.dart';

class IosPushPlatformHooks implements PushPlatformHooks {
  const IosPushPlatformHooks();

  @override
  Future<void> beforePermissionRequest() async {
    // Дадим первому кадру стабилизироваться перед запросом прав / I/O.
    await Future<void>.delayed(const Duration(milliseconds: 600));
  }

  @override
  Future<void> setupBackgroundHandling(FirebaseMessaging fm) async {}
}
