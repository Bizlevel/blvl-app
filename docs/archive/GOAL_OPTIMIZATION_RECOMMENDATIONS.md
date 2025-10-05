# 📊 Отчёт по оптимизации системы Goal

**Дата анализа:** 2 октября 2025  
**Анализируемая папка:** `/lib` (файлы, связанные с Goal)  
**Инструменты:** CodeScene, ручной анализ кода

---

## 📈 Статистика размеров файлов

| Файл | Строк | Статус | Приоритет оптимизации |
|------|-------|--------|----------------------|
| **goal_screen.dart** | 1512 | ⛔ Критично | 🔴 Высокий |
| **goal_checkpoint_screen.dart** | 758 | ⚠️ Высокая сложность | 🟡 Средний |
| **goals_repository.dart** | 714 | ⚠️ Высокая сложность | 🟡 Средний |
| crystallization_section.dart | 419 | ✅ Приемлемо | 🟢 Низкий |
| goal_version_form.dart | 376 | ✅ Приемлемо | 🟢 Низкий |
| goal_screen_controller.dart | 280 | ✅ Хорошо | - |
| checkin_form.dart | 253 | ✅ Хорошо | - |

**Рекомендуемый максимум для одного файла:** 300-400 строк для UI, 500 строк для репозиториев

---

## 🔴 КРИТИЧЕСКАЯ ПРОБЛЕМА: goal_screen.dart (1512 строк)

### Проблемы:
1. **Монолитность:** Один файл содержит логику для 3 разных режимов (v1-v4, weekly, 28-day)
2. **Избыточность контроллеров:** 20+ TextEditingController в одном виджете
3. **Дублирование логики:** `_buildTrackerUserContext` дублирует `GoalScreenController.buildTrackerUserContext`
4. **Сложная структура:** Глубокая вложенность Builder'ов (до 5-6 уровней)
5. **Смешанная ответственность:** UI + бизнес-логика + валидации + навигация

### 🎯 Рекомендации по оптимизации:

#### **1. Разделение на специализированные экраны (300-400 строк каждый)**

```dart
// Текущая структура (1512 строк):
goal_screen.dart
  ├─ v1-v4 кристаллизация (450 строк)
  ├─ Weekly спринты (400 строк)
  └─ 28-day режим (662 строки)

// Предлагаемая структура:
lib/screens/goal/
  ├─ goal_overview_screen.dart          // 300 строк - главная страница с выбором режима
  ├─ goal_crystallization_screen.dart   // 350 строк - v1-v4 кристаллизация
  ├─ goal_weekly_screen.dart            // 300 строк - weekly спринты
  └─ goal_daily_28_screen.dart          // 400 строк - 28-дневный режим
```

**Выгода:**
- ✅ Каждый файл < 400 строк
- ✅ Чёткое разделение ответственности
- ✅ Легче тестировать и поддерживать
- ✅ Быстрее загружается в IDE
- ✅ Меньше конфликтов при командной работе

---

#### **2. Вынос логики контроллеров в отдельные классы**

**Текущая проблема:** 20+ TextEditingController в `_GoalScreenState`

**Решение:** Создать data holder классы:

```dart
// lib/screens/goal/models/goal_form_data.dart
class GoalFormData {
  final TextEditingController goalInitial;
  final TextEditingController goalWhy;
  final TextEditingController mainObstacle;
  // ... остальные
  
  GoalFormData() 
    : goalInitial = TextEditingController(),
      goalWhy = TextEditingController(),
      mainObstacle = TextEditingController();
      
  void dispose() {
    goalInitial.dispose();
    goalWhy.dispose();
    mainObstacle.dispose();
  }
  
  void fillFromVersion(Map<String, dynamic> data) {
    goalInitial.text = data['concrete_result'] ?? '';
    // ...
  }
}

class V1FormData { /* только v1 поля */ }
class V2FormData { /* только v2 поля */ }
class V3FormData { /* только v3 поля */ }
class V4FormData { /* только v4 поля */ }
```

**Выгода:**
- ✅ -80 строк из main файла
- ✅ Группировка связанных данных
- ✅ Автоматический dispose через один метод

---

#### **3. Разделение UI компонентов (уже частично сделано, но можно улучшить)**

**Текущие большие блоки в goal_screen.dart:**

```dart
// Строки 306-363: Баннер "Что дальше?" → вынести в отдельный виджет
NextActionBanner(
  nextAction: data['next_action'],
  nextTarget: data['next_action_target'],
  currentLevel: currentLevel,
)

// Строки 413-573: Chips навигации v1-v4 → вынести
VersionNavigationChips(
  versions: versions,
  allowedMax: allowedMax,
  currentStep: currentStep,
  onNavigate: (version) => ...,
)

// Строки 712-1056: 28-day режим → вынести полностью
DailySprintSection(
  versions: versions,
  onOpenChat: _openChatWithMax,
)
```

**Выгода:**
- ✅ -400 строк из main файла
- ✅ Компоненты можно переиспользовать
- ✅ Легче unit-тестировать

---

#### **4. Упрощение методов (сокращение дублирования)**

**Проблема:** Дублирование кода в нескольких местах

```dart
// goal_screen.dart:1152-1191 (40 строк)
String _buildTrackerUserContext(...) { ... }

// goal_screen_controller.dart:230-274 (45 строк)
String buildTrackerUserContext(...) { ... }
```

**Решение:** Удалить дублирование, использовать только метод из контроллера

```dart
// Вместо:
_buildTrackerUserContext(versions, selectedVersion)

// Использовать:
ref.read(goalScreenControllerProvider.notifier).buildTrackerUserContext(
  achievement: _achievementCtrl.text,
  metricActual: _metricActualCtrl.text,
  ...
)
```

**Выгода:**
- ✅ -40 строк
- ✅ Единственный источник истины
- ✅ Меньше багов при изменениях

---

#### **5. Упрощение навигации между режимами**

**Текущая проблема:** Сложная логика переключения между v1-v4 / weekly / 28-day внутри одного виджета

**Решение:** Router-based подход с глубокими ссылками

```dart
// Вместо переключения внутри одного экрана:
if (hasV4 && dailyStarted) { /* 28-day UI */ }
else if (hasV4) { /* weekly UI */ }
else { /* crystallization UI */ }

// Использовать:
/goal/overview          → GoalOverviewScreen (выбор режима)
/goal/crystallization   → GoalCrystallizationScreen (v1-v4)
/goal/weekly            → GoalWeeklyScreen (4 недели)
/goal/daily             → GoalDaily28Screen (28 дней)
```

**Выгода:**
- ✅ Deep links работают из коробки
- ✅ Можно переходить напрямую через URL
- ✅ История навигации корректна
- ✅ Проще интеграционные тесты

---

## 🟡 GOALS_REPOSITORY.DART (714 строк)

### CodeScene проблемы:

#### **1. Code Duplication (строки 18-48, 47-73)**

**Проблема:** Повторяющийся паттерн кеширования и обработки ошибок

```dart
// fetchLatestGoal (строки 18-45):
try {
  final data = await _client.from('core_goals').select(...);
  if (data != null) await cache.put(cacheKey, data);
  return data;
} on SocketException {
  final cached = cache.get(cacheKey);
  return cached == null ? null : Map<String, dynamic>.from(cached);
} catch (_) {
  final cached = cache.get(cacheKey);
  if (cached != null) return Map<String, dynamic>.from(cached);
  rethrow;
}

// fetchAllGoals (строки 47-73): 
// 🔁 Точно такая же логика!
```

**Решение:** Создать generic метод для кеширования

```dart
// В начале класса:
Future<T?> _cachedQuery<T>({
  required String cacheKey,
  required Future<T?> Function() query,
  required T Function(dynamic) fromCache,
}) async {
  try {
    final data = await query();
    if (data != null) await _goalCache.put(cacheKey, data);
    return data;
  } on SocketException {
    final cached = _goalCache.get(cacheKey);
    return cached == null ? null : fromCache(cached);
  } catch (_) {
    final cached = _goalCache.get(cacheKey);
    if (cached != null) return fromCache(cached);
    rethrow;
  }
}

// Использование:
Future<Map<String, dynamic>?> fetchLatestGoal(String userId) {
  return _cachedQuery<Map<String, dynamic>>(
    cacheKey: 'latest_$userId',
    query: () => _client.from('core_goals')
      .select('...')
      .eq('user_id', userId)
      .maybeSingle(),
    fromCache: (c) => Map<String, dynamic>.from(c),
  );
}
```

**Выгода:**
- ✅ -150 строк (удаление дублирования в 6 методах)
- ✅ Единая обработка ошибок
- ✅ Проще тестировать

---

#### **2. Primitive Obsession + String Heavy Arguments**

**Проблема:** Методы принимают множество примитивных параметров

```dart
// upsertWeek: 16 параметров! (строки 478-526)
Future<Map<String, dynamic>> upsertWeek({
  required int weekNumber,
  Map<String, dynamic>? plannedActions,
  Map<String, dynamic>? completedActions,
  String? completionStatus,
  num? metricValue,
  num? metricProgressPercent,
  String? maxFeedback,
  String? chatSessionId,
  String? achievement,
  String? metricActual,
  bool? usedArtifacts,
  bool? consultedLeo,
  bool? appliedTechniques,
  String? keyInsight,
  String? artifactsDetails,
  String? consultedBenefit,
  String? techniquesDetails,
}) async { ... }
```

**Решение:** Создать value objects / data classes

```dart
// lib/models/weekly_progress_data.dart
@freezed
class WeeklyProgressData with _$WeeklyProgressData {
  const factory WeeklyProgressData({
    required int weekNumber,
    String? achievement,
    String? metricActual,
    bool? usedArtifacts,
    bool? consultedLeo,
    bool? appliedTechniques,
    String? keyInsight,
    WeeklyProgressDetails? details,
  }) = _WeeklyProgressData;
  
  factory WeeklyProgressData.fromJson(Map<String, dynamic> json) =>
    _$WeeklyProgressDataFromJson(json);
}

@freezed
class WeeklyProgressDetails with _$WeeklyProgressDetails {
  const factory WeeklyProgressDetails({
    String? artifactsDetails,
    String? consultedBenefit,
    String? techniquesDetails,
  }) = _WeeklyProgressDetails;
}

// Использование:
Future<Map<String, dynamic>> upsertWeek(WeeklyProgressData data) async {
  final payload = data.toJson();
  return _withRetry(() async {
    final inserted = await _client
      .from('weekly_progress')
      .insert(payload)
      .select()
      .single();
    return Map<String, dynamic>.from(inserted);
  });
}
```

**Выгода:**
- ✅ Сокращение с 16 до 1 параметра
- ✅ Валидация на уровне типов
- ✅ Иммутабельность из коробки
- ✅ Проще рефакторинг при добавлении полей
- ✅ JSON serialization/deserialization автоматом

---

#### **3. Complex Method: upsertDailyProgress (cc=14, строки 251-321)**

**Проблема:** Высокая цикломатическая сложность из-за множественной обработки ошибок

**Текущая структура:**
```dart
Future<Map<String, dynamic>> upsertDailyProgress(...) async {
  final payload = ...;
  try {
    // основной путь
    final upserted = await _client.from('daily_progress')...
    
    // проверка серий
    if (status == 'completed' || status == 'partial') {
      try {
        await checkAndGrantStreakBonus();
      } catch (e) {
        debugPrint('Streak bonus check failed: $e');
      }
    }
    
    return Map<String, dynamic>.from(upserted);
  } on PostgrestException {
    // fallback logic (20 строк)
  } on SocketException {
    // fallback logic (20 строк) - дублирование!
  }
}
```

**Решение:** Разбить на подметоды

```dart
Future<Map<String, dynamic>> upsertDailyProgress({...}) async {
  final payload = _buildDailyProgressPayload(...);
  
  try {
    final result = await _upsertDailyProgressRemote(payload);
    await _checkStreakBonusIfCompleted(status);
    return result;
  } catch (e) {
    return await _upsertDailyProgressLocal(payload);
  }
}

Map<String, dynamic> _buildDailyProgressPayload({...}) {
  return {
    'day_number': dayNumber,
    if (taskText != null) 'task_text': taskText,
    if (status != null) 'completion_status': status,
    if (note != null) 'user_note': note,
    if (date != null) 'date': date.toUtc().toIso8601String(),
  };
}

Future<Map<String, dynamic>> _upsertDailyProgressRemote(
  Map<String, dynamic> payload
) async {
  final upserted = await _client
    .from('daily_progress')
    .upsert(payload, onConflict: 'user_id,day_number')
    .select()
    .single();
  return Map<String, dynamic>.from(upserted);
}

Future<void> _checkStreakBonusIfCompleted(String? status) async {
  if (status == 'completed' || status == 'partial') {
    try {
      await checkAndGrantStreakBonus();
    } catch (e) {
      debugPrint('Streak bonus check failed: $e');
    }
  }
}

Future<Map<String, dynamic>> _upsertDailyProgressLocal(
  Map<String, dynamic> payload
) async {
  final cache = await _openDailyProgressCache();
  final data = _getCachedItems(cache);
  _upsertItemInList(data, payload);
  await cache.put('items', data);
  return payload;
}
```

**Выгода:**
- ✅ Цикломатическая сложность: 14 → 3-4 в каждом методе
- ✅ Легче читать
- ✅ Легче тестировать каждый шаг
- ✅ Можно переиспользовать `_upsertDailyProgressLocal` для других методов

---

#### **4. Bumpy Road Ahead (fetchDailyDay & fetchDailyProgress)**

**Проблема:** Дублирование логики offline-fallback в нескольких местах

**Решение:** Унифицировать через единый метод кеширования (см. рекомендацию №1)

---

## 🟡 GOAL_CHECKPOINT_SCREEN.DART (758 строк)

### Проблемы:
1. **Множество контроллеров:** 14 TextEditingController + флаги
2. **Дублирование логики:** Заполнение контроллеров повторяется для каждой версии

### Рекомендации:

#### **1. Использовать GoalVersionForm вместо inline форм**

**Текущая проблема:** 758 строк большой части занимает GoalVersionForm в inline режиме

**Решение:** Вынести формы в отдельные компоненты с автоматическим управлением состоянием

```dart
// lib/screens/goal/forms/v1_form.dart (150 строк)
class V1GoalForm extends ConsumerWidget {
  final void Function(Map<String, dynamic> data) onSave;
  final Map<String, dynamic>? initialData;
  
  // Управление состоянием внутри формы
}

// lib/screens/goal/forms/v2_form.dart (180 строк)
class V2GoalForm extends ConsumerWidget { ... }

// lib/screens/goal/forms/v3_form.dart (200 строк)
class V3GoalForm extends ConsumerWidget { ... }

// lib/screens/goal/forms/v4_form.dart (180 строк)
class V4GoalForm extends ConsumerWidget { ... }
```

**Использование в GoalCheckpointScreen:**

```dart
// Вместо 600 строк логики:
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('v${widget.version}')),
    body: switch (widget.version) {
      1 => V1GoalForm(
        initialData: _versions[1]?['version_data'],
        onSave: (data) => _saveVersion(1, data),
      ),
      2 => V2GoalForm(...),
      3 => V3GoalForm(...),
      4 => V4GoalForm(...),
      _ => Text('Неизвестная версия'),
    },
  );
}
```

**Выгода:**
- ✅ GoalCheckpointScreen: 758 → 200 строк
- ✅ Каждая форма самодостаточна
- ✅ Можно переиспользовать формы в других местах
- ✅ Проще unit-тесты

---

## 📊 Итоговые рекомендации по приоритетам

### 🔴 ВЫСОКИЙ ПРИОРИТЕТ (делать первым)

1. **goal_screen.dart → разделение на 4 экрана**
   - **Эффект:** 1512 → 300-400 строк каждый
   - **Время:** 4-6 часов
   - **Сложность:** Средняя
   - **Риски:** Низкие (чистый рефакторинг UI)

2. **goals_repository.dart → устранение дублирования кеширования**
   - **Эффект:** 714 → ~550 строк
   - **Время:** 2-3 часа
   - **Сложность:** Низкая
   - **Риски:** Низкие (backend не меняется)

### 🟡 СРЕДНИЙ ПРИОРИТЕТ (делать вторым)

3. **goals_repository.dart → введение value objects для параметров**
   - **Эффект:** Улучшение типобезопасности
   - **Время:** 3-4 часа
   - **Сложность:** Средняя
   - **Риски:** Средние (нужно обновить все вызовы)

4. **goal_checkpoint_screen.dart → формы в отдельные компоненты**
   - **Эффект:** 758 → 200 строк
   - **Время:** 3-4 часа
   - **Сложность:** Низкая
   - **Риски:** Низкие

### 🟢 НИЗКИЙ ПРИОРИТЕТ (опционально)

5. **Создание тестов для новых компонентов**
   - **Время:** 2-3 часа
   - **Покрытие:** 60-70% новых компонентов

6. **Документация архитектурных решений**
   - **Время:** 1-2 часа
   - **Format:** ADR (Architecture Decision Records)

---

## 📈 Ожидаемые метрики после оптимизации

| Метрика | До | После | Изменение |
|---------|-----|-------|-----------|
| **Максимальный размер файла** | 1512 строк | 400 строк | ✅ -73% |
| **Средний размер UI файла** | 760 строк | 300 строк | ✅ -61% |
| **Средний размер репозитория** | 714 строк | 550 строк | ✅ -23% |
| **Цикломатическая сложность (макс)** | 14 | 4-5 | ✅ -64% |
| **Количество параметров (макс)** | 16 | 1-3 | ✅ -81% |
| **Code duplication** | 6 мест | 0 мест | ✅ -100% |
| **Тестируемость** | Сложно | Легко | ✅ +200% |

---

## 🚀 План внедрения

### Фаза 1: Подготовка (1 день)
- [ ] Создать ветку `refactor/goal-optimization`
- [ ] Зафиксировать текущие тесты как baseline
- [ ] Создать чек-лист функциональности для проверки

### Фаза 2: Repository оптимизация (1 день)
- [ ] Реализовать `_cachedQuery` generic метод
- [ ] Создать value objects для WeeklyProgressData, DailyProgressData
- [ ] Разбить complex methods на подметоды
- [ ] Запустить тесты

### Фаза 3: Screen разделение (2 дня)
- [ ] Создать GoalOverviewScreen
- [ ] Переместить crystallization логику в GoalCrystallizationScreen
- [ ] Переместить weekly логику в GoalWeeklyScreen
- [ ] Переместить 28-day логику в GoalDaily28Screen
- [ ] Обновить routing
- [ ] Запустить тесты

### Фаза 4: Checkpoint оптимизация (1 день)
- [ ] Создать V1GoalForm, V2GoalForm, V3GoalForm, V4GoalForm
- [ ] Упростить GoalCheckpointScreen до switch statement
- [ ] Запустить тесты

### Фаза 5: Финализация (0.5 дня)
- [ ] Code review
- [ ] Manual QA тестирование
- [ ] Merge в main

**Общее время:** 5.5 дней (1 неделя с запасом)

---

## ⚠️ Риски и митигации

| Риск | Вероятность | Влияние | Митигация |
|------|-------------|---------|-----------|
| Сломать навигацию | Средняя | Высокое | Тщательное тестирование роутинга, сохранить старый код |
| Забыть мигрировать функционал | Низкая | Высокое | Чек-лист всех фич + e2e тесты |
| Нарушить обратную совместимость | Низкая | Среднее | Feature flags для постепенного роллаута |
| Увеличить количество файлов | Высокая | Низкое | Это норма, улучшает maintainability |

---

## ✅ Критерии успеха

1. ✅ Ни один файл не превышает 500 строк
2. ✅ Максимальная цикломатическая сложность ≤ 7
3. ✅ Максимум 5 параметров на метод
4. ✅ 0 code duplication (по CodeScene)
5. ✅ Все существующие тесты проходят
6. ✅ Manual QA тест-кейсы проходят 100%

---

## 📚 Дополнительные материалы

- [Flutter Best Practices: Code Organization](https://docs.flutter.dev/development/data-and-backend/state-mgmt/intro)
- [Clean Architecture in Flutter](https://resocoder.com/2019/08/27/flutter-tdd-clean-architecture-course-1-explanation-project-structure/)
- [Freezed package documentation](https://pub.dev/packages/freezed)
- [CodeScene: Managing Technical Debt](https://codescene.com/blog/managing-technical-debt)

---

**Автор:** AI Assistant  
**Статус:** Черновик рекомендаций  
**Следующий шаг:** Обсуждение с командой и утверждение плана

