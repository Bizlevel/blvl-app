import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/typography.dart';

class CategoryBox extends StatelessWidget {
  const CategoryBox({
    super.key,
    required this.data,
    this.isSelected = false,
    this.onTap,
    this.selectedColor = AppColor.actionColor,
  });

  final Map<String, dynamic> data;
  final Color selectedColor;
  final bool isSelected;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            padding: AppSpacing.insetsAll(AppSpacing.s15),
            decoration: BoxDecoration(
              color: isSelected ? AppColor.error : AppColor.surface,
              boxShadow: [
                BoxShadow(
                  color: AppColor.shadowColor.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(1, 1), // changes position of shadow
                ),
              ],
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              data["icon"],
              colorFilter: ColorFilter.mode(
                isSelected ? selectedColor : AppColor.textColor,
                BlendMode.srcIn,
              ),
              width: 30,
              height: 30,
            ),
          ),
          const SizedBox(height: AppSpacing.s10),
          Text(
            data["name"],
            maxLines: 1,
            overflow: TextOverflow.fade,
            style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: AppColor.textColor, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
