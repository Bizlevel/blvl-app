import 'package:flutter/material.dart';
import 'package:bizlevel/theme/dimensions.dart';

class HomeCta extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final double? height;
  const HomeCta({super.key, required this.title, required this.subtitle, required this.onTap, this.height});

  @override
  State<HomeCta> createState() => _HomeCtaState();
}

class _HomeCtaState extends State<HomeCta> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _pulse();
  }

  void _pulse() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 4));
      if (!mounted) break;
      await _ctrl.forward();
      _ctrl.reset();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.height ?? AppDimensions.homeCtaHeight;
    return Semantics(
      label: '${widget.title}. ${widget.subtitle}',
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: widget.onTap,
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (context, child) {
              final scale = 1.0 + 0.02 * _ctrl.value;
              return Transform.scale(
                scale: scale,
                child: Container(
                  height: height,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x804285F4),
                        blurRadius: 20,
                        offset: Offset(0, 6),
                      )
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 24),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.title.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}


