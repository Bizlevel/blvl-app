import 'package:firebase_messaging/firebase_messaging.dart';

abstract class PushPlatformHooks {
  Future<void> setupBackgroundHandling(FirebaseMessaging fm);

  Future<void> beforePermissionRequest();
}

class DefaultPushPlatformHooks implements PushPlatformHooks {
  const DefaultPushPlatformHooks();

  @override
  Future<void> beforePermissionRequest() async {}

  @override
  Future<void> setupBackgroundHandling(FirebaseMessaging fm) async {}
}
