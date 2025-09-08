import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:bizlevel/theme/spacing.dart';

import 'custom_image.dart';
import 'package:bizlevel/utils/formatters.dart';

class LevelCard extends StatefulWidget {
  const LevelCard({
    super.key,
    required this.data,
    this.width = double.infinity,
    this.height = 290,
    this.onTap,
    this.compact = false,
  });

  final Map<String, dynamic> data;
  final double width;
  final double height;
  final GestureTapCallback? onTap;
  final bool compact;

  @override
  State<LevelCard> createState() => _LevelCardState();
}

class _LevelCardState extends State<LevelCard> {
  bool _hover = false;

  bool get _isLocked => widget.data["isLocked"] == true;

  bool get _isCompleted => widget.data["isCompleted"] == true;
  bool get _isCurrent => widget.data["isCurrent"] == true;

  @override
  Widget build(BuildContext context) {
    final enableHover = kIsWeb && MediaQuery.of(context).size.width >= 600;

    Widget card = LayoutBuilder(
      builder: (context, constraints) {
        final double cardWidth = constraints.maxWidth;
        // Отношение ширины к высоте изображения ~ 5:3
        final bool isMobile = MediaQuery.of(context).size.width < 600;
        // В компактном режиме уменьшаем высоту изображения (~-40%)
        final double imageRatio =
            widget.compact ? (isMobile ? 0.3 : 0.36) : (isMobile ? 0.5 : 0.6);
        final double imageHeight = cardWidth * imageRatio;

        return GestureDetector(
          onTap: _isLocked
              ? null
              : () {
                  HapticFeedback.lightImpact();
                  widget.onTap?.call();
                },
          child: Container(
            key: const Key('level_card'),
            width: widget.width,
            padding: const EdgeInsets.all(AppSpacing.medium),
            margin: const EdgeInsets.symmetric(vertical: AppSpacing.small),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: _isCurrent
                    ? AppColor.info
                    : AppColor.labelColor.withValues(alpha: 0.3),
                width: _isCurrent ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColor.shadowColor.withValues(
                    alpha: 0.1 + (_hover ? 0.1 : 0),
                  ),
                  spreadRadius: _hover ? 2 : 1,
                  blurRadius: _hover ? 6 : 1,
                  offset: const Offset(1, 1),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Preview image of the level
                CustomImage(
                  widget.data["image"],
                  width: double.infinity,
                  height: imageHeight,
                  radius: 15,
                ),
                // Level number badge
                Positioned(
                  top: imageHeight - 20,
                  right: 15,
                  child: _buildLevelNumber(),
                ),
                // Level info (title + lessons count) — скрываем в компактном режиме, кроме текущего
                if (!(widget.compact && !_isCurrent))
                  Positioned(
                    top: imageHeight + 10,
                    left: 0,
                    right: 0,
                    child: _buildInfo(),
                  ),
                // Completed overlay
                if (_isCompleted && !_isLocked) _buildCompletedOverlay(),
                // Current level overlay
                if (_isCurrent && !_isLocked) _buildCurrentOverlay(),
                // Locked overlay
                if (_isLocked) _buildLockedOverlay(),
              ],
            ),
          ),
        );
      },
    );

    if (enableHover) {
      card = MouseRegion(
        cursor: _isLocked ? SystemMouseCursors.basic : SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: AnimatedScale(
          scale: _hover ? 1.03 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: card,
        ),
      );
    }

    return card;
  }

  // ------------------ Widgets ------------------

  Widget _buildCompletedOverlay() {
    return Positioned(
      top: 10,
      left: 10,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColor.surface.withValues(alpha: 0.8),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, color: AppColor.success, size: 20),
      ),
    );
  }

  Widget _buildCurrentOverlay() {
    return Positioned(
      top: 10,
      left: 10,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 1.0, end: 1.2),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        builder: (context, scale, child) {
          return Transform.scale(scale: scale, child: child);
        },
        onEnd: () => setState(() {}),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColor.surface.withValues(alpha: 0.9),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.star, color: AppColor.premium, size: 20),
        ),
      ),
    );
  }

  Widget _buildLockedOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.labelColor.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Icon(Icons.lock, color: AppColor.onPrimary, size: 48),
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Container(
      width: widget.width == double.infinity
          ? double.infinity
          : widget.width - AppSpacing.medium,
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.data["name"],
            softWrap: true,
            style: TextStyle(
              fontSize: (MediaQuery.of(context).size.width < 600) ? 15 : 10,
              color: AppColor.textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          _buildLessonsCount(),
        ],
      ),
    );
  }

  Widget _buildLevelNumber() {
    final levelNum = widget.data["level"] as int? ?? 0;
    final String label;
    if (widget.compact) {
      // Показываем код уровня (101..110) или «Ресепшн» для 0
      final code = formatLevelCode(1, levelNum);
      label = levelNum == 0 ? code : code;
    } else {
      label = levelNum == 0 ? 'Первый шаг' : 'Уровень $levelNum';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withValues(alpha: 0.05),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColor.surface,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildLessonsCount() {
    return Row(
      children: [
        const Icon(
          Icons.play_circle_outlined,
          size: 18,
          color: AppColor.labelColor,
        ),
        const SizedBox(width: 3),
        Text(
          "${widget.data["lessons"]} уроков",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColor.labelColor, fontSize: 13),
        ),
      ],
    );
  }
}
