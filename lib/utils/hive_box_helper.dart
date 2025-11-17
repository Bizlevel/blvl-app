import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';

class HiveBoxHelper {
  HiveBoxHelper._();

  static Future<void>? _initFuture;
  static final Map<String, Future<Box>> _pendingOpens = {};

  static Future<void> _ensureInitialized() {
    return _initFuture ??= Hive.initFlutter();
  }

  static Future<Box> openBox(String name) {
    if (Hive.isBoxOpen(name)) {
      return Future<Box>.value(Hive.box(name));
    }
    return _pendingOpens[name] ??= _open(name);
  }

  static Future<Box> _open(String name) async {
    await _ensureInitialized();
    try {
      return await Hive.openBox(name);
    } finally {
      _pendingOpens.remove(name);
    }
  }

  static Box? maybeBox(String name) {
    return Hive.isBoxOpen(name) ? Hive.box(name) : null;
  }

  static Future<dynamic> readValue(String boxName, String key) async {
    try {
      final box = await openBox(boxName);
      return box.get(key);
    } catch (_) {
      return null;
    }
  }

  static void putDeferred(
    String boxName,
    String key,
    dynamic value, {
    Duration delay = const Duration(milliseconds: 32),
  }) {
    Future<void>.delayed(delay, () async {
      try {
        final box = await openBox(boxName);
        if (value == null) {
          await box.delete(key);
        } else {
          await box.put(key, value);
        }
      } catch (_) {}
    });
  }

  static Future<void> deleteValue(String boxName, String key) async {
    try {
      final box = await openBox(boxName);
      await box.delete(key);
    } catch (_) {}
  }
}



