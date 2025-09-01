part of '../biz_tower_screen.dart';

class _CheckpointNodeTile extends StatelessWidget {
  final Map<String, dynamic> node;
  final double size;
  final Alignment align;
  const _CheckpointNodeTile(
      {required this.node, required this.size, required this.align});

  @override
  Widget build(BuildContext context) {
    final String type = node.nodeType;
    final bool isCompleted = node.nodeCompleted;
    final int after = node.afterLevel;
    final int? caseId = node.caseId;
    final int? goalVersion = node.goalVersion;

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
            final prevDone = node.prevLevelCompleted;
            if (!prevDone) {
              if (!context.mounted) return;
              _showBlockedSnackBar(context);
              return;
            }
            if (type == 'mini_case' && caseId != null) {
              if (!context.mounted) return;
              context.push('/case/$caseId');
            } else if (type == 'goal_checkpoint' && goalVersion != null) {
              if (!context.mounted) return;
              context.push('/goal-checkpoint/$goalVersion');
            }
          } catch (e, st) {
            _captureError(e, st);
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
              _buildNodeLabel(label, textAlign: TextAlign.center),
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(kTileRadius),
                  border: const Border.fromBorderSide(kTileBorderSide),
                  boxShadow: kTileShadows,
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
}

class _LevelNodeTile extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool blockedByCheckpoint;
  final Alignment align;
  final Key? tileKey;
  const _LevelNodeTile(
      {required this.data,
      required this.blockedByCheckpoint,
      required this.align,
      required this.tileKey});

  @override
  Widget build(BuildContext context) {
    final int levelNumber = data['level'] as int? ?? 0;
    final bool isCurrent = data['isCurrent'] == true;
    final bool isLockedBase = data['isLocked'] == true;
    final bool isLocked = isLockedBase || blockedByCheckpoint;
    final bool premiumLock = false; // Премиум-гейтинг снят (этап 39.1)
    final bool isCompleted = data['isCompleted'] == true;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: tileKey,
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          try {
            _logBreadcrumb(
                'tower.tap level=$levelNumber locked=$isLocked completed=$isCompleted blockedByCheckpoint=$blockedByCheckpoint',
                category: 'ui.tap');
            final bool canOpen = isCompleted || !isLocked;
            if (!canOpen) {
              if (blockedByCheckpoint) {
                _showBlockedSnackBar(context);
              } else if (!premiumLock) {
                // Предложить открыть этаж за GP (этап 39.7)
                showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      title: const Text('Открыть этаж'),
                      content:
                          const Text('Стоимость: 1000 GP. Открыть доступ?'),
                      actions: [
                        FilledButton(
                          onPressed: () async {
                            Navigator.of(ctx).pop();
                            try {
                              final gp = GpService(Supabase.instance.client);
                              final userId = Supabase
                                      .instance.client.auth.currentUser?.id ??
                                  'anon';
                              final idem = 'floor:' + userId + ':1';
                              await gp.unlockFloor(
                                  floorNumber: 1, idempotencyKey: idem);
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Этаж открыт')),
                              );
                              // Обновим баланс и узлы башни
                              try {
                                final fresh = await gp.getBalance();
                                await GpService.saveBalanceCache(fresh);
                              } catch (_) {}
                              if (!context.mounted) return;
                              final container =
                                  ProviderScope.containerOf(context);
                              container.invalidate(levelsProvider);
                              container.invalidate(towerNodesProvider);
                              container.invalidate(gpBalanceProvider);
                            } on GpFailure catch (e) {
                              if (!context.mounted) return;
                              if (e.message.contains('Недостаточно GP')) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Недостаточно GP'),
                                    action: SnackBarAction(
                                      label: 'Купить GP',
                                      onPressed: () {
                                        context.push('/gp-store');
                                      },
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.message)),
                                );
                              }
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Не удалось открыть этаж')),
                              );
                            }
                          },
                          child: const Text('1000 GP'),
                        ),
                      ],
                    );
                  },
                );
              }
              return;
            }
            Future.microtask(() {
              if (!context.mounted) return;
              context.push('/levels/${data['id']}?num=$levelNumber');
            });
          } catch (e, st) {
            _captureError(e, st);
          }
        },
        child: Semantics(
          label: 'Уровень $levelNumber',
          button: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildNodeLabel(
                levelNumber == 0
                    ? 'Уровень 0: Первый шаг'
                    : 'Уровень $levelNumber: ${data['name']}',
                textAlign: TextAlign.center,
              ),
              Container(
                width: kNodeSize,
                height: kNodeSize,
                decoration: BoxDecoration(
                  color: AppColor.info,
                  borderRadius: BorderRadius.circular(kTileRadius),
                  border:
                      Border.all(color: _darker(AppColor.info, 0.2), width: 4),
                  boxShadow: [
                    const BoxShadow(
                        color: Color(0x22000000),
                        blurRadius: 10,
                        offset: Offset(0, 6)),
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 16,
                        spreadRadius: 2,
                        offset: const Offset(0, 8)),
                    if (isCurrent)
                      BoxShadow(
                          color: AppColor.premium.withValues(alpha: 0.55),
                          blurRadius: 18,
                          spreadRadius: 1,
                          offset: const Offset(0, 0)),
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
              if (levelNumber == 4 && isLocked && !blockedByCheckpoint)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side:
                          const BorderSide(color: AppColor.primary, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    onPressed: () {
                      try {
                        showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: const Text('Открыть этаж'),
                              content: const Text(
                                  'Стоимость: 1000 GP. Открыть доступ?'),
                              actions: [
                                FilledButton(
                                  onPressed: () async {
                                    Navigator.of(ctx).pop();
                                    try {
                                      final gp =
                                          GpService(Supabase.instance.client);
                                      final userId = Supabase.instance.client
                                              .auth.currentUser?.id ??
                                          'anon';
                                      final idem = 'floor:' + userId + ':1';
                                      await gp.unlockFloor(
                                          floorNumber: 1, idempotencyKey: idem);
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text('Этаж открыт')),
                                      );
                                      try {
                                        final fresh = await gp.getBalance();
                                        await GpService.saveBalanceCache(fresh);
                                      } catch (_) {}
                                      if (!context.mounted) return;
                                      final container =
                                          ProviderScope.containerOf(context);
                                      container.invalidate(levelsProvider);
                                      container.invalidate(towerNodesProvider);
                                      container.invalidate(gpBalanceProvider);
                                    } on GpFailure catch (e) {
                                      if (!context.mounted) return;
                                      if (e.message
                                          .contains('Недостаточно GP')) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content:
                                                const Text('Недостаточно GP'),
                                            action: SnackBarAction(
                                              label: 'Купить GP',
                                              onPressed: () {
                                                context.push('/gp-store');
                                              },
                                            ),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(content: Text(e.message)),
                                        );
                                      }
                                    } catch (e) {
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Не удалось открыть этаж')),
                                      );
                                    }
                                  },
                                  child: const Text('1000 GP'),
                                ),
                              ],
                            );
                          },
                        );
                      } catch (e, st) {
                        _captureError(e, st);
                      }
                    },
                    child: const Text('Получить полный доступ к этажу'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
