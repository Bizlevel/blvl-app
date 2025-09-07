import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';

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
      duration: const Duration(milliseconds: 800),
    );
    _t = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
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
      AchievementRarity.common =>
        const LinearGradient(colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)]),
      AchievementRarity.rare => AppColor.growthGradient,
      AchievementRarity.epic => AppColor.achievementGradient,
    };

    final Color border = switch (widget.rarity) {
      AchievementRarity.common => AppColor.borderColor,
      AchievementRarity.rare => const Color(0xFF06B6D4),
      AchievementRarity.epic => const Color(0xFF9333EA),
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
              boxShadow: [
                BoxShadow(
                    color: AppColor.shadow,
                    blurRadius: 6,
                    offset: const Offset(0, 3)),
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
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0x00FFFFFF),
                                Color(0x66FFFFFF),
                                Color(0x00FFFFFF)
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
        const SizedBox(height: 8),
        Text(
          widget.label!,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColor.onSurface),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
