import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/theme/typography.dart';

class CustomTextBox extends StatelessWidget {
  const CustomTextBox({
    super.key,
    this.hint = "",
    this.prefix,
    this.suffix,
    this.controller,
    this.readOnly = false,
    this.obscureText = false,
    this.keyboardType,
    this.readOnlySoftBackground = false,
    this.maxLines = 1,
  });

  final String hint;
  final Widget? prefix;
  final Widget? suffix;
  final bool readOnly;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool readOnlySoftBackground;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(bottom: AppSpacing.xs3),
      constraints:
          const BoxConstraints(minHeight: AppDimensions.minButtonHeight),
      decoration: BoxDecoration(
        color: (readOnly && readOnlySoftBackground)
            ? AppColor.appBarColor
            : AppColor.textBoxColor,
        border: Border.all(
            color: (readOnly && readOnlySoftBackground)
                ? AppColor.appBarColor
                : AppColor.textBoxColor),
        borderRadius: BorderRadius.circular(AppDimensions.radius10),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withValues(alpha: 0.05),
            spreadRadius: .5,
            blurRadius: .5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        readOnly: readOnly,
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          prefixIcon: prefix,
          suffixIcon: suffix,
          border: InputBorder.none,
          hintText: hint,
          hintStyle: AppTypography.textTheme.bodyMedium
              ?.copyWith(color: AppColor.labelColor),
          isDense: false,
          contentPadding:
              AppSpacing.insetsSymmetric(h: AppSpacing.md, v: AppSpacing.s10),
        ),
      ),
    );
  }
}
