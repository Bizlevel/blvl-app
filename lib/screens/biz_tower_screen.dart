import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/providers/levels_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:bizlevel/providers/gp_providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bizlevel/services/gp_service.dart';

part 'tower/tower_constants.dart';
part 'tower/tower_helpers.dart';
part 'tower/tower_extensions.dart';
part 'tower/tower_grid.dart';
part 'tower/tower_painters.dart';
part 'tower/tower_tiles.dart';
part 'tower/tower_floor_widgets.dart';

// Константы и хелперы вынесены в part-файлы tower_*.dart

/// Экран «Башня»: вертикальная карта прогресса обучения.
/// Внешний API/поведение не меняем; внутренняя структура упрощена.
class BizTowerScreen extends ConsumerStatefulWidget {
  final int? scrollTo;
  const BizTowerScreen({super.key, this.scrollTo});

  @override
  ConsumerState<BizTowerScreen> createState() => _BizTowerScreenState();
}

/// Состояние экрана башни: содержит автоскролл и ключи узлов.
class _BizTowerScreenState extends ConsumerState<BizTowerScreen> {
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _nodeKeys = {};
  final GlobalKey _stackKey = GlobalKey();
  // Ранее использовалось для пересчётов; оставлено для возможной телеметрии
  // ignore: unused_field
  List<Map<String, dynamic>> _lastNodes = const [];
  int? _lastScrolledTo;

  void _scheduleAutoscrollTo(int levelNumber) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _scrollToLevelNumber(levelNumber);
    });
  }

  /// Автоскролл к узлу уровня с безопасной обработкой ошибок.
  Future<void> _scrollToLevelNumber(int levelNumber) async {
    try {
      final key = _nodeKeys[levelNumber];
      if (key?.currentContext != null) {
        if (!mounted) return;
        await Scrollable.ensureVisible(key!.currentContext!,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            alignment: 0.3);
        _logBreadcrumb('tower_autoscroll_done level=$levelNumber');
      }
    } catch (e, st) {
      _captureError(e, st);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Открытие экрана — breadcrumb (однократно)
    _logBreadcrumb('tower_opened');
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
        actions: [
          Consumer(builder: (context, ref, _) {
            final gpAsync = ref.watch(gpBalanceProvider);
            final balance = gpAsync.value?['balance'];
            if (balance == null) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: InkWell(
                  onTap: () {
                    // Переход в магазин GP (маршрут добавим в 39.8)
                    try {
                      GoRouter.of(context).go('/gp-store');
                    } catch (_) {}
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.change_circle_outlined, size: 18),
                      const SizedBox(width: 4),
                      Text('${balance} GP',
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            );
          })
        ],
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
              _scheduleAutoscrollTo(requested);
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
              _scheduleAutoscrollTo(targetLevel);
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
            _captureError(e, st);
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
                          _logBreadcrumb('tower_retry');
                          // Перезапрос узлов
                          ref.invalidate(towerNodesProvider);
                        } catch (ex, stx) {
                          _captureError(ex, stx);
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
    return _TowerGrid(
      nodes: nodes,
      nodeBuilder: (
        Map<String, dynamic> item,
        int row,
        int col,
        double left,
        double top,
        double size,
      ) {
        return _positionedNode(
          context: context,
          ref: ref,
          item: item,
          row: row,
          col: col,
          left: left,
          top: top,
          size: size,
        );
      },
    );
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
    final String? type = item['type'] as String?;
    final bool isCheckpoint =
        type == 'checkpoint' || item.isMiniCase || item.isGoalCheckpoint;

    if (isCheckpoint) {
      return Positioned(
        left: left,
        top: top,
        width: size,
        child: _CheckpointNodeTile(
          node: item,
          size: size,
          align: _alignmentForColumn(col),
        ),
      );
    }

    final Map<String, dynamic> data = item.dataMap;
    final bool blockedByCheckpoint = item.blockedByCheckpoint;
    final Alignment align = _alignmentForColumn(col);
    final int levelNumber = data['level'] as int? ?? 0;
    _nodeKeys[levelNumber] = _nodeKeys[levelNumber] ?? GlobalKey();

    return Positioned(
      left: left,
      top: top,
      width: size,
      child: _LevelNodeTile(
        data: data,
        blockedByCheckpoint: blockedByCheckpoint,
        align: align,
        tileKey: _nodeKeys[levelNumber],
      ),
    );
  }
}
