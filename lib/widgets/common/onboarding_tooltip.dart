import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';

/// Направление для попытки расположить подсказку
enum TooltipDirection { above, below, left, right }

/// Описание шага тура
class OnboardingTourStep {
  OnboardingTourStep({
    required this.targetKey,
    required this.title,
    required this.description,
    this.preferredDirection = TooltipDirection.below,
  });

  final GlobalKey targetKey;
  final String title;
  final String description;
  final TooltipDirection preferredDirection;
}

/// Контроллер показа тура (Overlay)
class OnboardingTourController {
  OnboardingTourController({required this.steps, this.onFinish, this.onSkip});

  final List<OnboardingTourStep> steps;
  final VoidCallback? onFinish;
  final VoidCallback? onSkip;

  OverlayEntry? _entry;
  int _index = 0;

  bool get isShowing => _entry != null;

  void start(BuildContext context) {
    if (steps.isEmpty || isShowing) return;
    _index = 0;
    _showCurrent(context);
  }

  void _showCurrent(BuildContext context) {
    final step = steps[_index];
    _entry = OverlayEntry(
      builder: (_) => _OnboardingTooltipOverlay(
        step: step,
        onNext: () {
          _entry?.remove();
          _entry = null;
          if (_index < steps.length - 1) {
            _index++;
            _showCurrent(context);
          } else {
            onFinish?.call();
          }
        },
        onSkip: () {
          _entry?.remove();
          _entry = null;
          onSkip?.call();
        },
      ),
    );
    Overlay.of(context, debugRequiredFor: context.widget).insert(_entry!);
  }

  void dispose() {
    _entry?.remove();
    _entry = null;
  }
}

class _OnboardingTooltipOverlay extends StatefulWidget {
  const _OnboardingTooltipOverlay(
      {required this.step, required this.onNext, required this.onSkip});

  final OnboardingTourStep step;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  @override
  State<_OnboardingTooltipOverlay> createState() =>
      _OnboardingTooltipOverlayState();
}

class _OnboardingTooltipOverlayState extends State<_OnboardingTooltipOverlay> {
  Rect _targetRect = Rect.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _computeTargetRect());
  }

  void _computeTargetRect() {
    final ctx = widget.step.targetKey.currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return;
    final offset = box.localToGlobal(Offset.zero);
    setState(() {
      _targetRect = offset & box.size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // Тень со сквозным «отверстием»
          Positioned.fill(
            child: CustomPaint(
              painter: _HolePainter(target: _targetRect),
            ),
          ),
          // Подсказка (пузырь)
          if (_targetRect != Rect.zero) _buildBubble(context),
          // Клик по пустому месту — пропустить
          Positioned.fill(
            child: GestureDetector(onTap: widget.onSkip),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const double padding = 12;
    const double bubbleWidth = 320;

    // Пытаемся расположить относительно preferredDirection
    Offset bubbleOffset;
    Alignment arrowAlign;
    bool arrowDown; // стрелка вниз (подсказка над элементом)

    switch (widget.step.preferredDirection) {
      case TooltipDirection.above:
        bubbleOffset = Offset(
          (_targetRect.center.dx - bubbleWidth / 2)
              .clamp(16.0, size.width - bubbleWidth - 16.0),
          (_targetRect.top - 16 - 120).clamp(16.0, _targetRect.top - 80),
        );
        arrowAlign = Alignment.bottomCenter;
        arrowDown = true;
        break;
      case TooltipDirection.below:
        bubbleOffset = Offset(
          (_targetRect.center.dx - bubbleWidth / 2)
              .clamp(16.0, size.width - bubbleWidth - 16.0),
          (_targetRect.bottom + 16)
              .clamp(_targetRect.bottom + 16, size.height - 160),
        );
        arrowAlign = Alignment.topCenter;
        arrowDown = false;
        break;
      case TooltipDirection.left:
        bubbleOffset = Offset(
          (_targetRect.left - bubbleWidth - 16)
              .clamp(16.0, size.width - bubbleWidth - 16.0),
          (_targetRect.center.dy - 80).clamp(16.0, size.height - 160),
        );
        arrowAlign = Alignment.centerRight;
        arrowDown = false;
        break;
      case TooltipDirection.right:
        bubbleOffset = Offset(
          (_targetRect.right + 16).clamp(16.0, size.width - bubbleWidth - 16.0),
          (_targetRect.center.dy - 80).clamp(16.0, size.height - 160),
        );
        arrowAlign = Alignment.centerLeft;
        arrowDown = false;
        break;
    }

    final bubble = Container(
      width: bubbleWidth,
      padding: const EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: AppColor.shadow,
              blurRadius: 12,
              offset: const Offset(0, 6))
        ],
        border: Border.all(color: AppColor.borderColor.withOpacity(0.6)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.step.title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(widget.step.description,
              style: const TextStyle(
                  fontSize: 14, color: AppColor.onSurfaceSubtle)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onSkip,
                  child: const Text('Пропустить тур'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.onNext,
                  child: const Text('Далее'),
                ),
              ),
            ],
          )
        ],
      ),
    );

    // Стрелка (указатель)
    final arrow = Align(
      alignment: arrowAlign,
      child: CustomPaint(
        size: const Size(20, 10),
        painter: _ArrowPainter(down: arrowDown),
      ),
    );

    return Positioned(
      left: bubbleOffset.dx,
      top: bubbleOffset.dy,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (arrowDown) arrow,
          bubble,
          if (!arrowDown) arrow,
        ],
      ),
    );
  }
}

class _HolePainter extends CustomPainter {
  _HolePainter({required this.target});
  final Rect target;

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = Colors.black.withValues(alpha: 0.6);
    final path = Path()..addRect(Offset.zero & size);
    final hole = Path()
      ..addRRect(RRect.fromRectAndRadius(
          target.inflate(8), const Radius.circular(12)));
    final diff = Path.combine(PathOperation.difference, path, hole);
    canvas.drawPath(diff, bg);
  }

  @override
  bool shouldRepaint(covariant _HolePainter oldDelegate) =>
      oldDelegate.target != target;
}

class _ArrowPainter extends CustomPainter {
  _ArrowPainter({required this.down});
  final bool down;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColor.surface
      ..style = PaintingStyle.fill;
    final path = Path();
    if (down) {
      // Треугольник «вниз»
      path.moveTo(0, 0);
      path.lineTo(size.width / 2, size.height);
      path.lineTo(size.width, 0);
    } else {
      // Треугольник «вверх»
      path.moveTo(0, size.height);
      path.lineTo(size.width / 2, 0);
      path.lineTo(size.width, size.height);
    }
    path.close();
    canvas.drawPath(path, paint);
    // Обводка
    final stroke = Paint()
      ..color = AppColor.borderColor.withOpacity(0.6)
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(covariant _ArrowPainter oldDelegate) =>
      oldDelegate.down != down;
}
