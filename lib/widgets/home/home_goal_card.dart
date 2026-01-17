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
import 'package:bizlevel/widgets/common/bizlevel_card.dart';
import 'package:bizlevel/widgets/common/donut_progress.dart';
import 'package:intl/intl.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:bizlevel/utils/max_context_helper.dart';
import 'package:bizlevel/utils/custom_modal_route.dart';

class HomeGoalCard extends ConsumerWidget {
  const HomeGoalCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalAsync = ref.watch(userGoalProvider);
    return BizLevelCard(
      semanticsLabel: 'Моя цель',
      onTap: () => context.go('/goal'),
      radius: AppDimensions.radiusXl,
      padding: AppSpacing.insetsAll(AppSpacing.s20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: AppDimensions.homeGoalMinHeight,
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
              targetDate =
                  td == null ? null : DateTime.tryParse(td)?.toLocal();
            } catch (_) {}

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    // Верхняя часть: текст цели + прогресс справа
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Моя цель',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              AppSpacing.gapH(AppSpacing.sm),
                              Text(
                                goalText.isEmpty ? 'Цель не задана' : goalText,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              AppSpacing.gapH(AppSpacing.sm),
                              if (targetDate != null)
                                Row(
                                  children: [
                                    const Text('⏱ '),
                                    Flexible(
                                      child: Text(
                                        targetDate.isBefore(DateTime.now())
                                            ? 'Поставить новый дедлайн'
                                            : 'до ${DateFormat('dd.MM.yyyy').format(targetDate)}',
                                        style: Theme.of(context).textTheme.bodySmall
                                            ?.copyWith(
                                              color: targetDate.isBefore(DateTime.now())
                                                  ? AppColor.error
                                                  : AppColor.onSurfaceSubtle,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        if (progress != null) ...[
                          const SizedBox(width: AppSpacing.md),
                          DonutProgress(
                            value: progress.clamp(0.0, 1.0),
                            size: 80,
                            strokeWidth: 6,
                          ),
                        ],
                      ],
                    ),
                    if (progress == null) ...[
                      AppSpacing.gapH(AppSpacing.sm),
                      Text(
                        'Добавьте метрику, чтобы видеть прогресс.',
                        style: Theme.of(context).textTheme.labelSmall
                            ?.copyWith(color: AppColor.onSurfaceSubtle),
                      ),
                    ],
                    AppSpacing.gapH(AppSpacing.md),
                    // Кнопки в отдельном ряду на всю ширину
                    Row(
                      children: [
                        Expanded(
                          child: BizLevelButton(
                            icon: const Icon(Icons.track_changes, size: 16),
                            label: 'Действие',
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
                            size: BizLevelButtonSize.sm,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: BizLevelButton(
                            icon: Container(
                              width: 18,
                              height: 18,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/avatars/avatar_max.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            label: 'Обсудить',
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
                              
                              // ВАЖНО: Получаем ProviderContainer из текущего контекста,
                              // чтобы передать его в UncontrolledProviderScope для диалога
                              // Это гарантирует, что провайдеры будут доступны даже если родитель умрет
                              final container = ProviderScope.containerOf(context);
                              
                              Navigator.of(context, rootNavigator: true).push(
                                CustomModalBottomSheetRoute(
                                  child: UncontrolledProviderScope(
                                    container: container,
                                    child: Scaffold(
                                      backgroundColor: Colors.transparent,
                                      resizeToAvoidBottomInset: true,
                                      body: Stack(
                                        children: [
                                          Positioned.fill(
                                            child: GestureDetector(
                                              behavior: HitTestBehavior.opaque,
                                              onTap: () {
                                                final navigator = Navigator.of(
                                                  context,
                                                  rootNavigator: true,
                                                );
                                                if (navigator.canPop()) {
                                                  navigator.pop();
                                                }
                                              },
                                              child: Container(color: Colors.transparent),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Material(
                                              color: Colors.transparent,
                                              child: ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                                                ),
                                                child: Container(
                                                  decoration: const BoxDecoration(
                                                    color: AppColor.surface,
                                                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                                  ),
                                                  clipBehavior: Clip.hardEdge,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        color: AppColor.primary,
                                                        child: SafeArea(
                                                          bottom: false,
                                                          child: AppBar(
                                                            backgroundColor: AppColor.primary,
                                                            automaticallyImplyLeading: false,
                                                            leading: Builder(
                                                              builder: (context) => IconButton(
                                                                tooltip: 'Закрыть',
                                                                icon: const Icon(Icons.close),
                                                                onPressed: () {
                                                                  FocusManager.instance.primaryFocus?.unfocus();
                                                                  final navigator = Navigator.of(
                                                                    context,
                                                                    rootNavigator: true,
                                                                  );
                                                                  if (navigator.canPop()) {
                                                                    navigator.pop();
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                            title: Row(
                                                              children: [
                                                                CircleAvatar(
                                                                  radius: 14,
                                                                  backgroundImage: const AssetImage('assets/images/avatars/avatar_max.png'),
                                                                  backgroundColor: Colors.transparent,
                                                                ),
                                                                const SizedBox(width: 8),
                                                                const Text('Макс'),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: LeoDialogScreen(
                                                          bot: 'max',
                                                          userContext: buildMaxUserContext(
                                                            goal: goal,
                                                          ),
                                                          levelContext: '',
                                                          embedded: true,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            size: BizLevelButtonSize.sm,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
          },
        ),
      ),
    );
  }
}
