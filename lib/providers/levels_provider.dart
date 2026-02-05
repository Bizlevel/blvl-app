import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/models/level_model.dart';
import 'package:bizlevel/providers/levels_repository_provider.dart';
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/utils/formatters.dart';
import 'package:bizlevel/services/supabase_service.dart';
import 'package:bizlevel/utils/goal_checkpoint_helper.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:bizlevel/providers/goals_providers.dart';
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

  // Собираем информацию о завершенности всех уровней из user_progress
  // Ключ: номер уровня, значение: завершен ли уровень (только из user_progress.is_completed)
  final Map<int, bool> levelCompletionStatus = {};
  for (final json in rows) {
    final levelNumber = (json['number'] as int? ?? -1);
    final progressArr = json['user_progress'] as List?;
    final bool isCompleted = progressArr != null && progressArr.isNotEmpty
        ? (progressArr.first['is_completed'] as bool? ?? false)
        : false;
    levelCompletionStatus[levelNumber] = isCompleted;
  }

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

  // Проверяет, завершены ли все предыдущие уровни (с меньшим номером)
  bool areAllPreviousLevelsCompleted(int currentLevelNumber) {
    if (currentLevelNumber <= 0) return true; // Уровень 0 всегда доступен
    
    // Проверяем все уровни с номером меньше текущего
    for (int i = 0; i < currentLevelNumber; i++) {
      // Если уровень существует в данных, проверяем его статус
      if (levelCompletionStatus.containsKey(i)) {
        if (levelCompletionStatus[i] != true) {
          return false; // Найден незавершенный предыдущий уровень
        }
      } else {
        // Если уровня нет в данных, но пользователь уже дошёл дальше — считаем завершённым
        if (i < userCurrentLevelNumber) {
          continue;
        }
        return false;
      }
    }
    return true; // Все предыдущие уровни завершены
  }

  return rows.map((json) {
    final level = LevelModel.fromJson(json);
    final floor = floorForLevelJson(json, level);

    // Определяем, завершён ли текущий уровень пользователем
    // Используем только user_progress.is_completed, без учёта current_level
    final progressArr = json['user_progress'] as List?;
    final bool isCompleted = progressArr != null && progressArr.isNotEmpty
        ? (progressArr.first['is_completed'] as bool? ?? false)
        : false;

    // Проверяем, завершены ли все предыдущие уровни
    final bool previousCompleted = areAllPreviousLevelsCompleted(level.number);

    // Доступность уровня
    bool isAccessible;
    bool isRepeatable = false;
    if (level.number == 0) {
      // «Первый шаг» всегда доступен для просмотра
      isAccessible = true;
      isRepeatable = false;
    } else if (isCompleted) {
      // Повторное прохождение разрешаем независимо от статуса предыдущих уровней
      isAccessible = true;
      isRepeatable = true;
    } else if (level.number < userCurrentLevelNumber) {
      // Пользователь уже проходил уровень — разрешаем повтор
      isAccessible = true;
      isRepeatable = true;
    } else {
      // Доступ по этажу: бесплатные на этаже — всегда; иначе нужен floor_access
      final bool hasAccess =
          isFreeOnFloor(floor, level.number) || unlockedFloors.contains(floor);
      isAccessible = hasAccess && previousCompleted;
    }

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
          ? (!previousCompleted
              ? 'Завершите предыдущий уровень'
              : (!isFreeOnFloor(floor, level.number) &&
                      !unlockedFloors.contains(floor))
                  ? 'Требуются GP'
                  : 'Завершите предыдущий уровень')
          : null,
      'isRepeatable': isRepeatable,
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

  // 0) Чекпоинт цели (если предыдущий уровень завершён и пользователь ещё не ушёл дальше)
  // Важно: чекпоинты L1/L4/L7 блокируют следующий уровень в башне.
  final Map<String, dynamic> pendingGoalCheckpoint = nodes.firstWhere(
    (n) =>
        n['type'] == 'goal_checkpoint' &&
        (n['isCompleted'] != true) &&
        (n['prevLevelCompleted'] as bool? ?? false) == true,
    orElse: () => <String, dynamic>{},
  );
  if (pendingGoalCheckpoint.isNotEmpty) {
    final int afterLevel = pendingGoalCheckpoint['afterLevel'] as int? ?? 0;
    // Не навязываем чекпоинт тем, кто уже ушёл дальше по прогрессу.
    if (userCurrentLevelNumber <= afterLevel + 1) {
      final String label = afterLevel == 1
          ? 'Чекпоинт L1: Первая цель'
          : (afterLevel == 4
              ? 'Чекпоинт L4: Финансовый фокус'
              : 'Чекпоинт L7: Проверка реальности');
      return {
        'floorId': 1,
        'requiresPremium': false,
        // Принудительно ведём в Башню, чтобы пользователь открыл чекпоинт в правильном месте.
        'isLocked': true,
        'targetScroll': afterLevel + 1,
        'label': label,
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
  final Map<String, dynamic> candidate = levels.firstWhere(
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
    // surface title from levels table (level name)
    'levelTitle': (candidate['name'] as String?),
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
  final List casesRows = await supa
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

  // Текущий номер уровня (нужен, чтобы не "ретро-блокировать" пользователей,
  // которые уже ушли дальше по прогрессу).
  int currentLevelNumber = 0;
  try {
    final current = levels.firstWhere(
      (l) => (l['isCurrent'] as bool? ?? false) == true,
      orElse: () => <String, dynamic>{},
    );
    currentLevelNumber = (current['level'] as int?) ?? 0;
  } catch (_) {}

  // Лёгкие признаки для чекпоинтов цели (новая модель user_goal)
  final String uid = Supabase.instance.client.auth.currentUser?.id ?? '';
  Map<String, dynamic>? userGoal;
  if (uid.isNotEmpty) {
    try {
      userGoal = await supa
          .from('user_goal')
            .select('goal_text, financial_focus, action_plan_note')
          .eq('user_id', uid)
          .limit(1)
          .maybeSingle();
    } catch (_) {}
  }

  // Статусы версий цели (v2 после L4, v3 после L7, v4 после L10)
  // Чекпоинты версий цели больше не используются

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

    // Добавляем goal_checkpoint после 1, 4, 7
    if (num == 1 || num == 4 || num == 7) {
      // Сначала проверяем, завершен ли уровень
      final bool levelCompleted = (l['isCompleted'] as bool? ?? false);
      
      bool completed = false;
      if (num == 1) {
        // Чекпоинт L1 считается завершенным только если:
        // 1. Уровень 1 завершен
        // 2. И есть goal_text в user_goal
        final String goalText = (userGoal?['goal_text'] ?? '').toString();
        final bool hasGoalText = goalText.trim().isNotEmpty ||
            isCheckpointGoalPlaceholder(goalText);
        completed = levelCompleted && hasGoalText;
      } else if (num == 4) {
        // Чекпоинт L4 считается завершенным только если:
        // 1. Уровень 4 завершен
        // 2. И есть financial_focus в user_goal
        final hasFinancialFocus = ((userGoal?['financial_focus'] ?? '')
            .toString()
            .trim()
            .isNotEmpty);
        completed = levelCompleted && hasFinancialFocus;
      } else if (num == 7) {
        // Чекпоинт L7 считается завершенным только если:
        // 1. Уровень 7 завершен
        // 2. И есть action_plan_note в user_goal
        final hasActionPlan = ((userGoal?['action_plan_note'] ?? '')
            .toString()
            .trim()
            .isNotEmpty);
        completed = levelCompleted && hasActionPlan;
      }

      // Важно: чекпоинт должен реально блокировать следующий уровень.
      // Иначе пользователь может открыть Уровень 2 (или 5/8) сразу после завершения уровня,
      // не заполнив цель/поля чекпоинта.
      //
      // При этом не "ретро-блокируем" тех, кто уже ушёл дальше (currentLevelNumber > num+1).
      final int nextLevelNumber = num + 1;
      final bool shouldBlockNext =
          levelCompleted && !completed && currentLevelNumber <= nextLevelNumber;
      if (shouldBlockNext) {
        blockedNextLevels.add(nextLevelNumber);
      }

      nodes.add({
        'type': 'goal_checkpoint',
        'afterLevel': num,
        'goalVersion': null,
        'isCompleted': completed,
        'prevLevelCompleted': (l['isCompleted'] as bool? ?? false),
        'route': num == 1
            ? '/checkpoint/l1'
            : (num == 4 ? '/checkpoint/l4' : '/checkpoint/l7'),
      });
    }
  }

  return nodes;
});

// _readCheckpointState удалён как неиспользуемый вместе с пустыми чекпоинтами
