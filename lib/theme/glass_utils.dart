import 'dart:io' show Platform;
import 'dart:ui';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/effects.dart';
import 'package:bizlevel/theme/dimensions.dart';

/// Варианты стилизации glass-эффекта (Premium 2.0).
enum GlassVariant {
  /// Стандартный glass (умеренная непрозрачность, стандартный бордер).
  standard,

  /// Усиленный glass (выраженный контраст, highlight-бордер).
  strong,

  /// Subtle glass (минимальный эффект, для вложенных элементов).
  subtle,

  /// Blur glass (для модалов и оверлеев, если платформа поддерживает).
  blur,

  /// Hero glass (для главных карточек — низкая opacity, сильная тень).
  hero,

  /// Content glass (для списков и контента — высокая opacity).
  content,

  /// Nested glass (для вложенных элементов — почти непрозрачный).
  nested,
}

/// Утилиты для platform-aware glass-эффекта.
class GlassUtils {
  GlassUtils._();

  // ==========================================================================
  // Platform detection
  // ==========================================================================

  /// Blur рекомендован на iOS/macOS (оптимизирован на уровне системы).
  static bool get isBlurRecommended {
    if (kIsWeb) return false;
    try {
      return Platform.isIOS || Platform.isMacOS;
    } catch (_) {
      return false;
    }
  }

  /// Пользовательский override (можно управлять через настройки).
  static bool useBlurOverride = false;

  /// Итоговое решение: использовать blur или нет.
  static bool get shouldUseBlur => isBlurRecommended || useBlurOverride;

  // ==========================================================================
  // Glass decorations
  // ==========================================================================

  /// Возвращает BoxDecoration для glass-карточки.
  static BoxDecoration cardDecoration({
    GlassVariant variant = GlassVariant.standard,
    double radius = AppDimensions.radiusL,
    bool withHighlightBorder = true,
  }) {
    switch (variant) {
      // Premium 2.0 variants
      case GlassVariant.hero:
        return heroDecoration(radius: radius);

      case GlassVariant.content:
        return contentDecoration(radius: radius);

      case GlassVariant.nested:
        return nestedDecoration(radius: radius);

      // Legacy variants (обратная совместимость)
      case GlassVariant.strong:
        return BoxDecoration(
          gradient: AppColor.glassCardGradientStrong,
          borderRadius: BorderRadius.circular(radius),
          border: withHighlightBorder
              ? premiumBorder()
              : Border.all(color: AppColor.glassBorderStrong),
          boxShadow: AppEffects.shadowHeroCard,
        );

      case GlassVariant.subtle:
        return BoxDecoration(
          color: AppColor.glassSurface,
          borderRadius: BorderRadius.circular(radius),
          border: subtleBorder(),
          boxShadow: AppEffects.shadowSubtle,
        );

      case GlassVariant.blur:
        // Для blur используется более прозрачная поверхность.
        // BackdropFilter добавляется отдельно в виджете.
        return BoxDecoration(
          gradient: AppColor.glassModalGradient,
          borderRadius: BorderRadius.circular(radius),
          border: withHighlightBorder
              ? premiumBorder()
              : Border.all(color: AppColor.glassHighlightStrong),
          boxShadow: AppEffects.shadowModal,
        );

      case GlassVariant.standard:
        return BoxDecoration(
          gradient: AppColor.glassContentGradient,
          borderRadius: BorderRadius.circular(radius),
          border: withHighlightBorder
              ? subtleBorder()
              : Border.all(color: AppColor.glassBorder),
          boxShadow: AppEffects.shadowContentCard,
        );
    }
  }

  /// Возвращает BoxDecoration для модалов/оверлеев.
  static BoxDecoration modalDecoration({
    double radius = AppDimensions.radiusXl,
  }) {
    if (shouldUseBlur) {
      return BoxDecoration(
        gradient: AppColor.glassModalGradient,
        borderRadius: BorderRadius.circular(radius),
        border: premiumBorder(),
        boxShadow: AppEffects.shadowModal,
      );
    }
    return BoxDecoration(
      color: AppColor.glassContent,
      borderRadius: BorderRadius.circular(radius),
      border: premiumBorder(),
      boxShadow: AppEffects.shadowModal,
    );
  }

  /// Возвращает BoxDecoration для панелей навигации.
  static BoxDecoration panelDecoration({
    double radius = AppDimensions.radiusL,
    bool topOnly = true,
  }) {
    final BorderRadius borderRadius = topOnly
        ? BorderRadius.vertical(top: Radius.circular(radius))
        : BorderRadius.circular(radius);

    return BoxDecoration(
      color: AppColor.glassNav,
      borderRadius: borderRadius,
      border: const Border(
        top: BorderSide(color: AppColor.glassBorderTop),
        left: BorderSide(color: AppColor.glassBorderLeft),
        right: BorderSide(color: AppColor.glassBorderRight),
      ),
      boxShadow: const [
        BoxShadow(
          color: Color(0x1A000000), // ~10%
          blurRadius: 16,
          offset: Offset(0, -6),
        ),
        BoxShadow(
          color: Color(0x0D000000), // ~5%
          blurRadius: 4,
          offset: Offset(0, -2),
        ),
      ],
    );
  }

  // ==========================================================================
  // ImageFilter для blur
  // ==========================================================================

  /// ImageFilter для стандартного blur.
  static ImageFilter get blurFilter =>
      ImageFilter.blur(sigmaX: AppEffects.glassBlurSigma, sigmaY: AppEffects.glassBlurSigma);

  /// ImageFilter для лёгкого blur.
  static ImageFilter get blurFilterLight => ImageFilter.blur(
      sigmaX: AppEffects.glassBlurSigmaLight, sigmaY: AppEffects.glassBlurSigmaLight);

  /// ImageFilter для сильного blur (модалы).
  static ImageFilter get blurFilterStrong => ImageFilter.blur(
      sigmaX: AppEffects.glassBlurSigmaStrong, sigmaY: AppEffects.glassBlurSigmaStrong);

  // ==========================================================================
  // Premium 2.0: Gradient Border System
  // ==========================================================================

  /// Премиальный gradient border (свет сверху-слева).
  static Border premiumBorder() {
    return const Border(
      top: BorderSide(color: AppColor.glassBorderTop),
      left: BorderSide(color: AppColor.glassBorderLeft),
      right: BorderSide(color: AppColor.glassBorderRight),
      bottom: BorderSide(color: AppColor.glassBorderBottom),
    );
  }

  /// Subtle gradient border (минимальный highlight).
  static Border subtleBorder() {
    return Border(
      top: BorderSide(color: AppColor.glassBorderTop.withValues(alpha: 0.3)),
      left: BorderSide(color: AppColor.glassBorderLeft.withValues(alpha: 0.2)),
      right: const BorderSide(color: AppColor.glassBorderRight),
      bottom: const BorderSide(color: AppColor.glassBorderBottom),
    );
  }

  /// Акцентный border с цветным glow.
  static Border accentBorder({Color? accentColor}) {
    final color = accentColor ?? AppColor.primary;
    return Border(
      top: BorderSide(color: color.withValues(alpha: 0.3)),
      left: BorderSide(color: color.withValues(alpha: 0.2)),
      right: BorderSide(color: color.withValues(alpha: 0.1)),
      bottom: BorderSide(color: color.withValues(alpha: 0.1)),
    );
  }

  // ==========================================================================
  // Premium 2.0: Contextual Decorations
  // ==========================================================================

  /// Decoration для hero-карточек (главная цель, продолжить).
  static BoxDecoration heroDecoration({
    double radius = AppDimensions.radiusL,
  }) {
    return BoxDecoration(
      gradient: AppColor.glassHeroGradient,
      borderRadius: BorderRadius.circular(radius),
      border: premiumBorder(),
      boxShadow: AppEffects.shadowHeroCard,
    );
  }

  /// Decoration для контентных карточек (списки, навыки).
  static BoxDecoration contentDecoration({
    double radius = AppDimensions.radiusL,
  }) {
    return BoxDecoration(
      gradient: AppColor.glassContentGradient,
      borderRadius: BorderRadius.circular(radius),
      border: subtleBorder(),
      boxShadow: AppEffects.shadowContentCard,
    );
  }

  /// Decoration для вложенных элементов.
  static BoxDecoration nestedDecoration({
    double radius = AppDimensions.radiusM,
  }) {
    return BoxDecoration(
      color: AppColor.glassNested,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: AppColor.glassBorderBottom),
      boxShadow: AppEffects.shadowSubtle,
    );
  }

  // ==========================================================================
  // Helpers
  // ==========================================================================

  /// Оборачивает виджет в BackdropFilter, если blur рекомендован.
  static Widget wrapWithBlur({
    required Widget child,
    required BorderRadius borderRadius,
    bool forceBlur = false,
  }) {
    if (!shouldUseBlur && !forceBlur) {
      return child;
    }
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: blurFilter,
        child: child,
      ),
    );
  }
}
