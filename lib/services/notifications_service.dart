import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class NotificationsService {
  NotificationsService._();
  static final NotificationsService instance = NotificationsService._();
  static String? pendingRoute;

  // Keys for local persistence
  static const String _boxName = 'notifications';
  static const String _kWeekdays = 'practice_reminder_weekdays';
  static const String _kHour = 'practice_reminder_hour';
  static const String _kMinute = 'practice_reminder_minute';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    if (kIsWeb) {
      _initialized = true;
      try {
        Sentry.addBreadcrumb(Breadcrumb(
          level: SentryLevel.info,
          category: 'notif',
          message: 'notif_init_skipped_web',
        ));
      } catch (_) {}
      return;
    }
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('ic_launcher');
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );
    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        final payload = details.payload;
        if (payload == null) return;
        try {
          final data = json.decode(payload) as Map<String, dynamic>;
          final route = data['route']?.toString();
          if (route != null && route.isNotEmpty) {
            pendingRoute = route;
          }
          try {
            Sentry.addBreadcrumb(Breadcrumb(
              level: SentryLevel.info,
              category: 'notif',
              message: 'notif_tap',
            ));
          } catch (_) {}
        } catch (_) {}
      },
    );

    await _ensureAndroidChannels();
    await _requestPermissionsIfNeeded();

    _initialized = true;
  }

  // Load persisted practice reminder prefs; provide defaults when absent
  Future<(Set<int> weekdays, int hour, int minute)>
      getPracticeReminderPrefs() async {
    try {
      final Box box = Hive.isBoxOpen(_boxName)
          ? Hive.box(_boxName)
          : await Hive.openBox(_boxName);
      final List<dynamic>? rawDays = box.get(_kWeekdays) as List<dynamic>?;
      final int hour = (box.get(_kHour) as int?) ?? 19;
      final int minute = (box.get(_kMinute) as int?) ?? 0;
      final Set<int> days = rawDays == null
          ? {DateTime.monday, DateTime.wednesday, DateTime.friday}
          : rawDays
              .map((e) => int.tryParse(e.toString()) ?? 0)
              .where((v) => v >= 1 && v <= 7)
              .toSet();
      return (days, hour, minute);
    } catch (_) {
      return ({DateTime.monday, DateTime.wednesday, DateTime.friday}, 19, 0);
    }
  }

  Future<String?> consumeAnyLaunchRoute() async {
    try {
      String? route;
      if (pendingRoute != null && pendingRoute!.isNotEmpty) {
        route = pendingRoute;
        pendingRoute = null;
      }
      if (route == null) {
        try {
          final box = Hive.isBoxOpen('notifications')
              ? Hive.box('notifications')
              : await Hive.openBox('notifications');
          final stored = box.get('launch_route');
          if (stored is String && stored.isNotEmpty) {
            route = stored;
            await box.delete('launch_route');
          }
        } catch (_) {}
      }
      if (route == null) {
        try {
          final details = await _plugin.getNotificationAppLaunchDetails();
          final payload = details?.notificationResponse?.payload;
          if (payload != null) {
            final data = json.decode(payload) as Map<String, dynamic>;
            final r = data['route']?.toString();
            if (r != null && r.isNotEmpty) route = r;
          }
        } catch (_) {}
      }
      return route;
    } catch (_) {
      return null;
    }
  }

  Future<void> showNow({
    required String title,
    required String body,
    String channelId = 'education',
    String? route,
  }) async {
    if (kIsWeb) return;
    if (!_initialized) await initialize();
    final android = AndroidNotificationDetails(
      channelId,
      _channelName(channelId),
      channelDescription: _channelDesc(channelId),
      importance: Importance.high,
      priority: Priority.high,
    );
    final details = NotificationDetails(android: android);
    final payload =
        route != null && route.isNotEmpty ? '{"route":"$route"}' : null;
    try {
      await _plugin.show(
        DateTime.now().millisecondsSinceEpoch % 1000000,
        title,
        body,
        details,
        payload: payload,
      );
    } catch (_) {}
  }

  String _channelName(String id) {
    switch (id) {
      case 'goal_reminder':
        return 'Напоминания по целям';
      case 'chat_messages':
        return 'Сообщения чатов';
      default:
        return 'Обучение';
    }
  }

  String _channelDesc(String id) {
    switch (id) {
      case 'goal_reminder':
        return 'План недели и чекины';
      case 'chat_messages':
        return 'Ответы ИИ‑тренеров';
      default:
        return 'Новые материалы';
    }
  }

  Future<void> _ensureAndroidChannels() async {
    if (!Platform.isAndroid) return;
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return;
    try {
      await android.createNotificationChannel(const AndroidNotificationChannel(
        'goal_reminder',
        'Напоминания по целям',
        description: 'План недели, середина недели и чекин',
        importance: Importance.high,
      ));
      await android.createNotificationChannel(const AndroidNotificationChannel(
        'education',
        'Обучение',
        description: 'Новые материалы, курсы и библиотека',
      ));
      await android.createNotificationChannel(const AndroidNotificationChannel(
        'chat_messages',
        'Сообщения чатов',
        description: 'Ответы ИИ‑тренеров и уведомления чатов',
        importance: Importance.high,
      ));
      try {
        Sentry.addBreadcrumb(Breadcrumb(
          level: SentryLevel.info,
          category: 'notif',
          message: 'notif_channels_ready',
        ));
      } catch (_) {}
    } catch (_) {}
  }

  /// Schedule reminders at selected weekdays (IDs: Monday..Sunday) and hour
  Future<void> schedulePracticeReminders(
      {required List<int> weekdays, int hour = 19}) async {
    if (kIsWeb) return;
    if (!_initialized) await initialize();
    const channelId = 'goal_reminder';
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      channelId,
      'Напоминания по целям',
      channelDescription: 'План недели, середина недели и чекин',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: android);
    for (final wd in weekdays.toSet()) {
      const idBase = 9000;
      await _plugin.zonedSchedule(
        idBase + wd,
        'Время практики',
        'Загляни в «Цель» и отметь действие сегодня',
        _nextInstanceOf(weekday: wd, hour: hour, minute: 0),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: '{"route":"/goal"}',
      );
    }
    // Persist selected weekdays/hour
    try {
      final Box box = Hive.isBoxOpen(_boxName)
          ? Hive.box(_boxName)
          : await Hive.openBox(_boxName);
      await box.put(_kWeekdays, weekdays.toSet().toList());
      await box.put(_kHour, hour);
      await box.put(_kMinute, 0);
    } catch (_) {}
  }

  /// Convenience: default Mon/Wed/Fri
  Future<void> scheduleDailyPracticeReminder({int hour = 19}) async {
    await schedulePracticeReminders(
      weekdays: const [DateTime.monday, DateTime.wednesday, DateTime.friday],
      hour: hour,
    );
  }

  Future<void> cancelDailyPracticeReminder() async {
    if (kIsWeb) return;
    if (!_initialized) await initialize();
    for (final wd in const [
      DateTime.monday,
      DateTime.wednesday,
      DateTime.friday,
      DateTime.tuesday,
      DateTime.thursday,
      DateTime.saturday,
      DateTime.sunday
    ]) {
      try {
        await _plugin.cancel(9000 + wd);
      } catch (_) {}
    }
  }

  Future<void> cancelWeeklyPlan() async {
    if (kIsWeb) return;
    if (!_initialized) await initialize();
    final List<int> ids = <int>[1001, 1002, 1003];
    for (int h = 0; h <= 23; h++) {
      ids.add(1100 + h);
    }
    for (final id in ids) {
      try {
        await _plugin.cancel(id);
      } catch (_) {}
    }
  }

  Future<void> cancelDailySprint() async {
    if (kIsWeb) return;
    if (!_initialized) await initialize();
    for (int id = 3000; id <= 4007; id++) {
      try {
        await _plugin.cancel(id);
      } catch (_) {}
    }
  }

  tz.TZDateTime _nextInstanceOf(
      {required int weekday, required int hour, required int minute}) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    while (scheduled.weekday != weekday || !scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  Future<void> _requestPermissionsIfNeeded() async {
    if (kIsWeb) return;
    if (Platform.isIOS) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
    if (Platform.isAndroid) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if ((await android?.areNotificationsEnabled()) == false) {
        try {
          await android?.requestNotificationsPermission();
        } catch (_) {}
      }
    }
  }
}
