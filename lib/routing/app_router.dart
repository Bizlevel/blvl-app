import 'package:flutter/material.dart';
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
import '../screens/main_street_screen.dart';
import '../screens/biz_tower_screen.dart';
import '../screens/leo_chat_screen.dart';
import '../screens/goal_screen.dart';
import '../screens/goal_history_screen.dart';
import '../screens/mini_case_screen.dart';
import '../screens/gp_store_screen.dart';
import '../screens/library/library_screen.dart';
import '../screens/library/library_section_screen.dart';
import '../screens/notifications_settings_screen.dart';
import '../screens/artifacts_screen.dart';
import '../screens/checkpoints/checkpoint_screen.dart';
import '../services/level_input_guard.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class _FlowNavigatorObserver extends NavigatorObserver {
  void _log(String msg) {
    assert(() {
      debugPrint('[nav-observer] $msg');
      return true;
    }());
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _log('didPush route=${route.settings.name ?? route.runtimeType} previous=${previousRoute?.settings.name ?? previousRoute?.runtimeType}');
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _log('didPop route=${route.settings.name ?? route.runtimeType} previous=${previousRoute?.settings.name ?? previousRoute?.runtimeType}');
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    _log('didRemove route=${route.settings.name ?? route.runtimeType} previous=${previousRoute?.settings.name ?? previousRoute?.runtimeType}');
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    _log('didReplace new=${newRoute?.settings.name ?? newRoute?.runtimeType} old=${oldRoute?.settings.name ?? oldRoute?.runtimeType}');
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}

class AuthNotifier extends ChangeNotifier {
  final Ref ref;
  
  AuthNotifier(this.ref) {
    ref.listen(currentUserProvider, (_, __) {
      notifyListeners();
    });
  }
}

final authNotifierProvider = Provider<AuthNotifier>((ref) => AuthNotifier(ref));

final goRouterProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authNotifierProvider);
  final session = Supabase.instance.client.auth.currentSession;
  final initialLocation = session == null ? '/login' : '/home';

  // ShellRoute содержит экраны, у которых ЕСТЬ нижнее меню (BottomBar)
  final ShellRoute appShell = ShellRoute(
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
        path: '/goal/history',
        builder: (context, state) => const GoalHistoryScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/artifacts',
        builder: (context, state) => const ArtifactsScreen(),
      ),
      GoRoute(
        path: '/tower',
        builder: (context, state) {
          final scrollParam =
              int.tryParse(state.uri.queryParameters['scrollTo'] ?? '');
          return BizTowerScreen(scrollTo: scrollParam);
        },
      ),
      // ВАЖНО: /levels/:id удален отсюда. Он перенесен ниже, в корневой список.
      // Это предотвращает конфликт с AppShell при открытии клавиатуры.
      
      GoRoute(
        path: '/case/:id',
        builder: (context, state) {
          final caseId = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
          return MiniCaseScreen(caseId: caseId);
        },
      ),
      GoRoute(
        path: '/gp-store',
        builder: (context, state) => const GpStoreScreen(),
      ),
      GoRoute(
        path: '/library',
        builder: (context, state) => const LibraryScreen(),
      ),
      GoRoute(
        path: '/library/:type',
        builder: (context, state) {
          final type = state.pathParameters['type'] ?? 'courses';
          return LibrarySectionScreen(type: type);
        },
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsSettingsScreen(),
      ),
    ],
  );

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: initialLocation,
    debugLogDiagnostics: true,
    refreshListenable: authNotifier,
    observers: [SentryNavigatorObserver(), _FlowNavigatorObserver()],
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
        path: '/checkpoint/l1',
        builder: (context, state) =>
            const CheckpointScreen(type: CheckpointType.l1),
      ),
      GoRoute(
        path: '/checkpoint/l4',
        builder: (context, state) =>
            const CheckpointScreen(type: CheckpointType.l4),
      ),
      GoRoute(
        path: '/checkpoint/l7',
        builder: (context, state) =>
            const CheckpointScreen(type: CheckpointType.l7),
      ),
      // --- ПЕРЕНЕСЕННЫЙ МАРШРУТ ---
      // Теперь он "над" ShellRoute. AppShell не будет перестраиваться при открытии
      // клавиатуры на этом экране, и не будет пытаться сбросить нас в /tower.
      GoRoute(
        path: '/levels/:id',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
          final levelNum = int.tryParse(state.uri.queryParameters['num'] ?? '');
          return LevelDetailScreen(levelId: id, levelNumber: levelNum);
        },
      ),
      // -----------------------------
      appShell,
    ],
    redirect: (context, state) {
      assert(() {
        debugPrint('[redirect] enter location=${state.uri} matched=${state.matchedLocation}');
        return true;
      }());
      try {
        final guard = LevelInputGuard.instance;
        final String location = state.uri.toString();
        
        // Guard Logic: теперь он должен молчать, так как AppShell не будет пытаться 
        // перенаправить нас на /tower.
        if (guard.isActive &&
            guard.lastLevelRoute != null &&
            (location == '/tower' || location.startsWith('/tower?'))) {
          guard.debugLog(
              'redirected_tower_to_level from=$location to=${guard.lastLevelRoute}');
          assert(() {
            debugPrint('[redirect] force_to_last_level from=$location to=${guard.lastLevelRoute}');
            return true;
          }());
          return guard.lastLevelRoute!;
        }

        final loggingIn = state.matchedLocation == '/login' ||
            state.matchedLocation == '/register';

        final currentUserAsync = ref.read(currentUserProvider);
        final currentUser = currentUserAsync.asData?.value;
        final loggedIn = currentUser != null;
        
        final currentSession = Supabase.instance.client.auth.currentSession;

        if (currentSession != null && !currentUserAsync.isLoading && !loggedIn) {
          ref.read(authServiceProvider).signOut();
          assert(() {
            debugPrint('[redirect] session_without_user -> /login');
            return true;
          }());
          return '/login';
        }

        final isOnProfile = state.matchedLocation == '/profile';
        if (isOnProfile) {
          return null; 
        }

        if (!loggedIn && !loggingIn && !currentUserAsync.isLoading) {
          assert(() {
            debugPrint('[redirect] not_logged_in -> /login');
            return true;
          }());
          return '/login';
        }

        if (loggedIn && loggingIn) {
          assert(() {
            debugPrint('[redirect] logged_in_on_auth -> /home');
            return true;
          }());
          return '/home';
        }

        if (state.matchedLocation.startsWith('/goal')) {
          final currentLevel = currentUser?.currentLevel ?? 0;
          final bool fromCheckpoint =
              state.uri.queryParameters['from'] == 'checkpoint';
          if (currentLevel < 2 && !fromCheckpoint) {
            assert(() {
              debugPrint('[redirect] gate_goal currentLevel=$currentLevel -> /home');
              return true;
            }());
            return '/home';
          }
        }

        assert(() {
          debugPrint('[redirect] none');
          return true;
        }());
        return null;
      } on Object catch (error, stackTrace) {
        Sentry.captureException(error, stackTrace: stackTrace);
        assert(() {
          debugPrint('[redirect] exception -> /login err=$error');
          return true;
        }());
        return '/login';
      }
    },
  );
});