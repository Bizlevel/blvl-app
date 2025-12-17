import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/theme/effects.dart';
import 'package:bizlevel/theme/spacing.dart';

/// Унифицированная карточка BizLevel с преднастройками
class BizLevelCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final double radius;
  final double elevation;
  final Color? color;
  final Color? borderColor;
  final Key? semanticsKey;
  final String? semanticsLabel;
  final bool outlined; // v2
  final bool tonal; // v2

  const BizLevelCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.cardPadding),
    this.radius = AppDimensions.radiusLg,
    this.elevation = 2,
    this.color,
    this.borderColor,
    this.semanticsKey,
    this.semanticsLabel,
    this.outlined = false,
    this.tonal = false,
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius r = BorderRadius.circular(radius);
    final Widget content = Padding(padding: padding, child: child);

    // Liquid glass: псевдо‑glass (градиент + highlight‑border + мягкая тень).
    // Blur (BackdropFilter) намеренно НЕ используется по умолчанию — снижает риски
    // производительности на web/low-end; при необходимости включим точечно позже.
    final LinearGradient? gradient = color == null
        ? (tonal ? AppColor.glassTonalGradient : AppColor.glassCardGradient)
        : null;
    final Color fill =
        color ?? (tonal ? AppColor.glassSurfaceTonal : AppColor.glassSurface);

    final Color resolvedBorderColor = borderColor ??
        (outlined ? AppColor.borderSubtle : AppColor.glassBorder);

    // elevation — не Material elevation, а "интенсивность" тени.
    final List<BoxShadow> shadows = elevation <= 0
        ? const <BoxShadow>[]
        : (elevation <= 1
            ? AppEffects.glassCardShadowSm
            : AppEffects.glassCardShadow);

    final Decoration decoration = BoxDecoration(
      gradient: gradient,
      color: gradient == null ? fill : null,
      borderRadius: r,
      border: Border.all(color: resolvedBorderColor),
      boxShadow: shadows,
    );

    final Widget card = Material(
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
}
