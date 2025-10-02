import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bizlevel/providers/goals_repository_provider.dart';
import 'package:bizlevel/theme/color.dart';

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
        
        final (String title, VoidCallback? onTap) = _buildActionData(
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
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              TextButton(
                onPressed: onTap,
                child: const Text('Перейти'),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Строит данные для кнопки действия на основе next_action
  (String, VoidCallback?) _buildActionData({
    required BuildContext context,
    required String nextAction,
    required int nextTarget,
    required int currentLevel,
    VoidCallback? onScrollToSprint,
  }) {
    switch (nextAction) {
      case 'goal_checkpoint':
        if (nextTarget >= 2 && nextTarget <= 4) {
          return (
            'Что дальше: заполнить v$nextTarget на чекпоинте',
            () => GoRouter.of(context).push('/goal-checkpoint/$nextTarget'),
          );
        }
        break;

      case 'level_up':
        return (
          'Что дальше: пройти Уровень $currentLevel для открытия v$nextTarget',
          () => GoRouter.of(context).push('/tower?scrollTo=$currentLevel'),
        );

      case 'weeks':
        return (
          'Что дальше: перейти к 28 дням',
          onScrollToSprint,
        );
    }

    // Дефолт: создать v1
    return (
      'Что дальше: создать v1 на Уровне 1',
      () => GoRouter.of(context).push('/tower?scrollTo=1'),
    );
  }
}

