import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/app_shell.dart';
import '../providers/auth_provider.dart';
import '../screens/profile_screen.dart';
import '../screens/level_detail_screen.dart';
import '../screens/premium_screen.dart';
import '../screens/main_street_screen.dart';
import '../screens/biz_tower_screen.dart';
import '../screens/leo_chat_screen.dart';
import '../screens/goal_screen.dart';
// material import не требуется
import '../screens/mini_case_screen.dart';
import '../screens/goal_checkpoint_screen.dart';

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
        builder: (context, state) => const MainStreetScreen(),
      ),
      GoRoute(
        path: '/chat',
        builder: (context, state) => const LeoChatScreen(),
      ),
      GoRoute(
        path: '/goal',
        builder: (context, state) => const GoalScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      // BizLevel Tower overview (MVP)
      GoRoute(
        path: '/tower',
        builder: (context, state) {
          final scrollParam =
              int.tryParse(state.uri.queryParameters['scrollTo'] ?? '');
          return BizTowerScreen(scrollTo: scrollParam);
        },
      ),
      GoRoute(
        path: '/levels/:id',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
          final levelNum = int.tryParse(state.uri.queryParameters['num'] ?? '');
          return LevelDetailScreen(levelId: id, levelNumber: levelNum);
        },
      ),
      GoRoute(
        path: '/case/:id',
        builder: (context, state) {
          final caseId = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
          return MiniCaseScreen(caseId: caseId);
        },
      ),
      GoRoute(
        path: '/goal-checkpoint/:version',
        builder: (context, state) {
          final version =
              int.tryParse(state.pathParameters['version'] ?? '0') ?? 0;
          return GoalCheckpointScreen(version: version);
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
      // /goal объявлен внутри ShellRoute
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      // Deprecated onboarding routes removed
      GoRoute(
        path: '/premium',
        builder: (context, state) => const PremiumScreen(),
      ),
      appShell,
    ],
    redirect: (context, state) {
      final loggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';
      // Onboarding routes deprecated; no special handling

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
      if (!loggedIn && !loggingIn) {
        return '/login';
      }

      // Если авторизован и на страницах входа/регистрации - на домашнюю
      if (loggedIn && loggingIn) {
        return '/home';
      }

      // Гейтинг для /goal: доступно после завершения Уровня 1 (current_level >= 2)
      if (state.matchedLocation.startsWith('/goal')) {
        final currentLevel = currentUser?.currentLevel ?? 0;
        if (currentLevel < 2) {
          return '/home';
        }
      }

      // no redirect
      return null;
    },
  );
});

// stub removed (реализован MiniCaseScreen)
