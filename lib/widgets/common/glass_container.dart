import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/theme/effects.dart';
import 'package:bizlevel/theme/glass_utils.dart';

/// Универсальный контейнер с glass-эффектом (Premium 2.0).
///
/// В отличие от [BizLevelCard], этот виджет:
/// - Не является карточкой Material (нет InkWell/ripple)
/// - Поддерживает больше вариантов компоновки
/// - Более гибкий для кастомных layouts
class GlassContainer extends StatelessWidget {
  /// Содержимое контейнера.
  final Widget child;

  /// Вариант glass-эффекта.
  final GlassVariant variant;

  /// Радиус скругления углов.
  final double radius;

  /// Padding внутри контейнера.
  final EdgeInsetsGeometry? padding;

  /// Margin вокруг контейнера.
  final EdgeInsetsGeometry? margin;

  /// Переопределение blur: true — всегда blur, false — никогда, null — авто.
  final bool? useBlur;

  /// Кастомная декорация (переопределяет [variant]).
  final BoxDecoration? decoration;

  /// Ограничения размера.
  final BoxConstraints? constraints;

  /// Выравнивание содержимого.
  final AlignmentGeometry? alignment;

  /// Показывать ли highlight-бордер.
  final bool showHighlightBorder;

  /// Clip behavior.
  final Clip clipBehavior;

  const GlassContainer({
    super.key,
    required this.child,
    this.variant = GlassVariant.standard,
    this.radius = AppDimensions.radiusL,
    this.padding,
    this.margin,
    this.useBlur,
    this.decoration,
    this.constraints,
    this.alignment,
    this.showHighlightBorder = true,
    this.clipBehavior = Clip.antiAlias,
  });

  /// Создаёт glass-контейнер для модалов.
  const GlassContainer.modal({
    super.key,
    required this.child,
    this.radius = AppDimensions.radiusXl,
    this.padding,
    this.margin,
    this.decoration,
    this.constraints,
    this.alignment,
    this.clipBehavior = Clip.antiAlias,
  })  : variant = GlassVariant.blur,
        useBlur = null, // авто
        showHighlightBorder = true;

  /// Создаёт glass-контейнер для панелей (bottom bar, app bar).
  const GlassContainer.panel({
    super.key,
    required this.child,
    this.radius = AppDimensions.radiusL,
    this.padding,
    this.margin,
    this.decoration,
    this.constraints,
    this.alignment,
    this.clipBehavior = Clip.antiAlias,
  })  : variant = GlassVariant.content,
        useBlur = false,
        showHighlightBorder = true;

  /// Создаёт subtle glass-контейнер для вложенных элементов.
  const GlassContainer.subtle({
    super.key,
    required this.child,
    this.radius = AppDimensions.radiusMd,
    this.padding,
    this.margin,
    this.decoration,
    this.constraints,
    this.alignment,
    this.clipBehavior = Clip.antiAlias,
  })  : variant = GlassVariant.nested,
        useBlur = false,
        showHighlightBorder = false;

  /// Создаёт hero glass-контейнер для главных элементов.
  const GlassContainer.hero({
    super.key,
    required this.child,
    this.radius = AppDimensions.radiusL,
    this.padding,
    this.margin,
    this.decoration,
    this.constraints,
    this.alignment,
    this.clipBehavior = Clip.antiAlias,
  })  : variant = GlassVariant.hero,
        useBlur = null,
        showHighlightBorder = true;

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(radius);

    // Определяем, нужен ли blur
    final bool shouldBlur = _shouldApplyBlur();

    // Получаем декорацию
    final BoxDecoration resolvedDecoration =
        decoration ?? _buildDecoration(borderRadius);

    // Основной контейнер
    Widget container = Container(
      margin: margin,
      padding: padding,
      constraints: constraints,
      alignment: alignment,
      decoration: resolvedDecoration,
      clipBehavior: clipBehavior,
      child: child,
    );

    // Оборачиваем в BackdropFilter, если нужен blur
    if (shouldBlur) {
      container = ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: _getBlurFilter(),
          child: container,
        ),
      );
    }

    return container;
  }

  /// Определяет, нужно ли применять blur.
  bool _shouldApplyBlur() {
    if (useBlur == true) return true;
    if (useBlur == false) return false;

    // Blur для модалов на поддерживающих платформах
    if (variant == GlassVariant.blur && GlassUtils.shouldUseBlur) {
      return true;
    }

    return false;
  }

  /// Возвращает ImageFilter для blur.
  ImageFilter _getBlurFilter() {
    switch (variant) {
      case GlassVariant.blur:
        return GlassUtils.blurFilterStrong;
      case GlassVariant.strong:
      case GlassVariant.hero:
        return GlassUtils.blurFilter;
      default:
        return GlassUtils.blurFilterLight;
    }
  }

  /// Строит BoxDecoration на основе варианта (Premium 2.0).
  BoxDecoration _buildDecoration(BorderRadius borderRadius) {
    switch (variant) {
      // Premium 2.0 контекстные варианты
      case GlassVariant.hero:
        return BoxDecoration(
          gradient: AppColor.glassHeroGradient,
          borderRadius: borderRadius,
          border: showHighlightBorder ? GlassUtils.premiumBorder() : null,
          boxShadow: AppEffects.shadowHeroCard,
        );

      case GlassVariant.content:
        return BoxDecoration(
          gradient: AppColor.glassContentGradient,
          borderRadius: borderRadius,
          border: showHighlightBorder ? GlassUtils.subtleBorder() : null,
          boxShadow: AppEffects.shadowContentCard,
        );

      case GlassVariant.nested:
        return BoxDecoration(
          color: AppColor.glassNested,
          borderRadius: borderRadius,
          border: Border.all(color: AppColor.glassBorderBottom),
          boxShadow: AppEffects.shadowSubtle,
        );

      // Legacy варианты
      case GlassVariant.strong:
        return BoxDecoration(
          gradient: AppColor.glassCardGradientStrong,
          borderRadius: borderRadius,
          border: showHighlightBorder ? GlassUtils.premiumBorder() : null,
          boxShadow: AppEffects.shadowHeroCard,
        );

      case GlassVariant.subtle:
        return BoxDecoration(
          color: AppColor.glassSurface,
          borderRadius: borderRadius,
          border: GlassUtils.subtleBorder(),
          boxShadow: AppEffects.shadowSubtle,
        );

      case GlassVariant.blur:
        final bool shouldBlur = _shouldApplyBlur();
        return BoxDecoration(
          gradient: shouldBlur
              ? AppColor.glassModalGradient
              : AppColor.glassContentGradient,
          borderRadius: borderRadius,
          border: showHighlightBorder ? GlassUtils.premiumBorder() : null,
          boxShadow: AppEffects.shadowModal,
        );

      case GlassVariant.standard:
        return BoxDecoration(
          gradient: AppColor.glassContentGradient,
          borderRadius: borderRadius,
          border: showHighlightBorder ? GlassUtils.subtleBorder() : null,
          boxShadow: AppEffects.shadowContentCard,
        );
    }
  }
}
