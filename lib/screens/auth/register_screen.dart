import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../theme/color.dart' show AppColor;
import '../../services/auth_service.dart';

import '../../providers/auth_provider.dart';
import '../../providers/login_controller.dart';
import '../../widgets/custom_textfield.dart';
// custom_image больше не используется для логотипа на этом экране
import '../../theme/spacing.dart';
import '../../theme/dimensions.dart';
import '../../theme/typography.dart';
import '../../utils/constant.dart';

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
                color: AppColor.card,
                borderRadius: BorderRadius.circular(AppDimensions.radiusXxl),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.shadow.withValues(alpha: 0.05),
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
            tooltip: _obscurePassword ? 'Показать пароль' : 'Скрыть пароль',
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
            tooltip: _obscureConfirm ? 'Показать пароль' : 'Скрыть пароль',
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
              gradient: AppColor.businessGradient,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            ),
            alignment: Alignment.center,
            child: _isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: AppColor.onPrimary,
                      strokeWidth: 3,
                    ),
                  )
                : Text(
                    'Создать аккаунт',
                    style: AppTypography.textTheme.titleMedium
                        ?.copyWith(color: AppColor.onPrimary),
                  ),
          ),
        ),
        AppSpacing.gapH(AppSpacing.lg),
        if (kEnableGoogleAuth) const _OrDivider(),
        if (kEnableGoogleAuth) AppSpacing.gapH(AppSpacing.lg),
        if (kEnableGoogleAuth)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.login),
              label: const Text('Регистрация через Google'),
              onPressed: () {
                ref.read(loginControllerProvider.notifier).signInWithGoogle();
              },
              style: OutlinedButton.styleFrom(
                padding: AppSpacing.insetsSymmetric(v: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                ),
                side: BorderSide(
                    color: AppColor.textColor.withValues(alpha: 0.2)),
              ),
            ),
          ),
        if (kEnableGoogleAuth) AppSpacing.gapH(AppSpacing.lg),
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
        ),
        AppSpacing.gapH(AppSpacing.xl),
        Container(
          padding: AppSpacing.insetsAll(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColor.success.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(color: AppColor.success.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: AppColor.success, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Регистрация успешна!',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColor.success, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        AppSpacing.gapH(AppSpacing.xl),
        Text(
          'Проверьте почту для подтверждения аккаунта',
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        AppSpacing.gapH(AppSpacing.lg),
        Text(
          'Мы отправили вам письмо со ссылкой для подтверждения. Перейдите по ссылке, а затем войдите в приложение.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4),
          textAlign: TextAlign.center,
        ),
        AppSpacing.gapH(AppSpacing.xl),
        GestureDetector(
          onTap: () => context.go('/login?registered=true'),
          child: Container(
            height: 48,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: AppColor.businessGradient,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            ),
            alignment: Alignment.center,
            child: Text(
              'Уже подтвердили? Войти',
              style: AppTypography.textTheme.titleMedium
                  ?.copyWith(color: AppColor.onPrimary),
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

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(thickness: 0.5)),
        Padding(
          padding: AppSpacing.insetsSymmetric(h: 16),
          child: const Text('или'),
        ),
        const Expanded(child: Divider(thickness: 0.5)),
      ],
    );
  }
}
