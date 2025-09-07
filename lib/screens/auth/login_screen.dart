import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../providers/login_controller.dart';
import '../../services/auth_service.dart';
import '../../theme/color.dart' show AppColor;
import '../../widgets/custom_textfield.dart';
import '../../theme/spacing.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final loginState = ref.watch(loginControllerProvider);
    final isLoading = loginState.isLoading;
    final obscurePassword = useState<bool>(true);

    // Читаем query-параметр registered из GoRouter
    final registered =
        GoRouterState.of(context).uri.queryParameters['registered'] == 'true';

    ref.listen(loginControllerProvider, (previous, next) {
      if (next is AsyncError) {
        final error = next.error;
        if (error is AuthFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(error.message)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Произошла неизвестная ошибка: $error')));
        }
      }
    });

    Future<void> submit() async {
      final email = emailController.text.trim();
      final password = passwordController.text;
      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Введите email и пароль')));
        return;
      }

      // Вызываем signIn, обработка ошибок и навигация происходят в listener'ах
      // и роутере.
      await ref
          .read(loginControllerProvider.notifier)
          .signIn(email: email, password: password);
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColor.bgGradient,
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.insetsSymmetric(h: 24, v: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Баннер успешной регистрации
                if (registered) ...[
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: AppSpacing.insetsAll(16),
                    decoration: BoxDecoration(
                      color: AppColor.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColor.success.withValues(alpha: 0.3)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle,
                            color: AppColor.success, size: 24),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Вы успешно зарегистрировались!',
                            style: TextStyle(
                              color: AppColor.success,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                // белая карта формы
                Container(
                  key: const Key('login_form'),
                  // adaptive width
                  width: () {
                    final w = MediaQuery.of(context).size.width;
                    if (w >= 600 && w < 1024) {
                      return 480.0;
                    }
                    return 420.0;
                  }(),
                  padding: AppSpacing.insetsSymmetric(h: 24, v: 32),
                  decoration: BoxDecoration(
                    color: AppColor.surface,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.textColor.withValues(alpha: 0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: const BoxDecoration(
                          color: AppColor.dividerColor,
                          shape: BoxShape.circle,
                        ),
                        padding: AppSpacing.insetsAll(8),
                        child: SvgPicture.asset(
                          'assets/images/logo_light.svg',
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                      ),
                      AppSpacing.gapH(32),
                      CustomTextBox(
                        key: const ValueKey('email_field'),
                        hint: 'Email',
                        prefix: const Icon(Icons.email_outlined),
                        controller: emailController,
                      ),
                      AppSpacing.gapH(16),
                      // поле пароля с глазом
                      CustomTextBox(
                        key: const ValueKey('password_field'),
                        hint: 'Пароль',
                        prefix: const Icon(Icons.lock_outline),
                        controller: passwordController,
                        obscureText: obscurePassword.value,
                        suffix: IconButton(
                          icon: Icon(obscurePassword.value
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () =>
                              obscurePassword.value = !obscurePassword.value,
                        ),
                      ),
                      AppSpacing.gapH(24),
                      // Градиентная кнопка
                      GestureDetector(
                        onTap: isLoading ? null : submit,
                        child: Container(
                          height: 48,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColor.primary, AppColor.info],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: AppColor.onPrimary,
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Text(
                                  'Войти',
                                  style: TextStyle(
                                    color: AppColor.onPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      AppSpacing.gapH(16),
                      TextButton(
                        onPressed: () => context.go('/register'),
                        child: const Text('Нет аккаунта? Зарегистрироваться'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
