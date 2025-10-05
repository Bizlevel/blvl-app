import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:bizlevel/providers/goals_repository_provider.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/utils/goal_version_names.dart';

/// Баннер "Что дальше?" - показывает следующий шаг в кристаллизации цели
///
/// Использует RPC fetch_goal_state для определения:
/// - goal_checkpoint: переход на чекпоинт vN
/// - level_up: нужно пройти уровень для разблокировки версии
/// - weeks: все версии заполнены, переход к спринтам
class NextActionBanner extends ConsumerWidget {
  const NextActionBanner({
    super.key,
    required this.currentLevel,
    this.onScrollToSprint,
  });

  final int currentLevel;
  final VoidCallback? onScrollToSprint;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<Map<String, dynamic>>(
      future: ref.read(goalsRepositoryProvider).fetchGoalState(),
      builder: (context, snap) {
        if (!snap.hasData) return const SizedBox.shrink();

        final data = snap.data!;
        final String nextAction = (data['next_action'] as String?) ?? '';
        final int nextTarget = (data['next_action_target'] as int?) ?? 0;

        final (
          String title,
          String? progressLabel,
          String? timeEstimate,
          String ctaLabel,
          VoidCallback? onTap
        ) = _buildActionData(
          context: context,
          nextAction: nextAction,
          nextTarget: nextTarget,
          currentLevel: currentLevel,
          onScrollToSprint: onScrollToSprint,
        );

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColor.primary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColor.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (progressLabel != null || timeEstimate != null) ...[
                      Row(
                        children: [
                          if (progressLabel != null)
                            Text(
                              progressLabel,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColor.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          if (progressLabel != null && timeEstimate != null)
                            Text(
                              ' • ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.black54,
                                  ),
                            ),
                          if (timeEstimate != null)
                            Text(
                              timeEstimate,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.black54,
                                  ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                    ],
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Sentry.addBreadcrumb(Breadcrumb(
                    category: 'ui',
                    type: 'click',
                    message: 'goal_next_action_tap',
                    level: SentryLevel.info,
                  ));
                  if (onTap != null) onTap();
                },
                child: Text(ctaLabel),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Возвращает примерное время на заполнение версии
  String? _getVersionTimeEstimate(int version) {
    switch (version) {
      case 1:
        return '~2 мин';
      case 2:
        return '~3 мин';
      case 3:
        return '~5 мин';
      case 4:
        return '~2 мин';
      default:
        return null;
    }
  }

  /// Строит данные для кнопки действия на основе next_action
  /// Возвращает: (заголовок, прогресс-лейбл, оценка времени, CTA‑текст, callback)
  (String, String?, String?, String, VoidCallback?) _buildActionData({
    required BuildContext context,
    required String nextAction,
    required int nextTarget,
    required int currentLevel,
    VoidCallback? onScrollToSprint,
  }) {
    switch (nextAction) {
      case 'goal_checkpoint':
        if (nextTarget >= 1 && nextTarget <= 4) {
          final versionName = getGoalVersionName(nextTarget);
          final progressLabel = 'Шаг $nextTarget из 4';
          final timeEstimate = _getVersionTimeEstimate(nextTarget);
          return (
            'Что дальше: заполнить «$versionName»',
            progressLabel,
            timeEstimate,
            'Заполнить',
            () => GoRouter.of(context).push('/goal-checkpoint/$nextTarget'),
          );
        }
        break;

      case 'level_up':
        if (nextTarget >= 1 && nextTarget <= 4) {
          final versionName = getGoalVersionName(nextTarget);
          final progressLabel = 'Шаг $nextTarget из 4';
          return (
            'Что дальше: пройти Уровень $currentLevel для открытия «$versionName»',
            progressLabel,
            null, // Нет оценки времени для прохождения уровня
            'Открыть уровень',
            () => GoRouter.of(context).push('/tower?scrollTo=$currentLevel'),
          );
        }
        break;

      case 'weeks':
        return (
          'Что дальше: перейти к 28 дням',
          null, // Нет прогресса для этапа спринтов
          null,
          'Перейти',
          onScrollToSprint,
        );
    }

    // Дефолт: создать Семя цели
    return (
      'Что дальше: создать «${getGoalVersionName(1)}» на Уровне 1',
      'Шаг 1 из 4',
      '~2 мин',
      'Открыть Уровень 1',
      () => GoRouter.of(context).push('/tower?scrollTo=1'),
    );
  }
}
