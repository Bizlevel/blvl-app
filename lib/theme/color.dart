import 'package:flutter/material.dart';

class AppColor {
  static const primary = Color(0xFF1995F0);
  // --- BizLevel brand palette (21.1) ---
  static const success = Color(0xFF10B981);
  static const premium = Color(0xFFF59E0B);
  static const error = Color(0xFFDC2626);
  static const info = Color(0xFF3B82F6);
  static const warning = Color(0xFFF59E0B);

  static const darker = Color(0xFF475569);
  static const cardColor = Colors.white;
  static const appBgColor = Color(0xFFFAFBFC);
  static const appBarColor = Color(0xFFF1F5F9);
  static const bottomBarColor = Colors.white;
  static const inActiveColor = Colors.grey;
  static const shadowColor = Colors.black12;
  static const textBoxColor = Colors.white;
  static const textColor = Color(0xFF0F172A);
  static const glassTextColor = Colors.white;
  static const labelColor = Color(0xFF94A3B8);
  static const glassLabelColor = Colors.white;
  static const borderColor = Color(0xFFCBD5E1);
  static const dividerColor = Color(0xFFE2E8F0);

  // Градиент фона приложения (базовый)
  static const bgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF0F4FF), Color(0xFFDDE8FF)],
  );

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
      colors: [Color(0xFF1995F0), Color(0xFF62B4FF)],
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
class AppSpacing {
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
}
