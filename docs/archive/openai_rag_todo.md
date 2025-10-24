1. Расширить схему Supabase для двусторонней синхронизации с OpenAI Retrieval

   - Добавить поля в существующую таблицу `public.documents`:
     - `openai_primary_file_id text` — основной `file_id` в OpenAI (если документ хранится одним файлом).
     - `sync_status text not null default 'pending'` — статусы: `pending | processing | synced | error`.
     - `last_sync_at timestamptz` — время последней успешной синхронизации.
     - `last_sync_error text` — диагностическое сообщение об ошибке синка.
     - `is_deleted boolean not null default false` — мягкое удаление для синхронного удаления в OpenAI.

   - Создать новую таблицу для хранения соответствий «документ → чанки/файлы в OpenAI» (один-ко-многим):

     ```sql
     create table if not exists public.document_files (
       id bigserial primary key,
       document_id bigint not null references public.documents(id) on delete cascade,
       chunk_index int not null,
       openai_file_id text not null,
       size_bytes int,
       status text not null default 'synced', -- synced | pending | error
       last_sync_at timestamptz,
       last_sync_error text,
       unique (document_id, chunk_index)
     );
     create index if not exists idx_document_files_doc on public.document_files(document_id);
     ```

     Пояснение: если документ большой, он будет разбит на чанки и загружен в OpenAI как несколько файлов. Для мелких документов можно хранить один файл и дублировать его `file_id` в `documents.openai_primary_file_id`.

   - Создать таблицу очереди задач синхронизации (управление upsert/delete и ретраями):

     ```sql
     create table if not exists public.document_sync_jobs (
       id bigserial primary key,
       document_id bigint not null references public.documents(id) on delete cascade,
       action text not null, -- upsert | delete
       status text not null default 'pending', -- pending | processing | done | error
       attempts int not null default 0,
       scheduled_at timestamptz not null default now(),
       processed_at timestamptz,
       last_error text
     );
     create index if not exists idx_document_sync_jobs_status on public.document_sync_jobs(status);
     create index if not exists idx_document_sync_jobs_doc on public.document_sync_jobs(document_id);
     ```

   - Что можно удалить из Supabase после стабильной работы Retrieval (по желанию):
     - Индексы ANN на `documents.embedding` и само поле `embedding` (pgvector) — если полностью переходим на Retrieval. Рекомендуется держать в режиме «read-only fallback» до стабилизации.

2. Скрипт синхронизации Supabase ↔ OpenAI (Node.js, cron/job)

   - Файл: `scripts/openai_retrieval_sync.ts` (Node 18+, TypeScript или JS).
   - Зависимости: `@supabase/supabase-js@^2`, `openai@^4`, `p-retry@^6`, `dotenv`.
   - Переменные окружения: `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`, `OPENAI_API_KEY`, `OPENAI_VECTOR_STORE_ID`.
   - Алгоритм upsert:
     1) Выбрать пачку задач из `document_sync_jobs` со `status='pending'` и `action='upsert'` (лимит, напр. 50).
     2) Для каждой задачи:
        - Получить документ из `public.documents` (поля: `id, content, metadata, is_deleted`). Если `is_deleted=true` — пересоздать задачу на `delete` и пропустить.
        - Разбить `content` на чанки по 800–1200 токенов с 10–15 % overlap. Примерно ориентироваться на 3–4 символа на токен.
        - Сформировать временные текстовые файлы или `.jsonl` (одна строка — один чанк). Имя файла должно включать `document_id` и `chunk_index`.
        - Загрузить чанки в OpenAI Vector Store:

          Вариант A (массовая загрузка):

          ```ts
          import OpenAI from 'openai';
          const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY! });

          // Рекомендуемый способ: батчем несколько файлов
          const batch = await openai.beta.vectorStores.fileBatches.uploadAndPoll({
            vector_store_id: process.env.OPENAI_VECTOR_STORE_ID!,
            files: chunkFileReadStreams /* массив fs.ReadStream */
          });
          // batch.status: 'completed' | 'failed' | 'cancelled' | 'in_progress'
          ```

          Вариант B (по одному файлу):

          ```ts
          // 1) Создать файл
          const file = await openai.files.create({
            file: fs.createReadStream(tmpFilePath),
            purpose: 'assistants'
          });
          // 2) Привязать к Vector Store
          await openai.beta.vectorStores.files.create(
            process.env.OPENAI_VECTOR_STORE_ID!,
            { file_id: file.id }
          );
          ```

        - Сохранить соответствия chunk_index → `openai_file_id` в `public.document_files` (upsert).
        - Обновить `documents.openai_primary_file_id` (если один файл), `documents.sync_status='synced'`, `documents.last_sync_at=now()`.
        - Обновить задачу `document_sync_jobs.status='done'`.
     3) Ошибки помечать как `status='error'`, инкрементировать `attempts`, писать `last_error`, ставить backoff (например, через cron повторно подхватится).

   - Алгоритм delete:
     1) Выбрать `document_sync_jobs` со `action='delete'`.
     2) Получить все `openai_file_id` из `public.document_files` для `document_id`.
     3) Удалить их из Vector Store:

        ```ts
        await openai.beta.vectorStores.files.del(
          process.env.OPENAI_VECTOR_STORE_ID!,
          fileId
        );
        // при необходимости: await openai.files.del(fileId);
        ```

     4) Удалить строки из `public.document_files`, обновить `documents.sync_status='synced'`, `is_deleted=true`, выставить `last_sync_at`.
     5) Пометить задачу `status='done'`.

   - Запуск: cron (GitHub Actions `schedule` + `workflow_dispatch`), либо системный cron на сервере. Пример GH Actions:

     ```yaml
     on:
       workflow_dispatch: {}
       schedule:
         - cron: '*/15 * * * *'
     jobs:
       sync:
         runs-on: ubuntu-latest
         steps:
           - uses: actions/checkout@v4
           - uses: actions/setup-node@v4
             with: { node-version: '20' }
           - run: npm i openai @supabase/supabase-js p-retry dotenv
           - run: node scripts/openai_retrieval_sync.js
             env:
               SUPABASE_URL: ${{ secrets.SUPABASE_URL }}
               SUPABASE_SERVICE_ROLE_KEY: ${{ secrets.SUPABASE_SERVICE_ROLE_KEY }}
               OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
               OPENAI_VECTOR_STORE_ID: ${{ secrets.OPENAI_VECTOR_STORE_ID }}
     ```

3. Добавление/удаление документов (поток данных)

   - Добавление/обновление:
     - При insert/update в `public.documents` вставлять запись в `document_sync_jobs` (`action='upsert'`). Это можно делать из приложения или через триггер Postgres.
     - Скрипт синка подхватывает задачу, бьёт на чанки, загружает в Vector Store, обновляет `document_files` и поля в `documents`.

     Пример триггера (опционально):

     ```sql
     create or replace function public.enqueue_document_upsert()
     returns trigger language plpgsql as $$
     begin
       insert into public.document_sync_jobs(document_id, action)
       values (new.id, 'upsert');
       return new;
     end; $$;

     drop trigger if exists trg_documents_upsert on public.documents;
     create trigger trg_documents_upsert
       after insert or update of content, metadata on public.documents
       for each row execute function public.enqueue_document_upsert();
     ```

   - Удаление:
     - При удалении в приложении — сначала `update public.documents set is_deleted=true where id=?`, затем вставить задачу `document_sync_jobs (action='delete')`.
     - Скрипт удаляет связанные файлы из Vector Store и чистит `document_files`.

4. Изменения в Supabase Edge Functions (leo-chat / leo-rag)

   - Переключатель режима RAG через переменную окружения: `USE_OPENAI_RETRIEVAL=true|false`.
   - Новая переменная: `OPENAI_VECTOR_STORE_ID` (общая для проекта; можно иметь несколько, но стартуем с одной).
   - В `leo-chat/index.ts` заменить локальный поиск (pgvector) на OpenAI Retrieval при включённом флаге. Сценарий с Responses API:

     ```ts
     import OpenAI from 'openai';
     const openai = new OpenAI();

     const useRetrieval = Deno.env.get('USE_OPENAI_RETRIEVAL') === 'true';
     const vectorStoreId = Deno.env.get('OPENAI_VECTOR_STORE_ID');

     if (useRetrieval && vectorStoreId) {
       const response = await openai.responses.create({
         model: Deno.env.get('OPENAI_MODEL') || 'gpt-4.1-mini',
         input: [
           { role: 'system', content: 'Ты — ИИ-ментор. Отвечай кратко и по делу.' },
           { role: 'user', content: lastUserMessage }
         ],
         tools: [{ type: 'file_search' }],
         tool_resources: {
           file_search: { vector_store_ids: [vectorStoreId] }
         }
       });
       const answer = response.output_text || '';
       // дальше использовать answer вместо контекста из pgvector
     } else {
       // fallback: текущая логика embeddings + match_documents
     }
     ```

   - В `leo-rag/index.ts` можно:
     - либо проксировать вызов Retrieval (возвращать найденные тезисы через Responses API),
     - либо пометить как deprecated и оставить `leo-chat` единой точкой входа.

5. Flutter-клиент остаётся без изменений

   - Клиент продолжает дергать те же Edge Functions (`leo-chat`). Вся логика выбора Retrieval/pgvector — на сервере (переменные окружения).

6. Ключи и доступ

   - Хранение секретов:
     - В Edge Functions: `OPENAI_API_KEY`, `OPENAI_MODEL` (опц.), `OPENAI_VECTOR_STORE_ID`, `USE_OPENAI_RETRIEVAL` — через Secret Manager Supabase.
     - В скрипте синка: через `.env.local` (вне репозитория) или GitHub Secrets (если cron в Actions).
     - Не хранить `SUPABASE_SERVICE_ROLE_KEY` в клиенте. Используется только в синк-скрипте и Edge Functions.

   - Права доступа:
     - Таблицы `document_files`, `document_sync_jobs` — закрыты RLS для клиентов; доступ только через сервис-роль/Edge Functions.
     - Клиент (Flutter) работает как и раньше — анонимный ключ + RLS для пользовательских данных, к документам доступ через Edge Function.

7. Первичная миграция и обратная совместимость

   - Шаги миграции:
     1) Применить миграции на создание таблиц `document_files`, `document_sync_jobs` и новые поля в `documents`.
     2) Подготовить `OPENAI_VECTOR_STORE_ID` (создать через API/консоль один раз).
     3) Запустить backfill-скрипт: для всех существующих документов создать задания `upsert` и дождаться окончания загрузки файлов в Vector Store.
     4) Включить `USE_OPENAI_RETRIEVAL=true` и проверить качество ответов.
     5) По результатам — оставить `documents.embedding` как fallback или удалить индексы/поле pgvector.

   - Создание Vector Store (однократно):

     ```ts
     const vs = await openai.beta.vectorStores.create({ name: 'bizlevel-knowledge' });
     // сохранить vs.id в переменную окружения OPENAI_VECTOR_STORE_ID
     ```

8. Ограничения и практические параметры

   - Размеры файлов и чанков: стараться держать чанк < 200–400 КБ текста; при необходимости дробить.
   - Метаданные: кодировать `level_id`, `skill_id`, `tags` в имени файла или в содержимом первой строки чанка. Тонкое управление метаданными в Vector Store пока ограничено, поэтому фильтрацию по уровню лучше оставлять на стороне промпта/контекста. Если потом понадобится делать “поиск только по level_id=2”, это в Retrieval напрямую не сделаешь. Это значит, что либо мета встраивается в текст чанка, либо фильтрация будет на уровне промпта. Это важно согласовать.
   - Ретраи: 3–5 попыток с экспоненциальным backoff. Логировать `last_sync_error`. Во избежание циклирования нужен механизм дедупликации (например, уникальный ключ document_id+action+scheduled_at::date).
   - Retrieval сам по себе бесплатный, но при каждом запросе к модели идёт внутренняя операция поиска по файлам → токены могут быть больше. Подводный камень: если документов станет много, стоимость “чата” вырастет.

9. Чек-лист готовности

   - [ ] Миграции применены; RLS закрыты для служебных таблиц
   - [ ] Создан `OPENAI_VECTOR_STORE_ID` и сохранён как секрет
   - [ ] Реализован и отлажен `scripts/openai_retrieval_sync.ts`
   - [ ] Выполнен backfill существующих документов
   - [ ] В Edge Functions включен `USE_OPENAI_RETRIEVAL`
   - [ ] Flutter клиент проходит сценарии без изменений

10. Параметры и стратегия

   1) Параметры чанкинга
      - Рекомендуемый размер чанка: 500–1000 токенов (≈350–700 слов)
      - Перекрытие чанков: 50–100 токенов
      - Включать в метаданные чанка: `doc_id`, `section`, `tags` для группового управления чанками (удаление/повторная индексация по документу или секции). Если используем `.jsonl`, хранить метаданные как JSON-поля рядом с текстом чанка; если загружаем `.txt`, включать мета как префикс первой строки.

   2) Синхронизация
      - Базовый вариант: запуск cron раз в сутки (ночью по серверному времени) — низкая нагрузка, предсказуемые окна.
      - Альтернатива (более «онлайн»): Postgres trigger на insert/update в `public.documents` → вставка задачи в `document_sync_jobs` → фоновый sync-скрипт подхватывает очередь (может крутиться как долгоживущий воркер или запускаться cron’ом чаще, например раз в 5–15 минут). Тут надо определиться, может предусмотреть ручное обновление,чтобы не ждать cron процесса. До этого бот не будет знать новую инфу.
      - Скрипт должен проверять `last_updated` (или `updated_at`, если есть) и синхронизировать только изменённые документы. Для этого в `document_sync_jobs` по upsertу повторно создавать задачу только когда `updated_at > last_sync_at`.

   3) Политика удаления и миграции
      - Переходный период: держать параллельно pgvector и Retrieval. Переключение источника знаний — через фича-флаг `USE_OPENAI_RETRIEVAL` в Edge Functions.
      - Удаление: использовать soft delete в Supabase (`is_active=false` или текущий `is_deleted=true`), а sync-скрипт создаёт задачу `delete` и удаляет связанные `openai_file_id` из Vector Store. Затем помечать в БД `sync_status='synced'`, обновлять `last_sync_at`.
      - Вести `sync_log` (можно как отдельную таблицу или логи в `document_sync_jobs`), фиксируя `doc_id`, список `chunk_ids`/`openai_file_id`, время загрузки/удаления и статус — для аудита и отладки.
      - После тестов и стабилизации: выпилить pgvector (поле `embedding` и индексы) или оставить как резервный fallback на ограниченный срок.

   4) Вопросы для согласования
      - Какой финальный размер чанков принять по умолчанию: 500 или 1000 токенов?
      - Частота синхронизации: cron раз в сутки (ночью) или событийная модель (через очередь задач, запуск чаще)?
      - Сколько времени держать параллельный режим pgvector+Retrieval до полного выключения pgvector?


