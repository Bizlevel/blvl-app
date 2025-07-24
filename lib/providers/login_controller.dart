import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_service.dart';
import 'auth_provider.dart';

/// [LoginController] управляет процессом авторизации и выдаёт `true`, когда
/// выполняется запрос к серверу.
class LoginController extends StateNotifier<bool> {
  LoginController(this.ref) : super(false);

  final Ref ref;

  Future<void> signIn({required String email, required String password}) async {
    if (state) return; // уже выполняется
    state = true;
    try {
      await ref
          .read(authServiceProvider)
          .signIn(email: email, password: password);
    } on AuthFailure catch (e) {
      _showError(e.message);
    } catch (_) {
      _showError('Неизвестная ошибка входа');
    } finally {
      state = false;
    }
  }

  void _showError(String message) {
    // Для отображения SnackBar нужен BuildContext, поэтому прокинем event.
    // Этот контроллер будет слушаться в UI; мы пробросим исключение наверх.
    throw message;
  }
}

/// Провайдер для [LoginController].
final loginControllerProvider =
    StateNotifierProvider<LoginController, bool>((ref) => LoginController(ref));
