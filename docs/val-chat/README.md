# Валли — AI-валидатор идей

## 🎉 MVP ЗАВЕРШЁН (15.12.2024)

**Статус:** ✅ Готов к тестированию и деплою

✅ **Backend готов** — БД, Edge Function, GP-экономика  
✅ **Frontend готов** — ValiService, ValiDialogScreen, интеграция  
✅ **Документация готова** — 6 файлов, ~2500 строк  
🧪 **Готов к тестированию** — функциональному, UX, интеграционному

## Что уже работает

### 1. База данных ✅
- Таблица `idea_validations` — хранит метаданные валидаций
- Constraint `leo_chats.bot` поддерживает значение `'vali'`
- RLS политики и индексы настроены

### 2. Edge Function ✅
- **URL:** `https://acevqbdpzgbtqznbpgzr.supabase.co/functions/v1/val-chat`
- **Режимы:** 
  - `dialog` — ведение диалога (7 вопросов / 7 шагов с контролем качества ответов)
  - `score` — скоринг и генерация отчёта
- **GP-экономика:** первая валидация бесплатно, повторные — 20 GP
- **Аутентификация:** JWT через заголовок `x-user-jwt`

#### 2.1 Контроль качества ответов (двухпроходная валидация)

- Каждый шаг диалога продвигается **только если** ответ пользователя достаточно развернутый и релевантный
- Edge Function использует **двухпроходную логику**:
  - 1) генерация ответа Валли
  - 2) отдельный валидатор, который решает, считать ли ответ достаточным
- При слабом ответе Валли:
  - мягко объясняет, что не так,
  - даёт 2–3 уточняющих пункта,
  - показывает мини‑шаблон ответа,
  - **повторяет тот же вопрос**, не переходя к следующему шагу

### 3. ValiService (Dart) ✅
- **Файл:** `lib/services/vali_service.dart`
- **Документация:** `docs/val-chat/vali-service-usage.md`
- **Примеры:** `lib/services/vali_service_example.dart`

**Методы:**
- `sendMessage()` — диалог
- `scoreValidation()` — скоринг
- `createValidation()` — создание
- `getValidation()` — получение
- `saveValidationResults()` — сохранение результатов
- `updateValidationProgress()` — обновление шага
- `getUserValidations()` — список валидаций
- `isFirstValidation()` — проверка первой валидации
- `abandonValidation()` — пометка как заброшенной
- `saveConversation()` — сохранение сообщений

### 4. ValiDialogScreen ✅
- **Файл:** `lib/screens/vali_dialog_screen.dart`
- **Provider:** `lib/providers/vali_service_provider.dart`
- **Документация:** `docs/val-chat/vali-dialog-screen-usage.md`
- **Примеры:** `lib/screens/vali_dialog_screen_example.dart`

**Возможности:**
- Диалог с Валли (7 вопросов)
- Прогресс-бар (1/7, 2/7, ..., 7/7)
- Скоринг после завершения
- Отображение отчёта с markdown
- CTA кнопки (уровни, Макс, новая валидация)
- Обработка 402 ошибки (недостаточно GP)

### 5. Интеграция в Base Trainers ✅
- **Файл:** `lib/screens/leo_chat_screen.dart`
- **Изменения:**
  - Добавлена карточка Валли (3-я карточка)
  - Layout изменён с Row на Column
  - Навигация к ValiDialogScreen
  - Поддержка в истории чатов (`bot='vali'`)

## Архитектура

```
┌─────────────────────────────────────┐
│      Flutter App (Mobile)           │
├─────────────────────────────────────┤
│  ValiService (lib/services/)        │
│  ↓                                   │
│  Dio HTTP Client                    │
└──────────────┬──────────────────────┘
               ↓
┌──────────────▼──────────────────────┐
│  Edge Function: val-chat            │
│  (supabase/functions/val-chat/)     │
├─────────────────────────────────────┤
│  • Диалог: 7 вопросов/шагов        │
│    с контролем качества ответов     │
│  • Скоринг: 5 критериев (0-20)     │
│  • Генерация отчёта (markdown)      │
│  • GP-экономика (20 GP)            │
└──────────────┬──────────────────────┘
               ↓
┌──────────────▼──────────────────────┐
│  Supabase PostgreSQL                │
├─────────────────────────────────────┤
│  • idea_validations                 │
│  • leo_chats (bot='vali')           │
│  • leo_messages                     │
└─────────────────────────────────────┘
```

## Быстрый старт

### 1. Создание валидации

```dart
import 'package:bizlevel/services/vali_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final valiService = ValiService(Supabase.instance.client);

// Создать новую валидацию
final validationId = await valiService.createValidation(
  ideaSummary: 'Приложение для доставки еды',
);
```

### 2. Открыть диалог с Валли

```dart
import 'package:bizlevel/screens/vali_dialog_screen.dart';

// Новая валидация
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const ValiDialogScreen(),
  ),
);

// Или через GoRouter
context.push('/chat/vali');

// Продолжить существующую
context.push('/chat/vali?validationId=$validationId');
```

### 2a. Отправить сообщение (низкоуровневый API)

```dart
// Отправить сообщение
final response = await valiService.sendMessage(
  messages: [
    {'role': 'user', 'content': 'Хочу создать...'},
  ],
  validationId: validationId,
);

// Получить ответ
final answer = response['message']['content'];
print('Валли: $answer');
```

### 3. Скоринг

```dart
// После 7 вопросов запросить скоринг
final result = await valiService.scoreValidation(
  messages: allMessages,
  validationId: validationId,
);

// Получить отчёт
final report = result['report'];
final totalScore = result['scores']['total'];
print('Балл: $totalScore/100');
print(report);
```

### 4. Обработка ошибок

```dart
try {
  await valiService.sendMessage(...);
} on ValiFailure catch (e) {
  if (e.statusCode == 402) {
    // Недостаточно GP
    showGpTopUpDialog(e.data?['required'] ?? ValiService.kValidationCostGp);
  } else if (e.statusCode == 401) {
    // Требуется авторизация
    Navigator.pushReplacement(context, LoginScreen());
  } else {
    // Общая ошибка
    showErrorSnackbar(e.message);
  }
}
```

## GP-экономика

| Действие | Стоимость | Примечание |
|----------|-----------|------------|
| Первая валидация | **0 GP** | Бесплатно для онбординга |
| Повторные валидации | **20 GP** | За каждую новую сессию |
| Просмотр истории | **0 GP** | Всегда бесплатно |

Списание происходит автоматически при вызове `sendMessage()` в режиме `dialog`.

## Документация

| Файл | Описание |
|------|----------|
| `val-plan.md` | Полный план реализации с деталями |
| `vali-service-usage.md` | Подробное руководство по ValiService |
| `vali-dialog-screen-usage.md` | Подробное руководство по ValiDialogScreen |
| `vali_service_example.dart` | Примеры кода для ValiService |
| `vali_dialog_screen_example.dart` | Примеры навигации к ValiDialogScreen |
| `concept_valli.md` | Концепт и системные промпты |

## Следующие шаги

### ✅ Готово (MVP завершён):
- ✅ **Backend** — Edge Function, БД, GP-экономика
- ✅ **ValiService** — Dart-сервис для API
- ✅ **ValiDialogScreen** — UI экран диалога и отчёта
- ✅ **Интеграция в Base Trainers** — карточка Валли
- ✅ **Интеграция с Максом** — CTA кнопка после отчёта (переход в Max без передачи данных Валли)
- ✅ **Интеграция с уровнями** — кнопка перехода к рекомендованным урокам
- ✅ **История чатов** — поддержка `bot='vali'` в leo_chat_screen

### 🎯 Готово к тестированию:
MVP Валли полностью функционален и готов к:
- Функциональному тестированию
- UX тестированию
- Интеграционному тестированию
- Beta-тестированию с реальными пользователями

### 📋 Запланированные улучшения (после тестирования):
- ⏳ **GoRouter интеграция** — deep links для валидаций
- ⏳ **ValiHistoryScreen** — отдельный экран истории валидаций
- ⏳ **Уникальный аватар Валли** (сейчас используется копия Лео)
- ⏳ **Подсказки (chips)** — рекомендованные вопросы в диалоге
- ⏳ **Аналитика** — трекинг метрик валидаций
- ⏳ **Шаринг отчётов** — возможность поделиться результатами

## Тестирование

### Функциональное тестирование Edge Function:

```bash
# Через curl (с JWT)
curl -X POST https://acevqbdpzgbtqznbpgzr.supabase.co/functions/v1/val-chat \
  -H "Content-Type: application/json" \
  -H "x-user-jwt: YOUR_JWT_TOKEN" \
  -d '{
    "messages": [{"role": "user", "content": "Хочу создать стартап"}],
    "mode": "dialog"
  }'
```

### Unit-тесты ValiService:

```bash
# Запуск тестов
flutter test test/services/vali_service_test.dart
```

## Миграции БД

### Применить миграции:

```bash
# Из корня проекта
supabase db push

# Или через SQL Editor в Supabase Dashboard:
# 1. supabase/migrations/20251215_create_idea_validations.sql
# 2. supabase/migrations/20251215_add_vali_bot_to_leo_chats.sql
```

## Troubleshooting

### Ошибка 401 (Unauthorized)
**Причина:** Невалидный или истёкший JWT токен  
**Решение:** ValiService автоматически пытается обновить сессию

### Ошибка 402 (Payment Required)
**Причина:** Недостаточно GP (нужно 20 GP)  
**Решение:** Показать диалог пополнения баланса

### Ошибка 500 (Internal Server Error)
**Причина:** Проблема на стороне Edge Function или xAI API  
**Решение:** Проверить логи в Supabase Dashboard → Edge Functions → val-chat

### Timeout
**Причина:** Медленный ответ от xAI (Grok API)  
**Решение:** ValiService автоматически делает retry (до 2 попыток)

## Контакты

- **Проект:** BizLevel
- **Репозиторий:** `/home/nail/Documents/Projects/BizLevel/blvl-app-main`
- **Дата создания:** 15.12.2024

---

**Версия:** 1.0  
**Статус:** Backend готов, Frontend в процессе
