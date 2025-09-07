import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';

class BizLevelProgressBar extends StatelessWidget {
  const BizLevelProgressBar({
    super.key,
    required this.value,
    this.minHeight = 6,
    this.color,
    this.backgroundColor,
    this.animated = true,
    this.duration = const Duration(milliseconds: 600),
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
    final Widget bar = LinearProgressIndicator(
      value: value.clamp(0.0, 1.0),
      minHeight: minHeight,
      backgroundColor: bg,
      valueColor: AlwaysStoppedAnimation<Color>(barColor),
    );
    if (!animated) return bar;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.clamp(0.0, 1.0)),
      duration: duration,
      builder: (context, v, _) => LinearProgressIndicator(
        value: v,
        minHeight: minHeight,
        backgroundColor: bg,
        valueColor: AlwaysStoppedAnimation<Color>(barColor),
      ),
    );
  }
}
