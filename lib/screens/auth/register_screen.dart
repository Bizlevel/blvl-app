import 'dart:developer';

import 'package:bizlevel/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../providers/login_controller.dart';
import '../../theme/color.dart' show AppColor;
import '../../services/auth_service.dart';

import '../../widgets/custom_textfield.dart';
import '../../widgets/common/animated_button.dart';
import '../../theme/spacing.dart';

class RegisterScreen extends HookConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmController = useTextEditingController();

    final loginState = ref.watch(loginControllerProvider);
    final isLoading = loginState.isLoading;
    final registrationSuccess = useState(false);

    final obscurePassword = useState(true);
    final obscureConfirm = useState(true);

    void showSnackBar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    Future<void> submit() async {
      final email = emailController.text.trim();
      final password = passwordController.text;
      final confirm = confirmController.text;

      if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
        showSnackBar('Заполните все поля');
        return;
      }
      if (password != confirm) {
        showSnackBar('Пароли не совпадают');
        return;
      }

      log('Attempting to sign up with email: $email');
      try {
        await ref
            .read(authServiceProvider)
            .signUp(email: email, password: password);
        log('Sign up successful for email: $email');
        registrationSuccess.value = true;
      } on AuthFailure catch (e) {
        log('AuthFailure during sign up for $email', error: e);
        showSnackBar(e.message);
      } catch (e, st) {
        log('Unknown error during sign up for $email', error: e, stackTrace: st);
        showSnackBar('Неизвестная ошибка регистрации');
      }
    }

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
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: registrationSuccess.value
                  ? _buildSuccessView(context, registrationSuccess)
                  : _buildRegistrationForm(
                      context,
                      ref,
                      emailController,
                      passwordController,
                      confirmController,
                      obscurePassword,
                      obscureConfirm,
                      isLoading,
                      submit,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegistrationForm(
    BuildContext context,
    WidgetRef ref,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController confirmController,
    ValueNotifier<bool> obscurePassword,
    ValueNotifier<bool> obscureConfirm,
    bool isLoading,
    Future<void> Function() submit,
  ) {
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
          controller: emailController,
        ),
        AppSpacing.gapH(AppSpacing.lg),
        CustomTextBox(
          key: const Key('password_field'),
          hint: 'Пароль',
          prefix: const Icon(Icons.lock_outline),
          controller: passwordController,
          obscureText: obscurePassword.value,
          suffix: IconButton(
            icon: Icon(
                obscurePassword.value ? Icons.visibility_off : Icons.visibility),
            onPressed: () => obscurePassword.value = !obscurePassword.value,
          ),
        ),
        AppSpacing.gapH(AppSpacing.lg),
        CustomTextBox(
          key: const Key('confirm_password_field'),
          hint: 'Подтвердите пароль',
          prefix: const Icon(Icons.lock_person_outlined),
          controller: confirmController,
          obscureText: obscureConfirm.value,
          suffix: IconButton(
            icon:
                Icon(obscureConfirm.value ? Icons.visibility_off : Icons.visibility),
            onPressed: () => obscureConfirm.value = !obscureConfirm.value,
          ),
        ),
        AppSpacing.gapH(AppSpacing.xl),
        AnimatedButton(
          label: 'Создать аккаунт',
          onPressed: isLoading ? null : submit,
          loading: isLoading,
        ),
        AppSpacing.gapH(AppSpacing.lg),
        const _OrDivider(),
        AppSpacing.gapH(AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: SvgPicture.asset(
              'assets/images/google_logo.svg',
              width: 24,
              height: 24,
            ),
            label: const Text('Регистрация через Google'),
            onPressed: () {
              ref.read(loginControllerProvider.notifier).signInWithGoogle();
            },
            style: OutlinedButton.styleFrom(
              padding: AppSpacing.insetsSymmetric(v: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(color: AppColor.textColor.withOpacity(0.2)),
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

  Widget _buildSuccessView(
      BuildContext context, ValueNotifier<bool> registrationSuccess) {
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
        AnimatedButton(
          label: 'Уже подтвердили? Войти',
          onPressed: () => context.go('/login?registered=true'),
        ),
        AppSpacing.gapH(AppSpacing.lg),
        TextButton(
          onPressed: () => registrationSuccess.value = false,
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
          child: Text(
            'или',
            style: TextStyle(color: AppColor.textColor.withOpacity(0.5)),
          ),
        ),
        const Expanded(child: Divider(thickness: 0.5)),
      ],
    );
  }
}
