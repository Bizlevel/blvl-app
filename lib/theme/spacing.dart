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
  // Доп. часто используемые промежуточные значения
  static const double s6 = 6;
  static const double s10 = 10;
  static const double s20 = 20;
  static const double s5 = 5;
  static const double s14 = 14;
  static const double s15 = 15;
  static const double s25 = 25;
  static const double xxs = 2;
  static const double xs3 = 3;

  // Backward-compatibility aliases (medium/small/large)
  static const double small = sm; // 8
  static const double medium = lg; // 16
  static const double large = xl; // 24

  // Шорткаты отступов
  static EdgeInsets insetsAll(double value) => EdgeInsets.all(value);
  static EdgeInsets insetsSymmetric({double h = 0, double v = 0}) =>
      EdgeInsets.symmetric(horizontal: h, vertical: v);

  // Вертикальные/горизонтальные GAP'ы
  static SizedBox gapH(double height) => SizedBox(height: height);
  static SizedBox gapW(double width) => SizedBox(width: width);

  // Специализированные токены
  static const double buttonPaddingHorizontal = 16.0;
  static const double buttonPaddingVertical = 12.0;
  static const double cardPadding = 16.0;
  static const double screenPadding = 16.0;
  static const double sectionSpacing = 24.0;
  static const double itemSpacing = 12.0;
}
