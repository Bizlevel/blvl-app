import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  static const String _prefsLaunchRouteKey = 'notif_launch_route';
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  bool _permissionsRequested = false;
  bool? _lastPermissionGranted;
  Box? _launchBox;
  String? _cachedStoredRoute;

  Future<void> initialize() async {
    if (_initialized) return;
    _startupLog('notif.initialize.start');
    if (kIsWeb) {
      _initialized = true;
      _startupLog('notif.initialize.skip_web');
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
    // ВАЖНО (iOS): не запрашиваем permission на cold start.
    // Иначе в логах появляется "Requesting authorization..." + возможные фризы/деактивации сцены.
    // Разрешение просим только по явному действию пользователя (см. ensurePermissionsRequested()).
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
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
    _startupLog('notif.plugin_initialized');

    await _ensureAndroidChannels();
    _startupLog('notif.android_channels_ready');

    _initialized = true;
    _startupLog('notif.initialize.done');
  }

  /// Запрос разрешений на уведомления — **только по явному действию** (например, при сохранении напоминаний).
  ///
  /// Не вызываем на cold start, чтобы не ловить фризы/задержки и неожиданные системные диалоги.
  Future<bool> ensurePermissionsRequested() async {
    if (kIsWeb) return false;
    if (!_initialized) await initialize();
    // Если ранее уже получили "true" — не делаем лишних проверок в рамках процесса.
    // Если было "false" — разрешаем повторную попытку (пользователь мог включить в Settings).
    if (_permissionsRequested && _lastPermissionGranted == true) {
      return true;
    }
    _startupLog('notif.permissions.request.start');
    final allowed = await _requestPermissionsIfNeeded();
    _permissionsRequested = true;
    _lastPermissionGranted = allowed;
    _startupLog('notif.permissions.request.done', {'allowed': allowed});
    return allowed;
  }

  void _startupLog(String name, [Map<String, Object?> data = const {}]) {
    // Лёгкий лог, чтобы не ухудшать старты; привязан к общему стилю STARTUP[*].
    // Здесь не используем shared Stopwatch, чтобы не тянуть зависимости;
    // важнее иметь порядок/факт вызовов.
    if (kDebugMode) {
      debugPrint('STARTUP[$name] $data');
    }
  }

  void attachLaunchBox(Box box) {
    _launchBox = box;
  }

  void cacheStoredLaunchRoute(String? route) {
    if (route == null || route.isEmpty) return;
    _cachedStoredRoute = route;
  }

  Future<String?> _consumeLaunchRouteFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final route = prefs.getString(_prefsLaunchRouteKey);
      if (route == null || route.isEmpty) return null;
      await prefs.remove(_prefsLaunchRouteKey);
      return route;
    } catch (_) {
      return null;
    }
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
      // Этап 1: если пользователь локально выключил напоминания (пустые дни),
      // не перезаписываем это состояние данными из облака.
      try {
        final local = await _loadReminderPrefsFromCache();
        if (local.$1.isEmpty) {
          _logReminderStage(
              'cloud_fetch_skip_local_disabled', {'source': source});
          return;
        }
      } catch (_) {}
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
    // Этап 1: пустые дни означают "напоминания выключены" локально.
    // RPC в базе требует непустые weekdays, поэтому здесь синк пропускаем.
    if (days.isEmpty) return;
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
      // ВАЖНО: быстрый путь без Hive (чтобы не делать Hive.openBox на cold start).
      route ??= await _consumeLaunchRouteFromPrefs();
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
    bool requestPermissions = true,
    bool syncToCloud = true,
  }) async {
    if (kIsWeb) return;
    if (!_initialized) await initialize();
    final Set<int> uniqueWeekdays = weekdays.toSet();

    // Пустой набор дней = пользователь выключил напоминания.
    if (uniqueWeekdays.isEmpty) {
      await cancelDailyPracticeReminder();
      await _cacheReminderPrefs(
        <int>{},
        hour,
        minute,
        // tz.local может быть не готов, используем сохранённую или UTC.
        timezone: (await _getCachedTimezone()) ?? 'UTC',
      );
      // Обновим in-memory cache, чтобы UI сразу увидел "выключено".
      ReminderPrefsCache.instance.set(
        ReminderPrefs(weekdays: const <int>{}, hour: hour, minute: minute),
      );
      // Важно: не синкаем в Supabase (RPC требует непустые weekdays).
      return;
    }

    if (requestPermissions) {
      final allowed = await ensurePermissionsRequested();
      if (!allowed) {
        throw const NotificationsPermissionDenied();
      }
    }
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

    // Для надёжности: удаляем старые practice reminders перед созданием новых,
    // чтобы избежать "залипания" старого расписания.
    await cancelDailyPracticeReminder();

    final mode = await _resolveAndroidScheduleMode();
    for (final wd in uniqueWeekdays) {
      const idBase = 9000;
      await _plugin.zonedSchedule(
        idBase + wd,
        'Время практики',
        'Загляни в «Цель» и отметь действие сегодня',
        _nextInstanceOf(weekday: wd, hour: hour, minute: minute),
        details,
        androidScheduleMode: mode,
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
    // Обновим in-memory cache сразу после успешного расписания.
    ReminderPrefsCache.instance.set(
      ReminderPrefs(weekdays: uniqueWeekdays, hour: hour, minute: minute),
    );
    if (syncToCloud) {
      await _syncReminderPrefsToCloud(uniqueWeekdays, hour, minute);
    }
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

  Future<bool> _requestPermissionsIfNeeded() async {
    if (kIsWeb) return false;
    bool allowed = true;
    if (Platform.isIOS) {
      final res = await _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      allowed = (res ?? false);
    }
    if (Platform.isAndroid) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final before = await android?.areNotificationsEnabled();
      if (before == false) {
        try {
          await android?.requestNotificationsPermission();
        } catch (_) {}
      }
      final after = await android?.areNotificationsEnabled();
      // Если API недоступен (null) — считаем, что разрешено (старые Android/прошивки).
      allowed = (after ?? true);
    }
    return allowed;
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
      // ВАЖНО: не открываем box на холодном старте.
      // Hive.openBox может быть дорогим (блокирующий I/O) и провоцировать Hang detected.
      return null;
    } catch (e) {
      // HiveError: Hive не инициализирован — это может произойти,
      // если consumeAnyLaunchRoute() вызывается до Hive.initFlutter()
      debugPrint('WARN: NotificationsService._ensureLaunchBox failed: $e');
      return null;
    }
  }

  Future<void> persistLaunchRoute(String route) async {
    try {
      // Быстрый и безопасный storage: SharedPreferences (NSUserDefaults).
      // Hive для этой задачи избыточен и может давать долгие openBox на старте.
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsLaunchRouteKey, route);
    } catch (_) {}
  }

  Future<void> _ensureTimezoneReady() async {
    try {
      await TimezoneGate.ensureInitialized();
    } catch (error, stackTrace) {
      try {
        await Sentry.captureException(error, stackTrace: stackTrace);
      } catch (_) {}
      rethrow;
    }
  }

  Future<AndroidScheduleMode> _resolveAndroidScheduleMode() async {
    if (!Platform.isAndroid) return AndroidScheduleMode.exactAllowWhileIdle;
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return AndroidScheduleMode.exactAllowWhileIdle;

    // Android 12+ может запретить точные алармы. В этом случае выбираем inexact,
    // чтобы напоминания "приходили", пусть и не минута-в-минуту.
    try {
      final dynamic dyn = android;
      final dynamic res = await dyn.canScheduleExactNotifications();
      final bool canExact = res is bool ? res : true;
      return canExact
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle;
    } catch (_) {
      // Метод может отсутствовать на старых версиях плагина — используем прежнее поведение.
      return AndroidScheduleMode.exactAllowWhileIdle;
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

class NotificationsPermissionDenied implements Exception {
  const NotificationsPermissionDenied();
  @override
  String toString() => 'Уведомления выключены в системных настройках';
}
