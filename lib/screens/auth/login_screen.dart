import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../providers/login_controller.dart';
import '../../theme/color.dart';
import '../../widgets/custom_image.dart';
import '../../widgets/custom_textfield.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final isLoading = ref.watch(loginControllerProvider);
    final obscurePassword = useState<bool>(true);

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
      } on String catch (msg) {
        // перехватываем сообщение ошибки, брошенное контроллером
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg)));
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
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const CustomImage(
                          'assets/images/logo_light.png',
                          width: 80,
                          height: 80,
                          isNetwork: false,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 32),
                      CustomTextBox(
                        hint: 'Email',
                        prefix: const Icon(Icons.email_outlined),
                        controller: emailController,
                      ),
                      const SizedBox(height: 16),
                      // поле пароля с глазом
                      CustomTextBox(
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
