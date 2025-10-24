import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/animations.dart';

/// Анимируемая «галочка» успеха
/// - Длительность по умолчанию: 400мс
/// - Размеры: 24 или 48 (можно задать любой)
class SuccessIndicator extends StatefulWidget {
  const SuccessIndicator(
      {super.key, this.size = 24, this.duration = AppAnimations.normal});

  final double size;
  final Duration duration;

  const SuccessIndicator.s24({Key? key}) : this(key: key, size: 24);
  const SuccessIndicator.s48({Key? key}) : this(key: key, size: 48);

  @override
  State<SuccessIndicator> createState() => _SuccessIndicatorState();
}

class _SuccessIndicatorState extends State<SuccessIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          painter: _CheckPainter(
              progress: CurvedAnimation(
                      parent: _controller, curve: AppAnimations.defaultCurve)
                  .value),
        ),
      ),
    );
  }
}

class _CheckPainter extends CustomPainter {
  _CheckPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path();
    final double w = size.width;
    final double h = size.height;

    // Нормализованная галочка (под размеры 24/48)
    final Offset p1 = Offset(w * 0.18, h * 0.54);
    final Offset p2 = Offset(w * 0.42, h * 0.76);
    final Offset p3 = Offset(w * 0.82, h * 0.28);
    path.moveTo(p1.dx, p1.dy);
    path.lineTo(p2.dx, p2.dy);
    path.lineTo(p3.dx, p3.dy);

    // Градиент штриха (лёгкий)
    final Rect rect = Offset.zero & size;
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.12
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..shader = const LinearGradient(
        colors: [AppColor.success, Color(0xFF14B8A6)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);

    // Рисуем часть пути по прогрессу
    final metrics = path.computeMetrics();
    final Path draw = Path();
    for (final m in metrics) {
      final extractLen = m.length * progress.clamp(0.0, 1.0);
      draw.addPath(m.extractPath(0, extractLen), Offset.zero);
    }
    canvas.drawPath(draw, paint);
  }

  @override
  bool shouldRepaint(covariant _CheckPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
