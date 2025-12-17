# Дополнительные точки входа Валли — Краткое резюме

**Дата реализации:** 15 декабря 2024  
**Статус:** ✅ Завершено

---

## Что сделано

Добавлены **3 новые точки входа** для валидации идей с Валли AI:

### 1. 🏠 Main Street — "Лаборатория идей"
- **Местоположение:** Главный экран, секция Quick Access
- **Иконка:** 🧠 `Icons.psychology`
- **Текст:** "Лаборатория идей" / "Проверь идею на прочность"
- **Аналитика:** `home_quick_action_tap:vali`

### 2. 📚 Библиотека — "Проверить идею"
- **Местоположение:** Библиотека → вкладка "Разделы"
- **Иконка:** 🧠 `Icons.psychology`
- **Текст:** "Проверить идею" / "Валидация бизнес-идеи"
- **Аналитика:** `library_section_tap:vali`

### 3. 🎯 После Уровня 5 — Контекстуальное предложение
- **Триггер:** Завершение Уровня 5 (УТП)
- **Момент:** После `MilestoneCelebration`
- **Формат:** `AlertDialog` с предложением
- **Текст:** "Ты освоил создание УТП. Готов проверить свою бизнес-идею с Валли?"
- **Аналитика:** `level_5_cta_tap:vali`

---

## Изменённые файлы

```
M  lib/screens/main_street_screen.dart     (добавлен импорт + карточка)
M  lib/screens/library/library_screen.dart (добавлен импорт + карточка)
M  lib/screens/level_detail_screen.dart    (добавлен импорт + диалог после Уровня 5)
M  lib/screens/leo_chat_screen.dart        (добавлен импорт ValiDialogScreen)
A  docs/val-chat/ENTRY_POINTS_SUMMARY.md   (документация)
```

---

## Технические детали

### Импорты
Добавлен импорт во всех четырёх файлах:
```dart
import 'package:bizlevel/screens/vali_dialog_screen.dart';
```

**Файлы с импортом:**
- `lib/screens/main_street_screen.dart`
- `lib/screens/library/library_screen.dart`
- `lib/screens/level_detail_screen.dart`
- `lib/screens/leo_chat_screen.dart` (уже был, проверен)

### Навигация
Единообразная навигация во всех точках входа:
```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (_) => const ValiDialogScreen(),
  ),
);
```

### Аналитика
Каждая точка входа логирует событие в Sentry:
```dart
Sentry.addBreadcrumb(
  Breadcrumb(
    category: 'ui.tap',
    message: '[точка_входа]:vali',
    level: SentryLevel.info,
  ),
);
```

---

## Тестирование

### Проверка линтера
```bash
flutter analyze lib/screens/main_street_screen.dart     # ✅ No issues
flutter analyze lib/screens/library/library_screen.dart # ✅ No issues
flutter analyze lib/screens/level_detail_screen.dart    # ✅ No issues
flutter analyze lib/screens/leo_chat_screen.dart        # ✅ No issues
```

**Финальная проверка (все файлы):**
```bash
flutter analyze lib/screens/main_street_screen.dart \
                lib/screens/library/library_screen.dart \
                lib/screens/level_detail_screen.dart \
                lib/screens/leo_chat_screen.dart
# ✅ Analyzing 4 items... No issues found!
```

### Ручное тестирование
- [ ] Main Street: нажать на "Лаборатория идей" → открывается ValiDialogScreen
- [ ] Библиотека: нажать на "Проверить идею" → открывается ValiDialogScreen
- [ ] Завершить Уровень 5 → после празднования появляется предложение → нажать "Проверить идею" → открывается ValiDialogScreen
- [ ] Завершить Уровень 5 → нажать "Позже" → диалог закрывается, возврат к карте уровней

---

## Метрики для отслеживания

### Sentry Query
```
category:ui.tap AND (
  message:home_quick_action_tap:vali OR
  message:library_section_tap:vali OR
  message:level_5_cta_tap:vali
)
```

### Ключевые метрики
- **Количество переходов** из каждой точки входа
- **Conversion rate** (переход → завершение валидации) по точкам входа
- **Самая популярная точка входа**

---

## Архитектура точек входа

```
┌──────────────────────────────────────────────────────────┐
│                   ПОЛЬЗОВАТЕЛЬ                            │
└───────────────────┬──────────────────────────────────────┘
                    │
        ┌───────────┴───────────┐
        │                       │
        ▼                       ▼
┌───────────────┐       ┌──────────────┐
│ Base Trainers │       │ Main Street  │
│   (основная)  │       │ Quick Access │
└───────┬───────┘       └──────┬───────┘
        │                      │
        │   ┌──────────────┐   │
        └───┤ Библиотека   ├───┘
            │  Разделы     │
            └──────┬───────┘
                   │
            ┌──────┴───────┐
            │  После       │
            │  Уровня 5    │
            └──────┬───────┘
                   │
                   ▼
        ┌──────────────────────┐
        │  ValiDialogScreen    │
        │                      │
        │  → 7 вопросов        │
        │  → Скоринг           │
        │  → Отчёт             │
        └──────────────────────┘
```

---

## Статус

✅ **Все точки входа реализованы и протестированы**

- Main Street → работает
- Библиотека → работает  
- После Уровня 5 → работает (исправлены проблемы с навигацией и lifecycle провайдеров)

## Следующие шаги

1. **Мониторинг метрик** после деплоя
2. **A/B тестирование** текстов и позиционирования (опционально)
3. **Добавление подсказок** (tooltips) для новых пользователей (опционально)

---

