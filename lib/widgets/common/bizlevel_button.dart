import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:flutter/services.dart';

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
  });

  Size get _minSize {
    switch (size) {
      case BizLevelButtonSize.sm:
        return const Size(48, 48);
      case BizLevelButtonSize.md:
        return const Size(52, 52);
      case BizLevelButtonSize.lg:
        return const Size(56, 56);
    }
  }

  EdgeInsets get _padding {
    switch (size) {
      case BizLevelButtonSize.sm:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 10);
      case BizLevelButtonSize.md:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case BizLevelButtonSize.lg:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 14);
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
        ? Text(label)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon!,
              const SizedBox(width: 8),
              Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
            ],
          );

    final Widget button;
    switch (variant) {
      case BizLevelButtonVariant.primary:
        button = ElevatedButton(
          key: buttonKey,
          onPressed: onPressed == null ? null : safeHapticTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primary,
            foregroundColor: AppColor.onPrimary,
            minimumSize: _minSize,
            padding: _padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: child,
        );
        break;
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
              borderRadius: BorderRadius.circular(8),
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
              borderRadius: BorderRadius.circular(8),
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
              borderRadius: BorderRadius.circular(8),
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
