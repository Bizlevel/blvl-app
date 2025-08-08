import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/app_shell.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/onboarding_screens.dart';
import '../screens/auth/onboarding_video_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/level_detail_screen.dart';
import '../screens/premium_screen.dart';
import '../screens/levels_map_screen.dart';
import '../screens/leo_chat_screen.dart';

/// Riverpod provider that exposes the [GoRouter] instance used across the app.
///
/// На данном этапе логика редиректов будет добавлена позже (задача 15.2).
final goRouterProvider = Provider<GoRouter>((ref) {
  // Слушаем изменения аутентификации, чтобы GoRouter автоматически
  // пересоздавался при логине/логауте.
  final authAsync = ref.watch(authStateProvider);
  final currentUserAsync = ref.watch(currentUserProvider);
  final session = authAsync.asData?.value.session ??
      Supabase.instance.client.auth.currentSession;

  final initialLocation = session == null ? '/login' : '/home';

  ShellRoute appShell = ShellRoute(
    builder: (context, state, child) => AppShell(child: child),
    routes: [
      GoRoute(
        path: '/home',
        builder: (context, state) => const LevelsMapScreen(),
      ),
      GoRoute(
        path: '/chat',
        builder: (context, state) => const LeoChatScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/levels/:id',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
          return LevelDetailScreen(levelId: id);
        },
      ),
    ],
  );

  return GoRouter(
    initialLocation: initialLocation,
    debugLogDiagnostics: false,
    observers: [SentryNavigatorObserver()],
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/onboarding/profile',
        builder: (context, state) => const OnboardingProfileScreen(),
      ),
      GoRoute(
        path: '/onboarding/video',
        builder: (context, state) => const OnboardingVideoScreen(),
      ),
      GoRoute(
        path: '/premium',
        builder: (context, state) => const PremiumScreen(),
      ),
      appShell,
    ],
    redirect: (context, state) {
      final loggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';
      final onboardingPath = state.matchedLocation.startsWith('/onboarding');

      // Используем currentUserProvider для определения статуса логина.
      // Это надёжнее, чем просто проверять сессию.
      final currentUser = currentUserAsync.asData?.value;
      final loggedIn = currentUser != null;

      // Обработка случая с "зависшей" сессией, когда сессия есть,
      // а пользователя в базе нет.
      if (session != null && !currentUserAsync.isLoading && !loggedIn) {
        // Запускаем signOut в фоне и сразу редиректим на логин
        ref.read(authServiceProvider).signOut();
        return '/login';
      }

      // Если не авторизован и не на страницах логина/регистрации - на логин
      if (!loggedIn && !loggingIn && !onboardingPath) {
        return '/login';
      }

      // Если авторизован и на страницах входа/регистрации - на домашнюю
      if (loggedIn && loggingIn) {
        return '/home';
      }

      // Удалена логика редиректа на онбординг — после входа пользователь попадает на карту уровней

      // no redirect
      return null;
    },
  );
});
