import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:go_router/go_router.dart';

import 'custom_image.dart';

class LevelCard extends StatefulWidget {
  const LevelCard({
    super.key,
    required this.data,
    this.width = double.infinity,
    this.height = 290,
    this.onTap,
  });

  final Map<String, dynamic> data;
  final double width;
  final double height;
  final GestureTapCallback? onTap;

  @override
  State<LevelCard> createState() => _LevelCardState();
}

class _LevelCardState extends State<LevelCard> {
  bool _hover = false;

  bool get _isLocked => widget.data["isLocked"] == true;

  @override
  Widget build(BuildContext context) {
    final enableHover = kIsWeb;

    Widget card = GestureDetector(
      onTap: _isLocked
          ? null
          : () {
              HapticFeedback.lightImpact();
              widget.onTap?.call();
            },
      child: Container(
        width: widget.width,
        height: widget.height,
        padding: const EdgeInsets.all(AppSpacing.medium),
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.small),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowColor.withOpacity(0.1 + (_hover ? 0.1 : 0)),
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
              height: 190,
              radius: 15,
            ),
            // Level number badge
            Positioned(
              top: 170,
              right: 15,
              child: _buildLevelNumber(),
            ),
            // Level info (title + lessons count)
            Positioned(
              top: 210,
              left: 0,
              right: 0,
              child: _buildInfo(),
            ),
            // Locked overlay
            if (_isLocked) _buildLockedOverlay(),
          ],
        ),
      ),
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

  Widget _buildLockedOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Icon(
            Icons.lock,
            color: Colors.white,
            size: 48,
          ),
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 17,
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
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColor.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Text(
        widget.data["level"].toString(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
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
