import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/widgets/common/bizlevel_button.dart';

class AnimatedButton extends StatefulWidget {
  const AnimatedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = BizLevelButtonVariant.primary,
    this.size = BizLevelButtonSize.md,
    this.icon,
    this.fullWidth = false,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final BizLevelButtonVariant variant;
  final BizLevelButtonSize size;
  final Widget? icon;
  final bool fullWidth;
  final bool loading;

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (widget.onPressed == null || widget.loading) return;
    try {
      HapticFeedback.lightImpact();
    } catch (_) {}
    await _controller.forward();
    await _controller.reverse();
    if (!mounted) return;
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final double start = 1.0;
    final double end = 0.95;
    final Animation<double> scale = Tween<double>(begin: start, end: end)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    final Widget content = widget.loading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColor.onPrimary),
            ),
          )
        : Text(widget.label, overflow: TextOverflow.ellipsis);

    final Widget base = BizLevelButton(
      label: widget.label,
      onPressed: _handleTap,
      variant: widget.variant,
      size: widget.size,
      icon: widget.icon,
      fullWidth: widget.fullWidth,
      enableHaptic: false,
    );

    final bool isPrimary = widget.variant == BizLevelButtonVariant.primary;
    final BorderRadius radius = BorderRadius.circular(8);

    return RepaintBoundary(
      child: ScaleTransition(
        scale: scale,
        child: isPrimary
            ? InkWell(
                borderRadius: radius,
                onTap: _handleTap,
                child: Container(
                  constraints: const BoxConstraints(minHeight: 44),
                  width: widget.fullWidth ? double.infinity : null,
                  decoration: const BoxDecoration(
                    gradient: AppColor.businessGradient,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: content,
                ),
              )
            : base,
      ),
    );
  }
}
