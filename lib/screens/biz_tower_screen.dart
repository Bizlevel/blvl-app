import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/providers/levels_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:bizlevel/providers/gp_providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bizlevel/services/gp_service.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:bizlevel/widgets/common/gp_balance_widget.dart';
import 'package:bizlevel/widgets/common/bizlevel_modal.dart';
import 'package:bizlevel/theme/ui_strings.dart';
import 'package:bizlevel/widgets/common/notification_center.dart';
import 'package:bizlevel/services/notification_log_service.dart';

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
  const BizTowerScreen(
      {super.key = const Key('biz_tower_screen'), this.scrollTo});

  @override
  ConsumerState<BizTowerScreen> createState() => _BizTowerScreenState();
}

/// Состояние экрана башни: содержит автоскролл и ключи узлов.
class _BizTowerScreenState extends ConsumerState<BizTowerScreen> {
  // ignore: unused_field
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
            curve: Curves.easeInOutCubic,
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          tooltip: 'Главная улица',
          onPressed: () {
            try {
              GoRouter.of(context).go('/home');
            } catch (_) {}
          },
        ),
        title: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Башня БизЛевел'),
            SizedBox(height: 2),
            Text(
              'Этаж 1: База предпринимательства',
              style: TextStyle(fontSize: 12, color: AppColor.labelColor),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: const Center(child: GpBalanceWidget()),
          )
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
            final int? requested = widget.scrollTo;
            if (requested != null && _lastScrolledTo != requested) {
              _scheduleAutoscrollTo(requested);
              _lastScrolledTo = requested;
            }
            return Stack(
              key: _stackKey,
              children: [
                _buildTowerGrid(context, ref, nodes),
                // Поверх башни может быть слой ошибок/баннеров
                // Баннеры показываются через статические методы NotificationCenter
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) {
            _captureError(e, st);
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: AppColor.labelColor),
                  const SizedBox(height: 8),
                  const Text('Не удалось загрузить башню'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(towerNodesProvider),
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
