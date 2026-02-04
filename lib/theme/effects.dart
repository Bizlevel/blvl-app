import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';

/// Токены эффектов: тени, blur, glow
class AppEffects {
  AppEffects._();

  // ==========================================================================
  // ТЕНИ (BoxShadow)
  // ==========================================================================

  /// Минимальная тень — для hover/focus состояний
  static const BoxShadow shadowXs = BoxShadow(
    color: Color(0x0D000000), // ~5% opacity
    blurRadius: 2,
    offset: Offset(0, 1),
  );

  /// Лёгкая тень — для карточек и кнопок
  static const BoxShadow shadowSm = BoxShadow(
    color: Color(0x14000000), // ~8% opacity
    blurRadius: 4,
    offset: Offset(0, 2),
  );

  /// Средняя тень — для приподнятых элементов
  static const BoxShadow shadowMd = BoxShadow(
    color: Color(0x1A000000), // ~10% opacity
    blurRadius: 8,
    offset: Offset(0, 4),
  );

  /// Большая тень — для модалов и floating элементов
  static const BoxShadow shadowLg = BoxShadow(
    color: Color(0x1F000000), // ~12% opacity
    blurRadius: 12,
    offset: Offset(0, 6),
  );

  /// Очень большая тень — для dialogs и overlays
  static const BoxShadow shadowXl = BoxShadow(
    color: Color(0x26000000), // ~15% opacity
    blurRadius: 20,
    offset: Offset(0, 10),
  );

  // ==========================================================================
  // СПИСКИ ТЕНЕЙ для удобства
  // ==========================================================================

  static const List<BoxShadow> cardShadow = [shadowSm];
  static const List<BoxShadow> buttonShadow = [shadowXs];
  static const List<BoxShadow> modalShadow = [shadowLg];
  static const List<BoxShadow> floatingShadow = [shadowXl];

  // ==========================================================================
  // "Liquid glass" shadows (light-mode)
  // ==========================================================================
  /// Мягкая тень для стеклянных карточек (ощущение глубины без "грязи").
  static const BoxShadow glassShadow = BoxShadow(
    color: Color(0x14000000), // ~8% opacity
    blurRadius: 24,
    offset: Offset(0, 12),
  );

  /// Более лёгкая тень для небольших стеклянных элементов.
  static const BoxShadow glassShadowSm = BoxShadow(
    color: Color(0x0D000000), // ~5% opacity
    blurRadius: 16,
    offset: Offset(0, 8),
  );

  static const List<BoxShadow> glassCardShadow = [glassShadow];
  static const List<BoxShadow> glassCardShadowSm = [glassShadowSm];

  // ==========================================================================
  // Premium Glass shadows (усиленные тени для современного UI)
  // ==========================================================================

  /// Усиленная тень для premium glass-эффекта.
  static const BoxShadow glassShadowStrong = BoxShadow(
    color: Color(0x26000000), // ~15% opacity
    blurRadius: 32,
    offset: Offset(0, 16),
  );

  /// Чёткая компактная тень (первый слой для layered эффекта).
  static const BoxShadow _glassShadowSharp = BoxShadow(
    color: Color(0x1A000000), // ~10% opacity
    blurRadius: 8,
    offset: Offset(0, 4),
  );

  /// Мягкая размытая тень (второй слой для layered эффекта).
  static const BoxShadow _glassShadowSoft = BoxShadow(
    color: Color(0x0D000000), // ~5% opacity
    blurRadius: 24,
    offset: Offset(0, 12),
  );

  /// Двойная тень для премиального "парящего" эффекта.
  static const List<BoxShadow> glassShadowLayered = [
    _glassShadowSharp,
    _glassShadowSoft,
  ];

  /// Тень с цветным glow от primary (для акцентных элементов).
  static List<BoxShadow> glassShadowGlow({double intensity = 0.15}) => [
        BoxShadow(
          color: AppColor.primary.withValues(alpha: intensity),
          blurRadius: 20,
          spreadRadius: 2,
        ),
        const BoxShadow(
          color: Color(0x14000000), // ~8% opacity
          blurRadius: 16,
          offset: Offset(0, 8),
        ),
      ];

  // ==========================================================================
  // Premium Layered Shadows (Premium 2.0)
  // ==========================================================================

  /// Ambient тень — мягкая, большая, создаёт глубину.
  static const BoxShadow _premiumAmbient = BoxShadow(
    color: Color(0x14000000), // ~8% opacity
    blurRadius: 40,
    offset: Offset(0, 20),
  );

  /// Direct тень — чёткая, близкая, создаёт elevation.
  static const BoxShadow _premiumDirect = BoxShadow(
    color: Color(0x1A000000), // ~10% opacity
    blurRadius: 10,
    offset: Offset(0, 4),
  );

  /// Highlight — белый блик сверху (эффект объёма).
  static const BoxShadow _premiumHighlight = BoxShadow(
    color: Color(0x33FFFFFF), // ~20% white
    offset: Offset(0, -1),
  );

  /// Премиальная многослойная тень (3 слоя: ambient + direct + highlight).
  static const List<BoxShadow> premiumShadowLayered = [
    _premiumAmbient,
    _premiumDirect,
    _premiumHighlight,
  ];

  // ==========================================================================
  // Contextual Shadows (Premium 2.0)
  // ==========================================================================

  /// Hero-карточки — сильная тень для "парящего" эффекта.
  static const List<BoxShadow> shadowHeroCard = [
    BoxShadow(
      color: Color(0x1A000000), // ~10% opacity
      blurRadius: 32,
      offset: Offset(0, 16),
    ),
    BoxShadow(
      color: Color(0x14000000), // ~8% opacity
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  /// Контентные карточки — средняя тень.
  static const List<BoxShadow> shadowContentCard = [
    BoxShadow(
      color: Color(0x14000000), // ~8% opacity
      blurRadius: 20,
      offset: Offset(0, 10),
    ),
    BoxShadow(
      color: Color(0x0D000000), // ~5% opacity
      blurRadius: 6,
      offset: Offset(0, 3),
    ),
  ];

  /// Вложенные элементы — слабая тень.
  static const List<BoxShadow> shadowSubtle = [
    BoxShadow(
      color: Color(0x0D000000), // ~5% opacity
      blurRadius: 12,
      offset: Offset(0, 6),
    ),
  ];

  /// Модалы и sheets — глубокая тень.
  static const List<BoxShadow> shadowModal = [
    BoxShadow(
      color: Color(0x1F000000), // ~12% opacity
      blurRadius: 48,
      offset: Offset(0, 24),
    ),
    BoxShadow(
      color: Color(0x14000000), // ~8% opacity
      blurRadius: 12,
      offset: Offset(0, 6),
    ),
  ];

  // ==========================================================================
  // Blur токены (для BackdropFilter)
  // ==========================================================================

  /// Стандартный blur для glass-карточек.
  static const double glassBlurSigma = 12.0;

  /// Лёгкий blur для subtle эффекта.
  static const double glassBlurSigmaLight = 6.0;

  /// Сильный blur для модалов и оверлеев.
  static const double glassBlurSigmaStrong = 20.0;

  // Контекстные blur-токены (Premium 2.0)

  /// Blur для модалов и bottom sheets.
  static const double blurModal = 20.0;

  /// Blur для навигации (app bar, bottom bar).
  static const double blurNav = 8.0;

  /// Blur для hero-карточек (опционально).
  static const double blurHero = 12.0;

  // ==========================================================================
  // Inner highlight (декорации для внутреннего блика)
  // ==========================================================================

  /// Градиент внутреннего блика (верхняя часть карточки).
  static const LinearGradient glassInnerHighlight = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.center,
    colors: [
      Color(0x33FFFFFF), // ~20%
      Color(0x00FFFFFF), // прозрачный
    ],
  );

  /// Градиент блика для левой грани.
  static const LinearGradient glassLeftHighlight = LinearGradient(
    // begin: Alignment.centerLeft is default
    end: Alignment.center,
    colors: [
      Color(0x26FFFFFF), // ~15%
      Color(0x00FFFFFF), // прозрачный
    ],
  );

  // ==========================================================================
  // GLOW эффекты
  // ==========================================================================

  /// Glow для success состояний
  static BoxShadow glowSuccess({double spread = 0, double blur = 8}) => BoxShadow(
        color: AppColor.success.withValues(alpha: 0.3),
        blurRadius: blur,
        spreadRadius: spread,
      );

  /// Glow для primary элементов
  static BoxShadow glowPrimary({double spread = 0, double blur = 8}) => BoxShadow(
        color: AppColor.primary.withValues(alpha: 0.3),
        blurRadius: blur,
        spreadRadius: spread,
      );

  /// Glow для premium/gold элементов
  static BoxShadow glowPremium({double spread = 0, double blur = 8}) => BoxShadow(
        color: AppColor.premium.withValues(alpha: 0.3),
        blurRadius: blur,
        spreadRadius: spread,
      );
}




