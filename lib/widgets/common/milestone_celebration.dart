import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';

class MilestoneCelebration extends StatefulWidget {
  const MilestoneCelebration({super.key, required this.onClose, this.gpGain});

  final VoidCallback onClose;
  final int? gpGain;

  @override
  State<MilestoneCelebration> createState() => _MilestoneCelebrationState();
}

class _MilestoneCelebrationState extends State<MilestoneCelebration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1600))
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final isLowEnd = dpr < 2.0;
    return Stack(
      children: [
        // Dark overlay
        Positioned.fill(
          child: Container(color: Colors.black.withValues(alpha: 0.55)),
        ),
        // Lightweight confetti particles (custom painter)
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _ConfettiPainter(
                  animation: _controller, particles: isLowEnd ? 16 : 24),
            ),
          ),
        ),
        // Center content card
        Center(
          child: Container(
            width: 320,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColor.card,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                    color: AppColor.shadow,
                    blurRadius: 12,
                    offset: Offset(0, 6))
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Поздравляем!',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                const Text('Вы достигли вехи. Продолжайте в том же духе!',
                    textAlign: TextAlign.center),
                const SizedBox(height: 12),
                if (widget.gpGain != null)
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: widget.gpGain!.toDouble()),
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeOut,
                    builder: (context, value, _) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.local_fire_department,
                            color: AppColor.premium),
                        const SizedBox(width: 6),
                        Text('+${value.toInt()} GP',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: widget.onClose,
                    child: const Text('Продолжить'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.animation, this.particles = 24})
      : super(repaint: animation);

  final Animation<double> animation;
  final int particles;
  final Random _rnd = Random(1);

  @override
  void paint(Canvas canvas, Size size) {
    final t = animation.value;
    final int count = particles; // ограничение частиц
    for (int i = 0; i < count; i++) {
      final px = (i / count) * size.width + sin(i * 13.0) * 8;
      final py = t * (size.height + 40) - (i * 18 % 120);
      final paint = Paint()
        ..color = [
          AppColor.premium,
          AppColor.info,
          AppColor.success,
          AppColor.warning
        ][_rnd.nextInt(4)]
            .withValues(alpha: 0.8)
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(px, py), Offset(px + 6, py + 6), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}
