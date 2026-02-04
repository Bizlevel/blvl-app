import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/widgets/common/bizlevel_button.dart';
import 'package:bizlevel/widgets/common/bizlevel_text_field.dart';
import 'package:bizlevel/services/referral_service.dart';
import 'package:bizlevel/services/referral_storage.dart';

/// Модальное окно для ввода промокода после завершения уровня 0.
/// Показывается один раз.
class PromoReminderModal extends StatefulWidget {
  final VoidCallback? onCodeApplied;
  final VoidCallback? onDismiss;

  const PromoReminderModal({
    super.key,
    this.onCodeApplied,
    this.onDismiss,
  });

  /// Ключ в SharedPreferences для отслеживания показа
  static const String _shownKey = 'promo_reminder_shown';

  /// Проверяет, нужно ли показывать модал
  static Future<bool> shouldShow() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_shownKey) ?? false);
  }

  /// Отмечает, что модал был показан
  static Future<void> markShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_shownKey, true);
  }

  /// Показывает модал если нужно
  static Future<void> showIfNeeded(BuildContext context) async {
    if (!await shouldShow()) return;
    if (!context.mounted) return;
    
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PromoReminderModal(
        onDismiss: () {
          markShown();
          Navigator.of(ctx).pop();
        },
        onCodeApplied: () {
          markShown();
          Navigator.of(ctx).pop();
        },
      ),
    );
  }

  @override
  State<PromoReminderModal> createState() => _PromoReminderModalState();
}

class _PromoReminderModalState extends State<PromoReminderModal> {
  final _controller = TextEditingController();
  bool _isLoading = false;
  String? _statusMessage;
  bool _isError = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _applyCode() async {
    final code = ReferralStorage.normalizeCode(_controller.text);
    if (code == null || code.isEmpty) {
      setState(() {
        _statusMessage = 'Введите промокод';
        _isError = true;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = null;
    });

    try {
      final service = ReferralService(Supabase.instance.client);
      
      // Сначала пробуем как промокод
      try {
        await service.redeemPromoCode(code);
        if (!mounted) return;
        setState(() {
          _statusMessage = 'Промокод применён!';
          _isError = false;
        });
        await Future.delayed(const Duration(milliseconds: 800));
        widget.onCodeApplied?.call();
        return;
      } on PromoFailure catch (e) {
        if (!e.message.contains('не найден')) {
          setState(() {
            _statusMessage = e.message;
            _isError = true;
          });
          return;
        }
      }

      // Если промокод не найден — пробуем как реферальный код
      try {
        await service.applyReferralCode(code);
        if (!mounted) return;
        setState(() {
          _statusMessage = 'Код принят! Бонус после уровня 1';
          _isError = false;
        });
        await Future.delayed(const Duration(milliseconds: 800));
        widget.onCodeApplied?.call();
      } on ReferralFailure catch (e) {
        setState(() {
          _statusMessage = e.message;
          _isError = true;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _statusMessage = 'Не удалось применить код';
        _isError = true;
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.lg),
      padding: AppSpacing.insetsAll(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColor.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          AppSpacing.gapH(AppSpacing.lg),
          
          // Icon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColor.colorAccentWarm.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.card_giftcard,
              color: AppColor.colorAccentWarm,
              size: 28,
            ),
          ),
          AppSpacing.gapH(AppSpacing.md),
          
          // Title
          Text(
            'Есть промокод?',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          AppSpacing.gapH(AppSpacing.sm),
          
          // Subtitle
          Text(
            'Введите промокод от друга и получите 100 GP после прохождения уровня 1',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColor.onSurfaceSubtle,
                ),
          ),
          AppSpacing.gapH(AppSpacing.lg),
          
          // Input
          BizLevelTextField(
            hint: 'Промокод',
            controller: _controller,
            textCapitalization: TextCapitalization.characters,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _applyCode(),
          ),
          
          // Status message
          if (_statusMessage != null) ...[
            AppSpacing.gapH(AppSpacing.sm),
            Text(
              _statusMessage!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _isError ? AppColor.error : AppColor.success,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
          AppSpacing.gapH(AppSpacing.lg),
          
          // Buttons
          Row(
            children: [
              Expanded(
                child: BizLevelButton(
                  label: 'Пропустить',
                  variant: BizLevelButtonVariant.secondary,
                  onPressed: _isLoading ? null : widget.onDismiss,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: BizLevelButton(
                  label: 'Применить',
                  onPressed: _isLoading ? null : _applyCode,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
