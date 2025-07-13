import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/root_app.dart';
import 'services/supabase_service.dart';
import 'theme/color.dart';
import 'screens/auth/onboarding_screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Пытаемся загрузить переменные из .env; в release-сборке файл обычно
  // отсутствует, поэтому проглатываем FileNotFoundError.
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // ignore – fallback to --dart-define / const String.fromEnvironment
  }
  await SupabaseService.initialize();

  // Приоритет: .env → --dart-define
  final dsn = dotenv.env['sentry_dsn'] ??
      const String.fromEnvironment('SENTRY_DSN', defaultValue: '');

  // Если DSN не указан – не инициализируем Sentry, чтобы избежать ошибок в консоли
  if (dsn.isEmpty) {
    runApp(ProviderScope(child: MyApp()));
  } else {
    await SentryFlutter.init(
      (options) {
        options.dsn = dsn;
      },
      appRunner: () => runApp(ProviderScope(child: MyApp())),
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
      debugShowCheckedModeBanner: false,
      title: 'BizLevel',
      theme: ThemeData(
        primaryColor: AppColor.primary,
      ),
      home: home,
    );
  }
}
