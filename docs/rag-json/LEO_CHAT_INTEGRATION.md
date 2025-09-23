# Интеграция новой RAG системы с leo-chat

## 🎯 Цель
Интеграция новой JSON-основанной RAG системы в существующий leo-chat сервис с поддержкой fallback на старую систему.

## 📁 Файлы для интеграции

### 1. Новые файлы
- `leo_chat_new_retriever.py` - новый ретривер с гибридным поиском
- `leo_chat_config.py` - конфигурация RAG системы
- `test_new_rag.py` - тестирование новой системы

### 2. Изменения в существующих файлах
- `supabase/functions/leo-chat/index.ts` - основная функция leo-chat
- `supabase/migrations/` - новые функции поиска

## 🔧 Пошаговая интеграция

### Шаг 1: Подготовка файлов

1. **Скопируйте файлы в проект:**
```bash
# В корне проекта
cp docs/rag-json/leo_chat_new_retriever.py supabase/functions/leo-chat/
cp docs/rag-json/leo_chat_config.py supabase/functions/leo-chat/
cp docs/rag-json/test_new_rag.py supabase/functions/leo-chat/
```

2. **Установите зависимости:**
```bash
# В supabase/functions/leo-chat/
npm install aiohttp
```

### Шаг 2: Изменения в leo-chat/index.ts

#### 2.1 Добавьте импорт новой RAG системы:
```typescript
// В начале файла, после существующих импортов
import { perform_new_rag_query } from './leo_chat_new_retriever.py';
import { LeoChatConfig } from './leo_chat_config.py';
```

#### 2.2 Замените функцию performRAGQuery:
```typescript
// Замените существующую функцию performRAGQuery на:
async function performRAGQuery(lastUserMessage, levelContext, userId, ragCache, openaiInstance, supabaseAdminInstance) {
  try {
    // Проверяем, включена ли новая RAG система
    const useNewRAG = Deno.env.get("USE_NEW_RAG") !== "false";
    
    if (useNewRAG) {
      // Используем новую RAG систему
      const config = {
        use_new_rag: true,
        fallback_to_old: Deno.env.get("RAG_FALLBACK_TO_OLD") !== "false",
        supabase_url: Deno.env.get("SUPABASE_URL"),
        supabase_key: Deno.env.get("SUPABASE_ANON_KEY"),
        openai_api_key: Deno.env.get("OPENAI_API_KEY"),
        embedding_model: Deno.env.get("OPENAI_EMBEDDING_MODEL") || "text-embedding-3-small",
        match_threshold: parseFloat(Deno.env.get("RAG_MATCH_THRESHOLD") || "0.35"),
        match_count: parseInt(Deno.env.get("RAG_MATCH_COUNT") || "6"),
        max_tokens: parseInt(Deno.env.get("RAG_MAX_TOKENS") || "1200")
      };
      
      const result = await perform_new_rag_query(
        lastUserMessage,
        levelContext,
        userId,
        config
      );
      
      if (result) {
        return result;
      }
      
      // Если новая система не дала результатов и включен fallback
      if (config.fallback_to_old) {
        console.log("🔄 Fallback на старую RAG систему");
        // Продолжаем выполнение старой логики
      }
    }
    
    // Существующая логика старой RAG системы (fallback)
    const embeddingModel = Deno.env.get("OPENAI_EMBEDDING_MODEL") || "text-embedding-3-small";
    const matchThreshold = parseFloat(Deno.env.get("RAG_MATCH_THRESHOLD") || "0.35");
    const matchCount = parseInt(Deno.env.get("RAG_MATCH_COUNT") || "6");
    const ragTtlMs = ttlMsFromEnv('RAG_CACHE_TTL_SEC', 180);

    const normalized = (lastUserMessage || '').toLowerCase().trim();
    const ragKeyBase = `${userId || 'anon'}::${hashQuery(normalized)}`;
    const cachedRag = getCached(ragCache, ragKeyBase);
    if (cachedRag) {
      return cachedRag;
    }

    // ... остальная логика старой системы ...
    
  } catch (e) {
    console.error('ERR rag_pipeline', {
      message: String(e).slice(0, 240)
    });
    return '';
  }
}
```

### Шаг 3: Настройка переменных окружения

Добавьте в `.env` файл или переменные окружения Supabase:

```bash
# Новая RAG система
USE_NEW_RAG=true
RAG_FALLBACK_TO_OLD=true

# Существующие переменные (убедитесь, что они установлены)
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
OPENAI_API_KEY=sk-your-openai-key

# RAG параметры
RAG_MATCH_THRESHOLD=0.35
RAG_MATCH_COUNT=6
RAG_MAX_TOKENS=1200
OPENAI_EMBEDDING_MODEL=text-embedding-3-small
```

### Шаг 4: Создание функций поиска в Supabase

Выполните миграцию для создания новых функций:

```sql
-- В Supabase SQL Editor или через миграцию
-- Функция гибридного поиска
CREATE OR REPLACE FUNCTION search_lesson_facts(
    query_text TEXT,
    query_embedding VECTOR(1536),
    level_filter INTEGER DEFAULT NULL,
    section_filter TEXT DEFAULT NULL,
    limit_count INTEGER DEFAULT 10
)
RETURNS TABLE(
    id TEXT,
    content TEXT,
    lesson_id INTEGER,
    level_number INTEGER,
    section TEXT,
    title TEXT,
    similarity DOUBLE PRECISION
)
LANGUAGE SQL
STABLE
AS $$
    SELECT 
        lf.id,
        lf.content,
        lf.lesson_id,
        lf.level_number,
        lf.section,
        lf.title,
        1 - (lf.embedding <=> query_embedding) as similarity
    FROM lesson_facts lf
    WHERE 
        (level_filter IS NULL OR lf.level_number = level_filter)
        AND (section_filter IS NULL OR lf.section = section_filter)
        AND (1 - (lf.embedding <=> query_embedding)) >= 0.3
    ORDER BY lf.embedding <=> query_embedding ASC
    LIMIT limit_count;
$$;

-- Функция поиска по уровню
CREATE OR REPLACE FUNCTION search_by_level(
    level_number INTEGER,
    query_text TEXT DEFAULT '',
    limit_count INTEGER DEFAULT 20
)
RETURNS TABLE(
    id TEXT,
    content TEXT,
    lesson_id INTEGER,
    section TEXT,
    title TEXT
)
LANGUAGE SQL
STABLE
AS $$
    SELECT 
        lf.id,
        lf.content,
        lf.lesson_id,
        lf.section,
        lf.title
    FROM lesson_facts lf
    WHERE lf.level_number = level_number
    ORDER BY lf.created_at DESC
    LIMIT limit_count;
$$;
```

### Шаг 5: Тестирование

1. **Запустите тесты:**
```bash
cd supabase/functions/leo-chat/
python test_new_rag.py
```

2. **Проверьте логи leo-chat:**
```bash
# В Supabase Dashboard -> Functions -> leo-chat -> Logs
# Ищите сообщения о новой RAG системе
```

3. **Тестируйте через API:**
```bash
curl -X POST https://your-project.supabase.co/functions/v1/leo-chat \
  -H "Authorization: Bearer your-anon-key" \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [{"role": "user", "content": "Как поставить цели?"}],
    "levelContext": "level_id=11"
  }'
```

## 🔄 Управление системой

### Включение/отключение новой RAG
```bash
# Включить новую RAG
export USE_NEW_RAG=true

# Отключить новую RAG (только старая система)
export USE_NEW_RAG=false

# Отключить fallback (только новая система)
export RAG_FALLBACK_TO_OLD=false
```

### Мониторинг
```sql
-- Проверка работы новой системы
SELECT 
    level_number,
    COUNT(*) as facts_count,
    AVG(array_length(embedding, 1)) as avg_embedding_size
FROM lesson_facts 
GROUP BY level_number;

-- Проверка последних поисков
SELECT * FROM lesson_facts 
WHERE created_at > NOW() - INTERVAL '1 hour'
ORDER BY created_at DESC;
```

## ⚠️ Важные замечания

1. **Fallback**: Всегда оставляйте `RAG_FALLBACK_TO_OLD=true` для безопасности
2. **Тестирование**: Протестируйте на dev-окружении перед продакшеном
3. **Мониторинг**: Настройте алерты на ошибки RAG системы
4. **Производительность**: Следите за временем ответа и качеством результатов

## 🐛 Устранение неполадок

### Ошибка "Module not found"
- Убедитесь, что файлы скопированы в правильную директорию
- Проверьте импорты в index.ts

### Ошибка "Function not found"
- Выполните миграцию для создания функций поиска
- Проверьте права доступа к таблицам

### Пустые результаты
- Проверьте, что данные загружены в таблицы
- Убедитесь, что эмбеддинги сгенерированы
- Проверьте фильтры по уровням

### Медленная работа
- Проверьте индексы в базе данных
- Уменьшите `RAG_MATCH_COUNT` если нужно
- Проверьте кэширование эмбеддингов
