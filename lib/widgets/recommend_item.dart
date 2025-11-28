import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/theme/typography.dart';
import 'package:bizlevel/widgets/custom_image.dart';

class RecommendItem extends StatelessWidget {
  const RecommendItem({
    super.key,
    required this.data,
    this.onTap,
  });

  final Map<String, dynamic> data;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: AppSpacing.insetsSymmetric(h: AppSpacing.s10),
        padding: AppSpacing.insetsAll(AppSpacing.s10),
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXxl),
          color: AppColor.surface,
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowColor.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(1, 1), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            CustomImage(
              data["image"],
              radius: 15,
              height: 80,
            ),
            const SizedBox(width: AppSpacing.s10),
            _buildInfo()
          ],
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data["name"],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.textTheme.titleMedium
              ?.copyWith(color: AppColor.textColor),
        ),
        const SizedBox(height: AppSpacing.s5),
        Text(
          data["price"],
          style: AppTypography.textTheme.bodyMedium
              ?.copyWith(color: AppColor.textColor),
        ),
        const SizedBox(height: AppSpacing.s15),
        _buildDurationAndRate()
      ],
    );
  }

  Widget _buildDurationAndRate() {
    return Row(
      children: [
        const Icon(
          Icons.schedule_rounded,
          color: AppColor.labelColor,
          size: 14,
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          data["duration"],
          style: AppTypography.textTheme.labelMedium
              ?.copyWith(color: AppColor.labelColor),
        ),
        const SizedBox(width: AppSpacing.s20),
        const Icon(
          Icons.star,
          color: AppColor.orange,
          size: 14,
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          data["review"],
          style: AppTypography.textTheme.labelMedium
              ?.copyWith(color: AppColor.labelColor),
        )
      ],
    );
  }
}
