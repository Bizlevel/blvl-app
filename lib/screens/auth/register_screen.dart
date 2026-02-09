import 'dart:developer';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/common/bizlevel_button.dart';
import '../../services/referral_storage.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _promoController = TextEditingController();

  bool _isLoading = false;
  bool _registrationSuccess = false;

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreed = false;
  bool _showPromoField = false;

  @override
  void initState() {
    super.initState();
    _loadPendingPromoCode();
  }

  Future<void> _loadPendingPromoCode() async {
    final pending = await ReferralStorage.getPendingReferralCode();
    if (pending != null && pending.isNotEmpty && mounted) {
      setState(() {
        _promoController.text = pending;
        _showPromoField = true;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _promoController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_agreed) {
      _showSnackBar('Подтвердите согласие с условиями');
      return;
    }
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
      Sentry.addBreadcrumb(Breadcrumb(
        category: 'auth',
        level: SentryLevel.info,
        message: 'auth_register_submit',
      ));
    } catch (_) {}
    // Сохраняем промокод для применения после авторизации
    final promoCode = _promoController.text.trim();
    if (promoCode.isNotEmpty) {
      await ReferralStorage.savePendingReferralCode(promoCode);
    }
    
    log('Attempting to sign up with email: $email');
    try {
      await ref.read(authServiceProvider).signUp(
            email: email,
            password: password,
          );
      log('Sign up successful for email: $email');
      try {
        Sentry.addBreadcrumb(Breadcrumb(
          category: 'auth',
          level: SentryLevel.info,
          message: 'auth_register_success',
          data: {'has_promo': promoCode.isNotEmpty},
        ));
      } catch (_) {}
      if (!mounted) return;
      // Устанавливаем состояние успешной регистрации для показа экрана подтверждения
      setState(() => _registrationSuccess = true);
    } on AuthFailure catch (e) {
      log('AuthFailure during sign up for $email', error: e);
      try {
        Sentry.addBreadcrumb(Breadcrumb(
          category: 'auth',
          level: SentryLevel.warning,
          message: 'auth_register_fail',
          data: {'error_type': e.runtimeType.toString()},
        ));
      } catch (_) {}
      _showSnackBar(e.message);
    } catch (e, st) {
      log('Unknown error during sign up for $email', error: e, stackTrace: st);
      try {
        Sentry.addBreadcrumb(Breadcrumb(
          category: 'auth',
          level: SentryLevel.warning,
          message: 'auth_register_fail',
          data: {'error_type': e.runtimeType.toString()},
        ));
      } catch (_) {}
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
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColor.bgGradient),
        child: Center(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
        Image.asset(
          'assets/images/logo_light.png',
          width: 176,
          height: 176,
        ),
        AppSpacing.gapH(AppSpacing.xl),
        CustomTextBox(
          key: const Key('email_field'),
          hint: 'Email',
          prefix: const Icon(Icons.email_outlined),
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.email],
          preset: TextFieldPreset.auth,
        ),
        AppSpacing.gapH(AppSpacing.lg),
        CustomTextBox(
          key: const Key('password_field'),
          hint: 'Пароль',
          prefix: const Icon(Icons.lock_outline),
          controller: _passwordController,
          obscureText: _obscurePassword,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.password],
          preset: TextFieldPreset.auth,
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
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.password],
          preset: TextFieldPreset.auth,
          suffix: IconButton(
            tooltip: _obscureConfirm ? 'Показать пароль' : 'Скрыть пароль',
            icon:
                Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
          ),
        ),
        AppSpacing.gapH(AppSpacing.md),
        // Сворачиваемое поле промокода
        _PromoCodeSection(
          controller: _promoController,
          isExpanded: _showPromoField,
          onToggle: () => setState(() => _showPromoField = !_showPromoField),
        ),
        AppSpacing.gapH(AppSpacing.lg),
        _AgreementRow(
          checked: _agreed,
          onChanged: (v) => setState(() => _agreed = v),
          onOpen: () => _openAgreement(context),
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
        if (kEnableGoogleAuth || kEnableAppleAuth) const _OrDivider(),
        if (kEnableGoogleAuth || kEnableAppleAuth)
          AppSpacing.gapH(AppSpacing.lg),
        if (kEnableGoogleAuth)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.login),
              label: const Text('Регистрация через Google'),
              onPressed: () async {
                // Сохраняем промокод перед OAuth
                final promoCode = _promoController.text.trim();
                if (promoCode.isNotEmpty) {
                  await ReferralStorage.savePendingReferralCode(promoCode);
                }
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
        if (kEnableGoogleAuth) AppSpacing.gapH(AppSpacing.md),
        if (kEnableAppleAuth && (kIsWeb || (!kIsWeb && Platform.isIOS)))
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.apple),
              label: const Text('Регистрация через Apple'),
              onPressed: () async {
                // Сохраняем промокод перед OAuth
                final promoCode = _promoController.text.trim();
                if (promoCode.isNotEmpty) {
                  await ReferralStorage.savePendingReferralCode(promoCode);
                }
                ref.read(loginControllerProvider.notifier).signInWithApple();
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
        if (kEnableGoogleAuth || kEnableAppleAuth)
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
        Image.asset(
          'assets/images/logo_light.png',
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

class _PromoCodeSection extends StatelessWidget {
  final TextEditingController controller;
  final bool isExpanded;
  final VoidCallback onToggle;

  const _PromoCodeSection({
    required this.controller,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onToggle,
          child: Row(
            children: [
              Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: AppColor.primary,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                'Есть промокод?',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColor.primary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
        if (isExpanded) ...[
          AppSpacing.gapH(AppSpacing.sm),
          CustomTextBox(
            hint: 'Введите промокод или код друга',
            prefix: const Icon(Icons.card_giftcard_outlined),
            controller: controller,
            textCapitalization: TextCapitalization.characters,
            textInputAction: TextInputAction.done,
            preset: TextFieldPreset.auth,
          ),
          AppSpacing.gapH(AppSpacing.xs),
          Text(
            'Промокод будет применён после подтверждения email',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColor.onSurfaceSubtle,
                  fontSize: 11,
                ),
          ),
        ],
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
      crossAxisAlignment: CrossAxisAlignment.center,
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
                  const TextSpan(text: 'Я ознакомился(ась) и принимаю '),
                  TextSpan(
                    text: 'Условия использования BizLevel',
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
  final uri = Uri.parse('https://bizlevel.kz/terms');
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
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColor.onSurfaceSubtle),
                            children: [
                              const TextSpan(
                                  text:
                                      'Полный текст соглашения доступен на нашем сайте: '),
                              TextSpan(
                                text: 'https://bizlevel.kz/terms',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColor.primary,
                                      decoration: TextDecoration.underline,
                                    ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
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
