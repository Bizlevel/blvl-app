import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/providers/levels_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
// import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';

class BizTowerScreen extends ConsumerStatefulWidget {
  final int? scrollTo;
  const BizTowerScreen({super.key, this.scrollTo});

  @override
  ConsumerState<BizTowerScreen> createState() => _BizTowerScreenState();
}

class _BizTowerScreenState extends ConsumerState<BizTowerScreen> {
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _nodeKeys = {};
  final GlobalKey _stackKey = GlobalKey();

  // Центры Y размещённых level-узлов для точного автоскролла
  final Map<int, double> _levelCenterY = {};
  List<Map<String, dynamic>> _lastNodes = const [];
  int? _lastScrolledTo;

  Future<void> _scrollToLevelNumber(int levelNumber) async {
    try {
      // Пытаемся использовать расчётные координаты
      final double? centerY = _levelCenterY[levelNumber];
      if (centerY != null && _scrollController.hasClients) {
        final double viewport = _scrollController.position.viewportDimension;
        final double target =
            (centerY - viewport * 0.3).clamp(0, double.infinity);
        await _scrollController.animateTo(target,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
        return;
      }
      // Фолбэк на ensureVisible (если координаты ещё не рассчитаны)
      final key = _nodeKeys[levelNumber];
      if (key?.currentContext != null) {
        if (!mounted) return;
        await Scrollable.ensureVisible(key!.currentContext!,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            alignment: 0.3);
      }
    } catch (e, st) {
      Sentry.captureException(e, stackTrace: st);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Открытие экрана — breadcrumb (однократно)
    Sentry.addBreadcrumb(Breadcrumb(
        level: SentryLevel.info, category: 'tower', message: 'tower_opened'));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Башня БизЛевел'),
            SizedBox(height: 2),
            Text(
              'Этаж 1: База предпринимательства',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
        backgroundColor: AppColor.appBarColor,
      ),
      backgroundColor: AppColor.appBgColor,
      body: Consumer(builder: (context, ref, _) {
        final nodesAsync = ref.watch(towerNodesProvider);
        return nodesAsync.when(
          data: (nodes) {
            _lastNodes = nodes;
            _scheduleRecompute();
            // Обработка запроса автоскролла через переданный параметр scrollTo
            bool scrolledByQuery = false;
            final int? requested = widget.scrollTo;
            if (requested != null && _lastScrolledTo != requested) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                _scrollToLevelNumber(requested);
              });
              _lastScrolledTo = requested;
              scrolledByQuery = true;
            }
            // Определяем текущий узел уровня для автоскролла
            final levelNodes = nodes
                .where((n) => n['type'] == 'level')
                .toList(growable: false);
            Map<String, dynamic>? current = levelNodes
                .cast<Map<String, dynamic>?>()
                .firstWhere(
                    (n) =>
                        ((n?['data'] as Map?)?['isCurrent'] as bool? ?? false),
                    orElse: () => null);
            current ??= levelNodes.firstWhere(
              (n) =>
                  (((n['data'] as Map?)?['isLocked'] as bool? ?? true) ==
                      false) &&
                  (n['blockedByCheckpoint'] as bool? ?? false) == false,
              orElse: () => levelNodes.first,
            );

            // Автоскролл только при смене целевого узла,
            // чтобы не мешать кликам во время постоянных перерисовок
            // После вычисления current выше он всегда не null (есть минимум один levelNode)
            final int targetLevel = (current['level'] as int? ?? 0);
            if (!scrolledByQuery && _lastScrolledTo != targetLevel) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                _scrollToLevelNumber(targetLevel);
              });
              _lastScrolledTo = targetLevel;
            }

            return LayoutBuilder(builder: (context, c) {
              return Stack(key: _stackKey, children: [
                // Вертикальные стены
                Positioned.fill(
                  left: 24,
                  right: 24,
                  child: Row(
                    children: [
                      Container(width: 2, color: Colors.black26),
                      const Spacer(),
                      Container(width: 2, color: Colors.black26),
                    ],
                  ),
                ),
                // Дороги между узлами: рисуются внутри сетки (_buildTowerGrid) новым painter
                const SizedBox.shrink(),
                SafeArea(
                  child: SingleChildScrollView(
                    primary: false,
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    padding: const EdgeInsets.fromLTRB(32, 16, 32, 24),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 900),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Тизеры этажей 2..4 (должны быть выше уровней этажа 1)
                            const _FloorDivider(),
                            _FloorSection(
                                child: _LockedFloorTile(
                                    title: 'Этаж 4',
                                    onTap: () => ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                            content: Text('Скоро'))))),
                            const _FloorDivider(),
                            _FloorSection(
                                child: _LockedFloorTile(
                                    title: 'Этаж 3',
                                    onTap: () => ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                            content: Text('Скоро'))))),
                            const _FloorDivider(),
                            _FloorSection(
                                child: _LockedFloorTile(
                                    title: 'Этаж 2',
                                    onTap: () => ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                            content: Text('Скоро'))))),
                            const SizedBox(height: 12),
                            // Секция сетки узлов этажа 1: статичная 3-колоночная раскладка
                            _buildTowerGrid(context, ref, nodes),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ]);
            });
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) {
            Sentry.captureException(e, stackTrace: st);
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Не удалось загрузить башню',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Text(e.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.black54)),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        try {
                          // Перезапрос узлов
                          ref.invalidate(towerNodesProvider);
                        } catch (ex, stx) {
                          Sentry.captureException(ex, stackTrace: stx);
                        }
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Повторить'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: Consumer(builder: (context, ref, _) {
        return FloatingActionButton.extended(
          onPressed: () async {
            try {
              final next = await ref.read(nextLevelToContinueProvider.future);
              final int? gver = next['goalCheckpointVersion'] as int?;
              if (gver != null) {
                if (!mounted) return;
                context.push('/goal-checkpoint/$gver');
              } else {
                await _scrollToLevelNumber(next['levelNumber'] as int? ?? 0);
              }
            } catch (e, st) {
              Sentry.captureException(e, stackTrace: st);
            }
          },
          icon: const Icon(Icons.arrow_upward),
          label: const Text('Продолжить'),
        );
      }),
    );
  }

  // Статичная 3‑колоночная сетка узлов башни (этаж 1)
  Widget _buildTowerGrid(
      BuildContext context, WidgetRef ref, List<Map<String, dynamic>> nodes) {
    // Берём только объекты (уровни/чекпоинты/мини-кейсы). Разделители отрисованы выше.
    final items =
        nodes.where((n) => n['type'] != 'divider').toList(growable: false);

    return LayoutBuilder(builder: (context, constraints) {
      final double totalWidth = constraints.maxWidth;
      const double sidePadding = 24;
      final double columnWidth =
          ((totalWidth - sidePadding * 2) / 3).clamp(84.0, 500.0);
      const double nodeSize = 88;
      // Чекпоинты теперь такого же размера, как узлы уровней
      const double checkpointSize = 88;
      const double rowHeight = 120;
      const double levelLabelHeight = 34; // высота текста над квадратом уровня
      final List<int> columns = _generateColumns(items.length);
      final double canvasHeight = (items.length + 1) * rowHeight;

      // Предварительно вычислим позиции и сегменты для painter
      final List<_Placed> placed = [];
      for (int i = 0; i < items.length; i++) {
        final item = items[i];
        final bool isCheckpoint =
            (item['type'] == 'mini_case' || item['type'] == 'goal_checkpoint');
        final double size = isCheckpoint ? checkpointSize : nodeSize;
        final double left =
            sidePadding + columns[i] * columnWidth + (columnWidth - size) / 2;
        final double centerY = canvasHeight - (i + 0.5) * rowHeight;
        final double squareTop = centerY - size / 2;
        final double widgetTop =
            isCheckpoint ? squareTop : squareTop - levelLabelHeight;
        placed.add(_Placed(
            item: item,
            row: i,
            col: columns[i],
            left: left,
            top: widgetTop,
            squareTop: squareTop,
            size: size));
      }

      // Обновим карту центров уровней для автоскролла
      _levelCenterY.clear();

      final List<_GridSegment> segments = [];
      for (int i = 0; i < placed.length - 1; i++) {
        final a = placed[i];
        final b = placed[i + 1];
        final Offset aCenter =
            Offset(a.left + a.size / 2, a.squareTop + a.size / 2);
        final Offset bCenter =
            Offset(b.left + b.size / 2, b.squareTop + b.size / 2);

        // Сохраняем центр Y для level-узлов
        final String aType = (a.item['type'] as String? ?? 'level');
        if (aType == 'level') {
          try {
            final data = (a.item['data'] as Map).cast<String, dynamic>();
            final int levelNumber = data['level'] as int? ?? -1;
            if (levelNumber >= 0) {
              _levelCenterY[levelNumber] = aCenter.dy;
            }
          } catch (_) {}
        }

        // Точка выхода из A: если колонки разные — из стороны по направлению к B, иначе — из верхней стороны центра
        late Offset start;
        if (a.col == b.col) {
          // Всегда выходим из нижнего узла через боковую грань
          if (a.col == 2) {
            start = Offset(a.left, aCenter.dy); // левая грань центра
          } else {
            start = Offset(a.left + a.size, aCenter.dy); // правая грань центра
          }
        } else if (a.col < b.col) {
          start = Offset(a.left + a.size, aCenter.dy); // правая грань центр
        } else {
          start = Offset(a.left, aCenter.dy); // левая грань центр
        }
        // Точка входа в B: снизу по центру
        final Offset end = Offset(bCenter.dx, b.squareTop + b.size);

        // Цвет по статусу стартового узла
        Color color = AppColor.info;
        if (aType == 'level') {
          final data = (a.item['data'] as Map).cast<String, dynamic>();
          final bool isCompleted = data['isCompleted'] == true;
          final bool isCurrent = data['isCurrent'] == true;
          final bool isLocked = data['isLocked'] == true;
          color = isCompleted
              ? AppColor.success
              : (isCurrent
                  ? AppColor.info
                  : (isLocked ? Colors.grey.withOpacity(0.6) : AppColor.info));
        } else if (aType == 'mini_case' || aType == 'goal_checkpoint') {
          final bool done = a.item['isCompleted'] as bool? ?? false;
          color = done ? AppColor.success : AppColor.info;
        }
        segments.add(_GridSegment(start: start, end: end, color: color));
      }

      // Учтём последний узел для карты центров
      if (placed.isNotEmpty) {
        final last = placed.last;
        final String lastType = (last.item['type'] as String? ?? 'level');
        if (lastType == 'level') {
          try {
            final data = (last.item['data'] as Map).cast<String, dynamic>();
            final int levelNumber = data['level'] as int? ?? -1;
            if (levelNumber >= 0) {
              _levelCenterY[levelNumber] = last.squareTop + last.size / 2;
            }
          } catch (_) {}
        }
      }

      return SizedBox(
        height: canvasHeight,
        width: double.infinity,
        child: Stack(
          children: [
            // Слой путей
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _GridPathPainter(segments: segments),
                ),
              ),
            ),
            for (int i = 0; i < items.length; i++)
              _positionedNode(
                context: context,
                ref: ref,
                item: items[i],
                row: i, // нижняя строка = 0
                col: columns[i],
                columnWidth: columnWidth,
                sidePadding: sidePadding,
                canvasHeight: canvasHeight,
                nodeSize: nodeSize,
                checkpointSize: checkpointSize,
                rowHeight: rowHeight,
              ),
          ],
        ),
      );
    });
  }

  // Размещает один объект сетки
  Widget _positionedNode({
    required BuildContext context,
    required WidgetRef ref,
    required Map<String, dynamic> item,
    required int row,
    required int col,
    required double columnWidth,
    required double sidePadding,
    required double canvasHeight,
    required double nodeSize,
    required double checkpointSize,
    required double rowHeight,
  }) {
    final type = item['type'] as String?;
    final bool isCheckpoint = type == 'checkpoint' ||
        type == 'mini_case' ||
        type == 'goal_checkpoint';
    final double size = isCheckpoint ? checkpointSize : nodeSize;
    final double left =
        sidePadding + col * columnWidth + (columnWidth - size) / 2;
    final double top = canvasHeight -
        (row + 1) * rowHeight -
        (nodeSize - size) / 2; // единая высота строки

    if (isCheckpoint) {
      // Квадрат чекпоинта по стилю уровня, но с белым фоном и подписью
      return Positioned(
        left: left,
        top: top - 34, // место для подписи сверху
        width: nodeSize,
        child: _buildStyledCheckpointNode(
            context: context,
            ref: ref,
            node: item,
            size: nodeSize,
            align: _alignmentForLevel(
                ((item['afterLevel'] as int? ?? 0) + 1))),
      );
    }

    // Узел уровня: используем существующую отрисовку
    final data = (item['data'] as Map).cast<String, dynamic>();
    final bool blockedByCheckpoint =
        item['blockedByCheckpoint'] as bool? ?? false;
    final int num = data['level'] as int? ?? 0;
    final Alignment align = _alignmentForLevel(num);

    return Positioned(
      left: left,
      top: top,
      width: nodeSize,
      child: _buildLevelNode(
        context,
        data: data,
        blockedByCheckpoint: blockedByCheckpoint,
        align: align,
      ),
    );
  }

  // Старый компактный checkpoint-рендер больше не используется (заменён стилизованным)

  // Новый стиль чекпоинта: как квадрат уровня, но белый, с подписью
  Widget _buildStyledCheckpointNode({
    required BuildContext context,
    required WidgetRef ref,
    required Map<String, dynamic> node,
    required double size,
    required Alignment align,
  }) {
    final String type = node['type'] as String? ?? 'checkpoint';
    final bool isCompleted = node['isCompleted'] as bool? ?? false;
    final int after = node['afterLevel'] as int? ?? 0;
    final int? caseId = node['caseId'] as int?;
    final int? goalVersion = node['version'] as int?;

    String label;
    if (type == 'mini_case') {
      final caseIndex = after == 3 ? 1 : (after == 6 ? 2 : (after == 9 ? 3 : 0));
      label = caseIndex > 0 ? 'Кейс $caseIndex' : 'Кейс';
    } else if (type == 'goal_checkpoint') {
      label = 'Кристаллизация цели ${goalVersion ?? ''}'.trim();
    } else {
      label = '';
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          try {
            if (type == 'mini_case' && caseId != null) {
              context.push('/case/$caseId');
            } else if (type == 'goal_checkpoint' && goalVersion != null) {
              context.push('/goal-checkpoint/$goalVersion');
            }
          } catch (e, st) {
            Sentry.captureException(e, stackTrace: st);
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                label,
                textAlign: align == Alignment.centerLeft
                    ? TextAlign.left
                    : (align == Alignment.centerRight
                        ? TextAlign.right
                        : TextAlign.center),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x11000000),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  type == 'mini_case'
                      ? Icons.work_outline
                      : (type == 'goal_checkpoint'
                          ? (isCompleted ? Icons.flag : Icons.flag_outlined)
                          : Icons.center_focus_strong),
                  color: type == 'mini_case'
                      ? AppColor.info
                      : (type == 'goal_checkpoint'
                          ? (isCompleted ? AppColor.success : AppColor.info)
                          : Colors.black54),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<int> _generateColumns(int count) {
    const List<int> pattern = [1, 0, 2, 1, 0, 2, 1, 2, 0, 1];
    return List<int>.generate(count, (i) => pattern[i % pattern.length]);
  }

  Widget _buildLevelNode(BuildContext context,
      {required Map<String, dynamic> data,
      bool blockedByCheckpoint = false,
      required Alignment align}) {
    final int levelNumber = data['level'] as int? ?? 0;
    _nodeKeys[levelNumber] = _nodeKeys[levelNumber] ?? GlobalKey();

    final bool isCurrent = data['isCurrent'] == true;
    final bool isLockedBase = data['isLocked'] == true;
    final bool isLocked = isLockedBase || blockedByCheckpoint;
    final String? lockReason = data['lockReason'] as String?;
    final bool premiumLock =
        (lockReason != null && lockReason.toLowerCase().contains('премиум'));
    final bool isCompleted = data['isCompleted'] == true;

    // Текущий уровень тоже рендерим как квадрат с подписью (единый интерактив)

    // Компактный синий квадрат
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: _nodeKeys[levelNumber],
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          try {
            Sentry.addBreadcrumb(Breadcrumb(
              level: SentryLevel.info,
              category: 'ui.tap',
              message:
                  'tower.tap level=$levelNumber locked=$isLocked completed=$isCompleted blockedByCheckpoint=$blockedByCheckpoint',
            ));
            // Разрешаем открывать уже пройденные уровни всегда
            final bool canOpen = isCompleted || !isLocked;
            if (!canOpen) {
              if (blockedByCheckpoint) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Завершите предыдущий этаж')));
              } else if (premiumLock) {
                if (mounted) {
                  context.go('/premium');
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Завершите предыдущий уровень')));
              }
              return;
            }
            // Передаём номер уровня как query-параметр, чтобы экран уровня
            // корректно определял сценарий (например, для уровня 0 — профиль)
            // Используем push, чтобы по возврату оставаться на экране башни.
            // Небольшая задержка, чтобы исключить конкуренцию с пост‑фрейм скроллом
            Future.microtask(() {
              if (!mounted) return;
              context.push('/levels/${data['id']}?num=$levelNumber');
            });
          } catch (e, st) {
            Sentry.captureException(e, stackTrace: st);
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                _truncateToTwoWords(levelNumber == 0
                    ? 'Уровень 0: Первый шаг'
                    : 'Уровень $levelNumber: ${data['name']}'),
                textAlign: align == Alignment.centerLeft
                    ? TextAlign.left
                    : (align == Alignment.centerRight
                        ? TextAlign.right
                        : TextAlign.center),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColor.info,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  const BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                  if (isCurrent)
                    BoxShadow(
                      color: AppColor.premium.withValues(alpha: 0.55),
                      blurRadius: 18,
                      spreadRadius: 1,
                      offset: const Offset(0, 0),
                    ),
                ],
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      isCompleted
                          ? Icons.check
                          : (isLocked && !isCompleted
                              ? Icons.lock
                              : Icons.stop),
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  if (isCurrent)
                    const Positioned(
                      top: 6,
                      right: 6,
                      child: Icon(
                        Icons.star,
                        color: AppColor.premium,
                        size: 20,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _scheduleRecompute() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _recomputeSegments());
  }

  void _recomputeSegments() {
    final stackCtx = _stackKey.currentContext;
    if (stackCtx == null) return;
    final stackBox = stackCtx.findRenderObject() as RenderBox?;
    if (stackBox == null) return;

    final List<int> levelNumbers = _lastNodes
        .where((n) => n['type'] == 'level')
        .map<int>((n) => n['level'] as int)
        .toList()
      ..sort();

    // final Map<int, Map<String, dynamic>> levelData = {
    //   for (final n in _lastNodes.where((e) => e['type'] == 'level'))
    //     (n['level'] as int): (n['data'] as Map).cast<String, dynamic>()
    // };

    final List<_NodePoint> points = [];
    for (final num in levelNumbers) {
      final key = _nodeKeys[num];
      final ctx = key?.currentContext;
      final box = ctx?.findRenderObject() as RenderBox?;
      if (box == null) continue;
      final size = box.size;
      final centerGlobal =
          box.localToGlobal(Offset(size.width / 2, size.height / 2));
      final centerLocal = stackBox.globalToLocal(centerGlobal);
      points.add(_NodePoint(num, centerLocal));
    }
  }
}

Alignment _alignmentForLevel(int level) {
  if (level <= 0) return Alignment.center;
  final int idx = (level - 1) % 3; // 0,1,2 → центр, лево, право
  switch (idx) {
    case 0:
      return Alignment.center;
    case 1:
      return Alignment.centerLeft;
    default:
      return Alignment.centerRight;
  }
}

String _truncateToTwoWords(String input) {
  // Оставляем префикс "Уровень N:" и ограничиваем часть названия двумя словами
  final parts = input.split(':');
  if (parts.length < 2) return input;
  final head = parts.first; // "Уровень N"
  final tail = parts.sublist(1).join(':').trim();
  final words = tail.split(RegExp(r'\s+'));
  final limited = words.take(2).join(' ');
  return '$head: $limited';
}

class _LockedFloorTile extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  const _LockedFloorTile({required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
                color: Color(0x11000000), blurRadius: 8, offset: Offset(0, 4)),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
            const Icon(Icons.lock_outline),
          ],
        ),
      ),
    );
  }
}

class _FloorDivider extends StatelessWidget {
  const _FloorDivider();
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 2,
        color: Colors.black12,
        margin: const EdgeInsets.symmetric(vertical: 6));
  }
}

// _FloorLabel удалён: лейбл этажа вынесен в AppBar (закреплён)

class _FloorSection extends StatelessWidget {
  final Widget child;
  const _FloorSection({required this.child});
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 900),
      child: child,
    );
  }
}

// Старый `_CheckpointTile` больше не используется (заменён компактным узлом в сетке)

// Старый `_MiniCaseTile` больше не используется (заменён компактным узлом в сетке)

class _NodePoint {
  final int levelNumber;
  final Offset point;
  _NodePoint(this.levelNumber, this.point);
}

// class _Segment {
//   final Offset a;
//   final Offset b;
//   final Color color;
//   _Segment(this.a, this.b, this.color);
// }

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

class _GridPathPainter extends CustomPainter {
  final List<_GridSegment> segments;
  _GridPathPainter({required this.segments});

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in segments) {
      final paint = Paint()
        ..color = s.color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..isAntiAlias = true;

      final path = Path();
      final double r = 20;
      final dx = s.end.dx - s.start.dx;
      final dy = s.end.dy - s.start.dy;

      path.moveTo(s.start.dx, s.start.dy);
      if (dx.abs() < 1 || dy.abs() < 1) {
        // Прямая вертикаль или горизонталь
        path.lineTo(s.end.dx, s.end.dy);
      } else {
        // Манхэттен с входом строго снизу по центру верхнего узла:
        // горизонталь → скругление к вертикали под центром B → вертикаль до end
        final alignX = s.end.dx;
        final preCornerX = s.start.dx < alignX ? alignX - r : alignX + r;
        path.lineTo(preCornerX, s.start.dy);
        final control = Offset(alignX, s.start.dy);
        final cornerY = s.start.dy + (s.end.dy > s.start.dy ? r : -r);
        path.quadraticBezierTo(control.dx, control.dy, alignX, cornerY);
        path.lineTo(alignX, s.end.dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPathPainter oldDelegate) {
    return oldDelegate.segments != segments;
  }
}

// Старый painter `_TowerPathPainter` удалён (заменён `_GridPathPainter`)
