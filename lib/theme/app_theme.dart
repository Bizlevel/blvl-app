import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/typography.dart';
import 'package:bizlevel/theme/input_decoration_theme.dart';
import 'package:bizlevel/theme/dimensions.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: AppColor.primary),
      textTheme: AppTypography.textTheme,
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: AppTypography
            .textTheme.headlineSmall, // 20, w600 по токенам типографики
      ),
      inputDecorationTheme: AppInputDecoration.theme(),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColor.primary,
        contentTextStyle: TextStyle(color: AppColor.onPrimary),
        actionTextColor: AppColor.premium,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static ThemeData dark() {
    final base = ThemeData.dark();
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColor.primary,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: AppTypography.textTheme.headlineSmall,
      ),
      inputDecorationTheme: AppInputDecoration.theme().copyWith(
        fillColor: AppColor.surfaceDark,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(color: AppColor.borderStrong),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(color: AppColor.borderStrong),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColor.primary,
        contentTextStyle: TextStyle(color: AppColor.onPrimary),
        actionTextColor: AppColor.premium,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
