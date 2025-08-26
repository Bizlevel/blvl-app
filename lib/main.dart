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
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  // КРИТИЧНО для web: Все инициализации должны быть в одной зоне
  WidgetsFlutterBinding.ensureInitialized();

  // Чистые URL без # — только для Web
  if (kIsWeb) {
    setUrlStrategy(PathUrlStrategy());
  }

  // Загружаем переменные окружения (если файл есть)
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {}

  // Инициализируем Supabase
  await SupabaseService.initialize();

  // Инициализируем Hive и открываем нужные боксы для кеша
  await Hive.initFlutter();
  await Hive.openBox('levels');
  await Hive.openBox('lessons');
  await Hive.openBox('goals');
  await Hive.openBox('weekly_progress');
  await Hive.openBox('quotes');

  final dsn = envOrDefine('SENTRY_DSN');

  if (dsn.isEmpty) {
    // Без Sentry - просто запускаем приложение
    print('INFO: Sentry DSN not configured, running without Sentry');
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

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter router = ref.watch(goRouterProvider);

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
              ),
              child: wrapped,
            ),
          );
        },
        debugShowCheckedModeBanner: false,
        title: 'BizLevel',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColor.primary,
            brightness: Brightness.light,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          snackBarTheme: const SnackBarThemeData(
            backgroundColor: AppColor.primary,
            contentTextStyle: TextStyle(color: Colors.white),
            actionTextColor: AppColor.premium,
          ),
        ),
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
