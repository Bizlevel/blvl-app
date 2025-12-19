# План рефакторинга leo-chat для продакшена

**Статус:** 🟡 В разработке  
**Приоритет:** 🔴 Критический  
**Цель:** Привести `leo-chat` к уровню надежности `val-chat` без breaking changes

---

## 📋 Обзор проблем

### Критические (блокеры для продакшена)
1. ❌ **Отсутствие Zod-валидации** входных данных (request body)
2. ❌ **Race condition** в `saveMessages` + `updateAIMessageLeoId` (потеря данных биллинга)
3. ❌ **Partial failure** при сохранении сообщений (молчаливое продолжение при ошибке)
4. ❌ **Небезопасный JSON.parse** в кешах (может уронить функцию)

### Важные (но не блокеры)
5. ⚠️ Недостаточное логирование критических операций
6. ⚠️ Отсутствие лимитов на глобальные кеши (потенциальная утечка памяти)

---

## 🎯 Принципы рефакторинга

1. **Обратная совместимость** — все изменения не должны ломать существующих клиентов
2. **Постепенный деплой** — каждый этап можно деплоить отдельно
3. **Минимальные изменения** — только то, что критично для надежности
4. **Безопасность** — все изменения проходят через тестирование на staging

---

## 📦 Этап 1: Zod-валидация входных данных (CRITICAL)

**Цель:** Защита от некорректных входных данных, injection, OOM

**Время:** 1 день  
**Риск:** 🟢 Низкий (только добавление валидации, не меняет логику)

**⚠️ Важно:** 
- Лимит на количество сообщений (max 20) защищает от гигантских массивов, которые могут вызвать OOM
- Без этого лимита злоумышленник может отправить массив из 1000+ сообщений и уронить Edge-функцию

**⚠️ Важно:** 
- Zod используется **ТОЛЬКО на входе в `serve()`** для валидации request body
- После валидации работаем с чистыми TypeScript интерфейсами внутри всех функций и репозиториев
- **НЕ валидируем ответы LLM через Zod** - работаем с TypeScript типами напрямую
- Это быстрее и проще, чем валидировать каждую функцию через Zod
(НЕ валидируем ответы LLM через Zod (в отличие от val-chat, где это оправдано)
**Сравнение с val-chat:**
- В `val-chat` есть валидация ответов LLM через Zod (т.к. там структурированные JSON-ответы)
- В `leo-chat` ответы LLM - это простой текст, валидация не нужна
- Если в будущем понадобится валидация структурированных ответов - добавим, но только там, где это действительно нужно

### Шаги

#### 1.1 Добавить Zod-схемы для request body и TypeScript интерфейсы

```typescript
// После импортов, перед типами
import { z } from "https://deno.land/x/zod@v3.23.8/mod.ts";

// ============================
// ZOD SCHEMAS (только для валидации входных данных)
// ============================

// Схема для одного сообщения
const MessageSchema = z.object({
  role: z.enum(['system', 'user', 'assistant']),
  content: z.string().min(1).max(8000) // Лимит для защиты от OOM
});

// Схема для request body
const RequestBodySchema = z.object({
  messages: z.array(MessageSchema).max(20).default([]), // ✅ Лимит на количество сообщений для защиты от OOM
  mode: z.enum(['chat', 'quiz', 'chips']).default('chat'),
  bot: z.enum(['leo', 'max']).default('leo'),
  userContext: z.string().nullable().default(null),
  levelContext: z.unknown().nullable().default(null), // unknown, т.к. может быть объектом
  chatId: z.string().uuid().nullable().default(null),
  caseMode: z.boolean().default(false),
  quiz: z.object({
    question: z.string(),
    options: z.array(z.string()),
    selectedIndex: z.number().int().min(0),
    correctIndex: z.number().int().min(0)
  }).optional(),
  isCorrect: z.boolean().optional()
});

// ============================
// TYPESCRIPT INTERFACES (для работы внутри функций)
// ============================

// ✅ После валидации через Zod работаем с чистыми TypeScript типами
// Это быстрее и проще, чем валидировать каждую функцию через Zod

interface ValidatedMessage {
  role: 'system' | 'user' | 'assistant';
  content: string;
}

interface ValidatedQuiz {
  question: string;
  options: string[];
  selectedIndex: number;
  correctIndex: number;
}

interface ValidatedRequestBody {
  messages: ValidatedMessage[];
  mode: 'chat' | 'quiz' | 'chips';
  bot: 'leo' | 'max';
  userContext: string | null;
  levelContext: unknown | null;
  chatId: string | null;
  caseMode: boolean;
  quiz?: ValidatedQuiz;
  isCorrect?: boolean;
}
```

#### 1.2 Добавить функцию валидации (только на входе)

```typescript
/**
 * Валидирует request body через Zod-схему
 * Возвращает валидированные данные как TypeScript интерфейс
 * Выбрасывает LeoError с кодом 'bad_request' при ошибке валидации
 * 
 * ⚠️ ВАЖНО: Zod используется ТОЛЬКО здесь, на границе входа.
 * После валидации работаем с чистыми TypeScript типами внутри всех функций.
 */
function validateRequestBody(raw: unknown): ValidatedRequestBody {
  const result = RequestBodySchema.safeParse(raw);
  if (!result.success) {
    console.error('ERR request_validation_failed', {
      issues: result.error.issues?.slice(0, 10), // Логируем первые 10 ошибок
    });
    throw new LeoError(
      'bad_request',
      'Invalid request body',
      { validation_errors: result.error.issues }
    );
  }
  // ✅ Возвращаем как TypeScript интерфейс, не как Zod-тип
  // TypeScript автоматически выведет правильный тип из result.data
  return result.data as ValidatedRequestBody;
}
```

#### 1.3 Интегрировать валидацию в serve() (только на входе)

```typescript
// В serve(), после парсинга body:
let body: any;
try {
  body = await req.json();
} catch (e) {
  return new Response(JSON.stringify({
    error: "bad_request",
    message: "Invalid JSON in request body"
  }), {
    status: 400,
    headers: { ...corsHeaders, "Content-Type": "application/json" }
  });
}

// ✅ НОВОЕ: Валидация через Zod ТОЛЬКО на входе
let validatedBody: ValidatedRequestBody;
try {
  validatedBody = validateRequestBody(body);
} catch (e) {
  if (e instanceof LeoError && e.code === 'bad_request') {
    return handleGlobalError(e); // Вернет 400 с деталями
  }
  throw e; // Пробрасываем другие ошибки
}

// ✅ После валидации работаем с чистыми TypeScript типами
// Все функции дальше получают типизированные данные, без Zod
const { messages, mode, bot, userContext, levelContext, chatId } = validatedBody;

// Пример: передача в функции (все типизировано через TypeScript)
await handleChat(messages, mode, bot, userContext, levelContext, chatId);
// ↑ messages: ValidatedMessage[]
// ↑ mode: 'chat' | 'quiz' | 'chips'
// ↑ bot: 'leo' | 'max'
// и т.д. - все типизировано, но без Zod внутри функций
```

**Проверка:**
- ✅ Старые валидные запросы работают как раньше
- ✅ Некорректные запросы получают понятную ошибку 400
- ✅ Защита от огромных массивов messages (max 8000 символов на сообщение)
- ✅ **Защита от OOM: лимит на количество сообщений (max 20)** - предотвращает гигантские массивы
- ✅ **Zod используется ТОЛЬКО на входе в `serve()`** - после валидации работаем с TypeScript типами
- ✅ Внутри всех функций и репозиториев - чистые TypeScript интерфейсы (быстрее и проще)

---

## 📦 Этап 2: Исправление race condition в сохранении сообщений (CRITICAL)

**Цель:** Гарантировать атомарность сохранения сообщений и связи с cost

**Время:** 1-2 дня  
**Риск:** 🟡 Средний (меняет логику сохранения, но сохраняет обратную совместимость)

### Проблема

Текущий код:
```typescript
// 1. Сохраняем сообщения (может быть partial success)
const saveResult = await saveMessages(...);
assistantLeoMessageId = saveResult.assistantMessageId;

// 2. Отдельно обновляем ai_message (race condition!)
if (assistantLeoMessageId) {
  await updateAIMessageLeoId(...); // SELECT + UPDATE = не атомарно
}
```

**Риски:**
- Если `saveMessages` частично упал (user сохранен, assistant нет) → функция продолжает работу
- Если `updateAIMessageLeoId` упал → cost не связан с сообщением
- При параллельных запросах два потока могут выбрать один `ai_message`

### Решение: Улучшенная версия без PL/pgSQL (минимальные изменения)

**Архитектурное решение:** Используем `Promise.allSettled` вместо последовательного сохранения:
- ✅ **Скорость сохранена**: user и assistant сохраняются параллельно (как было)
- ✅ **Точная диагностика**: точно знаем, какое из двух сохранений упало
- ✅ **Нет увеличения latency**: пользователь не ждет последовательных операций

**Сравнение latency:**
- ❌ Последовательное сохранение: `latency = saveUser + saveAssistant` (~100-200ms)
- ✅ Параллельное с `Promise.allSettled`: `latency = max(saveUser, saveAssistant)` (~50-100ms)

#### 2.1 Переработать `saveMessages` для явной обработки ошибок с сохранением параллелизма

```typescript
interface SaveMessagesResult {
  userMessageId: string | null;
  assistantMessageId: string | null;
  errors: Array<{ type: 'user' | 'assistant'; error: any }>; // ✅ НОВОЕ
}

async function saveMessages(
  chatId: string,
  userId: string,
  userMessage: string | null,
  assistantMessage: string,
  dbAdmin: ReturnType<typeof createClient>
): Promise<SaveMessagesResult> {
  const errors: Array<{ type: 'user' | 'assistant'; error: any }> = [];
  let userMessageId: string | null = null;
  let assistantMessageId: string | null = null;

  // ✅ Параллельное сохранение через Promise.allSettled для сохранения скорости
  // Promise.allSettled не падает при ошибке одного из промисов, а возвращает все результаты
  const savePromises: Promise<{ type: 'user' | 'assistant'; result?: any; error?: any }>[] = [];

  // Пользовательское сообщение (если есть)
  if (userMessage) {
    savePromises.push(
      dbAdmin
        .from('leo_messages')
        .insert({
          chat_id: chatId,
          user_id: userId,
          role: 'user',
          content: String(userMessage)
        })
        .select('id')
        .single()
        .then(result => ({ type: 'user' as const, result }))
        .catch(e => ({ type: 'user' as const, error: e }))
    );
  }

  // Ответ ассистента (всегда сохраняем)
  savePromises.push(
    dbAdmin
      .from('leo_messages')
      .insert({
        chat_id: chatId,
        user_id: userId,
        role: 'assistant',
        content: String(assistantMessage)
      })
      .select('id')
      .single()
      .then(result => ({ type: 'assistant' as const, result }))
      .catch(e => ({ type: 'assistant' as const, error: e }))
  );

  // ✅ Используем Promise.allSettled вместо Promise.all
  // Это позволяет получить результаты всех промисов, даже если некоторые упали
  const saveResults = await Promise.allSettled(savePromises);

  // Обрабатываем результаты
  for (const settledResult of saveResults) {
    if (settledResult.status === 'rejected') {
      // Если сам Promise.allSettled упал (крайне редко), логируем
      console.error('ERR saveMessages_promise_rejected', {
        message: String(settledResult.reason).slice(0, 200),
        chatId,
        userId
      });
      continue;
    }

    const { type, result, error } = settledResult.value;

    if (error) {
      errors.push({ type, error });
      console.error(`ERR saveMessages_${type}`, {
        message: String(error).slice(0, 200),
        chatId,
        userId
      });
    } else if (result?.data?.id) {
      if (type === 'user') {
        userMessageId = result.data.id;
      } else if (type === 'assistant') {
        assistantMessageId = result.data.id;
      }
    }
  }

  return {
    userMessageId,
    assistantMessageId,
    errors // ✅ НОВОЕ: явно возвращаем ошибки
  };
}
```

**Преимущества подхода:**
- ✅ **Скорость сохранена**: user и assistant сохраняются параллельно
- ✅ **Точная диагностика**: точно знаем, какое из двух сохранений упало
- ✅ **Нет увеличения latency**: пользователь не ждет последовательных операций

#### 2.2 Улучшить `updateAIMessageLeoId` для избежания race condition

```typescript
/**
 * Обновляет leo_message_id в ai_message, используя конкретный ID записи.
 * Если ai_message_id не передан, ищет последнюю запись (legacy режим).
 * 
 * ⚠️ ВАЖНО: Для полной атомарности лучше передавать ai_message_id из executeAiTask
 */
async function updateAIMessageLeoId(
  userId: string,
  chatId: string | null,
  leoMessageId: string,
  supabaseAdminInstance: ReturnType<typeof createClient>,
  correlationId?: string | null,
  aiMessageId?: string | null // ✅ НОВОЕ: опциональный конкретный ID
): Promise<void> {
  if (!userId || !chatId || !leoMessageId) {
    console.warn('WARN update_ai_message_leo_id_skipped', {
      userId,
      chatId,
      leoMessageId,
      correlationId
    });
    return;
  }

  try {
    let updateQuery;

    if (aiMessageId) {
      // ✅ ПРЕДПОЧТИТЕЛЬНО: Обновляем конкретную запись по ID
      updateQuery = supabaseAdminInstance
        .from('ai_message')
        .update({ leo_message_id: leoMessageId })
        .eq('id', aiMessageId)
        .eq('user_id', userId)
        .eq('chat_id', chatId)
        .is('leo_message_id', null); // Защита от двойного обновления
    } else {
      // ⚠️ LEGACY: Ищем последнюю запись (может быть race condition при параллельных запросах)
      const { data: aiMessages, error: findError } = await supabaseAdminInstance
        .from('ai_message')
        .select('id')
        .eq('user_id', userId)
        .eq('chat_id', chatId)
        .is('leo_message_id', null)
        .order('created_at', { ascending: false })
        .limit(1);

      if (findError) {
        console.error('ERR update_ai_message_leo_id_find', {
          message: findError.message,
          userId,
          chatId,
          correlationId
        });
        return;
      }

      if (!aiMessages || aiMessages.length === 0) {
        console.warn('WARN update_ai_message_leo_id_not_found', {
          userId,
          chatId,
          correlationId
        });
        return;
      }

      const targetId = aiMessages[0].id;
      updateQuery = supabaseAdminInstance
        .from('ai_message')
        .update({ leo_message_id: leoMessageId })
        .eq('id', targetId)
        .eq('user_id', userId)
        .is('leo_message_id', null); // Защита от race condition
    }

    const { error: updateError } = await updateQuery;

    if (updateError) {
      console.error('ERR update_ai_message_leo_id_update', {
        message: updateError.message,
        userId,
        chatId,
        leoMessageId,
        correlationId
      });
    } else {
      console.log('INFO ai_message_leo_id_updated', {
        userId,
        chatId,
        leoMessageId,
        correlationId
      });
    }
  } catch (e) {
    console.error('ERR update_ai_message_leo_id_exception', {
      message: String(e).slice(0, 200),
      userId,
      chatId,
      correlationId
    });
  }
}
```

#### 2.3 Изменить логику в `handleChat` для обработки ошибок сохранения

```typescript
// В handleChat() после executeAiTask:

// Сохраняем сообщения
const saveResult = await saveMessages(
  effectiveChatId,
  userId,
  lastUserText,
  sanitizedContent,
  this.ctx.dbAdmin
);

// ✅ НОВОЕ: Проверяем, что assistant сообщение сохранено
if (!saveResult.assistantMessageId) {
  const errorMsg = saveResult.errors.find(e => e.type === 'assistant')?.error;
  console.error('CRITICAL saveMessages_assistant_failed', {
    userId,
    chatId: effectiveChatId,
    correlationId: this.ctx.correlationId,
    error: errorMsg ? String(errorMsg).slice(0, 200) : 'unknown'
  });
  
  // ⚠️ ВАЖНО: Не падаем, но логируем критическую ошибку
  // Сообщение уже отправлено пользователю, но не сохранено в БД
  // В будущем можно добавить retry или dead letter queue
}

// Обновляем leo_message_id в ai_message
if (saveResult.assistantMessageId) {
  await updateAIMessageLeoId(
    userId,
    effectiveChatId,
    saveResult.assistantMessageId,
    this.ctx.dbAdmin,
    this.ctx.correlationId
    // TODO: В будущем передавать ai_message_id из executeAiTask
  );
} else {
  console.warn('WARN skipping_update_ai_message_leo_id_no_assistant', {
    userId,
    chatId: effectiveChatId,
    correlationId: this.ctx.correlationId
  });
}
```

**Проверка:**
- ✅ При ошибке сохранения assistant-сообщения логируется критическая ошибка
- ✅ `updateAIMessageLeoId` защищен от race condition через `.is('leo_message_id', null)`
- ✅ Обратная совместимость сохранена (legacy режим без `ai_message_id`)
- ✅ **Параллелизм сохранен**: `Promise.allSettled` позволяет сохранять user и assistant одновременно без увеличения latency

**Следующий шаг (опционально, после продакшена):**
- Модифицировать `executeAiTask` для возврата `ai_message_id` из `saveAIMessageData`
- Передавать этот ID в `updateAIMessageLeoId` для полной атомарности

---

## 📦 Этап 3: Безопасный JSON.parse в кешах (CRITICAL)

**Цель:** 
- Защита от падения функции при некорректном JSON в кеше
- **Мониторинг проблем с кешем** через метрику `cache_corruption`
- Предотвращение скрытых проблем: если кеш битый, мы должны знать об этом, иначе БД ляжет под нагрузкой

**Время:** 0.5 дня  
**Риск:** 🟢 Низкий (только добавление try/catch + логирование)

**⚠️ Важно:** Это не просто "безопасный парсинг" - это **мониторинг здоровья кеша**. 
Без метрики `cache_corruption` мы не узнаем, что кеш перестал работать, и БД получит всю нагрузку.

### Шаги

#### 3.1 Обернуть все JSON.parse в безопасные функции с метрикой corruption

```typescript
/**
 * Безопасный парсинг JSON с fallback и метрикой corruption
 * Используется для парсинга данных из кеша
 * 
 * ⚠️ ВАЖНО: Логирует метрику "cache_corruption" для мониторинга проблем с кешем
 * Если кеш битый, мы должны знать об этом, иначе БД ляжет под нагрузкой
 */
function safeJsonParse<T>(
  json: string,
  fallback: T,
  context: {
    cacheType: 'persona' | 'rag' | 'chips' | 'progress';
    cacheKey?: string;
    userId?: string;
  }
): T {
  try {
    return JSON.parse(json) as T;
  } catch (e) {
    // ✅ КРИТИЧНО: Логируем метрику cache_corruption для мониторинга
    // Это не просто ошибка парсинга - это признак проблем с кешем
    console.error('ERR cache_corruption', {
      metric: 'cache_corruption', // Метрика для алертов/мониторинга
      cacheType: context.cacheType,
      cacheKey: context.cacheKey || 'unknown',
      userId: context.userId || 'unknown',
      error: String(e).slice(0, 200),
      jsonPreview: json.slice(0, 100), // Первые 100 символов для отладки
      jsonLength: json.length, // Размер битых данных
      timestamp: new Date().toISOString()
    });
    
    // ⚠️ ВАЖНО: Возвращаем fallback, но проблема ЗАЛОГИРОВАНА
    // Мониторинг должен отслеживать частоту "cache_corruption"
    // Если частота растет → проблема с кешем (TTL, сериализация, etc.)
    return fallback;
  }
}
```

#### 3.2 Заменить все JSON.parse в кешах с передачей контекста

```typescript
// В getUserProfile:
const cached = getCached<string>(personaCache, cacheKey);
if (cached) {
  return safeJsonParse<UserProfile>(cached, null, {
    cacheType: 'persona',
    cacheKey,
    userId // Передаем userId из параметров функции
  });
}

// В getUserProgress:
const cached = getCached<string>(personaCache, cacheKey);
if (cached) {
  return safeJsonParse<UserProgress>(cached, null, {
    cacheType: 'progress',
    cacheKey,
    userId // Передаем userId из параметров функции
  });
}

// В performRAGQuery (если есть кеш для RAG):
const cached = getCached<string | number[]>(ragCache, ragCacheKey);
if (cached) {
  if (typeof cached === 'string') {
    return safeJsonParse<string>(cached, '', {
      cacheType: 'rag',
      cacheKey: ragCacheKey,
      userId
    });
  }
  // Если это number[] (embeddings), не нужно парсить
  return cached;
}
```

**Проверка:**
- ✅ Некорректный JSON в кеше не уронит функцию
- ✅ **Метрика `cache_corruption` логируется** для мониторинга проблем с кешем
- ✅ Функция продолжает работу, загружая данные из БД
- ✅ **Мониторинг должен отслеживать частоту `cache_corruption`**:
  - Если частота растет → проблема с кешем (TTL, сериализация, race condition)
  - Если частота высокая → БД может лечь под нагрузкой (все запросы идут в БД)
  - Рекомендуется алерт при >10 случаев в минуту

**⚠️ Анти-паттерн, который мы избегаем:**
- ❌ **Error Swallowing**: Молча возвращать fallback без логирования
- ✅ **Правильный подход**: Логировать метрику + возвращать fallback

**📊 Настройка мониторинга (после деплоя):**
- Настроить алерт на метрику `ERR cache_corruption` в системе мониторинга (Sentry, Datadog, CloudWatch, etc.)
- Рекомендуемый порог: >10 случаев в минуту
- При срабатывании алерта:
  1. Проверить логи на паттерны (какой cacheType чаще всего битый)
  2. Проверить TTL кешей (возможно, слишком долгий)
  3. Проверить логику сериализации (возможно, race condition при записи)
  4. Рассмотреть увеличение лимитов кешей или оптимизацию сериализации

---

## 📦 Этап 4: Базовое структурированное логирование (HIGH)

**Цель:** Улучшить observability критических операций с полной трассировкой запросов

**Время:** 0.5 дня  
**Риск:** 🟢 Низкий (только добавление логов)

**⚠️ Критично:** При 100+ запросах в секунду без `correlationId` невозможно сопоставить "начало задачи" и "ошибку сохранения". 
Все логи ДОЛЖНЫ содержать `correlationId` без исключения.

### Шаги

#### 4.1 Генерировать correlationId, если его нет

```typescript
// В serve(), при создании ctx:
const correlationId = req.headers.get('x-correlation-id') || crypto.randomUUID();

// ✅ НОВОЕ: Генерируем UUID на сервере, если клиент не предоставил
// Это критично для трассировки запросов в продакшене
const ctx: LeoContext = {
  // ...
  correlationId, // Всегда есть, даже если клиент не отправил header
  // ...
};
```

#### 4.2 Добавить логирование начала запроса

```typescript
// В serve(), сразу после создания ctx:
console.log('INFO request_start', {
  correlationId: ctx.correlationId,
  userId: ctx.user.id,
  method: req.method,
  mode,
  bot,
  messagesCount: messages?.length || 0,
  hasUserContext: Boolean(userContext),
  hasLevelContext: Boolean(levelContext)
});
```

#### 4.3 Добавить correlationId во все логи в saveMessages

```typescript
// В saveMessages(), при обработке ошибок:
for (const settledResult of saveResults) {
  if (settledResult.status === 'rejected') {
    console.error('ERR saveMessages_promise_rejected', {
      correlationId, // ✅ НОВОЕ: Добавляем correlationId
      message: String(settledResult.reason).slice(0, 200),
      chatId,
      userId
    });
    continue;
  }

  const { type, result, error } = settledResult.value;

  if (error) {
    errors.push({ type, error });
    console.error(`ERR saveMessages_${type}`, {
      correlationId, // ✅ НОВОЕ: Добавляем correlationId
      message: String(error).slice(0, 200),
      chatId,
      userId,
      type // user или assistant
    });
  } else if (result?.data?.id) {
    // ... успешное сохранение
  }
}
```

#### 4.4 Добавить логирование в handleChat с correlationId

```typescript
// В handleChat(), после executeAiTask:
console.log('INFO chat_ai_task_completed', {
  correlationId: this.ctx.correlationId, // ✅ Уже есть, но проверяем
  userId,
  chatId: effectiveChatId,
  mode,
  bot,
  tokensUsed: usage?.total_tokens || 0,
  cost,
  duration: nowMs() - this.ctx.startTime
});

// После saveMessages (успех):
if (saveResult.assistantMessageId) {
  console.log('INFO chat_messages_saved', {
    correlationId: this.ctx.correlationId, // ✅ Уже есть
    userId,
    chatId: effectiveChatId,
    userMessageId: saveResult.userMessageId,
    assistantMessageId: saveResult.assistantMessageId,
    hasErrors: saveResult.errors.length > 0
  });
}

// После saveMessages (ошибка):
if (!saveResult.assistantMessageId) {
  const errorMsg = saveResult.errors.find(e => e.type === 'assistant')?.error;
  console.error('CRITICAL saveMessages_assistant_failed', {
    correlationId: this.ctx.correlationId, // ✅ КРИТИЧНО: Без этого не сопоставишь с началом запроса
    userId,
    chatId: effectiveChatId,
    error: errorMsg ? String(errorMsg).slice(0, 200) : 'unknown',
    userMessageSaved: Boolean(saveResult.userMessageId) // Важно знать, что сохранилось
  });
}

// После updateAIMessageLeoId (уже есть correlationId, но проверяем):
if (saveResult.assistantMessageId) {
  await updateAIMessageLeoId(
    userId,
    effectiveChatId,
    saveResult.assistantMessageId,
    this.ctx.dbAdmin,
    this.ctx.correlationId // ✅ Уже передается
  );
} else {
  console.warn('WARN skipping_update_ai_message_leo_id_no_assistant', {
    correlationId: this.ctx.correlationId, // ✅ НОВОЕ: Добавляем correlationId
    userId,
    chatId: effectiveChatId
  });
}
```

#### 4.5 Добавить correlationId в параметры функций и логи ошибок

**⚠️ Критично:** `correlationId` должен передаваться в `getUserProfile`, `getUserProgress` и `performRAGQuery`. 
Если они упадут, мы должны видеть это в контексте конкретного запроса.

```typescript
// ✅ Обновляем сигнатуры функций для приема correlationId:

// getUserProfile:
async function getUserProfile(
  userId: string,
  dbAdmin: ReturnType<typeof createClient>,
  correlationId?: string | null // ✅ НОВОЕ: Добавляем correlationId в параметры
): Promise<UserProfile | null> {
  // ...
  if (error) {
    console.error('ERR getUserProfile', { 
      message: error.message, 
      userId,
      correlationId // ✅ НОВОЕ: Логируем correlationId
    });
    return null;
  }
  // ...
  catch (e) {
    console.error('ERR getUserProfile_exception', { 
      message: String(e).slice(0, 200), 
      userId,
      correlationId // ✅ НОВОЕ: Логируем correlationId
    });
    return null;
  }
}

// getUserProgress:
async function getUserProgress(
  userId: string,
  dbAdmin: ReturnType<typeof createClient>,
  correlationId?: string | null // ✅ НОВОЕ: Добавляем correlationId в параметры
): Promise<UserProgress> {
  // ...
  catch (e) {
    console.error('ERR getUserProgress_exception', { 
      message: String(e).slice(0, 200), 
      userId,
      correlationId // ✅ НОВОЕ: Логируем correlationId
    });
    // ...
  }
}

// performRAGQuery:
async function performRAGQuery(
  lastUserMessage: string,
  levelContext: string | object | null,
  userId: string | null,
  embeddingsClient: OpenAI,
  dbAdmin: ReturnType<typeof createClient>,
  correlationId?: string | null // ✅ НОВОЕ: Добавляем correlationId в параметры
): Promise<string> {
  // ...
  catch (e) {
    console.error('ERR rag_pipeline', {
      correlationId, // ✅ НОВОЕ: Логируем correlationId
      message: String(e).slice(0, 240),
      userId,
      levelId
    });
    return '';
  }
}

// ✅ Обновляем все вызовы этих функций, чтобы передавать correlationId:

// В buildLeoContext:
const [profileResult, progressResult] = await Promise.all([
  getUserProfile(userId, dbAdmin, ctx.correlationId), // ✅ Передаем correlationId
  getUserProgress(userId, dbAdmin, ctx.correlationId)  // ✅ Передаем correlationId
]);

// В buildLeoContext, при вызове performRAGQuery:
performRAGQuery(
  lastUserMessage, 
  safeLevelContext, 
  userId, 
  embeddingsClient, 
  dbAdmin,
  ctx.correlationId // ✅ Передаем correlationId
)
  .catch((e) => {
    console.error('ERR performRAGQuery', { 
      message: String(e).slice(0, 200), 
      userId,
      correlationId: ctx.correlationId // ✅ Логируем correlationId
    });
    return '';
  });

// В handleChat (Leo/Max), при вызове getUserProfile:
const profile = await getUserProfile(userId, this.ctx.dbAdmin, this.ctx.correlationId); // ✅ Передаем correlationId
```

#### 4.6 Добавить correlationId в остальные функции (getGoalData, getChatSummaries, getUserMemories, createOrGetChat)

**⚠️ Важно:** Эти функции также должны логировать correlationId для полной трассировки.

```typescript
// getGoalData:
async function getGoalData(
  userId: string,
  dbAdmin: ReturnType<typeof createClient>,
  profileGoal: string | null,
  correlationId?: string | null // ✅ НОВОЕ: Добавляем correlationId
): Promise<GoalData> {
  // ...
  catch (e) {
    console.error('ERR getGoalData_exception', { 
      message: String(e).slice(0, 200), 
      userId,
      correlationId // ✅ НОВОЕ: Логируем correlationId
    });
    // ...
  }
}

// getChatSummaries:
async function getChatSummaries(
  userId: string,
  bot: 'leo' | 'max',
  dbAdmin: ReturnType<typeof createClient>,
  correlationId?: string | null // ✅ НОВОЕ: Добавляем correlationId
): Promise<string> {
  // ...
  catch (e) {
    console.error('ERR getChatSummaries_exception', { 
      message: String(e).slice(0, 200), 
      userId,
      bot,
      correlationId // ✅ НОВОЕ: Логируем correlationId
    });
    return '';
  }
}

// getUserMemories:
async function getUserMemories(
  userId: string,
  lastUserMessage: string | null,
  dbAdmin: ReturnType<typeof createClient>,
  embeddingsClient: OpenAI,
  correlationId?: string | null // ✅ НОВОЕ: Добавляем correlationId
): Promise<{ memoriesText: string; metadata: any }> {
  // ...
  catch (e) {
    console.error('ERR getUserMemories_exception', { 
      message: String(e).slice(0, 200), 
      userId,
      correlationId // ✅ НОВОЕ: Логируем correlationId
    });
    return { memoriesText: '', metadata: { fallback: true, hitCount: 0, requested: 0 } };
  }
}

// createOrGetChat:
async function createOrGetChat(
  userId: string,
  bot: 'leo' | 'max',
  chatId: string | null | undefined,
  lastUserMessage: string | null,
  dbAdmin: ReturnType<typeof createClient>,
  correlationId?: string | null // ✅ НОВОЕ: Добавляем correlationId
): Promise<string | null> {
  // ...
  catch (e) {
    console.error('ERR createOrGetChat_exception', { 
      message: String(e).slice(0, 200), 
      userId,
      bot,
      correlationId // ✅ НОВОЕ: Логируем correlationId
    });
    return null;
  }
}

// ✅ Обновляем все вызовы этих функций в buildLeoContext:
const goalData = await getGoalData(userId, dbAdmin, profileGoal, ctx.correlationId); // ✅ Передаем correlationId
const summaries = await getChatSummaries(userId, bot, dbAdmin, ctx.correlationId); // ✅ Передаем correlationId
const memories = await getUserMemories(userId, lastUserMessage, dbAdmin, embeddingsClient, ctx.correlationId); // ✅ Передаем correlationId
const chatId = await createOrGetChat(userId, bot, chatId, lastUserMessage, dbAdmin, ctx.correlationId); // ✅ Передаем correlationId
```

#### 4.7 Убедиться, что saveAIMessageData уже логирует correlationId

**Проверка:** Функция `saveAIMessageData` уже принимает `correlationId` и логирует его в ошибках:
- ✅ `ERR save_ai_message` - уже содержит correlationId
- ✅ `ERR save_ai_message_exception` - уже содержит correlationId
- ✅ `WARN cost_is_nan` - уже содержит correlationId

**Дополнительно:** Убедиться, что все вызовы `saveAIMessageData` передают `correlationId`:
```typescript
// В executeAiTask:
await saveAIMessageData(
  ctx.user.id,
  ctx.chatId,
  leoMessageId || null,
  usage,
  cost,
  model,
  bot,
  requestType,
  ctx.dbAdmin,
  ctx.correlationId // ✅ Уже передается
);
```

**Проверка:**
- ✅ **correlationId генерируется на сервере**, если клиент не предоставил
- ✅ **Все логи содержат correlationId** без исключения (начало, успех, ошибки)
- ✅ **correlationId передается во ВСЕ функции**: getUserProfile, getUserProgress, performRAGQuery, getGoalData, getChatSummaries, getUserMemories, createOrGetChat
- ✅ **correlationId уже есть в saveAIMessageData** (проверено в коде)
- ✅ Можно отследить полный путь запроса: начало → getUserProfile → performRAGQuery → AI задача → сохранение → ошибка
- ✅ При 100+ запросах/сек можно найти все логи одного запроса по correlationId

**Полный список функций с correlationId:**
- ✅ getUserProfile
- ✅ getUserProgress
- ✅ performRAGQuery
- ✅ getGoalData
- ✅ getChatSummaries
- ✅ getUserMemories
- ✅ createOrGetChat
- ✅ saveMessages (в логах)
- ✅ updateAIMessageLeoId
- ✅ saveAIMessageData (уже есть)

**⚠️ Критично для продакшена:**
Без `correlationId` в каждом логе невозможно:
- Сопоставить "начало задачи" и "ошибку сохранения"
- Отследить полный путь запроса через все функции
- Найти причину проблемы при высокой нагрузке

---

## 📦 Этап 5: Простые лимиты на кеши (MEDIUM)

**Цель:** Предотвратить утечку памяти в глобальных кешах

**Время:** 0.5 дня  
**Риск:** 🟢 Низкий (только добавление проверок)

### Шаги

#### 5.1 Добавить лимиты на размер кешей прямо в setCached

```typescript
// Константы для лимитов
const CACHE_LIMITS = {
  MAX_ENTRIES: 500, // Максимальное количество записей в кеше
  CLEANUP_THRESHOLD: 0.8 // Очищать до 80% лимита
} as const;

/**
 * Улучшенная версия setCached с автоматической очисткой при превышении лимита
 * 
 * ✅ Преимущества:
 * - Проверка размера происходит только при добавлении (дешевле)
 * - Нет магических чисел (каждые 10 запросов)
 * - Логичнее: очистка происходит тогда, когда она действительно нужна
 */
function setCached<T>(
  map: Map<string, CacheEntry<T>>,
  key: string,
  value: T,
  ttlMs: number
): void {
  const now = nowMs();
  
  // Сначала удаляем просроченные записи (быстрая проверка)
  for (const [k, entry] of map.entries()) {
    if (entry.expiresAt <= now) {
      map.delete(k);
    }
  }

  // ✅ Проверяем размер ТОЛЬКО если превышен лимит
  // Это дешевле, чем вызывать cleanupCache каждые 10 запросов
  if (map.size >= CACHE_LIMITS.MAX_ENTRIES) {
    // Удаляем самые старые записи до достижения порога
    const sortedEntries = Array.from(map.entries())
      .sort((a, b) => a[1].expiresAt - b[1].expiresAt);
    
    const targetSize = Math.floor(CACHE_LIMITS.MAX_ENTRIES * CACHE_LIMITS.CLEANUP_THRESHOLD);
    const toRemove = map.size - targetSize;
    
    for (let i = 0; i < toRemove; i++) {
      map.delete(sortedEntries[i][0]);
    }

    console.warn('WARN cache_cleanup_performed', {
      cacheType: 'persona/rag/chips', // Можно передавать как параметр, если нужно
      removedEntries: toRemove,
      remainingEntries: map.size,
      maxEntries: CACHE_LIMITS.MAX_ENTRIES
    });
  }

  // Добавляем новую запись
  map.set(key, {
    value,
    expiresAt: now + ttlMs
  });
}
```

**Преимущества подхода:**
- ✅ **Дешевле**: Проверка размера только при добавлении, а не каждые 10 запросов
- ✅ **Логичнее**: Очистка происходит тогда, когда она действительно нужна (превышен лимит)
- ✅ **Нет магических чисел**: Не нужно вызывать cleanupCache периодически
- ✅ **Автоматически**: Каждый вызов `setCached` проверяет и чистит при необходимости

**Проверка:**
- ✅ Кеши не растут бесконечно (лимит проверяется при каждом `setCached`)
- ✅ Старые записи удаляются автоматически (просроченные + самые старые при превышении лимита)
- ✅ **Нет магических чисел**: Очистка происходит по необходимости, а не каждые N запросов
- ✅ **Эффективнее**: Проверка размера только при добавлении, а не периодически

---

## 📦 Этап 6: Вынос магических чисел в конфиг (MEDIUM)

**Цель:** Вынести все магические числа в централизованный конфиг по аналогии с `val-chat`

**Время:** 0.5 дня  
**Риск:** 🟢 Низкий (рефакторинг без изменения логики)

**⚠️ Важно:** По аналогии с `val-chat`, где есть `VALIDATION_LIMITS`, нужно создать `LEO_CONFIG` для всех магических чисел.

### Шаги

#### 6.1 Создать централизованный конфиг

```typescript
// ============================
// CONFIG: LIMITS & THRESHOLDS
// ============================
const LEO_CONFIG = {
  // Кеши: TTL (в секундах)
  CACHE: {
    PERSONA_TTL_SEC: 180,        // TTL для персоны пользователя
    PROGRESS_TTL_SEC: 60,         // TTL для прогресса (короткий, т.к. меняется часто)
    RAG_TTL_SEC: 180,             // TTL для результатов RAG
    EMBEDDING_TTL_HOURS: 24,      // TTL для эмбеддингов (стабильные данные)
    GOALS_TTL_MINUTES: 5,         // TTL для целей и практики
    MAX_ENTRIES: 500,             // Максимальное количество записей в кеше
    CLEANUP_THRESHOLD: 0.8,       // Порог для очистки (80% от MAX_ENTRIES)
  },

  // Лимиты токенов для разных компонентов контекста
  TOKEN_LIMITS: {
    PERSONA: 400,                 // Максимум токенов для персоны
    MEMORIES: 500,                // Максимум токенов для памяти
    SUMMARIES: 400,               // Максимум токенов для сводок
    RAG: 1200,                    // Максимум токенов для RAG контекста
    USER_CONTEXT: 500,            // Максимум токенов для userContext
    GOALS: 300,                   // Максимум токенов для целей
    PRACTICE: 200,                // Максимум токенов для практики
  },

  // RAG конфигурация
  RAG: {
    MATCH_THRESHOLD: 0.35,        // Порог схожести для match_documents
    MATCH_COUNT: 6,               // Количество документов для поиска
    MAX_TOKENS: 1200,             // Максимум токенов в RAG ответе
    MEM_MATCH_THRESHOLD: 0.35,    // Порог для поиска в памяти
    MEM_MATCH_COUNT: 5,           // Количество результатов из памяти
  },

  // Чипы (кнопки-подсказки)
  CHIPS: {
    MAX_COUNT: 6,                 // Максимальное количество чипов
    SESSION_TTL_MIN: 30,          // TTL сессии для дедупликации (в минутах)
    MAX_LABELS: 6,                // Максимум меток для чипов
  },

  // AI параметры
  AI: {
    TEMPERATURE_DEFAULT: 0.4,     // Температура по умолчанию для чата
    TEMPERATURE_QUIZ: 0.2,        // Температура для quiz (более детерминированная)
    QUIZ_MAX_TOKENS: 180,         // Максимум токенов для quiz ответа
    QUIZ_MIN_TOKENS: 60,          // Минимум токенов для quiz ответа
    QUIZ_MAX_TOKENS_LIMIT: 300,   // Верхний лимит для quiz
  },

  // Стоимость токенов (per 1K tokens)
  COST: {
    // Grok модели (XAI)
    GROK_INPUT: 0.001,            // Входные токены для Grok
    GROK_OUTPUT: 0.003,           // Выходные токены для Grok
    
    // GPT-4.1
    GPT_4_1_INPUT: 0.002,
    GPT_4_1_OUTPUT: 0.008,
    
    // GPT-4.1-mini (default fallback)
    GPT_4_1_MINI_INPUT: 0.0004,
    GPT_4_1_MINI_OUTPUT: 0.0016,
    
    // GPT-5-mini и другие GPT модели
    GPT_5_MINI_INPUT: 0.00025,
    GPT_5_MINI_OUTPUT: 0.002,
    
    // Округление стоимости (6 знаков после запятой)
    ROUND_PRECISION: 1000000,
  },

  // Текстовые лимиты
  TEXT: {
    SUMMARIZE_CHUNK_MAX_CHARS: 400, // Максимум символов для summarizeChunk
  },
} as const;
```

#### 6.2 Обновить функцию calculateCost

```typescript
function calculateCost(usage: any, model: string = 'grok-4-fast-non-reasoning'): number {
  const inputTokens = usage?.prompt_tokens || 0;
  const outputTokens = usage?.completion_tokens || 0;
  
  let inputCostPer1K = LEO_CONFIG.COST.GPT_4_1_MINI_INPUT; // default fallback
  let outputCostPer1K = LEO_CONFIG.COST.GPT_4_1_MINI_OUTPUT;
  
  try {
    if (typeof model === 'string' && model.startsWith('grok-')) {
      // Позволяем конфигурировать через ENV, но используем конфиг как fallback
      const envIn = parseFloat(Deno.env.get('XAI_INPUT_COST_PER_1K') || String(LEO_CONFIG.COST.GROK_INPUT));
      const envOut = parseFloat(Deno.env.get('XAI_OUTPUT_COST_PER_1K') || String(LEO_CONFIG.COST.GROK_OUTPUT));
      inputCostPer1K = isFinite(envIn) ? envIn : LEO_CONFIG.COST.GROK_INPUT;
      outputCostPer1K = isFinite(envOut) ? envOut : LEO_CONFIG.COST.GROK_OUTPUT;
    } else if (model === 'gpt-4.1') {
      inputCostPer1K = LEO_CONFIG.COST.GPT_4_1_INPUT;
      outputCostPer1K = LEO_CONFIG.COST.GPT_4_1_OUTPUT;
    } else if (model === 'gpt-5-mini' || (typeof model === 'string' && model.startsWith('gpt-'))) {
      inputCostPer1K = LEO_CONFIG.COST.GPT_5_MINI_INPUT;
      outputCostPer1K = LEO_CONFIG.COST.GPT_5_MINI_OUTPUT;
    }
  } catch (_) {
    // keep defaults on any parsing error
  }
  
  const totalCost = (inputTokens * inputCostPer1K / 1000) + (outputTokens * outputCostPer1K / 1000);
  return Math.round(totalCost * LEO_CONFIG.COST.ROUND_PRECISION) / LEO_CONFIG.COST.ROUND_PRECISION;
}
```

#### 6.3 Обновить использование магических чисел

```typescript
// Вместо:
const personaTtlMs = ttlMsFromEnv('PERSONA_CACHE_TTL_SEC', 180);

// Используем:
const personaTtlMs = ttlMsFromEnv('PERSONA_CACHE_TTL_SEC', LEO_CONFIG.CACHE.PERSONA_TTL_SEC);

// Вместо:
setCached(ragCache, embeddingCacheKey, queryEmbedding, 24 * 60 * 60 * 1000);

// Используем:
setCached(
  ragCache, 
  embeddingCacheKey, 
  queryEmbedding, 
  LEO_CONFIG.CACHE.EMBEDDING_TTL_HOURS * 60 * 60 * 1000
);

// Вместо:
const cacheTtl = 5 * 60 * 1000; // 5 минут

// Используем:
const cacheTtl = LEO_CONFIG.CACHE.GOALS_TTL_MINUTES * 60 * 1000;

// Вместо:
function summarizeChunk(content: string, maxChars: number = 400): string {

// Используем:
function summarizeChunk(content: string, maxChars: number = LEO_CONFIG.TEXT.SUMMARIZE_CHUNK_MAX_CHARS): string {

// Вместо:
temperature: parseFloat(Deno.env.get("OPENAI_TEMPERATURE") || "0.4"),

// Используем:
temperature: parseFloat(Deno.env.get("OPENAI_TEMPERATURE") || String(LEO_CONFIG.AI.TEMPERATURE_DEFAULT)),

// Вместо:
const maxTokens = 180;
temperature: 0.2,
maxTokens: Math.max(60, Math.min(300, maxTokens))

// Используем:
const maxTokens = LEO_CONFIG.AI.QUIZ_MAX_TOKENS;
temperature: LEO_CONFIG.AI.TEMPERATURE_QUIZ,
maxTokens: Math.max(
  LEO_CONFIG.AI.QUIZ_MIN_TOKENS, 
  Math.min(LEO_CONFIG.AI.QUIZ_MAX_TOKENS_LIMIT, maxTokens)
)

// Вместо:
const personaCap = parseInt(Deno.env.get('PERSONA_MAX_TOKENS') || '400');

// Используем:
const personaCap = parseInt(Deno.env.get('PERSONA_MAX_TOKENS') || String(LEO_CONFIG.TOKEN_LIMITS.PERSONA));

// И так далее для всех магических чисел...
```

#### 6.4 Обновить CONFIG для RAG (уже частично есть)

```typescript
const CONFIG = {
  MODELS: {
    DEFAULT: Deno.env.get("OPENAI_MODEL") || "grok-4-fast-non-reasoning",
    EMBEDDING: Deno.env.get("OPENAI_EMBEDDING_MODEL") || "text-embedding-3-small",
  },
  RAG: {
    MATCH_THRESHOLD: parseFloat(Deno.env.get("RAG_MATCH_THRESHOLD") || String(LEO_CONFIG.RAG.MATCH_THRESHOLD)),
    MATCH_COUNT: parseInt(Deno.env.get("RAG_MATCH_COUNT") || String(LEO_CONFIG.RAG.MATCH_COUNT)),
    MAX_TOKENS: parseInt(Deno.env.get('RAG_MAX_TOKENS') || String(LEO_CONFIG.RAG.MAX_TOKENS)),
    CACHE_TTL_SEC: parseInt(Deno.env.get('RAG_CACHE_TTL_SEC') || String(LEO_CONFIG.CACHE.RAG_TTL_SEC)),
  },
} as const;
```

**Проверка:**
- ✅ Все магические числа вынесены в `LEO_CONFIG`
- ✅ Конфиг можно переопределить через ENV переменные (как сейчас)
- ✅ Код стал более читаемым и поддерживаемым
- ✅ Легко изменить лимиты в одном месте

---

## 📊 Итоговый план деплоя

| Этап | Описание | Время | Риск | Приоритет |
|------|----------|-------|------|-----------|
| **1** | Zod-валидация входных данных | 1 день | 🟢 Низкий | 🔴 CRITICAL |
| **2** | Исправление race condition | 1-2 дня | 🟡 Средний | 🔴 CRITICAL |
| **3** | Безопасный JSON.parse | 0.5 дня | 🟢 Низкий | 🔴 CRITICAL |
| **4** | Структурированное логирование | 0.5 дня | 🟢 Низкий | 🟠 HIGH |
| **5** | Лимиты на кеши | 0.5 дня | 🟢 Низкий | 🟡 MEDIUM |
| **6** | Вынос магических чисел в конфиг | 0.5 дня | 🟢 Низкий | 🟡 MEDIUM |

**Общее время:** 4-5 дней  
**Критический путь (этапы 1-3):** 2.5-3.5 дня  
**Опциональные улучшения (этапы 4-6):** 1.5 дня

---

## ✅ Чеклист перед деплоем каждого этапа

- [ ] Код протестирован локально
- [ ] Проверена обратная совместимость (старые запросы работают)
- [ ] Добавлены логи для мониторинга
- [ ] Код ревью (если есть команда)
- [ ] Деплой на staging
- [ ] Тестирование на staging (минимум 1 час)
- [ ] Мониторинг логов после деплоя в прод (первые 30 минут)

---

## 🚫 Что НЕ включено (намеренно)

- ❌ Semantic embeddings для определения уровня вопроса (overengineering)
- ❌ Circuit breaker для OpenAI (можно добавить позже, если будут проблемы)
- ❌ Сложные health-мониторинги кешей (достаточно простых лимитов)
- ❌ PL/pgSQL RPC для атомарности (можно добавить в будущем, если понадобится)

---

## 📝 Примечания

1. **Этап 2** можно разбить на подэтапы:
   - 2.1: Улучшение `saveMessages` (0.5 дня)
   - 2.2: Улучшение `updateAIMessageLeoId` (0.5 дня)
   - 2.3: Интеграция в `handleChat` (0.5 дня)

2. **Этап 4** можно делать параллельно с этапами 1-3, т.к. не влияет на логику

3. После завершения всех этапов рекомендуется:
   - Мониторинг ошибок в логах (особенно `CRITICAL saveMessages_assistant_failed`)
   - Анализ производительности (время выполнения операций)
   - Рассмотрение PL/pgSQL RPC для полной атомарности (если будут проблемы с race condition)

---

**Автор:** AI Assistant  
**Дата создания:** 2025-01-XX  
**Последнее обновление:** 2025-01-XX
