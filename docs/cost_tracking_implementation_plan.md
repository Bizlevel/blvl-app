# План реализации системы подсчета и контроля расходов на ботов

## Цель
Создать внутреннюю систему учета стоимости запросов к AI моделям для анализа расходов и формирования ценовой политики.

## Область применения
- Отслеживание стоимости запросов к Лео (с RAG), Максу (без RAG), Quiz режиму
- Агрегированная статистика по месяцам и типам ботов
- Внутренняя аналитика для планирования расходов

## Этап 1: Подготовка базы данных

### 1.1 Создание таблицы ai_message
```sql
-- Таблица для учета AI запросов и их стоимости
CREATE TABLE IF NOT EXISTS public.ai_message (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  leo_message_id uuid REFERENCES public.leo_messages(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  chat_id uuid NOT NULL REFERENCES public.leo_chats(id) ON DELETE CASCADE,
  
  -- AI-специфичные данные
  model_used text NOT NULL DEFAULT 'gpt-4.1-mini',
  input_tokens integer NOT NULL,
  output_tokens integer NOT NULL,
  total_tokens integer NOT NULL,
  cost_usd numeric(10,6) NOT NULL,
  
  -- Контекст запроса
  bot_type text NOT NULL, -- 'leo', 'max', 'quiz'
  request_type text DEFAULT 'chat', -- 'chat', 'rag', 'memory', 'quiz'
  
  created_at timestamptz NOT NULL DEFAULT now()
);
  
  -- Индексы для быстрых запросов
CREATE INDEX idx_ai_message_user_time ON public.ai_message(user_id, created_at DESC);
CREATE INDEX idx_ai_message_bot_type ON public.ai_message(bot_type);
CREATE INDEX idx_ai_message_model ON public.ai_message(model_used);
CREATE INDEX idx_ai_message_chat ON public.ai_message(chat_id);

-- Включаем RLS
ALTER TABLE public.ai_message ENABLE ROW LEVEL SECURITY;

-- RLS политики
CREATE POLICY "Users can view own AI messages" ON public.ai_message
  FOR SELECT TO authenticated USING (user_id = auth.uid());

CREATE POLICY "Users can insert own AI messages" ON public.ai_message
  FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid());
```

### 1.2 Создание таблицы агрегированной статистики
```sql
-- Таблица для месячной статистики (только для внутреннего анализа)
CREATE TABLE IF NOT EXISTS public.internal_usage_stats (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  month_year text NOT NULL, -- формат: '2025-01'
  total_tokens integer NOT NULL DEFAULT 0,
  total_cost_usd numeric(10,6) NOT NULL DEFAULT 0,
  message_count integer NOT NULL DEFAULT 0,
  avg_tokens_per_message numeric(5,2),
  avg_cost_per_message numeric(10,6),
  bot_type text NOT NULL, -- 'leo', 'max', 'quiz'
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  
  UNIQUE(month_year, bot_type)
);

-- Индексы для быстрых запросов
CREATE INDEX idx_internal_usage_stats_month ON public.internal_usage_stats(month_year);
CREATE INDEX idx_internal_usage_stats_bot_type ON public.internal_usage_stats(bot_type);
```

### 1.3 Создание функции расчета стоимости
```sql
-- Функция для расчета стоимости запроса
CREATE OR REPLACE FUNCTION calculate_openai_cost(
  input_tokens integer,
  output_tokens integer,
  model_name text DEFAULT 'gpt-4.1-mini'
) RETURNS numeric(10,6) AS $$
DECLARE
  input_cost_per_1k numeric(10,6);
  output_cost_per_1k numeric(10,6);
BEGIN
  -- Определяем стоимость в зависимости от модели
  CASE model_name
    WHEN 'gpt-4.1-mini' THEN
      input_cost_per_1k := 0.0004;
      output_cost_per_1k := 0.0016;
    WHEN 'gpt-4.1' THEN
      input_cost_per_1k := 0.002;
      output_cost_per_1k := 0.008;
    WHEN 'gpt-5-mini' THEN
      input_cost_per_1k := 0.00025;
      output_cost_per_1k := 0.002;
    ELSE
      -- По умолчанию используем цены GPT-4.1-mini
      input_cost_per_1k := 0.0004;
      output_cost_per_1k := 0.0016;
  END CASE;
  
  -- Рассчитываем общую стоимость
  RETURN (
    (input_tokens::numeric * input_cost_per_1k / 1000) +
    (output_tokens::numeric * output_cost_per_1k / 1000)
  );
END;
$$ LANGUAGE plpgsql;
```

## Этап 2: Создание триггеров

### 2.1 Триггер для автоматического обновления статистики
```sql
-- Триггер для автоматического обновления общей статистики
CREATE OR REPLACE FUNCTION update_internal_usage_stats_trigger() RETURNS trigger AS $$
DECLARE
  month_year text;
BEGIN
  -- Определяем месяц-год
  month_year := to_char(NOW(), 'YYYY-MM');
  
  -- Обновляем или создаем запись общей статистики
  INSERT INTO public.internal_usage_stats (
    month_year, total_tokens, total_cost_usd, 
    message_count, avg_tokens_per_message, avg_cost_per_message, bot_type
  ) VALUES (
    month_year, NEW.total_tokens, NEW.cost_usd,
    1, NEW.total_tokens::numeric, NEW.cost_usd, NEW.bot_type
  )
  ON CONFLICT (month_year, bot_type) 
  DO UPDATE SET
    total_tokens = internal_usage_stats.total_tokens + NEW.total_tokens,
    total_cost_usd = internal_usage_stats.total_cost_usd + NEW.cost_usd,
    message_count = internal_usage_stats.message_count + 1,
    avg_tokens_per_message = (internal_usage_stats.total_tokens + NEW.total_tokens)::numeric / (internal_usage_stats.message_count + 1),
    avg_cost_per_message = (internal_usage_stats.total_cost_usd + NEW.cost_usd) / (internal_usage_stats.message_count + 1),
    updated_at = NOW();
    
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Создаем триггер
CREATE TRIGGER trg_update_internal_usage_stats
  AFTER INSERT ON public.ai_message
  FOR EACH ROW
  EXECUTE FUNCTION update_internal_usage_stats_trigger();
```

## Этап 3: Модификация Edge Function

### 3.1 Обновление leo-chat/index.ts
Добавить в Edge Function `leo-chat` функцию расчета стоимости:

```typescript
// Функция расчета стоимости
function calculateCost(usage: any, model: string = 'gpt-4.1-mini'): number {
  const inputTokens = usage.prompt_tokens || 0;
  const outputTokens = usage.completion_tokens || 0;
  
  let inputCostPer1K = 0.0004;  // GPT-4.1-mini по умолчанию
  let outputCostPer1K = 0.0016;
  
  if (model === 'gpt-4.1') {
    inputCostPer1K = 0.002;
    outputCostPer1K = 0.008;
  } else if (model === 'gpt-5-mini') {
    inputCostPer1K = 0.00025;
    outputCostPer1K = 0.002;
  }
  
  const totalCost = (
    (inputTokens * inputCostPer1K / 1000) +
    (outputTokens * outputCostPer1K / 1000)
  );
  
  return Math.round(totalCost * 1000000) / 1000000; // Округляем до 6 знаков
}
```

### 3.2 Модификация ответа API
В каждом месте, где возвращается ответ от OpenAI, добавить:

```typescript
const cost = calculateCost(usage, model);
return new Response(
  JSON.stringify({ 
    message: assistantMessage, 
    usage,
    cost_usd: cost,
    model_used: model
  }),
  { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } }
);
```

### 3.3 Обновление LeoService в Flutter
Модифицировать `lib/services/leo_service.dart` для сохранения данных о стоимости:

```dart
// В методе sendMessage добавить сохранение стоимости
final costUsd = response.data['cost_usd'] as double?;
final inputTokens = response.data['usage']['prompt_tokens'] as int?;
final outputTokens = response.data['usage']['completion_tokens'] as int?;
final modelUsed = response.data['model_used'] as String?;

// При сохранении в leo_messages передавать эти данные
// И дополнительно создавать запись в ai_message
```

### 3.4 Создание функции для сохранения AI данных
```dart
// Добавить в LeoService метод для сохранения AI данных
Future<void> saveAiMessageData({
  required String leoMessageId,
  required String chatId,
  required String userId,
  required int inputTokens,
  required int outputTokens,
  required double costUsd,
  required String modelUsed,
  required String botType,
  String requestType = 'chat',
}) async {
  await _client.from('ai_message').insert({
    'leo_message_id': leoMessageId,
    'chat_id': chatId,
    'user_id': userId,
    'input_tokens': inputTokens,
    'output_tokens': outputTokens,
    'total_tokens': inputTokens + outputTokens,
    'cost_usd': costUsd,
    'model_used': modelUsed,
    'bot_type': botType,
    'request_type': requestType,
  });
}
```

## Этап 4: Бэкфилл исторических данных

### 4.1 Создание функции для бэкфилла
```sql
-- Функция для бэкфилла исторических данных
CREATE OR REPLACE FUNCTION backfill_ai_message_stats() RETURNS void AS $$
DECLARE
  rec record;
  month_year text;
  bot_type text;
  cost_usd numeric(10,6);
  total_tokens integer;
BEGIN
  -- Проходим по всем существующим сообщениям ассистента
  FOR rec IN 
    SELECT 
      lm.id,
      lm.token_count,
      lm.chat_id,
      lm.user_id,
      to_char(lm.created_at, 'YYYY-MM') as month_year
    FROM public.leo_messages lm
    WHERE lm.role = 'assistant' 
      AND lm.token_count IS NOT NULL
      AND NOT EXISTS (
        SELECT 1 FROM public.ai_message am WHERE am.leo_message_id = lm.id
      )
  LOOP
    -- Определяем тип бота
    SELECT bot INTO bot_type 
    FROM public.leo_chats 
    WHERE id = rec.chat_id;
    
    IF bot_type IS NULL THEN
      bot_type := 'leo';
    END IF;
    
    -- Приблизительно разделяем токены (70% input, 30% output)
    total_tokens := rec.token_count;
    
    -- Рассчитываем стоимость
    cost_usd := calculate_openai_cost(
      ROUND(total_tokens * 0.7), -- input tokens
      ROUND(total_tokens * 0.3), -- output tokens
      'gpt-4.1-mini'
    );
    
    -- Создаем запись в ai_message
    INSERT INTO public.ai_message (
      leo_message_id, user_id, chat_id,
      input_tokens, output_tokens, total_tokens,
      cost_usd, model_used, bot_type, request_type
    ) VALUES (
      rec.id, rec.user_id, rec.chat_id,
      ROUND(total_tokens * 0.7), ROUND(total_tokens * 0.3), total_tokens,
      cost_usd, 'gpt-4.1-mini', bot_type, 'chat'
    );
  END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Запуск бэкфилла
SELECT backfill_ai_message_stats();
```

## Этап 5: Создание аналитических запросов

### 5.1 Основные запросы для анализа

```sql
-- Общая статистика за последние 6 месяцев
SELECT 
  month_year,
  bot_type,
  total_tokens,
  total_cost_usd,
  message_count,
  avg_tokens_per_message,
  avg_cost_per_message,
  ROUND(total_cost_usd / message_count, 6) as cost_per_message
FROM public.internal_usage_stats 
WHERE month_year >= to_char(NOW() - interval '6 months', 'YYYY-MM')
ORDER BY month_year DESC, bot_type;

-- Средняя стоимость запроса по типам ботов
SELECT 
  bot_type,
  AVG(avg_cost_per_message) as avg_cost_per_message,
  AVG(avg_tokens_per_message) as avg_tokens_per_message,
  SUM(total_cost_usd) as total_cost,
  SUM(message_count) as total_messages
FROM public.internal_usage_stats 
WHERE month_year >= to_char(NOW() - interval '3 months', 'YYYY-MM')
GROUP BY bot_type;

-- Месячные расходы
SELECT 
  month_year,
  SUM(total_cost_usd) as monthly_cost,
  SUM(message_count) as monthly_messages,
  ROUND(SUM(total_cost_usd) / SUM(message_count), 6) as avg_cost_per_message
FROM public.internal_usage_stats 
GROUP BY month_year
ORDER BY month_year DESC;

-- Детальная статистика по моделям
SELECT 
  model_used,
  bot_type,
  COUNT(*) as message_count,
  SUM(total_tokens) as total_tokens,
  SUM(cost_usd) as total_cost,
  AVG(cost_usd) as avg_cost_per_message,
  AVG(total_tokens) as avg_tokens_per_message
FROM public.ai_message 
WHERE created_at >= NOW() - interval '3 months'
GROUP BY model_used, bot_type
ORDER BY total_cost DESC;

-- Прогноз расходов на следующий месяц
SELECT 
  ROUND(AVG(monthly_cost), 2) as avg_monthly_cost,
  ROUND(AVG(monthly_messages), 0) as avg_monthly_messages,
  ROUND(AVG(avg_cost_per_message), 6) as avg_cost_per_message
FROM (
  SELECT 
    month_year,
    SUM(total_cost_usd) as monthly_cost,
    SUM(message_count) as monthly_messages,
    ROUND(SUM(total_cost_usd) / SUM(message_count), 6) as avg_cost_per_message
  FROM public.internal_usage_stats 
  WHERE month_year >= to_char(NOW() - interval '3 months', 'YYYY-MM')
  GROUP BY month_year
) monthly_stats;
```

## Этапы реализации

- Этап 1: Подготовка базы данных
- Этап 2: Создание триггеров
- Этап 3: Модификация Edge Function
- Этап 4: Бэкфилл исторических данных
- Тестирование системы
- Проверка корректности расчетов
- Этап 5: Создание аналитических запросов
- Документирование системы
- Создание дашборда для мониторинга
В течение месяца или недели
- Сбор данных о реальном использовании
- Анализ трендов и паттернов
- Оптимизация на основе полученных данных
- Формирование рекомендаций по ценовой политике

## Ожидаемые результаты

### Через 1 неделю
- Полная система учета стоимости работает
- Исторические данные обработаны
- Базовые метрики доступны

### Через 1 месяц
- Достаточно данных для анализа трендов
- Понимание средней стоимости запроса по типам ботов
- Основа для планирования бюджета и ценообразования

## Мониторинг и поддержка

### Еженедельные проверки
- Корректность работы триггеров
- Точность расчетов стоимости
- Производительность запросов

### Ежемесячный анализ
- Общие расходы на AI
- Сравнение с прогнозами
- Корректировка ценовой политики
