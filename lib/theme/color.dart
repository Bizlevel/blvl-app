import 'package:flutter/material.dart';

class AppColor {
  static const primary = Color(0xFF2563EB);
  // --- BizLevel brand palette (21.1) ---
  static const success = Color(0xFF10B981);
  static const premium = Color(0xFF7C3AED);
  static const error = Color(0xFFDC2626);
  static const info = Color(0xFF3B82F6);
  static const warning = Color(0xFFF59E0B);

  static const darker = Color(0xFF475569);
  // Семантические роли поверхности/текста/границ
  static const surface = Color(0xFFFFFFFF);
  static const appBgColor = Color(0xFFFAFBFC);
  static const appBarColor = Color(0xFFF1F5F9);
  static const cardColor = surface;
  static const bottomBarColor = surface;
  static const inActiveColor = Color(0xFF9CA3AF);
  static const shadowColor = Color(0x08000000);
  static const textBoxColor = surface;
  static const textColor = Color(0xFF0F172A);
  static const glassTextColor = Color(0xFFFFFFFF);
  static const labelColor = Color(0xFF94A3B8);
  static const glassLabelColor = Color(0xFFFFFFFF);
  static const borderColor = Color(0xFFCBD5E1);
  static const dividerColor = Color(0xFFE2E8F0);

  // Доп. семантические алиасы для удобства
  static const onSurface = textColor;
  static const onSurfaceSubtle = labelColor;
  static const onPrimary = Color(0xFFFFFFFF);
  static const appBackground = appBgColor;
  static const card = cardColor;
  static const border = borderColor;
  static const divider = dividerColor;
  static const shadow = shadowColor;

  // Градиент фона приложения (базовый)
  static const bgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF0F4FF), Color(0xFFDDE8FF)],
  );

  // Бизнес‑токены градиентов
  static const businessGradient = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
  );
  static const growthGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
  );
  static const achievementGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
  );

  // Подготовка к dark‑mode
  static const surfaceDark = Color(0xFF1E293B);
  static const textDark = Color(0xFFF1F5F9);

  // ---- Backward-compatibility aliases (to мигрировать позднее) ----
  static const red = error;
  static const orange = warning;
  static const yellow = premium;
  static const blue = info;
  static const actionColor = primary;

  // Градиенты карточек уровней (свободные, продвинутые, премиум)
  static const levelCardBg = Color(0x809FC5E8); // 50% opacity

  static const levelGradients = <LinearGradient>[
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF2563EB), Color(0xFF62B4FF)],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF4338CA), Color(0xFF2563EB)],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF3B82F6), Color(0xFF06B6D4)],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
    ),
  ];
  static const listColors = [
    primary,
    info,
    premium,
    success,
    error,
    warning,
  ];
}

// Глобальные константы отступов
// AppSpacing перенесён в lib/theme/spacing.dart (единый источник)
