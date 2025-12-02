import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/providers/goals_repository_provider.dart';
import 'package:bizlevel/screens/leo_dialog_screen.dart';
import 'package:bizlevel/widgets/common/bizlevel_button.dart';
import 'package:bizlevel/widgets/common/donut_progress.dart';
import 'package:intl/intl.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:bizlevel/utils/max_context_helper.dart';

class HomeGoalCard extends ConsumerWidget {
  const HomeGoalCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalAsync = ref.watch(userGoalProvider);
    return Semantics(
      label: 'Моя цель',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go('/goal'),
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
          child: Container(
            constraints: const BoxConstraints(
              minHeight: AppDimensions.homeGoalMinHeight,
            ),
            padding: AppSpacing.insetsAll(AppSpacing.s20),
            decoration: BoxDecoration(
              // fix: цвета/радиусы/тени → токены
              color: Theme.of(context).cardTheme.color ?? AppColor.card,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
              boxShadow: const [
                BoxShadow(
                  color: AppColor.shadowSoft,
                  blurRadius: 24,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: goalAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Text('Не удалось загрузить цель'),
              data: (goal) {
                final repo = ref.read(goalsRepositoryProvider);
                final double? progress = repo.computeGoalProgressPercent(goal);
                final String goalText = (goal?['goal_text'] ?? '').toString();

                DateTime? targetDate;
                try {
                  final td = (goal?['target_date']?.toString());
                  targetDate = td == null
                      ? null
                      : DateTime.tryParse(td)?.toLocal();
                } catch (_) {}

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final isCompact = constraints.maxWidth < 360;
                    final goalStyle = Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(height: 1.4);
                    Widget buildCtas() {
                      final buttons = [
                        Expanded(
                          child: BizLevelButton(
                            icon: const Icon(Icons.add_task, size: 20),
                            label: '+ Действие к цели',
                            onPressed: () {
                              try {
                                Sentry.addBreadcrumb(
                                  Breadcrumb(
                                    category: 'ui.tap',
                                    message: 'home_goal_action_tap',
                                    level: SentryLevel.info,
                                  ),
                                );
                              } catch (_) {}
                              context.go('/goal?scroll=journal');
                            },
                            variant: BizLevelButtonVariant.secondary,
                            size: BizLevelButtonSize.lg,
                          ),
                        ),
                        AppSpacing.gapW(AppSpacing.md),
                        Expanded(
                          child: BizLevelButton(
                            icon: Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/avatars/avatar_max.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            label: 'Обсудить с Максом',
                            onPressed: () {
                              try {
                                Sentry.addBreadcrumb(
                                  Breadcrumb(
                                    category: 'ui.tap',
                                    message: 'home_goal_max_tap',
                                    level: SentryLevel.info,
                                  ),
                                );
                              } catch (_) {}
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => LeoDialogScreen(
                                    bot: 'max',
                                    userContext: buildMaxUserContext(
                                      goal: goal,
                                    ),
                                    levelContext: '',
                                  ),
                                ),
                              );
                            },
                            size: BizLevelButtonSize.lg,
                          ),
                        ),
                      ];
                      if (!isCompact) {
                        return Row(children: buttons);
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          buttons[0],
                          AppSpacing.gapH(AppSpacing.sm),
                          buttons[2],
                        ],
                      );
                    }

                    final donutSize = isCompact ? 82.0 : 104.0;
                    final donutStroke = isCompact ? 6.0 : 8.0;

                    return Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Моя цель',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              AppSpacing.gapH(AppSpacing.md),
                              Text(
                                goalText.isEmpty ? 'Цель не задана' : goalText,
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                                style: goalStyle,
                              ),
                              AppSpacing.gapH(AppSpacing.s10),
                              if (targetDate != null)
                                Row(
                                  children: [
                                    const Icon(Icons.schedule, size: 18),
                                    AppSpacing.gapW(AppSpacing.xs),
                                    Text(
                                      targetDate.isBefore(DateTime.now())
                                          ? 'Поставить новый дедлайн'
                                          : 'до ${DateFormat('dd.MM.yyyy').format(targetDate)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: targetDate
                                                    .isBefore(DateTime.now())
                                                ? AppColor.error
                                                : AppColor.onSurfaceSubtle,
                                          ),
                                    ),
                                  ],
                                ),
                              if (progress == null) ...[
                                AppSpacing.gapH(AppSpacing.sm),
                                Text(
                                  'Добавьте метрику (тип, текущее и целевое значение), чтобы видеть прогресс.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(color: AppColor.onSurfaceSubtle),
                                ),
                              ],
                              AppSpacing.gapH(AppSpacing.md),
                              buildCtas(),
                            ],
                          ),
                        ),
                        AppSpacing.gapW(AppSpacing.lg),
                        if (progress != null)
                          DonutProgress(
                            value: progress.clamp(0.0, 1.0),
                            size: donutSize,
                            strokeWidth: donutStroke,
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
