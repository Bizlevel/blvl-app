import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:bizlevel/theme/color.dart';

/// Компактная навигация между версиями цели (v1-v4) и неделями
///
/// Отображает чипы с галочками для заполненных версий и замками для заблокированных
class VersionNavigationChips extends StatelessWidget {
  const VersionNavigationChips({
    super.key,
    required this.versions,
    required this.allowedMaxVersion,
    required this.onScrollToSprint,
  });

  final Map<int, Map<String, dynamic>> versions;
  final int allowedMaxVersion;
  final VoidCallback onScrollToSprint;

  @override
  Widget build(BuildContext context) {
    final hasV1 = versions.containsKey(1);
    final hasV2 = versions.containsKey(2);
    final hasV3 = versions.containsKey(3);
    final hasV4 = versions.containsKey(4);

    final String currentStep;
    if (!hasV1) {
      currentStep = 'v1';
    } else if (!hasV2) {
      currentStep = 'v2';
    } else if (!hasV3) {
      currentStep = 'v3';
    } else if (!hasV4) {
      currentStep = 'v4';
    } else {
      currentStep = 'weeks';
    }

    void showLockedSnack(String msg) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    }

    return Wrap(
      children: [
        // v1
        _buildChip(
          context: context,
          label: 'v1',
          completed: hasV1,
          active: currentStep == 'v1',
          locked: false,
          onTap: () {
            if (!hasV1) {
              GoRouter.of(context).push('/tower?scrollTo=1');
            }
          },
        ),

        // v2
        _buildChip(
          context: context,
          label: 'v2',
          completed: hasV2,
          active: currentStep == 'v2',
          locked: (!hasV1) || allowedMaxVersion < 2,
          onTap: (!hasV1 || allowedMaxVersion < 2)
              ? () => showLockedSnack('Откроется после Уровня 4')
              : () => GoRouter.of(context).push('/goal-checkpoint/2'),
        ),

        // v3
        _buildChip(
          context: context,
          label: 'v3',
          completed: hasV3,
          active: currentStep == 'v3',
          locked: (!hasV2) || allowedMaxVersion < 3,
          onTap: (!hasV2 || allowedMaxVersion < 3)
              ? () => showLockedSnack('Откроется после Уровня 7')
              : () => GoRouter.of(context).push('/goal-checkpoint/3'),
        ),

        // v4
        _buildChip(
          context: context,
          label: 'v4',
          completed: hasV4,
          active: currentStep == 'v4',
          locked: (!hasV3) || allowedMaxVersion < 4,
          onTap: (!hasV3 || allowedMaxVersion < 4)
              ? () => showLockedSnack('Откроется после Уровня 10')
              : () => GoRouter.of(context).push('/goal-checkpoint/4'),
        ),

        // Weeks
        _buildChip(
          context: context,
          label: 'Недели',
          completed: false,
          active: currentStep == 'weeks',
          locked: !hasV4,
          onTap: !hasV4
              ? () => showLockedSnack('Доступно после v4 «Финал»')
              : onScrollToSprint,
        ),
      ],
    );
  }

  Widget _buildChip({
    required BuildContext context,
    required String label,
    required bool completed,
    required bool active,
    required bool locked,
    required VoidCallback? onTap,
  }) {
    final Color bg = locked
        ? AppColor.surface
        : (active ? AppColor.primary.withValues(alpha: 0.08) : Colors.white);

    final Color border = active
        ? AppColor.primary
        : (locked
            ? AppColor.labelColor.withValues(alpha: 0.4)
            : AppColor.labelColor.withValues(alpha: 0.3));

    final TextStyle? ts = Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          color: locked ? AppColor.labelColor : AppColor.textColor,
        );

    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 6),
      child: Semantics(
        button: true,
        label: 'Версия $label'
            '${completed ? ', заполнено' : ''}'
            '${locked ? ', заблокировано' : ''}',
        child: InkWell(
          onTap: locked ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: border),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x08000000),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (completed)
                  const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Colors.green,
                    ),
                  )
                else if (locked)
                  const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Icon(
                      Icons.lock_outline,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ),
                Row(
                  children: [
                    Text(label, style: ts),
                    if (!completed &&
                        !locked &&
                        (label == 'v1' ||
                            label == 'v2' ||
                            label == 'v3' ||
                            label == 'v4'))
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Text(
                          'Шаг ${label.substring(1)} из 4',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColor.labelColor,
                                  ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
