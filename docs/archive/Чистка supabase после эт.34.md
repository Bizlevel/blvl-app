## Отчёт по аудиту Supabase (BizLevel)

### 1) Область аудита и источники
- **Проект**: Supabase `acevqbdpzgbtqznbpgzr` (прод), схема `public`.
- **Клиент**: Flutter (GoRouter, Riverpod, репозитории + Hive SWR), см. `docs/status.md` и `docs/bizlevel-concept.md`.
- **Метод**: чтение схемы/политик/функций/триггеров через supabase-mcp; сопоставление с пользовательским флоу и текущим кодом.
- **Важно**: это аналитический отчёт. Изменений в БД/коде не выполнялось.

Ссылки внутри проекта:
- Статус-лог изменений: `docs/status.md`
- Концепция продукта: `docs/bizlevel-concept.md`
- Миграции БД: `supabase/migrations/`

### 2) Ключевая модель данных (связи и назначение)
- **`public.users`**: профиль пользователя и служебные поля доступа
  - Ключевые поля: `id(uuid, =auth.uid())`, `email`, `name`, `about`, `goal`, `is_premium`, `current_level`, лимиты чатов (`leo_messages_total`, `leo_messages_today`, `leo_reset_at`), `avatar_id`, `persona_summary`.
  - RLS: insert/select/update только для владельца (`auth.uid() = id`).
  - Создание записи: триггер `auth.on_auth_user_created → public.handle_new_user()`.

- **`public.levels`**: уровни контента
  - Поля: `id`, `number`, `title`, `description`, `is_free`, `artifact_*`, `image_url` (актуальная обложка), `cover_path` (legacy), `skill_id` (связь со `skills`).
  - Связи: `levels.skill_id → skills.id`; 1:N с `lessons` и `user_progress`.
  - RLS: SELECT доступен авторизованным.

- **`public.lessons`**: уроки уровня
  - Поля: `level_id`, `order`, `title`, `description`, `vimeo_id` (источник видео), `quiz_questions jsonb`, `correct_answers jsonb`.
  - Примечание: `video_url` сохранено для обратной совместимости, фактически не используется.
  - RLS: SELECT для авторизованных.

- **Прогресс и навыки**
  - `public.user_progress(user_id, level_id, current_lesson, is_completed, completed_at, updated_at)` — отметки завершения уровня (для доступа/аналитики).
  - `public.skills(id, name)` и `public.user_skills(user_id, skill_id, points, updated_at)` — дерево навыков и очки.
  - Обновление: RPC `public.update_current_level(p_level_id int)` — атомарно завершает уровень, повышает `users.current_level`, делает UPSERT в `user_skills` (+1 балл по `levels.skill_id`) и фиксирует прогресс.

- **Чаты тренеров**
  - `public.leo_chats(id, user_id, title, message_count, unread_count, summary, last_topics, bot in ('leo','max'))`.
  - `public.leo_messages(id, chat_id, user_id, role in ('user','assistant'), content, token_count)`.
  - Триггеры на `leo_messages`: `trg_leo_unread_after_insert` (непрочитанные), `trg_leo_messages_dedupe` (дедуп), `trg_call_leo_memory` → `call_leo_memory_trigger()` (вызов edge `leo-memory`).
  - Память: `public.user_memories` (upsert фактов по диалогам), служебная `public.leo_messages_processed` (идемпотентность).

- **Цель и 28-дневный путь**
  - `public.core_goals(user_id, version 1..4, goal_text, version_data jsonb)` — версии цели; триггеры: `tg_set_user_id`, `tg_set_updated_at`, `tg_core_goals_update_guard`.
  - `public.weekly_progress(user_id, sprint_number 1..4, поля чек-ина)` — прогресс по неделям.
  - `public.reminder_checks(user_id, day_number 1..28, reminder_text, is_completed)` — отметки напоминаний.
  - `public.motivational_quotes(quote_text, author, category, is_active)` — цитата дня (SELECT разрешён анонимно/авторизованным).

- **RAG хранилище**
  - `public.documents(content, metadata jsonb, embedding vector)` — основные документы для поиска.
  - `public.documents_backfill_map` — карта бэкфилла метаданных (служебно).
  - `public.docs_duplicate` — дубликат `documents` (временное/архивное).
  - RPC: `public.match_documents(...)`, актуальная перегрузка с `metadata_filter jsonb`.

- **Подписка/оплата** (контуры)
  - `public.subscriptions(user_id, status in ('trialing','active','past_due','canceled'), current_period_end)`.
  - `public.payments(user_id, amount, status, payment_method, bill_id/bill_url, confirmed_by/at)`.

### 3) Политики RLS (основное)
- `users`: insert/select/update только владелец.
- `levels`, `lessons`: SELECT при `auth.uid() IS NOT NULL`.
- `user_progress`: insert/update/select только владелец.
- `user_skills`: прямой DML запрещён (deny), SELECT владельцу.
- `leo_chats` и `leo_messages`: CRUD в рамках владельца (частично дублирующиеся политики с одинаковым смыслом для select/update — см. рекомендации ниже).
- `core_goals`, `weekly_progress`, `reminder_checks`: owner-only.
- `motivational_quotes`: SELECT `{anon, authenticated}`.
- `documents`: SELECT `{authenticated}`; DML — только `service_role`.

### 4) Функции и триггеры (используемые в флоу)
- RPC: `update_current_level(p_level_id int)` — завершение уровня + начисление навыков.
- Чат/память: `call_leo_memory`, `call_leo_memory_trigger`, `decrement_leo_message`, `reset_leo_unread`, `handle_leo_unread_after_insert`, `leo_messages_dedupe`.
- Служебные: `handle_new_user`, `tg_set_user_id`, `tg_set_updated_at`, `tg_core_goals_update_guard`, `update_updated_at_column`.
- RAG: `match_documents(...)` (актуальная версия с `metadata_filter jsonb`).

Ссылки на миграции (файлы):
- `20250717061935_add_updated_at_to_user_progress.sql`
- `20250717094528_create_update_current_level_function.sql`
- `20250806_add_skills_system.sql`, `20250806_update_rpc_for_skills.sql`
- `20250810_move_vector_to_extensions.sql`, `20250810_update_match_documents*.sql`
- `20250808_setup_leo_memory_trigger*.sql` (серия фиксов)
- `20250812_28_1_create_goal_feature_tables.sql`
- `20250815_30_3_rename_alex_to_max_v3.sql`
- `20250820_drop_update_current_level_overload.sql`

### 5) Пользовательский флоу → записи в БД
1) Регистрация → `auth.users` → триггер `handle_new_user()` создаёт `public.users` со стартовыми значениями (в т.ч. `current_level=0`).
2) Карта/Башня уровней → чтение `levels`/`lessons` (SELECT при авторизации); доступность платных уровней определяется по `users.is_premium` и завершённости предыдущего уровня (клиент+сервер).
3) Прохождение уровня → локальный прогресс уроков (клиент‑сайд провайдер), на завершении уровня: вызов `update_current_level(level_id)` → апдейт `users.current_level`, upsert в `user_skills`, фиксация `user_progress.is_completed=true`.
4) Чат Лео/Макс → `leo_chats` (бот в `bot = 'leo'|'max'`) и `leo_messages`; триггер памяти вызывает edge `leo-memory`, который должен upsert в `user_memories` и свёртки.
5) Цель/Спринты → CRUD в `core_goals`, `weekly_progress`, `reminder_checks`; цитата дня из `motivational_quotes`.
6) Подписка/оплата (контуры) → запись в `payments`/`subscriptions` (клиент сейчас использует `users.is_premium` как флаг доступа).

### 6) Фактическое использование (сводные метрики)
- `levels.image_url` заполнено: 11/11 — основная колонка обложки, используется клиентом.
- `levels.cover_path` заполнено: 10/11 — legacy‑поле (устаревшее, не является источником истины).
- `levels.is_free` = true: 4/11 — уровни 0–3 бесплатные (как в продуктовой логике).
- `lessons.vimeo_id` заполнено: 41/41; `lessons.video_url`: 0/41 — не используется.
- `user_progress.current_lesson != 1`: 0/22 — поле не отражает фактический прогресс уроков (управляется клиентом).
- `users.onboarding_completed`: true у 3/9 — онбординг перенесён в уровень 0; флаг по сути устаревший.
- `users.business_area`: 2/9; `users.experience_level`: 0/9 — данные почти не используются.
- `leo_chats.bot='max'`: 20/99 — бот Макс используется в части диалогов.
- `leo_messages.role='assistant'`: 155/359 — ответы ассистента пишутся корректно.
- `user_memories`: 0/0 — память пока не заполняется (см. рекомендации по конфигурации edge).
- `subscriptions`/`payments`: 0 записей — контуры есть, но реальный биллинг не задействован; доступ контролируется `users.is_premium`.

### 7) Что сейчас не влияет / устарело / дубликаты (с уточнениями)
- Колонки, фактически не используемые клиентом:
  - `levels.cover_path` — legacy (основной источник обложки — `image_url`).
  - `lessons.video_url` — весь контент использует `vimeo_id`/подписанные URL из Storage.
  - `users.onboarding_completed` — флаг сейчас не участвует в маршрутизации; факт онбординга определяется завершением Уровня 0 (см. ниже).
  - `users.business_area`, `users.experience_level` — НЕ удалять: зарезервированы для использования на Уровне 0 (профиль/персонализация тренеров).
  - `user_progress.current_lesson` — не отражает реальный прогресс уроков; шаги внутри уровня ведутся на клиенте (кэш провайдера/SharedPreferences/Hive).
- Таблицы:
  - `docs_duplicate` — дубликат `documents` (служебная/временная); не используется клиентом.
  - `documents_backfill_map` — служебно для ETL; если бэкфилл завершён и карта не нужна — кандидат на архивирование/удаление.
- Политики RLS (дубли по смыслу):
  - `leo_chats`: дублирующие SELECT/UPDATE политики — одновременно присутствуют `Users can view own chats` и `select_own` (SELECT), а также `Users can update own chats` и `update_own` (UPDATE). Вероятно, появились при итеративном усилении RLS между ранними миграциями (`initial_schema` 20250710) и `20250724_missing_rls`, когда добавлялись дополнительные политики без удаления базовых.
  - `payments`: аналогично продублированы INSERT/SELECT — `Users can create payments` и `insert_own_payments` (INSERT), `Users can view own payments` и `view_own_payments` (SELECT). По времени — вероятно в период `initial_schema` → `20250724_add_subscriptions`/`20250724_missing_rls`.

Пояснения:
- Онбординг: в текущей логике онбординг рассматривается как прохождение Уровня 0. Признаки: наличие `user_progress.is_completed=true` для `level_id=0` и/или `users.current_level >= 1`. Флаг `users.onboarding_completed` не требуется для гейта и не используется напрямую в роутинге.
- Прогресс уроков: хранится локально на клиенте (провайдер `lesson_progress_provider` + SharedPreferences/Hive), серверная БД фиксирует только завершение уровня (кнопка «Завершить уровень» → RPC `update_current_level`).

### 8) Рекомендации по оптимизации (без внесения изменений сейчас)
1) Подготовить пакет «чистки колонок» (после ревью клиентского кода):
   - Потенциально удалить: `levels.cover_path` (legacy), `lessons.video_url`, опционально `users.onboarding_completed` (если не нужен для аналитики), и `user_progress.current_lesson` (если не планируется серверное хранение промежуточных шагов).
   - Сохранить: `users.business_area`, `users.experience_level` — использовать на Уровне 0 (профиль/персонализация).
   - Проверки: отсутствие обращений к удаляемым полям в коде/тестах; подтверждение, что источником обложек является `levels.image_url`.

2) Консолидация RLS‑политик:
   - Свести дубликаты в `leo_chats` и `payments` к одной политике на команду (SELECT/UPDATE/INSERT).
   - Перепроверить пермиссивность/ссылки на `auth.uid()` и роли.

3) Память диалогов (`user_memories`):
   - Проверить секреты edge‑функции `leo-memory` (`CRON_SECRET`, ключи OpenAI и доступ к `pg_net`), перезапустить деплой.
   - Убедиться, что `call_leo_memory_trigger()` вызывает актуальную сигнатуру `call_leo_memory(p_message_id, p_chat_id, p_user_id, p_content, p_level_id default null)` — лишние перегрузки миграцией удалены.

4) Премиум‑доступ и биллинг:
   - Источник правды: планово перенести с `users.is_premium` на `subscriptions.status in ('trialing','active')` + live‑провайдер; `is_premium` оставить как кеш/предвычисление (опционально) или удалить после миграции.

5) RAG‑хранилище:
   - Если `docs_duplicate` не нужен для отката/архива — удалить.
   - Если `documents_backfill_map` не используется в текущем ETL — снять из эксплуатации/удалить.

6) Документация и тесты:
   - Зафиксировать план миграций в `docs/status.md` и добавить тесты на отсутствие обращений к удаляемым полям.

### 9) Проверенные артефакты (отсылки)
- Миграции (образцы):
  - `20250717061935_add_updated_at_to_user_progress.sql`
  - `20250717094528_create_update_current_level_function.sql`
  - `20250806_add_skills_system.sql`
  - `20250806_update_rpc_for_skills.sql`
  - `20250810_move_vector_to_extensions.sql`
  - `20250810_update_match_documents*.sql`
  - `20250808_setup_leo_memory_trigger*.sql` и последующие фиксы
  - `20250812_28_1_create_goal_feature_tables.sql`
  - `20250815_30_3_rename_alex_to_max_v3.sql`
  - `20250820_drop_update_current_level_overload.sql`

### 10) Резюме
- Схема соответствует целям BizLevel: уровни/уроки, прогресс/навыки, чат Лео/Макс, цели/спринты, RAG.
- Выявлены устаревшие или неиспользуемые элементы (колонки, дубликаты политик, служебные таблицы).
- Для оптимизации предлагается пошаговый план чистки и консолидации без изменения поведенческой логики.

Отчёт подготовлен без выполнения DDL/DML — только анализ и сопоставление с текущим клиентским кодом.

### 11) План аккуратной чистки (без изменения поведения)

Этап A — валидация использования
- По коду (поиск): убедиться, что нет обращений к `levels.cover_path`, `lessons.video_url`, `users.onboarding_completed`, `user_progress.current_lesson` (grep по репозиторию, включая тесты/моки/строки SQL).
- По данным supabase-mcp: повторно проверить заполненность полей и отсутствие внешних зависимостей (например, BI/аналитика) — согласовать с владельцами аналитики.
- По маршрутам: подтвердить, что онбординг определяется завершением Уровня 0 (а не флагом в профиле).

Этап B — подготовительные миграции (обратимая стадия)
- Обложки уровней: подтвердить, что источник истины — `levels.image_url`.
- RAG: подтвердить, что `docs_duplicate` и/или `documents_backfill_map` не используются текущим ETL; если используются — подготовить экспорт/архив.

Этап C — изменения схемы (последовательно, малыми порциями)
- Удаление legacy-колонок:
  - `levels.cover_path` (legacy вместо `image_url`).
  - `lessons.video_url` (не используется; весь видео-контент через `vimeo_id`/подписанные ссылки).
  - Опционально: `users.onboarding_completed` (если не нужен даже для аналитики), `user_progress.current_lesson` (если не планируется серверное хранение промежуточных шагов).
- Консолидация RLS-политик:
  - `leo_chats`: оставить по одной политике на команду (SELECT/UPDATE), удалить дубликаты (`select_own`/`view own`, `update_own`/`update own`).
  - `payments`: аналогично — свести INSERT/SELECT к единичным политикам.
- Архивация служебных таблиц (после подтверждения):

Этап D — конфигурация и активация памяти чатов (не чистка, но важная связанная задача)
- Edge `leo-memory`: задать секреты (`CRON_SECRET`, OpenAI), убедиться в доступе к `pg_net`, задеплоить; проверить, что `call_leo_memory_trigger()` вызывает актуальную сигнатуру RPC (перегрузки удалены).

Этап E — деплой и контроль
- Прогнать миграции на staging, выполнить smoke-тесты сценариев (регистрация → Уровень 0 → Уровень 1 → чат Лео/Макс → страница «Цель» → RAG-запросы).
- Наблюдаемость: проверить логирование Sentry (критические ошибки), Supabase Advisors, валидность RLS.

Примеры безопасных DDL (черновик):
```sql
-- после валидации
alter table public.levels drop column if exists cover_path;
alter table public.lessons drop column if exists video_url;

-- опционально, если принято решение удалять
alter table public.users drop column if exists onboarding_completed;
alter table public.user_progress drop column if exists current_lesson;

-- удаление дубликатов политик (пример для leo_chats)
drop policy if exists select_own on public.leo_chats;
drop policy if exists update_own on public.leo_chats;
```

### 12) Контрольный список проверок и тестов
- Глобальный поиск по коду на упоминания удаляемых полей/таблиц (включая тесты и фикстуры).
- Юнит/виджет/интеграционные тесты: сборка Web/iOS/Android, сценарии уровней 0–1, чат Лео/Макс, страница «Цель», RAG.
- Ручная проверка RLS: чтение/запись от имени владельца и чужого пользователя (ожидаемый deny).
- Supabase Advisors: отсутствие новых предупреждений security/performance.
- Наблюдение Sentry 24–48 часов: отсутствие новых критических ошибок после миграций.

### 13) Порядок выката
1) Ветка feature/cleanup → CI (тесты/линт/анализаторы).
2) Staging с копией данных: накатываем миграции частями (начала с колонок без использования и консолидации RLS).
3) Продуктовая проверка сценариев на staging, ревью аналитики.
4) Прод: накатываем миграции пачками с паузами и мониторингом Sentry.

### 14) План отката
- Все DDL формировать как обратимые скрипты (напр., предварительно `rename column` → период наблюдения → `drop column`).
- Перед удалением таблиц/политик — SQL-дамп объектов и зависимостей (описания/политики/индексы).
- В случае регресса — мгновенный откат миграции, восстановление дампов.

### 15) Риски и смягчение
- Ошибка в RLS при консолидации — риск потери доступа: смягчение — тесты RLS и staged rollout.
- Скрытая зависимость аналитики от флага `onboarding_completed`: смягчение — представление `user_onboarding_status`.
- Удаление колонок, используемых в отчётах/дампах: смягчение — инвентаризация потребителей, коммуникация с командами.
- Долг в Edge-секретах (память чатов): смягчение — подготовить конфигурацию и чек-лист перед включением.


