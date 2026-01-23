import 'package:flutter/foundation.dart';

class LevelInputGuard {
  LevelInputGuard._();

  static final LevelInputGuard instance = LevelInputGuard._();

  bool _active = false;
  String? _lastLevelRoute;

  bool get isActive => _active;
  String? get lastLevelRoute => _lastLevelRoute;

  void setCurrentLevelRoute(String route) {
    _lastLevelRoute = route;
    debugLog('set_current_level_route route=$route');
  }

  void activate() {
    _active = true;
    debugLog('activate');
  }

  void deactivate() {
    _active = false;
    debugLog('deactivate');
  }

  void clear() {
    _active = false;
    _lastLevelRoute = null;
    debugLog('clear');
  }

  void debugLog(String message) {
    assert(() {
      debugPrint('[nav] level_input_guard $message');
      return true;
    }());
  }
}
