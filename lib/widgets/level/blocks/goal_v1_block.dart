import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/widgets/common/bizlevel_card.dart';
import 'package:go_router/go_router.dart';
import 'package:bizlevel/widgets/common/bizlevel_button.dart';
import 'package:bizlevel/widgets/level/blocks/level_page_block.dart';
import 'package:bizlevel/providers/goals_providers.dart';

class GoalV1Block extends LevelPageBlock {
  final VoidCallback onSaved;
  GoalV1Block({required this.onSaved});
  @override
  Widget build(BuildContext context, int index) {
    final TextEditingController goalInitialCtrl = TextEditingController();
    final TextEditingController goalWhyCtrl = TextEditingController();
    final TextEditingController mainObstacleCtrl = TextEditingController();

    return Consumer(builder: (context, ref, _) {
      // Проверяем наличие сохраненной цели через userGoalProvider
      final goalAsync = ref.watch(userGoalProvider);

      return goalAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, __) => Center(child: Text('Ошибка загрузки цели: $e')),
        data: (goal) {
          // Проверяем, есть ли сохраненная цель
          final bool hasGoal = goal != null &&
              (goal['goal_text'] as String? ?? '').trim().isNotEmpty;

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
                          label:
                              hasGoal ? 'Цель сохранена ✓' : 'Сохранить цель',
                          onPressed: () async {
                            // Используем /checkpoint/l1 для сохранения цели во время прохождения Уровня 1
                            // (так как /goal недоступен до завершения уровня из-за гейтинга)
                            final result = await GoRouter.of(context)
                                .push('/checkpoint/l1');
                            // После возврата проверяем, была ли сохранена цель
                            // result будет true если цель была сохранена, или проверяем БД
                            // Инвалидируем провайдер для обновления данных
                            ref.invalidate(userGoalProvider);
                            // Проверяем цель снова после обновления
                            try {
                              final updatedGoal =
                                  await ref.read(userGoalProvider.future);
                              if (updatedGoal != null) {
                                final goalText =
                                    (updatedGoal['goal_text'] as String? ?? '')
                                        .trim();
                                if (goalText.isNotEmpty) {
                                  onSaved();
                                }
                              }
                            } catch (_) {
                              // Игнорируем ошибки при проверке
                            }
                          },
                        ),
                      ),
                      if (hasGoal)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.sm),
                          child: Text(
                            'Цель сохранена. Вы можете завершить уровень.',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
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
