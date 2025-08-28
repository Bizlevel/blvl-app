import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationsService {
  NotificationsService._();
  static final NotificationsService instance = NotificationsService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('ic_launcher');
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );
    await _plugin.initialize(initSettings);

    if (Platform.isIOS) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
    _initialized = true;
  }

  Future<void> scheduleWeeklyPlan() async {
    if (!_initialized) await initialize();
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      'goal_weekly_channel',
      'Расписание цели',
      channelDescription: 'Напоминания о цели и чекине недели',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails details = NotificationDetails(android: android);

    // Пн 09:00
    await _plugin.zonedSchedule(
      1001,
      'Новая неделя! План готов?',
      'Откройте страницу «Цель» и уточните план недели',
      _nextInstanceOf(weekday: DateTime.monday, hour: 9, minute: 0),
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );

    // Ср 14:00
    await _plugin.zonedSchedule(
      1002,
      'Середина недели. Как прогресс?',
      'Проверьте цель и отметьте прогресс',
      _nextInstanceOf(weekday: DateTime.wednesday, hour: 14, minute: 0),
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );

    // Пт 16:00
    await _plugin.zonedSchedule(
      1003,
      'Напоминание на выходные',
      'Через два дня — чекин недели',
      _nextInstanceOf(weekday: DateTime.friday, hour: 16, minute: 0),
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );

    // Вс 10:00 / 13:00 / 18:00
    for (final hm in const [(10, 0), (13, 0), (18, 0)]) {
      await _plugin.zonedSchedule(
        1100 + hm.$1,
        'Время недельного чекина',
        'Заполните итоги недели на странице «Цель»',
        _nextInstanceOf(weekday: DateTime.sunday, hour: hm.$1, minute: hm.$2),
        details,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
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
}
