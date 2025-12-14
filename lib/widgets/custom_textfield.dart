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
    this.autocorrect,
    this.enableSuggestions,
    this.enableIMEPersonalizedLearning,
    this.textInputAction,
    this.autofillHints,
    this.textCapitalization = TextCapitalization.none,
    this.smartDashesType,
    this.smartQuotesType,
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
  final bool? autocorrect;
  final bool? enableSuggestions;
  final bool? enableIMEPersonalizedLearning;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final TextCapitalization textCapitalization;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;

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
        // Для большинства полей оставляем системные значения по умолчанию,
        // а на чувствительных экранах (login/password) можем явно отключать подсказки/автокоррекцию.
        autocorrect: autocorrect ?? true,
        enableSuggestions: enableSuggestions ?? true,
        enableIMEPersonalizedLearning: enableIMEPersonalizedLearning ?? true,
        textInputAction: textInputAction,
        autofillHints: autofillHints,
        textCapitalization: textCapitalization,
        smartDashesType: smartDashesType,
        smartQuotesType: smartQuotesType,
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
