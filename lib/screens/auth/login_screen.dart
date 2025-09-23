import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../providers/login_controller.dart';
import '../../services/auth_service.dart';
import '../../theme/color.dart' show AppColor;
import '../../widgets/custom_textfield.dart';
import '../../widgets/common/animated_button.dart';
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
      body: Stack(
        children: [
          // Анимированный фон (медленная ротация градиента, лёгкая)
          const _AnimatedGradientBackground(),
          Center(
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
                        // Логотип без внешнего кольца: чистый белый круг и увеличенный логотип
                        Container(
                          width: 224,
                          height: 224,
                          decoration: const BoxDecoration(
                            color: AppColor.surface,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            'assets/images/logo_light.svg',
                            width: 176,
                            height: 176,
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
                        AnimatedButton(
                          label: 'Войти',
                          onPressed: isLoading ? null : submit,
                          loading: isLoading,
                        ),
                        AppSpacing.gapH(24),
                        const _OrDivider(),
                        AppSpacing.gapH(24),
                        // Кнопка входа через Google
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            icon: SvgPicture.asset(
                              'assets/images/google_logo.svg',
                              width: 24,
                              height: 24,
                            ),
                            label: const Text('Войти через Google'),
                            onPressed: () {
                              ref
                                  .read(loginControllerProvider.notifier)
                                  .signInWithGoogle();
                            },
                            style: OutlinedButton.styleFrom(
                              padding: AppSpacing.insetsSymmetric(v: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(
                                  color: AppColor.textColor.withValues(alpha: 0.2)),
                            ),
                          ),
                        ),
                        AppSpacing.gapH(32),
                        // Social proof (лёгкий блок
                        const _SocialProofBlock(),
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
        ],
      ),
    );
  }
}

class _AnimatedGradientBackground extends StatefulWidget {
  const _AnimatedGradientBackground();
  @override
  State<_AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState
    extends State<_AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    final dpr = MediaQueryData.fromView(
            WidgetsBinding.instance.platformDispatcher.views.first)
        .devicePixelRatio;
    final isLowEnd = dpr < 2.0;
    _controller = AnimationController(
        vsync: this, duration: Duration(seconds: isLowEnd ? 18 : 30))
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(
                    const Color(0xFFF0F4FF), const Color(0xFFDDE8FF), t * 0.6)!,
                Color.lerp(
                    const Color(0xFFE0F2FE), const Color(0xFFEDE9FE), t * 0.6)!,
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SocialProofBlock extends StatelessWidget {
  const _SocialProofBlock();
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'С BizLevel учатся предприниматели по всему СНГ',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColor.onSurfaceSubtle),
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
            style: TextStyle(color: AppColor.textColor.withValues(alpha: 0.5)),
          ),
        ),
        const Expanded(child: Divider(thickness: 0.5)),
      ],
    );
  }
}
