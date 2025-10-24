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
import 'utils/deep_link.dart';

import 'routing/app_router.dart';
import 'package:go_router/go_router.dart';
import 'services/supabase_service.dart';
import 'theme/color.dart';
import 'theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bizlevel/services/notifications_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'services/push_service.dart';

import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  // КРИТИЧНО для web: Все инициализации должны быть в одной зоне
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await _tryInitFirebase();
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

  // Инициализируем Hive и открываем нужные боксы для кеша
  await Hive.initFlutter();
  await Hive.openBox('levels');
  await Hive.openBox('lessons');
  await Hive.openBox('goals');
  // Кэш новой модели цели и журнала применений
  await Hive.openBox('user_goal');
  await Hive.openBox('practice_log');
  // Удалено: weekly_progress бокс (legacy)
  await Hive.openBox('quotes');
  await Hive.openBox('gp');

  // Инициализация таймзон и локальных уведомлений (M0)
  try {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
    await NotificationsService.instance.initialize();
    // Убрали недельные напоминания; остаются ежедневные напоминания практики на экране настроек
    // Открываем лог уведомлений
    await Hive.openBox('notifications');
  } catch (_) {}

  // Инициализация FCM (только для мобильных).
  if (!kIsWeb) {
    try {
      await PushService.instance.initialize();
    } catch (_) {}
  }

  final dsn = envOrDefine('SENTRY_DSN');

  if (dsn.isEmpty) {
    // Без Sentry - просто запускаем приложение
    debugPrint('INFO: Sentry DSN not configured, running without Sentry');
    runApp(const ProviderScope(child: MyApp()));
  } else {
    // С Sentry, но в той же зоне
    final packageInfo = await PackageInfo.fromPlatform();
    await SentryFlutter.init(
      (options) {
        options
          ..dsn = dsn
          ..tracesSampleRate = kReleaseMode ? 0.3 : 1.0
          ..environment = kReleaseMode ? 'prod' : 'dev'
          ..release =
              'bizlevel@${packageInfo.version}+${packageInfo.buildNumber}'
          ..enableAutoSessionTracking = true
          ..attachScreenshot = true
          ..attachViewHierarchy = true
          ..beforeSend = (SentryEvent event, Hint hint) {
            event.request?.headers
                .removeWhere((k, _) => k.toLowerCase() == 'authorization');
            return event;
          };
      },
      // НЕ используем appRunner - это создает разные зоны
    );

    // Запускаем приложение в той же зоне
    runApp(const ProviderScope(child: MyApp()));
  }
}

// Пытаемся инициализировать Firebase, но не падаем, если конфиг отсутствует
Future<void> _tryInitFirebase() async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
  } catch (e) {
    // В Dev/CI окружениях файл GoogleService-Info.plist может отсутствовать
    // Это не блокирует работу приложения (FCM будет отключён)
    debugPrint('WARN: Firebase is not initialized: $e');
  }
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
            decoration: const BoxDecoration(
              gradient: AppColor.bgGradient,
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
