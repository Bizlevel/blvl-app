import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';

class DonutProgress extends StatefulWidget {
  final double value; // 0..1
  final double size;
  final double strokeWidth;
  final Duration duration;

  const DonutProgress({
    super.key,
    required this.value,
    this.size = 104,
    this.strokeWidth = 8,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<DonutProgress> createState() => _DonutProgressState();
}

class _DonutProgressState extends State<DonutProgress> {
  double _prev = 0.0;

  @override
  void didUpdateWidget(covariant DonutProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    _prev = oldWidget.value.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final clamped = widget.value.clamp(0.0, 1.0);
    return Semantics(
      label: 'Прогресс к цели',
      value: '${(clamped * 100).round()}%',
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: _prev, end: clamped),
          duration: widget.duration,
          curve: Curves.easeOutCubic,
          builder: (context, v, _) {
            return Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: widget.size,
                  height: widget.size,
                  child: CircularProgressIndicator(
                    value: v,
                    strokeWidth: widget.strokeWidth,
                    backgroundColor: AppColor.borderSubtle,
                    strokeCap: StrokeCap.round,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppColor.primary),
                  ),
                ),
                Text(
                  '${(v * 100).round()}%',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColor.primary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
