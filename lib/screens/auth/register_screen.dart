import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/color.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_image.dart';
import 'onboarding_screens.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
      _showSnackBar('Заполните все поля');
      return;
    }
    if (password != confirm) {
      _showSnackBar('Пароли не совпадают');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await AuthService.signUp(email: email, password: password);
      if (!mounted) return;
      // Переходим на первый экран онбординга
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const OnboardingProfileScreen(),
        ),
        (_) => false,
      );
    } on AuthFailure catch (e) {
      _showSnackBar(e.message);
    } catch (e) {
      _showSnackBar('Неизвестная ошибка регистрации');
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
      appBar: AppBar(title: const Text('Регистрация')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          children: [
            SizedBox(height: size.height * 0.05),
            CustomImage(
              'https://placehold.co/100x100',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 24),
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
            const SizedBox(height: 16),
            CustomTextBox(
              hint: 'Подтвердите пароль',
              prefix: const Icon(Icons.lock_person_outlined),
              controller: _confirmController,
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
                    : const Text('Создать аккаунт'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
