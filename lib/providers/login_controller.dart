import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'auth_provider.dart';
import '../routing/app_router.dart';

/// [LoginController] управляет процессом авторизации.
/// Его состояние - [AsyncValue], что позволяет отслеживать статусы
/// загрузки, ошибки и успеха.
class LoginController extends StateNotifier<AsyncValue<void>> {
  LoginController(this.ref) : super(const AsyncData(null));

  final Ref ref;

  void _addAuthBreadcrumb(String message, {Map<String, Object?> data = const {}}) {
    try {
      Sentry.addBreadcrumb(Breadcrumb(
        category: 'auth',
        level: SentryLevel.info,
        message: message,
        data: data,
      ));
    } catch (_) {}
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    _addAuthBreadcrumb('auth_login_submit');
    try {
      await ref
          .read(authServiceProvider)
          .signIn(email: email, password: password);
      state = const AsyncData(null);
      _addAuthBreadcrumb('auth_login_success');
      // КРИТИЧНО: После успешного логина инвалидируем провайдеры,
      // чтобы GoRouter обновился и перенаправил на /home
      _invalidateAuthDependentProviders();
    } catch (e, st) {
      state = AsyncError(e, st);
      _addAuthBreadcrumb('auth_login_fail', data: {
        'error_type': e.runtimeType.toString(),
      });
    }
  }
  
  /// Инвалидирует провайдеры, зависящие от auth state.
  /// Вызывается после успешного логина/логаута.
  void _invalidateAuthDependentProviders() {
    if (kDebugMode) {
      debugPrint('LoginController: invalidating auth-dependent providers');
    }
    ref.invalidate(currentUserProvider);
    ref.invalidate(goRouterProvider);
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    _addAuthBreadcrumb('auth_google_start');
    try {
      await ref.read(authServiceProvider).signInWithGoogle();
      state = const AsyncData(null);
      _addAuthBreadcrumb('auth_google_success');
      _invalidateAuthDependentProviders();
    } catch (e, st) {
      state = AsyncError(e, st);
      _addAuthBreadcrumb('auth_google_fail', data: {
        'error_type': e.runtimeType.toString(),
      });
    }
  }

  Future<void> signInWithApple() async {
    state = const AsyncLoading();
    _addAuthBreadcrumb('auth_apple_start');
    try {
      await ref.read(authServiceProvider).signInWithApple();
      state = const AsyncData(null);
      _addAuthBreadcrumb('auth_apple_success');
      _invalidateAuthDependentProviders();
    } catch (e, st) {
      state = AsyncError(e, st);
      _addAuthBreadcrumb('auth_apple_fail', data: {
        'error_type': e.runtimeType.toString(),
      });
    }
  }
}

/// Провайдер для [LoginController].
final loginControllerProvider =
    StateNotifierProvider<LoginController, AsyncValue<void>>(
        (ref) => LoginController(ref));
