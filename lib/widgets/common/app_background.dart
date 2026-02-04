import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';

/// Фоновый градиент приложения с декоративными элементами.
///
/// По умолчанию использует насыщенный градиент [AppColor.bgGradientRich]
/// для лучшего контраста с glass-элементами.
///
/// Premium 2.0: добавлены декоративные "блобы" для создания глубины.
class AppBackground extends StatelessWidget {
  final Widget child;

  /// Кастомный градиент (переопределяет [useRichGradient]).
  final Gradient? gradient;

  /// Использовать насыщенный градиент для лучшего glass-эффекта.
  /// По умолчанию `true`.
  final bool useRichGradient;

  /// Показывать декоративные блобы для создания глубины.
  /// По умолчанию `true`.
  final bool showDecorations;

  /// Общая прозрачность декоративных элементов (0.0 - 1.0).
  final double decorationOpacity;

  const AppBackground({
    required this.child,
    this.gradient,
    this.useRichGradient = true,
    this.showDecorations = true,
    this.decorationOpacity = 1.0,
    super.key,
  });

  /// Конструктор с классическим (менее насыщенным) градиентом.
  const AppBackground.classic({
    required this.child,
    this.gradient,
    this.showDecorations = false,
    this.decorationOpacity = 1.0,
    super.key,
  }) : useRichGradient = false;

  /// Конструктор без декораций (для производительности).
  const AppBackground.minimal({
    required this.child,
    this.gradient,
    this.useRichGradient = true,
    super.key,
  })  : showDecorations = false,
        decorationOpacity = 0.0;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // Определяем градиент
    final Gradient resolvedGradient;
    if (gradient != null) {
      resolvedGradient = gradient!;
    } else if (useRichGradient) {
      resolvedGradient =
          isDark ? AppColor.bgGradientRichDark : AppColor.bgGradientRich;
    } else {
      resolvedGradient = isDark ? AppColor.bgGradientDark : AppColor.bgGradient;
    }

    return Container(
      decoration: BoxDecoration(gradient: resolvedGradient),
      child: showDecorations && decorationOpacity > 0
          ? Stack(
              children: [
                // Декоративные блобы (статичные, обёрнуты в RepaintBoundary)
                RepaintBoundary(
                  child: _DecorativeBlobs(
                    opacity: decorationOpacity,
                    isDark: isDark,
                  ),
                ),
                // Контент поверх
                child,
              ],
            )
          : child,
    );
  }
}

/// Декоративные размытые круги для создания глубины фона.
class _DecorativeBlobs extends StatelessWidget {
  final double opacity;
  final bool isDark;

  const _DecorativeBlobs({
    required this.opacity,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return IgnorePointer(
      child: Opacity(
        opacity: opacity,
        child: Stack(
          children: [
            // Блоб 1: Top-right (primary)
            Positioned(
              top: -80,
              right: -60,
              child: _Blob(
                size: size.width * 0.7,
                color: isDark
                    ? AppColor.primary.withValues(alpha: 0.08)
                    : AppColor.decorativeBlob1,
                blurRadius: 120,
              ),
            ),
            // Блоб 2: Bottom-left (warm accent)
            Positioned(
              bottom: size.height * 0.15,
              left: -100,
              child: _Blob(
                size: size.width * 0.6,
                color: isDark
                    ? AppColor.warmAccent.withValues(alpha: 0.05)
                    : AppColor.decorativeBlob2,
                blurRadius: 100,
              ),
            ),
            // Блоб 3: Center-right (teal)
            Positioned(
              top: size.height * 0.4,
              right: -80,
              child: _Blob(
                size: size.width * 0.5,
                color: isDark
                    ? AppColor.teal.withValues(alpha: 0.06)
                    : AppColor.decorativeBlob3,
                blurRadius: 80,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Отдельный декоративный блоб (размытый круг).
class _Blob extends StatelessWidget {
  final double size;
  final Color color;
  final double blurRadius;

  const _Blob({
    required this.size,
    required this.color,
    required this.blurRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: blurRadius,
            spreadRadius: size * 0.3,
          ),
        ],
      ),
    );
  }
}
