# АУДИТ ТЕКУЩЕГО СОСТОЯНИЯ СИСТЕМЫ BIZLEVEL

Дата: 2025-10-02
Аналитик: Cursor AI

---

## EXECUTIVE SUMMARY

В рамках Этапа 1 проведён полный аудит компонента «Макс» (бот‑трекер цели): файловая структура, UI‑компоненты, логика и бизнес‑правила, состояние (state management), backend/API и связанные таблицы Supabase. Выявлены все места присутствия «Макса» в клиенте (экраны/виджеты/навигация), а также серверная логика Edge Function `leo-chat` для режима `bot='max'`.

Найдено: 10+ клиентских файлов с прямыми упоминаниями «Макса», 1 Edge Function (`supabase/functions/leo-chat/index.ts`), 2 миграции, расширяющие поддержку «max» в `leo_chats` (в т.ч. переименование `alex`→`max`). Чат «Макса» использует ту же клиентскую оболочку, что и «Лео» (`LeoDialogScreen`), но с отличающимися системными промптами на сервере и отключённым RAG.

Общая картина: «Макс» встроен в «Цель» (страница и чекпоинты v2/v3/v4), доступен как отдельный бот в «Базе тренеров», использует экономику GP (списание 1 GP за пользовательские сообщения; для авто‑сообщений и embedded‑режимов предусмотрены случаи без списаний), хранит чаты в `leo_chats/leo_messages`, ведёт метрики запроса в `ai_message`.

---

## 1. КОМПОНЕНТ "МАКС"

### 1.1. Файловая структура

| Путь | Примерный размер (строк) | Назначение |
|------|---------------------------|------------|
| `lib/screens/leo_chat_screen.dart` | ~260 | Экран «База тренеров»: переключение ботов (Leo/Max), список чатов, запуск диалога |
| `lib/screens/leo_dialog_screen.dart` | ~690 | Универсальный экран диалога (используется для Leo/Max/case/embedded), логика отправки/пагинации |
| `lib/widgets/floating_chat_bubble.dart` | ~150 | Плавающий баббл чата; может открывать диалог с `bot='max'` |
| `lib/screens/goal_screen.dart` | ~930 | Страница «Цель»: кнопки/баббл «Обсудить с Максом», автозапуск реакции после чек‑ина |
| `lib/screens/goal_checkpoint_screen.dart` | ~760 | Экран чекпоинта v2/v3/v4: embedded‑чат `bot='max'` рядом с формой версии |
| `lib/screens/goal/widgets/motivation_card.dart` | ~220 | Карточка «Мотивация от Макса» (цитата дня, аватар Макса) |
| `lib/services/leo_service.dart` | ~580 | Клиент Edge Function `leo-chat` (отправка сообщений, списание GP, режимы bot/max/quiz) |
| `lib/providers/leo_service_provider.dart` | ~10 | DI‑провайдер `LeoService` |
| `supabase/functions/leo-chat/index.ts` | ~1390 | Edge Function: боты Leo/Max, режимы default/quiz/case, сохранение сообщений, RAG (только для Leo) |
| `supabase/migrations/20250813_29_1_add_leo_chats_bot.sql` | ~40 | Добавляет колонку `bot` в `leo_chats`, индекс, CHECK ('leo','alex') |
| `supabase/migrations/20250815_30_3_rename_alex_to_max.sql` | ~26 | Переименование значений `'alex'` → `'max'`, обновление CHECK ('leo','max') |
| (связанные) `supabase/migrations/20250811_add_leo_memory_trigger.sql` | ~158 | Триггеры/функции памяти для `leo_messages` (общие для ботов) |

Примечание: LOC указаны по текущим версиям файлов в репозитории, оценочно.

### 1.2. UI компоненты

- Экраны и разделы, где появляется «Макс»:
  - `LeoChatScreen` — экран «База тренеров»: две карточки ботов (Leo/Max), переключение `_activeBot` и список чатов по выбранному боту.
  - `LeoDialogScreen` — универсальный экран диалога. Для `bot='max'` рендерит AppBar с аватаром Макса и подписью «Макс».
  - `GoalScreen` —
    - плавающий `FloatingChatBubble(bot='max')` с контекстом версии/уровня;
    - кнопки/обработчики, открывающие полноэкранный чат Макса после сохранения чек‑ина недели (опционально с авто‑сообщением без списаний).
  - `GoalCheckpointScreen` — embedded‑чат Макса по правой части над формой версии; кнопки «Сохранить» запускают комментарий Макса (авто‑сообщение).
  - `MotivationCard` — «Мотивация от Макса» (цитата дня, аватар Макса) вверху страницы «Цель».
- Кнопки/триггеры вызова Макса:
  - FAB/баббл на GoalScreen: `FloatingChatBubble(bot='max')`.
  - Кнопки «Обсудить с Максом» и автозапуск после сохранения чек‑ина (`_openChatWithMax()`), а также embedded‑чат в чекпоинте.
- Навигация:
  - Маршрут `/chat` (GoRouter) открывает `LeoChatScreen` (там выбор между Leo/Max).
  - Внутренние push (`MaterialPageRoute`) на `LeoDialogScreen(bot='max')` из GoalScreen/GoalCheckpointScreen.

### 1.3. Логика и бизнес‑правила

- Инициализация Макса (greeting): при создании нового диалога без `chatId` для `bot='max'` в `LeoDialogScreen.initState` добавляется приветствие Макса в ленту.
- Сценарии/промпты:
  - Клиент передаёт `userContext` и `levelContext`; для case‑режима — `systemPrompt/firstPrompt`.
  - Сервер (Edge) формирует Max‑специфический системный промпт (короткий, фокус на целях/спринтах/локальном контексте, без RAG). Для Leo — другой промпт с RAG.
- Обработка сообщений:
  - На клиенте `_sendMessageInternal` добавляет сообщение пользователя, опционально создаёт/обновляет `leo_chats/leo_messages`, вызывает `LeoService.sendMessageWithRAG` с `bot='max'` и добавляет ответ ассистента.
  - Для embedded/авто‑сообщений предусмотрен `skipSpend` (без списания GP).
- Генерация ответов:
  - Edge `leo-chat` при `bot='max'` отключает RAG, подтягивает краткие блоки целей/спринтов/напоминаний/цитаты, применяет правила формата (без таблиц/эмодзи), может возвращать `recommended_chips`.
- Условия появления:
  - «Макс» доступен в «Базе тренеров» и на «Цели» (в том числе чекпоинты v2/v3/v4). Визуально маркируется аватаром Макса.

### 1.4. State Management

- Riverpod провайдеры:
  - `leo_service_provider.dart`: `Provider<LeoService>` — DI сервиса чатов.
  - На «Цели»: `goalScreenControllerProvider`, `goalVersionsProvider`, `sprintProvider`, `dailyQuoteProvider` и др. обеспечивают контекст для чата Макса.
- Локальное состояние экрана диалога:
  - В `LeoDialogScreen` — список сообщений `_messages`, флаги `_isSending/_hasMore`, пагинация по 30.
- Хранение истории:
  - Сервер/клиент вставляют в `leo_chats` (чат) и `leo_messages` (сообщения). Клиентский список на `LeoChatScreen` загружается из `leo_chats` по `bot` и `message_count>0`.

### 1.5. Backend и API

- Endpoint: `POST /functions/v1/leo-chat` (Edge Function).
- Параметры запроса (основные): `messages[]`, `userContext`, `levelContext`, `bot ('leo'|'max')`, `chatId?`, `skipSpend?`, `caseMode?`, а также режимы `mode='quiz'|...'`.
- Поведение на сервере для `bot='max'`:
  - `isMax=true`: RAG не выполняется, формируется трекер‑промпт, ответы санитизируются (без таблиц/эмодзи), возможны `recommended_chips` по версии цели.
  - Сохранение: при наличии `userId` создаёт/обновляет `leo_chats` и вставляет сообщения в `leo_messages`.
  - Учёт токенов/стоимости: вставка в `ai_message`.
- Интеграции AI: OpenAI Chat Completions (`gpt-4.1-mini` по умолчанию), управление max_tokens/temperature и безопасные breadcrumbs в лог.

### 1.6. База данных Supabase (связанные с Максом)

- `leo_chats` (чаты ботов)
  - Колонки (факт в Supabase): `id uuid PK default gen_random_uuid()`, `user_id uuid`, `title text`, `message_count int default 0`, `created_at timestamptz default now()`, `updated_at timestamptz default now()`, `unread_count int default 0`, `summary text?`, `last_topics jsonb default '[]'`, `bot text default 'leo'` CHECK in ('leo','max'). RLS включён. Политики: insert/update/select только свои записи.
- `leo_messages` (сообщения)
  - Колонки (факт): `id uuid PK default gen_random_uuid()`, `chat_id uuid`, `user_id uuid`, `role text`, `content text`, `token_count int default 0`, `created_at timestamptz default now()`. RLS включён. Политики: пользователи видят/вставляют свои; service role может читать все.
- `ai_message` (метрики)
  - Колонки (факт): `id uuid PK default gen_random_uuid()`, `leo_message_id uuid?`, `user_id uuid`, `chat_id uuid`, `model_used text default 'gpt-4.1-mini'`, `input_tokens int`, `output_tokens int`, `total_tokens int`, `cost_usd numeric`, `bot_type text`, `request_type text default 'chat'`, `created_at timestamptz default now()`. RLS включён. Политики: insert/view только свои.

#### 1.6.1. RLS/Политики (факт)
- `leo_chats`: select/update/insert только при `user_id = auth.uid()`.
- `leo_messages`: select/insert только свои; отдельная политика на чтение всем service role.
- `ai_message`: select/insert только свои (`user_id = auth.uid()`).

### 1.7. Структура таблиц (SQL, по фактическому использованию)

```sql
-- public.leo_chats (инференс по коду и миграциям)
create table if not exists public.leo_chats (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null default '',
  message_count int not null default 0,
  updated_at timestamptz not null default now(),
  bot text not null default 'leo',
  constraint leo_chats_bot_chk check (bot in ('leo','max'))
);
create index if not exists idx_leo_chats_user_bot_updated
  on public.leo_chats(user_id, bot, updated_at desc);

-- public.leo_messages (инференс по коду/триггерам)
create table if not exists public.leo_messages (
  id uuid primary key default gen_random_uuid(),
  chat_id uuid not null references public.leo_chats(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  role text not null,
  content text not null,
  created_at timestamptz not null default now()
);

-- public.ai_message (инференс по коду сохранения метрик)
create table if not exists public.ai_message (
  leo_message_id uuid,
  chat_id uuid,
  user_id uuid,
  model_used text,
  input_tokens int,
  output_tokens int,
  total_tokens int,
  cost_usd numeric,
  bot_type text,
  request_type text,
  created_at timestamptz not null default now()
);
```

(Примечание: точные DDL для `leo_chats/leo_messages/ai_message` могут отличаться в деталях; здесь приведена реконструкция по использованию в коде и миграциям. Полные DDL см. в разделе 7 при сборе всех таблиц проекта.)

### 1.8. Ключевые участки кода

- Выбор бота и запуск чата (экран «База тренеров»):
```dart
// lib/screens/leo_chat_screen.dart
// ...
String _activeBot = 'leo'; // 'leo' | 'max'
// ... запуск нового диалога с контекстом
return LeoDialogScreen(
  userContext: userCtx,
  levelContext: lvlCtx,
  bot: _activeBot,
);
```

- Приветствие Макса и отправка сообщений:
```dart
// lib/screens/leo_dialog_screen.dart
// greeting для bot == 'max' при новом диалоге
if (widget.bot == 'max' && _chatId == null && _messages.isEmpty) {
  final String greeting = (widget.firstPrompt?.trim().isNotEmpty == true)
      ? widget.firstPrompt!.trim()
      : 'Я — Макс, трекер цели BizLevel. Помогаю кристаллизовать цель и держать темп 28 дней. Напишите, чего хотите добиться — предложу ближайший шаг.';
  _messages.add({'role': 'assistant', 'content': greeting});
}
// отправка на Edge Function с bot='max'
final response = await _leo.sendMessageWithRAG(
  messages: _buildChatContext(),
  userContext: cleanUserContext,
  levelContext: cleanLevelContext,
  bot: widget.bot,
  skipSpend: widget.skipSpend,
  caseMode: widget.caseMode,
);
```

- Встраивание Макса в «Цель» и чекпоинты:
```dart
// lib/screens/goal_screen.dart (плавающий баббл)
FloatingChatBubble(
  chatId: null,
  systemPrompt: 'Режим трекера цели: обсуждаем версию v... и прогресс спринтов. Будь краток, поддерживай фокус, предлагай следующий шаг.',
  userContext: _buildTrackerUserContext(...),
  levelContext: 'current_level: $currentLevel',
  bot: 'max',
)
```

- Серверная логика для `bot='max'` (RAG off, спец‑промпт):
```ts
// supabase/functions/leo-chat/index.ts
let bot = typeof body?.bot === 'string' ? String(body.bot) : 'leo';
if (bot === 'alex') bot = 'max';
const isMax = bot === 'max';
// RAG выполняется только для Leo
const shouldDoRAG = !isMax && !caseMode && typeof lastUserMessage === 'string' && lastUserMessage.trim().length > 0;
// Системный промпт Макса (tracker): systemPromptAlex ...
// Сохранение сообщений в leo_chats/leo_messages и метрик в ai_message
```

---

## 2. КОМПОНЕНТ "ЦЕЛЬ"

### 2.1. Файловая структура
- `lib/screens/goal_screen.dart`: основной экран «Цель» (обзор версий, прогресс, таймлайн недель, баббл Макса).
- `lib/screens/goal_checkpoint_screen.dart`: чекпоинт версии v2/v3/v4 (форма + embedded‑чат Макса).
- `lib/screens/goal/widgets/goal_compact_card.dart`: компактная карточка цели (свёрнуто/развёрнуто, «История»).
- `lib/screens/goal/widgets/crystallization_section.dart`: секция «Кристаллизация цели» (переключение v1–v4, история).
- `lib/screens/goal/widgets/progress_widget.dart`: визуальный прогресс/мини‑дашборд цели.
- `lib/screens/goal/widgets/weeks_timeline_row.dart`: горизонтальный таймлайн недель 1–4.
- `lib/screens/goal/widgets/checkin_form.dart`: форма чек‑ина недели (упрощённый набор полей).
- `lib/screens/goal/widgets/sprint_section.dart`: секция «Путь к цели» (таймлайн + чек‑ин + CTA открыть чат Макса).
- `lib/widgets/goal_version_form.dart`: единая форма версий v1–v4 (контроллеры/валидации извне).
- `lib/screens/goal/widgets/motivation_card.dart`: «Мотивация от Макса» (цитата дня).
- `lib/screens/goal/controller/goal_screen_controller.dart`: стейт/селекторы/хелперы экрана «Цель».
- `lib/providers/goals_providers.dart`: провайдеры Goal/Weekly/Quotes/Progress.
- `lib/repositories/goals_repository.dart`: доступ к `core_goals`, `weekly_progress`, `reminder_checks`, RPC.

### 2.2. Архитектура и навигация
- Маршрут `/goal` (GoRouter) открывает `GoalScreen`.
- Чекпоинты v2/v3/v4 открываются с `/goal-checkpoint/:version`.
- На «Цели» доступен плавающий баббл чата Макса (полноэкранный диалог). На чекпоинте — embedded‑чат Макса.

### 2.3. UI/UX потоки
- Обзор цели: «Мотивация» → «Моя цель» (компакт) → «Кристаллизация цели» (переключатель v1–v4) → «Прогресс» → «Путь к цели» (после v4).
- Чекпоинт v2/v3/v4: сверху embedded‑чат Макса, ниже форма `GoalVersionForm`, кнопка «Сохранить».
- После сохранения версии — возврат в «Башню» (скролл к следующему узлу). После чек‑ина — опциональный авто‑открытие чата Макса.

### 2.4. Структура данных
```dart
// lib/models/core_goal_model.dart (Freezed)
class CoreGoalModel { String id; String userId; int version; String? goalText; Map<String, dynamic>? versionData; DateTime? createdAt; DateTime? updatedAt; }
// lib/models/weekly_progress_model.dart (Freezed)
class WeeklyProgressModel { String id; String userId; int sprintNumber; String? achievement; String? metricActual; bool? usedArtifacts; bool? consultedLeo; bool? appliedTechniques; String? keyInsight; DateTime? createdAt; }
```
- Валидации (клиент):
  - v1: три поля длиной ≥10 (см. `GoalScreen._isValidV1`/`GoalCheckpointScreen._isValid` для v1).
  - v2: `concrete_result` (строка), `metric_type` (строка), `metric_current/metric_target` (числа), `financial_goal` (число).
  - v3: `goal_smart` (строка), `week1..4_focus` (строки, ≥5 символов).
  - v4: `first_three_days/final_what` (строка), `start_date/final_when` (дата‑строка), `accountability_person/final_how` (строка), `readiness_score` (1–10) или `commitment`.

### 2.5. Логика работы с целями
- Создание/обновление версий:
  - Через `GoalsRepository.upsertGoalVersion` (RPC `upsert_goal_version`), либо fallback `upsert core_goals` (user_id из сессии/триггером).
  - Обновление версии по `id`: `GoalsRepository.updateGoalById` (guard триггером — редактируется только последняя версия).
- Чек‑ины недель: `GoalsRepository.upsertWeek/updateWeek` (таблица `weekly_progress`). В UI — `SprintSection` + `checkin_form`.
- Удаление цели: в коде клиента не предусмотрено.
- Расчёт прогресса: на экране и в `GoalScreenController` (проценты 25/50/75/100 по наличию v1..v4; недельный прогресс — по данным v2/v4/weekly).

### 2.6. Чекпоинты
- Понятие: специальные узлы «Башни» после уровней 4/7/10 соответствуют v2/v3/v4.
- Данные: версии хранятся в `core_goals (version, goal_text, version_data)`. Прогресс полей (в упрощённом режиме) может использоваться через `goal_checkpoint_progress` для компоновки (см. `GoalsRepository.fetchGoalProgress`).
- Создание/выполнение: при сохранении версии — запись в `core_goals` (через RPC/Upsert), чекпоинт считается выполненным по наличию версии.
- Связь с целью: 1 пользователь → 1..4 версий (`unique (user_id, version)`).
- Влияние на обучение: навигация «Что дальше» ориентирует к ближайшему незавершённому чекпоинту; уровни в башне могут ожидать завершения соответствующего чекпоинта согласно провайдерам узлов.

### 2.7. State Management (Goal)
- Провайдеры: `goalLatestProvider`, `goalVersionsProvider`, `sprintProvider`, `remindersStreamProvider`, `dailyQuoteProvider`, `hasGoalVersionProvider(version)`, `goalProgressProvider(version)`, `metricLabelProvider`, `usedToolsOptionsProvider`.
- Контроллер: `GoalScreenController` — загрузка версий, выбор версии/спринта, вычисления (progress%, currentWeekNumber, labels) и сбор контекста для чата Макса.
- Источники данных: `GoalsRepository`, Supabase RPC/таблицы, Hive SWR‑кеш.

### 2.8. База данных

- `core_goals` (факт): `id uuid PK default gen_random_uuid()`, `user_id uuid`, `version int CHECK 1..4`, `goal_text text?`, `version_data jsonb?`, `created_at timestamptz default now()`, `updated_at timestamptz default now()`.
- `weekly_progress` (факт):
  - Ключевые: `id uuid PK`, `user_id uuid`, `week_number int CHECK 1..4`, `achievement text?`, `metric_actual text?`,
  - Флаги/детали: `used_artifacts bool?`, `consulted_leo bool?`, `applied_techniques bool?`, `key_insight text?`, `artifacts_details text?`, `consulted_benefit text?`, `techniques_details text?`,
  - Трекер: `planned_actions jsonb?`, `completed_actions jsonb?`, `completion_status text? in ('full','partial','failed')`, `metric_value numeric?`, `metric_progress_percent numeric?`, `mood_tracking jsonb?`, `mood_average numeric?`, `max_feedback text?`, `chat_session_id uuid?`,
  - Служебные: `created_at timestamptz default now()`, `updated_at timestamptz default now()`.
- `reminder_checks` (факт): `id uuid PK`, `user_id uuid`, `day_number int CHECK 1..28`, `reminder_text text?`, `is_completed bool default false`, `completed_at timestamptz?`, `created_at timestamptz default now()`.
- `motivational_quotes` (факт): `id uuid PK`, `quote_text text`, `author text?`, `category text?`, `is_active bool default true`, `created_at timestamptz default now()`.
- `goal_checkpoint_progress` (факт, используется прогрессом чекпоинтов): PK(`user_id`,`version`,`field_name`), поля: `user_id uuid`, `version int 1..4`, `field_name text(1..64)`, `completed_at timestamptz default now()`, `max_interaction_id uuid?`.

#### 2.8.1. RLS/Политики (факт)
- `core_goals`: owner-only на select/* (`user_id = auth.uid()`).
- `weekly_progress`: owner-only на select/* (`user_id = auth.uid()`).
- `reminder_checks`: owner-only на select/* (`user_id = auth.uid()`).
- `motivational_quotes`: select открыт для anon и authenticated (policy `motivational_quotes_read_all`).
- `goal_checkpoint_progress`: owner-only на select/insert/update/delete.

#### 2.8.2. RPC (факт)
- Имеются функции: `fetch_goal_state(record)`, `upsert_goal_field(jsonb)`, `upsert_goal_version(record)`, `update_current_level(void)`.

### 2.9. Ключевые участки кода
```663:676:lib/screens/goal_screen.dart
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingChatBubble(
            chatId: null,
            systemPrompt:
                'Режим трекера цели: обсуждаем версию v${ref.watch(goalScreenControllerProvider).selectedVersion} и прогресс спринтов. Будь краток, поддерживай фокус, предлагай следующий шаг.',
            userContext: _buildTrackerUserContext(
              ref.watch(goalScreenControllerProvider).versions,
              ref.watch(goalScreenControllerProvider).selectedVersion,
            ),
            levelContext: 'current_level: $currentLevel',
            bot: 'max',
          ),
        ),
```

---

## 3. СИСТЕМА УРОВНЕЙ И АРТЕФАКТОВ

### 3.1. Уровни обучения
- Файлы:
  - `lib/screens/biz_tower_screen.dart` (+ `tower_*.dart`): башня (вертикальная карта).
  - `lib/screens/level_detail_screen.dart`: экран уровня (Intro → видео → квиз → финал/артефакт; для L0 профиль; для L1 — v1 «Набросок цели»).
  - `lib/providers/levels_provider.dart`: список уровней с прогрессом/гейтингом и «куда продолжить». 
  - `lib/repositories/levels_repository.dart`, `lib/repositories/lessons_repository.dart`: данные уровней/уроков.
- Количество уровней: 0 и 1..10 (этаж 1). Нумерация: числовая; дополнительно отображаемый `displayCode`.
- Контент уроков: загружается через `LessonsRepository.fetchLessons` (SupabaseService.fetchLessonsRaw), видео по подписанным URL.

### 3.2. Прогресс по уровням
- Текущий уровень пользователя определяется по `users.current_level` (нормализуется до номера) и/или факту завершений в `user_progress`.
- Условия разблокировки: предыдущий узел завершён; для уровней >3 — доступ этажа через `floor_access` (GP). Локально в `levelsProvider` применяется правило `previousCompleted & hasAccess`.
- Хранение прогресса в БД: `user_progress (user_id, level_id, is_completed)`; доступ этажей: `floor_access (user_id, floor_number)`.
- Возврат к пройденным уровням: возможен (узлы уровней остаются доступны; `isLocked` = false при выполненных условиях).

### 3.3. Артефакты
- Понятие: финальные карточки уровней (1–10), отображаются в конце уровня и на экране «Артефакты».
- Структура данных (в `levels`): `artifact_title`, `artifact_description`, `artifact_url` (для внешних материалов) и локальные ассеты (UI).
- Создание/привязка: артефакт связан с уровнем (по `levels.id/number`).
- UI: `ArtifactsScreen` — сетка карточек 2/3/4 колонки, badge «Собрано X/10», полноэкранный просмотр c «переворотом» front/back.

### 3.4. База данных (факт)

- `levels`: `id int PK`, `number int`, `title text`, `description text`, `image_url text (deprecated)`, `is_free bool default false`, `artifact_title text`, `artifact_description text`, `artifact_url text`, `cover_path text?`, `skill_id int?`, `floor_number smallint default 1`, `created_at timestamptz default now()`.
- `lessons`: `id int PK`, `level_id int`, `order int`, `title text`, `description text`, `video_url text?`, `duration_minutes int`, `quiz_questions jsonb`, `correct_answers jsonb`, `vimeo_id text?`, `created_at timestamptz default now()`.
- `user_progress`: PK(`user_id`,`level_id`), `current_lesson int default 1`, `is_completed bool default false`, `started_at timestamptz default now()`, `completed_at timestamptz?`, `updated_at timestamptz default now()`.
- `floor_access`: PK(`user_id`,`floor_number`), `unlocked_at timestamptz default now()`.
- `mini_cases`: `id smallint PK`, `slug text?`, `title text`, `after_level smallint in {3,6,9}`, `skill_name text?`, `estimated_minutes smallint>0 default 10`, `hero_image_path text?`, `description_image_path text?`, `is_required bool default true`, `active bool default true`, `script jsonb?`, timestamps.
- `user_case_progress`: `id uuid PK`, `user_id uuid default auth.uid()`, `case_id smallint`, `status text in {'started','completed','skipped'} default 'started'`, `steps_completed smallint >=0 default 0`, `hints_used smallint >=0 default 0`, timestamps.

#### 3.4.1. RLS/Политики (факт)
- `levels`/`lessons`: select для authenticated (`auth.uid() IS NOT NULL`).
- `user_progress`: select/insert/update только свои (`user_id = auth.uid()`).
- `floor_access`: select/upsert только свои (`user_id = auth.uid()`).
- `mini_cases`: read для authenticated при `active = true`.
- `user_case_progress`: select/insert/update только свои (`user_id = auth.uid()`).

(Примечание: точные DDL см. в миграциях проекта; выше — реконструкция по использованию.)

### 3.5. Ключевые участки кода
```200:212:lib/providers/levels_provider.dart
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
    'label': levelNumber == 0 ? 'Ресепшн' : 'Уровень $levelNumber',
  };
```
```439:447:lib/screens/level_detail_screen.dart
final rows = await Supabase.instance.client
  .from('levels')
  .select('artifact_title, artifact_description, artifact_url')
  .eq('id', levelId)
  .maybeSingle();
```

---

## 4. ИНТЕГРАЦИИ И СВЯЗИ

### 4.1. Матрица интеграций

| Компонент A | Компонент B | Связь | Как реализована | Файлы |
|-------------|-------------|-------|-----------------|-------|
| Макс | Цели | ✅ | Чат Макса на «Цели» (баббл) и в чекпоинтах (embedded); контекст версии/чек‑ина | `goal_screen.dart`, `goal_checkpoint_screen.dart`, `leo_dialog_screen.dart`, Edge `leo-chat`
| Макс | Уровни | ✅ | Edge учитывает пройденные уровни (гейты ответов), levelContext; чат в LevelDetail (Leo) | `leo_chat/index.ts`, `level_detail_screen.dart`
| Цели | Уровни | ✅ | v1 создаётся на L1; чекпоинты v2/v3/v4 после L4/L7/L10; «куда продолжить» | `levels_provider.dart`, `level_detail_screen.dart`
| Артефакты | Цели | ⚠️ косвенно | В чек‑ине недели есть признаки использования артефактов | `goal_screen.dart` (контекст), `goals_repository.dart`
| Артефакты | Макс | ⚠️ косвенно | Контекст чата Макса включает признаки weekly (used_artifacts) | `goal_screen.dart`, Edge `leo-chat`

### 4.2. Детализация связей

- Макс ↔ Цели:
```680:696:lib/screens/goal_checkpoint_screen.dart
LeoDialogScreen(
  bot: 'max',
  embedded: true,
  firstPrompt: ...,
  recommendedChips: _recommendedChips(),
  autoUserMessage: _autoMessageForChat,
  skipSpend: true,
)
```
```663:676:lib/screens/goal_screen.dart
FloatingChatBubble(
  userContext: _buildTrackerUserContext(...),
  levelContext: 'current_level: $currentLevel',
  bot: 'max',
)
```
- Макс ↔ Уровни (server‑side гейты/учёт прогресса):
```801:808:supabase/functions/leo-chat/index.ts
// RAG context (только для Leo, не для Max)
let ragContext = '';
const shouldDoRAG = !isMax && !caseMode && ...;
```
- Цели ↔ Уровни (узлы башни и «куда продолжить»):
```312:327:lib/providers/levels_provider.dart
// Вставляем чекпоинт цели после 4/7/10
nodes.add({ 'type': 'goal_checkpoint', 'version': goalVersion, ... });
```
```134:157:lib/providers/levels_provider.dart
// «Куда продолжить»: при завершённом уровне перед чекпоинтом ведём на v2/v3/v4
return { 'label': 'Чекпоинт цели v${gver ?? ''}', ... };
```
- Уровень 1 → v1 (создание наброска):
```400:409:lib/screens/level_detail_screen.dart
_GoalV1Block(onSaved: () { ref.invalidate(goalLatestProvider); ref.invalidate(goalVersionsProvider); ... });
```
- Weekly контекст в чате Макса:
```709:717:lib/screens/goal_screen.dart
sb.writeln('last_sprint_metric_actual: ${_metricActualCtrl.text.trim()}');
```

---

## 5. ПОТОКИ ДАННЫХ

### 5.1. Data Flow: Создание/обновление цели
```
UI (GoalCheckpointScreen → GoalVersionForm)
  ↓
GoalCheckpointScreen._save()
  ↓
GoalsRepository.upsertGoalVersion()/updateGoalById
  ↓
Supabase RPC upsert_goal_version (или upsert core_goals)
  ↓
core_goals (version, goal_text, version_data)
  ↓
invalidate goalLatest/goalVersions → UI обновляет таблицу/прогресс
```

### 5.2. Data Flow: Чат с Максом
```
UI (GoalScreen FloatingChatBubble / GoalCheckpointScreen embedded)
  ↓
LeoDialogScreen._sendMessageInternal()
  ↓
LeoService.sendMessageWithRAG({ bot:'max', userContext, levelContext, chatId? })
  ↓
Edge Function /functions/v1/leo-chat (isMax=true: RAG off, tracker prompt)
  ↓
(при userId) leo_chats/leo_messages insert + ai_message (usage/cost)
  ↓
Response { message, recommended_chips? } → UI: добавление бабла ассистента
```

### 5.3. Data Flow: Прохождение уровня
```
UI (LevelDetailScreen PageView: Lesson/Quiz blocks)
  ↓
lessonProgressProvider: markVideoWatched/markQuizPassed → unlock next
  ↓
Кнопка «Завершить уровень» → SupabaseService.completeLevel(levelId)
  ↓
user_progress (is_completed=true), update_current_level RPC (очки навыков)
  ↓
invalidate levelsProvider/currentUser → Башня/Главная обновляют состояние
```

### 5.4. Data Flow: Создание v1 на Уровне 1
```
UI (_GoalV1Block)
  ↓
GoalsRepository.upsertGoalVersion(version:1)
  ↓
core_goals upsert (user_id триггером)
  ↓
invalidate goalLatest/goalVersions → кнопка «Завершить уровень» разблокирована
```

### 5.5. Database ER (основные сущности)
```
auth.users (id)
├─ core_goals (user_id, version 1..4, goal_text, version_data)
│
├─ weekly_progress (user_id, sprint_number 1..4, ...)
│
├─ reminder_checks (user_id, day_number 1..28, ...)
│
├─ leo_chats (user_id, bot in 'leo'|'max', ...)
│  └─ leo_messages (chat_id, user_id, role, content)
│     └─ ai_message (leo_message_id, chat_id, user_id, usage/cost, bot_type)
│
├─ user_progress (user_id, level_id, is_completed)
│  └─ levels (id, number, floor_number, artifact_*)
│     └─ lessons (level_id, order, quiz_*)
│
├─ floor_access (user_id, floor_number)
├─ user_case_progress (user_id, case_id, status)
└─ motivational_quotes (public read)
```

---

(Дальше в отчёте будут последовательно заполнены разделы 2–10 и Приложения. Этап 2 — «Цель».)
