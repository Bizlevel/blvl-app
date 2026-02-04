import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/theme/effects.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/glass_utils.dart';

/// Унифицированная карточка BizLevel с преднастройками (Premium 2.0).
class BizLevelCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final double radius;
  final double elevation;
  final Color? color;
  final LinearGradient? gradient;
  final Color? borderColor;
  final Key? semanticsKey;
  final String? semanticsLabel;
  final bool outlined;
  final bool tonal;

  /// Вариант glass-эффекта. Если задан, имеет приоритет над [outlined] и [tonal].
  final GlassVariant? variant;

  /// Переопределение blur: true — всегда blur, false — никогда, null — авто.
  final bool? useBlur;

  const BizLevelCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.cardPadding),
    this.radius = AppDimensions.radiusL,
    this.elevation = 1,
    this.color,
    this.gradient,
    this.borderColor,
    this.semanticsKey,
    this.semanticsLabel,
    this.outlined = false,
    this.tonal = false,
    this.variant,
    this.useBlur,
  });

  /// Hero-карточка для главных элементов (цель, продолжить обучение).
  /// Низкая непрозрачность, сильная тень, premium border.
  const BizLevelCard.hero({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.cardPadding),
    this.radius = AppDimensions.radiusL,
    this.semanticsKey,
    this.semanticsLabel,
  })  : variant = GlassVariant.hero,
        useBlur = null,
        elevation = 2,
        color = null,
        gradient = null,
        borderColor = null,
        outlined = false,
        tonal = false;

  /// Контентная карточка для списков и обычного контента.
  /// Высокая непрозрачность, средняя тень.
  const BizLevelCard.content({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.cardPadding),
    this.radius = AppDimensions.radiusL,
    this.semanticsKey,
    this.semanticsLabel,
  })  : variant = GlassVariant.content,
        useBlur = false,
        elevation = 1,
        color = null,
        gradient = null,
        borderColor = null,
        outlined = false,
        tonal = false;

  /// Вложенная карточка для элементов внутри других карточек.
  /// Почти непрозрачная, минимальная тень.
  const BizLevelCard.nested({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.sm),
    this.radius = AppDimensions.radiusM,
    this.semanticsKey,
    this.semanticsLabel,
  })  : variant = GlassVariant.nested,
        useBlur = false,
        elevation = 0,
        color = null,
        gradient = null,
        borderColor = null,
        outlined = false,
        tonal = false;

  @override
  Widget build(BuildContext context) {
    final BorderRadius r = BorderRadius.circular(radius);
    final Widget content = Padding(padding: padding, child: child);

    // Определяем эффективный вариант glass
    final GlassVariant effectiveVariant = _resolveVariant();

    // Определяем, нужен ли blur
    final bool shouldBlur = _shouldApplyBlur(effectiveVariant);

    // Получаем декорацию на основе варианта
    final BoxDecoration decoration = _buildDecoration(effectiveVariant, r);

    // Собираем карточку
    Widget card = Material(
      color: Colors.transparent,
      borderRadius: r,
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: decoration,
        child: onTap == null
            ? content
            : InkWell(
                borderRadius: r,
                onTap: onTap,
                child: content,
              ),
      ),
    );

    // Оборачиваем в BackdropFilter, если нужен blur
    if (shouldBlur) {
      card = ClipRRect(
        borderRadius: r,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppEffects.glassBlurSigma,
            sigmaY: AppEffects.glassBlurSigma,
          ),
          child: card,
        ),
      );
    }

    if (semanticsLabel != null) {
      return Semantics(
        key: semanticsKey,
        label: semanticsLabel,
        button: onTap != null,
        child: card,
      );
    }
    return card;
  }

  /// Определяет эффективный вариант glass на основе параметров.
  GlassVariant _resolveVariant() {
    // Если variant задан явно, используем его
    if (variant != null) return variant!;

    // Если заданы кастомные color или gradient, используем standard
    if (color != null || gradient != null) return GlassVariant.standard;

    // Обратная совместимость: outlined и tonal
    if (outlined) return GlassVariant.subtle;
    if (tonal) return GlassVariant.standard;

    return GlassVariant.standard;
  }

  /// Определяет, нужно ли применять blur.
  bool _shouldApplyBlur(GlassVariant effectiveVariant) {
    // Если useBlur задан явно
    if (useBlur == true) return true;
    if (useBlur == false) return false;

    // Blur только для GlassVariant.blur и если платформа поддерживает
    if (effectiveVariant == GlassVariant.blur && GlassUtils.shouldUseBlur) {
      return true;
    }

    return false;
  }

  /// Строит BoxDecoration на основе варианта и параметров.
  BoxDecoration _buildDecoration(GlassVariant effectiveVariant, BorderRadius r) {
    // Если заданы кастомные параметры, используем legacy-логику
    if (gradient != null || color != null || borderColor != null) {
      return _buildLegacyDecoration(r);
    }

    // Используем новую систему вариантов (Premium 2.0)
    switch (effectiveVariant) {
      // Premium 2.0 контекстные варианты
      case GlassVariant.hero:
        return BoxDecoration(
          gradient: AppColor.glassHeroGradient,
          borderRadius: r,
          border: GlassUtils.premiumBorder(),
          boxShadow: AppEffects.shadowHeroCard,
        );

      case GlassVariant.content:
        return BoxDecoration(
          gradient: AppColor.glassContentGradient,
          borderRadius: r,
          border: GlassUtils.subtleBorder(),
          boxShadow: AppEffects.shadowContentCard,
        );

      case GlassVariant.nested:
        return BoxDecoration(
          color: AppColor.glassNested,
          borderRadius: r,
          border: Border.all(color: AppColor.glassBorderBottom),
          boxShadow: AppEffects.shadowSubtle,
        );

      // Legacy варианты (обратная совместимость)
      case GlassVariant.strong:
        return BoxDecoration(
          gradient: AppColor.glassCardGradientStrong,
          borderRadius: r,
          border: GlassUtils.premiumBorder(),
          boxShadow: AppEffects.shadowHeroCard,
        );

      case GlassVariant.subtle:
        return BoxDecoration(
          color: AppColor.glassSurface,
          borderRadius: r,
          border: GlassUtils.subtleBorder(),
          boxShadow: AppEffects.shadowSubtle,
        );

      case GlassVariant.blur:
        return BoxDecoration(
          gradient: GlassUtils.shouldUseBlur
              ? AppColor.glassModalGradient
              : AppColor.glassCardGradientStrong,
          borderRadius: r,
          border: GlassUtils.premiumBorder(),
          boxShadow: AppEffects.shadowModal,
        );

      case GlassVariant.standard:
        return BoxDecoration(
          gradient: tonal ? AppColor.glassTonalGradient : AppColor.glassContentGradient,
          borderRadius: r,
          border: GlassUtils.subtleBorder(),
          boxShadow: AppEffects.shadowContentCard,
        );
    }
  }

  /// Legacy-логика для обратной совместимости.
  BoxDecoration _buildLegacyDecoration(BorderRadius r) {
    final LinearGradient? resolvedGradient = gradient ??
        (color == null
            ? (tonal ? AppColor.glassTonalGradient : AppColor.glassContentGradient)
            : null);
    final Color fill =
        color ?? (tonal ? AppColor.glassSurfaceTonal : AppColor.glassSurface);

    final Color resolvedBorderColor =
        borderColor ?? (outlined ? AppColor.borderSubtle : AppColor.glassBorder);

    return BoxDecoration(
      gradient: resolvedGradient,
      color: resolvedGradient == null ? fill : null,
      borderRadius: r,
      border: Border.all(color: resolvedBorderColor),
      boxShadow: _resolveShadows(elevated: elevation > 1),
    );
  }

  /// Выбирает тени на основе elevation.
  List<BoxShadow> _resolveShadows({required bool elevated}) {
    if (elevation <= 0) return const <BoxShadow>[];
    if (elevated) return AppEffects.shadowHeroCard;
    return AppEffects.shadowContentCard;
  }
}
