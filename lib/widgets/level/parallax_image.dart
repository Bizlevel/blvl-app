import 'package:flutter/material.dart';

class ParallaxImage extends StatelessWidget {
  final String assetPath;
  final double height;
  const ParallaxImage(
      {super.key, required this.assetPath, required this.height});

  bool _isLowEnd(BuildContext context) {
    final mq = MediaQuery.of(context);
    final disableAnimations = View.of(context)
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;
    return mq.devicePixelRatio < 2.0 || disableAnimations;
  }

  @override
  Widget build(BuildContext context) {
    final lowEnd = _isLowEnd(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: NotificationListener<ScrollNotification>(
          onNotification: (_) => false,
          child: LayoutBuilder(builder: (context, c) {
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 1),
              builder: (context, v, child) {
                final dy = lowEnd ? 0.0 : 6.0;
                return Transform.translate(
                  offset: Offset(0, -dy),
                  child: child,
                );
              },
              child: Image.asset(
                assetPath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) =>
                    const SizedBox.shrink(),
              ),
            );
          }),
        ),
      ),
    );
  }
}
