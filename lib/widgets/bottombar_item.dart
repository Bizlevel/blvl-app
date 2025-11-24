import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/theme/animations.dart';

class BottomBarItem extends StatelessWidget {
  const BottomBarItem(
    this.icon, {
    super.key,
    this.onTap,
    this.color = AppColor.onSurfaceSubtle,
    this.activeColor = AppColor.primary,
    this.isActive = false,
    this.isNotified = false,
    this.iconWidget,
    this.label,
    this.iconBuilder,
  });

  final IconData icon;
  final Color color;
  final Color activeColor;
  final bool isNotified;
  final bool isActive;
  final GestureTapCallback? onTap;
  final Widget? iconWidget;
  final String? label;
  final Widget Function(bool isActive, Color color, Color activeColor)? iconBuilder;

  @override
  Widget build(BuildContext context) {
    final Widget innerIcon = iconBuilder != null
        ? iconBuilder!(isActive, color, activeColor)
        : (iconWidget ??
            Icon(
              icon,
              color: isActive ? activeColor : color,
              size: 22,
            ));

    final Widget iconView = AnimatedContainer(
      duration: AppAnimations.normal,
      curve: AppAnimations.smoothCurve,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: AppColor.bottomBarColor,
        boxShadow: [
          if (isActive)
            BoxShadow(
              color: AppColor.shadowColor.withValues(alpha: 0.1),
              spreadRadius: 2,
              blurRadius: 2,
            ),
        ],
      ),
      child: innerIcon,
    );

    final Widget content = (label == null)
        ? iconView
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              iconView,
              const SizedBox(height: 2),
              // fix: inline типографика → textTheme.labelSmall
              Builder(builder: (context) {
                final base = Theme.of(context).textTheme.labelSmall;
                return Text(
                  label!,
                  style: base?.copyWith(
                    color: isActive ? activeColor : color,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  ),
                );
              }),
            ],
          );
    // fix: touch target ≥48dp, ripple через InkWell
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: onTap,
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(minHeight: AppDimensions.minTouchTarget),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Center(child: content),
          ),
        ),
      ),
    );
  }
}
