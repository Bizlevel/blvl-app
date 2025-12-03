import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

/// [LoginController] управляет процессом авторизации.
/// Его состояние - [AsyncValue], что позволяет отслеживать статусы
/// загрузки, ошибки и успеха.
class LoginController extends StateNotifier<AsyncValue<void>> {
  LoginController(this.ref) : super(const AsyncData(null));

  final Ref ref;

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    try {
      await ref
          .read(authServiceProvider)
          .signIn(email: email, password: password);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    try {
      await ref.read(authServiceProvider).signInWithGoogle();
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> signInWithApple() async {
    state = const AsyncLoading();
    try {
      await ref.read(authServiceProvider).signInWithApple();
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

/// Провайдер для [LoginController].
final loginControllerProvider =
    StateNotifierProvider<LoginController, AsyncValue<void>>(
        (ref) => LoginController(ref));
