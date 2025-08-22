import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/providers/levels_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
  final Map<int, GlobalKey> _squareKeys = {};
  final GlobalKey _stackKey = GlobalKey();
  List<_Segment> _segments = [];
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
      }
    } catch (e, st) {
      Sentry.captureException(e, stackTrace: st);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                // Дороги между узлами
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: _TowerPathPainter(segments: _segments),
                    ),
                  ),
                ),
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
                                    title: 'Этаж 2: Продажи',
                                    onTap: () => ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                            content: Text('ppp'))))),
                            const _FloorDivider(),
                            _FloorSection(
                                child: _LockedFloorTile(
                                    title: 'Этаж 3: Команда',
                                    onTap: () => ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                            content: Text('Скоро'))))),
                            const _FloorDivider(),
                            _FloorSection(
                                child: _LockedFloorTile(
                                    title: 'Этаж 4: Масштабирование',
                                    onTap: () => ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                            content: Text('Скоро'))))),
                            const SizedBox(height: 12),
                            // Рендер узлов: снизу вверх — сначала уровень 0, затем этаж 1 и уровни
                            ...nodes.reversed.map((n) {
                              final type = n['type'];
                              if (type == 'divider') {
                                // Лейбл этажа вынесен в AppBar (закреплён)
                                return const SizedBox.shrink();
                              }
                              if (type == 'checkpoint') {
                                final int after = n['afterLevel'] as int;
                                final bool done = n['isCompleted'] as bool? ?? false;
                                final align = Alignment.center;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  child: _FloorSection(
                                    child: Align(
                                      alignment: align,
                                      child: _buildCheckpointNode(
                                        context,
                                        afterLevel: after,
                                        isCompleted: done,
                                        align: align,
                                        ref: ref, // добавили
                                      ),
                                    ),
                                  ),
                                );
                              }
                              // level
                              final data =
                                  (n['data'] as Map).cast<String, dynamic>();
                              final bool blockedByCheckpoint =
                                  n['blockedByCheckpoint'] as bool? ?? false;
                              final int num = data['level'] as int? ?? 0;
                              final Alignment align = _alignmentForLevel(num);
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: _FloorSection(
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Align(
                                      alignment: align,
                                      child: _buildLevelNode(
                                        context,
                                        data: data,
                                        blockedByCheckpoint:
                                            blockedByCheckpoint,
                                        align: align,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
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
              await _scrollToLevelNumber(next['levelNumber'] as int? ?? 0);
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
              child: SizedBox(
                width: 88, child: Text(
                _truncateToTwoWords(levelNumber == 0
                    ? 'Уровень 0: Первый шаг'
                    : 'Уровень $levelNumber: ${data['name']}'),
                textAlign: align == Alignment.centerLeft
                    ? TextAlign.left
                    : (align == Alignment.centerRight
                        ? TextAlign.right
                        : TextAlign.center),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
              ) 
            ),
            Container(
              key: _squareKeys[levelNumber] = _squareKeys[levelNumber] ?? GlobalKey(),
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
                      color: AppColor.premium.withOpacity(0.55),
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

Widget _buildCheckpointNode(BuildContext context,
    {required int afterLevel,
    required bool isCompleted,
    required Alignment align,
    required WidgetRef ref}) {
  // Чтобы ключи не пересекались с уровнями — используем отрицательный индекс
  final int checkpointKey = -afterLevel;
  _squareKeys[checkpointKey] = _squareKeys[checkpointKey] ?? GlobalKey();

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: SizedBox(
          width: 88,
          child: Text(
            'Чекпоинт',
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
      ),
      InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isCompleted
            ? null
            : () async {
                try {
                  final box = await Hive.openBox('tower_checkpoints');
                  await box.put('after_${afterLevel}', true);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Чекпоинт пройден')),
                    );
                  }

                  // Обновляем towerNodesProvider
                  ref.invalidate(towerNodesProvider);
                } catch (e, st) {
                  Sentry.captureException(e, stackTrace: st);
                }
              },
        child: Container(
          key: _squareKeys[checkpointKey],
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              isCompleted ? Icons.flag : Icons.flag_outlined,
              color: isCompleted ? AppColor.success : AppColor.info,
              size: 30,
            ),
          ),
        ),
      ),
    ],
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

    final Map<int, Map<String, dynamic>> levelData = {
      for (final n in _lastNodes.where((e) => e['type'] == 'level'))
        (n['level'] as int): (n['data'] as Map).cast<String, dynamic>()
    };

    final List<_NodePoint> points = [];
    for (final num in levelNumbers) {
      final key = _squareKeys[num];
      final ctx = key?.currentContext;
      final box = ctx?.findRenderObject() as RenderBox?;
      if (box == null) continue;
      final size = box.size;
      final centerGlobal =
          box.localToGlobal(Offset(size.width / 2, size.height / 2));
      final centerLocal = stackBox.globalToLocal(centerGlobal);
      points.add(_NodePoint(num, centerLocal));
    }

    final List<_Segment> segments = [];
    for (int i = 0; i < points.length - 1; i++) {
      final a = points[i];
      final b = points[i + 1];
      final data = levelData[a.levelNumber] ?? const {};
      final bool completed = data['isCompleted'] == true;
      final bool current = data['isCurrent'] == true;
      final bool locked = data['isLocked'] == true;
      final color = completed
          ? AppColor.success
          : (current
              ? AppColor.info
              : (locked ? Colors.grey.withOpacity(0.6) : AppColor.info));
      segments.add(_Segment(a.point, b.point, color));
    }

    setState(() => _segments = segments);
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

class _NodePoint {
  final int levelNumber;
  final Offset point;
  _NodePoint(this.levelNumber, this.point);
}

class _Segment {
  final Offset a;
  final Offset b;
  final Color color;
  _Segment(this.a, this.b, this.color);
}


class _TowerPathPainter extends CustomPainter {
  final List<_Segment> segments;
  _TowerPathPainter({required this.segments});

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in segments) {
      final paint = Paint()
        ..color = s.color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..isAntiAlias = true;
      // Рисуем линию с одним углом 90 градусов:
      // Сначала вертикально до уровня B по X, затем горизонтально до точки B
      final corner = Offset(s.b.dx, s.a.dy);
      final path = Path()
        ..moveTo(s.a.dx, s.a.dy)
        ..lineTo(corner.dx, corner.dy)
        ..lineTo(s.b.dx, s.b.dy);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TowerPathPainter oldDelegate) {
    return oldDelegate.segments != segments;
  }
}
