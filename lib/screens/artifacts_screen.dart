import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/providers/levels_provider.dart';

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
        loading: () => const Center(child: CircularProgressIndicator()),
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
    final total = 10;
    final collected = levels
        .where((l) =>
            (l['level'] as int? ?? 0) >= 1 && (l['level'] as int? ?? 0) <= 10)
        .where((l) => (l['isCompleted'] as bool? ?? false))
        .length;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Text('Собрано $collected/$total'),
    );
  }
}

class _ArtifactTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final image = front;
    return Semantics(
      label: 'Артефакт уровня $level',
      button: !isLocked,
      child: InkWell(
        onTap: isLocked || image == null
            ? null
            : () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    opaque: false,
                    barrierColor: Colors.black.withOpacity(0.85),
                    pageBuilder: (ctx, _, __) => _ArtifactFullscreen(
                      front: front!,
                      back: back!,
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
                    if (image != null)
                      Image.asset(image, fit: BoxFit.cover)
                    else
                      Container(color: AppColor.appBgColor),
                    if (isLocked) ...[
                      Container(color: Colors.black.withOpacity(0.35)),
                      const Positioned(
                        right: 8,
                        top: 8,
                        child: Icon(Icons.lock, color: Colors.white),
                      ),
                      Positioned(
                        left: 8,
                        right: 8,
                        bottom: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.45),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('Откроется после Уровня $level',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12)),
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
                            color: Colors.black.withOpacity(0.5),
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
                    Text('Уровень $level',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: AppColor.labelColor)),
                    const SizedBox(height: 4),
                    Text(title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    if (description.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(description,
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
  late bool _showFront = true;
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _anim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutCubic),
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
    setState(() => _showFront = !_showFront);
    _ctrl.reset();
  }

  @override
  Widget build(BuildContext context) {
    final image = _showFront ? widget.front : widget.back;
    return GestureDetector(
      onTap: _flip,
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.85),
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: AnimatedBuilder(
                  animation: _anim,
                  builder: (context, child) {
                    final double angle = _anim.value * 3.14159; // 0..pi
                    final bool pastHalf = angle > 3.14159 / 2;
                    final double displayAngle = pastHalf
                        ? 3.14159 - angle // зеркалим вторую половину
                        : angle;
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.0015)
                        ..rotateY(displayAngle),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 900),
                        child: Image.asset(
                          image,
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
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.touch_app, color: Colors.white, size: 16),
                        SizedBox(width: 6),
                        Text('Тапните, чтобы перевернуть',
                            style:
                                TextStyle(color: Colors.white, fontSize: 13)),
                      ],
                    ),
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
