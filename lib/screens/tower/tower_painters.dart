part of '../biz_tower_screen.dart';

class _GridPathPainter extends CustomPainter {
  final List<_GridSegment> segments;
  _GridPathPainter({required this.segments});

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in segments) {
      final paint = Paint()
        ..color = s.color
        ..strokeWidth = kPathStroke
        ..style = PaintingStyle.stroke
        ..isAntiAlias = true;

      final path = Path();
      const double r = kCornerRadius;
      final dx = s.end.dx - s.start.dx;
      final dy = s.end.dy - s.start.dy;

      path.moveTo(s.start.dx, s.start.dy);
      if (dx.abs() < 1 || dy.abs() < 1) {
        path.lineTo(s.end.dx, s.end.dy);
      } else {
        final alignX = s.end.dx;
        final preCornerX = s.start.dx < alignX ? alignX - r : alignX + r;
        path.lineTo(preCornerX, s.start.dy);
        final control = Offset(alignX, s.start.dy);
        final cornerY = s.start.dy + (s.end.dy > s.start.dy ? r : -r);
        path.quadraticBezierTo(control.dx, control.dy, alignX, cornerY);
        path.lineTo(alignX, s.end.dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPathPainter oldDelegate) {
    return oldDelegate.segments != segments;
  }
}

class _DotGridPainter extends CustomPainter {
  final double spacing;
  final double radius;
  final Color color;
  _DotGridPainter(
      {required this.spacing, required this.radius, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    for (double y = spacing / 2; y < size.height; y += spacing) {
      for (double x = spacing / 2; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotGridPainter oldDelegate) {
    return oldDelegate.spacing != spacing ||
        oldDelegate.radius != radius ||
        oldDelegate.color != color;
  }
}
