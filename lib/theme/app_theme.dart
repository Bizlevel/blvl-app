// ignore_for_file: code-duplication
import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/typography.dart';
import 'package:bizlevel/theme/input_decoration_theme.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/chat_theme.dart';
import 'package:bizlevel/theme/quiz_theme.dart';
import 'package:bizlevel/theme/gp_theme.dart';
import 'package:bizlevel/theme/game_progress_theme.dart';
import 'package:bizlevel/theme/video_theme.dart';
import 'package:bizlevel/theme/material_elevation.dart';

class AppTheme {
  static ThemeData fromColorScheme(ColorScheme colorScheme) {
    final bool isDark = colorScheme.brightness == Brightness.dark;
    return _buildTheme(colorScheme, isDark);
  }

  static ThemeData _buildTheme(ColorScheme colorScheme, bool isDark) {
    var theme = _baseTheme(isDark, colorScheme);
    theme = _applyComponents(theme, colorScheme);
    return theme;
  }

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(seedColor: AppColor.primary);
    return fromColorScheme(colorScheme);
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColor.primary,
      brightness: Brightness.dark,
    );
    return fromColorScheme(colorScheme);
  }

  // Экспериментальная OLED‑тема
  static ThemeData darkOled() {
    final cs = ColorScheme.fromSeed(
      seedColor: AppColor.primary,
      brightness: Brightness.dark,
    );
    final oled = cs.copyWith(
      surface: const Color(0xFF000000),
      surfaceContainerHighest: const Color(0xFF0A0A0A),
      onSurface: AppColor.textDark,
    );
    return fromColorScheme(oled);
  }

  // Small layered helpers to reduce method size/duplication
  static ThemeData _baseTheme(bool isDark, ColorScheme cs) {
    final ThemeData base = isDark ? ThemeData.dark() : ThemeData.light();
    return base.copyWith(
      colorScheme: cs,
      textTheme: AppTypography.textTheme,
      scaffoldBackgroundColor: Colors.transparent,
      extensions: <ThemeExtension<dynamic>>[
        isDark ? ChatTheme.dark(cs) : ChatTheme.light(cs),
        isDark ? QuizTheme.dark(cs) : QuizTheme.light(cs),
        isDark ? GpTheme.dark(cs) : GpTheme.light(cs),
        isDark ? GameProgressTheme.dark(cs) : GameProgressTheme.light(cs),
        isDark ? VideoTheme.dark(cs) : VideoTheme.light(cs),
      ],
      appBarTheme: _appBarTheme(),
      inputDecorationTheme:
          isDark ? _inputDecorationDark() : AppInputDecoration.theme(),
    );
  }

  static ThemeData _applyComponents(ThemeData t, ColorScheme cs) {
    return t.copyWith(
      elevatedButtonTheme: _elevatedButtonTheme(),
      filledButtonTheme: _filledButtonTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(cs),
      iconButtonTheme: _iconButtonTheme(),
      chipTheme: _chipTheme(cs),
      navigationBarTheme: _navigationBarTheme(cs),
      tabBarTheme: _tabBarTheme(cs),
      cardTheme: _cardTheme(cs),
      listTileTheme: _listTileTheme(),
      dialogTheme: _dialogTheme(cs),
      bottomSheetTheme: _bottomSheetTheme(cs),
      progressIndicatorTheme: _progressTheme(cs),
      tooltipTheme: _tooltipTheme(cs),
      snackBarTheme: _snackBarTheme(cs),
    );
  }

  static AppBarTheme _appBarTheme() => AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: AppTypography.textTheme.headlineSmall,
      );

  static InputDecorationTheme _inputDecorationDark() =>
      AppInputDecoration.theme().copyWith(
        fillColor: AppColor.surfaceDark,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(color: AppColor.borderStrong),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(color: AppColor.borderStrong),
        ),
      );

  static ElevatedButtonThemeData _elevatedButtonTheme() =>
      ElevatedButtonThemeData(style: _baseButtonStyle());

  static FilledButtonThemeData _filledButtonTheme() => FilledButtonThemeData(
        style: _baseButtonStyle(),
      );

  static OutlinedButtonThemeData _outlinedButtonTheme(ColorScheme cs) =>
      OutlinedButtonThemeData(
        style: _baseButtonStyle().copyWith(
          side: WidgetStateProperty.all(BorderSide(color: cs.outline)),
        ),
      );

  static IconButtonThemeData _iconButtonTheme() => IconButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.all(
            const Size(
                AppDimensions.minTouchTarget, AppDimensions.minTouchTarget),
          ),
          padding: WidgetStateProperty.all(const EdgeInsets.all(AppSpacing.sm)),
        ),
      );

  static ButtonStyle _baseButtonStyle() => ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonPaddingHorizontal,
            vertical: AppSpacing.buttonPaddingVertical,
          ),
        ),
        minimumSize: WidgetStateProperty.all(
            const Size.fromHeight(AppDimensions.minButtonHeight)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
        ),
      );
  static ChipThemeData _chipTheme(ColorScheme cs) => ChipThemeData(
        backgroundColor: cs.surface,
        selectedColor: cs.secondaryContainer,
        disabledColor: cs.surfaceContainerHighest,
        labelStyle: TextStyle(color: cs.onSurface),
        selectedShadowColor: Colors.transparent,
        showCheckmark: false,
        side: BorderSide(color: cs.outlineVariant),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
      );

  static NavigationBarThemeData _navigationBarTheme(ColorScheme cs) =>
      NavigationBarThemeData(
        backgroundColor: cs.surface,
        indicatorColor: cs.secondaryContainer,
        labelTextStyle: WidgetStateProperty.all(
          TextStyle(fontWeight: FontWeight.w600, color: cs.onSurface),
        ),
      );

  static TabBarThemeData _tabBarTheme(ColorScheme cs) => TabBarThemeData(
        labelColor: cs.primary,
        unselectedLabelColor: cs.onSurface.withValues(alpha: 0.6),
        indicatorColor: cs.primary,
        dividerColor: cs.surfaceContainerHighest,
        labelStyle: AppTypography.textTheme.titleSmall,
        unselectedLabelStyle: AppTypography.textTheme.titleSmall,
      );

  static CardThemeData _cardTheme(ColorScheme cs) => CardThemeData(
        color: MaterialElevation.surfaceAt(cs, 1),
        elevation: AppDimensions.elevationHairline,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        margin: const EdgeInsets.all(AppSpacing.cardPadding),
      );

  static ListTileThemeData _listTileTheme() => ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
      );

  static DialogThemeData _dialogTheme(ColorScheme cs) => DialogThemeData(
        backgroundColor: MaterialElevation.surfaceAt(cs, 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        ),
      );

  static BottomSheetThemeData _bottomSheetTheme(ColorScheme cs) =>
      BottomSheetThemeData(
        backgroundColor: MaterialElevation.surfaceAt(cs, 1),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusXl),
          ),
        ),
      );

  static ProgressIndicatorThemeData _progressTheme(ColorScheme cs) =>
      ProgressIndicatorThemeData(
        color: cs.primary,
        linearTrackColor: cs.surfaceContainerHighest,
      );

  static TooltipThemeData _tooltipTheme(ColorScheme cs) => TooltipThemeData(
        decoration: BoxDecoration(
          color: cs.inverseSurface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        textStyle: TextStyle(color: cs.onInverseSurface),
      );

  static SnackBarThemeData _snackBarTheme(ColorScheme cs) => SnackBarThemeData(
        backgroundColor: cs.primary,
        contentTextStyle: const TextStyle(color: AppColor.onPrimary),
        actionTextColor: AppColor.premium,
        behavior: SnackBarBehavior.floating,
      );
}
