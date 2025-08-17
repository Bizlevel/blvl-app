# Этап 27: Исправления и оптимизации
### Задача 27.1: База данных — корректировка прогресса и навыков
- Файлы: `supabase/migrations/YYYYMMDD_update_current_level_with_skills.sql`
- Что сделать:
  1) Обновить RPC `public.update_current_level(p_level_id int)`:
     - Определять `lvl_num` и `skill_id` завершённого уровня: `select number, skill_id into ... from levels where id = p_level_id`.
     - Обновлять `users.current_level = lvl_num + 1` для `auth.uid()` (сохранить текущее поведение и `SECURITY DEFINER`, `SET search_path TO public`).
     - Если `skill_id` не NULL — выполнить UPSERT в `user_skills` (+1 к `points`) для пары `(auth.uid(), skill_id)`.
  2) Добавить индексы производительности:
     - `create index if not exists idx_levels_skill_id on public.levels(skill_id);`
     - `create index if not exists idx_user_skills_skill on public.user_skills(skill_id);`
     - (проверка) наличие индекса `idx_user_progress_level_id` на `user_progress(level_id)`.
- Проверка:
  - Применить миграцию через `supabase-mcp`.
  - Выполнить `select pg_get_functiondef('public.update_current_level(int)')` и визуально подтвердить логику UPSERT.
  - Прогнать advisors (см. 27.3) — не должно появиться новых ошибок.      
### Задача 27.2: Клиент — консистентность и безрегрессный сценарий
- Файлы: без изменений (поведение уже корректное: `SupabaseService.completeLevel()` → upsert в `user_progress` + RPC, инвалидация провайдеров `levelsProvider`/`currentUserProvider`/`userSkillsProvider`).
- Опционально (техдолг): унифицировать дефолт `UserModel.currentLevel` на `0`, чтобы соответствовал БД. Делать только после прохождения основного сценария.
### Задача 27.3: Advisors и индексы
- Инструменты: `supabase-mcp` (`get_advisors`, `list_tables`).
- Что сделать:
  1) Запустить security/performance advisors и зафиксировать результаты.
  2) Убедиться, что предупреждения про неиндексированные FK `levels.skill_id` и `user_skills.skill_id` ушли.
  3) (Техдолг) Отметить WARN по RLS init-plan (вызовы `auth.*()` в политиках) — оставить к последующей оптимизации.

### Задача 27.4: Тесты — проверка начисления навыков
- Файлы: `test/level_flow_test.dart` (расширить), либо новый `test/level_skill_increment_test.dart`.
- Что проверить:
  1) После вызова `SupabaseService.completeLevel(levelId)` очки навыка, связанного с этим уровнем (`levels.skill_id`), увеличиваются на 1 в данных `userSkillsProvider`.
  2) Инвалидация `levelsProvider`/`currentUserProvider`/`userSkillsProvider` приводит к обновлению UI (можно проверить через мок/фейк-репозитории или интеграционный сценарий).
- Примечание: интеграционный тест с реальной БД допустим в отдельном окружении; в юнит‑тестах — контрактный тест на уровне репозитория/провайдера.

### Задача 27.5: Проверка и настройка Sentry
- Файлы: `lib/main.dart`, `lib/routing/app_router.dart`, `scripts/sentry_check.sh`.
- Что сделать:
  1) Проверить, что DSN передаётся через `envOrDefine('SENTRY_DSN')`, Sentry инициализируется в той же async‑зоне, `SentryNavigatorObserver` подключён к GoRouter.
  2) Убедиться, что `beforeSend` удаляет заголовок `Authorization` из событий (есть в `main.dart`).
  3) Прогнать `scripts/sentry_check.sh` локально и в CI, убедиться в отсутствии критических нерешённых ошибок за 24 часа. Игнор «шумных» категорий должен сохраняться.
  4) Смоук-проверка: искусственно выбросить исключение в dev-сборке и убедиться, что оно попадает в Sentry с корректным `environment` и `release`.

# Этап 28: Реализация фичи «Цель» (MVP + трекер)

## 28.1 Миграции Supabase (через supabase-mcp)
  - Создать таблицы с индексами и RLS (owner-only):
    - `core_goals(id uuid pk, user_id uuid fk, version int check 1..4, goal_text text, version_data jsonb, created_at timestamptz default now(), updated_at timestamptz default now())`
      - Индексы: уникальный `(user_id, version)`, а также `updated_at DESC`
      - Ограничение: редактировать можно только последнюю версию (см. триггер ниже); запрещено менять поле `version` через UPDATE
    - `weekly_progress(id uuid pk, user_id uuid fk, sprint_number int check 1..4, achievement text, metric_actual text, used_artifacts bool, consulted_leo bool, applied_techniques bool, key_insight text, created_at timestamptz default now())`
      - Индекс: `(user_id, sprint_number DESC)`
    - `reminder_checks(id uuid pk, user_id uuid fk, day_number int check 1..28, reminder_text text, is_completed bool default false, completed_at timestamptz)`
      - Уникальный ключ `(user_id, day_number)` для upsert (обновлено на 28 дней)
    - `motivational_quotes(id uuid pk, quote_text text, author text, category text, is_active bool default true)`
      - Индексы: `is_active`, опционально `created_at`
  - Включить RLS, добавить политики select/insert/update/delete для `auth.uid() = user_id` (кроме `motivational_quotes`, доступно для чтения всем или без RLS)
  - Триггеры целостности и защита RLS:
    - `BEFORE INSERT` на `core_goals`, `weekly_progress`, `reminder_checks`: жёстко проставлять `NEW.user_id = auth.uid()`; отклонять вставку/обновление, где `user_id != auth.uid()`
    - `BEFORE UPDATE` на `core_goals`: запрещать редактирование не последней версии для пользователя (если `OLD.version < max(version) for user` → RAISE EXCEPTION)
  - Seed «цитат дня» в `motivational_quotes` из локального файла: `/docs/motivational-quotes-goals.md` (парсинг и загрузка в таблицу)

## 28.2 Модели и репозиторий (минимум нового кода)
  - Добавить модели (Freezed/JSON): `CoreGoal`, `WeeklyProgress`, `ReminderCheck`, `MotivationalQuote`
  - Создать `GoalsRepository` по шаблону существующих (`LevelsRepository`, `LessonsRepository`):
    - `fetchLatestGoal(userId)` / `fetchAllGoals(userId)`
    - `upsertGoalVersion(version, goalText, versionData)` — insert новой версии; редактируется только текущая
    - `fetchSprint(sprintNumber)` / `upsertSprint(...)`
    - `streamReminderChecks()` / `upsertReminder(day, isCompleted)`
    - `getDailyQuote()` — выбор активной цитаты с детерминированной ротацией по дате
  - Включить Hive‑кеш (stale‑while‑revalidate) как в существующих репозиториях
  - Провайдеры Riverpod: `goalsRepositoryProvider`, `goalLatestProvider`, `goalVersionsProvider`, `sprintProvider`, `remindersProvider`, `dailyQuoteProvider`

## 28.3 Роутинг и оболочка (Web + Mobile + Desktop)
  - В `lib/routing/app_router.dart` добавить `GoRoute(path: '/goal', builder: (_) => GoalScreen())`
  - В `lib/screens/app_shell.dart` расширить вкладки: `['/home','/chat','/goal','/profile']`
    - Мобильный `BottomNavigationBar`: добавить пункт с иконкой `Icons.flag` (или `Icons.target`)
    - `DesktopNavBar`: добавить «Цель» (четвёртая вкладка)
  - Гейтинг: до завершения Уровня 1 — вкладка неактивна (серый стиль + SnackBar «Доступно после Уровня 1»), при прямом переходе на `/goal` — редирект на `/home`. Критерий: `current_level >= 2` (уровень 1 завершён).

## 28.4 Экран `GoalScreen` (MVP)
  - Использовать существующие компоненты: `CustomScrollView`/`SingleChildScrollView`, `StatCard`, `CustomTextBox`, паттерн `PageView`/индикатор как в уровнях
  - Секции:
    - «Мотивация от Leo»: карточка с данными `dailyQuoteProvider`
    - «Кристаллизация цели v1»: форма из 3 полей (`goal_initial`, `goal_why`, `main_obstacle`) + кнопка «Сохранить»
      - Валидация (мин. 10 символов), автосохранение с дебаунсом 200 мс (как в провайдере прогресса уроков)
  - До v4 блок «Путь к цели» показывать как 🔒 (заглушка)

## 28.5 Версии v2–v4 (кристаллизация)
  - Добавить горизонтальный переключатель версий (свайп/табы) и индикатор ●●●●
  - Формы v2/v3/v4 по спецификации; редактируемая только последняя доступная версия, предыдущие — read‑only
  - Копирование полей предыдущей версии как базовое значение при создании новой
  - Данные храним в `core_goals.version_data` (JSONB), `goal_text` — краткая сводка

## 28.6 Путь к цели (28‑дневный спринт)
  - Разблокировать после заполнения v4
  - 4 спринта по 7 дней. UI спринтов: переключатель 1–4, прогресс‑бар дней (1..7), вертикальная timeline (ровно 7 чекпоинтов), список напоминаний текущего дня/спринта (чекбоксы)
  - Кнопка «📝 Итоги спринта»: форма `WeeklyProgress` (по последнему дню спринта)
  - После успешного сохранения чек‑ина автоматически открывать чат Лео‑трекера (см. 28.7) с персональным фидбеком и мягкими рекомендациями по незаполненным пунктам
  - Данные: `weekly_progress`, `reminder_checks`; провайдеры из п. 28.2

## 28.7 Интеграция Leo‑трекера (без изменений Edge Function)
  - Переиспользовать `FloatingChatBubble` на `GoalScreen`; дополнительно поддержать программированное открытие диалога
  - После сохранения «Итоги спринта» автоматически открыть чат и отправить системный промпт с краткой похвалой и мягким пояснением важности постоянства. Включать в контекст незаполненные пункты (например, отсутствующие галочки по напоминаниям), чтобы Лео предложил обсудить их
  - Передавать в `LeoService.sendMessageWithRAG` `systemPrompt`/`knowledgeContext`, содержащий текущую версию цели, номер спринта, день (1..7), отмеченные/неотмеченные напоминания, и сводку `WeeklyProgress`
  - Тумблер «Общий режим ↗» — переключение промпта на дефолтный (клиентская логика)
## 28.8 Интеграция с Уровнями
  - В `LevelDetailScreen` после успешного `completeLevel()` уровня 1 выполнять `context.go('/goal')` и открывать v1
  - Для уровней 4/7/10 — отображать ненавязчивую плашку «Кристаллизуй цель» (опционально; можно ограничиться доступностью версий на странице «Цель»)
## 28.9 Тесты
  - Юнит‑тесты `GoalsRepository` (CRUD целей/спринтов/напоминаний, ошибки, кеш)
  - Виджет‑тесты `GoalScreen` (гейтинг до/после Level 1, формы v1, переключение версий, скрытие/показ спринтов, 28‑дневная логика)
  - Интеграционный happy‑path: завершение Уровня 1 → редирект на `/goal` → сохранение v1
  - Интеграционный сценарий чек‑ина: сохранение «Итоги спринта» ⇒ автоматически открыт чат Лео‑трекера с корректным промптом
## 28.10 Наблюдаемость и производительность
  - Логировать ошибки в Sentry (`captureException`) в репозитории/провайдерах; использовать sentry‑mcp для проверки критичных ошибок после релиза
  - Исключить отправку PII/контента целей в Sentry (логировать только исключения и метаданные)
  - Кеширование через Hive, минимальные перерисовки, ленивые загрузки истории версий
  - `flutter analyze` и существующие тесты — без регрессий

# Этап 29: Бот Алекс — трекер цели (минимальные изменения)

### Задача 29.1: База данных — маркировка чатов по боту
- Файлы: `supabase/migrations/YYYYMMDD_add_leo_chats_bot.sql`
- Что сделать:
  1) Добавить колонку `bot text not null default 'leo' check (bot in ('leo','alex'))` в `public.leo_chats`.
  2) Бэкфилл существующих строк: установить `bot = 'leo'` (в рамках `DEFAULT` значений это не требуется, но зафиксировать явно).
  3) Индекс производительности для списков: `create index if not exists idx_leo_chats_user_bot_updated on public.leo_chats(user_id, bot, updated_at desc);`
  4) RLS/политики не менять (привязка по `user_id` сохраняется). Триггеры и счётчики сообщений не трогаем.
- Проверка:
  - Применить миграцию через supabase-mcp (apply_migration), затем `list_tables` и выборка `select bot,count(*) from leo_chats group by 1`.

### Задача 29.2: Edge Function — единая `leo-chat` с режимом `bot`
- Файл: `supabase/functions/leo-chat/index.ts`
- Что сделать (без создания новой функции):
  1) Принимать параметр `bot` в теле запроса: `'leo' | 'alex'` (по умолчанию `'leo'`).
  2) Если `bot==='alex'`:
     - Сформировать отдельный системный промпт «Алекс — трекер цели» с фокусом на кристаллизацию цели и поддержку в спринтах (короткие, конкретные ответы; без таблиц и «могу помочь…» — правила как у Лео, тон и приоритеты иные).
     - Дополнительно выбирать данные для контекста:
       - `users`: `name, goal, business_area, experience_level, current_level` (если есть)
       - `core_goals`: последняя версия (version, goal_text, version_data)
       - `weekly_progress`: последняя запись или текущий спринт
       - `reminder_checks`: записи по текущему дню/неделе (минимум — текущий день)
       - `motivational_quotes`: активная цитата дня
       - `user_memories`: последние 3–5
       - `leo_chats.summary`: последние 2–3 свёртки, фильтр `bot='alex'`
     - Встроенный RAG: вызывать `rpc('match_documents', ...)` как у Лео; при наличии `levelContext` — передавать `metadata_filter`. Модель/температура/лимиты — те же ENV, что у Лео.
  3) Если `bot!=='alex'` — оставить текущее поведение Лео без изменений (режим трекера у Лео отключается на клиенте; серверная ветка Лео соответствует состоянию до этапа 28).
- Проверка:
  - Локальный вызов `leo-chat` с `bot='alex'` возвращает ответ с включёнными секциями «Цель/Спринт/Напоминания/Память/Итоги обсуждений/RAG».

### Задача 29.3: Клиент — параметр `bot` в сервисе и создании чатов
- Файлы: `lib/services/leo_service.dart`, места вызова `saveConversation`/`sendMessageWithRAG`
- Что сделать:
  1) В `sendMessageWithRAG` добавить параметр `String bot = 'leo'` и передавать его в тело POST `/leo-chat`.
  2) В `saveConversation(...)` добавить параметр `String bot = 'leo'` и при создании новой записи в `leo_chats` проставлять `{'bot': bot}`.
  3) Обратная совместимость: существующие вызовы не меняем (дефолт `'leo'`).

### Задача 29.4: UI — интеграция Алекса в «Цель» и «Чат»
- Файлы: `lib/widgets/floating_chat_bubble.dart`, `lib/screens/leo_dialog_screen.dart`, `lib/screens/leo_chat_screen.dart`, `lib/screens/goal_screen.dart`
- Что сделать:
  1) `LeoDialogScreen`: добавить параметр `bot = 'leo'`; заголовок AppBar менять на «Диалог с Алекс», если `bot==='alex'`; прокинуть `bot` в `LeoService` методы.
  2) `FloatingChatBubble`: добавить параметр `bot` и текст кнопки; на странице «Цель» использовать `bot='alex'` и лейбл «Обсудить с Алекс»; по умолчанию — Лео.
  3) `LeoChatScreen`: добавить переключатель вкладок «Лео»/«Алекс» (фильтр списка по `leo_chats.bot`), FAB: «Новый диалог с Лео» и опция «Новый диалог с Алекс».
  4) В уровнях и на общей странице «Чат» по умолчанию остаётся Лео; на странице «Цель» — автоматически открывать Алекса.

### Задача 29.5: Контекст и промпт Алекса
- Файл: `supabase/functions/leo-chat/index.ts`
- Что сделать:
  - Описать блоки контекста в системном промпте для `bot='alex'`: «ДАННЫЕ ЦЕЛИ», «СПРИНТ», «НАПОМИНАНИЯ», «ЛИЧНЫЕ ЗАМЕТКИ», «ИТОГИ ПРОШЛЫХ ОБСУЖДЕНИЙ», «RAG контекст».
  - Приоритет ответов: 1) цель/метрики пользователя, 2) практические шаги на ближайший день/неделю, 3) дополнение из материалов курса (RAG), 4) краткое завершение без «предложений помощи».
  - Сохранить те же модель/параметры OpenAI (ENV), что у Лео.

### Задача 29.6: Лимиты, память и совместимость
- Что сделать:
  - Использовать те же лимиты сообщений (общие поля в `users`), отдельный бюджет для Алекса не вводить (MVP).
  - Триггер `leo-memory` оставить без изменений — «память» общая на пользователя; свёртки `leo_chats.summary` учитывают `bot` при выборке в контексте Алекса.
  - Поведение Лео вернуть к роли «ментор» (без трекер‑логики) — реализуется тем, что клиент перестаёт передавать «трекинговый» контекст для `bot='leo'`.

### Задача 29.7: Тесты
- Файлы: `test/services/leo_service_unit_test.dart`, `test/screens/leo_chat_screen_test.dart`, `test/goal_alex_flow_test.dart`
- Что проверить:
  1) `LeoService.sendMessageWithRAG` передаёт `bot` в тело запроса; `saveConversation` проставляет `bot` в `leo_chats`.
  2) Фильтрация чатов по `bot` и создание нового диалога с Алекс из `LeoChatScreen`.
  3) Открытие чата с Алекс с страницы «Цель» (через `FloatingChatBubble`), наличие контекста цели/спринта в промпте.
  4) Backward‑compatibility: диалоги Лео продолжают работать как прежде.
- Подсказка в UI (tooltip/баннер) при первом открытии «Цели»: «Диалог с Алекс помогает кристаллизовать цель и поддерживает вас 28 дней».

### Задача 29.8: Аудит схемы и индексов для Leo/Alex и RAG
- Инструменты: supabase-mcp (`list_tables`, `execute_sql`).
- Что сделать:
  1) Проверить структуру таблиц: `users`, `leo_chats` (включая `bot`, `summary`, `last_topics`), `leo_messages`, `user_memories`, `documents` (наличие `embedding vector` и `metadata jsonb`), `core_goals`, `weekly_progress`, `reminder_checks`, `motivational_quotes`.
  2) Проверить индексы производительности: 
     - `idx_leo_chats_user_bot_updated` на `(user_id, bot, updated_at desc)`;
     - ANN/IVFFLAT/HNSW индекс на `documents(embedding)`;
     - GIN индекс на `documents(metadata)`;
     - индексы на навыках: `idx_levels_skill_id`, `idx_user_skills_skill`.
  3) Проверить триггеры на `leo_messages` (AFTER INSERT ассистента → вызов памяти) и отсутствие дубликатов `public.call_leo_memory(...)`.
  4) Подтвердить наличие перегрузки RPC `match_documents(vector, double precision, integer, jsonb)`.
- Критерии приёмки: все объекты существуют; индексы присутствуют; перегрузка RPC с `jsonb` доступна; нет дублирующих сигнатур `call_leo_memory`.

### Задача 29.9: Конфигурация секретов и GUC для edge‑функций
- Инструменты: Supabase Studio (Edge Functions Settings), supabase-mcp (`execute_sql`).
- Что сделать:
  1) Установить БД‑GUC: `app.supabase_url`, `app.service_role_key` (без коммитов ключей в репозиторий).
  2) Для edge‑функции `leo-memory` задать секрет `CRON_SECRET` и выполнить redeploy.
  3) Для `leo-chat` убедиться, что внешние ключи (если используются) берутся из ENV/секретов, а не из кода.
- Критерии приёмки: `current_setting('app.supabase_url', true)` и `current_setting('app.service_role_key', true)` возвращают непустые значения; `leo-memory` читает `CRON_SECRET`; функции успешно деплоятся.

### Задача 29.10: Smoke‑проверка пайплайна памяти
- Инструменты: supabase-mcp (`execute_sql`).
- Что сделать:
  1) Выполнить ручной вызов `public.call_leo_memory(...)` на последнем ассистентском сообщении (как в `docs/1.md`).
  2) Проверить, что появилась запись в `leo_messages_processed` для этого `message_id`.
  3) Проверить обновление `leo_chats.summary` и `leo_chats.last_topics` по соответствующему `chat_id`.
- Критерии приёмки: сообщение помечено как обработанное, свёртки обновились без ошибок.

### Задача 29.11: Smoke‑проверка RAG с metadata_filter
- Инструменты: supabase-mcp (`execute_sql`), логи edge‑функции `leo-chat`.
- Что сделать:
  1) Выполнить SQL‑запрос к `match_documents` с `metadata_filter` по уровню (например, `{"level_id":1}`) и убедиться, что есть релевантные совпадения.
  2) Отправить тестовый запрос в `leo-chat` с `levelContext` и проверить по логам, что фильтр применяется и ошибок RAG нет.
- Критерии приёмки: SQL возвращает результаты, логи функции фиксируют применение `metadata_filter` и отсутствие ошибок.

### Задача 29.12: Бэкфилл и индексация `documents`
- Инструменты: скрипт `scripts/upload_from_drive.py`, supabase-mcp (`execute_sql`).
- Что сделать:
  1) Проверить заполненность `documents.metadata` (`level_id`, `lesson_id`, `tags` вида "Level N"/"Lesson N"). При нехватке — выполнить бэкфилл через `documents_backfill_map` и загрузчик.
  2) Создать (если отсутствуют) индексы: ANN на `embedding` и GIN на `metadata`.
  3) Пройти advisors (performance) — убедиться в отсутствии предупреждений по этим таблицам.
- Критерии приёмки: покрытие метаданных ≥ 95%; индексы на месте; latency `match_documents` в норме; advisors без новых WARN/ERROR.

### Задача 29.13: Выравнивание RAG‑фильтра для `bot='alex'` в `leo-chat`
- Файл: `supabase/functions/leo-chat/index.ts`.
- Что сделать:
  1) Убедиться, что при наличии `levelContext` ветка `bot='alex'` передаёт `metadata_filter` в `rpc('match_documents', ...)` аналогично Лео.
  2) Добавить структурированное логирование факта применения `metadata_filter` (без утечки данных пользователя).
- Критерии приёмки: ответы Алекса включают RAG по уровню/уроку, логи подтверждают применение фильтра; поведение Лео не меняется.

### Задача 29.14: Безопасность service role и секретов
- Инструменты: ревью репозитория, CI.
- Что сделать:
  1) Исключить `service_role_key` и любые секреты из `.env` и коммитов (проверить `.gitignore`, скрипты, README).
  2) Хранить секреты только в БД‑GUC/Edge Secrets/CI Secrets. В клиенте — использовать `envOrDefine` без сервисных ключей.
  3) (Опционально) В CI добавить grep‑проверку на строки вида `service_role`/`app.service_role_key` в изменениях пул‑реквестов.
- Критерии приёмки: в репозитории отсутствуют секреты; CI/ревью проходят; Sentry/логи не содержат секретов.

### Задача 29.15: Мини‑сид данных для `bot='alex'`
- Инструменты: supabase-mcp (`execute_sql`).
- Что сделать:
  1) Вставить под тестового пользователя минимальные записи: `core_goals(v1)`, один `weekly_progress`, `reminder_checks` (текущий день), одну активную запись в `motivational_quotes`.
  2) Отправить вопрос в `leo-chat` с `bot='alex'` и убедиться, что ответ содержит секции «Цель/Спринт/Напоминания/Цитата».
- Критерии приёмки: Алекс отвечает предметно, без RAG‑регрессий.

### Задача 29.16: Наблюдаемость (Sentry и логи edge)
- Инструменты: sentry-mcp, логи Supabase Edge.
- Что сделать:
  1) Проверить отсутствие критичных нерешённых ошибок за 24 часа (скрипт `scripts/sentry_check.sh`).
  2) Убедиться, что edge‑функции логируют ключевые этапы (применение фильтра, обращение к памяти) без PII.
- Критерии приёмки: критичных ошибок нет; логи информативны и безопасны.
