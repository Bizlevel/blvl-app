import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/providers/levels_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class BizTowerScreen extends ConsumerWidget {
  const BizTowerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Башня БизЛевел'),
        backgroundColor: AppColor.appBarColor,
      ),
      backgroundColor: AppColor.appBgColor,
      body: Consumer(builder: (context, ref, _) {
        final levelsAsync = ref.watch(levelsProvider);
        return levelsAsync.when(
          data: (levels) {
            final int total = levels.length;
            final int completed =
                levels.where((l) => l['isCompleted'] == true).length;
            return LayoutBuilder(builder: (context, c) {
              return Stack(children: [
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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 16, 32, 24),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Ваш прогресс: $completed/$total уровней',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black54)),
                          const SizedBox(height: 12),
                          _FloorSection(
                              child: _LockedFloorTile(
                                  title: 'Этаж 4: Масштабирование',
                                  onTap: () => ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                          content: Text('Скоро'))))),
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
                                  title: 'Этаж 2: Продажи',
                                  onTap: () => ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                          content: Text('Скоро'))))),
                          const _FloorDivider(),
                          _FloorSection(
                            child: _OpenFloorTile(
                              number: 1,
                              title: 'База предпринимательства',
                              progress: total == 0 ? 0 : completed / total,
                              onTap: () => context.go('/floor/1'),
                            ),
                          ),
                          const _FloorDivider(),
                          _FloorSection(
                            child: _CompletedFloorTile(
                              number: 0,
                              title: 'Ресепшн',
                              onTap: () => context.go('/levels/0'),
                            ),
                          ),
                        ],
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
            return ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                _LockedFloorTile(title: 'Этаж 0: Ресепшн'),
                _LockedFloorTile(title: 'Этаж 1: База предпринимательства'),
                _LockedFloorTile(title: 'Этаж 2: Продажи'),
                _LockedFloorTile(title: 'Этаж 3: Команда'),
                _LockedFloorTile(title: 'Этаж 4: Масштабирование'),
              ],
            );
          },
        );
      }),
    );
  }
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

class _OpenFloorTile extends StatelessWidget {
  final int number;
  final String title;
  final double progress; // 0..1
  final VoidCallback? onTap;
  const _OpenFloorTile(
      {required this.number,
      required this.title,
      required this.progress,
      this.onTap});

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
          border: Border.all(color: AppColor.info, width: 2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(number.toString(),
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.w600)),
                const SizedBox(width: 12),
                Expanded(
                    child: Text('Этаж ' + number.toString() + ': ' + title,
                        style: const TextStyle(fontSize: 16))),
                const Icon(Icons.chevron_right),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                minHeight: 8,
                value: progress.clamp(0, 1),
                backgroundColor: Colors.black12,
                valueColor: const AlwaysStoppedAnimation(AppColor.success),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompletedFloorTile extends StatelessWidget {
  final int number;
  final String title;
  final VoidCallback? onTap;
  const _CompletedFloorTile(
      {required this.number, required this.title, this.onTap});

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
            Text(number.toString(),
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: AppColor.success)),
            const SizedBox(width: 12),
            Expanded(
                child: Text('Этаж ' + number.toString() + ': ' + title,
                    style: const TextStyle(fontSize: 16))),
            const Icon(Icons.check, color: Colors.green),
          ],
        ),
      ),
    );
  }
}
