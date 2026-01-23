import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/theme/typography.dart';

enum TextFieldPreset { auth, form, chat }

class CustomTextBox extends StatelessWidget {
  const CustomTextBox({
    super.key,
    this.hint = "",
    this.prefix,
    this.suffix,
    this.controller,
    this.focusNode,
    this.autofocus = false,
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
    this.textCapitalization,
    this.smartDashesType,
    this.smartQuotesType,
    this.minLines,
    this.onSubmitted,
    this.onTapOutside,
    this.onTap,
    this.preset,
  });

  final String hint;
  final Widget? prefix;
  final Widget? suffix;
  final bool readOnly;
  final bool obscureText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextInputType? keyboardType;
  final bool readOnlySoftBackground;
  final int maxLines;
  final bool? autocorrect;
  final bool? enableSuggestions;
  final bool? enableIMEPersonalizedLearning;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final TextCapitalization? textCapitalization;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final int? minLines;
  final ValueChanged<String>? onSubmitted;
  final TapRegionCallback? onTapOutside;
  final VoidCallback? onTap;
  final TextFieldPreset? preset;

  @override
  Widget build(BuildContext context) {
    final bool isAuthPreset = preset == TextFieldPreset.auth;
    final bool isFormPreset = preset == TextFieldPreset.form;
    final bool isChatPreset = preset == TextFieldPreset.chat;
    final bool effectiveAutocorrect = autocorrect ?? !isAuthPreset;
    final bool effectiveSuggestions = enableSuggestions ?? !isAuthPreset;
    final bool effectiveImeLearning =
        enableIMEPersonalizedLearning ?? !isAuthPreset;
    final TextCapitalization effectiveCapitalization = textCapitalization ??
        ((isFormPreset || isChatPreset)
            ? TextCapitalization.sentences
            : TextCapitalization.none);
    final SmartDashesType? effectiveDashes =
        smartDashesType ?? (isAuthPreset ? SmartDashesType.disabled : null);
    final SmartQuotesType? effectiveQuotes =
        smartQuotesType ?? (isAuthPreset ? SmartQuotesType.disabled : null);
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
        // Важно: readOnly TextField по умолчанию всё ещё может получать фокус.
        // В нашем приложении это приводило к редким device-specific кейсам,
        // когда при переключении readOnly→editable (или при попытке сфокусировать поле)
        // срабатывал неожиданный pop на маршруте уровня (/levels → /tower).
        // Для readOnly-полей фокус запрещаем — они предназначены для просмотра,
        // а интерактив (например, выбор даты) делается через отдельные кнопки.
        canRequestFocus: !readOnly,
        controller: controller,
        focusNode: focusNode,
        autofocus: autofocus && !readOnly,
        obscureText: obscureText,
        keyboardType: keyboardType,
        minLines: minLines,
        maxLines: maxLines,
        // Для большинства полей оставляем системные значения по умолчанию,
        // а на чувствительных экранах (login/password) можем явно отключать подсказки/автокоррекцию.
        autocorrect: effectiveAutocorrect,
        enableSuggestions: effectiveSuggestions,
        enableIMEPersonalizedLearning: effectiveImeLearning,
        textInputAction: textInputAction,
        autofillHints: autofillHints,
        textCapitalization: effectiveCapitalization,
        smartDashesType: effectiveDashes,
        smartQuotesType: effectiveQuotes,
        onSubmitted: onSubmitted,
        onTapOutside: onTapOutside,
        onTap: onTap,
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
