import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:bizlevel/services/timezone_gate.dart';
import 'package:bizlevel/services/reminder_prefs_cache.dart';
import 'package:bizlevel/services/reminder_prefs_storage.dart';
import 'package:bizlevel/models/reminder_prefs.dart';

class NotificationsService {
  NotificationsService._();
  static final NotificationsService instance = NotificationsService._();
  static String? pendingRoute;
  bool _cloudRefreshInFlight = false;

  // Keys for local persistence
  static const String _boxName = 'notifications';
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  Box? _launchBox;
  String? _cachedStoredRoute;

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

  void attachLaunchBox(Box box) {
    _launchBox = box;
  }

  void cacheStoredLaunchRoute(String? route) {
    if (route == null || route.isEmpty) return;
    _cachedStoredRoute = route;
  }

  // Load persisted practice reminder prefs; prioritize Supabase, fallback to Hive
  Future<(Set<int> weekdays, int hour, int minute)>
      getPracticeReminderPrefs() async {
    final cached = ReminderPrefsCache.instance.current;
    if (cached != null) {
      _logReminderStage('cache_hit', {
        'weekdays': cached.weekdays.length.toString(),
        'hour': '${cached.hour}',
      });
      unawaited(_refreshCloudPrefs(source: 'cache_hit'));
      return (cached.weekdays, cached.hour, cached.minute);
    }
    final local = await _loadReminderPrefsFromCache();
    final prefs = ReminderPrefs(
      weekdays: local.$1,
      hour: local.$2,
      minute: local.$3,
    );
    ReminderPrefsCache.instance.set(prefs);
    _logReminderStage('local_loaded', {
      'weekdays': prefs.weekdays.length.toString(),
      'hour': '${prefs.hour}',
    });
    unawaited(_refreshCloudPrefs(source: 'local_fallback'));
    return local;
  }

  Future<void> prefetchReminderPrefs() async {
    try {
      final cached = await _loadReminderPrefsFromCache();
      ReminderPrefsCache.instance.set(
        ReminderPrefs(
          weekdays: cached.$1,
          hour: cached.$2,
          minute: cached.$3,
        ),
      );
      unawaited(_refreshCloudPrefs(source: 'prefetch'));
    } catch (_) {}
  }

  Future<void> _refreshCloudPrefs({String source = 'auto'}) async {
    if (_cloudRefreshInFlight) return;
    final supabaseClient = Supabase.instance.client;
    final String? userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) return;
    _cloudRefreshInFlight = true;
    try {
      _logReminderStage('cloud_fetch_start', {'source': source});
      final data = await supabaseClient
          .from('practice_reminders')
          .select('weekdays,hour,minute,timezone')
          .eq('user_id', userId)
          .maybeSingle()
          .timeout(const Duration(seconds: 2));
      if (data == null) {
        _logReminderStage('cloud_fetch_empty', {'source': source});
        return;
      }
      final List<dynamic>? rawDays = data['weekdays'] as List<dynamic>?;
      final int hour = (data['hour'] as num?)?.toInt() ?? 19;
      final int minute = (data['minute'] as num?)?.toInt() ?? 0;
      final Set<int> days = rawDays == null
          ? {DateTime.monday, DateTime.wednesday, DateTime.friday}
          : rawDays
              .map((e) => (e as num).toInt())
              .where((v) => v >= 1 && v <= 7)
              .toSet();
      final prefs = ReminderPrefs(weekdays: days, hour: hour, minute: minute);
      ReminderPrefsCache.instance.set(prefs);
      await _cacheReminderPrefs(
        days,
        hour,
        minute,
        timezone: data['timezone'] as String? ?? tz.local.name,
      );
      _logReminderStage('cloud_fetch_success', {
        'source': source,
        'weekdays': days.length.toString(),
        'hour': '$hour',
      });
    } catch (error, stackTrace) {
      _logReminderStage('cloud_fetch_error', {
        'source': source,
        'message': error.toString(),
      });
      await Sentry.captureException(error, stackTrace: stackTrace);
    } finally {
      _cloudRefreshInFlight = false;
    }
  }

  Future<(Set<int> weekdays, int hour, int minute)>
      _loadReminderPrefsFromCache() async {
    try {
      return await ReminderPrefsStorage.instance.load();
    } catch (_) {
      return ({DateTime.monday, DateTime.wednesday, DateTime.friday}, 19, 0);
    }
  }

  Future<void> _cacheReminderPrefs(
    Set<int> days,
    int hour,
    int minute, {
    String? timezone,
  }) async {
    try {
      await ReminderPrefsStorage.instance.save(
        days,
        hour,
        minute,
        timezone: timezone ?? tz.local.name,
      );
    } catch (_) {}
  }

  Future<void> _syncReminderPrefsToCloud(
      Set<int> days, int hour, int minute) async {
    final client = Supabase.instance.client;
    final userId = client.auth.currentUser?.id;
    if (userId == null) return;
    try {
      await client.rpc('upsert_practice_reminders', params: {
        'p_weekdays': days.toList(),
        'p_hour': hour,
        'p_minute': minute,
        'p_timezone': (await _getCachedTimezone()) ?? tz.local.name,
        'p_source': 'mobile',
      });
    } catch (error, stackTrace) {
      await Sentry.captureException(error, stackTrace: stackTrace);
    }
  }

  Future<String?> _getCachedTimezone() async =>
      ReminderPrefsStorage.instance.loadTimezone();

  Future<String?> consumeAnyLaunchRoute() async {
    try {
      String? route;
      if (pendingRoute != null && pendingRoute!.isNotEmpty) {
        route = pendingRoute;
        pendingRoute = null;
      }
      if (route == null && _cachedStoredRoute != null) {
        route = _cachedStoredRoute;
        _cachedStoredRoute = null;
      }
      if (route == null) {
        final box = await _ensureLaunchBox();
        if (box != null) {
          final stored = box.get('launch_route');
          if (stored is String && stored.isNotEmpty) {
            route = stored;
            await box.delete('launch_route');
          }
        }
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

  /// Schedule reminders at selected weekdays (IDs: Monday..Sunday) and hour/minute
  Future<void> schedulePracticeReminders({
    required List<int> weekdays,
    int hour = 19,
    int minute = 0,
  }) async {
    if (kIsWeb) return;
    if (!_initialized) await initialize();
    await _ensureTimezoneReady();
    const channelId = 'goal_reminder';
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      channelId,
      'Напоминания по целям',
      channelDescription: 'План недели, середина недели и чекин',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: android);
    final Set<int> uniqueWeekdays = weekdays.toSet();
    for (final wd in uniqueWeekdays) {
      const idBase = 9000;
      await _plugin.zonedSchedule(
        idBase + wd,
        'Время практики',
        'Загляни в «Цель» и отметь действие сегодня',
        _nextInstanceOf(weekday: wd, hour: hour, minute: minute),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: '{"route":"/goal"}',
      );
    }
    await _cacheReminderPrefs(
      uniqueWeekdays,
      hour,
      minute,
      timezone: tz.local.name,
    );
    await _syncReminderPrefsToCloud(uniqueWeekdays, hour, minute);
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

  /// Возвращает Hive box для launch route, или null если Hive не инициализирован.
  /// ВАЖНО: Hive.initFlutter() должен быть вызван в main() ДО runApp()!
  Future<Box?> _ensureLaunchBox() async {
    try {
      if (_launchBox != null && _launchBox!.isOpen) {
        return _launchBox!;
      }
      if (Hive.isBoxOpen(_boxName)) {
        _launchBox = Hive.box(_boxName);
        return _launchBox!;
      }
      _launchBox = await Hive.openBox(_boxName);
      return _launchBox!;
    } catch (e) {
      // HiveError: Hive не инициализирован — это может произойти,
      // если consumeAnyLaunchRoute() вызывается до Hive.initFlutter()
      debugPrint('WARN: NotificationsService._ensureLaunchBox failed: $e');
      return null;
    }
  }

  Future<void> persistLaunchRoute(String route) async {
    try {
      final box = await _ensureLaunchBox();
      if (box != null) {
        await box.put('launch_route', route);
      }
    } catch (_) {}
  }

  Future<void> _ensureTimezoneReady() async {
    try {
      await TimezoneGate.waitUntilReady();
    } catch (error, stackTrace) {
      try {
        await Sentry.captureException(error, stackTrace: stackTrace);
      } catch (_) {}
    }
  }

  void _logReminderStage(String stage, [Map<String, String>? data]) {
    final payload = data ?? const <String, String>{};
    debugPrint('REMINDER_PREFS[$stage] $payload');
    try {
      Sentry.addBreadcrumb(
        Breadcrumb(
          category: 'notif.reminder_prefs',
          message: stage,
          level: SentryLevel.info,
          data: payload,
        ),
      );
    } catch (_) {}
  }
}
