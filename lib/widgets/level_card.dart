import 'package:flutter/material.dart';
import 'package:online_course/theme/color.dart';

import 'custom_image.dart';

class LevelCard extends StatelessWidget {
  LevelCard({
    Key? key,
    required this.data,
    this.width = 280,
    this.height = 290,
    this.onTap,
  }) : super(key: key);

  final Map<String, dynamic> data;
  final double width;
  final double height;
  final GestureTapCallback? onTap;

  bool get _isLocked => data["isLocked"] == true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isLocked ? null : onTap,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowColor.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Preview image of the level
            CustomImage(
              data["image"],
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
              child: _buildInfo(),
            ),
            // Locked overlay
            if (_isLocked) _buildLockedOverlay(),
          ],
        ),
      ),
    );
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
      width: width - 20,
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data["name"],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
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
        data["level"].toString(),
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
          "${data["lessons"]} уроков",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColor.labelColor, fontSize: 13),
        ),
      ],
    );
  }
}
