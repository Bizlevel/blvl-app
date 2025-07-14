import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/root_app.dart';
import 'services/supabase_service.dart';
import 'theme/color.dart';
import 'screens/auth/onboarding_screens.dart';

Future<void> _bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  runApp(ProviderScope(child: MyApp()));
}
  


Future<void> main() async {
  // Загружаем переменные окружения (если файл есть)
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {}

  final dsn = dotenv.env['sentry_dsn'] ??
      const String.fromEnvironment('SENTRY_DSN', defaultValue: '');

  if (dsn.isEmpty) {
    await _bootstrap();
  } else {
    await SentryFlutter.init(
      (options) => options..dsn = dsn,
      appRunner: _bootstrap,
    );
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
        final isLoggedIn = session != null && session.user != null;
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
    );
  }
}
