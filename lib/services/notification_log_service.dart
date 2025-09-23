import 'package:hive_flutter/hive_flutter.dart';

enum NotificationKind { success, info, warn, error }

class NotificationLogService {
  NotificationLogService._();
  static final NotificationLogService instance = NotificationLogService._();

  static const String _boxName = 'notifications';

  Box? get _box => Hive.isBoxOpen(_boxName) ? Hive.box(_boxName) : null;

  Future<void> record({
    required NotificationKind kind,
    required String message,
    String? route,
    String? category,
  }) async {
    final box = _box;
    if (box == null) return;
    final now = DateTime.now().toUtc().toIso8601String();
    await box.add({
      'kind': kind.name,
      'message': message,
      'route': route,
      'category': category,
      'ts': now,
      'read': false,
    });
  }

  Future<List<Map>> latest({int limit = 20, String? filter}) async {
    final box = _box;
    if (box == null) return [];
    final items = box.values.cast<Map>().toList();
    items.sort((a, b) => (b['ts'] as String).compareTo(a['ts'] as String));
    final filtered = filter == null
        ? items
        : items.where((m) => (m['category'] == filter)).toList();
    return filtered.take(limit).toList();
  }

  Future<int> unreadCount() async {
    final box = _box;
    if (box == null) return 0;
    int c = 0;
    for (final v in box.values) {
      if (v is Map && v['read'] == false) c++;
    }
    return c;
  }

  Future<void> markAllRead() async {
    final box = _box;
    if (box == null) return;
    for (int i = 0; i < box.length; i++) {
      final v = box.getAt(i);
      if (v is Map && v['read'] == false) {
        final nv = Map.of(v);
        nv['read'] = true;
        await box.putAt(i, nv);
      }
    }
  }
}
