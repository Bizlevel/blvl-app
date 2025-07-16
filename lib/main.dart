import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/root_app.dart';
import 'services/supabase_service.dart';
import 'theme/color.dart';
import 'screens/auth/onboarding_screens.dart';

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
    runApp(ProviderScope(child: MyApp()));
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
    runApp(ProviderScope(child: MyApp()));
  }
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authStateProvider);
    final currentUserAsync = ref.watch(currentUserProvider);

    Widget home = authAsync.when(
      data: (authState) {
        // Проверяем наличие сессии
        final session = authState.session;
        final isLoggedIn = session != null;
        if (!isLoggedIn) {
          return const LoginScreen();
        }

        // Пользователь авторизован – смотрим, завершён ли онбординг
        return currentUserAsync.when(
          data: (user) {
            if (user == null || !(user.onboardingCompleted)) {
              return const OnboardingProfileScreen();
            }
            return const RootApp();
          },
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => const RootApp(),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => const LoginScreen(),
    );

    return MaterialApp(
      builder: (context, child) => ResponsiveWrapper.builder(
        BouncingScrollWrapper.builder(context, child!),
        maxWidth: 600,
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
      home: home,
      navigatorObservers: [SentryNavigatorObserver()],
    );
  }
}
