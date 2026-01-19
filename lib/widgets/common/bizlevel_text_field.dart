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
    this.minLines,
    this.maxLines = 1,
    this.textInputAction,
    this.autofillHints,
    this.textCapitalization = TextCapitalization.none,
    this.smartDashesType,
    this.smartQuotesType,
    this.autocorrect,
    this.enableSuggestions,
    this.enableIMEPersonalizedLearning,
    this.onSubmitted,
    this.onTapOutside,
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
  final int? minLines;
  final int maxLines;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final TextCapitalization textCapitalization;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool? autocorrect;
  final bool? enableSuggestions;
  final bool? enableIMEPersonalizedLearning;
  final ValueChanged<String>? onSubmitted;
  final TapRegionCallback? onTapOutside;

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
        minLines: minLines,
        maxLines: maxLines,
        textInputAction: textInputAction,
        autofillHints: autofillHints,
        textCapitalization: textCapitalization,
        smartDashesType: smartDashesType,
        smartQuotesType: smartQuotesType,
        autocorrect: autocorrect,
        enableSuggestions: enableSuggestions,
        enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
        onSubmitted: onSubmitted,
        onTapOutside: onTapOutside,
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
