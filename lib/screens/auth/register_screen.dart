import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../theme/color.dart' show AppColor;
import '../../services/auth_service.dart';

import '../../providers/auth_provider.dart';
import '../../widgets/custom_textfield.dart';
// custom_image больше не используется для логотипа на этом экране
import '../../theme/spacing.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _isLoading = false;
  bool _registrationSuccess = false;

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

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
    log('Attempting to sign up with email: $email');
    try {
      await ref.read(authServiceProvider).signUp(
            email: email,
            password: password,
          );
      log('Sign up successful for email: $email');
      if (!mounted) return;
      // Устанавливаем состояние успешной регистрации для показа экрана подтверждения
      setState(() => _registrationSuccess = true);
    } on AuthFailure catch (e) {
      log('AuthFailure during sign up for $email', error: e);
      _showSnackBar(e.message);
    } catch (e, st) {
      log('Unknown error during sign up for $email', error: e, stackTrace: st);
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColor.bgGradient),
        child: Center(
          child: SingleChildScrollView(
            padding:
                AppSpacing.insetsSymmetric(h: AppSpacing.xl, v: AppSpacing.x3l),
            child: Container(
              key: const Key('register_form'),
              // adaptive width
              width: () {
                final w = MediaQuery.of(context).size.width;
                if (w >= 600 && w < 1024) {
                  return 480.0;
                }
                return 420.0;
              }(),
              padding: AppSpacing.insetsSymmetric(
                  h: AppSpacing.xl, v: AppSpacing.xl),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: _registrationSuccess
                  ? _buildSuccessView()
                  : _buildRegistrationForm(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegistrationForm() {
    return Column(
      children: [
        SvgPicture.asset(
          'assets/images/logo_light.svg',
          width: 176,
          height: 176,
          fit: BoxFit.contain,
        ),
        AppSpacing.gapH(AppSpacing.xl),
        CustomTextBox(
          key: const Key('email_field'),
          hint: 'Email',
          prefix: const Icon(Icons.email_outlined),
          controller: _emailController,
        ),
        AppSpacing.gapH(AppSpacing.lg),
        CustomTextBox(
          key: const Key('password_field'),
          hint: 'Пароль',
          prefix: const Icon(Icons.lock_outline),
          controller: _passwordController,
          obscureText: _obscurePassword,
          suffix: IconButton(
            icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility),
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        AppSpacing.gapH(AppSpacing.lg),
        CustomTextBox(
          key: const Key('confirm_password_field'),
          hint: 'Подтвердите пароль',
          prefix: const Icon(Icons.lock_person_outlined),
          controller: _confirmController,
          obscureText: _obscureConfirm,
          suffix: IconButton(
            icon:
                Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
          ),
        ),
        AppSpacing.gapH(AppSpacing.xl),
        GestureDetector(
          onTap: _isLoading ? null : _submit,
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
            child: _isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : const Text(
                    'Создать аккаунт',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
        AppSpacing.gapH(AppSpacing.lg),
        TextButton(
          onPressed: () => context.go('/login'),
          child: const Text('Уже есть аккаунт? Войти'),
        ),
      ],
    );
  }

  Widget _buildSuccessView() {
    return Column(
      children: [
        SvgPicture.asset(
          'assets/images/logo_light.svg',
          width: 176,
          height: 176,
          fit: BoxFit.contain,
        ),
        AppSpacing.gapH(AppSpacing.xl),
        Container(
          padding: AppSpacing.insetsAll(AppSpacing.lg),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
          ),
          child: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 24),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Регистрация успешна!',
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
        AppSpacing.gapH(AppSpacing.xl),
        const Text(
          'Проверьте почту для подтверждения аккаунта',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        AppSpacing.gapH(AppSpacing.lg),
        const Text(
          'Мы отправили вам письмо со ссылкой для подтверждения. Перейдите по ссылке, а затем войдите в приложение.',
          style: TextStyle(
            fontSize: 14,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
        AppSpacing.gapH(AppSpacing.xl),
        GestureDetector(
          onTap: () => context.go('/login?registered=true'),
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
            child: const Text(
              'Уже подтвердили? Войти',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        AppSpacing.gapH(AppSpacing.lg),
        TextButton(
          onPressed: () => setState(() => _registrationSuccess = false),
          child: const Text('← Назад к регистрации'),
        ),
      ],
    );
  }
}
