import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/providers/levels_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bizlevel/widgets/common/bizlevel_button.dart';

/// Экран «Артефакты» (этап 1: каркас и маршрут)
/// Далее будет добавлена сетка 3xN и просмотр карточек.
class ArtifactsScreen extends ConsumerWidget {
  const ArtifactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levelsAsync = ref.watch(levelsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Артефакты'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _CollectedBadge(),
          )
        ],
      ),
      backgroundColor: AppColor.appBgColor,
      body: levelsAsync.when(
        loading: () => const _ArtifactsSkeletonGrid(),
        error: (e, st) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Не удалось загрузить артефакты',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColor.onSurfaceSubtle)),
          ),
        ),
        data: (levels) {
          // Маппинг локальных ассетов: front/back по номеру уровня
          final Map<int, (String front, String back)> assets = {
            1: (
              'assets/images/artefacts/art-1-1.png',
              'assets/images/artefacts/art-1-2.png'
            ),
            2: (
              'assets/images/artefacts/art-2-1.png',
              'assets/images/artefacts/art-2-2.png'
            ),
            3: (
              'assets/images/artefacts/art-3-1.png',
              'assets/images/artefacts/art-3-2.png'
            ),
            4: (
              'assets/images/artefacts/art-4-1.png',
              'assets/images/artefacts/art-4-2.png'
            ),
            5: (
              'assets/images/artefacts/art-5-1.png',
              'assets/images/artefacts/art-5-2.png'
            ),
            6: (
              'assets/images/artefacts/art-6-1.png',
              'assets/images/artefacts/art-6-2.png'
            ),
            7: (
              'assets/images/artefacts/art-7-1.png',
              'assets/images/artefacts/art-7-2.png'
            ),
            8: (
              'assets/images/artefacts/art-8-1.png',
              'assets/images/artefacts/art-8-2.png'
            ),
            9: (
              'assets/images/artefacts/art-9-1.png',
              'assets/images/artefacts/art-9-2.png'
            ),
            10: (
              'assets/images/artefacts/art-10-1.png',
              'assets/images/artefacts/art-10-2.png'
            ),
          };

          // Составим карточки только для уровней 1..10
          final items =
              levels.where((l) => (l['level'] as int? ?? 0) > 0).map((l) {
            final num = l['level'] as int? ?? 0;
            final title = (l['artifact_title'] as String?) ?? 'Артефакт';
            final desc = (l['artifact_description'] as String?) ?? '';
            final completed = (l['isCompleted'] as bool? ?? false);
            final pair = assets[num];
            return (
              level: num,
              title: title,
              description: desc,
              isUnlocked: completed,
              front: pair?.$1,
              back: pair?.$2,
            );
          }).toList();

          final allLocked = items.every((e) => e.isUnlocked != true);
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (allLocked)
                  _ArtifactsEmptyState(onOpenTower: () => context.go('/tower')),
                Expanded(
                  child: LayoutBuilder(builder: (context, c) {
                    final w = c.maxWidth;
                    int crossAxisCount = 3;
                    if (w < 380) crossAxisCount = 2;
                    if (w >= 1024) crossAxisCount = 4;
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 3 / 4,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final it = items[index];
                        final hasAsset = it.front != null && it.back != null;
                        final locked = !(it.isUnlocked == true);
                        return _ArtifactTile(
                          level: it.level,
                          title: it.title,
                          description: it.description,
                          front: hasAsset ? it.front! : null,
                          back: hasAsset ? it.back! : null,
                          isLocked: locked,
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CollectedBadge extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levels = ref.watch(levelsProvider).value ?? const [];
    const total = 10;
    final collected = levels
        .where((l) =>
            (l['level'] as int? ?? 0) >= 1 && (l['level'] as int? ?? 0) <= 10)
        .where((l) => (l['isCompleted'] as bool? ?? false))
        .length;
    final progress = total == 0 ? 0.0 : collected / total;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: SizedBox(
        width:
            110, // фиксированная ширина, чтобы избежать бесконечных ограничений в AppBar actions
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Собрано $collected/$total', textAlign: TextAlign.center),
            const SizedBox(height: 4),
            SizedBox(
              height: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  backgroundColor: Colors.white.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArtifactTile extends StatefulWidget {
  const _ArtifactTile({
    required this.level,
    required this.title,
    required this.description,
    required this.isLocked,
    this.front,
    this.back,
  });

  final int level;
  final String title;
  final String description;
  final bool isLocked;
  final String? front;
  final String? back;

  @override
  State<_ArtifactTile> createState() => _ArtifactTileState();
}

class _ArtifactTileState extends State<_ArtifactTile> {
  bool _hovered = false;
  bool _isNew = false;

  @override
  void initState() {
    super.initState();
    // Простая эвристика «Новый»: показываем, пока не откроют полноэкранный просмотр
    try {
      final box =
          Hive.isBoxOpen('artifacts_seen') ? Hive.box('artifacts_seen') : null;
      final key = 'seen_${widget.level}';
      _isNew = !(box?.get(key) == true);
    } catch (_) {
      _isNew = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final image = widget.front;
    return Semantics(
      label: 'Артефакт уровня ${widget.level}',
      button: !widget.isLocked,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedScale(
          scale: _hovered ? 1.03 : 1.0,
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          child: InkWell(
            onTap: widget.isLocked || image == null
                ? null
                : () {
                    // Помечаем как просмотренный
                    try {
                      final key = 'seen_${widget.level}';
                      () async {
                        try {
                          final box = Hive.isBoxOpen('artifacts_seen')
                              ? Hive.box('artifacts_seen')
                              : await Hive.openBox('artifacts_seen');
                          await box.put(key, true);
                        } catch (_) {}
                      }();
                      if (mounted) setState(() => _isNew = false);
                    } catch (_) {}
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: false,
                        barrierColor: Colors.black.withValues(alpha: 0.85),
                        pageBuilder: (ctx, _, __) => _ArtifactFullscreen(
                          front: widget.front!,
                          back: widget.back!,
                        ),
                      ),
                    );
                  },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.shadowColor.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Лёгкий tilt‑эффект
                        if (image != null)
                          AnimatedBuilder(
                            animation:
                                Listenable.merge([ValueNotifier(_hovered)]),
                            builder: (context, child) {
                              final angle = _hovered ? 0.06 : 0.0;
                              return Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.001)
                                  ..rotateY(angle),
                                child: child,
                              );
                            },
                            child: Image.asset(image, fit: BoxFit.cover),
                          )
                        else
                          Container(color: AppColor.appBgColor),
                        if (!widget.isLocked && _isNew)
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColor.premium.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'NEW',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        if (widget.isLocked) ...[
                          Container(
                              color: Colors.black.withValues(alpha: 0.35)),
                          const Positioned(
                            right: 8,
                            top: 8,
                            child: Icon(Icons.lock, color: Colors.white),
                          ),
                          Positioned(
                            left: 8,
                            right: 8,
                            bottom: 40,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.45),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                  'Откроется после Уровня ${widget.level}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12)),
                            ),
                          ),
                          Positioned(
                            left: 8,
                            right: 8,
                            bottom: 8,
                            child: SizedBox(
                              height: 44,
                              child: Semantics(
                                label: 'Перейти к Башне',
                                button: true,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.white.withValues(alpha: 0.9),
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10),
                                  ),
                                  onPressed: () => context
                                      .go('/tower?scrollTo=${widget.level}'),
                                  child: const Text('К Башне'),
                                ),
                              ),
                            ),
                          ),
                        ] else if (image != null)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.touch_app,
                                      color: Colors.white, size: 14),
                                  SizedBox(width: 4),
                                  Text('Тапните',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12)),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Уровень ${widget.level}',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(color: AppColor.labelColor)),
                        const SizedBox(height: 4),
                        Text(widget.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        if (widget.description.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(widget.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppColor.onSurfaceSubtle)),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ArtifactFullscreen extends StatefulWidget {
  const _ArtifactFullscreen({required this.front, required this.back});
  final String front;
  final String back;

  @override
  State<_ArtifactFullscreen> createState() => _ArtifactFullscreenState();
}

class _ArtifactFullscreenState extends State<_ArtifactFullscreen>
    with SingleTickerProviderStateMixin {
  // Текущее видимое лицо в состоянии покоя
  bool _isFrontVisible = true;
  late AnimationController _ctrl;
  bool _isClosing = false;
  double _dragAccumulatedDy = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _flip() async {
    if (_ctrl.isAnimating) return;
    await _ctrl.forward();
    setState(() => _isFrontVisible = !_isFrontVisible);
    _ctrl.reset();
  }

  double _currentAngle() => _ctrl.value * 3.1415926535; // 0..pi

  void _onVerticalDragStart(DragStartDetails d) {
    _dragAccumulatedDy = 0;
  }

  void _onVerticalDragUpdate(DragUpdateDetails d) {
    if (_isClosing) return;
    final dy = d.delta.dy;
    if (dy > 0) {
      _dragAccumulatedDy += dy;
      if (_dragAccumulatedDy > 60) {
        _close();
      }
    }
  }

  void _onVerticalDragEnd(DragEndDetails d) {
    if (_isClosing) return;
    final v = d.primaryVelocity ?? 0;
    if (v > 800) {
      _close();
    }
  }

  void _close() {
    if (_isClosing) return;
    _isClosing = true;
    if (mounted) {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flip,
      onVerticalDragStart: _onVerticalDragStart,
      onVerticalDragUpdate: _onVerticalDragUpdate,
      onVerticalDragEnd: _onVerticalDragEnd,
      child: Scaffold(
        backgroundColor: Colors.black.withValues(alpha: 0.85),
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: AnimatedBuilder(
                  animation: _ctrl,
                  builder: (context, child) {
                    final angle = _currentAngle();
                    final bool firstHalf = angle <= 3.1415926535 / 2;
                    final String img = firstHalf
                        ? (_isFrontVisible ? widget.front : widget.back)
                        : (_isFrontVisible ? widget.back : widget.front);
                    final double displayAngle = firstHalf
                        ? angle
                        : 3.1415926535 - angle; // избегаем зеркала
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.0012)
                        ..rotateY(displayAngle),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 900),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 20,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: Image.asset(
                          img,
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.touch_app,
                                color: Colors.white, size: 16),
                            SizedBox(width: 6),
                            Text('Тапните или кнопка ниже',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 40,
                        child: BizLevelButton(
                          label: 'Перевернуть',
                          onPressed: _flip,
                          variant: BizLevelButtonVariant.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ArtifactsSkeletonGrid extends StatelessWidget {
  const _ArtifactsSkeletonGrid();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(builder: (context, c) {
        final w = c.maxWidth;
        int crossAxisCount = 3;
        if (w < 380) crossAxisCount = 2;
        if (w >= 1024) crossAxisCount = 4;
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 3 / 4,
          ),
          itemCount: 8,
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

class _ArtifactsEmptyState extends StatelessWidget {
  const _ArtifactsEmptyState({required this.onOpenTower});
  final VoidCallback onOpenTower;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowColor.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Артефактов пока нет',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(
              'Проходите уровни, чтобы открывать карточки. Начните с Уровня 1 на Башне.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColor.onSurfaceSubtle),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: BizLevelButton(
                label: 'К Башне',
                onPressed: onOpenTower,
              ),
            )
          ],
        ),
      ),
    );
  }
}
