import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Небольшой индикатор «набирает…» из трёх прыгающих точек.
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key, this.dotSize = 6, this.color});

  final double dotSize;
  final Color? color;

  /// Компактный вариант под текстовый бабл ассистента
  const TypingIndicator.small({super.key, this.dotSize = 6, this.color});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = widget.color ?? Colors.black38;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final double phase = (_controller.value + i * 0.2) % 1.0;
            // 0..1 → 0..2π
            final double t = phase * 2 * math.pi;
            final double dy = math.sin(t) * 2.0; // лёгкий вертикальный сдвиг
            final double scale = 0.8 + 0.2 * math.sin(t).abs();
            return Transform.translate(
              offset: Offset(0, -dy),
              child: Transform.scale(
                scale: scale,
                child: child,
              ),
            );
          },
          child: Container(
            width: widget.dotSize,
            height: widget.dotSize,
            margin: EdgeInsets.only(left: i == 0 ? 0 : 4),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }
}
