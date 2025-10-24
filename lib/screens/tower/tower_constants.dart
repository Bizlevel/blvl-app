part of '../biz_tower_screen.dart';

// Геометрические константы башни (задаются централизованно)
const double kNodeSize = 60.0;
const double kCheckpointSize = 60.0;
const double kRowHeight = 120.0; // под ужатые узлы и сохранение геометрии
const double kLabelHeight = 48.0; // высота лейбла над квадратом (до 3 строк)
const double kSidePadding = 24.0; // боковые отступы внутри сетки
const double kCornerRadius = 20.0; // радиус скругления углов линий
const double kPathStroke = 8.0; // толщина путей
const double kPathAlpha = 0.6; // прозрачность путей
const double kDotAlpha = 0.06; // прозрачность точек фона

// Общие константы стилей для плиток
const double kTileRadius = 12.0;
const BorderSide kTileBorderSide =
    BorderSide(color: AppColor.borderColor, width: 4);
const List<BoxShadow> kTileShadows = [
  BoxShadow(color: AppColor.shadowColor, blurRadius: 8, offset: Offset(0, 4)),
  BoxShadow(
      color: AppColor.shadowColor,
      blurRadius: 14,
      spreadRadius: 1,
      offset: Offset(0, 6)),
];
const TextStyle kNodeLabelStyle =
    TextStyle(fontSize: 13, fontWeight: FontWeight.w700, height: 1.2);
