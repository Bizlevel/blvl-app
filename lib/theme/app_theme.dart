import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/typography.dart';
import 'package:bizlevel/theme/input_decoration_theme.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: AppColor.primary),
      textTheme: AppTypography.textTheme,
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      inputDecorationTheme: AppInputDecoration.theme(),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColor.primary,
        contentTextStyle: TextStyle(color: Colors.white),
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
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      inputDecorationTheme: AppInputDecoration.theme().copyWith(
        fillColor: AppColor.surfaceDark,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColor.borderStrong),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColor.borderStrong),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColor.primary,
        contentTextStyle: TextStyle(color: Colors.white),
        actionTextColor: AppColor.premium,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
