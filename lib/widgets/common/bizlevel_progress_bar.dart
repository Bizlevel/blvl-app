import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/animations.dart';

class BizLevelProgressBar extends StatelessWidget {
  const BizLevelProgressBar({
    super.key,
    required this.value,
    this.minHeight = 6,
    this.color,
    this.backgroundColor,
    this.animated = true,
    this.duration = AppAnimations.slow,
  });

  final double value; // 0..1
  final double minHeight;
  final Color? color;
  final Color? backgroundColor;
  final bool animated;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final Color barColor = color ?? AppColor.primary;
    final Color bg = backgroundColor ?? barColor.withValues(alpha: 0.2);
    final double clamped = value.clamp(0.0, 1.0);
    const String semanticsLabel = 'Прогресс';
    final String semanticsValue = '${(clamped * 100).round()}%';
    final Widget bar = Semantics(
      label: semanticsLabel,
      value: semanticsValue,
      child: LinearProgressIndicator(
        value: clamped,
        minHeight: minHeight,
        backgroundColor: bg,
        valueColor: AlwaysStoppedAnimation<Color>(barColor),
      ),
    );
    if (!animated) return bar;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: clamped),
      duration: duration,
      builder: (context, v, _) => Semantics(
        label: semanticsLabel,
        value: '${(v * 100).round()}%',
        child: LinearProgressIndicator(
          value: v,
          minHeight: minHeight,
          backgroundColor: bg,
          valueColor: AlwaysStoppedAnimation<Color>(barColor),
        ),
      ),
    );
  }
}
