part of '../biz_tower_screen.dart';

// Геометрические константы башни (задаются централизованно)
const double kNodeSize = 88.0;
const double kCheckpointSize = 88.0;
const double kRowHeight =
    128.0; // базовая высота строки (с запасом под 2 строки заголовка)
const double kLabelHeight = 34.0; // высота лейбла над квадратом
const double kSidePadding = 24.0; // боковые отступы внутри сетки
const double kCornerRadius = 20.0; // радиус скругления углов линий
const double kPathStroke = 8.0; // толщина путей
const double kPathAlpha = 0.6; // прозрачность путей

// Общие константы стилей для плиток
const double kTileRadius = 12.0;
const BorderSide kTileBorderSide = BorderSide(color: Colors.black26, width: 4);
const List<BoxShadow> kTileShadows = [
  BoxShadow(color: Color(0x11000000), blurRadius: 8, offset: Offset(0, 4)),
  BoxShadow(
      color: Color(0x24000000),
      blurRadius: 14,
      spreadRadius: 1,
      offset: Offset(0, 6)),
];
const TextStyle kNodeLabelStyle =
    TextStyle(fontSize: 13, fontWeight: FontWeight.w700);
