import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/providers/levels_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
// import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';

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
  // Ранее использовалось для пересчётов; оставлено для возможной телеметрии
  // ignore: unused_field
  List<Map<String, dynamic>> _lastNodes = const [];
  int? _lastScrolledTo;

  Future<void> _scrollToLevelNumber(int levelNumber) async {
    try {
      final key = _nodeKeys[levelNumber];
      if (key?.currentContext != null) {
        if (!mounted) return;
        await Scrollable.ensureVisible(key!.currentContext!,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            alignment: 0.3);
        Sentry.addBreadcrumb(Breadcrumb(
            level: SentryLevel.info,
            category: 'tower',
            message: 'tower_autoscroll_done level=$levelNumber'));
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
                          Sentry.addBreadcrumb(Breadcrumb(
                              level: SentryLevel.info,
                              category: 'tower',
                              message: 'tower_retry'));
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
      final double columnWidth =
          ((totalWidth - kSidePadding * 2) / 3).clamp(84.0, 500.0);
      // Адаптивная высота строки: на узких экранах добавляем небольшой запас
      final bool isNarrow = totalWidth < 420;
      final double rowHeight = isNarrow ? (kRowHeight + 8.0) : kRowHeight;
      // Размер checkpoint совпадает с размером level (MVP)
      final List<int> columns = _generateColumns(items.length);
      final double canvasHeight = (items.length + 1) * rowHeight;

      // Предварительно вычислим позиции и сегменты для painter
      final List<_Placed> placed = [];
      for (int i = 0; i < items.length; i++) {
        final item = items[i];
        final bool isCheckpoint =
            (item['type'] == 'mini_case' || item['type'] == 'goal_checkpoint');
        final double size = isCheckpoint ? kCheckpointSize : kNodeSize;
        int colIndex = columns[i];
        if (i > 0 && colIndex == placed[i - 1].col) {
          // Избегаем подряд одинаковых колонок: выбираем соседнюю
          final int alt1 = (colIndex + 1) % 3;
          final int alt2 = (colIndex + 2) % 3;
          colIndex = alt1 != placed[i - 1].col ? alt1 : alt2;
        }
        final double left =
            kSidePadding + colIndex * columnWidth + (columnWidth - size) / 2;
        final double centerY = canvasHeight - (i + 0.5) * rowHeight;
        final double squareTop = centerY - size / 2;
        // Все узлы имеют подпись сверху: квадрат смещается вверх на высоту лейбла
        final double widgetTop = squareTop - kLabelHeight;
        placed.add(_Placed(
            item: item,
            row: i,
            col: colIndex,
            left: left,
            top: widgetTop,
            squareTop: squareTop,
            size: size));
      }

      final List<_GridSegment> segments = [];
      for (int i = 0; i < placed.length - 1; i++) {
        final a = placed[i];
        final b = placed[i + 1];
        final Offset aCenter =
            Offset(a.left + a.size / 2, a.squareTop + a.size / 2);
        final Offset bCenter =
            Offset(b.left + b.size / 2, b.squareTop + b.size / 2);

        final String aType = (a.item['type'] as String? ?? 'level');

        // Точка выхода из A: если колонки одинаковые — снизу по центру; иначе — из боковой стороны по направлению к B на высоте центра
        late Offset start;
        if (a.col == b.col) {
          start =
              Offset(aCenter.dx, a.squareTop + a.size); // нижняя грань центра
        } else if (a.col < b.col) {
          start = Offset(a.left + a.size, aCenter.dy); // правая грань центр
        } else {
          start = Offset(a.left, aCenter.dy); // левая грань центр
        }
        // Точка входа в B: снизу по центру
        final Offset end = Offset(bCenter.dx, b.squareTop + b.size);

        // Цвет по статусу стартового узла (прозрачность применим при добавлении сегмента)
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
        segments.add(_GridSegment(
            start: start,
            end: end,
            color: color.withValues(alpha: kPathAlpha)));
      }

      // Карта центров для автоскролла больше не используется (ensureVisible)

      return SizedBox(
        height: canvasHeight,
        width: double.infinity,
        child: Stack(
          children: [
            // Слой точечной сетки фона
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _DotGridPainter(
                    spacing: 120,
                    radius: 3,
                    color: Colors.black.withValues(alpha: 0.06),
                  ),
                ),
              ),
            ),
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
                col: placed[i].col,
                left: placed[i].left,
                top: placed[i].top,
                size: placed[i].size,
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
    required double left,
    required double top,
    required double size,
  }) {
    final type = item['type'] as String?;
    final bool isCheckpoint = type == 'checkpoint' ||
        type == 'mini_case' ||
        type == 'goal_checkpoint';

    if (isCheckpoint) {
      // Квадрат чекпоинта по стилю уровня, но с белым фоном и подписью
      return Positioned(
        left: left,
        top: top,
        width: size,
        child: _buildStyledCheckpointNode(
            context: context,
            ref: ref,
            node: item,
            size: size,
            align: _alignmentForColumn(col)),
      );
    }

    // Узел уровня: используем существующую отрисовку
    final data = (item['data'] as Map).cast<String, dynamic>();
    final bool blockedByCheckpoint =
        item['blockedByCheckpoint'] as bool? ?? false;
    final Alignment align = _alignmentForColumn(col);

    return Positioned(
      left: left,
      top: top,
      width: size,
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
      final caseIndex =
          after == 3 ? 1 : (after == 6 ? 2 : (after == 9 ? 3 : 0));
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
            // Гейтинг: вход возможен только если завершён предыдущий уровень
            final prevDone = node['prevLevelCompleted'] as bool? ?? false;
            if (!prevDone) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Завершите предыдущий уровень')));
              return;
            }
            if (type == 'mini_case' && caseId != null) {
              context.push('/case/$caseId');
            } else if (type == 'goal_checkpoint' && goalVersion != null) {
              context.push('/goal-checkpoint/$goalVersion');
            }
          } catch (e, st) {
            Sentry.captureException(e, stackTrace: st);
          }
        },
        child: Semantics(
          label: type == 'mini_case'
              ? 'Мини-кейс после уровня $after'
              : (type == 'goal_checkpoint'
                  ? 'Чекпоинт цели версии ${goalVersion ?? ''}'
                  : 'Чекпоинт'),
          button: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black26, width: 4),
                  boxShadow: [
                    const BoxShadow(
                      color: Color(0x11000000),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.14),
                      blurRadius: 14,
                      spreadRadius: 1,
                      offset: const Offset(0, 6),
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
                    size: size * 0.7,
                  ),
                ),
              ),
            ],
          ),
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
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Завершите предыдущий уровень')));
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
        child: Semantics(
          label: 'Уровень $levelNumber',
          button: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  levelNumber == 0
                      ? 'Уровень 0: Первый шаг'
                      : 'Уровень $levelNumber: ${data['name']}',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                width: kNodeSize,
                height: kNodeSize,
                decoration: BoxDecoration(
                  color: AppColor.info,
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: _darker(AppColor.info, 0.2), width: 4),
                  boxShadow: [
                    const BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 10,
                      offset: Offset(0, 6),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 16,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
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
                                : Icons.circle),
                        color: Colors.white,
                        size: kNodeSize * 0.7,
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
      ),
    );
  }

  // Ранее пересчитывались центры для автоскролла; теперь используется ensureVisible
}

Alignment _alignmentForColumn(int col) {
  switch (col) {
    case 0:
      return Alignment.centerLeft;
    case 1:
      return Alignment.center;
    default:
      return Alignment.centerRight;
  }
}

// _truncateToTwoWords больше не требуется: заголовок рендерится полностью в 2 строки

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

// class _NodePoint {
//   final int levelNumber;
//   final Offset point;
//   _NodePoint(this.levelNumber, this.point);
// }

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
        ..strokeWidth = kPathStroke
        ..style = PaintingStyle.stroke
        ..isAntiAlias = true;

      final path = Path();
      final double r = kCornerRadius;
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

Color _darker(Color c, double t) {
  final lerped = Color.lerp(c, Colors.black, t);
  return lerped ?? c;
}

class _DotGridPainter extends CustomPainter {
  final double spacing;
  final double radius;
  final Color color;
  _DotGridPainter(
      {required this.spacing, required this.radius, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    for (double y = spacing / 2; y < size.height; y += spacing) {
      for (double x = spacing / 2; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotGridPainter oldDelegate) {
    return oldDelegate.spacing != spacing ||
        oldDelegate.radius != radius ||
        oldDelegate.color != color;
  }
}
