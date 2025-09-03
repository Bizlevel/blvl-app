part of '../biz_tower_screen.dart';

// Чистые функции и грид башни
class _Placed {
  final Map<String, dynamic> item;
  final int row;
  final int col;
  final double left;
  final double top;
  final double squareTop; // фактический top квадрата (без подписи)
  final double size;
  _Placed({
    required this.item,
    required this.row,
    required this.col,
    required this.left,
    required this.top,
    required this.squareTop,
    required this.size,
  });
}

class _GridSegment {
  final Offset start;
  final Offset end;
  final Color color;
  _GridSegment({required this.start, required this.end, required this.color});
}

List<_Placed> _placeItems({
  required List<Map<String, dynamic>> items,
  required List<int> columns,
  required double columnWidth,
  required double canvasHeight,
  required double rowHeight,
}) {
  final List<_Placed> placed = [];
  for (int i = 0; i < items.length; i++) {
    final item = items[i];
    final bool isCheckpoint = (item.isMiniCase || item.isGoalCheckpoint);
    final double size = isCheckpoint ? kCheckpointSize : kNodeSize;
    int colIndex = columns[i];
    if (i > 0 && colIndex == (placed[i - 1].col)) {
      final int alt1 = (colIndex + 1) % 3;
      final int alt2 = (colIndex + 2) % 3;
      colIndex = alt1 != placed[i - 1].col ? alt1 : alt2;
    }
    final double left =
        kSidePadding + colIndex * columnWidth + (columnWidth - size) / 2;
    final double centerY = canvasHeight - (i + 0.5) * rowHeight;
    final double squareTop = centerY - size / 2;
    final double widgetTop =
        squareTop - kLabelHeight; // подпись над квадратом (до 3 строк)
    placed.add(_Placed(
      item: item,
      row: i,
      col: colIndex,
      left: left,
      top: widgetTop,
      squareTop: squareTop,
      size: size,
    ));
  }
  return placed;
}

List<_GridSegment> _buildSegments(List<_Placed> placed) {
  final List<_GridSegment> segments = [];
  for (int i = 0; i < placed.length - 1; i++) {
    final a = placed[i];
    final b = placed[i + 1];
    final Offset aCenter =
        Offset(a.left + a.size / 2, a.squareTop + a.size / 2);
    final Offset bCenter =
        Offset(b.left + b.size / 2, b.squareTop + b.size / 2);

    final String aType = (a.item['type'] as String? ?? 'level');

    late Offset start;
    if (a.col == b.col) {
      start = Offset(aCenter.dx, a.squareTop + a.size);
    } else if (a.col < b.col) {
      start = Offset(a.left + a.size, aCenter.dy);
    } else {
      start = Offset(a.left, aCenter.dy);
    }
    final Offset end = Offset(bCenter.dx, b.squareTop + b.size);

    Color color = AppColor.info;
    if (aType == 'level') {
      final data = (a.item['data'] as Map).cast<String, dynamic>();
      final bool isCompleted = data['isCompleted'] == true;
      final bool isCurrent = data['isCurrent'] == true;
      final bool isLocked = data['isLocked'] == true;
      if (isCompleted) {
        color = AppColor.success; // завершённый — зелёный
      } else if (isCurrent) {
        color = AppColor.info; // активный — основной цвет
      } else if (isLocked) {
        color = Colors.grey.withValues(alpha: 0.6); // заблокирован — серый ≈60%
      } else {
        color = AppColor.info;
      }
    } else if (aType == 'mini_case' || aType == 'goal_checkpoint') {
      final bool done = a.item['isCompleted'] as bool? ?? false;
      color = done ? AppColor.success : AppColor.info;
    }
    segments.add(_GridSegment(
      start: start,
      end: end,
      color: color.withValues(alpha: kPathAlpha),
    ));
  }
  return segments;
}

class _TowerGrid extends StatelessWidget {
  final List<Map<String, dynamic>> nodes;
  final Widget Function(
    Map<String, dynamic> item,
    int row,
    int col,
    double left,
    double top,
    double size,
  ) nodeBuilder;

  const _TowerGrid({required this.nodes, required this.nodeBuilder});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items =
        nodes.where((n) => n.nodeType != 'divider').toList(growable: false);

    return LayoutBuilder(builder: (context, constraints) {
      final double totalWidth = constraints.maxWidth;
      final double columnWidth =
          ((totalWidth - kSidePadding * 2) / 3).clamp(84.0, 500.0);
      final bool isNarrow = totalWidth < 420;
      final double rowHeight = isNarrow ? (kRowHeight + 8.0) : kRowHeight;
      final List<int> columns = _generateColumns(items.length);
      final double canvasHeight = (items.length + 1) * rowHeight;

      final List<_Placed> placed = _placeItems(
        items: items,
        columns: columns,
        columnWidth: columnWidth,
        canvasHeight: canvasHeight,
        rowHeight: rowHeight,
      );

      final List<_GridSegment> segments = _buildSegments(placed);

      return SizedBox(
        height: canvasHeight,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: RepaintBoundary(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _DotGridPainter(
                        spacing: 120,
                        radius: 3,
                        color: Colors.black.withValues(alpha: 0.06)),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: RepaintBoundary(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _GridPathPainter(segments: segments),
                  ),
                ),
              ),
            ),
            for (int i = 0; i < items.length; i++)
              nodeBuilder(items[i], i, placed[i].col, placed[i].left,
                  placed[i].top, placed[i].size),
          ],
        ),
      );
    });
  }

  List<int> _generateColumns(int count) {
    const List<int> pattern = [1, 0, 2, 1, 0, 2, 1, 2, 0, 1];
    return List<int>.generate(count, (i) => pattern[i % pattern.length]);
  }
}
