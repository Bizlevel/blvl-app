import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'routing/app_router.dart';
import 'package:go_router/go_router.dart';
import 'services/supabase_service.dart';
import 'theme/color.dart';

Future<void> main() async {
  // КРИТИЧНО для web: Все инициализации должны быть в одной зоне
  WidgetsFlutterBinding.ensureInitialized();

  // Загружаем переменные окружения (если файл есть)
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {}

  // Инициализируем Supabase
  await SupabaseService.initialize();

  final dsn = dotenv.env['sentry_dsn'] ??
      const String.fromEnvironment('SENTRY_DSN', defaultValue: '');

  if (dsn.isEmpty) {
    // Без Sentry
    runApp(const ProviderScope(child: MyApp()));
  } else {
    // С Sentry, но в той же зоне
    final packageInfo = await PackageInfo.fromPlatform();
    await SentryFlutter.init(
      (options) {
        options
          ..dsn = dsn
          ..tracesSampleRate = 1.0
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

    return MaterialApp.router(
      routerConfig: router,
      builder: (context, child) => ResponsiveWrapper.builder(
        BouncingScrollWrapper.builder(context, child!),
        maxWidth: 480,
        minWidth: 320,
        defaultScale: true,
        breakpoints: const [
          ResponsiveBreakpoint.resize(320, name: MOBILE),
          ResponsiveBreakpoint.autoScale(600, name: TABLET),
          ResponsiveBreakpoint.autoScale(800, name: DESKTOP),
        ],
      ),
      debugShowCheckedModeBanner: false,
      title: 'BizLevel',
      theme: ThemeData(
        primaryColor: AppColor.primary,
      ),
      // Навигатор теперь управляется GoRouter; SentryObserver добавлен в конфигурацию роутера
    );
  }
}
