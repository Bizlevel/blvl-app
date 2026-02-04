import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:flutter/services.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/theme/spacing.dart';

enum BizLevelButtonVariant { primary, secondary, outline, text, danger, link }

enum BizLevelButtonSize { sm, md, lg }

class BizLevelButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final BizLevelButtonVariant variant;
  final BizLevelButtonSize size;
  final Widget? icon;
  final bool fullWidth;
  final Key? buttonKey;
  final bool enableHaptic;
  final Color? backgroundColorOverride;
  final Color? foregroundColorOverride;

  const BizLevelButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = BizLevelButtonVariant.primary,
    this.size = BizLevelButtonSize.md,
    this.icon,
    this.fullWidth = false,
    this.buttonKey,
    this.enableHaptic = true,
    this.backgroundColorOverride,
    this.foregroundColorOverride,
  });

  Size get _minSize {
    switch (size) {
      case BizLevelButtonSize.sm:
        return const Size(48, AppDimensions.minTouchTarget);
      case BizLevelButtonSize.md:
        return const Size(48, AppDimensions.buttonPrimaryMediumHeight);
      case BizLevelButtonSize.lg:
        return const Size(56, AppDimensions.buttonPrimaryLargeHeight);
    }
  }

  EdgeInsets get _padding {
    switch (size) {
      case BizLevelButtonSize.sm:
        return AppSpacing.insetsSymmetric(h: AppSpacing.lg, v: AppSpacing.sm);
      case BizLevelButtonSize.md:
        return AppSpacing.insetsSymmetric(h: AppSpacing.s20, v: AppSpacing.md);
      case BizLevelButtonSize.lg:
        return AppSpacing.insetsSymmetric(h: AppSpacing.xl, v: AppSpacing.s14);
    }
  }

  double get _radius {
    switch (size) {
      case BizLevelButtonSize.lg:
        return AppDimensions.radiusL;
      case BizLevelButtonSize.md:
      case BizLevelButtonSize.sm:
        return AppDimensions.radiusM;
    }
  }

  @override
  Widget build(BuildContext context) {
    void safeHapticTap() {
      if (enableHaptic) {
        try {
          HapticFeedback.lightImpact();
        } catch (_) {}
      }
      onPressed?.call();
    }

    final child = icon == null
        ? Text(
            label,
            softWrap: true,
            maxLines: 2,
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon!,
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  softWrap: true,
                  maxLines: 2,
                ),
              ),
            ],
          );

    final Widget button;
    switch (variant) {
      case BizLevelButtonVariant.primary:
        button = ElevatedButton(
          key: buttonKey,
          onPressed: onPressed == null ? null : safeHapticTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColorOverride ?? AppColor.primary,
            foregroundColor: foregroundColorOverride ?? AppColor.onPrimary,
            minimumSize: _minSize,
            padding: _padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_radius),
            ),
          ),
          child: child,
        );
        break;
      // Тёплый вариант CTA через outline+градиент бэкграунд (используется точечно)
      // Чтобы не ломать API, warm-стиль зададим через BizLevelButtonVariant.outline при необходимости на местах
      case BizLevelButtonVariant.danger:
        button = ElevatedButton(
          key: buttonKey,
          onPressed: onPressed == null ? null : safeHapticTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.error,
            foregroundColor: AppColor.onPrimary,
            minimumSize: _minSize,
            padding: _padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_radius),
            ),
          ),
          child: child,
        );
        break;
      case BizLevelButtonVariant.outline:
        button = OutlinedButton(
          key: buttonKey,
          onPressed: onPressed == null ? null : safeHapticTap,
          style: OutlinedButton.styleFrom(
            minimumSize: _minSize,
            padding: _padding,
            side: const BorderSide(color: AppColor.primary),
            foregroundColor: AppColor.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_radius),
            ),
          ),
          child: child,
        );
        break;
      case BizLevelButtonVariant.text:
        button = TextButton(
          key: buttonKey,
          onPressed: onPressed == null ? null : safeHapticTap,
          style: TextButton.styleFrom(
            minimumSize: _minSize,
            padding: _padding,
            foregroundColor: AppColor.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
          ),
          child: child,
        );
        break;
      case BizLevelButtonVariant.link:
        button = TextButton(
          key: buttonKey,
          onPressed: onPressed == null ? null : safeHapticTap,
          style: TextButton.styleFrom(
            minimumSize: _minSize,
            padding: _padding,
            foregroundColor: AppColor.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
            textStyle: const TextStyle(decoration: TextDecoration.underline),
          ),
          child: child,
        );
        break;
      case BizLevelButtonVariant.secondary:
        button = OutlinedButton(
          key: buttonKey,
          onPressed: onPressed == null ? null : safeHapticTap,
          style: OutlinedButton.styleFrom(
            minimumSize: _minSize,
            padding: _padding,
            side: const BorderSide(color: AppColor.borderColor),
            foregroundColor: AppColor.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_radius),
            ),
            backgroundColor: AppColor.surface,
          ),
          child: child,
        );
        break;
    }

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}
