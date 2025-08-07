import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../providers/login_controller.dart';
import '../../theme/color.dart';
import '../../widgets/custom_textfield.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final isLoading = ref.watch(loginControllerProvider);
    final obscurePassword = useState<bool>(true);

    // Читаем query-параметр registered из GoRouter
    final registered =
        GoRouterState.of(context).uri.queryParameters['registered'] == 'true';

    Future<void> submit() async {
      final email = emailController.text.trim();
      final password = passwordController.text;
      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Введите email и пароль')));
        return;
      }

      try {
        await ref
            .read(loginControllerProvider.notifier)
            .signIn(email: email, password: password);

        // Если вход выполнен после подтверждения регистрации - переходим на онбординг
        if (registered && context.mounted) {
          context.go('/onboarding/profile');
        }
      } on String catch (msg) {
        // перехватываем сообщение ошибки, брошенное контроллером
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(msg)));
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColor.bgGradient,
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Баннер успешной регистрации
                if (registered) ...[
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 24),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Вы успешно зарегистрировались!',
                            style: TextStyle(
                              color: Colors.green,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
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
                        decoration: BoxDecoration(
                          color: Color(0xFFf0f0f0),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: SvgPicture.asset(
                          'assets/images/logo_light.svg',
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 32),
                      CustomTextBox(
                        key: const ValueKey('email_field'),
                        hint: 'Email',
                        prefix: const Icon(Icons.email_outlined),
                        controller: emailController,
                      ),
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 24),
                      // Градиентная кнопка
                      GestureDetector(
                        onTap: isLoading ? null : submit,
                        child: Container(
                          height: 48,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColor.primary, Color(0xFF1273C4)],
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
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Text(
                                  'Войти',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
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
