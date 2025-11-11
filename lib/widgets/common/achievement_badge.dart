import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/animations.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/typography.dart';

enum AchievementRarity { common, rare, epic }

enum AchievementBadgeSize { s48, s80 }

/// Бейдж достижения с учётом редкости и лёгким shine-эффектом (одноразово)
class AchievementBadge extends StatefulWidget {
  const AchievementBadge({
    super.key,
    required this.icon,
    this.rarity = AchievementRarity.common,
    this.size = AchievementBadgeSize.s48,
    this.label,
  });

  final IconData icon;
  final AchievementRarity rarity;
  final AchievementBadgeSize size;
  final String? label;

  @override
  State<AchievementBadge> createState() => _AchievementBadgeState();
}

class _AchievementBadgeState extends State<AchievementBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _t;
  bool _shinePlayed = false;
  Timer? _cooldown;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.verySlow,
    );
    _t =
        CurvedAnimation(parent: _controller, curve: AppAnimations.defaultCurve);
    // Запускаем shine один раз при первом появлении
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playShineOnce();
    });
  }

  void _playShineOnce() {
    if (_shinePlayed) return;
    _shinePlayed = true;
    _controller.forward(from: 0);
    _cooldown?.cancel();
    _cooldown = Timer(const Duration(seconds: 3), () {});
  }

  @override
  void dispose() {
    _cooldown?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double d =
        switch (widget.size) { AchievementBadgeSize.s48 => 48, _ => 80 };
    final double iconSize = widget.size == AchievementBadgeSize.s48 ? 22 : 36;

    final Gradient fill = switch (widget.rarity) {
      AchievementRarity.common => AppColor.badgeBgLight,
      AchievementRarity.rare => AppColor.growthGradient,
      AchievementRarity.epic => AppColor.achievementGradient,
    };

    final Color border = switch (widget.rarity) {
      AchievementRarity.common => AppColor.borderColor,
      AchievementRarity.rare => AppColor.cyan,
      AchievementRarity.epic => AppColor.premium,
    };

    final Color iconColor = switch (widget.rarity) {
      AchievementRarity.common => AppColor.darker,
      AchievementRarity.rare => AppColor.onPrimary,
      AchievementRarity.epic => AppColor.onPrimary,
    };

    final badge = RepaintBoundary(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: d,
            height: d,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: fill,
              boxShadow: const [
                BoxShadow(
                    color: AppColor.shadow,
                    blurRadius: 6,
                    offset: Offset(0, 3)),
              ],
              border: Border.all(color: border, width: 2),
            ),
          ),
          Icon(widget.icon, size: iconSize, color: iconColor),
          // Shine overlay (одноразовый проход диагонального блика)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _t,
              builder: (context, child) {
                final dx = -1.0 + _t.value * 3.0; // пролёт слева направо
                return Opacity(
                  opacity: (_t.value > 0.1 && _t.value < 0.9) ? 0.55 : 0,
                  child: Transform.rotate(
                    angle: 0.6,
                    child: FractionalTranslation(
                      translation: Offset(dx, 0),
                      child: ClipOval(
                        child: Container(
                          width: d,
                          height: d,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColor.whiteA0,
                                AppColor.whiteA40,
                                AppColor.whiteA0
                              ],
                              stops: [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );

    if (widget.label == null) return badge;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        badge,
        AppSpacing.gapH(AppSpacing.sm),
        Text(
          widget.label!,
          style: AppTypography.textTheme.labelMedium
              ?.copyWith(color: AppColor.onSurface),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
