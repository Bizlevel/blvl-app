import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/models/level_model.dart';
import 'package:bizlevel/providers/levels_repository_provider.dart';
import 'package:bizlevel/providers/subscription_provider.dart';
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provides список уровней с учётом прогресса пользователя.
final levelsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.watch(levelsRepositoryProvider);

  final userCurrentLevel =
      ref.watch(currentUserProvider.select((user) => user.value?.currentLevel));
  final hasPremium =
      ref.watch(currentUserProvider.select((user) => user.value?.isPremium));
  final subscriptionStatus =
      ref.watch(subscriptionProvider.select((sub) => sub.value));

  final bool isPremium =
      (hasPremium ?? false) || (subscriptionStatus == 'active');

  final userId = Supabase.instance.client.auth.currentUser?.id;
  final rows = await repo.fetchLevels(userId: userId);

  // Сначала сортируем по номеру на случай, если order потерян
  rows.sort((a, b) => (a['number'] as int).compareTo(b['number'] as int));

  bool previousCompleted = false;

  return rows.map((json) {
    final level = LevelModel.fromJson(json);

    // Определяем, завершён ли текущий уровень пользователем
    final progressArr = json['user_progress'] as List?;
    final bool isCompleted = progressArr != null && progressArr.isNotEmpty
        ? (progressArr.first['is_completed'] as bool? ?? false)
        : false;

    // Логика доступности
    bool isAccessible;
    if (level.number == 1) {
      isAccessible = true;
    } else if (!level.isFree && level.number > 3) {
      // Премиум уровни открываются только при активной подписке/флаге
      isAccessible = isPremium && previousCompleted;
    } else {
      isAccessible = previousCompleted;
    }

    // Обновляем previousCompleted для следующего уровня
    previousCompleted = isCompleted;

    final bool isLocked = !isAccessible;

    return {
      'id': level.id,
      'image': level.imageUrl,
      'level': level.number,
      'name': level.title,
      'lessons': () {
        final lessonsAgg = json['lessons'];
        if (lessonsAgg is List && lessonsAgg.isNotEmpty) {
          return (lessonsAgg.first['count'] as int? ?? 0);
        }
        return 0;
      }(),
      'isLocked': isLocked,
      'isCompleted': isCompleted,
      'isCurrent': level.number == userCurrentLevel,
      'lockReason': isLocked
          ? (level.number > 3 && !level.isFree
              ? 'Только для премиум'
              : 'Завершите предыдущий уровень')
          : null,
      'artifact_title': json['artifact_title'],
      'artifact_description': json['artifact_description'],
      'artifact_url': json['artifact_url'],
    };
  }).toList();
});
