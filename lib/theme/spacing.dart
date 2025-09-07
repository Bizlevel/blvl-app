import 'package:flutter/widgets.dart';

/// Токены отступов BizLevel и утилиты для удобной разметки
class AppSpacing {
  AppSpacing._();

  // Базовые токены (px)
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double x2l = 32; // 2xl (без дефиса для стиля имен)
  static const double x3l = 48; // 3xl

  // Шорткаты отступов
  static EdgeInsets insetsAll(double value) => EdgeInsets.all(value);
  static EdgeInsets insetsSymmetric({double h = 0, double v = 0}) =>
      EdgeInsets.symmetric(horizontal: h, vertical: v);

  // Вертикальные/горизонтальные GAP'ы
  static SizedBox gapH(double height) => SizedBox(height: height);
  static SizedBox gapW(double width) => SizedBox(width: width);
}
