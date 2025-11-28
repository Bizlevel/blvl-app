import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/widgets/common/bizlevel_card.dart';
import 'package:go_router/go_router.dart';
import 'package:bizlevel/widgets/common/bizlevel_button.dart';
import 'package:bizlevel/widgets/level/blocks/level_page_block.dart';

class GoalV1Block extends LevelPageBlock {
  final VoidCallback onSaved;
  GoalV1Block({required this.onSaved});
  @override
  Widget build(BuildContext context, int index) {
    final TextEditingController goalInitialCtrl = TextEditingController();
    final TextEditingController goalWhyCtrl = TextEditingController();
    final TextEditingController mainObstacleCtrl = TextEditingController();

    return Consumer(builder: (context, ref, _) {
      const versionsAsync =
          AsyncValue<List<Map<String, dynamic>>>.data(<Map<String, dynamic>>[]);
      return versionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, __) => Center(child: Text('Ошибка загрузки цели: $e')),
        data: (all) {
          final byVersion = {
            for (final m in all)
              m['version'] as int: Map<String, dynamic>.from(m)
          };
          final v1 = byVersion[1]?['version_data'];
          if (v1 is Map) {
            final data = Map<String, dynamic>.from(v1);
            goalInitialCtrl.text = (data['goal_initial'] ?? '') as String;
            goalWhyCtrl.text = (data['goal_why'] ?? '') as String;
            mainObstacleCtrl.text = (data['main_obstacle'] ?? '') as String;
          }

          return SingleChildScrollView(
            padding:
                AppSpacing.insetsSymmetric(h: AppSpacing.xl, v: AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BizLevelCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Куда дальше?',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      AppSpacing.gapH(AppSpacing.sm),
                      const Text(
                        'Сформулируйте цель и начните дневник применений на странице «Цель». Это поможет Максу давать точные рекомендации.',
                      ),
                      AppSpacing.gapH(AppSpacing.md),
                      SizedBox(
                        width: double.infinity,
                        child: BizLevelButton(
                          label: 'Открыть страницу «Цель»',
                          onPressed: () {
                            GoRouter.of(context).push('/goal');
                            onSaved();
                          },
                        ),
                      ),
                      AppSpacing.gapH(AppSpacing.md),
                      const Divider(height: AppSpacing.xl),
                      Text(
                        'Артефакт: Ядро целей',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      AppSpacing.gapH(AppSpacing.sm),
                      const Text(
                        'Откройте артефакт «Ядро целей», чтобы пошагово сформулировать первую цель. Это поможет Максу давать точные рекомендации.',
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              GoRouter.of(context).push('/artifacts'),
                          icon: const Icon(Icons.auto_stories_outlined),
                          label: const Text('Открыть артефакт'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
