import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/theme/typography.dart';
import 'package:bizlevel/widgets/custom_image.dart';

class ArtifactCard extends StatelessWidget {
  const ArtifactCard({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.url,
  });

  final String title;
  final String description;
  final String image;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.s10),
      padding: AppSpacing.insetsAll(AppSpacing.s10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXxl),
        color: AppColor.surface,
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          CustomImage(
            image,
            radius: 15,
            height: 60,
            width: 60,
          ),
          const SizedBox(width: AppSpacing.s10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.textTheme.titleMedium
                      ?.copyWith(color: AppColor.textColor),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.textTheme.bodySmall
                      ?.copyWith(color: AppColor.labelColor),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s10),
        ],
      ),
    );
  }
}
