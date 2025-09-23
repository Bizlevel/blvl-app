## Анализ текущей организации user_memories

### **Структура базы данных**

**Таблица `user_memories`:**
- `id` (uuid) - первичный ключ
- `user_id` (uuid) - ссылка на пользователя
- `content` (text) - текст воспоминания
- `embedding` (vector(1536)) - векторное представление для семантического поиска
- `weight` (integer) - вес воспоминания (по умолчанию 1)
- `created_at`, `updated_at` - временные метки

**Индексы:**
- Уникальный индекс по `(user_id, content)` для предотвращения дубликатов
- HNSW/IVFFLAT индекс для векторного поиска по embedding
- Композитный индекс по `(user_id, updated_at DESC)` для быстрого получения последних воспоминаний

**Безопасность:**
- RLS (Row Level Security) включен
- Политики доступа: пользователи видят только свои воспоминания

### **Процесс создания воспоминаний**

**1. Триггерная система:**
- При вставке сообщения ассистента в `leo_messages` срабатывает триггер `trg_call_leo_memory`
- Триггер вызывает функцию `call_leo_memory_trigger()`, которая асинхронно вызывает Edge Function `leo-memory`

**2. Edge Function `leo-memory`:**
- Получает последние сообщения чата пользователя
- Отправляет их в OpenAI для извлечения фактов
- Нормализует и дедуплицирует факты
- Создает эмбеддинги для каждого факта
- Сохраняет воспоминания через `upsert` (обновляет существующие или создает новые)

**3. Извлечение фактов:**
- Использует GPT для анализа диалога
- Извлекает только релевантные для персонализации факты
- Формат: короткие строки (5-20 слов) без PII
- Возвращает JSON-массив фактов

### **Использование воспоминаний**

**В `leo-chat` функции:**
- Загружаются последние 5 воспоминаний пользователя
- Добавляются в контекст промпта как персонализация
- Используются параллельно с RAG-контекстом и сводками чатов

### **Ключевые особенности архитектуры**

**Преимущества:**
1. **Автоматическое извлечение** - воспоминания создаются автоматически при диалоге
2. **Семантический поиск** - векторные эмбеддинги позволяют находить релевантные воспоминания
3. **Дедупликация** - уникальный индекс предотвращает дубликаты
4. **Безопасность** - RLS обеспечивает изоляцию данных пользователей
5. **Масштабируемость** - HNSW индекс для быстрого векторного поиска

**Потенциальные области для улучшения:**
1. **Качество извлечения** - можно настроить промпты для лучшего извлечения фактов
2. **Управление памятью** - нет автоматической очистки старых воспоминаний
3. **Вес воспоминаний** - поле `weight` пока не используется активно
4. **Мониторинг** - нет метрик качества извлеченных воспоминаний

# Комплексная стратегия оптимизации таблицы `user_memories`

## Анализ текущей проблемы

При всего **11 тестовых пользователях** таблица уже содержит **1129 записей** (около 102 воспоминания на пользователя) и занимает **22.8 МБ**. Это составляет примерно **20 КБ на запись**, что критически много. Основной объем приходится на векторные эмбеддинги размерностью 1536 (float32), занимающие около **6 КБ на вектор**.

**Прогноз для продакшена:** При 1000 активных пользователей таблица может достичь **~20 ГБ**, что создаст серьезные проблемы производительности и затрат на хранение.

## Рекомендуемая стратегия по приоритетам
Я произвел анализ различных решений и проранжировал их по соотношению **эффективность/сложность**. Вот план внедрения по приоритетам:

### 🚀 **ЭТАП 1: Критические меры (1-2 недели)**

#### 1. Лимит воспоминаний на пользователя (**Приоритет #1**)
- **Эффективность:** 8/10 | **Сложность:** 1/10 | **Экономия:** 30-40%
- **Время реализации:** 1-2 дня
- Ограничение до 50 активных воспоминаний с автоматическим удалением старых

CREATE OR REPLACE FUNCTION limit_user_memories()
RETURNS trigger AS $$
BEGIN
  -- Удаляем старые воспоминания, если превышен лимит
  DELETE FROM user_memories 
  WHERE user_id = NEW.user_id 
    AND id NOT IN (
      SELECT id FROM user_memories 
      WHERE user_id = NEW.user_id 
      ORDER BY weight DESC, updated_at DESC 
      LIMIT 50
    );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

#### 2. Переход на halfvec (**Приоритет #2**)
- **Эффективность:** 9/10 | **Сложность:** 2/10 | **Экономия:** 50%
- **Время реализации:** 1 неделя  
- Использование halfvec вместо vector для сокращения размера эмбеддингов в 2 раза

**Примеры SQL для перехода на halfvec:**
```sql
-- Проверяем поддержку halfvec в PostgreSQL
SELECT * FROM pg_extension WHERE extname = 'vector';

-- Создаем новую таблицу с halfvec (16-bit float вместо 32-bit)
CREATE TABLE user_memories_halfvec (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  content text NOT NULL,
  embedding halfvec(1536), -- 16-bit вместо 32-bit = 50% экономии
  weight integer NOT NULL DEFAULT 1,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- Создаем индексы для halfvec
CREATE INDEX user_memories_halfvec_user_content_idx 
  ON user_memories_halfvec(user_id, content);

CREATE INDEX user_memories_halfvec_embedding_hnsw 
  ON user_memories_halfvec USING hnsw (embedding halfvec_cosine_ops) 
  WITH (m=16, ef_construction=64);

-- Функция миграции данных из vector в halfvec
CREATE OR REPLACE FUNCTION migrate_to_halfvec()
RETURNS void AS $$
DECLARE
  batch_size integer := 1000;
  processed integer := 0;
  total_count integer;
BEGIN
  -- Получаем общее количество записей
  SELECT COUNT(*) INTO total_count FROM user_memories;
  
  -- Мигрируем данные батчами
  WHILE processed < total_count LOOP
    INSERT INTO user_memories_halfvec (id, user_id, content, embedding, weight, created_at, updated_at)
    SELECT id, user_id, content, embedding::halfvec, weight, created_at, updated_at
    FROM user_memories 
    WHERE id NOT IN (SELECT id FROM user_memories_halfvec)
    LIMIT batch_size;
    
    processed := processed + batch_size;
    
    -- Логируем прогресс
    RAISE NOTICE 'Migrated % of % records', processed, total_count;
    
    -- Небольшая пауза между батчами
    PERFORM pg_sleep(0.1);
  END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Функция для безопасного переключения таблиц
CREATE OR REPLACE FUNCTION switch_to_halfvec()
RETURNS void AS $$
BEGIN
  -- Переименовываем старую таблицу
  ALTER TABLE user_memories RENAME TO user_memories_old;
  
  -- Переименовываем новую таблицу
  ALTER TABLE user_memories_halfvec RENAME TO user_memories;
  
  -- Обновляем политики RLS
  DROP POLICY IF EXISTS "Allow select own memories" ON user_memories;
  DROP POLICY IF EXISTS "Allow insert own memories" ON user_memories;
  DROP POLICY IF EXISTS "Allow update own memories" ON user_memories;
  DROP POLICY IF EXISTS "Allow delete own memories" ON user_memories;
  
  CREATE POLICY "Allow select own memories" ON user_memories
    FOR select USING (auth.uid() = user_id);
  
  CREATE POLICY "Allow insert own memories" ON user_memories
    FOR insert WITH check (auth.uid() = user_id);
  
  CREATE POLICY "Allow update own memories" ON user_memories
    FOR update USING (auth.uid() = user_id);
  
  CREATE POLICY "Allow delete own memories" ON user_memories
    FOR delete USING (auth.uid() = user_id);
    
  RAISE NOTICE 'Successfully switched to halfvec table';
END;
$$ LANGUAGE plpgsql;

-- Функция для отката (если что-то пойдет не так)
CREATE OR REPLACE FUNCTION rollback_from_halfvec()
RETURNS void AS $$
BEGIN
  -- Переименовываем halfvec таблицу обратно
  ALTER TABLE user_memories RENAME TO user_memories_halfvec;
  
  -- Восстанавливаем оригинальную таблицу
  ALTER TABLE user_memories_old RENAME TO user_memories;
  
  RAISE NOTICE 'Rolled back to original vector table';
END;
$$ LANGUAGE plpgsql;

-- Проверка размера до и после миграции
CREATE OR REPLACE FUNCTION check_table_sizes()
RETURNS TABLE(table_name text, size_mb numeric) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    schemaname||'.'||tablename as table_name,
    ROUND(pg_total_relation_size(schemaname||'.'||tablename) / 1024.0 / 1024.0, 2) as size_mb
  FROM pg_tables 
  WHERE tablename LIKE '%user_memories%'
  ORDER BY size_mb DESC;
END;
$$ LANGUAGE plpgsql;
```

**Преимущества halfvec:**
- **50% экономии места** (16-bit vs 32-bit float)
- **Сохранение точности** для большинства ML задач
- **Совместимость** с существующими vector операциями
- **Простая миграция** с возможностью отката

#### 3. TTL политики (**Приоритет #3**)
- **Эффективность:** 8/10 | **Сложность:** 2/10 | **Экономия:** 40-50%
- **Время реализации:** 3-5 дней
- Автоматическое удаление воспоминаний старше 90 дней с весом = 1

CREATE OR REPLACE FUNCTION cleanup_old_memories()
RETURNS void AS $$
BEGIN
  DELETE FROM user_memories 
  WHERE created_at < NOW() - INTERVAL '90 days'
    AND weight = 1; -- Удаляем только неважные воспоминания
END;
$$ LANGUAGE plpgsql;

-- Cron задача для еженедельной очистки
SELECT cron.schedule('cleanup-memories', '0 2 * * 0', 'SELECT cleanup_old_memories();');

#### 4. Фильтрация при создании (**Приоритет #4**)
- **Эффективность:** 7/10 | **Сложность:** 2/10 | **Экономия:** 25-35%
- **Время реализации:** 2-3 дня
- Предотвращение создания коротких/технических/повторяющихся воспоминаний

**Примеры SQL для фильтрации:**
```sql
-- Функция для поиска семантически похожих воспоминаний
CREATE OR REPLACE FUNCTION find_similar_memories(
  target_embedding vector(1536),
  target_user_id uuid,
  similarity_threshold float DEFAULT 0.85
)
RETURNS TABLE(id uuid, content text, similarity float) AS $$
BEGIN
  RETURN QUERY
  SELECT m.id, m.content, 
         1 - (m.embedding <=> target_embedding) as similarity
  FROM user_memories m
  WHERE m.user_id = target_user_id
    AND 1 - (m.embedding <=> target_embedding) > similarity_threshold
  ORDER BY similarity DESC;
END;
$$ LANGUAGE plpgsql;

-- Триггер для проверки качества перед вставкой
CREATE OR REPLACE FUNCTION check_memory_quality()
RETURNS trigger AS $$
BEGIN
  -- Проверяем длину контента
  IF LENGTH(NEW.content) < 50 THEN
    RAISE EXCEPTION 'Memory content too short (minimum 50 characters)';
  END IF;
  
  -- Проверяем на дубликаты по семантическому сходству
  IF EXISTS (
    SELECT 1 FROM find_similar_memories(NEW.embedding, NEW.user_id, 0.9)
  ) THEN
    RAISE EXCEPTION 'Similar memory already exists';
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

### ⚡ **ЭТАП 2: Среднесрочные оптимизации (1-2 месяца)**

#### 5. Система архивирования
- **Эффективность:** 8/10 | **Сложность:** 5/10 | **Экономия:** 60-80%
- Перенос старых данных в файловое хранилище (CSV/Parquet)

**Примеры SQL для архивирования:**
```sql
-- Создание архивной таблицы
CREATE TABLE user_memories_archive (
  LIKE user_memories INCLUDING ALL,
  archived_at timestamptz DEFAULT NOW(),
  archive_reason text NOT NULL -- 'age', 'low_weight', 'aggregated'
);

-- Функция архивирования старых воспоминаний
CREATE OR REPLACE FUNCTION archive_old_memories()
RETURNS void AS $$
BEGIN
  -- Архивируем воспоминания старше 6 месяцев
  INSERT INTO user_memories_archive 
  SELECT *, NOW(), 'age' as archive_reason
  FROM user_memories 
  WHERE created_at < NOW() - INTERVAL '6 months';
  
  -- Удаляем архивированные записи из основной таблицы
  DELETE FROM user_memories 
  WHERE created_at < NOW() - INTERVAL '6 months';
  
  -- Архивируем воспоминания с низким весом
  INSERT INTO user_memories_archive 
  SELECT *, NOW(), 'low_weight' as archive_reason
  FROM user_memories 
  WHERE weight = 1 AND updated_at < NOW() - INTERVAL '3 months';
  
  DELETE FROM user_memories 
  WHERE weight = 1 AND updated_at < NOW() - INTERVAL '3 months';
END;
$$ LANGUAGE plpgsql;

-- Функция экспорта в CSV для холодного хранения
CREATE OR REPLACE FUNCTION export_memories_to_csv()
RETURNS void AS $$
BEGIN
  COPY (
    SELECT user_id, content, weight, created_at, archived_at
    FROM user_memories_archive 
    WHERE archived_at < NOW() - INTERVAL '1 year'
  ) TO '/tmp/cold_storage_memories.csv' 
  WITH CSV HEADER;
  
  -- Удаляем экспортированные записи
  DELETE FROM user_memories_archive 
  WHERE archived_at < NOW() - INTERVAL '1 year';
END;
$$ LANGUAGE plpgsql;

-- Автоматическая архивация (cron)
SELECT cron.schedule('archive-memories', '0 3 * * 0', 'SELECT archive_old_memories();');
SELECT cron.schedule('export-cold-storage', '0 4 1 * *', 'SELECT export_memories_to_csv();');
```

#### 6. Логирование использования + деградация весов
- **Эффективность:** 6/10 | **Сложность:** 4/10 | **Экономия:** 15-25%
- Отслеживание использования воспоминаний и снижение веса неактивных

Обновление системы весов:
-- Функция для обновления веса воспоминаний на основе использования
CREATE OR REPLACE FUNCTION update_memory_weights()
RETURNS void AS $$
BEGIN
  -- Увеличиваем вес воспоминаний, которые часто используются в контексте
  UPDATE user_memories 
  SET weight = LEAST(weight + 1, 10),
      updated_at = NOW()
  WHERE id IN (
    SELECT memory_id FROM memory_usage_logs 
    WHERE used_at > NOW() - INTERVAL '7 days'
    GROUP BY memory_id 
    HAVING COUNT(*) > 2
  );
  
  -- Уменьшаем вес неиспользуемых воспоминаний
  UPDATE user_memories 
  SET weight = GREATEST(weight - 1, 1)
  WHERE updated_at < NOW() - INTERVAL '30 days'
    AND weight > 1;
END;
$$ LANGUAGE plpgsql;

Таблица логирования использования воспоминаний:
CREATE TABLE memory_usage_logs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  memory_id uuid REFERENCES user_memories(id) ON DELETE CASCADE,
  user_id uuid REFERENCES users(id) ON DELETE CASCADE,
  context_type text NOT NULL, -- 'chat', 'recommendation', etc.
  used_at timestamptz DEFAULT NOW()
);

CREATE INDEX memory_usage_logs_memory_idx ON memory_usage_logs(memory_id);
CREATE INDEX memory_usage_logs_user_time_idx ON memory_usage_logs(user_id, used_at DESC);

#### 7. Временное партиционирование
- **Эффективность:** 6/10 | **Сложность:** 4/10 | **Экономия:** производительность
- Разделение таблицы на месячные партиции для ускорения запросов

**Примеры SQL для партиционирования:**
```sql
-- Создаем партиционированную таблицу по месяцам
CREATE TABLE user_memories_partitioned (
  id uuid NOT NULL,
  user_id uuid NOT NULL,
  content text NOT NULL,
  embedding vector(1536),
  weight integer NOT NULL DEFAULT 1,
  created_at timestamptz NOT NULL,
  updated_at timestamptz NOT NULL,
  PRIMARY KEY (id, created_at)
) PARTITION BY RANGE (created_at);

-- Создаем партиции на несколько месяцев вперед
CREATE TABLE user_memories_2024_01 PARTITION OF user_memories_partitioned
  FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');

CREATE TABLE user_memories_2024_02 PARTITION OF user_memories_partitioned
  FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');

CREATE TABLE user_memories_2024_03 PARTITION OF user_memories_partitioned
  FOR VALUES FROM ('2024-03-01') TO ('2024-04-01');

-- Создаем партиции для текущего и следующих месяцев
CREATE TABLE user_memories_current PARTITION OF user_memories_partitioned
  FOR VALUES FROM (DATE_TRUNC('month', NOW())) TO (DATE_TRUNC('month', NOW() + INTERVAL '1 month'));

CREATE TABLE user_memories_next PARTITION OF user_memories_partitioned
  FOR VALUES FROM (DATE_TRUNC('month', NOW() + INTERVAL '1 month')) TO (DATE_TRUNC('month', NOW() + INTERVAL '2 months'));

-- Создаем индексы для каждой партиции
CREATE INDEX user_memories_current_user_idx ON user_memories_current(user_id, created_at DESC);
CREATE INDEX user_memories_current_embedding_idx ON user_memories_current USING hnsw (embedding vector_cosine_ops);

-- Функция для автоматического создания партиций
CREATE OR REPLACE FUNCTION create_monthly_partitions()
RETURNS void AS $$
DECLARE
  partition_name text;
  start_date date;
  end_date date;
  i integer;
BEGIN
  -- Создаем партиции на 6 месяцев вперед
  FOR i IN 0..5 LOOP
    start_date := DATE_TRUNC('month', NOW() + (i || ' months')::interval)::date;
    end_date := DATE_TRUNC('month', NOW() + ((i + 1) || ' months')::interval)::date;
    partition_name := 'user_memories_' || TO_CHAR(start_date, 'YYYY_MM');
    
    -- Проверяем, существует ли партиция
    IF NOT EXISTS (
      SELECT 1 FROM pg_tables 
      WHERE tablename = partition_name 
        AND schemaname = 'public'
    ) THEN
      EXECUTE format('
        CREATE TABLE %I PARTITION OF user_memories_partitioned
        FOR VALUES FROM (%L) TO (%L)',
        partition_name, start_date, end_date
      );
      
      -- Создаем индексы для новой партиции
      EXECUTE format('CREATE INDEX %I ON %I (user_id, created_at DESC)',
        partition_name || '_user_idx', partition_name);
        
      EXECUTE format('CREATE INDEX %I ON %I USING hnsw (embedding vector_cosine_ops)',
        partition_name || '_embedding_idx', partition_name);
        
      RAISE NOTICE 'Created partition % for period % to %', partition_name, start_date, end_date;
    END IF;
  END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Функция для удаления старых партиций
CREATE OR REPLACE FUNCTION drop_old_partitions()
RETURNS void AS $$
DECLARE
  partition_name text;
  partition_date date;
BEGIN
  -- Удаляем партиции старше 12 месяцев
  FOR partition_name, partition_date IN 
    SELECT tablename, 
           TO_DATE(SUBSTRING(tablename FROM 'user_memories_(\d{4}_\d{2})'), 'YYYY_MM')
    FROM pg_tables 
    WHERE tablename LIKE 'user_memories_%' 
      AND schemaname = 'public'
      AND tablename != 'user_memories_partitioned'
  LOOP
    IF partition_date < NOW() - INTERVAL '12 months' THEN
      EXECUTE format('DROP TABLE IF EXISTS %I CASCADE', partition_name);
      RAISE NOTICE 'Dropped old partition %', partition_name;
    END IF;
  END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Функция миграции данных в партиционированную таблицу
CREATE OR REPLACE FUNCTION migrate_to_partitioned()
RETURNS void AS $$
DECLARE
  batch_size integer := 1000;
  processed integer := 0;
  total_count integer;
BEGIN
  -- Получаем общее количество записей
  SELECT COUNT(*) INTO total_count FROM user_memories;
  
  -- Мигрируем данные батчами
  WHILE processed < total_count LOOP
    INSERT INTO user_memories_partitioned (id, user_id, content, embedding, weight, created_at, updated_at)
    SELECT id, user_id, content, embedding, weight, created_at, updated_at
    FROM user_memories 
    WHERE id NOT IN (SELECT id FROM user_memories_partitioned)
    LIMIT batch_size;
    
    processed := processed + batch_size;
    
    -- Логируем прогресс
    RAISE NOTICE 'Migrated % of % records to partitioned table', processed, total_count;
    
    -- Небольшая пауза между батчами
    PERFORM pg_sleep(0.1);
  END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Функция для автоматического управления партициями (cron)
CREATE OR REPLACE FUNCTION manage_partitions()
RETURNS void AS $$
BEGIN
  -- Создаем новые партиции
  PERFORM create_monthly_partitions();
  
  -- Удаляем старые партиции
  PERFORM drop_old_partitions();
  
  RAISE NOTICE 'Partition management completed';
END;
$$ LANGUAGE plpgsql;

-- Автоматическое управление партициями (cron)
SELECT cron.schedule('manage-partitions', '0 1 1 * *', 'SELECT manage_partitions();');

-- Функция для анализа производительности партиций
CREATE OR REPLACE FUNCTION analyze_partition_performance()
RETURNS TABLE(
  partition_name text,
  row_count bigint,
  size_mb numeric,
  avg_query_time_ms numeric
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    t.tablename::text as partition_name,
    COALESCE(s.n_tup_ins - s.n_tup_del, 0) as row_count,
    ROUND(pg_total_relation_size('public.'||t.tablename) / 1024.0 / 1024.0, 2) as size_mb,
    COALESCE(ROUND(s.n_tup_ins::numeric / NULLIF(EXTRACT(EPOCH FROM (NOW() - s.last_vacuum)), 0) * 1000, 2), 0) as avg_query_time_ms
  FROM pg_tables t
  LEFT JOIN pg_stat_user_tables s ON t.tablename = s.relname
  WHERE t.tablename LIKE 'user_memories_%'
    AND t.schemaname = 'public'
  ORDER BY size_mb DESC;
END;
$$ LANGUAGE plpgsql;
```

**Преимущества партиционирования:**
- **Ускорение запросов** по времени (автоматическое исключение ненужных партиций)
- **Параллельная обработка** запросов по разным партициям
- **Быстрое удаление** старых данных (DROP TABLE вместо DELETE)
- **Индексирование** только активных партиций
- **Масштабируемость** для больших объемов данных

#### 8. Агрегация старых воспоминаний
- **Эффективность:** 7/10 | **Сложность:** 5/10 | **Экономия:** 30-40%
- Объединение схожих воспоминаний в сводки по периодам

Создание таблицы для агрегации воспоминаний
CREATE TABLE user_memory_summaries (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  period_start timestamptz NOT NULL,
  period_end timestamptz NOT NULL,
  aggregated_facts text[] NOT NULL,
  embedding vector(1536),
  importance_score float DEFAULT 0.5,
  created_at timestamptz DEFAULT NOW()
);

-- Индексы для быстрого поиска
CREATE INDEX user_memory_summaries_user_period_idx 
  ON user_memory_summaries(user_id, period_end DESC);

Сама функция для агрегации воспоминаний:
CREATE OR REPLACE FUNCTION aggregate_user_memories(
  target_user_id uuid,
  days_back integer DEFAULT 30
)
RETURNS void AS $$
DECLARE
  memory_group RECORD;
  aggregated_content text;
BEGIN
  -- Получаем воспоминания за период
  SELECT array_agg(content ORDER BY weight DESC, updated_at DESC) as facts
  INTO memory_group
  FROM user_memories 
  WHERE user_id = target_user_id 
    AND created_at >= NOW() - (days_back || ' days')::interval;
  
  -- Создаем агрегированное воспоминание
  IF memory_group.facts IS NOT NULL AND array_length(memory_group.facts, 1) > 0 THEN
    -- Группируем похожие воспоминания и создаем сводку
    INSERT INTO user_memory_summaries (user_id, period_start, period_end, aggregated_facts)
    VALUES (
      target_user_id,
      NOW() - (days_back || ' days')::interval,
      NOW(),
      memory_group.facts
    );
    
    -- Удаляем оригинальные воспоминания
    DELETE FROM user_memories 
    WHERE user_id = target_user_id 
      AND created_at >= NOW() - (days_back || ' days')::interval;
  END IF;
END;
$$ LANGUAGE plpgsql;


### 🔬 **ЭТАП 3: Продвинутые техники (при критических объемах >100 ГБ)**
**Только при экстремальных нагрузках:**
#### 9. Квантизация до int8 (**Приоритет #9**)
- **Эффективность:** 8/10 | **Сложность:** 6/10 | **Экономия:** 75%
- Сжатие float32 → int8 с контролируемой потерей точности

**Примеры SQL для квантизации:**
```sql
-- Создание таблицы для квантизованных эмбеддингов
CREATE TABLE user_memory_embeddings_quantized (
  memory_id uuid PRIMARY KEY REFERENCES user_memories(id) ON DELETE CASCADE,
  embedding_int8 int8[], -- Квантизованный эмбеддинг (75% экономии)
  min_val float,
  max_val float,
  quantized_at timestamptz DEFAULT NOW()
);

-- Функция для квантизации float32 -> int8
CREATE OR REPLACE FUNCTION quantize_embeddings()
RETURNS void AS $$
BEGIN
  -- Квантизуем эмбеддинги для архивных воспоминаний
  INSERT INTO user_memory_embeddings_quantized (memory_id, embedding_int8, min_val, max_val)
  SELECT 
    id,
    ARRAY(
      SELECT (embedding[i] - min_val) * 255 / (max_val - min_val)::int8
      FROM generate_subscripts(embedding, 1) as i
    ) as embedding_int8,
    min_val,
    max_val
  FROM (
    SELECT 
      id,
      embedding,
      min(unnest(embedding)) as min_val,
      max(unnest(embedding)) as max_val
    FROM user_memories 
    WHERE weight = 1 AND created_at < NOW() - INTERVAL '3 months'
    GROUP BY id, embedding
  ) quantized_data;
END;
$$ LANGUAGE plpgsql;

-- Функция восстановления квантизованного эмбеддинга
CREATE OR REPLACE FUNCTION dequantize_embedding(
  embedding_int8 int8[],
  min_val float,
  max_val float
)
RETURNS vector(1536) AS $$
BEGIN
  RETURN ARRAY(
    SELECT (embedding_int8[i]::float * (max_val - min_val) / 255 + min_val)::float
    FROM generate_subscripts(embedding_int8, 1) as i
  )::vector(1536);
END;
$$ LANGUAGE plpgsql;
```

#### 10. Binary embeddings (**Приоритет #10**)
- **Эффективность:** 9/10 | **Сложность:** 8/10 | **Экономия:** 95%
- Радикальное сжатие до битовых векторов

**Примеры SQL для binary embeddings:**
```sql
-- Создание таблицы для бинарных эмбеддингов
CREATE TABLE user_memory_embeddings_binary (
  memory_id uuid PRIMARY KEY REFERENCES user_memories(id) ON DELETE CASCADE,
  embedding_binary bit(1536), -- Бинарный вектор (95% экономии)
  threshold float DEFAULT 0.0,
  created_at timestamptz DEFAULT NOW()
);

-- Функция конвертации в бинарный формат
CREATE OR REPLACE FUNCTION convert_to_binary_embedding(
  input_vector vector(1536),
  threshold_val float DEFAULT 0.0
)
RETURNS bit(1536) AS $$
BEGIN
  RETURN (
    SELECT string_agg(
      CASE WHEN input_vector[i] > threshold_val THEN '1' ELSE '0' END, 
      ''
    )::bit(1536)
    FROM generate_subscripts(input_vector, 1) as i
  );
END;
$$ LANGUAGE plpgsql;

-- Функция для массовой конвертации в binary
CREATE OR REPLACE FUNCTION convert_embeddings_to_binary()
RETURNS void AS $$
BEGIN
  INSERT INTO user_memory_embeddings_binary (memory_id, embedding_binary, threshold)
  SELECT 
    id,
    convert_to_binary_embedding(embedding),
    0.0
  FROM user_memories 
  WHERE weight = 1 
    AND created_at < NOW() - INTERVAL '6 months'
    AND id NOT IN (SELECT memory_id FROM user_memory_embeddings_binary);
END;
$$ LANGUAGE plpgsql;
```

#### 11. Иерархическая система (hot/warm/cold) (**Приоритет #11**)
- **Эффективность:** 8/10 | **Сложность:** 9/10 | **Экономия:** 70-90%
- Многоуровневое хранение с автоматическим перемещением данных

**Примеры SQL для иерархической системы:**
```sql
-- Создание отдельной таблицы для эмбеддингов (warm storage)
CREATE TABLE user_memory_embeddings_warm (
  memory_id uuid PRIMARY KEY REFERENCES user_memories(id) ON DELETE CASCADE,
  embedding_full vector(1536),     -- Полный эмбеддинг
  embedding_compressed vector(768), -- Сжатая версия (50% размера)
  compression_ratio float DEFAULT 0.5,
  last_updated timestamptz DEFAULT NOW()
);

-- Функция перемещения в warm storage
CREATE OR REPLACE FUNCTION move_to_warm_storage()
RETURNS void AS $$
BEGIN
  -- Перемещаем эмбеддинги воспоминаний с низким весом
  INSERT INTO user_memory_embeddings_warm (memory_id, embedding_full, embedding_compressed)
  SELECT 
    id,
    embedding,
    embedding[1:768] as embedding_compressed
  FROM user_memories 
  WHERE weight <= 3 
    AND array_length(embedding, 1) = 1536
    AND id NOT IN (SELECT memory_id FROM user_memory_embeddings_warm);
    
  -- Удаляем полные эмбеддинги из основной таблицы
  UPDATE user_memories 
  SET embedding = NULL
  WHERE weight <= 3 
    AND id IN (SELECT memory_id FROM user_memory_embeddings_warm);
END;
$$ LANGUAGE plpgsql;

-- Автоматическое управление storage (cron)
SELECT cron.schedule('move-to-warm', '0 5 * * 0', 'SELECT move_to_warm_storage();');
SELECT cron.schedule('quantize-old-embeddings', '0 6 1 * *', 'SELECT quantize_embeddings();');
```

## Ожидаемые результаты
Создать мониторинг роста:
   CREATE VIEW memory_growth_stats AS
   SELECT 
     DATE_TRUNC('day', created_at) as date,
     COUNT(*) as new_memories,
     COUNT(DISTINCT user_id) as active_users,
     AVG(LENGTH(content)) as avg_content_length
   FROM user_memories 
   GROUP BY DATE_TRUNC('day', created_at)
   ORDER BY date DESC;
   
**После этапа 1 (2 недели):**
- Сокращение размера таблицы с 22.8 МБ до **5-7 МБ** (экономия 70-80%)
- Контролируемый рост новых записей
- Стабильная производительность

**После этапа 2 (2-3 месяца):**
- Дополнительная оптимизация на 20-30%
- Полная автоматизация управления данными
- Готовность к продакшн нагрузкам




