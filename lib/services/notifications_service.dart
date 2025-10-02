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

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  // Централизованная таблица каналов (id -> (name, description, importance))
  static const Map<String, (String name, String desc, Importance imp)>
      _channelsMeta = {
    'goal_reminder': (
      'Напоминания по целям',
      'План/середина недели и чекин',
      Importance.high,
    ),
    'gp_economy': (
      'Экономика GP',
      'Покупки, начисления и баланс GP',
      Importance.high,
    ),
    'education': (
      'Обучение',
      'Новые материалы, курсы и библиотека',
      Importance.defaultImportance,
    ),
    'chat_messages': (
      'Сообщения чатов',
      'Ответы ИИ‑тренеров и уведомления чатов',
      Importance.high,
    ),
  };

  Future<void> initialize() async {
    if (_initialized) return;
    if (kIsWeb) {
      // На Web локальные уведомления не поддерживаются
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
          // Навигация выполняется в MyApp через глобальный роутер.
          // Здесь можно сохранить маршрут в кэш/статик, если потребуется.
          // final route = data['route'];
        } catch (_) {}
      },
    );

    await _ensureAndroidChannels();
    await _requestPermissionsIfNeeded();

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

  /// Унифицированное получение маршрута запуска из:
  /// 1) pendingRoute (in-app), 2) Hive('notifications').launch_route (push), 3) системных деталей (local notif)
  /// После чтения очищает источники.
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
        route = await getLaunchRoute();
      }
      return route;
    } catch (_) {
      return null;
    }
  }

  /// Показ немедленного локального уведомления (foreground heads-up)
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
          DateTime.now().millisecondsSinceEpoch % 1000000, title, body, details,
          payload: payload);
    } catch (_) {}
  }

  String _channelName(String id) {
    switch (id) {
      case 'goal_reminder':
        return 'Напоминания по целям';
      case 'gp_economy':
        return 'Экономика GP';
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
      case 'gp_economy':
        return 'Покупки и начисления GP';
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
    if (kIsWeb) {
      // no-op на Web
      try {
        Sentry.addBreadcrumb(Breadcrumb(
          level: SentryLevel.info,
          category: 'notif',
          message: 'notif_schedule_skipped_web',
        ));
      } catch (_) {}
      return;
    }
    if (!_initialized) await initialize();
    final ch = _channelsMeta['goal_reminder']!;
    final AndroidNotificationDetails android = AndroidNotificationDetails(
      'goal_reminder',
      ch.$1,
      channelDescription: ch.$2,
      importance: ch.$3,
      priority: Priority.high,
    );
    final NotificationDetails details = NotificationDetails(android: android);

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

  /// Ежедневные уведомления для 28-дневного режима: утро и вечер
  Future<void> scheduleDailySprint({
    (int, int) morning = const (9, 0),
    (int, int) evening = const (19, 0),
  }) async {
    if (kIsWeb) return;
    if (!_initialized) await initialize();
    final ch = _channelsMeta['goal_reminder']!;
    final android = AndroidNotificationDetails(
      'goal_reminder',
      ch.$1,
      channelDescription: ch.$2,
      importance: ch.$3,
      priority: Priority.high,
    );
    final details = NotificationDetails(android: android);

    // На каждый день недели создаём расписание morning/evening
    const days = <int>[
      DateTime.monday,
      DateTime.tuesday,
      DateTime.wednesday,
      DateTime.thursday,
      DateTime.friday,
      DateTime.saturday,
      DateTime.sunday,
    ];
    for (final wd in days) {
      await _plugin.zonedSchedule(
        3000 + wd, // уникальные ID
        'День цели',
        'Проверьте задачу дня на странице «Цель»',
        _nextInstanceOf(weekday: wd, hour: morning.$1, minute: morning.$2),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: '{"route":"/goal"}',
      );
      await _plugin.zonedSchedule(
        4000 + wd,
        'Итог дня',
        'Отметьте результат дня на странице «Цель»',
        _nextInstanceOf(weekday: wd, hour: evening.$1, minute: evening.$2),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: '{"route":"/goal"}',
      );
    }
  }

  Future<void> cancelDailySprint() async {
    if (kIsWeb) return;
    if (!_initialized) await initialize();
    // Диапазон ID 3000..4007 условно
    for (int id = 3000; id <= 4007; id++) {
      try {
        await _plugin.cancel(id);
      } catch (_) {}
    }
  }

  /// Отменяет существующее расписание еженедельных напоминаний (известные ID)
  Future<void> cancelWeeklyPlan() async {
    if (kIsWeb) {
      try {
        Sentry.addBreadcrumb(Breadcrumb(
          level: SentryLevel.info,
          category: 'notif',
          message: 'notif_cancel_skipped_web',
        ));
      } catch (_) {}
      return;
    }
    if (!_initialized) await initialize();
    // Базовые ID по умолчанию
    final List<int> ids = <int>[1001, 1002, 1003];
    // Диапазон воскресных ID (10:00, 13:00, 18:00), а также на будущее — с 0..23 часов
    for (int h = 0; h <= 23; h++) {
      ids.add(1100 + h);
    }
    for (final id in ids) {
      try {
        await _plugin.cancel(id);
      } catch (_) {}
    }
  }

  /// Пересоздаёт еженедельное расписание под выбранные дни/время
  /// mon/wed/fri — кортежи (hour, minute). sunTimes — список кортежей.
  Future<void> rescheduleWeekly({
    (int, int)? mon,
    (int, int)? wed,
    (int, int)? fri,
    List<(int, int)> sunTimes = const <(int, int)>[],
  }) async {
    if (kIsWeb) {
      try {
        Sentry.addBreadcrumb(Breadcrumb(
          level: SentryLevel.info,
          category: 'notif',
          message: 'notif_reschedule_skipped_web',
        ));
      } catch (_) {}
      return;
    }
    if (!_initialized) await initialize();
    await cancelWeeklyPlan();

    final ch = _channelsMeta['goal_reminder']!;
    final AndroidNotificationDetails android = AndroidNotificationDetails(
      'goal_reminder',
      ch.$1,
      channelDescription: ch.$2,
      importance: ch.$3,
      priority: Priority.high,
    );
    final NotificationDetails details = NotificationDetails(android: android);

    Future<void> _scheduleIf(
        {required (int, int)? time,
        required int id,
        required int weekday,
        required String title,
        required String body}) async {
      if (time == null) return;
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        _nextInstanceOf(weekday: weekday, hour: time.$1, minute: time.$2),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: '{"route":"/goal"}',
      );
    }

    await _scheduleIf(
      time: mon,
      id: 1001,
      weekday: DateTime.monday,
      title: 'Новая неделя! План готов?',
      body: 'Откройте страницу «Цель» и уточните план недели',
    );

    await _scheduleIf(
      time: wed,
      id: 1002,
      weekday: DateTime.wednesday,
      title: 'Середина недели. Как прогресс?',
      body: 'Проверьте цель и отметьте прогресс',
    );

    await _scheduleIf(
      time: fri,
      id: 1003,
      weekday: DateTime.friday,
      title: 'Напоминание на выходные',
      body: 'Через два дня — чекин недели',
    );

    // Вс — один или несколько слотов
    for (final hm in sunTimes) {
      final int id = 1100 + hm.$1; // уникальный ID на основе часа
      await _plugin.zonedSchedule(
        id,
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
        message: 'notif_rescheduled_weekly_plan',
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
