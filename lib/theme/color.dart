import 'package:flutter/material.dart';

class AppColor {
  static const primary = Color(0xFF2563EB);
  static const primaryLight = Color(0xFFDBEAFE);
  // --- BizLevel brand palette (21.1) ---
  static const success = Color(0xFF10B981);
  static const successStrong = Color(0xFF059669);
  static const premium = Color(0xFF7C3AED);
  static const error = Color(0xFFDC2626);
  static const info = Color(0xFF3B82F6);
  static const warning = Color(0xFFF59E0B);
  static const warningLight = Color(0xFFFEF3C7);
  // Доп. акцентные цвета
  static const teal = Color(0xFF14B8A6);
  static const cyan = Color(0xFF06B6D4);

  static const darker = Color(0xFF475569);
  // Семантические роли поверхности/текста/границ
  static const surface = Color(0xFFFFFFFF);
  static const background = Color(0xFFF8FAFC);
  static const backgroundSecondary = Color(0xFFF1F5F9);
  static const appBgColor = Color(0xFFFAFBFC);
  static const appBarColor = Color(0xFFF1F5F9);
  static const cardColor = surface;
  static const bottomBarColor = surface;
  static const inActiveColor = Color(0xFF9CA3AF);
  static const shadowColor = Color(0x08000000);
  static const shadowSoft = Color(0x05000000); // Новый, более мягкий токен
  static const textBoxColor = surface;
  static const textColor = Color(0xFF0F172A);
  static const textPrimary = Color(0xFF111827);
  static const textSecondary = Color(0xFF6B7280);
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
  static const warmAccentLight = Color(0xFFFEF3C7);
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

  // ==========================================================================
  // Premium Glass Effect (усиленный glass для современного UI)
  // ==========================================================================

  /// Поверхность для элементов с blur (низкая непрозрачность для эффекта).
  static const Color glassSurfaceBlur = Color(0x59FFFFFF); // ~35%

  /// Средняя непрозрачность для усиленного псевдо-glass без blur.
  static const Color glassSurfaceMedium = Color(0xA6FFFFFF); // ~65%

  /// Сильный highlight для верхней/левой грани (премиальный блик).
  static const Color glassHighlightStrong = Color(0xA6FFFFFF); // ~65%

  /// Мягкий highlight для свечения.
  static const Color glassHighlightSubtle = Color(0x4DFFFFFF); // ~30%

  /// Усиленный бордер для видимого glass-эффекта.
  static const Color glassBorderStrong = Color(0x73FFFFFF); // ~45%

  /// Цветной бордер с glow-эффектом (primary с alpha).
  static const Color glassBorderGlow = Color(0x402563EB); // primary ~25%

  /// Усиленный градиент карточки (более выраженный контраст).
  static const LinearGradient glassCardGradientStrong = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xBFFFFFFF), // верхний блик ~75%
      Color(0x8CFFFFFF), // основная поверхность ~55%
    ],
  );

  /// Градиент для элементов с blur (более прозрачный).
  static const LinearGradient glassBlurGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x66FFFFFF), // верхний блик ~40%
      Color(0x40FFFFFF), // основная поверхность ~25%
    ],
  );

  /// Тональный усиленный градиент (синеватый оттенок).
  static const LinearGradient glassTonalGradientStrong = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xB3EEF4FF), // верхний блик ~70%
      Color(0x80E8F0FF), // основная поверхность ~50%
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

  // Семантические алиасы под дизайн-документ (не ломают текущие токены)
  static const colorPrimary = primary;
  static const colorPrimaryLight = primaryLight;
  static const colorAccentWarm = warmAccent;
  static const colorAccentWarmLight = warmAccentLight;
  static const colorSuccess = successStrong;
  static const colorSuccessLight = backgroundSuccess;
  static const colorError = error;
  static const colorErrorLight = backgroundError;
  static const colorWarning = warning;
  static const colorWarningLight = warningLight;
  static const colorSurface = surface;
  static const colorBackground = background;
  static const colorBackgroundSecondary = backgroundSecondary;
  static const colorTextPrimary = textPrimary;
  static const colorTextSecondary = textSecondary;
  static const colorTextTertiary = inActiveColor;
  static const colorBorder = borderSubtle;

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

  /// Насыщенный градиент фона для лучшего контраста с glass-элементами.
  /// Premium 2.0: более глубокий голубой для видимого glass-эффекта.
  static const bgGradientRich = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFD0E0FF), Color(0xFFA0C8FF)],
  );

  /// Насыщенный тёмный градиент (dark mode).
  static const bgGradientRichDark = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0A1628), Color(0xFF162033)],
  );

  // ==========================================================================
  // Decorative Elements (Premium 2.0)
  // ==========================================================================

  /// Декоративный блоб 1 (primary с alpha) — top-right.
  static const Color decorativeBlob1 = Color(0x262563EB); // primary ~15%

  /// Декоративный блоб 2 (accent с alpha) — bottom-left.
  static const Color decorativeBlob2 = Color(0x1AF59E0B); // warm ~10%

  /// Декоративный блоб 3 (teal с alpha) — center-right.
  static const Color decorativeBlob3 = Color(0x1F14B8A6); // teal ~12%

  // ==========================================================================
  // Contextual Glass Surfaces (Premium 2.0)
  // ==========================================================================

  /// Hero-карточки (главная цель, продолжить) — низкая opacity для эффекта.
  static const Color glassHero = Color(0x73FFFFFF); // ~45%

  /// Контентные карточки (списки, навыки) — выше opacity для читаемости.
  static const Color glassContent = Color(0xBFFFFFFF); // ~75%

  /// Модалы и bottom sheets — низкая opacity + blur.
  static const Color glassModal = Color(0x59FFFFFF); // ~35%

  /// Навигация (bottom bar, app bar) — высокая opacity.
  static const Color glassNav = Color(0xE0FFFFFF); // ~88%

  /// Вложенные элементы — почти непрозрачные.
  static const Color glassNested = Color(0xD9FFFFFF); // ~85%

  // ==========================================================================
  // Gradient Borders (Premium 2.0)
  // ==========================================================================

  /// Верхняя грань highlight (свет сверху).
  static const Color glassBorderTop = Color(0x80FFFFFF); // ~50%

  /// Нижняя грань (минимальная видимость).
  static const Color glassBorderBottom = Color(0x1AFFFFFF); // ~10%

  /// Левая грань highlight (свет слева).
  static const Color glassBorderLeft = Color(0x66FFFFFF); // ~40%

  /// Правая грань (минимальная видимость).
  static const Color glassBorderRight = Color(0x14FFFFFF); // ~8%

  // ==========================================================================
  // Contextual Glass Gradients (Premium 2.0)
  // ==========================================================================

  /// Градиент для hero-карточек (более прозрачный).
  static const LinearGradient glassHeroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x80FFFFFF), // верхний блик ~50%
      Color(0x59FFFFFF), // основа ~35%
    ],
  );

  /// Градиент для контентных карточек (стандартный).
  static const LinearGradient glassContentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xD9FFFFFF), // верхний блик ~85%
      Color(0xBFFFFFFF), // основа ~75%
    ],
  );

  /// Градиент для модалов (прозрачный под blur).
  static const LinearGradient glassModalGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x66FFFFFF), // верхний блик ~40%
      Color(0x4DFFFFFF), // основа ~30%
    ],
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
