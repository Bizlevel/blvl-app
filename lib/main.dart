// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'utils/env_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'compat/url_strategy_noop.dart'
    if (dart.library.html) 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';
import 'utils/deep_link.dart';

import 'routing/app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'services/supabase_service.dart';
import 'theme/color.dart';
import 'theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'theme/dynamic_theme_builder.dart';
import 'package:bizlevel/services/notifications_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'services/push_service.dart';
import 'providers/auth_provider.dart';
import 'models/user_model.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

const String _appVersion = String.fromEnvironment(
  'APP_VERSION',
  defaultValue: 'dev',
);
const String _appBuild = String.fromEnvironment('APP_BUILD', defaultValue: '0');

/// Краткий отчёт о старте приложения: сколько занял каждый шаг.
class BootstrapReport {
  BootstrapReport(this.timings);
  final Map<String, int> timings;
}

Future<BootstrapReport> _runBootstrap() async {
  final timings = <String, int>{};

  Future<void> measure(
    String label,
    Future<void> Function() task, {
    bool fatal = false,
  }) async {
    final sw = Stopwatch()..start();
    try {
      await task();
      debugPrint('BOOTSTRAP [$label] done in ${sw.elapsedMilliseconds}ms');
    } catch (error, stack) {
      debugPrint('BOOTSTRAP [$label] failed: $error');
      if (fatal) {
        Error.throwWithStackTrace(error, stack);
      }
    } finally {
      timings[label] = sw.elapsedMilliseconds;
    }
  }

  await measure('dotenv', () async {
    await dotenv.load();
  });

  await measure('supabase', () async {
    await SupabaseService.initialize();
  }, fatal: true);

  await measure('firebase', () async {
    final bool isIos = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
    if (kIsWeb) {
      _completeFirebaseInit();
      return;
    }
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
      if (!kIsWeb && !isIos) {
        await FirebaseMessaging.instance.setAutoInitEnabled(false);
      }
      _completeFirebaseInit();
    } catch (error, stack) {
      _completeFirebaseInit(error: error, stackTrace: stack);
      rethrow;
    }
  });

  return BootstrapReport(Map.unmodifiable(timings));
}

/// Показывает сплэш / ошибку, пока обязательный bootstrap ещё выполняется.
class BootstrapGate extends StatefulWidget {
  const BootstrapGate({super.key});

  @override
  State<BootstrapGate> createState() => _BootstrapGateState();
}

class _BootstrapGateState extends State<BootstrapGate> {
  bool _postBootstrapScheduled = false;
  late Future<BootstrapReport> _bootstrapFuture;

  @override
  void initState() {
    super.initState();
    _bootstrapFuture = _runBootstrap();
  }

  void _restartBootstrap() {
    setState(() {
      _postBootstrapScheduled = false;
      _bootstrapFuture = _runBootstrap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BootstrapReport>(
      future: _bootstrapFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _BootstrapSplash();
        }
        if (snapshot.hasError) {
          return _BootstrapErrorScreen(
            error: snapshot.error!,
            onRetry: _restartBootstrap,
          );
        }
        final report = snapshot.data!;
        if (!_postBootstrapScheduled) {
          _postBootstrapScheduled = true;
          debugPrint('BOOTSTRAP timings: ${report.timings}');
          // не блокируем build: планируем пост-инициализацию
          // ignore: discarded_futures
          _bootstrapAfterFirstFrame();
        }
        return const MyApp();
      },
    );
  }
}

class _BootstrapSplash extends StatelessWidget {
  const _BootstrapSplash();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: AppColor.bgGradient),
          child: const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 56,
                  height: 56,
                  child: CircularProgressIndicator(),
                ),
                SizedBox(height: 16),
                Text(
                  'Подготавливаем BizLevel…',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BootstrapErrorScreen extends StatelessWidget {
  const _BootstrapErrorScreen({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Не удалось подготовить приложение.\n$error',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('Повторить'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> main() async {
  FlutterError.onError = (details) {
    debugPrint('FlutterError: ${details.exceptionAsString()}');
  };
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      runApp(const ProviderScope(child: BootstrapGate()));
    },
    (error, stack) {
      debugPrint('Uncaught (zone): $error');
    },
  );
}

// Пытаемся инициализировать Firebase, но не падаем, если конфиг отсутствует.
final Completer<void> _firebaseInitCompleter = Completer<void>();
bool _backgroundServicesScheduled = false;
bool _iosMessagingRegistered = false;

void _completeFirebaseInit({Object? error, StackTrace? stackTrace}) {
  if (_firebaseInitCompleter.isCompleted) {
    return;
  }
  if (error != null) {
    _firebaseInitCompleter.completeError(
      error,
      stackTrace ?? StackTrace.current,
    );
  } else {
    _firebaseInitCompleter.complete();
  }
}

void _scheduleDeferredTask(
  String label,
  Future<void> Function() task, {
  Duration delay = Duration.zero,
}) {
  unawaited(
    Future<void>(() async {
      if (delay > Duration.zero) {
        await Future.delayed(delay);
      }
      final sw = Stopwatch()..start();
      try {
        await task();
        debugPrint('POSTBOOT [$label] done in ${sw.elapsedMilliseconds}ms');
      } catch (error, stack) {
        debugPrint('POSTBOOT [$label] failed: $error');
        debugPrint('$stack');
      }
    }),
  );
}

void _scheduleBackgroundServices() {
  if (_backgroundServicesScheduled || kIsWeb) {
    return;
  }
  _backgroundServicesScheduled = true;

  Future<void>.delayed(const Duration(seconds: 3), () async {
    try {
      await _prepareLocalNotifications();
    } catch (_) {}
  });

  Future<void>.delayed(const Duration(seconds: 5), () async {
    try {
      await _firebaseInitCompleter.future;
    } catch (_) {}
    try {
      await PushService.instance.initialize();
    } catch (_) {}
  });
}

// Фоновая инициализация сервисов после первого кадра.
Future<void> _bootstrapAfterFirstFrame() async {
  // Ждём первый кадр и переносим тяжёлые операции в фон.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (kIsWeb) {
      setUrlStrategy(PathUrlStrategy());
      _completeFirebaseInit();
    }

    unawaited(_ensureIosMessagingRegistered());

    _scheduleDeferredTask('sentry', () async {
      final dsn = envOrDefine('SENTRY_DSN');
      if (dsn.isEmpty) {
        debugPrint('INFO: Sentry DSN not configured, running without Sentry');
        return;
      }
      const release = 'bizlevel@$_appVersion+$_appBuild';
      await SentryFlutter.init((options) {
        options
          ..dsn = dsn
          ..tracesSampleRate = kReleaseMode ? 0.3 : 1.0
          ..environment = kReleaseMode ? 'prod' : 'dev'
          ..release = release
          ..enableAutoSessionTracking = true
          ..beforeSend = (SentryEvent event, Hint hint) {
            event.request?.headers.removeWhere(
              (k, _) => k.toLowerCase() == 'authorization',
            );
            return event;
          };
      });
    }, delay: const Duration(milliseconds: 2000));
  });
}

Future<void> _ensureIosMessagingRegistered() async {
  if (kIsWeb ||
      defaultTargetPlatform != TargetPlatform.iOS ||
      _iosMessagingRegistered) {
    return;
  }
  const channel = MethodChannel('bizlevel/native/fcm');
  try {
    final bool? registered = await channel.invokeMethod<bool>(
      'registerMessagingPlugin',
    );
    if (registered == true) {
      await FirebaseMessaging.instance.setAutoInitEnabled(false);
      _iosMessagingRegistered = true;
    } else {
      debugPrint('registerMessagingPlugin returned $registered');
    }
  } catch (error, stackTrace) {
    debugPrint('Failed to register FirebaseMessaging plugin: $error');
    debugPrint('$stackTrace');
  }
}

Future<void> _prepareLocalNotifications() async {
  await _initializeTimezone();
  try {
    await NotificationsService.instance.initialize();
  } catch (_) {}
}

Future<void> _initializeTimezone() async {
  try {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  } catch (_) {}
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  static bool _launchHandled = false;
  ProviderSubscription<AsyncValue<UserModel?>>? _userSubscription;

  @override
  void initState() {
    super.initState();
    _userSubscription = ref.listenManual<AsyncValue<UserModel?>>(
      currentUserProvider,
      (previous, next) {
        final user = next.asData?.value;
        if (user != null) {
          _scheduleBackgroundServices();
        }
      },
      fireImmediately: true,
    );
  }

  @override
  void dispose() {
    _userSubscription?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GoRouter router = ref.watch(goRouterProvider);
    // Простая эвристика low-end устройства: низкий DPR или отключённая анимация ОС
    final bool lowDpr = MediaQuery.of(context).devicePixelRatio < 2.0;
    final bool disableAnimations = View.of(
      context,
    ).platformDispatcher.accessibilityFeatures.disableAnimations;
    final bool isLowEndDevice =
        lowDpr || disableAnimations; // reserved for global gating

    return _LinkListener(
      router: router,
      child: DynamicColorBuilder(
        builder: (lightDynamic, darkDynamic) {
          final ColorScheme lightScheme = DynamicThemeBuilder.buildColorScheme(
            lightDynamic?.harmonized(),
            Brightness.light,
          );
          final ColorScheme darkScheme = DynamicThemeBuilder.buildColorScheme(
            darkDynamic?.harmonized(),
            Brightness.dark,
          );
          return MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('ru'), Locale('en')],
            // Локализации делегируем системным настройкам; ru-параметры передаются напрямую в showDatePicker
            builder: (context, child) {
              // создаём ResponsiveWrapper как обычно
              final wrapped = ResponsiveWrapper.builder(
                BouncingScrollWrapper.builder(context, child!),
                minWidth: 320,
                defaultScale: true,
                breakpoints: const [
                  ResponsiveBreakpoint.resize(320, name: MOBILE),
                  ResponsiveBreakpoint.autoScale(600, name: TABLET),
                  ResponsiveBreakpoint.autoScale(1024, name: DESKTOP),
                ],
              );

              // После первого кадра — обрабатываем маршрут запуска (не блокируем build)
              if (!_launchHandled) {
                _launchHandled = true;
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  try {
                    final route = await NotificationsService.instance
                        .consumeAnyLaunchRoute();
                    if (route != null && route.isNotEmpty) {
                      try {
                        router.go(route);
                      } catch (_) {}
                    }
                  } catch (_) {}
                });
              }

              // увеличиваем базовый размер шрифта на desktop (>=1024)
              final bool isDesktop = MediaQuery.of(context).size.width >= 1024;
              final textTheme = Theme.of(context).textTheme;
              final scaledTextTheme = isDesktop
                  ? textTheme.copyWith(
                      displayLarge: textTheme.displayLarge?.copyWith(
                        fontSize: (textTheme.displayLarge?.fontSize ?? 24) + 2,
                      ),
                      bodyMedium: textTheme.bodyMedium?.copyWith(
                        fontSize: (textTheme.bodyMedium?.fontSize ?? 14) + 2,
                      ),
                    )
                  : textTheme;

              return Container(
                decoration:
                    (Theme.of(context).colorScheme.brightness ==
                        Brightness.dark)
                    ? null
                    : const BoxDecoration(gradient: AppColor.bgGradient),
                color:
                    (Theme.of(context).colorScheme.brightness ==
                        Brightness.dark)
                    ? Theme.of(context).colorScheme.surface
                    : null,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    textTheme: scaledTextTheme,
                    scaffoldBackgroundColor: Colors.transparent,
                    // Глобально уменьшаем длительность анимаций на low-end
                    pageTransitionsTheme: PageTransitionsTheme(
                      builders: {
                        for (final platform in TargetPlatform.values)
                          platform: isLowEndDevice
                              ? const ZoomPageTransitionsBuilder()
                              : const FadeUpwardsPageTransitionsBuilder(),
                      },
                    ),
                  ),
                  child: FutureBuilder<String?>(
                    // Больше не выполняем IO внутри первого build‑прохода
                    future: Future<String?>.value(),
                    builder: (context, snap) => wrapped,
                  ),
                ),
              );
            },
            debugShowCheckedModeBanner: false,
            title: 'BizLevel',
            theme: AppTheme.fromColorScheme(lightScheme),
            darkTheme: AppTheme.fromColorScheme(darkScheme),
            themeMode: ref.watch(themeModeProvider),
            // Навигатор теперь управляется GoRouter; SentryObserver добавлен в конфигурацию роутера
          );
        },
      ),
    );
  }
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
