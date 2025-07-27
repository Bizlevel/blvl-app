import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../providers/login_controller.dart';
import '../../theme/color.dart';
import '../../widgets/custom_image.dart';
import '../../widgets/custom_textfield.dart';
import 'register_screen.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final isLoading = ref.watch(loginControllerProvider);

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.1),
            // Логотип BizLevel
            const CustomImage(
              'assets/images/logo_light.png',
              width: 120,
              height: 120,
              isNetwork: false,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 32),
            CustomTextBox(
              hint: 'Email',
              prefix: const Icon(Icons.email_outlined),
              controller: emailController,
            ),
            const SizedBox(height: 16),
            CustomTextBox(
              hint: 'Пароль',
              prefix: const Icon(Icons.lock_outline),
              controller: passwordController,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                ),
                onPressed: isLoading ? null : submit,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Войти'),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const RegisterScreen(),
                  ),
                );
              },
              child: const Text('Нет аккаунта? Зарегистрироваться'),
            ),
          ],
        ),
      ),
    );
  }
}
