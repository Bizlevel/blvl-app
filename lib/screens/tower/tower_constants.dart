part of '../biz_tower_screen.dart';

// Геометрические константы башни (задаются централизованно)
const double kNodeSize = 90.0; // увеличено в 1.5 раза для удобства тапа
const double kCheckpointSize = 90.0; // синхронно с размером узлов
const double kRowHeight = 180.0; // масштабировано пропорционально размеру узлов
const double kLabelHeight = 48.0; // высота лейбла над квадратом (до 3 строк)
const double kSidePadding = 24.0; // боковые отступы внутри сетки
const double kCornerRadius = 20.0; // радиус скругления углов линий
const double kPathStroke = 8.0; // толщина путей
const double kPathAlpha = 0.6; // прозрачность путей
const double kDotAlpha = 0.06; // прозрачность точек фона

// Общие константы стилей для плиток
const double kTileRadius = 12.0;
const BorderSide kTileBorderSide = BorderSide(
  color: AppColor.borderColor,
  width: 4,
);
const List<BoxShadow> kTileShadows = [
  BoxShadow(color: AppColor.shadowColor, blurRadius: 8, offset: Offset(0, 4)),
  BoxShadow(
    color: AppColor.shadowColor,
    blurRadius: 14,
    spreadRadius: 1,
    offset: Offset(0, 6),
  ),
];
const TextStyle kNodeLabelStyle = TextStyle(
  // Используем scale из AppTypography: близко к labelMedium (12) с жирностью,
  // но оставляем 13 как специфику карты, чтобы не ломать верстку.
  fontSize: 13,
  fontWeight: FontWeight.w700,
  height: 1.2,
);
