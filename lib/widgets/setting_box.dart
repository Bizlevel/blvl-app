import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/theme/typography.dart';

class SettingBox extends StatelessWidget {
  const SettingBox({
    super.key,
    required this.title,
    required this.icon,
    this.color = AppColor.darker,
  });

  final String title;
  final String icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.insetsAll(AppSpacing.s10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        color: AppColor.surface,
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          SvgPicture.asset(
            icon,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            width: 22,
            height: 22,
          ),
          const SizedBox(height: AppSpacing.s6),
          Text(
            title,
            style: AppTypography.textTheme.bodyMedium
                ?.copyWith(color: color, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
