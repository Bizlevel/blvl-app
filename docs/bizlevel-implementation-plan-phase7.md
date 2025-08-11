# Этап 26: Улучшение Лео

### Задача 26.1: База данных — персонализация и долговременная память
- Файлы: `supabase/migrations/YYYYMMDD_add_personalization_and_memories.sql`
- Таблицы/колонки:
  - `users.persona_summary text NULL` — краткая персональная сводка (персона) пользователя, используется в системном промпте.
  - `leo_chats.summary text NULL`, `leo_chats.last_topics jsonb NOT NULL DEFAULT '[]'` — свёртка чата и последние темы.
  - Новая таблица `user_memories`:
    - `user_id uuid NOT NULL` (FK → `users.id`),
    - `content text NOT NULL`,
    - `embedding vector(1536) NULL`,
    - `weight integer NOT NULL DEFAULT 1`,
    - `created_at timestamptz NOT NULL DEFAULT now()`,
    - `updated_at timestamptz NOT NULL DEFAULT now()`,
    - PK `(user_id, content)` или surrogate `id uuid` — выбрать один вариант; рекомендуется `id uuid DEFAULT gen_random_uuid()`.
  - Индексы:
    - HNSW для векторного поиска: `CREATE INDEX IF NOT EXISTS user_memories_embedding_hnsw ON public.user_memories USING hnsw (embedding vector_cosine_ops) WITH (m=16, ef_construction=64);`
    - По пользователю/времени: `CREATE INDEX IF NOT EXISTS user_memories_user_time_idx ON public.user_memories(user_id, updated_at DESC);`
  - Политики RLS: enable RLS; SELECT/INSERT/UPDATE/DELETE только для `auth.uid() = user_id`.
- Проверка: через `supabase-mcp` применить миграцию, убедиться, что таблицы/колонки появились, индексы созданы, RLS активен.

### Задача 26.2: Оптимизация RAG и объединение запросов (уменьшение RTT)
- Файлы: `supabase/functions/leo-chat/index.ts`
- Что делать:
  1) Перенести логику RAG из `leo-rag` внутрь `leo-chat`: при наличии запроса строить embedding (модель `text-embedding-3-small`), вызывать `rpc('match_documents', { query_embedding, match_threshold: 0.3..0.4, match_count: 5..8 })`, собрать контекст (сжатый).
  2) Добавить фильтрацию по метаданным (если передан текущий уровень/скилл): использовать `documents.metadata->>'level_id'`/`skill_id` в RPC/фильтрах.
  3) Скомбинировать: `persona_summary` → `user_memories` (top-K по сходству) → `RAG контекст` → системный промпт. Не менять текущий формат ответа `{ message, usage }`.
- Backward compatibility: оставить поддержку текущего запроса от клиента (поле `knowledgeContext` опционально игнорировать). `leo-rag` не удалять на этом этапе.
- Проверка: локальный вызов функции с тем же payload, что сейчас отправляет `LeoService`, должен возвращать ответ без деградации.

### Задача 26.3: Быстрый доступ к «персоне» и кэширование контекстов в функции
- Файлы: `supabase/functions/leo-chat/index.ts`
- Что делать:
  1) Загружать `users.persona_summary`; если пусто — формировать on-the-fly из `users.{name, about, goal, business_area, experience_level}` (fallback).
  2) Ввести in-memory кэш (глобальные переменные модуля Deno) на 2–5 минут для `persona_summary` и результатов `match_documents` по `(user_id, last_query_hash)`.
  3) Ограничить итоговый объём контекста (truncate по токенам), использовать сжатие чанков (краткие тезисы) перед добавлением в системный промпт.
- Проверка: несколько последовательных запросов возвращают ответы быстрее (нет лишнего повторного поиска), при смене пользователя кэш не конфликтует.

### Задача 26.4: Долговременная память — извлечение фактов из диалогов
- Файлы: `supabase/functions/leo-memory/index.ts` (новая Edge Function)
- Что делать:
  1) Реализовать эндпоинт, принимающий список свежих сообщений чата и возвращающий JSON c массивом «памяток» (atomic facts/preferences/goals).
  2) Для каждой «памятки» считать embedding (тот же модельный размер), upsert в `user_memories` (по `(user_id, content)` или `id`).
  3) Добавить лёгкую нормализацию текста (обрезка, нижний регистр для ключей, удаление PII, если нужно).
- Проверка: ручной вызов функции создаёт записи в `user_memories`; повторный вызов не плодит дубликаты (upsert).

### Задача 26.5: Фоновый запуск извлечения памяти
- Инструменты: Supabase Scheduled Functions (Cron)
- Что делать:
  1) Создать расписание (каждые 1–5 минут) на вызов `leo-memory` с секретным заголовком.
  2) Внутри `leo-memory` выбирать «необработанные» сообщения за последний интервал (по `leo_messages.created_at`) и помечать обработанные (сервисный маркер в Redis/таблице `leo_messages_processed` — создать простую таблицу id/timestamp).
- Таблицы: при необходимости добавить `leo_messages_processed(id uuid PK, processed_at timestamptz)` с RLS=OFF (только service-role).
- Проверка: память пополняется после диалогов, повторная обработка не происходит.

### Задача 26.6: Улучшение `documents` (metadata и индексы) для точного/быстрого RAG
- Файлы: `supabase/migrations/YYYYMMDD_optimize_documents_for_rag.sql`
- Исходное состояние (подтверждено): в `metadata` только `file_id`, `file_name`, `chunk_index`, `total_chunks`; ключей `level_id/skill_id/title/section/tags` нет; индекс по embedding — `ivfflat`, GIN по metadata отсутствует.
- Что делать:
  1) Индексы по embedding:
     - Зафиксировать стандарт: перейти на HNSW (если доступна pgvector ≥ 0.7) —
       `CREATE INDEX IF NOT EXISTS documents_embedding_hnsw ON public.documents USING hnsw (embedding vector_cosine_ops) WITH (m=16, ef_construction=64);`
     - Если HNSW недоступен — оставить существующий `ivfflat` как фолбэк, задокументировать выбор.
  2) Индексы по metadata:
     - `CREATE INDEX IF NOT EXISTS documents_metadata_gin ON public.documents USING gin (metadata);`
  3) Обогащение metadata (без изменения схемы столбцов):
     - Добавить ключи: `level_id` (int), `skill_id` (int), `title` (string), `section` (string), `tags` (string[]), где они отсутствуют.
     - В миграции предусмотреть бэкфилл существующих строк: `UPDATE documents SET metadata = metadata || jsonb_build_object(...)` на основе временного маппинга (см. задачу 26.12) и/или эвристик по `file_name`.
  4) Параметризовать пороги поиска: оставить `match_threshold`/`match_count` как настраиваемые через ENV/RPC параметры.
- Проверка: `rpc('match_documents', ...)` с `metadata`-фильтрами по `level_id/skill_id` работает, время ответа сокращается (за счёт HNSW/GIN и фильтров), содержимое metadata содержит новые ключи.

### Задача 26.7: Клиент — минимальная адаптация без поломок
- Файлы: `lib/services/leo_service.dart`, `lib/screens/leo_dialog_screen.dart`
- Что делать:
  1) Обновить `sendMessage`/`sendMessageWithRAG` на единый вызов `/leo-chat` (с флагом `enableRag: true`), без отдельного запроса в `/leo-rag`. Сохранить текущий контракт ответа.
  2) Поля `userContext`/`levelContext` оставить как опциональные (передавать можно, но функция теперь сама формирует персонализацию из БД). Backward compatible.
  3) Логика сохранения сообщений/лимитов не меняется.
- Проверка: текущие UI-потоки работают как прежде, количество сетевых запросов на одно сообщение стало меньше.

### Задача 26.8: Свёртки чатов
- Файлы: `supabase/functions/leo-memory/index.ts`, `supabase/migrations/YYYYMMDD_add_chat_summaries.sql`
- Что делать:
  1) В `leo-memory` после обработки батча сообщений формировать обновлённую `leo_chats.summary` (короткая выжимка) и `last_topics` (массив строк, max 5), `updated_at = now()`.
  2) При старте нового чата в `leo-chat` подтягивать 2–3 последних релевантных `summary` пользователя (по темам — через быстрый string-similarity/вектор `user_memories`).
- Проверка: новая сессия получает контекст прошлых бесед (без длинного history), LLM отвечает «помня» прошлый опыт.

### Задача 26.9: Качество поиска — гибрид и реранк
- Файлы: `supabase/functions/leo-chat/index.ts`, `supabase/migrations/YYYYMMDD_update_match_documents.sql`
- Что делать:
  1) В `match_documents` добавить параметр `metadata_filter jsonb DEFAULT '{}'` и/или отдельные параметры (уровень, скилл), применять WHERE-фильтры до ANN.
  2) В `leo-chat` после top-K ANN запустить лёгкий re-rank (OpenAI rerank или эвристика по tf-idf/BM25 через полнотекстовый индекс). В проде — фича-флаг.
- Проверка: ответы чаще ссылаются на корректные разделы учебника, уместность выше.

### Задача 26.10: Пайплайн загрузки/чанкования документов и бэкфилл metadata
- Файлы: `scripts/upload_from_drive.py`, `supabase/migrations/YYYYMMDD_documents_metadata_backfill.sql`
- Что делать:
  1) Обновить пайплайн чанкования в `scripts/upload_from_drive.py`:
     - использовать токенизацию (напр. `tiktoken`) и целевой размер 300–500 токенов с перекрытием;
     - извлекать и сохранять заголовки/подзаголовки в metadata: `title`, `section`, `tags`;
     - при наличии маппинга — добавлять `level_id`/`skill_id` в metadata при загрузке.
  2) Бэкфилл для существующих строк:
     - подготовить временную таблицу маппинга `documents_backfill_map(file_id text PRIMARY KEY, level_id int, skill_id int, title text, section text, tags text[])` (заполняется вручную/скриптом);
     - миграцией выполнить `UPDATE documents d SET metadata = d.metadata || jsonb_build_object('level_id', m.level_id, 'skill_id', m.skill_id, 'title', m.title, 'section', m.section, 'tags', to_jsonb(m.tags)) FROM documents_backfill_map m WHERE m.file_id = (d.metadata->>'file_id');`
     - по завершении — удалить/очистить временную таблицу.
- Проверка: новые документы загружаются с полной metadata; существующие получают заполненные `level_id/skill_id/title/section/tags`; выборки с фильтрами работают.

### Задача 26.11: Тесты
- Файлы:
  - Новые: `test/edge/leo_memory_function_test.md` (док-тест сценариев), `test/rag/rag_quality_test.dart` (offline-проверка hit@k по эталонным запросам),
  - Обновить: `test/leo_integration_test.dart` (путь один к `/leo-chat`), `test/services/leo_service_unit_test.dart` (контракт ответа без `leo-rag`).
- Что делать:
  1) Добавить фикстуры эталонных вопросов/ответов по ключевым темам уровней.
  2) Проверить, что количество сетевых вызовов за отправку сообщения уменьшилось (без регрессий UI).
- Проверка: тесты зелёные, rag-тесты демонстрируют стабильный hit@k и скорость.

### Задача 26.12: Контроль рисков и обратная совместимость
- Не удалять `supabase/functions/leo-rag` до завершения 26.7 и прохождения интеграционных тестов.
- `leo-chat` должен принимать старый payload (со старыми полями) и корректно работать без них.
- Миграции БД — только additive (новые колонки/таблицы/индексы). Изменять существующие поля/политики RLS — запрещено на этом этапе.

### Задача 26.13: Надёжный запуск памяти и свёрток без cron (триггер + защита)
- Файлы: `supabase/functions/leo-memory/index.ts`, SQL (триггеры/функции), `supabase/functions/leo-chat/index.ts` (опционально)
- Что сделать:
  1) Триггер AFTER INSERT на `leo_messages` для `role='assistant'` (уже есть). Уточнить условие: `WHEN NEW.role='assistant' AND COALESCE(NEW.is_final, true)` во избежание зацикливания и полу-сообщений.
  2) Вызов `leo-memory` делать через `pg_net` с малым таймаутом (2–3 сек) и без ожидания длинной работы. Рекомендуемый ответ функции — 202.
  3) В `http_post` передавать payload (минимум `message_id`, `chat_id`, `user_id`, `content`, опц. `level_id`) — чтобы избежать гонки чтения незакоммиченной строки и повысить детерминизм.
  4) Идемпотентность: в `leo-memory` перед upsert в `user_memories` отмечать сообщение в `leo_messages_processed` (UPSERT по `message_id`) и пропускать повторную обработку.
  5) Исключить петлю: `leo-memory` не должно писать новые сообщения в `leo_messages`. Если потребуется служебная запись — добавлять флаг источника в метаданные и фильтровать в триггере.
  6) Безопасность секрета: хранить `CRON_SECRET` не в общедоступной таблице; как минимум — включить RLS на `public.app_settings` (deny для пользователей), либо перенести секрет в ENV Edge Function и не хранить в БД.
  7) Структура контекста уровня: клиент или сервер должны формировать `levelContext` в структурном виде (`{"level_id":6}` или строка `level_id: 6`) — это включает `metadata_filter` и повышает точность RAG.

### Задача 26.14: Ручная настройка в Supabase (пошагово)
- Цель: обеспечить запуск памяти и свёрток без cron, защитить секреты, включить точный RAG.
- Шаги:
  1) Открыть Supabase → Edge Functions → `leo-memory` → Environment → добавить/установить `CRON_SECRET=<секрет>` → redeploy.
  2) SQL Editor → выполнить: `update public.app_settings set value='<тот_же_секрет>' where key='leo_memory_cron_secret';` (если используется посредник через таблицу).
  3) Защитить секреты: включить RLS на `public.app_settings`. Создать политики deny‑all для анонимных/авторизованных ролей. (Edge Functions с service-role продолжают работать.)
  4) Проверить/включить расширение `pg_net` (Extensions → pg_net → enable), если ещё не активно.
  5) Убедиться, что триггер `trg_call_leo_memory` существует на `public.leo_messages` и вызывает `public.call_leo_memory()` при `role='assistant'`.
  6) В клиенте обеспечить структурный `levelContext` при вызове `/leo-chat` (например `{"level_id":6}`), либо передавать строку `level_id: 6`.
  7) Прогнать проверку: отправить сообщение → ответ ассистента → через ~сек проверить `user_memories` (новые записи), `leo_chats.summary/last_topics` (заполнены). Новый чат должен получить блок «Итоги прошлых обсуждений» в системном промпте и корректно отвечать на вопрос про прошлый диалог.

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

