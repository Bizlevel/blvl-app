import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/models/level_model.dart';
import 'package:bizlevel/providers/levels_repository_provider.dart';
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/utils/formatters.dart';
import 'package:bizlevel/services/supabase_service.dart';
// import 'package:hive_flutter/hive_flutter.dart';
import 'package:bizlevel/providers/goals_providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bizlevel/utils/constant.dart';

/// Provides список уровней с учётом прогресса пользователя.
final levelsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.watch(levelsRepositoryProvider);

  // Дожидаемся профиля пользователя, чтобы избежать расчётов с null userId
  final user = await ref.watch(currentUserProvider.future);
  final int userCurrentLevelNumber =
      await SupabaseService.resolveCurrentLevelNumber(user?.currentLevel);
  // Подписки отключены (этап 39.1). Доступ уровней >3 будет реализован через GP (этап 39.7).

  final userId = Supabase.instance.client.auth.currentUser?.id;
  final rows = await repo.fetchLevels(userId: userId);

  // Получаем доступ к этажам (floor_access) — учитываем для уровней >3
  // Дожидаемся профиля, чтобы гарантированно иметь авторизованную сессию перед чтением прогресса
  await ref.watch(currentUserProvider.future);
  final supa = Supabase.instance.client;
  final List<dynamic> accessRows = await supa
      .from('floor_access')
      .select('floor_number')
      .catchError((_) => <dynamic>[]);
  final Set<int> unlockedFloors = {
    for (final r in accessRows)
      if (r is Map && r['floor_number'] != null)
        (r['floor_number'] as num).toInt()
  };

  // Сначала сортируем по номеру на случай, если order потерян
  rows.sort((a, b) => (a['number'] as int).compareTo(b['number'] as int));

  bool previousCompleted = false;

  int floorForLevelJson(Map<String, dynamic> json, LevelModel level) {
    // При активном флаге используем floor_number из API, иначе считаем, что все уровни на этаже 1
    if (kUseFloorMapping) {
      final v = json['floor_number'];
      if (v is int) return v;
      if (v is num) return v.toInt();
    }
    return 1;
  }

  bool isFreeOnFloor(int floor, int number) {
    // Для этажа 1 бесплатны 0..3; для остальных этажей по умолчанию всё платно
    if (floor == 1) return number <= 3;
    return false;
  }

  return rows.map((json) {
    final level = LevelModel.fromJson(json);
    final floor = floorForLevelJson(json, level);

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
    } else {
      // Доступ по этажу: бесплатные на этаже — всегда; иначе нужен floor_access
      final bool hasAccess =
          isFreeOnFloor(floor, level.number) || unlockedFloors.contains(floor);
      isAccessible = hasAccess && previousCompleted;
    }

    // Обновляем previousCompleted для следующего уровня:
    // - уровень считается «пройденным» если user_progress.is_completed = true
    // - или если текущий уровень пользователя больше номера этого уровня
    previousCompleted = isCompleted || (userCurrentLevelNumber > level.number);

    final bool isLocked = !isAccessible;

    return {
      'id': level.id,
      // Репозиторий мог подставить подписанный cover в json['image'].
      // Используем его с приоритетом, иначе fallback на image_url из модели.
      'image': (json['image'] ?? level.imageUrl),
      'level': level.number,
      'floor': floor,
      'name': level.title,
      'displayCode': formatLevelCode(floor, level.number),
      'lessons': () {
        final lessonsAgg = json['lessons'];
        if (lessonsAgg is List && lessonsAgg.isNotEmpty) {
          return (lessonsAgg.first['count'] as int? ?? 0);
        }
        return 0;
      }(),
      // Уровень 0 должен быть всегда доступен
      'isLocked': level.number == 0 ? false : isLocked,
      'isCompleted': isCompleted,
      'isCurrent': level.number == userCurrentLevelNumber,
      'lockReason': isLocked
          ? (!isFreeOnFloor(floor, level.number) &&
                  !unlockedFloors.contains(floor)
              ? 'Требуются GP'
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
  // Дождёмся профиля, чтобы избежать гонки null currentLevel
  final user = await ref.watch(currentUserProvider.future);
  final int userCurrentLevelNumber =
      await SupabaseService.resolveCurrentLevelNumber(user?.currentLevel);

  final levels = await ref.watch(levelsProvider.future);
  final nodes = await ref.watch(towerNodesProvider.future);

  // 0) Чекпоинт цели (если предшествующий уровень завершён)
  final Map<String, dynamic> pendingGoalCp = nodes.firstWhere(
    (n) => n['type'] == 'goal_checkpoint' && (n['isCompleted'] != true),
    orElse: () => <String, dynamic>{},
  );
  if (pendingGoalCp.isNotEmpty) {
    final int afterLevel = pendingGoalCp['afterLevel'] as int? ?? 0;
    final int targetLevel = afterLevel;
    final int? gver = pendingGoalCp['version'] as int?;
    final candidate = levels.firstWhere(
      (l) => (l['level'] as int? ?? -1) == targetLevel,
      orElse: () => levels.first,
    );
    if ((candidate['isCompleted'] as bool? ?? false) == true) {
      return {
        'levelId': candidate['id'] as int,
        'levelNumber': targetLevel,
        'floorId': 1,
        'requiresPremium': false,
        'isLocked': false,
        'targetScroll': targetLevel,
        'label': 'Чекпоинт цели v${gver ?? ''}'.trim(),
        if (gver != null) 'goalCheckpointVersion': gver,
      };
    }
  }

  // 1) Мини‑кейс (если предыдущий уровень завершён)
  final Map<String, dynamic> pendingMiniCase = nodes.firstWhere(
    (n) => n['type'] == 'mini_case' && (n['isCompleted'] != true),
    orElse: () => <String, dynamic>{},
  );
  if (pendingMiniCase.isNotEmpty) {
    final bool prevDone =
        (pendingMiniCase['prevLevelCompleted'] as bool? ?? false);
    final bool isRequired = pendingMiniCase['isRequired'] as bool? ?? true;
    final int afterLevel = pendingMiniCase['afterLevel'] as int? ?? 0;
    // Предлагаем мини‑кейс только если он обязательный и пользователь ещё не ушёл дальше по прогрессу
    if (prevDone && isRequired && userCurrentLevelNumber <= afterLevel) {
      final int caseId = pendingMiniCase['caseId'] as int;
      final String title = (pendingMiniCase['title'] as String?) ?? 'Мини‑кейс';
      return {
        'floorId': 1,
        'requiresPremium': false,
        'isLocked': false,
        'targetScroll': afterLevel + 1,
        'label': 'Мини‑кейс: $title',
        'miniCaseId': caseId,
      };
    }
  }

  // Определяем целевой номер сами, чтобы исключить редкие падения на fallback'ах
  final Map<String, dynamic>? currentRow =
      levels.cast<Map<String, dynamic>?>().firstWhere(
            (l) => (l?['level'] as int? ?? -1) == userCurrentLevelNumber,
            orElse: () => null,
          );
  final bool currDone = currentRow?['isCompleted'] as bool? ?? false;
  final int maxLevel = levels
      .map<int>((l) => (l['level'] as int? ?? 0))
      .fold<int>(0, (a, b) => a > b ? a : b);
  int desiredNumber =
      currDone ? (userCurrentLevelNumber + 1) : userCurrentLevelNumber;
  if (desiredNumber > maxLevel) {
    desiredNumber = maxLevel; // выход за пределы: ведём к последнему уровню
  }
  Map<String, dynamic> candidate = levels.firstWhere(
    (l) => (l['level'] as int? ?? -1) == desiredNumber,
    orElse: () => currentRow ?? levels.first,
  );

  final int levelNumber = candidate['level'] as int? ?? 0;
  final bool isLocked = candidate['isLocked'] as bool? ?? false;
  final int floor = (candidate['floor'] as int?) ?? 1;
  return {
    'levelId': candidate['id'] as int,
    'levelNumber': levelNumber,
    'floorId': floor,
    'requiresPremium': false,
    'isLocked': isLocked,
    'targetScroll': levelNumber,
    'label': 'Уровень $levelNumber',
  };
});

/// Узлы башни (MVP): уровень 0 → divider(этаж 1) → уровни 1..10, чекпоинты будут
/// добавлены в 34.3 (сейчас помечаем их как завершённые для совместимости).
final towerNodesProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final levels = await ref.watch(levelsProvider.future);
  // Локальное состояние старых чекпоинтов больше не используется
  // Загрузим мини-кейсы и прогресс пользователя по ним (id ∈ {1,2,3})
  final supa = Supabase.instance.client;
  final List<dynamic> casesRows = await supa
      .from('mini_cases')
      .select('id, after_level, title, is_required, active')
      .eq('active', true)
      .order('after_level');

  final Map<int, Map<String, dynamic>> miniCasesByAfterLevel = {
    for (final r in casesRows)
      if (r is Map<String, dynamic> && r['after_level'] != null)
        (r['after_level'] as num).toInt(): Map<String, dynamic>.from(r)
  };
  final List<int> caseIds =
      casesRows.map<int>((r) => (r['id'] as int)).toList(growable: false);
  final Set<int> doneCaseIds = <int>{};
  if (caseIds.isNotEmpty) {
    final String uid = Supabase.instance.client.auth.currentUser?.id ?? '';
    final List<dynamic> prog = await supa
        .from('user_case_progress')
        .select('case_id, status')
        .eq('user_id', uid)
        .inFilter('case_id', caseIds);
    for (final p in prog) {
      final status = (p['status'] as String?)?.toLowerCase() ?? 'started';
      final caseId = (p['case_id'] as num).toInt();
      if (status == 'completed' || status == 'skipped') {
        doneCaseIds.add(caseId);
      }
    }
  }

  // Статусы версий цели (v2 после L4, v3 после L7, v4 после L10)
  const Map<int, int> goalCheckpointVersionByAfterLevel = {
    4: 2,
    7: 3,
    10: 4,
  };
  // Проверяем наличие версий через провайдер (единый источник истины)
  final bool hasV2 = await ref.watch(hasGoalVersionProvider(2).future);
  final bool hasV3 = await ref.watch(hasGoalVersionProvider(3).future);
  final bool hasV4 = await ref.watch(hasGoalVersionProvider(4).future);

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

  // Убраны пустые чекпоинты‑заглушки: оставляем только реальные mini_case и goal_checkpoint
  // Номера уровней, которые заблокированы мини‑кейсом до его выполнения
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
    // Вставляем мини‑кейс после 3/6/9 (если активен)
    final mini = miniCasesByAfterLevel[num];
    if (mini != null) {
      final int caseId = (mini['id'] as int);
      final bool isRequired = (mini['is_required'] as bool? ?? true);
      final bool isDone = doneCaseIds.contains(caseId);
      nodes.add({
        'type': 'mini_case',
        'afterLevel': num,
        'caseId': caseId,
        'title': mini['title'],
        'isCompleted': isDone,
        // Чекпоинт доступен только после завершения предыдущего уровня
        'prevLevelCompleted': (l['isCompleted'] as bool? ?? false),
      });
      if (isRequired && !isDone) {
        // Блокируем следующий уровень до завершения/пропуска кейса
        blockedNextLevels.add(num + 1);
      }
    }

    // Вставляем чекпоинт цели после 4/7/10
    final int? goalVersion = goalCheckpointVersionByAfterLevel[num];
    if (goalVersion != null) {
      final bool isCompleted =
          goalVersion == 2 ? hasV2 : (goalVersion == 3 ? hasV3 : hasV4);
      nodes.add({
        'type': 'goal_checkpoint',
        'afterLevel': num,
        'version': goalVersion,
        'title': goalVersion == 2
            ? 'v2 Метрики'
            : (goalVersion == 3 ? 'v3 SMART' : 'v4 Финал'),
        'isCompleted': isCompleted,
        // Разрешаем входить в чекпоинт, только если предыдущий уровень завершён
        'prevLevelCompleted': (l['isCompleted'] as bool? ?? false),
      });
      // Строгая логика: блокируем следующий уровень, пока checkpoint не завершён
      // Новый UX: редактирование чекпоинтов не блокирует прогресс уровней
    }
  }

  return nodes;
});

// _readCheckpointState удалён как неиспользуемый вместе с пустыми чекпоинтами
