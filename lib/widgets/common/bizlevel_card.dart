import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';

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

  const BizLevelCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.radius = 12,
    this.elevation = 2,
    this.color,
    this.borderColor,
    this.semanticsKey,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(padding: padding, child: child);

    final card = Card(
      color: color ?? AppColor.surface,
      elevation: elevation,
      shadowColor: AppColor.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(color: borderColor ?? Colors.transparent),
      ),
      child: onTap == null
          ? content
          : InkWell(
              borderRadius: BorderRadius.circular(radius),
              onTap: onTap,
              child: content,
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
