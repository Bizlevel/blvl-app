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




