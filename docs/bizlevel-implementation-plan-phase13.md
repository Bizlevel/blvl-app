# Этап 43 — Оптимизация системы цели и Макса (интерактивные чекпоинты)
### Задача 43.1: Миграции БД — partial updates и трекинг полей
- Файлы: `supabase/migrations/2025xxxx_431_goal_checkpoint_progress_and_core_goals_partial.sql`.
- Что сделать:
  1) Создать таблицу `goal_checkpoint_progress` с полями: `user_id uuid not null`, `version int not null`, `field_name text not null`, `completed_at timestamptz not null default now()`, `max_interaction_id uuid null`; PK `(user_id, version, field_name)`; индексы по `user_id, version`.
  2) Включить RLS (owner‑only): SELECT/INSERT/UPDATE/DELETE при `auth.uid() = user_id`.
  3) Обновить `core_goals`: гарантировать atomic partial‑updates `version_data` через JSONB‑merge (операторы `||`) и guard‑триггер «редактировать только последнюю версию» (блокировка старых версий и полей `user_id/version`).
  4) Добавить AFTER INSERT/UPDATE триггер на `core_goals`: при изменении `version_data` публиковать событие для Макса (через `pg_net` или безопасный HTTP‑вызов Edge; таймаут короткий, идемпотентность по `(user_id, version, field_name)`).
- Критерии приёмки: политики RLS применены, миграция повторноидемпотентна, Supabase Advisors (security/perf) — без критичных замечаний.

### Задача 43.2: Edge Function `leo-chat` — режим реакции на поле и промпты Макса
- Файлы: `supabase/functions/leo-chat/index.ts` (+ конфиг промптов, если вынесен).
- Что сделать:
  1) Добавить обработку события «goal_field_saved»/`mode: 'goal_comment'`: короткий ответ (2–3 предложения), без списания GP, без истории, с учётом версии и номера поля.
  2) Принять payload от триггера: `{user_id, version, field_name, field_value, all_fields}`; сформировать системный промпт по `goal-system-optimization.md` (тон, структура, локальный контекст), включая ветвления (v1/v2/v3/v4).
  3) Поддержать `recommended_chips` (по версии/шагу) — опционально возвращать массив подсказок.
  4) Гарантировать обратную совместимость существующих режимов `default/quiz/case` и параметра `bot='max'`.
- Критерии приёмки: корректные короткие ответы Макса, отсутствие PII/JWT в логах, контракт `/leo-chat` не ломается, smoke‑тест с фиктивным payload проходит.

### Задача 43.3: Клиент — чекпоинты v2/v3/v4 (шаговая форма + embedded‑чат)
- Файлы: `lib/screens/goal_checkpoint_screen.dart`, `lib/screens/leo_dialog_screen.dart`, `lib/repositories/goals_repository.dart`, `lib/providers/goals_providers.dart`.
- Что сделать:
  1) Разделить экран на `ChatSection` (~60%) и `FormSection` (~40%); автоскролл чата; инпут чата disabled (общение через форму).
  2) Реализовать пошаговую форму: активное поле; заполненные — read‑only с ✓; неактивные — disabled; прогресс‑индикатор «Поле X из Y».
  3) Валидации по версии (v1/v2/v3/v4) согласно `goal-system-optimization.md` (цифры/длины/сравнения/диапазоны/дата).
  4) Частичные сохранения: `GoalsRepository.upsertGoalField(version, fieldName, value)` → JSONB merge в `core_goals.version_data` + запись в `goal_checkpoint_progress`; после ack активировать следующее поле и сфокусировать его.
  5) Встроенный чат Макса: `LeoDialogScreen(embedded: true, bot: 'max', inputDisabled: true, recommendedChips: [...])`; сообщение реакций приходит автоматически от Edge.
- Критерии приёмки: линтеры чистые; переход по полям без рывков; офлайн‑фолбэк сохраняет ввод локально и доотправляет; реакции Макса отображаются без списания GP.

### Задача 43.4: Клиент — страница «Цель» (цитата, мини‑дашборд, путь)
- Файлы: `lib/screens/goal_screen.dart`, `lib/repositories/goals_repository.dart`, `lib/providers/goals_providers.dart`.
- Что сделать:
  1) Добавить collapsible‑цитату (автосворачивание через 5с, клик — разворот/сворачивание).
  2) Мини‑дашборд из 3 карточек: прогресс %, текущая неделя/фокус, streak чек‑инов.
  3) «Путь к цели» как аккордеон: текущая неделя развернута, прошлые — кратко, будущие — заблокированы.
  4) Обновить чек‑ин до 3 полей: `week_result` (≤100), `metric_value` (динамика из v2), `used_tools` (динамически из пройденных уровней); после сохранения — запуск короткой реакции Макса (без списания GP).
- Критерии приёмки: без overflow на мобильных, читабельные состояния, офлайн‑кеш и SWR работают, реакции Макса приходят после чек‑ина.

### Задача 43.5: Провайдеры и репозиторий целей — partial/SWR/Realtime
- Файлы: `lib/repositories/goals_repository.dart`, `lib/providers/goals_providers.dart`.
- Что сделать:
  1) Добавить `upsertGoalField(version, fieldName, value)` и `getGoalProgress(version)` (собирает заполненные поля из `goal_checkpoint_progress` + `core_goals.version_data`).
  2) Инвалидация `goalLatest/goalVersions` после завершения версии; `sprintProvider` — после чек‑ина.
  3) Подписка/поллинг на обновления чата Макса для активного чекпоинта (embedded‑режим), безопасные ретраи.
- Критерии приёмки: отсутствие гонок состояния, корректная инвалидация и обновление UI; линтеры без ошибок.

### Задача 43.6: Безопасность, GP и тесты
- Файлы: миграции, `leo-chat`, репозиторий/экраны, тесты в `test/**`.
- Что сделать:
  1) Подтвердить RLS на `goal_checkpoint_progress`; убедиться, что Edge/триггеры не логируют PII/JWT.
  2) Гарантировать, что реакции Макса на сохранение поля/чек‑ина не списывают GP; пользовательские сообщения остаются платными (1 GP).
  3) Тесты: unit (репозиторий partial/прогресс, валидации), widget (чекпоинт шаги + чат, GoalScreen), интеграционный сценарий v1→v4 + недельный чек‑ин (+ smoke для Edge реакции).
- Критерии приёмки: тесты проходят локально/CI; Sentry без новых ошибок; сценарии устойчивы к офлайн/ретраям.

### Задача 43.7: Настройка промптов и документация
- Файлы: `supabase/functions/leo-chat/index.ts` (секция промптов Макса), `docs/goal-system-optimization.md`, `docs/status.md`.
- Что сделать:
  1) Имплементировать системные промпты Макса по версиям/шагам (тон, структура ответа, локальный контекст) из `goal-system-optimization.md`.
  2) Описать контракт события «goal_field_saved» и пример payload в документации; добавить заметку об идемпотентности и ограничении длины ответов.
  3) Добавить запись в `docs/status.md` «Задача 43: …» после завершения ключевых подзадач.
- Критерии приёмки: промпты соответствуют ТЗ; документация обновлена; обратная совместимость `/leo-chat` сохранена.

# Этап 44 - Библиотека
### Задача 44.1: Миграция Библиотеки (MVP)
- Файлы: `docs/library-migration-sql.sql` (источник), `supabase/migrations/2025xxxx_441_library_init.sql` (копия для применения).
- Что сделать:
  1) Применить миграцию через supabase-mcp: создать таблицы `library_courses`, `library_grants`, `library_accelerators`, `library_favorites`, индексы и RLS-политики (SELECT для всех на контент, owner-only на избранное).
  2) Проверить Advisors (security/perf) и зафиксировать отсутствие критичных замечаний.
- Критерии приёмки: схемы и политики созданы; выборки по категориям и вставка/удаление в избранное выполняются для аутентифицированного пользователя; Advisors без критичных ошибок.

### Задача 44.2: Hardening миграции (минимальные улучшения)
- Файлы: `supabase/migrations/2025xxxx_442_library_hardening.sql`.
- Что сделать (добавочно, без ломающих изменений):
  1) Добавить триггеры `updated_at` (BEFORE UPDATE set new.updated_at=now()) для `library_courses/grants/accelerators`.
  2) Добавить FK: `library_favorites.user_id` → `auth.users(id)` ON DELETE CASCADE.
  3) Добавить CHECK: `resource_type IN ('course','grant','accelerator')`.
  4) Добавить составные индексы для сортировок: `(category, is_active, sort_order)` на три контентные таблицы.
  5) Перепроверить Advisors (security/perf).
- Критерии приёмки: миграция идемпотентна, схемы обновлены, индексы задействуются в планах запросов.

### Задача 44.3: Роутинг и доступ
- Файлы: `lib/routing/app_router.dart`.
- Что сделать:
  1) Добавить маршрут `/library` (внутри ShellRoute) с экраном «Библиотека».
  2) Доступ — только для аутентифицированных (используется существующий redirect на /login; отдельный гейтинг не требуется).
- Критерии приёмки: при неавторизованном входе на `/library` происходит редирект на `/login`; SentryNavigatorObserver остаётся подключён.

### Задача 44.4: Главная — активация карточки «Библиотека»
- Файлы: `lib/screens/main_street_screen.dart`.
- Что сделать:
  1) Перевести карточку «Библиотека» из состояния `soon` в `active` и повесить `onTap: context.go('/library')`.
  2) Сохранить существующий стиль карточки и поведение ошибок (SnackBar + Sentry) по аналогии с «Башня БизЛевел»/«База тренеров».
- Критерии приёмки: тап по «Библиотека» открывает экран `/library` без ошибок; тест `street_screen_test` обновлён на новый кейс (smoke).

### Задача 44.5: Репозиторий и провайдеры (SWR + офлайн)
- Файлы: `lib/repositories/library_repository.dart`, `lib/providers/library_providers.dart`.
- Что сделать:
  1) Создать `LibraryRepository` по паттерну Levels/Lessons/Goals (Hive SWR-кеш, ретраи, Sentry.captureException).
  2) Методы: `fetchCourses({category})`, `fetchGrants({category})`, `fetchAccelerators({category})`, `toggleFavorite(resourceType, resourceId)`, `fetchFavorites()`.
  3) Провайдеры: `libraryRepositoryProvider`, `coursesProvider(category)`, `grantsProvider(category)`, `acceleratorsProvider(category)`, `favoritesProvider`.
- Критерии приёмки: офлайн-кеширование работает; ошибки сети показываются дружелюбно; логи Sentry без PII.

### Задача 44.6: Экран «Библиотека» (хаб разделов)
- Файлы: `lib/screens/library/library_screen.dart`.
- Что сделать:
  1) Экран-хаб с заголовком и тремя карточками разделов: «Курсы», «Гранты и поддержка», «Акселераторы» + вкладка «Избранное».
  2) По возможности переиспользовать готовые виджеты (например, `StatCard`/стили карточек из проекта); новые создавать только при необходимости.
  3) Навигация в подразделы (в рамках `/library`, либо с внутренними табами/вкладками — без добавления новых роутов, чтобы минимизировать изменения).
- Критерии приёмки: соответствие концепции; адаптивность без overflow на мобильных и web.

### Задача 44.7: Подразделы «Курсы»/«Гранты»/«Акселераторы»
- Файлы: `lib/screens/library/courses_screen.dart`, `grants_screen.dart`, `accelerators_screen.dart`.
- Что сделать:
  1) Список категорий (грид карточек) → список элементов; карточки сворачиваются/разворачиваются; кнопка «↗» открывает внешнюю ссылку через `url_launcher`.
  2) Кнопка ⭐ избранного на карточке (переключение через репозиторий/провайдер, owner-only RLS соблюдается).
  3) Переиспользовать существующие базовые карточки/темы; собственные виджеты — только если необходимо.
- Критерии приёмки: фильтрация по категориям, сортировка по `sort_order`, стабильный UX и состояния загрузки/ошибки.

### Задача 44.8: «Избранное»
- Файлы: `lib/screens/library/favorites_screen.dart` (или вкладка на `LibraryScreen`).
- Что сделать:
  1) Отображение сохранённых карточек, группировка по типам (course/grant/accelerator).
  2) Удаление из избранного, счётчик.
- Критерии приёмки: операции избранного работают только для аутентифицированных; состояния (пусто/ошибка) корректны.

### Задача 44.9: Тесты
- Файлы: `test/screens/library/*_test.dart`, `test/repositories/library_repository_test.dart`.
- Что сделать:
  1) Widget-smoke: открытие `/library` с главной, переход в разделы, рендер списка.
  2) Unit: кэш SWR и `toggleFavorite` (mock SupabaseClient/Hive).
  3) Актуализация `street_screen_test.dart` под активную карточку «Библиотека».
- Критерии приёмки: тесты проходят локально/CI; линтеры без новых ошибок.

### Задача 44.10: Наблюдаемость, офлайн и доступность
- Файлы: экраны/репозиторий библиотеки.
- Что сделать:
  1) Дружелюбные SnackBar при ошибках, ретраи сети, офлайн-кеш из репозитория.
  2) Sentry.captureException на критических путях; без логирования PII/JWT.
  3) Semantics(label, button) на интерактивах; минимальные размеры ≥44 px.
- Критерии приёмки: отсутствуют RenderFlex overflow; ошибки логируются в Sentry без утечек.
