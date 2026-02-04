import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/widgets/common/bizlevel_card.dart';
import 'package:bizlevel/widgets/common/bizlevel_button.dart';
import 'package:bizlevel/widgets/common/bizlevel_text_field.dart';
import 'package:bizlevel/services/referral_service.dart';
import 'package:bizlevel/services/referral_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/providers/gp_providers.dart';

/// Переиспользуемый виджет для реферальной системы.
/// 
/// Варианты использования:
/// - [ReferralShareCard()] — полный блок с кодом, кнопкой поделиться и полем ввода
/// - [ReferralShareCard.compact()] — только кнопка поделиться (для Магазина GP)
/// - [ReferralShareCard.inputOnly()] — только поле ввода промокода
class ReferralShareCard extends ConsumerStatefulWidget {
  /// Показывать ли поле для ввода чужого промокода
  final bool showInput;
  
  /// Компактный режим (без карточки)
  final bool compact;
  
  /// Callback при успешном применении кода
  final VoidCallback? onCodeApplied;

  const ReferralShareCard({
    super.key,
    this.showInput = true,
    this.compact = false,
    this.onCodeApplied,
  });

  /// Компактный вариант — только кнопка поделиться
  const ReferralShareCard.compact({
    super.key,
    this.onCodeApplied,
  })  : showInput = false,
        compact = true;

  /// Только поле ввода промокода
  const ReferralShareCard.inputOnly({
    super.key,
    this.onCodeApplied,
  })  : showInput = true,
        compact = true;

  @override
  ConsumerState<ReferralShareCard> createState() => _ReferralShareCardState();
}

class _ReferralShareCardState extends ConsumerState<ReferralShareCard> {
  String? _myCode;
  bool _codeLoading = false;
  String? _loadError;
  
  final _inputController = TextEditingController();
  bool _applyingCode = false;
  String? _statusMessage;
  bool _statusIsError = false;

  @override
  void initState() {
    super.initState();
    _loadMyCode();
    _inputController.addListener(_clearStatus);
  }

  @override
  void dispose() {
    _inputController.removeListener(_clearStatus);
    _inputController.dispose();
    super.dispose();
  }

  void _clearStatus() {
    if (_statusMessage != null) {
      setState(() {
        _statusMessage = null;
        _statusIsError = false;
      });
    }
  }

  Future<void> _loadMyCode() async {
    if (_codeLoading || (_myCode != null && _myCode!.isNotEmpty)) return;
    setState(() {
      _codeLoading = true;
      _loadError = null;
    });
    try {
      final service = ReferralService(Supabase.instance.client);
      final code = await service.getMyReferralCode();
      if (!mounted) return;
      setState(() => _myCode = code);
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadError = 'Код временно недоступен');
    } finally {
      if (mounted) setState(() => _codeLoading = false);
    }
  }

  void _share() {
    final code = _myCode;
    final String text;
    if (code != null && code.isNotEmpty) {
      text = 'Мой код BizLevel: $code\n'
          'Используй при регистрации и получи 100 GP!\n'
          'Скачай: bizlevel.kz';
    } else {
      text = 'BizLevel — платформа для предпринимателей. '
          'Присоединяйся: bizlevel.kz';
    }
    Share.share(text);
  }

  Future<void> _applyCode() async {
    final code = ReferralStorage.normalizeCode(_inputController.text);
    if (code == null || code.isEmpty) {
      setState(() {
        _statusMessage = 'Введите промокод';
        _statusIsError = true;
      });
      return;
    }

    setState(() => _applyingCode = true);
    try {
      final service = ReferralService(Supabase.instance.client);
      
      // Сначала как промокод
      try {
        await service.redeemPromoCode(code);
        if (!mounted) return;
        _inputController.clear();
        ref.invalidate(gpBalanceProvider);
        setState(() {
          _statusMessage = 'Промокод применён, баланс обновлён';
          _statusIsError = false;
        });
        widget.onCodeApplied?.call();
        return;
      } on PromoFailure catch (e) {
        if (!e.message.contains('не найден')) {
          setState(() {
            _statusMessage = e.message;
            _statusIsError = true;
          });
          return;
        }
      }

      // Потом как реферальный код
      try {
        await service.applyReferralCode(code);
        if (!mounted) return;
        _inputController.clear();
        setState(() {
          _statusMessage = 'Код принят. Бонус после уровней 0 и 1';
          _statusIsError = false;
        });
        widget.onCodeApplied?.call();
      } on ReferralFailure catch (e) {
        setState(() {
          _statusMessage = e.message;
          _statusIsError = true;
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _statusMessage = 'Не удалось применить код';
        _statusIsError = true;
      });
    } finally {
      if (mounted) setState(() => _applyingCode = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = _buildContent(context);
    
    if (widget.compact) {
      return content;
    }
    
    return BizLevelCard.content(
      padding: AppSpacing.insetsAll(AppSpacing.md),
      child: content,
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final hasCode = _myCode?.isNotEmpty == true;
    final codeText = hasCode
        ? _myCode!
        : (_loadError ?? (_codeLoading ? 'Загрузка...' : 'Код недоступен'));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок с кодом
        Text(
          'Пригласи друга',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        AppSpacing.gapH(AppSpacing.sm),
        
        // Код и кнопка поделиться
        Row(
          children: [
            Expanded(
              child: Container(
                padding: AppSpacing.insetsSymmetric(
                  h: AppSpacing.md,
                  v: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColor.colorPrimaryLight,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: Text(
                  codeText,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            BizLevelButton(
              label: 'Поделиться',
              onPressed: hasCode && !_codeLoading ? _share : null,
              size: BizLevelButtonSize.sm,
              variant: BizLevelButtonVariant.outline,
            ),
          ],
        ),
        AppSpacing.gapH(AppSpacing.xs),
        
        // Подсказка
        Text(
          '+100 GP вам и другу после уровней 0 и 1',
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColor.onSurfaceSubtle,
          ),
        ),
        
        // Индикатор загрузки
        if (_codeLoading) ...[
          AppSpacing.gapH(AppSpacing.s6),
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ],
        
        // Ошибка загрузки
        if (_loadError != null && !_codeLoading) ...[
          AppSpacing.gapH(AppSpacing.s6),
          Text(
            _loadError!,
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColor.error,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        
        // Поле ввода промокода
        if (widget.showInput) ...[
          AppSpacing.gapH(AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: BizLevelTextField(
                  hint: 'Введите промокод',
                  controller: _inputController,
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _applyCode(),
                ),
              ),
              AppSpacing.gapW(AppSpacing.sm),
              BizLevelButton(
                label: 'Применить',
                onPressed: _applyingCode ? null : _applyCode,
                size: BizLevelButtonSize.sm,
              ),
            ],
          ),
          
          // Статус применения
          if (_statusMessage != null) ...[
            AppSpacing.gapH(AppSpacing.s6),
            Text(
              _statusMessage!,
              style: theme.textTheme.labelMedium?.copyWith(
                color: _statusIsError ? AppColor.error : AppColor.success,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ],
    );
  }
}
