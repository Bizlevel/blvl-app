import 'dart:convert';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:sentry_flutter/sentry_flutter.dart';

class NotificationsService {
  NotificationsService._();
  static final NotificationsService instance = NotificationsService._();
  static String? pendingRoute;

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
          // Навигация выполняется в MyApp через глобальный роутер.
          // Здесь можно сохранить маршрут в кэш/статик, если потребуется.
          // final route = data['route'];
        } catch (_) {}
      },
    );

    await _ensureAndroidChannels();

    if (Platform.isIOS) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
    if (Platform.isAndroid) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      // Guard: только Android 13+
      if ((await android?.areNotificationsEnabled()) == false) {
        try {
          await android?.requestNotificationsPermission();
        } catch (_) {}
      }
    }
    _initialized = true;
  }

  /// Возвращает маршрут, если приложение запущено тапом по уведомлению
  Future<String?> getLaunchRoute() async {
    try {
      final details = await _plugin.getNotificationAppLaunchDetails();
      final payload = details?.notificationResponse?.payload;
      if (payload == null) return null;
      final data = json.decode(payload) as Map<String, dynamic>;
      final route = data['route']?.toString();
      return (route != null && route.isNotEmpty) ? route : null;
    } catch (_) {
      return null;
    }
  }

  Future<void> _ensureAndroidChannels() async {
    if (!Platform.isAndroid) return;
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return;
    try {
      await android.createNotificationChannel(const AndroidNotificationChannel(
        'goal_critical',
        'Критичные по целям',
        description: 'Важные дедлайны и критичные напоминания по целям',
        importance: Importance.max,
      ));
      await android.createNotificationChannel(const AndroidNotificationChannel(
        'goal_reminder',
        'Напоминания по целям',
        description: 'План недели, середина недели и чекин',
        importance: Importance.high,
      ));
      await android.createNotificationChannel(const AndroidNotificationChannel(
        'gp_economy',
        'Экономика GP',
        description: 'Покупки, начисления и баланс GP',
        importance: Importance.high,
      ));
      await android.createNotificationChannel(const AndroidNotificationChannel(
        'education',
        'Обучение',
        description: 'Новые материалы, курсы и библиотека',
        importance: Importance.defaultImportance,
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

  Future<void> scheduleWeeklyPlan() async {
    if (!_initialized) await initialize();
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      'goal_reminder',
      'Напоминания по целям',
      channelDescription: 'План/середина недели и чекин',
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
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: '{"route":"/goal"}',
    );

    // Ср 14:00
    await _plugin.zonedSchedule(
      1002,
      'Середина недели. Как прогресс?',
      'Проверьте цель и отметьте прогресс',
      _nextInstanceOf(weekday: DateTime.wednesday, hour: 14, minute: 0),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: '{"route":"/goal"}',
    );

    // Пт 16:00
    await _plugin.zonedSchedule(
      1003,
      'Напоминание на выходные',
      'Через два дня — чекин недели',
      _nextInstanceOf(weekday: DateTime.friday, hour: 16, minute: 0),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: '{"route":"/goal"}',
    );

    // Вс 10:00 / 13:00 / 18:00
    for (final hm in const [(10, 0), (13, 0), (18, 0)]) {
      await _plugin.zonedSchedule(
        1100 + hm.$1,
        'Время недельного чекина',
        'Заполните итоги недели на странице «Цель»',
        _nextInstanceOf(weekday: DateTime.sunday, hour: hm.$1, minute: hm.$2),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: '{"route":"/goal"}',
      );
    }
    try {
      Sentry.addBreadcrumb(Breadcrumb(
        level: SentryLevel.info,
        category: 'notif',
        message: 'notif_scheduled_weekly_plan',
      ));
    } catch (_) {}
  }

  /// Однократное локальное уведомление «Новые материалы в библиотеке»
  Future<void> showLibraryDigestOnce() async {
    if (!_initialized) await initialize();
    const android = AndroidNotificationDetails(
      'education',
      'Обучение',
      channelDescription: 'Новые материалы, курсы и библиотека',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    const details = NotificationDetails(android: android);
    await _plugin.show(
      2001,
      '📚 Новые материалы в библиотеке',
      'Откройте «Библиотеку», чтобы посмотреть обновления',
      details,
      payload: '{"route":"/library"}',
    );
    try {
      Sentry.addBreadcrumb(Breadcrumb(
        level: SentryLevel.info,
        category: 'notif',
        message: 'notif_library_digest_shown',
      ));
    } catch (_) {}
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
