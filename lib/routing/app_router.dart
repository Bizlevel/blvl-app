import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/root_app.dart';
import '../providers/auth_provider.dart';

/// Riverpod provider that exposes the [GoRouter] instance used across the app.
///
/// На данном этапе логика редиректов будет добавлена позже (задача 15.2).
final goRouterProvider = Provider<GoRouter>((ref) {
  // Слушаем изменения аутентификации, чтобы GoRouter автоматически
  // пересоздавался при логине/логауте.
  final authAsync = ref.watch(authStateProvider);
  final session = authAsync.asData?.value.session ??
      Supabase.instance.client.auth.currentSession;

  final initialLocation = session == null ? '/login' : '/home';

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
        path: '/home',
        builder: (context, state) => const RootApp(),
      ),
    ],
    redirect: (context, state) {
      final loggedIn = session != null;
      final loggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (!loggedIn && !loggingIn) {
        return '/login';
      }

      if (loggedIn && loggingIn) {
        return '/home';
      }

      // no redirect
      return null;
    },
  );
});
