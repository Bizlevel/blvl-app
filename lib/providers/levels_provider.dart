import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/models/level_model.dart';
import 'package:bizlevel/providers/levels_repository_provider.dart';
import 'package:bizlevel/providers/subscription_provider.dart';
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bizlevel/utils/formatters.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Provides список уровней с учётом прогресса пользователя.
final levelsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.watch(levelsRepositoryProvider);

  final int? userCurrentLevel =
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

    // Доступность уровня
    bool isAccessible;
    if (level.number == 0) {
      // «Первый шаг» всегда доступен для просмотра
      isAccessible = true;
    } else if (!level.isFree && level.number > 3) {
      // Премиум уровни открываются при активной подписке и после завершения предыдущего
      isAccessible = isPremium && previousCompleted;
    } else {
      // Обычные уровни доступны только после завершения предыдущего уровня
      isAccessible = previousCompleted;
    }

    // Обновляем previousCompleted для следующего уровня:
    // - уровень считается «пройденным» если user_progress.is_completed = true
    // - или если текущий уровень пользователя больше номера этого уровня
    previousCompleted = isCompleted || ((userCurrentLevel ?? 0) > level.number);

    final bool isLocked = !isAccessible;

    return {
      'id': level.id,
      'image': level.imageUrl,
      'level': level.number,
      'name': level.title,
      'displayCode': formatLevelCode(1, level.number),
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

/// Определяет «куда продолжить» на главном экране.
/// Возвращает: { levelId, levelNumber, floorId: 1, requiresPremium }
final nextLevelToContinueProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final levels = await ref.watch(levelsProvider.future);

  final hasPremium =
      ref.watch(currentUserProvider.select((user) => user.value?.isPremium)) ??
          false;
  final subscriptionStatus =
      ref.watch(subscriptionProvider.select((sub) => sub.value));
  final bool isPremium = hasPremium || (subscriptionStatus == 'active');

  // 1) Пытаемся найти текущий уровень
  Map<String, dynamic>? candidate = levels
      .cast<Map<String, dynamic>?>()
      .firstWhere((l) => (l?['isCurrent'] as bool? ?? false),
          orElse: () => null);

  // 2) Иначе — первый доступный, который ещё не завершён
  candidate ??= levels.firstWhere(
    (l) =>
        (l['isLocked'] as bool? ?? true) == false &&
        (l['isCompleted'] as bool? ?? false) == false,
    orElse: () => levels.first,
  );

  final int levelNumber = candidate['level'] as int? ?? 0;
  final bool requiresPremium = (levelNumber > 3) && !isPremium;

  return {
    'levelId': candidate['id'] as int,
    'levelNumber': levelNumber,
    'floorId': 1,
    'requiresPremium': requiresPremium,
  };
});

/// Узлы башни (MVP): уровень 0 → divider(этаж 1) → уровни 1..10, чекпоинты будут
/// добавлены в 34.3 (сейчас помечаем их как завершённые для совместимости).
final towerNodesProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final levels = await ref.watch(levelsProvider.future);
  final Map<int, bool> cp = await _readCheckpointState();

  // Каркас узлов: level | divider | checkpoint
  final List<Map<String, dynamic>> nodes = [];

  // Добавляем уровень 0, если он присутствует
  final level0 = levels.firstWhere(
    (l) => (l['level'] as int? ?? -1) == 0,
    orElse: () => <String, dynamic>{},
  );
  if (level0.isNotEmpty) {
    nodes.add({'type': 'level', 'level': 0, 'data': level0});
  }

  // Разделитель «Этаж 1»
  nodes.add({'type': 'divider', 'title': 'Этаж 1: База предпринимательства'});

  // Чекпоинты после уровней (MVP — считаем пройденными, состояние подключим в 34.3)
  const checkpointAfter = <int>{2, 3, 5, 7, 9, 10};
  final Set<int> blockedNextLevels = {};

  // Уровни 1..N
  for (final l in levels.where((x) => (x['level'] as int? ?? 0) > 0)) {
    final int num = l['level'] as int? ?? 0;
    nodes.add({
      'type': 'level',
      'level': num,
      'data': l,
      'blockedByCheckpoint': blockedNextLevels.contains(num),
    });
    if (checkpointAfter.contains(num)) {
      nodes.add({
        'type': 'checkpoint',
        'afterLevel': num,
        'isCompleted': cp[num] == true,
        'source': 'default',
      });
      if (!(cp[num] == true)) {
        blockedNextLevels.add(num + 1);
      }
    }
  }

  return nodes;
});

Future<Map<int, bool>> _readCheckpointState() async {
  try {
    final box = await Hive.openBox('tower_checkpoints');
    final Map<int, bool> state = {};
    for (final key in box.keys) {
      final value = box.get(key) == true;
      final str = key.toString();
      if (str.startsWith('after_')) {
        final n = int.tryParse(str.substring(6));
        if (n != null) state[n] = value;
      }
    }
    return state;
  } catch (_) {
    return {};
  }
}
