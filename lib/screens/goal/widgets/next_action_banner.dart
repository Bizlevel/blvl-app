import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/providers/goals_providers.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:go_router/go_router.dart';

/// Баннер "Что дальше?" (новая модель)
/// Логика:
/// - нет цели (L1 не выполнен) → CTA на чекпоинт L1
/// - нет финфокуса (L4 не выполнен) → CTA на чекпоинт L4
/// - есть дедлайн и нет решения L7 → CTA на чекпоинт L7
/// - иначе → CTA на добавление записи в журнал (скролл вниз)
class NextActionBanner extends ConsumerWidget {
  const NextActionBanner({
    super.key,
    required this.currentLevel,
    this.onScrollToSprint,
  });

  final int currentLevel;
  final VoidCallback? onScrollToSprint; // используется как скролл к журналу

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalAsync = ref.watch(userGoalProvider);
    final stateAsync = ref.watch(goalStateProvider);

    return goalAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (goal) {
        final state = stateAsync.asData?.value ?? const <String, dynamic>{};
        final bool l1 = state['l1Done'] == true;
        final bool l4 = state['l4Done'] == true;
        final bool l7 = state['l7Done'] == true;
        final String targetDate = (goal?['target_date'] ?? '').toString();
        final bool hasDeadline = targetDate.isNotEmpty;

        String title = 'Что дальше?';
        String cta = '';
        VoidCallback? onTap;

        if (!l1) {
          title = 'Сформулируйте первую цель';
          cta = 'Перейти к чекпоинту L1';
          onTap = () {
            try {
              Sentry.addBreadcrumb(Breadcrumb(
                  category: 'goal',
                  message: 'goal_next_action_tap',
                  level: SentryLevel.info,
                  data: {'target': 'l1'}));
            } catch (_) {}
            GoRouter.of(context).push('/checkpoint/l1');
          };
        } else if (!l4) {
          title = 'Добавьте финансовый фокус';
          cta = 'Перейти к чекпоинту L4';
          onTap = () {
            try {
              Sentry.addBreadcrumb(Breadcrumb(
                  category: 'goal',
                  message: 'goal_next_action_tap',
                  level: SentryLevel.info,
                  data: {'target': 'l4'}));
            } catch (_) {}
            GoRouter.of(context).push('/checkpoint/l4');
          };
        } else if (hasDeadline && !l7) {
          title = 'Проверьте реалистичность цели';
          cta = 'Перейти к чекпоинту L7';
          onTap = () {
            try {
              Sentry.addBreadcrumb(Breadcrumb(
                  category: 'goal',
                  message: 'goal_next_action_tap',
                  level: SentryLevel.info,
                  data: {'target': 'l7'}));
            } catch (_) {}
            GoRouter.of(context).push('/checkpoint/l7');
          };
        } else {
          title = 'Двигайте цель ежедневными применениями';
          cta = 'Добавить запись в журнал';
          onTap = onScrollToSprint;
        }

        if (cta.isEmpty) return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.flag_circle_outlined, color: Colors.blue),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: onTap,
                    child: Text(cta),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
