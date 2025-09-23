# PROJECT ANALYSIS REPORT - BizLevel AI Bots

## 1. Project Architecture Overview
Flutter (Riverpod) + Supabase (Auth, PostgREST, Edge Functions). Точка входа: `lib/main.dart` — инициализация `.env`, Supabase, Sentry, Hive, уведомлений, FCM, роутинг. Доступ к Supabase: `lib/services/supabase_service.dart` (инициализация клиента, универсальная обработка ошибок PostgREST). State: Riverpod провайдеры (`lib/providers`). UI: экраны в `lib/screens`, компоненты `lib/widgets`. БД и серверная логика: `supabase/migrations` (SQL) и `supabase/functions` (Edge Functions: `leo-chat`, `leo-memory`, `leo-rag`, др.). RAG и персонализация встроены в `/functions/v1/leo-chat`.

## 2. Leo Bot Components
### 2.1 Frontend Components
- `lib/screens/leo_chat_screen.dart`: список чатов Лео/Макс, переключатель бота, открытие `LeoDialogScreen` с `userContext` и `levelContext`.
- `lib/screens/leo_dialog_screen.dart`: основной UI диалога; пагинация сообщений из `leo_messages`, отправка в Edge Function через `LeoService.sendMessageWithRAG`, сохранение сообщений в `leo_chats/leo_messages`, обработка режимов кейсов (вставка `system` промпта для кейса).
- `lib/services/leo_service.dart`: HTTP-клиент (Dio) для вызова `/functions/v1/leo-chat` с заголовками `Authorization: Bearer <ANON_KEY>`, `x-user-jwt: <user JWT>`; методы: `sendMessage`, `sendMessageWithRAG` (основной), `sendQuizFeedback` (mode=quiz), `saveConversation` (insert в `leo_chats`/`leo_messages`), `resetUnread`, `saveAiMessageData`.
- `lib/providers/leo_service_provider.dart`: DI-провайдер `LeoService`.
- `lib/providers/leo_unread_provider.dart`: стрим `unread_count` по чату из `leo_chats`.
- `lib/widgets/leo_quiz_widget.dart`: локальный UI для короткой проверки знаний; обращается к `LeoService.sendQuizFeedback` (mode=quiz) и выводит ответ Лео.

### 2.2 Backend Functions
- `supabase/functions/leo-chat/index.ts`: основная Edge Function чата. Режимы: default (leo/max), `quiz`, `goal_comment`, `weekly_checkin`. Интеграции: OpenAI Chat Completions, OpenAI Embeddings, Supabase Admin/Auth. Встроенный RAG (см. 4). Персонализация из профиля, памяти и свёрток прошлых чатов. Сохраняет стоимость токенов в `ai_message` (через insert). Формирует системные промпты для Лео и Макса (полные тексты ниже).
- `supabase/functions/leo-memory/index.ts`: извлекает факты из недавнего диалога, нормализует (без PII), рассчитывает эмбеддинги батчем и upsert в `user_memories`. Обновляет `leo_chats.summary/last_topics`. Работает из триггера и прямого вызова.
- `supabase/functions/leo-rag/index.ts`: вспомогательная функция для поиска контекста по `match_documents` (может использоваться в отладке/скриптах).

### 2.3 Component Interaction Flow
1) Клиент (`LeoDialogScreen`) шлёт сообщения → `LeoService.sendMessageWithRAG` → Edge `/leo-chat` с `messages`, `userContext`, `levelContext`, `bot`, `x-user-jwt`.
2) Edge валидирует env, извлекает профиль по JWT, собирает персонализацию, последнюю память и свёртки. Если `bot != max`, выполняет RAG: embeddings → `rpc('match_documents')` с фильтрами → сжатие контекста.
3) Формируется системный промпт (Leo или Max) + messages → OpenAI → ответ. Возврат `message`, `usage`, опционально `recommended_chips` для Макса. Стоимость сохраняется в `ai_message`.
4) Клиент сохраняет сообщения в `leo_messages`/`leo_chats`. Триггер БД вызывает `leo-memory`, которая извлекает факты и обновляет `user_memories` и `leo_chats.summary/last_topics`.

## 3. System Prompts Inventory
### 3.1 Main System Prompts
- Файл: `supabase/functions/leo-chat/index.ts` — Leo (фрагмент):
```supabase/functions/leo-chat/index.ts
## КРИТИЧЕСКОЕ ОГРАНИЧЕНИЕ ПО ПРОГРЕССУ (ПЕРВЫЙ ПРИОРИТЕТ):
Пользователь прошёл уровней: ${maxCompletedLevel}. 
... [полный текст от L919..L997 в файле]
```

- Файл: `supabase/functions/leo-chat/index.ts` — Max:
```supabase/functions/leo-chat/index.ts
## Твоя роль и тон:
Ты — Макс, трекер цели BizLevel. 
... [полный текст от L1000..L1055 + правила v2/v3/v4 L1070..L1082]
```

- Файл: `supabase/functions/leo-chat/index.ts` — режимы goal_comment и weekly_checkin используют короткие `basePrompt` Макса:
```supabase/functions/leo-chat/index.ts
const basePrompt = `Ты - Макс, трекер целей BizLevel...` (L307..L310)
const basePrompt = `Ты — Макс, трекер целей BizLevel...` (L402..L405)
```

- Файл: `lib/screens/mini_case_screen.dart` — системный промпт фасилитатора кейса:
```lib/screens/mini_case_screen.dart
'Режим: case_facilitатор. Ты — Лео, фасилитатор мини‑кейса. ...' (L247..L255, L258..)
```

### 3.2 Dynamic Prompt Construction
- Leo: конкатенация блоков: ограничения по прогрессу → роль/тон → приоритеты → запреты → структура → алгоритм → динамика: `personaSummary`, `user_memories`, `recentSummaries`, `RAG контекст`, `userContext`, `levelContext`.
- Max: роль/тон, приоритеты, запреты, структура, алгоритм; динамика: `maxCompletedLevel`, `goalBlock`, `sprintBlock`, `remindersBlock`, `quoteBlock`, `personaSummary`, `userContext`, `levelContext`. Доп. правила по версии цели v2/v3/v4 добавляются условно.

### 3.3 Few-shot Examples
Прямых few-shot шаблонов не найдено; используются детальные инструкции и контекстные блоки. В кейсах — маркеры `[CASE:NEXT|FINAL]` в ответах для сценарного управления.

## 4. RAG System Architecture
### 4.1 Embedding Pipeline
- Edge `/leo-chat`: OpenAI Embeddings (`text-embedding-3-small` по умолчанию), кеш RAG по `(userId, hash(query))`, TTL из `RAG_CACHE_TTL_SEC`.
- Индексация контента кейсов: `scripts/index_cases.py` — сплит в чанки, генерация эмбеддингов, формирование документов с `metadata` (`level_id`, `skill_name`, `tags`, др.).

### 4.2 Document Structure
- Таблица `public.documents`: создаётся ранее; миграции содержат backfill и индексы:
  - `20250808_optimize_documents_for_rag.sql`: HNSW/IVFFLAT индекс `documents.embedding`, GIN по `metadata`, таблица `documents_backfill_map`, апдейт метаданных (`level_id`, `skill_id`, `title`, `section`, `tags`).
  - `20250808_update_match_documents.sql`: функция `public.match_documents(query_embedding, match_threshold, match_count, metadata_filter jsonb)` — ANN + фильтры метаданных до ANN.

### 4.3 Search & Retrieval Logic
- Edge `/leo-chat`: при `bot != max` → эмбеддинг последнего user-сообщения → `rpc('match_documents')` с `match_threshold` и `match_count` из ENV и опциональным `metadata_filter` (из `levelContext`). Сжатие чанков в тезисы `summarizeChunk()`, ограничение по токенам `RAG_MAX_TOKENS`.

## 5. Personalization Layer
### 5.1 User Data Sources
- Таблицы: `users` (поля: `name`, `about`, `goal`, `business_area`, `experience_level`, `persona_summary`, `current_level`), `user_progress` (макс. завершённый уровень), `core_goals`, `weekly_progress`, `reminder_checks`, `motivational_quotes`, `user_memories`, `leo_chats` (summary/last_topics).

### 5.2 Context Formation
- JWT → `auth.getUser` → профиль и текущий/макс. уровень → `profileText` и `personaSummary` (кешируется). `userContext` клиента добавляется поверх профиля. `levelContext` — строка или объект.

### 5.3 Memory System
- `leo-memory`: извлекает JSON‑массив фактов, нормализует, эмбеддинг батчем, `upsert` в `user_memories` по `(user_id, content)`. Триггер `trg_call_leo_memory` вызывает функцию на `INSERT` ассистентского сообщения; есть анти‑дедуп `trg_leo_messages_dedupe`. Также обновляет `leo_chats.summary/last_topics`.

## 6. Leo Operating Modes
### 6.1 Default Mode
- Бот `leo`: персонализация + RAG по пройденным уровням, строгие запреты отвечать по непройденным темам.
- Бот `max`: трекинг цели, без RAG, правила по версиям цели.

### 6.2 Quiz Mode
- `mode='quiz'` в `/leo-chat`: короткий ответ Лео без RAG/GP; используется из `LeoQuizWidget` через `LeoService.sendQuizFeedback`.

### 6.3 Case Mode
- Клиентский режим: `LeoDialogScreen(caseMode: true)` вставляет `system` промпт фасилитатора и сценарные сообщения. Маркеры `[CASE:NEXT|FINAL]` управляют шагами и финалом.

### 6.4 Mode Switching Logic
- Параметры запроса: `bot`, `mode`, `userContext`, `levelContext`, `chatId`. Режим определяется на сервере по `mode`; кейс — на клиенте через `caseMode`.

## 7. Database Schema
### 7.1 Tables Structure
- `user_memories` — см. `20250808_add_personalization_and_memories.sql` (id, user_id, content, embedding vector(1536), weight, timestamps), индексы, RLS.
- `documents` — хранит content, embedding, metadata; индексы HNSW/IVFFLAT и GIN; обогащение метаданных через `documents_backfill_map`.
- `leo_messages_processed` — для идемпотентности в `leo-memory` cron.
- Дополнительно: `app_settings` (секреты для триггера), `core_goals`, `weekly_progress`, `reminder_checks`, `motivational_quotes`, `push_tokens`, пр.

Прямые CREATE для `leo_chats`/`leo_messages` в видимых миграциях не обнаружены — вероятно, созданы ранее; упоминания в коде подтверждают структуру (поля: `id`, `user_id`, `title`, `message_count`, `bot`, `summary`, `last_topics`, `unread_count`, timestamps; `leo_messages`: `chat_id`, `user_id`, `role`, `content`, timestamps).

### 7.2 Relationships
- `leo_messages.chat_id → leo_chats.id`, `user_memories.user_id → users.id`, связи с `users`, `user_progress`, `core_goals` и т.д.

### 7.3 Functions & Triggers
- `public.match_documents(...)` — поиск по эмбеддингам с фильтрами метаданных.
- `public.call_leo_memory`, `public.call_leo_memory_trigger` — вызов Edge `leo-memory` через `pg_net` на `INSERT` ассистентского сообщения.
- `public.leo_messages_dedupe` — дедуп ассистентских сообщений.

## 8. External Integrations
### 8.1 OpenAI Integration
- Chat Completions: `OPENAI_MODEL` (по умолчанию `gpt-4.1-mini`), `OPENAI_TEMPERATURE` (например 0.4), токены учитываются и стоимость сохраняется в `ai_message`.
- Embeddings: `OPENAI_EMBEDDING_MODEL` (`text-embedding-3-small`).

### 8.2 Other APIs
- Push (`push-dispatch`), payments (`create-checkout-session` с TODO по интеграции Kaspi/FreedomPay).

## 9. Configuration
### 9.1 Environment Variables
- Клиент: `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `OPENAI_API_KEY` (через `envOrDefine`/`String.fromEnvironment`).
- Edge: `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`, `SUPABASE_ANON_KEY`, `OPENAI_API_KEY`, `OPENAI_MODEL`, `OPENAI_TEMPERATURE`, `OPENAI_EMBEDDING_MODEL`, `RAG_MATCH_THRESHOLD`, `RAG_MATCH_COUNT`, `RAG_MAX_TOKENS`, `PERSONA_CACHE_TTL_SEC`, `RAG_CACHE_TTL_SEC`, `CRON_SECRET`, `ENABLE_GOAL_COMMENT`, `ENABLE_WEEKLY_REACTION`.

### 9.2 Constants & Limits
- Ограничение RAG контекста по токенам, фичефлаги для быстрых отключений режимов, кеши в Edge (персона/RAG, 2–5 мин), лимиты токенов для коротких режимов (120).

## 10. Issues & Improvements
### 10.1 Current Issues
- В истории был 500/502 из-за TDZ переменной `userId` в `leo-chat` (исправлено, см. `docs/status.md`).
- Не найдены миграции CREATE для `leo_chats`/`leo_messages` — стоит убедиться в актуальности схемы в проекте/Studio.

### 10.2 Technical Debt
- TODO в `create-checkout-session` (платежные провайдеры), ряд TODO в инфраструктурных файлах (Windows/Linux CMake). План обновления зависимостей и кешей в CI.

### 10.3 Optimization Opportunities
- Дополнительные метаданные и фильтры в `match_documents` (расширение по тегам/уровням/навыкам уже частично реализовано).
- Реранжирование найденных документов (post-processing) при необходимости.
- Больше unit/integration тестов для `LeoService` и Edge режимов.

## 11. Code Examples
### 11.1 Key Functions
```lib/services/leo_service.dart
Future<Map<String, dynamic>> sendMessageWithRAG({...}) { ... } // вызов /leo-chat, skipSpend, idempotency key
```

```supabase/functions/leo-chat/index.ts
const { messages, userContext, levelContext, bot, mode } = body; // сбор параметров
// Персонализация, RAG, системные промпты, вызов OpenAI
```

### 11.2 Prompt Templates
```supabase/functions/leo-chat/index.ts
// Leo system prompt (полный блок L919..L997)
// Max system prompt + v2/v3/v4 правила (L1000..L1082)
```

### 11.3 RAG Queries
```supabase/functions/leo-chat/index.ts
const { data: results } = await supabaseAdmin.rpc('match_documents', {
  query_embedding,
  match_threshold,
  match_count,
  metadata_filter,
});
```

—

Примечания:
- Если какие-то CREATE TABLE для `leo_chats/leo_messages/documents` отсутствуют в репозитории, они, вероятно, применялись ранее; текущее состояние подтверждается использованием в коде и миграциями индексов/функций.
- Тесты для Leo UI есть косвенно (deeplinks, экраны уровней), прямых тестов `LeoService`/Edge нет — потенциальная зона усиления.


