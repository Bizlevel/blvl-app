import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/typography.dart';
import 'package:bizlevel/widgets/custom_textfield.dart';

class BizLevelTextField extends StatelessWidget {
  const BizLevelTextField({
    super.key,
    this.label,
    this.hint,
    this.prefix,
    this.suffix,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.readOnly = false,
    this.obscureText = false,
    this.keyboardType,
    this.isInvalid = false,
    this.errorText,
    this.readOnlySoftBackground = true,
  });

  final String? label;
  final String? hint;
  final Widget? prefix;
  final Widget? suffix;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool readOnly;
  final bool obscureText;
  final TextInputType? keyboardType;
  final bool isInvalid;
  final String? errorText;
  final bool readOnlySoftBackground;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];
    if (label != null && label!.trim().isNotEmpty) {
      children.add(Text(
        label!,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ) ??
            const TextStyle(fontWeight: FontWeight.w600),
      ));
      children.add(AppSpacing.gapH(AppSpacing.s6));
    }

    children.add(
      CustomTextBox(
        hint: hint ?? '',
        prefix: prefix,
        suffix: suffix,
        controller: controller,
        focusNode: focusNode,
        autofocus: autofocus,
        readOnly: readOnly,
        obscureText: obscureText,
        keyboardType: keyboardType,
        readOnlySoftBackground: readOnly && readOnlySoftBackground,
      ),
    );

    if (isInvalid || (errorText != null && errorText!.trim().isNotEmpty)) {
      children.add(AppSpacing.gapH(AppSpacing.s6));
      children.add(
        Text(
          errorText ?? 'Проверьте корректность значения',
          style: AppTypography.textTheme.labelMedium
              ?.copyWith(color: AppColor.error, fontWeight: FontWeight.w500),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}
