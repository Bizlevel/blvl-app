import 'package:flutter/material.dart';

class AppColor {
  static const primary = Color(0xFF2563EB);
  // --- BizLevel brand palette (21.1) ---
  static const success = Color(0xFF10B981);
  static const premium = Color(0xFF7C3AED);
  static const error = Color(0xFFDC2626);
  static const info = Color(0xFF3B82F6);
  static const warning = Color(0xFFF59E0B);
  // Доп. акцентные цвета
  static const teal = Color(0xFF14B8A6);
  static const cyan = Color(0xFF06B6D4);

  static const darker = Color(0xFF475569);
  // Семантические роли поверхности/текста/границ
  static const surface = Color(0xFFFFFFFF);
  static const appBgColor = Color(0xFFFAFBFC);
  static const appBarColor = Color(0xFFF1F5F9);
  static const cardColor = surface;
  static const bottomBarColor = surface;
  static const inActiveColor = Color(0xFF9CA3AF);
  static const shadowColor = Color(0x08000000);
  static const shadowSoft = Color(0x05000000); // Новый, более мягкий токен
  static const textBoxColor = surface;
  static const textColor = Color(0xFF0F172A);
  static const glassTextColor = Color(0xFFFFFFFF);
  // Повышенный контраст вторичного текста
  static const labelColor = Color(0xFF64748B);
  static const glassLabelColor = Color(0xFFFFFFFF);
  static const borderColor = Color(0xFFCBD5E1);
  static const dividerColor = Color(0xFFE2E8F0);
  // Белый с альфой
  static const whiteA0 = Color(0x00FFFFFF);
  static const whiteA40 = Color(0x66FFFFFF);

  // Дополнительные токены (унификация и использования в виджетах)
  static const textTertiary = Color(0xFF64748B);
  static const warmAccent = Color(0xFFF59E0B);
  static const backgroundSuccess = Color(0xFFE6F6ED);
  static const backgroundInfo = Color(0xFFE8F0FE);
  static const backgroundWarning = Color(0xFFFFF4E5);
  static const backgroundError = Color(0xFFFFEBEE);
  static const borderSubtle = Color(0xFFE5E7EB);
  static const borderStrong = Color(0xFFE2E8F0);

  // ==========================================================================
  // Liquid glass surfaces (light-mode)
  // ==========================================================================
  /// Базовая "стеклянная" поверхность карточки (полупрозрачная).
  static const Color glassSurface = Color(0xD9FFFFFF); // ~85%

  /// Более плотная поверхность для модалов/верхних панелей.
  static const Color glassSurfaceStrong = Color(0xEFFFFFFF); // ~94%

  /// Тональная поверхность (слегка "синяя" под фирменный градиент).
  static const Color glassSurfaceTonal = Color(0xD9F8FAFF);

  /// Светлый хайлайт (для бордера/блика).
  static const Color glassHighlight = Color(0x80FFFFFF); // 50%

  /// Бордер для glass‑поверхностей (нейтральный, без жёсткого серого).
  static const Color glassBorder = Color(0x33FFFFFF); // 20%

  /// Затемнение фона под модал/оверлей (мягче, чем чистый чёрный).
  static const Color glassScrim = Color(0x660F172A); // ~40% slate-900

  /// Градиент стеклянной карточки (псевдо‑glass без blur).
  static const LinearGradient glassCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xF2FFFFFF), // верхний блик
      Color(0xD9FFFFFF), // основная поверхность
    ],
  );

  /// Тональный градиент (для info/тональных карточек).
  static const LinearGradient glassTonalGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xE6F0F6FF),
      Color(0xD9FFFFFF),
    ],
  );

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
  static const bgGradientDark = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
  );
  // Светлый градиент для бейджей/фонов
  static const badgeBgLight =
      LinearGradient(colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)]);

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
  static const warmGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFFB923C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
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

  // Палитра навыков (централизовано)
  static const Color orangeSoft = Color(0xFFFB923C);
  static const Color indigo = Color(0xFF6366F1);
  static const Map<int, Color> skillColors = {
    1: premium,
    2: warning,
    3: orangeSoft,
    4: info,
    5: success,
    6: indigo, // AI‑предприниматель
  };
}

// Глобальные константы отступов
// AppSpacing перенесён в lib/theme/spacing.dart (единый источник)
