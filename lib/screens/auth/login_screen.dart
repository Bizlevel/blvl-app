import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../providers/login_controller.dart';
import '../../services/auth_service.dart';
import '../../theme/color.dart' show AppColor;
import '../../widgets/custom_textfield.dart';
import '../../widgets/common/bizlevel_button.dart';
import '../../theme/spacing.dart';
import '../../theme/dimensions.dart';
import '../../utils/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final loginState = ref.watch(loginControllerProvider);
    final isLoading = loginState.isLoading;
    final obscurePassword = useState<bool>(true);
    final agreed = useState<bool>(false);

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
      } else if (next is AsyncData<void>) {
        // Показать бонус за регистрацию только после регистрации (registered=true).
        // Сервер начисляет идемпотентно, но UI-сообщение не должно появляться на каждом логине.
        if (registered) {
          try {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Добро пожаловать! +30 GP за регистрацию')),
            );
          } catch (_) {}
        }
      }
    });

    Future<void> submit() async {
      if (!agreed.value) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Подтвердите согласие с условиями')));
        return;
      }
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
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Анимированный фон (медленная ротация градиента, лёгкая)
          const _AnimatedGradientBackground(),
          Center(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: AppSpacing.insetsSymmetric(
                  h: AppSpacing.lg, v: AppSpacing.x3l),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Баннер успешной регистрации
                  if (registered) ...[
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                      padding: AppSpacing.insetsAll(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColor.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                            AppSpacing.xl), // visual radius = 24
                        border: Border.all(
                            color: AppColor.success.withValues(alpha: 0.3)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.check_circle,
                              color: AppColor.success, size: 24),
                          SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Text(
                              'Вы успешно зарегистрировались!',
                              style: TextStyle(
                                color: AppColor.success,
                                fontSize:
                                    16, // aligns with AppTypography.titleMedium
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
                    padding: AppSpacing.insetsSymmetric(
                        h: AppSpacing.lg, v: AppSpacing.xl),
                    decoration: BoxDecoration(
                      color: AppColor.surface,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radius24),
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
                        // Логотип BizLevel (light) — растровая версия
                        Container(
                          width: 224,
                          height: 224,
                          decoration: const BoxDecoration(
                            color: AppColor.surface,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/logo_light.png',
                            width: 176,
                            height: 176,
                          ),
                        ),
                        AppSpacing.gapH(AppSpacing.x2l),
                        CustomTextBox(
                          key: const ValueKey('email_field'),
                          hint: 'Email',
                          prefix: const Icon(Icons.email_outlined),
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          preset: TextFieldPreset.auth,
                          autofillHints: const [AutofillHints.email],
                        ),
                        AppSpacing.gapH(AppSpacing.lg),
                        // поле пароля с глазом
                        CustomTextBox(
                          key: const ValueKey('password_field'),
                          hint: 'Пароль',
                          prefix: const Icon(Icons.lock_outline),
                          controller: passwordController,
                          obscureText: obscurePassword.value,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          preset: TextFieldPreset.auth,
                          autofillHints: const [AutofillHints.password],
                          suffix: IconButton(
                            tooltip: obscurePassword.value
                                ? 'Показать пароль'
                                : 'Скрыть пароль',
                            icon: Icon(obscurePassword.value
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () =>
                                obscurePassword.value = !obscurePassword.value,
                          ),
                        ),
                        AppSpacing.gapH(AppSpacing.lg),
                        _AgreementRow(
                          checked: agreed.value,
                          onChanged: (v) => agreed.value = v,
                          onOpen: () => _openAgreement(context),
                        ),
                        AppSpacing.gapH(AppSpacing.xl),
                        // Основная CTA: «Войти» – сразу под полем пароля
                        BizLevelButton(
                          label: isLoading ? 'Входим…' : 'Войти',
                          onPressed: isLoading ? null : submit,
                        ),
                        AppSpacing.gapH(AppSpacing.xl),
                        if (kEnableGoogleAuth || kEnableAppleAuth)
                          const _OrDivider(),
                        if (kEnableGoogleAuth || kEnableAppleAuth)
                          AppSpacing.gapH(AppSpacing.xl),
                        if (kEnableGoogleAuth)
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.login),
                              label: const Text('Войти через Google'),
                              onPressed: () {
                                ref
                                    .read(loginControllerProvider.notifier)
                                    .signInWithGoogle();
                              },
                              style: OutlinedButton.styleFrom(
                                padding: AppSpacing.insetsSymmetric(
                                    v: AppSpacing.md),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppDimensions.radiusXl),
                                ),
                                side: BorderSide(
                                  color:
                                      AppColor.textColor.withValues(alpha: 0.2),
                                ),
                              ),
                            ),
                          ),
                        if (kEnableGoogleAuth) AppSpacing.gapH(AppSpacing.md),
                        if (kEnableAppleAuth &&
                            (kIsWeb || (!kIsWeb && Platform.isIOS)))
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.apple),
                              label: const Text('Войти через Apple'),
                              onPressed: () {
                                ref
                                    .read(loginControllerProvider.notifier)
                                    .signInWithApple();
                              },
                              style: OutlinedButton.styleFrom(
                                padding: AppSpacing.insetsSymmetric(
                                    v: AppSpacing.md),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppDimensions.radiusXl),
                                ),
                                side: BorderSide(
                                  color:
                                      AppColor.textColor.withValues(alpha: 0.2),
                                ),
                              ),
                            ),
                          ),
                        if (kEnableGoogleAuth || kEnableAppleAuth)
                          AppSpacing.gapH(AppSpacing.lg),
                        // Social proof (лёгкий блок
                        const _SocialProofBlock(),
                        AppSpacing.gapH(AppSpacing.sm),
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
                Color.lerp(AppColor.bgGradient.colors.first,
                    AppColor.bgGradient.colors.last, t * 0.6)!,
                Color.lerp(AppColor.bgGradient.colors.last,
                    AppColor.bgGradient.colors.first, t * 0.6)!,
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
            style: TextStyle(
                color: AppColor.onSurfaceSubtle.withValues(alpha: 0.7)),
          ),
        ),
        const Expanded(child: Divider(thickness: 0.5)),
      ],
    );
  }
}

class _AgreementRow extends StatelessWidget {
  final bool checked;
  final ValueChanged<bool> onChanged;
  final VoidCallback onOpen;
  const _AgreementRow({
    required this.checked,
    required this.onChanged,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: checked,
          onChanged: (v) => onChanged(v ?? false),
        ),
        Expanded(
          child: GestureDetector(
            onTap: onOpen,
            child: RichText(
              text: TextSpan(
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColor.onSurfaceSubtle),
                children: [
                  const TextSpan(text: 'Я принимаю '),
                  TextSpan(
                    text: 'Пользовательское соглашение',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColor.primary,
                          decoration: TextDecoration.underline,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> _openAgreement(BuildContext context) async {
  final uri = Uri.parse('https://www.bizlevel.kz/privacy');
  await showModalBottomSheet(
    context: context,
    showDragHandle: true,
    backgroundColor: AppColor.surface,
    isScrollControlled: true,
    builder: (ctx) {
      return DraggableScrollableSheet(
        expand: false,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        initialChildSize: 0.75,
        builder: (context, controller) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                child: Row(
                  children: [
                    Text(
                      'Пользовательское соглашение',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    IconButton(
                      tooltip: 'Закрыть',
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  controller: controller,
                  padding: AppSpacing.insetsAll(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Полный текст соглашения доступен по ссылке. Нажмите кнопку ниже, чтобы открыть документ.',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppColor.onSurfaceSubtle),
                      ),
                      AppSpacing.gapH(AppSpacing.lg),
                      BizLevelButton(
                        label: 'Открыть документ',
                        onPressed: () async {
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(
                              uri,
                              mode: LaunchMode.inAppWebView,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
