// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'utils/env_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'compat/url_strategy_noop.dart'
    if (dart.library.html) 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';
import 'dart:developer' as dev;
import 'utils/deep_link.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'routing/app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'services/supabase_service.dart';
import 'theme/color.dart';
import 'theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bizlevel/services/notifications_service.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:bizlevel/services/timezone_gate.dart';
import 'services/push_service.dart';
import 'constants/push_flags.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:crypto/crypto.dart' as crypto;

bool _hiveInitialized = false;
bool _pushInitStarted = false;
StreamSubscription<AuthState>? _authStateSub;
bool _postFrameBootstrapsScheduled = false;
const bool _kDisableSentryDefine =
    bool.fromEnvironment('DISABLE_SENTRY', defaultValue: false);

bool _isSentryDisabled() {
  final envValue = dotenv.isInitialized
      ? (dotenv.env['DISABLE_SENTRY'] ?? dotenv.env['disable_sentry'])
      : null;
  final envFlag = envValue != null &&
      const ['true', '1', 'yes'].contains(envValue.toLowerCase());
  return _kDisableSentryDefine || envFlag;
}

/// Критический bootstrap, который раньше блокировал LaunchScreen из-за await до runApp().
///
/// Стратегия A: показываем Flutter UI сразу, а dotenv/Supabase/Hive инициализируем
/// уже на Flutter-экране (Bootscreen). Так LaunchScreen исчезает быстро.
final appBootstrapProvider = FutureProvider<void>((ref) async {
  // Загружаем env (может быть нужно для Supabase/Sentry/OneSignal ключей).
  try {
    await dotenv.load();
  } catch (_) {}

  // Supabase init — нужен до построения GoRouter (router читает currentSession).
  await SupabaseService.initialize();
  debugPrint('INFO: Supabase bootstrap completed');

  // Hive нужен NotificationsService (и части репозиториев/кэша).
  await _ensureHiveInitialized();
  debugPrint('INFO: Hive bootstrap completed');
});

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Чистые URL без # — только для Web
  if (kIsWeb) {
    setUrlStrategy(PathUrlStrategy());
  }

  // runApp() — сразу. Всё тяжёлое переносим в appBootstrapProvider.
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootstrap = ref.watch(appBootstrapProvider);
    return bootstrap.when(
      loading: () => _BootstrapApp(themeMode: ref.watch(themeModeProvider)),
      error: (error, _) => _BootstrapErrorApp(
        themeMode: ref.watch(themeModeProvider),
        error: error,
        onRetry: () => ref.invalidate(appBootstrapProvider),
      ),
      data: (_) {
        final GoRouter router = ref.watch(goRouterProvider);
        return _PostBootstrapRunner(
          child: _LinkListener(
            router: router,
            child: _RouterApp(
              router: router,
              themeMode: ref.watch(themeModeProvider),
            ),
          ),
        );
      },
    );
  }
}

void _schedulePostFrameBootstraps() {
  if (_postFrameBootstrapsScheduled) return;
  _postFrameBootstrapsScheduled = true;
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    if (kIsWeb) return;

    // Sentry — можно отключить через DISABLE_SENTRY (env/fromEnvironment)
    if (!_isSentryDisabled()) {
      final dsn = envOrDefine('SENTRY_DSN');
      if (dsn.isNotEmpty) {
        try {
          await _prewarmSentryCache(dsn);
          await _initializeSentry(dsn);
        } catch (e) {
          debugPrint('WARN: Sentry deferred init failed: $e');
        }
      }
    } else {
      debugPrint('INFO: Sentry initialization skipped (DISABLE_SENTRY=true)');
    }

    await _initializeDeferredLocalServices();

    // Обработка launch route от уведомлений — ПОСЛЕ инициализации Hive!
    // Раньше это было в FutureBuilder в MyApp.build(), но вызывало HiveError.
    await _handleNotificationLaunchRoute();

    _setupPushInitOnAuth();
  });
}

class _BootstrapApp extends StatelessWidget {
  final ThemeMode themeMode;
  const _BootstrapApp({required this.themeMode});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BizLevel',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      home: const _BootstrapScreen(),
    );
  }
}

class _BootstrapErrorApp extends StatelessWidget {
  final ThemeMode themeMode;
  final Object error;
  final VoidCallback onRetry;
  const _BootstrapErrorApp({
    required this.themeMode,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BizLevel',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      home: _BootstrapErrorScreen(error: error, onRetry: onRetry),
    );
  }
}

class _BootstrapScreen extends StatelessWidget {
  const _BootstrapScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(context).brightness == Brightness.dark
              ? AppColor.bgGradientDark
              : AppColor.bgGradient,
        ),
        child: const SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Загрузка BizLevel…'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BootstrapErrorScreen extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;
  const _BootstrapErrorScreen({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(context).brightness == Brightness.dark
              ? AppColor.bgGradientDark
              : AppColor.bgGradient,
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Не удалось запустить приложение',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: onRetry,
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PostBootstrapRunner extends StatefulWidget {
  final Widget child;
  const _PostBootstrapRunner({required this.child});

  @override
  State<_PostBootstrapRunner> createState() => _PostBootstrapRunnerState();
}

class _PostBootstrapRunnerState extends State<_PostBootstrapRunner> {
  @override
  void initState() {
    super.initState();
    // Запускаем тяжёлые операции (Sentry/notifications/timezone/push) только
    // после успешного bootstrap и после первого кадра реального UI (login/home).
    _schedulePostFrameBootstraps();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _RouterApp extends StatelessWidget {
  final GoRouter router;
  final ThemeMode themeMode;
  const _RouterApp({required this.router, required this.themeMode});

  @override
  Widget build(BuildContext context) {
    // Простая эвристика low-end устройства: низкий DPR или отключённая анимация ОС
    final bool lowDpr = MediaQuery.of(context).devicePixelRatio < 2.0;
    final bool disableAnimations = View.of(context)
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;
    final bool isLowEndDevice = lowDpr || disableAnimations;

    return MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru'),
        Locale('en'),
      ],
      // Локализации делегируем системным настройкам; ru-параметры передаются напрямую в showDatePicker
      builder: (context, child) {
        // создаём ResponsiveWrapper как обычно
        if (child == null) {
          return const SizedBox.shrink();
        }
        final wrapped = ResponsiveBreakpoints.builder(
          child: BouncingScrollWrapper.builder(context, child),
          breakpoints: const [
            Breakpoint(start: 0, end: 599, name: MOBILE),
            Breakpoint(start: 600, end: 1023, name: TABLET),
            Breakpoint(start: 1024, end: double.infinity, name: DESKTOP),
          ],
        );

        // увеличиваем базовый размер шрифта на desktop (>=1024)
        final bool isDesktop = MediaQuery.of(context).size.width >= 1024;
        final textTheme = Theme.of(context).textTheme;
        final scaledTextTheme = isDesktop
            ? textTheme.copyWith(
                displayLarge: textTheme.displayLarge?.copyWith(
                    fontSize: (textTheme.displayLarge?.fontSize ?? 24) + 2),
                bodyMedium: textTheme.bodyMedium?.copyWith(
                    fontSize: (textTheme.bodyMedium?.fontSize ?? 14) + 2),
              )
            : textTheme;

        return Container(
          decoration: BoxDecoration(
            gradient: Theme.of(context).brightness == Brightness.dark
                ? AppColor.bgGradientDark
                : AppColor.bgGradient,
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              textTheme: scaledTextTheme,
              scaffoldBackgroundColor: Colors.transparent,
              // Глобально уменьшаем длительность анимаций на low-end
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                for (final platform in TargetPlatform.values)
                  platform: isLowEndDevice
                      ? const ZoomPageTransitionsBuilder()
                      : const FadeUpwardsPageTransitionsBuilder(),
              }),
            ),
            // Launch route от уведомлений обрабатывается в _schedulePostFrameBootstraps()
            // после полной инициализации Hive. FutureBuilder здесь вызывал HiveError.
            child: wrapped,
          ),
        );
      },
      debugShowCheckedModeBanner: false,
      title: 'BizLevel',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      // Навигатор теперь управляется GoRouter; SentryObserver добавлен в конфигурацию роутера
    );
  }
}

Future<void> _initPushes() async {
  try {
    if (!kEnableIosPush && defaultTargetPlatform == TargetPlatform.iOS) {
      debugPrint('INFO: iOS PushService skipped (kEnableIosPush=false)');
      return;
    }
    await PushService.instance.initialize();
  } catch (error, stackTrace) {
    debugPrint('WARN: PushService init failed: $error');
    if (!_isSentryDisabled()) {
      await Sentry.captureException(error, stackTrace: stackTrace);
    }
  }
}

/// Инициализирует OneSignal только после успешной аутентификации.
void _setupPushInitOnAuth() {
  if (kIsWeb) return;
  final client = Supabase.instance.client;

  Future<void> trigger(Session? session) async {
    if (session?.user == null) return;
    if (_pushInitStarted) return;
    _pushInitStarted = true;
    unawaited(_initPushes());
  }

  final initialSession = client.auth.currentSession;
  if (initialSession != null) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(trigger(initialSession));
    });
  }

  _authStateSub?.cancel();
  _authStateSub = client.auth.onAuthStateChange.listen((event) {
    unawaited(trigger(event.session));
  });
}

/// Обрабатывает launch route от уведомлений после полной инициализации.
Future<void> _handleNotificationLaunchRoute() async {
  try {
    final route = await NotificationsService.instance.consumeAnyLaunchRoute();
    if (route != null && route.isNotEmpty) {
      debugPrint('INFO: Navigating to launch route: $route');
      // Используем глобальный navigatorKey из GoRouter
      final navigator = rootNavigatorKey.currentState;
      if (navigator != null && navigator.mounted) {
        // GoRouter.of требует context, используем navigator.context
        GoRouter.of(navigator.context).go(route);
      }
    }
  } catch (e) {
    debugPrint('WARN: Failed to handle notification launch route: $e');
  }
}

Future<void> _initializeSentry(String dsn) async {
  if (_isSentryDisabled()) {
    debugPrint('INFO: Sentry init skipped (DISABLE_SENTRY=true)');
    return;
  }
  try {
    final packageInfo = await PackageInfo.fromPlatform();
    await SentryFlutter.init(
      (options) {
        options
          ..dsn = dsn
          ..tracesSampleRate = kReleaseMode ? 0.3 : 1.0
          ..environment = kReleaseMode ? 'prod' : 'dev'
          ..release =
              'bizlevel@${packageInfo.version}+${packageInfo.buildNumber}'
          ..enableAutoSessionTracking = false
          ..attachScreenshot = true
          ..attachViewHierarchy = true
          ..enableAutoPerformanceTracing = false
          ..enableTimeToFullDisplayTracing = false
          ..enableAppHangTracking = false
          ..enableWatchdogTerminationTracking = false
          ..enableFramesTracking = false
          ..enableAutoNativeBreadcrumbs = false
          ..enableAppLifecycleBreadcrumbs = false
          ..enableWindowMetricBreadcrumbs = false
          ..enableUserInteractionBreadcrumbs = false
          ..enableUserInteractionTracing = false
          ..addInAppExclude('SentryFileIOTrackingIntegration')
          ..beforeSend = (SentryEvent event, Hint hint) {
            event.request?.headers
                .removeWhere((k, _) => k.toLowerCase() == 'authorization');
            return event;
          };
      },
    );
  } catch (error, stackTrace) {
    debugPrint('WARN: Sentry init failed: $error');
    if (!_isSentryDisabled()) {
      await Sentry.captureException(error, stackTrace: stackTrace);
    }
  }
}

Future<void> _prewarmSentryCache(String dsn) async {
  if (kIsWeb || !Platform.isIOS) return;
  try {
    final libraryDir = await getLibraryDirectory();
    final cachesRoot = Directory(p.join(libraryDir.path, 'Caches'));
    final hash = crypto.sha1.convert(utf8.encode(dsn)).toString();
    final sentryPath = p.join(cachesRoot.path, 'io.sentry', hash);
    final envelopesPath = p.join(sentryPath, 'envelopes');
    // Выполняем блокирующий I/O в отдельном изоляте, чтобы не задевать UI-поток.
    await Isolate.run(() {
      Directory(sentryPath).createSync(recursive: true);
      Directory(envelopesPath).createSync(recursive: true);
    });
  } catch (error) {
    debugPrint('WARN: Failed to prewarm Sentry cache: $error');
  }
}

Future<void> _initializeDeferredLocalServices() async {
  if (kIsWeb) return;
  ISentrySpan? transaction;
  dev.Timeline.startSync('startup.local_services');
  try {
    if (!_isSentryDisabled()) {
      transaction = Sentry.startTransaction(
        'startup.local_services',
        'task',
        trimEnd: true,
      );
    }
    final hiveSpan = transaction?.startChild('local.hive_init');
    final tzSpan = transaction?.startChild('local.timezone_init');
    final notifSpan = transaction?.startChild('local.notifications_init');

    await Future.wait([
      _ensureHiveInitialized().whenComplete(() => hiveSpan?.finish()),
      _warmUpTimezone().whenComplete(() => tzSpan?.finish()),
      _initializeNotifications().whenComplete(() => notifSpan?.finish()),
      _preloadNotificationsLaunchData(), // Перенесено из main()
    ]);
    transaction?.finish(status: const SpanStatus.ok());
  } catch (error, stackTrace) {
    transaction?.finish(status: const SpanStatus.internalError());
    debugPrint('WARN: Deferred local services failed: $error');
    if (!_isSentryDisabled()) {
      await Sentry.captureException(error, stackTrace: stackTrace);
    }
  } finally {
    dev.Timeline.finishSync();
  }
}

Future<void> _ensureHiveInitialized() async {
  if (_hiveInitialized) {
    debugPrint('INFO: Hive already initialized, skipping');
    return;
  }
  if (kIsWeb) {
    debugPrint('INFO: Hive skipped on web');
    return;
  }
  try {
    debugPrint('INFO: Hive.initFlutter() starting...');
    await Hive.initFlutter();
    _hiveInitialized = true;
    debugPrint('INFO: Hive.initFlutter() completed successfully');
  } catch (e, st) {
    debugPrint('ERROR: Hive.initFlutter() failed: $e');
    debugPrint('Stack trace: $st');
    // Пробуем инициализировать с явным путём
    try {
      final dir = await getApplicationDocumentsDirectory();
      final hivePath = p.join(dir.path, 'hive');
      Hive.init(hivePath);
      _hiveInitialized = true;
      debugPrint('INFO: Hive.init() with explicit path succeeded');
    } catch (e2) {
      debugPrint('ERROR: Hive.init() with explicit path also failed: $e2');
    }
  }
}

Future<void> _openHiveBoxes() async {
  if (kIsWeb) return;
  const boxes = [
    'levels',
    'lessons',
    'goals',
    'user_goal',
    'practice_log',
    'quotes',
    'gp',
    'notifications',
  ];
  final futures = <Future>[];
  for (final box in boxes) {
    if (!Hive.isBoxOpen(box)) {
      futures.add(Hive.openBox(box));
    }
  }
  if (futures.isNotEmpty) {
    await Future.wait(futures);
  }
}

Future<void> _warmUpTimezone() async {
  try {
    tzdata.initializeTimeZones();
    final timeZoneInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneInfo.identifier));
    TimezoneGate.markReady();
  } catch (error, stackTrace) {
    TimezoneGate.markError(error, stackTrace);
    rethrow;
  }
}

Future<void> _initializeNotifications() async {
  await _openHiveBoxes();
  if (!kIsWeb && Hive.isBoxOpen('notifications')) {
    NotificationsService.instance.attachLaunchBox(Hive.box('notifications'));
  }
  await NotificationsService.instance.initialize();
  await NotificationsService.instance.prefetchReminderPrefs();
}

Future<void> _preloadNotificationsLaunchData() async {
  if (kIsWeb) return;
  try {
    final box = Hive.isBoxOpen('notifications')
        ? Hive.box('notifications')
        : await Hive.openBox('notifications');
    NotificationsService.instance.attachLaunchBox(box);
    final stored = box.get('launch_route');
    if (stored is String && stored.isNotEmpty) {
      await box.delete('launch_route');
      NotificationsService.instance.cacheStoredLaunchRoute(stored);
    }
  } catch (_) {}
}

class _LinkListener extends StatefulWidget {
  final GoRouter router;
  final Widget child;
  const _LinkListener({required this.router, required this.child});

  @override
  State<_LinkListener> createState() => _LinkListenerState();
}

class _LinkListenerState extends State<_LinkListener> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initDeepLinks() async {
    // Listen to all incoming links
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleLinkUri(uri);
    });

    // Get the initial link
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _handleLinkUri(initialUri);
    }
  }

  void _handleLinkUri(Uri uri) {
    final path = mapBizLevelDeepLink(uri.toString());
    if (path != null) {
      widget.router.go(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
