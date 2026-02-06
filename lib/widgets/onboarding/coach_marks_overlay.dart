import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/theme/spacing.dart';

class CoachMarkStep {
  final GlobalKey targetKey;
  final String title;
  final String description;
  const CoachMarkStep({
    required this.targetKey,
    required this.title,
    required this.description,
  });
}

class CoachMarksOverlay extends StatefulWidget {
  const CoachMarksOverlay({
    super.key,
    required this.steps,
    required this.onFinish,
  });

  final List<CoachMarkStep> steps;
  final VoidCallback onFinish;

  @override
  State<CoachMarksOverlay> createState() => _CoachMarksOverlayState();
}

class _CoachMarksOverlayState extends State<CoachMarksOverlay> {
  int _index = 0;

  void _next() {
    if (_index >= widget.steps.length - 1) {
      widget.onFinish();
      return;
    }
    setState(() => _index += 1);
  }

  Rect? _resolveRect(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final render = ctx.findRenderObject();
    if (render is! RenderBox || !render.hasSize) return null;
    final offset = render.localToGlobal(Offset.zero);
    return offset & render.size;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.steps.isEmpty) return const SizedBox.shrink();
    final step = widget.steps[_index];
    final rect = _resolveRect(step.targetKey);
    if (rect == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() {});
      });
      return const SizedBox.shrink();
    }

    final screen = MediaQuery.of(context).size;
    final double tooltipWidth = (screen.width - 32).clamp(240, 320);
    final bool placeBelow = rect.center.dy < screen.height * 0.6;
    final double top = placeBelow
        ? rect.bottom + 12
        : (rect.top - 12 - 120).clamp(12, screen.height - 160);
    final double left = (rect.center.dx - tooltipWidth / 2)
        .clamp(16, screen.width - tooltipWidth - 16);

    return Positioned.fill(
      child: Material(
        color: Colors.black.withValues(alpha: 0.55),
        child: Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _next,
            ),
            Positioned(
              left: rect.left - 6,
              top: rect.top - 6,
              width: rect.width + 12,
              height: rect.height + 12,
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      // Более яркий жёлтый бордер для лучшего акцента
                      color: AppColor.colorWarning,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  ),
                ),
              ),
            ),
            Positioned(
              left: left,
              top: top,
              width: tooltipWidth,
              child: Container(
                padding: AppSpacing.insetsAll(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColor.colorSurface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.shadowColor.withValues(alpha: 0.18),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      step.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColor.colorTextPrimary,
                          ),
                    ),
                    AppSpacing.gapH(AppSpacing.xs),
                    Text(
                      step.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColor.colorTextSecondary,
                          ),
                    ),
                    AppSpacing.gapH(AppSpacing.sm),
                    // Используем Stack, чтобы счётчик шагов был строго по центру,
                    // независимо от ширины кнопок слева и справа.
                    SizedBox(
                      height: 32,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Ряд с кнопками по краям
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: widget.onFinish,
                                child: const Text('Пропустить'),
                              ),
                              TextButton(
                                onPressed: _next,
                                child: Text(
                                  _index >= widget.steps.length - 1
                                      ? 'Готово'
                                      : 'Далее',
                                ),
                              ),
                            ],
                          ),
                          // Центрированный счётчик 1/4
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              '${_index + 1}/${widget.steps.length}',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: AppColor.colorTextSecondary,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
