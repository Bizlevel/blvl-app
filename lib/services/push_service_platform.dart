abstract class PushPlatformHooks {
  Future<void> beforePermissionRequest();
}

class DefaultPushPlatformHooks implements PushPlatformHooks {
  const DefaultPushPlatformHooks();

  @override
  Future<void> beforePermissionRequest() async {}
}
