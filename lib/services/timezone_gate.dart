import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class TimezoneGate {
  TimezoneGate._();

  static final Completer<void> _readyCompleter = Completer<void>();
  static Future<void>? _initFuture;

  static bool get isReady => _readyCompleter.isCompleted;

  static Future<void> waitUntilReady() => _readyCompleter.future;

  /// Возвращает IANA timezone identifier (например, `Asia/Almaty`) без инициализации tzdata.
  ///
  /// Это лёгкий вызов, подходящий для синхронизации таймзоны на сервере
  /// (например, для daily-бонусов), не блокируя UI тяжёлым `initializeTimeZones()`.
  static Future<String?> tryGetLocalTimezoneIdentifier() async {
    try {
      final timeZoneInfo = await FlutterTimezone.getLocalTimezone();
      final id = timeZoneInfo.identifier.trim();
      return id.isEmpty ? null : id;
    } catch (_) {
      return null;
    }
  }

  /// Инициализирует timezone (tzdata + локальная таймзона) **по требованию**.
  ///
  /// Мы намеренно НЕ делаем это на cold start, потому что `tzdata.initializeTimeZones()`
  /// может быть тяжёлым и вызывать заметные подвисания UI.
  static Future<void> ensureInitialized() {
    if (isReady) return _readyCompleter.future;
    _initFuture ??= _doInit();
    return _initFuture!;
  }

  static Future<void> _doInit() async {
    try {
      final sw = Stopwatch()..start();
      if (kDebugMode) {
        // Лёгкий лог: важно понимать, когда timezone реально инициализируется.
        debugPrint('STARTUP[timezone.init.start] {}');
      }
      tzdata.initializeTimeZones();
      final timeZoneInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneInfo.identifier));
      markReady();
      if (kDebugMode) {
        debugPrint('STARTUP[timezone.init.done] {"ms": ${sw.elapsedMilliseconds}}');
      }
    } catch (error, stackTrace) {
      markError(error, stackTrace);
      rethrow;
    }
  }

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

