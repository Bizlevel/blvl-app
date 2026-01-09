part of '../biz_tower_screen.dart';

// Стоимость и номер пакета доступа к этажу (используются в диалогах разблокировки)
// Цена теперь подтягивается динамически из БД; значение ниже — только запасной дефолт.
const int _kFloorUnlockCost = 1000;
const int _kTargetFloorNumber = 1;

Future<void> _unlockFloor(BuildContext context,
    {required int floorNumber, int? priceGp}) async {
  try {
    final gp = GpService(Supabase.instance.client);
    final userId = Supabase.instance.client.auth.currentUser?.id ?? 'anon';
    final idem = 'floor:$userId:$floorNumber';
    final _ =
        await gp.unlockFloor(floorNumber: floorNumber, idempotencyKey: idem);
    if (!context.mounted) return;
    NotificationCenter.showSuccess(context, UIS.floorOpened);
    try {
      await NotificationLogService.instance.record(
        kind: NotificationKind.success,
        message: UIS.floorOpened,
        route: '/tower',
        category: 'tower',
      );
    } catch (_) {}
    // Обновим баланс и узлы башни
    try {
      final fresh = await gp.getBalance();
      await GpService.saveBalanceCache(fresh);
    } catch (_) {}
    if (!context.mounted) return;
    final container = ProviderScope.containerOf(context);
    container.invalidate(levelsProvider);
    container.invalidate(towerNodesProvider);
    container.invalidate(gpBalanceProvider);
  } on GpFailure catch (e) {
    if (!context.mounted) return;
    if (e.message.contains('Недостаточно GP')) {
      // Важно: показываем диалог и навигацию через "outer" context (экран башни),
      // а не контекст модалки покупки. Иначе после pop() контекст становится unmounted
      // и UX выглядит как "ничего не произошло".
      final cached = GpService.readBalanceCache();
      final balance = cached?['balance'] ?? 0;
      final price = priceGp ?? _kFloorUnlockCost;
      final missing = (price - balance);
      final String content = (missing > 0)
          ? 'Сейчас не хватает $missing GP, чтобы открыть этаж и продолжить обучение.\n\n'
              'Пополните баланс — и доступ откроется сразу.'
          : 'Сейчас не хватает GP, чтобы открыть этаж и продолжить обучение.\n\n'
              'Пополните баланс — и доступ откроется сразу.';
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(UIS.notEnoughGp),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Позже'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                if (context.mounted) context.push('/gp-store');
              },
              child: const Text('Пополнить GP'),
            ),
          ],
        ),
      );
      try {
        await NotificationLogService.instance.record(
          kind: NotificationKind.warn,
          message: UIS.notEnoughGp,
          route: '/gp-store',
          category: 'gp',
        );
      } catch (_) {}
    } else {
      NotificationCenter.showError(context, e.message);
      try {
        await NotificationLogService.instance.record(
          kind: NotificationKind.error,
          message: e.message,
          category: 'tower',
        );
      } catch (_) {}
    }
  } catch (e, st) {
    _captureError(e, st);
    if (!context.mounted) return;
    NotificationCenter.showError(context, UIS.floorOpenFailed);
    try {
      await NotificationLogService.instance.record(
        kind: NotificationKind.error,
        message: UIS.floorOpenFailed,
        category: 'tower',
      );
    } catch (_) {}
  }
}

void _showUnlockFloorDialog(BuildContext context, {required int floorNumber}) {
  // Важно: в BizLevelModal нажатие сначала закрывает dialog (pop), и только потом вызывает callback.
  // Поэтому здесь сохраняем внешний context (экран башни), чтобы последующие баннеры/диалоги/навигация
  // работали корректно.
  final outerContext = context;
  showDialog(
    context: outerContext,
    builder: (ctx) {
      return FutureBuilder<int>(
        future: GpService(Supabase.instance.client)
            .getFloorPrice(floorNumber: floorNumber),
        builder: (context, snapshot) {
          final price = snapshot.data ?? _kFloorUnlockCost;
          return BizLevelModal(
            title: 'Открыть этаж',
            subtitle: 'Стоимость: $price GP. Открыть доступ?',
            primaryLabel: '$price GP',
            icon: Icons.lock_open,
            onPrimary: () async {
              await _unlockFloor(outerContext,
                  floorNumber: floorNumber, priceGp: price);
            },
          );
        },
      );
    },
  );
}

bool _shouldShowUnlockButton(
    int levelNumber, bool isLocked, bool blockedByCheckpoint) {
  return levelNumber == 4 && isLocked && !blockedByCheckpoint;
}

void _handleCheckpointTap(BuildContext context, Map<String, dynamic> node) {
  try {
    final prevDone = node.prevLevelCompleted;
    if (!prevDone) {
      if (!context.mounted) return;
      _showBlockedSnackBar(context);
      return;
    }
    final String type = node.nodeType;
    // goalVersion больше не используется в новой модели
    final int? caseId = node.caseId;
    if (type == 'mini_case' && caseId != null) {
      if (!context.mounted) return;
      context.push('/case/$caseId');
    } else if (type == 'goal_checkpoint') {
      if (!context.mounted) return;
      final int after = node.afterLevel;
      final String route = after == 1
          ? '/checkpoint/l1'
          : (after == 4 ? '/checkpoint/l4' : '/checkpoint/l7');
      context.push(route);
    }
  } catch (e, st) {
    _captureError(e, st);
  }
}

void _handleLevelTap(
  BuildContext context, {
  required int levelNumber,
  required bool canOpen,
  required bool blockedByCheckpoint,
  required Map<String, dynamic> data,
}) {
  try {
    _logBreadcrumb(
        'tower.tap level=$levelNumber canOpen=$canOpen blockedByCheckpoint=$blockedByCheckpoint',
        category: 'ui.tap');
    if (!canOpen) {
      if (blockedByCheckpoint) {
        _showBlockedSnackBar(context);
      } else {
        _showUnlockFloorDialog(context, floorNumber: _kTargetFloorNumber);
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
}

Widget _buildLevelCoreTile({
  required bool isCurrent,
  required bool isCompleted,
  required bool isLocked,
}) {
  return Container(
    width: kNodeSize,
    height: kNodeSize,
    decoration: BoxDecoration(
      color: AppColor.info,
      borderRadius: BorderRadius.circular(kTileRadius),
      border: Border.all(color: _darker(AppColor.info, 0.2), width: 4),
      boxShadow: [
        const BoxShadow(
            color: AppColor.shadowColor, blurRadius: 10, offset: Offset(0, 6)),
        const BoxShadow(
            color: AppColor.shadowColor,
            blurRadius: 16,
            spreadRadius: 2,
            offset: Offset(0, 8)),
        if (isCurrent)
          BoxShadow(
              color: AppColor.premium.withValues(alpha: 0.55),
              blurRadius: 18,
              spreadRadius: 1),
      ],
    ),
    child: Stack(
      children: [
        Center(
          child: Icon(
            isCompleted
                ? Icons.check
                : (isLocked && !isCompleted ? Icons.lock : Icons.circle),
            color: AppColor.onPrimary,
            size: kNodeSize * 0.7,
          ),
        ),
        if (isCurrent)
          Positioned(
            top: 6,
            right: 6,
            child: _PulsingStar(),
          ),
      ],
    ),
  );
}

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
    // Новая модель цели: версии не используем

    String label;
    if (type == 'mini_case') {
      final caseIndex =
          after == 3 ? 1 : (after == 6 ? 2 : (after == 9 ? 3 : 0));
      label = caseIndex > 0 ? 'Кейс $caseIndex' : 'Кейс';
    } else if (type == 'goal_checkpoint') {
      // afterLevel 1 → L1, 4 → L4, 7 → L7
      final String cp = after == 1
          ? 'L1: Первая цель'
          : (after == 4 ? 'L4: Финансовый фокус' : 'L7: Проверка реальности');
      label = cp;
    } else {
      label = '';
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        onTap: () => _handleCheckpointTap(context, node),
        child: Semantics(
          label: type == 'mini_case'
              ? 'Мини-кейс после уровня $after'
              : (type == 'goal_checkpoint'
                  ? (after == 1
                      ? 'Чекпоинт L1: Первая цель'
                      : (after == 4
                          ? 'Чекпоинт L4: Финансовый фокус'
                          : 'Чекпоинт L7: Проверка реальности'))
                  : 'Чекпоинт'),
          button: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildNodeLabel(label),
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: AppColor.surface,
                  borderRadius: BorderRadius.circular(kTileRadius),
                  border: const Border.fromBorderSide(kTileBorderSide),
                  boxShadow: kTileShadows,
                ),
                child: Center(
                  child: Icon(
                    type == 'mini_case'
                        ? (isCompleted ? Icons.work : Icons.work_outline)
                        : (type == 'goal_checkpoint'
                            ? (isCompleted ? Icons.flag : Icons.flag_outlined)
                            : Icons.center_focus_strong),
                    color: type == 'mini_case'
                        ? (isCompleted ? AppColor.success : AppColor.info)
                        : (type == 'goal_checkpoint'
                            ? (isCompleted ? AppColor.success : AppColor.info)
                            : AppColor.labelColor),
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
    final bool isCompleted = data['isCompleted'] == true;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: tileKey,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        onTap: () => _handleLevelTap(
          context,
          levelNumber: levelNumber,
          canOpen: (isCompleted || !isLocked),
          blockedByCheckpoint: blockedByCheckpoint,
          data: data,
        ),
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
              ),
              _buildLevelCoreTile(
                isCurrent: isCurrent,
                isCompleted: isCompleted,
                isLocked: isLocked,
              ),
              if (_shouldShowUnlockButton(
                  levelNumber, isLocked, blockedByCheckpoint))
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side:
                          const BorderSide(color: AppColor.primary, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    onPressed: () {
                      try {
                        _showUnlockFloorDialog(context,
                            floorNumber: _kTargetFloorNumber);
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

class _PulsingStar extends StatefulWidget {
  @override
  State<_PulsingStar> createState() => _PulsingStarState();
}

class _PulsingStarState extends State<_PulsingStar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _t;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _t = CurvedAnimation(parent: _c, curve: Curves.easeInOutCubic);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _t,
      builder: (context, child) => Transform.scale(
        scale: 0.9 + (_t.value * 0.1),
        child: child,
      ),
      child: const Icon(Icons.star, color: AppColor.premium, size: 20),
    );
  }
}
