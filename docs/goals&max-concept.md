## Отчёт: «Цель» и бот Макс — текущее состояние реализации

### Обзор
- **Назначение**: система постановки цели (v1→v4) с чекпоинтами в «Башне», недельный путь (weekly_progress) и поддержка бота Макса (AI‑трекера).
- **Статус**: функционал реализован и интегрирован в навигацию (GoRouter), данные под RLS, UI экрана «Цель» — read‑only (редактирование в чекпоинтах). Чат Макса доступен в чекпоинтах (embedded) и на странице «Цель» (полноэкранный).

### Пользовательские флоу
- **v1 (Семя цели)**:
  - Создаётся после прохождения Уровня 1 (или на экране «Цель» при первом заходе, где показана карточка цели и блок кристаллизации).
  - Поля: goal_initial, goal_why, main_obstacle.
  - Сохранение создаёт запись в `core_goals` с `version = 1`.

- **Чекпоинты v2/v3/v4 в «Башне»**:
  - После уровней 4/7/10 появляются узлы `goal_checkpoint` (v2 Метрики, v3 SMART, v4 Финал).
  - Условия: вход возможен только если предыдущий уровень завершён; редактировать можно только текущую (последнюю) версию; нельзя «перепрыгнуть» через версии.
  - Экран чекпоинта содержит форму версии и встроенный чат Макса (embedded). Кнопка «Применить предложение» подставляет данные из ответа Макса в форму.
  - После сохранения — инвалидация провайдеров целей и возврат в «Башню» со скроллом к следующему узлу.

- **Недельный путь (weekly_progress)**:
  - На странице «Цель» (read‑only обзор) доступен блок 28‑дневного пути: выбор недели 1–4, форма чек‑ина (достижения, метрика, техники, инсайт) и сохранение в `weekly_progress`.
  - После сохранения чек‑ина может автоматически открываться чат Макса с контекстом недели.

- **Общение с Максом**:
  - В чекпоинте — встроенный чат `LeoDialogScreen(bot='max', embedded: true)`, сервер формирует ответ с учётом контекста цели/версии; доступны рекомендованные чипы.
  - На странице «Цель» — полноэкранный чат `LeoDialogScreen(bot='max')`.
  - Каждое сообщение списывает 1 GP (идемпотентно); при недостатке GP — дружелюбная ошибка с переходом в магазин.

### Архитектура клиента (ключевые элементы)
- **Экраны**:
  - `lib/screens/goal_screen.dart` — обзор цели (read‑only), «Кристаллизация», «Путь к цели», «Мотивация», кнопка/баббл чата Макса.
  - `lib/screens/goal_checkpoint_screen.dart` — формы v1/v2/v3/v4, встроенный чат Макса, сохранение версии и возврат в «Башню».

- **Чат**:
  - `lib/screens/leo_dialog_screen.dart` — поддерживает `bot='leo'|'max'`, режимы embedded/полноэкранный, `caseMode` (мини‑кейсы), чипы быстрых ответов, колбэк `onAssistantMessage`.
  - `lib/services/leo_service.dart` — вызов Edge `/leo-chat`, параметр `bot`, списание 1 GP (RPC), retry/обработка ошибок, режимы default/RAG/quiz/case.

- **Провайдеры целей (Riverpod)**: `lib/providers/goals_providers.dart`
  - `goalLatestProvider` — последняя версия цели пользователя.
  - `goalVersionsProvider` — все версии цели (v1→v4).
  - `hasGoalVersionProvider(version)` — наличие конкретной версии (используется в «Башне» для статусов чекпоинтов).
  - `sprintProvider(week)` — данные недели из `weekly_progress`.
  - `remindersStreamProvider` — поток `reminder_checks` (Supabase Realtime).
  - `dailyQuoteProvider` — цитата дня (детерминированный выбор + SWR‑кеш).

- **Репозиторий целей**: `lib/repositories/goals_repository.dart`
  - Goals (`core_goals`): `fetchLatestGoal`, `fetchAllGoals`, `upsertGoalVersion`, `updateGoalById`.
  - Weekly (`weekly_progress`): `fetchWeek`, `upsertWeek`, `updateWeek` (есть новый API и совместимость с более ранними методами), SWR‑кеш в Hive.
  - Reminders (`reminder_checks`): `streamReminderChecks`, `upsertReminder`.
  - Quotes (`motivational_quotes`): `getDailyQuote` с кешированием активных записей.
  - Все методы имеют офлайн‑фолбэки (Hive) и обработку сетевых исключений.

- **Навигация (GoRouter)**: `lib/routing/app_router.dart`
  - `/goal` — экран «Цель» (обзор/чаты).
  - `/goal-checkpoint/:version` — чекпоинты v2/v3/v4 с формами и embedded‑чатом Макса.
  - `/tower` — «Башня» (единая точка входа к уровням и чекпоинтам).

- **«Башня» и чекпоинты**:
  - `lib/providers/levels_provider.dart` — провайдер `towerNodesProvider` формирует узлы. После уровней 4/7/10 вставляются узлы `goal_checkpoint` с флагами `isCompleted` (на основе `hasGoalVersionProvider`) и `prevLevelCompleted` (гейтинг по предыдущему уровню).
  - `lib/screens/tower/tower_tiles.dart` — обработка тапа по чекпоинту → переход на `/goal-checkpoint/:version`.

### Бэкенд (Supabase) — данные и политики
- **Таблицы** (миграция `20250812_28_1_create_goal_feature_tables.sql`):
  - `public.core_goals` — версии цели (v1..v4): `id`, `user_id`, `version`, `goal_text`, `version_data`, `created_at`, `updated_at` (UNIQUE `(user_id, version)`).
  - `public.weekly_progress` — недельные чек‑ины: `id`, `user_id`, `sprint_number (1..4)`, `achievement`, `metric_actual`, `used_artifacts`, `consulted_leo`, `applied_techniques`, `key_insight`, `created_at`.
  - `public.reminder_checks` — напоминания по дням (1..28): `id`, `user_id`, `day_number`, `reminder_text`, `is_completed`, `completed_at`, `created_at` (UNIQUE `(user_id, day_number)`).
  - `public.motivational_quotes` — цитаты: `id`, `quote_text`, `author`, `category`, `is_active`, `created_at` (индекс по `is_active`).

- **RLS и политики**:
  - Включён RLS на `core_goals/weekly_progress/reminder_checks`.
  - Owner‑only политики: select/insert/update/delete только для `auth.uid() = user_id`.
  - Для `motivational_quotes` — разрешён SELECT для клиента (отдельная миграция `20250816_allow_select_motivational_quotes.sql`).

- **Триггеры и функции**:
  - `tg_set_user_id` — перед вставкой проставляет `user_id = auth.uid()`.
  - `tg_set_updated_at` — обновляет `updated_at` на `core_goals`.
  - `tg_core_goals_update_guard` — запрещает изменять `user_id`/`version` и редактировать не последнюю версию (гарантия последовательности v1→v4).

- **Индексы**:
  - `core_goals_user_updated_idx (user_id, updated_at desc)` — быстрый выбор последней версии.
  - `weekly_progress_user_sprint_idx (user_id, sprint_number desc)` — быстрый доступ к неделям.

- **ИИ и логи чатов (контекст)**:
  - Edge Function `/leo-chat` принимает `bot='leo'|'max'`, поддерживает режимы (default/quiz/case), использует пользовательский контекст целей/недель/памяти и RAG (для Лео; у Макса — режим трекера цели).
  - Триггер памяти `leo_messages → leo-memory` (из статуса в документации) — извлечение фактов/свёрток, используется для персонализации.

### Интеграция GP (Growth Points)
- Каждое сообщение в чате (кроме режимов quiz/case) списывает **1 GP**:
  - Клиент: `LeoService` вызывает `GpService.spend(type='spend_message', amount=1, idempotencyKey=...)`.
  - Идемпотентность обеспечивается ключом; при ошибке «Недостаточно GP» показывается дружелюбная ошибка и предлагается переход в магазин.
  - Флаг аварийного отключения списаний: `kDisableGpSpendInChat`.

### Состояния и ограничения (важное)
- Редактирование версии цели допустимо только для последней версии (RLS‑guard) — попытка редактировать старую версию приведёт к ошибке БД.
- Нельзя перескочить через версии (UI и серверная проверка): новая версия = `latest + 1`.
- Узлы `goal_checkpoint` доступны только после завершения предыдущего уровня (проверка в «Башне» через `prevLevelCompleted`).
- Мини‑кейсы (после 3/6/9) могут блокировать следующий уровень до `completed/skipped` (по данным `user_case_progress`).
- Экран «Цель» — read‑only обзор: редактирование выполняется в чекпоинтах; недельный чек‑ин сохраняется на месте.
- Офлайн: SWR‑кеш (Hive) для целей/недель/цитат; сетевые ошибки обрабатываются дружелюбно; есть Sentry‑breadcrumbs.

### Ссылки на ключевые файлы
- Экраны: `lib/screens/goal_screen.dart`, `lib/screens/goal_checkpoint_screen.dart`, `lib/screens/leo_dialog_screen.dart`.
- Провайдеры/DI: `lib/providers/goals_providers.dart`, `lib/providers/goals_repository_provider.dart`.
- Репозиторий: `lib/repositories/goals_repository.dart`.
- Навигация: `lib/routing/app_router.dart`.
- «Башня»: `lib/providers/levels_provider.dart`, `lib/screens/tower/tower_tiles.dart`.
- Миграции: `supabase/migrations/20250812_28_1_create_goal_feature_tables.sql`, `supabase/migrations/20250816_allow_select_motivational_quotes.sql`.

### Резюме
- «Цель» и Макс интегрированы сквозным флоу: уровни → чекпоинты v2/v3/v4 → недельный путь, с owner‑only безопасностью в БД, офлайн‑кешем и устойчивым UX. Чат Макса использует персональный контекст цели, поддерживает рекомендованные ответы и корректно учитывает GP.


