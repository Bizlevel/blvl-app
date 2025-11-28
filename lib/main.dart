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

import 'package:firebase_core/firebase_core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:crypto/crypto.dart' as crypto;

bool _hiveInitialized = false;

Future<void> main() async {
  // КРИТИЧНО для web: Все инициализации должны быть в одной зоне
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    debugPrint('INFO: Firebase bootstrap deferred to post-frame stage');
  }

  // Чистые URL без # — только для Web
  if (kIsWeb) {
    setUrlStrategy(PathUrlStrategy());
  }

  // Загружаем переменные окружения (если файл есть)
  try {
    await dotenv.load();
  } catch (_) {}

  // Инициализируем Supabase
  await SupabaseService.initialize();

  await _ensureHiveInitialized();
  await _preloadNotificationsLaunchData();

  const rootApp = ProviderScope(child: MyApp());

  final dsn = envOrDefine('SENTRY_DSN');
  if (dsn.isEmpty) {
    debugPrint('INFO: Sentry DSN not configured, running without Sentry');
  } else {
    await _prewarmSentryCache(dsn);
    await _initializeSentry(dsn);
  }

  runApp(rootApp);
  _schedulePostFrameBootstraps();
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter router = ref.watch(goRouterProvider);
    // Простая эвристика low-end устройства: низкий DPR или отключённая анимация ОС
    final bool lowDpr = MediaQuery.of(context).devicePixelRatio < 2.0;
    final bool disableAnimations = View.of(context)
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;
    final bool isLowEndDevice =
        lowDpr || disableAnimations; // reserved for global gating

    return _LinkListener(
      router: router,
      child: MaterialApp.router(
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
              child: FutureBuilder<String?>(
                future: NotificationsService.instance.consumeAnyLaunchRoute(),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.done &&
                      snap.data != null &&
                      snap.data!.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      try {
                        router.go(snap.data!);
                      } catch (_) {}
                    });
                  }
                  return wrapped;
                },
              ),
            ),
          );
        },
        debugShowCheckedModeBanner: false,
        title: 'BizLevel',
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ref.watch(themeModeProvider),
        // Навигатор теперь управляется GoRouter; SentryObserver добавлен в конфигурацию роутера
      ),
    );
  }
}

void _schedulePostFrameBootstraps() {
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    if (kIsWeb) return;
    await _ensureFirebaseInitialized('post_frame_bootstrap');
    await _initializeDeferredLocalServices();
    final bool runningOniOS =
        defaultTargetPlatform == TargetPlatform.iOS && !kIsWeb;
    if (kEnableIosFcm || !runningOniOS) {
      try {
        await PushService.instance.initialize();
      } catch (error, stackTrace) {
        debugPrint('WARN: PushService init failed: $error');
        await Sentry.captureException(error, stackTrace: stackTrace);
      }
    } else {
      debugPrint('INFO: iOS PushService skipped (kEnableIosFcm=false)');
    }
  });
}

Future<void> _initializeSentry(String dsn) async {
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
    await Sentry.captureException(error, stackTrace: stackTrace);
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

Future<void> _ensureFirebaseInitialized(String caller) async {
  if (kIsWeb) return;
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
      debugPrint('INFO: Firebase.initializeApp() completed ($caller)');
    }
  } catch (e) {
    debugPrint('WARN: Firebase initialize failed ($caller): $e');
  }
}

Future<void> _initializeDeferredLocalServices() async {
  if (kIsWeb) return;
  ISentrySpan? transaction;
  dev.Timeline.startSync('startup.local_services');
  try {
    transaction = Sentry.startTransaction(
      'startup.local_services',
      'task',
      trimEnd: true,
    );
    final hiveSpan = transaction.startChild('local.hive_init');
    final tzSpan = transaction.startChild('local.timezone_init');
    final notifSpan = transaction.startChild('local.notifications_init');

    await Future.wait([
      _ensureHiveInitialized().whenComplete(() => hiveSpan.finish()),
      _warmUpTimezone().whenComplete(() => tzSpan.finish()),
      _initializeNotifications().whenComplete(() => notifSpan.finish()),
    ]);
    transaction.finish(status: const SpanStatus.ok());
  } catch (error, stackTrace) {
    transaction?.finish(status: const SpanStatus.internalError());
    debugPrint('WARN: Deferred local services failed: $error');
    await Sentry.captureException(error, stackTrace: stackTrace);
  } finally {
    dev.Timeline.finishSync();
  }
}

Future<void> _ensureHiveInitialized() async {
  if (_hiveInitialized || kIsWeb) {
    return;
  }
  await Hive.initFlutter();
  _hiveInitialized = true;
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
