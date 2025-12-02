import 'package:flutter/material.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/spacing.dart';

class HomeCta extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final double? height;
  const HomeCta(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.onTap,
      this.height});

  @override
  State<HomeCta> createState() => _HomeCtaState();
}

class _HomeCtaState extends State<HomeCta> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
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
          borderRadius: BorderRadius.circular(AppDimensions.radius14),
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
                    // fix: заменить градиент/тени на токены
                    gradient: AppColor.businessGradient,
                    borderRadius: BorderRadius.circular(AppDimensions.radius14),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColor.shadow,
                        blurRadius: 20,
                        offset: Offset(0, 6),
                      )
                    ],
                  ),
                  // fix: spacing токен
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    children: [
                      const Icon(Icons.play_arrow_rounded,
                          color: AppColor.onPrimary, size: 24),
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
                              // fix: типографика через textTheme
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(color: AppColor.onPrimary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              // fix: типографика через textTheme
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: AppColor.onPrimary
                                          .withValues(alpha: 0.85)),
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
