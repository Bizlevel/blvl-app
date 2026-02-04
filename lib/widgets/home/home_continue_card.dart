import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/theme/animations.dart';
import 'package:bizlevel/theme/glass_utils.dart';
import 'package:bizlevel/widgets/common/bizlevel_button.dart';
import 'package:bizlevel/widgets/common/bizlevel_card.dart';
import 'package:shimmer/shimmer.dart';

/// Карточка «Продолжить обучение» с текстом слева и иллюстрацией уровня справа.
class HomeContinueCard extends StatefulWidget {
  final String subtitle;
  final int levelNumber;
  final VoidCallback onTap;

  const HomeContinueCard({
    super.key,
    required this.subtitle,
    required this.levelNumber,
    required this.onTap,
  });

  @override
  State<HomeContinueCard> createState() => _HomeContinueCardState();
}

class _HomeContinueCardState extends State<HomeContinueCard> {
  bool _animated = false;

  @override
  Widget build(BuildContext context) {
    return BizLevelCard(
      semanticsLabel: 'Продолжить обучение. ${widget.subtitle}',
      onTap: widget.onTap,
      variant: GlassVariant.hero,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColor.colorPrimaryLight,
          AppColor.colorSurface,
        ],
      ),
      child: Row(
        children: [
          // Текстовая часть
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColor.colorPrimaryLight,
                    borderRadius: BorderRadius.circular(AppDimensions.radius6),
                    border: Border.all(color: AppColor.colorBorder),
                  ),
                  child: Text(
                    widget.levelNumber > 0
                        ? 'Уровень ${widget.levelNumber}'
                        : 'Уровень',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColor.colorPrimary,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                AppSpacing.gapH(AppSpacing.sm),
                Text(
                  widget.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                AppSpacing.gapH(AppSpacing.md),
                BizLevelButton(
                  label: 'Продолжить',
                  onPressed: widget.onTap,
                  size: BizLevelButtonSize.md,
                ),
              ],
            ),
          ),
          AppSpacing.gapW(16),
          // Изображение уровня справа
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            child: _FadeOnce(
              enabled: !_animated,
              onShown: () => setState(() => _animated = true),
              child: Container(
                width: 112,
                height: 88,
                color: AppColor.primary.withValues(alpha: 0.05),
                child: Image.asset(
                  'assets/images/lvls/level_${widget.levelNumber}.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.school,
                      color: AppColor.primary.withValues(alpha: 0.3),
                      size: 40,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FadeOnce extends StatefulWidget {
  final Widget child;
  final bool enabled;
  final VoidCallback onShown;
  const _FadeOnce(
      {required this.child, required this.enabled, required this.onShown});

  @override
  State<_FadeOnce> createState() => _FadeOnceState();
}

class _FadeOnceState extends State<_FadeOnce>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl =
      AnimationController(vsync: this, duration: AppAnimations.normal)
        ..forward().whenComplete(() {
          widget.onShown();
        });

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;
    return FadeTransition(opacity: _ctrl, child: widget.child);
  }
}

class HomeContinueCardSkeleton extends StatelessWidget {
  const HomeContinueCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return BizLevelCard(
      outlined: true,
      child: Shimmer.fromColors(
        baseColor: AppColor.colorBackgroundSecondary,
        highlightColor: AppColor.colorSurface,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 92,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColor.colorSurface,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                  ),
                  AppSpacing.gapH(AppSpacing.sm),
                  Container(
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppColor.colorSurface,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                  ),
                  AppSpacing.gapH(AppSpacing.xs),
                  Container(
                    width: 160,
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppColor.colorSurface,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                  ),
                  AppSpacing.gapH(AppSpacing.md),
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColor.colorSurface,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusLg),
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.gapW(16),
            Container(
              width: 112,
              height: 88,
              decoration: BoxDecoration(
                color: AppColor.colorSurface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
