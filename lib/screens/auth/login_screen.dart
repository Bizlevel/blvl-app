import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/auth_service.dart';
import '../../theme/color.dart';
import '../../widgets/custom_image.dart';
import '../../widgets/custom_textfield.dart';
import 'register_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Введите email и пароль');
      return;
    }
    setState(() => _isLoading = true);
    try {
      await AuthService.signIn(email: email, password: password);
      // Навигация не требуется – AuthGate в main.dart отреагирует на изменение сессии.
    } on AuthFailure catch (e) {
      _showSnackBar(e.message);
    } catch (e) {
      _showSnackBar('Неизвестная ошибка входа');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.1),
            // Логотип – временный placeholder
            CustomImage(
              'https://placehold.co/120x120',
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 32),
            CustomTextBox(
              hint: 'Email',
              prefix: const Icon(Icons.email_outlined),
              controller: _emailController,
            ),
            const SizedBox(height: 16),
            CustomTextBox(
              hint: 'Пароль',
              prefix: const Icon(Icons.lock_outline),
              controller: _passwordController,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                ),
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
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
