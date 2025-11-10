import 'package:flutter/material.dart';

/// Публичный полноэкранный просмотрщик артефакта с «переворотом» (front/back).
class ArtifactViewer extends StatefulWidget {
  const ArtifactViewer({super.key, required this.front, required this.back});
  final String front;
  final String back;

  @override
  State<ArtifactViewer> createState() => _ArtifactViewerState();
}

class _ArtifactViewerState extends State<ArtifactViewer>
    with SingleTickerProviderStateMixin {
  late bool _showFront = true;
  late AnimationController _ctrl;
  late Animation<double> _anim;
  late Image _frontImg;
  late Image _backImg;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _anim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutCubic),
    );
    // Предзагрузка обеих сторон
    _frontImg = Image.asset(widget.front);
    _backImg = Image.asset(widget.back);
    // Запланируем precache после первой раскладки
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      precacheImage(_frontImg.image, context);
      precacheImage(_backImg.image, context);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _flip() async {
    if (_ctrl.isAnimating) return;
    await _ctrl.forward();
    setState(() => _showFront = !_showFront);
    _ctrl.reset();
  }

  @override
  Widget build(BuildContext context) {
    final image = _showFront ? widget.front : widget.back;
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        // Свайп меняет сторону
        final v = details.primaryVelocity ?? 0;
        if (v.abs() < 50) return;
        _flip();
      },
      onTap: _flip,
      child: Scaffold(
        backgroundColor: Colors.black.withValues(alpha: 0.85),
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: AnimatedBuilder(
                  animation: _anim,
                  builder: (context, child) {
                    const double pi = 3.1415926535;
                    final double angle = _anim.value * pi; // 0..pi
                    final bool pastHalf = angle > pi / 2;
                    final double displayAngle = pastHalf ? pi - angle : angle;
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.0015)
                        ..rotateY(displayAngle),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 900),
                        child: Image.asset(
                          image,
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  tooltip: 'Закрыть',
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              // Переключатели Front/Back
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _ChipToggle(
                        label: 'Front',
                        active: _showFront,
                        onTap: () {
                          if (!_showFront) _flip();
                        },
                      ),
                      const SizedBox(width: 6),
                      _ChipToggle(
                        label: 'Back',
                        active: !_showFront,
                        onTap: () {
                          if (_showFront) _flip();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.touch_app, color: Colors.white, size: 16),
                        SizedBox(width: 6),
                        Text('Тапните, чтобы перевернуть',
                            style:
                                TextStyle(color: Colors.white, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ChipToggle extends StatelessWidget {
  const _ChipToggle(
      {required this.label, required this.active, required this.onTap});
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: Colors.white.withValues(alpha: active ? 0.0 : 0.5)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.black : Colors.white,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
