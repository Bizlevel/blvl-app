import 'dart:async';

class TimezoneGate {
  TimezoneGate._();

  static final Completer<void> _readyCompleter = Completer<void>();

  static bool get isReady => _readyCompleter.isCompleted;

  static Future<void> waitUntilReady() => _readyCompleter.future;

  static void markReady() {
    if (!isReady) {
      _readyCompleter.complete();
    }
  }

  static void markError(Object error, StackTrace stackTrace) {
    if (!isReady) {
      _readyCompleter.completeError(error, stackTrace);
    }
  }
}

