/// Stub for `dart:ui`'s [platformViewRegistry] on non-web platforms.
class _FakePlatformViewRegistry {
  void registerViewFactory(String viewId, dynamic Function(int) _) {}
}

// Matches the API used on web.
final platformViewRegistry = _FakePlatformViewRegistry();
