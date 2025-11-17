import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/theme/typography.dart';

import 'custom_image.dart';

class FeatureItem extends StatelessWidget {
  const FeatureItem({
    super.key,
    required this.data,
    this.width = 280,
    this.height = 290,
    this.onTap,
  });

  final Map<String, dynamic> data;
  final double width;
  final double height;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: AppSpacing.insetsAll(AppSpacing.s10),
        margin: AppSpacing.insetsSymmetric(v: AppSpacing.s5),
        decoration: BoxDecoration(
          color: AppColor.card,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXxl),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowColor.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(1, 1), // changes position of shadow
            ),
          ],
        ),
        child: Stack(
          children: [
            CustomImage(
              data["image"],
              width: double.infinity,
              height: 190,
              radius: 15, // оставляем кастомный радиус изображения
            ),
            Positioned(top: 170, right: AppSpacing.s15, child: _buildPrice()),
            Positioned(top: 210, child: _buildInfo()),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Container(
      width: width - AppSpacing.s20,
      padding: AppSpacing.insetsSymmetric(h: AppSpacing.s5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data["name"],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.textTheme.titleMedium
                ?.copyWith(color: AppColor.textColor),
          ),
          const SizedBox(height: AppSpacing.s10),
          _buildAttributes(),
        ],
      ),
    );
  }

  Widget _buildPrice() {
    return Container(
      padding: AppSpacing.insetsAll(AppSpacing.s10),
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXxl),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withValues(alpha: 0.05),
            spreadRadius: 1,
            blurRadius: 1,
          ),
        ],
      ),
      child: Text(
        data["price"],
        style: AppTypography.textTheme.labelLarge
            ?.copyWith(color: AppColor.onPrimary, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildAttributes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _getAttribute(
          Icons.play_circle_outlined,
          AppColor.labelColor,
          data["session"],
        ),
        const SizedBox(width: AppSpacing.md),
        _getAttribute(
          Icons.schedule_rounded,
          AppColor.labelColor,
          data["duration"],
        ),
        const SizedBox(width: AppSpacing.md),
        _getAttribute(Icons.star, AppColor.yellow, data["review"]),
      ],
    );
  }

  Widget _getAttribute(IconData icon, Color color, String info) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: AppSpacing.xs3),
        Text(
          info,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.textTheme.labelMedium
              ?.copyWith(color: AppColor.labelColor),
        ),
      ],
    );
  }
}
