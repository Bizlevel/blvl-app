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

\

# Этап 45 — UX/UI консолидация и дизайн‑система (на основе design-optimization(after_st44).md)

### Задача 45.1: Дизайн‑токены и базовая тема
- Файлы: `lib/theme/typography.dart` (новый), `lib/theme/spacing.dart` (новый), `lib/theme/color.dart` (обновить), `lib/main.dart` (подключить тему).
- Что сделать:
  1) `typography.dart`: определить базовый `TextTheme` (display/headline/title/body/label, h1–h6, caption, button) с размерами и межстрочными интервалами.
  2) `spacing.dart`: токены `xs=4, sm=8, md=12, lg=16, xl=24, 2xl=32, 3xl=48` + утилиты `insets(all,h,v)` и `gap(height|width)`.
  3) `color.dart`: ввести семантические роли (`primary/success/warning/error/info/surface/onSurface/border/divider/shadow`), убрать прямые `Colors.*`, устранить дубли (warning=premium), централизовать `withOpacity/withValues`.
  4) Подключить `ThemeData` в `main.dart` (или существующем месте) и настроить `ElevatedButtonTheme`, `TextButtonTheme`, `InputDecorationTheme`, `SnackBarThemeData`.
- Критерии приёмки: сборка без регрессий, отсутствие прямых `Colors.*` в теме, линтеры чистые.

### Задача 45.2: Стандартизация кнопок (BizLevelButton)
- Файлы: `lib/widgets/common/bizlevel_button.dart` (новый), замены в: `lib/screens/level_detail_screen.dart`, `lib/screens/leo_dialog_screen.dart`, `lib/screens/gp_store_screen.dart`, `lib/screens/profile_screen.dart`.
- Что сделать:
  1) Создать `BizLevelButton` c вариантами `primary | secondary | outline | text | danger | link`, размерами `sm | md | lg` и токенами отступов.
  2) Заменить inline `ElevatedButton.styleFrom(...)` и прямые цвета на `BizLevelButton` в перечисленных файлах (CTA «Завершить уровень», «Обсудить с Лео», «Проверить покупку», кнопки профиля).
- Критерии приёмки: визуальный паритет, единые размеры/отступы, без дублирования стилей.

### Задача 45.3: Карточки (BizLevelCard)
- Файлы: `lib/widgets/common/bizlevel_card.dart` (новый), замены в: `lib/screens/library/library_screen.dart`, `lib/screens/gp_store_screen.dart`, `lib/screens/profile_screen.dart`, `lib/screens/levels_map_screen.dart`, `lib/screens/main_street_screen.dart`.
- Что сделать:
  1) Создать `BizLevelCard` с преднастройками: radius, elevation, padding, тени по токенам.
  2) Заменить повторяющиеся `Container/Card` с одинаковыми стилями в указанных экранах.
- Критерии приёмки: визуальный паритет, снижение дублирования стилей.

### Задача 45.4: Единые состояния (Loading/Error/Empty)
- Файлы: `lib/widgets/common/bizlevel_loading.dart` (новый), `lib/widgets/common/bizlevel_error.dart` (новый), `lib/widgets/common/bizlevel_empty.dart` (новый);
  рефактор: `lib/screens/profile_screen.dart`, `lib/screens/levels_map_screen.dart`, `lib/screens/library/library_section_screen.dart`, `lib/screens/library/library_screen.dart`, `lib/screens/main_street_screen.dart`, `lib/screens/goal_checkpoint_screen.dart`, `lib/screens/leo_dialog_screen.dart`, `lib/screens/mini_case_screen.dart`.
- Что сделать:
  1) Ввести стандартные виджеты состояний: inline/fullscreen/sliver варианты загрузки; error с title/message/retry; empty с icon/title/subtitle/CTA.
  2) Заменить `.when(loading|error)` и `CircularProgressIndicator` на унифицированные компоненты.
- Критерии приёмки: единый стиль состояний, присутствует retry там, где есть загрузка из сети.

### Задача 45.5: Производительность списков (ListView.builder)
- Файлы: `lib/screens/library/library_screen.dart:202`, `lib/screens/gp_store_screen.dart:18`, `lib/widgets/leo_quiz_widget.dart:157`.
- Что сделать:
  1) Заменить `ListView(` → `ListView.builder` для потенциально длинных списков; исключение: короткие списки допускаются, но желательно унифицировать.
  2) Исключить изменения в auto‑generated файлах (`lib/models/lesson_model.freezed.dart`).
- Критерии приёмки: без регрессий скролла, нет лишних перерисовок.

### Задача 45.6: Accessibility и тестируемость (Semantics + Keys)
- Файлы: `lib/screens/levels_map_screen.dart`, `lib/screens/biz_tower_screen.dart`, `lib/screens/profile_screen.dart`, `lib/screens/leo_dialog_screen.dart` и ключевые карточки/CTA.
- Что сделать:
  1) Добавить `Semantics`/`semanticsLabel` для карточек уровней, узлов башни (как кнопок), аватара/артефактов/GP‑баланса, кнопок чата.
  2) Добавить `Key(...)` для критичных элементов (корневые экраны, карточки, CTA‑кнопки) для тестов.
- Критерии приёмки: a11y‑аудит без явных пропусков, виджеты доступны по ключам в тестах.

### Задача 45.7: Навигация и breadcrumbs
- Файлы: `lib/widgets/common/breadcrumb.dart` (новый), интеграция: `lib/screens/level_detail_screen.dart`, `lib/screens/library/library_section_screen.dart`.
- Что сделать:
  1) Добавить простой `Breadcrumb` (root → раздел → текущая страница) и вывести его на глубинных экранах.
  2) Стандартизировать поведение back (AppBar/gesture) через утилиту/mixin.
  3) Валидация deep links в `utils/deep_link.dart` (unit‑тесты на корректную нормализацию).
- Критерии приёмки: breadcrumb отображается корректно, back‑UX консистентен, тесты для deep‑links проходят.

### Задача 45.8: Mobile‑first и адаптивность
- Файлы: `lib/utils/responsive.dart` (новый), правки: 
  `lib/screens/library/library_section_screen.dart` (width 120/180 → адаптивные),
  `lib/screens/goal/widgets/weeks_timeline_row.dart` (width 120 → адаптивно),
  `lib/screens/goal/widgets/motivation_card.dart` (width 120),
  `lib/screens/goal/widgets/crystallization_section.dart` (width 180),
  `lib/widgets/user_info_bar.dart` (width 120),
  `lib/widgets/recommend_item.dart` (width 300),
  а также фиксированные height 290/420/180/190 (заменить на зависимые от размеров экрана/constraints).
- Что сделать:
  1) Ввести helpers: `isMobile/tablet/desktop`, breakpoints (напр. 600/1024/1400).
  2) Перевести фиксированные размеры на расчетные (проценты/ограничения).
- Критерии приёмки: отсутствие overflow, читабельность на мобайл/таблет/десктоп.

### Задача 45.9: Башня — консолидация темы
- Файлы: `lib/screens/biz_tower_screen.dart`, `lib/screens/tower/tower_grid.dart`, `lib/screens/tower/tower_painters.dart`, `lib/screens/tower/tower_tiles.dart`, `lib/screens/tower/tower_floor_widgets.dart`, `lib/screens/tower/tower_constants.dart`.
- Что сделать:
  1) Централизовать цвета путей/точек/стен через `AppColor`/локальный `TowerTheme`.
  2) Связать `kPathStroke/kCornerRadius/kPathAlpha` с токенами темы; убедиться в `RepaintBoundary` там, где нужно.
  3) Добавить `const` к статичным узлам/текстам.
- Критерии приёмки: визуальный паритет, отсутствие лишних перерисовок.

### Задача 45.10: Метрики, документация и тесты
- Файлы: `docs/status.md`, тесты `test/**` (screens/widgets/routing).
- Что сделать:
  1) После внедрения — обновить метрики (Color(0x..)/Colors./TextStyle/EdgeInsets/Semantics) в `design-optimization(after_st44).md`.
  2) Добавить запись в `docs/status.md` «Задача 45: UX/UI консолидация…» (≤5 строк, формат проекта).
  3) Тесты: smoke на `/library`, `/levels/:id`, состояния Loading/Error/Empty, breadcrumb рендер; unit на deep‑links.
- Критерии приёмки: тесты зелёные локально/CI, метрики улучшаются согласно целям.
