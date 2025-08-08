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
