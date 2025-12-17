# Slot Filling Architecture — Архитектура Валли

**Дата создания:** 17.12.2024  
**Статус:** Реализовано  
**Версия:** 2.0 (переход от FSM к Slot Filling)

---

## Обзор

Валли версии 2.0 использует **Slot Filling архитектуру** вместо жёсткого пошагового конечного автомата (FSM). Это решает проблему блокировки пользователей из-за стохастической природы LLM и делает диалог более гибким и естественным.

## Проблема v1.0 (FSM)

### Bottleneck инкрементального перехода

```typescript
// СТАРАЯ ЛОГИКА (v1.0)
if (validationResult.is_sufficient === true) {
  const newStep = currentStep + 1; // Жёсткий инкремент
  // Переход только если LLM вернула is_sufficient: true
}
```

**Риски:**
- Пользователь застревает на шаге из-за случайной ошибки LLM
- Невозможно "перепрыгнуть" шаги, если пользователь дал информацию сразу по нескольким темам
- Нет защиты от бесконечных уточнений
- Контекст для Макса — "простыня" из 50 сообщений без структуры

## Решение v2.0 (Slot Filling)

### Принципы

1. **Накопительная валидация** — анализ всей истории диалога, а не только текущего ответа
2. **Flexible transitions** — переход к следующему шагу на основе заполненности слотов, а не жёсткого инкремента
3. **Soft validation** — принудительное продвижение после 2+ попыток уточнения
4. **Структурированный контекст** — внутреннее структурированное представление слотов (для отчёта Валли и будущих интеграций)

### Структура слотов

```typescript
interface SlotData {
  content: string;           // Краткая выжимка (2-4 предложения)
  status: SlotStatus;        // 'empty' | 'partial' | 'filled' | 'skipped_by_retry'
  confidence: number;        // 0.0 - 1.0
  feedback: string;          // Уточняющий вопрос (если нужен)
  updated_at: string;        // ISO timestamp
}

interface SlotsState {
  slots: {
    product: SlotData;       // Суть идеи
    problem: SlotData;       // Проблема
    audience: SlotData;      // Целевая аудитория
    validation: SlotData;    // Валидация гипотезы
    competitors: SlotData;   // Конкуренты
    utp: SlotData;          // Уникальное преимущество
    risks: SlotData;        // Риски
  };
  metadata: {
    last_updated: string;
    forced_slots: string[]; // Слоты, пропущенные через soft validation
  };
}
```

### Хранение в БД

**Таблица:** `idea_validations`

```sql
-- Новые поля
slots_state JSONB DEFAULT '{}'::jsonb  -- Гибкое состояние слотов
retry_count INT DEFAULT 0              -- Счётчик попыток для soft validation
```

**Индексы:**
```sql
CREATE INDEX idx_validations_slots_state 
ON idea_validations USING gin(slots_state);
```

---

## Логика работы

### 1. Slot Filling Validator (LLM Prompt)

**Файл:** `index.ts`, константа `SLOT_FILLING_VALIDATOR_PROMPT`

**Задачи промпта:**
1. Анализ ответа пользователя в контексте всей истории
2. Обновление состояния затронутых слотов
3. Оценка confidence (0.0–1.0) для каждого слота
4. Определение следующего приоритетного шага

**Формат ответа:**
```json
{
  "updated_slots": {
    "product": {
      "content": "Краткая выжимка",
      "status": "filled",
      "confidence": 0.85,
      "feedback": ""
    },
    "problem": {
      "content": "Частично заполнено",
      "status": "partial",
      "confidence": 0.5,
      "feedback": "Чуть не хватает деталей про частоту проблемы"
    }
  },
  "suggested_step_index": 3,
  "bot_response_text": "Отлично! Теперь давай уточним..."
}
```

### 2. Логика validateUserResponseSlotFilling

**Файл:** `index.ts`, строки 808–1056

**Шаги:**

```typescript
async function validateUserResponseSlotFilling(
  openai, messages, validationId, userId, chatId, supabaseAdmin
) {
  // 1. Загружаем текущее состояние из БД
  const { slots_state, current_step, retry_count } = await loadValidation();
  
  // 2. Технический фильтр качества (слишком короткий ответ)
  if (isTooShort(userMessage)) {
    return { response: "...", newStep: current_step, retryCount: retry_count + 1 };
  }
  
  // 3. Вызываем LLM Slot Filling валидатор
  const slotFillingResult = await callGrokValidator({
    history: conversationHistory,
    currentSlots: slots_state,
    lastMessage: userMessage
  });
  
  // 4. Мержим слоты (приоритет свежести + confidence)
  const mergedSlots = mergeSlots(slots_state, slotFillingResult.updated_slots);
  
  // 5. SOFT VALIDATION: если застряли 2+ раза на одном шаге
  if (retry_count >= 2 && slotFillingResult.suggested_step_index === current_step) {
    const currentSlotKey = getSlotKeyByStep(current_step);
    mergedSlots.slots[currentSlotKey].status = 'skipped_by_retry';
    mergedSlots.metadata.forced_slots.push(currentSlotKey);
    slotFillingResult.suggested_step_index = current_step + 1; // Форсируем переход
  }
  
  // 6. Вычисляем новый шаг (Math.max — не откатываемся назад)
  const nextStep = Math.max(current_step, slotFillingResult.suggested_step_index);
  
  // 7. Сбрасываем retry_count если шаг изменился
  const newRetryCount = nextStep > current_step ? 0 : retry_count + 1;
  
  // 8. Сохраняем обновлённое состояние в БД
  await supabaseAdmin
    .from('idea_validations')
    .update({
      slots_state: mergedSlots,
      current_step: nextStep,
      retry_count: newRetryCount
    })
    .eq('id', validationId);
  
  // 9. Возвращаем ответ Валли
  return {
    response: slotFillingResult.bot_response_text,
    newStep: nextStep,
    slotsState: mergedSlots,
    retryCount: newRetryCount
  };
}
```

### 3. Слияние слотов (mergeSlots)

**Файл:** `index.ts`, строки 447–501

**Правила приоритета:**

```typescript
function mergeSlots(currentSlots, updatedSlots) {
  for (const [slotKey, updatedData] of Object.entries(updatedSlots)) {
    const currentData = currentSlots[slotKey];
    
    // Перезаписываем если:
    const shouldOverwrite = 
      currentData.status === 'empty' ||                          // 1. Слот был пустой
      (updatedData.status === 'filled' && updatedData.confidence > 0.7) || // 2. Новый filled с высоким confidence
      updatedData.confidence > currentData.confidence;            // 3. Новый confidence выше
    
    if (shouldOverwrite) {
      currentSlots[slotKey] = {
        content: updatedData.content,
        status: updatedData.status,
        confidence: updatedData.confidence,
        feedback: updatedData.feedback,
        updated_at: now()
      };
    } else {
      // Обновляем только feedback если статус не меняется
      if (updatedData.feedback) {
        currentSlots[slotKey].feedback = updatedData.feedback;
      }
    }
  }
  
  return currentSlots;
}
```

**Защита от "галлюцинаций":**
- Если пользователь изменил ответ ("студенты" → "пенсионеры"), новый контент с высоким confidence перезапишет старый
- Если LLM вернула partial для уже filled слота — оставляем filled, но обновляем feedback

### 4. Soft Validation (защита от блокировки)

**Когда срабатывает:** `retry_count >= 2` и `suggested_step_index === current_step`

**Действия:**
1. Помечаем текущий слот как `status: 'skipped_by_retry'`
2. Добавляем слот в `metadata.forced_slots[]`
3. Искусственно увеличиваем `suggested_step_index` на +1
4. Логируем событие: `INFO soft_validation_triggered`

**Важно:** `retry_count` инкрементируется даже при срабатывании технического фильтра (короткие/мусорные ответы типа "ыыы", "нет", "хз"), чтобы пользователь не мог застрять на одном вопросе навсегда.

**Результат:**
- Пользователь продвигается дальше
- Слабый слот помечен для будущей проработки
- В итоговом отчёте будет отмечено, что слот проработан недостаточно

### 5. Завершение валидации

**Когда:** `suggested_step_index >= 8` (все 7 слотов пройдены)

**Поведение бота:**
- Вместо генерации нового вопроса возвращает финальное сообщение: "Отлично! Я записал все твои ответы. Готов проанализировать идею и показать результат?"
- Backend устанавливает флаг `is_complete: true` в метаданных ответа
- Frontend получает этот флаг и автоматически показывает диалог подтверждения для запуска скоринга
- Анимация пульсации слотов останавливается (`_isAnalyzing = true`)

---

## Структурированный контекст слотов

После завершения валидации (все слоты filled или `current_step > 7`) Slot Filling даёт:

- заполненную структуру `SlotsState` для отчёта и аналитики;
- список слабых мест (partial / `skipped_by_retry`), который используется в тексте отчёта и может быть подключён к другим ассистентам в будущих версиях.

## Защита от ошибок LLM

### 1. Битый JSON

```typescript
function cleanJsonString(raw: string): string {
  let cleaned = raw.trim();
  
  // Удаляем markdown обёртки
  if (cleaned.startsWith('```json')) {
    cleaned = cleaned.replace(/^```json\s*/i, '').replace(/```\s*$/, '');
  } else if (cleaned.startsWith('```')) {
    cleaned = cleaned.replace(/^```\s*/, '').replace(/```\s*$/, '');
  }
  
  return cleaned.trim();
}
```

### 2. Валидация структуры

```typescript
function safeParseSlotFillingResponse(raw: string): any | null {
  try {
    const cleaned = cleanJsonString(raw);
    const parsed = JSON.parse(cleaned);
    
    // Проверяем обязательные поля
    if (!parsed.updated_slots || !parsed.suggested_step_index || !parsed.bot_response_text) {
      console.error('ERR missing_required_fields');
      return null;
    }
    
    return parsed;
  } catch (parseError) {
    console.error('ERR parse_slot_response', { error: parseError, raw: raw.slice(0, 200) });
    return null;
  }
}
```

### 3. Fallback при ошибке

```typescript
if (!slotFillingResult) {
  // Используем стандартный вопрос текущего шага
  const step = VALIDATION_STEPS.find(s => s.id === currentStep);
  return {
    response: `Хм, не совсем понял твой ответ. Попробуй ответить более развёрнуто.\n\n${step?.exampleTemplate}\n\n${step?.question}`,
    newStep: currentStep,
    slotsState: currentSlotsState,
    retryCount: retryCount + 1
  };
}
```

---

## Отличия v1.0 vs v2.0

| Аспект | v1.0 (FSM) | v2.0 (Slot Filling) |
|--------|-----------|---------------------|
| **Переход между шагами** | Жёсткий инкремент (+1) | `Math.max(current, suggested)` |
| **Анализ ответа** | Только последнее сообщение | Вся история диалога |
| **Блокировка** | Бесконечная при `is_sufficient: false` | Soft validation после 2 попыток |
| **Пропуск шагов** | Невозможен | Возможен если пользователь дал инфо сразу |
| **Контекст для Макса** | Сырая история (50 сообщений) | Структурированные слоты + weak spots |
| **Хранение состояния** | Только `current_step` | `slots_state JSONB` + `retry_count` |
| **Защита от ошибок LLM** | Fallback на стандартный ответ | Парсинг + валидация + fallback |

---

## Метрики успеха

### Ключевые показатели

**Вовлечение:**
- Completion Rate: % начавших → завершивших (Target: >70%, было 60%)
- Retry Rate: среднее количество попыток на шаг (Target: <1.5)
- Soft Validation Trigger Rate: % валидаций с forced_slots (Monitor: <20%)

**Качество:**
- Average Confidence: средний confidence по заполненным слотам (Target: >0.75)
- Forced Slots Rate: % слотов со статусом `skipped_by_retry` (Target: <10%)

**Интеграция с другими ассистентами (будущее):**
- Доля завершивших валидацию и перешедших к другим AI‑ассистентам с отчёта Валли (Monitor)

---

## Логирование и отладка

### Ключевые события

```typescript
// Загрузка состояния
console.log('INFO slots_state_loaded', { validationId, currentStep, retryCount });

// Soft validation
console.log('INFO soft_validation_triggered', { validationId, currentStep, slotKey, retryCount });

// Обновление состояния
console.log('INFO slots_state_updated', { validationId, oldStep, newStep, retryCount });

// Ошибки парсинга
console.error('ERR slot_filling_parse_failed', { validationId, currentStep });
console.error('ERR missing_required_fields', { hasSlots, hasStep, hasResponse });
```

### Sentry breadcrumbs

```typescript
// Frontend (ValiService)
Sentry.addBreadcrumb({
  category: 'vali',
  message: 'slot_filling_request',
  data: { validationId, currentStep, retryCount }
});

// Backend (index.ts)
// Автоматически через console.log/error
```

---

## Миграция с v1.0 на v2.0

### Обратная совместимость

**Существующие валидации (v1.0):**
- `slots_state` будет `{}` (пустой объект)
- `retry_count` будет `0`
- При первом сообщении слоты инициализируются дефолтными значениями
- `current_step` продолжит работать как есть

**Новые валидации (v2.0):**
- Сразу используют Slot Filling
- `current_step` обновляется на основе `suggested_step_index`
- `slots_state` заполняется постепенно

### Деплой

1. ✅ Применить миграцию БД (`20251217_add_slot_filling_to_validations.sql`)
2. ✅ Деплой Edge Function с новым кодом
3. ⏳ Мониторинг метрик в первые 48 часов
4. ⏳ A/B тестирование (опционально): 50% v1.0 / 50% v2.0

---

## Следующие шаги

### Краткосрочные (1-2 недели)
1. ⏳ Мониторинг метрик Slot Filling
2. ⏳ Калибровка confidence thresholds (может потребоваться >0.7 → >0.75)

### Среднесрочные (1 месяц)
1. ⏳ UI индикация заполненности слотов (progress bar по слотам)
2. ⏳ Возможность "вернуться" к forced_slots через UI
3. ⏳ Аналитика: какие слоты чаще попадают в forced_slots

### Долгосрочные (квартал)
1. ⏳ ML-модель для калибровки confidence (на основе исторических данных)
2. ⏳ Персонализация порядка слотов (для разных типов идей)
3. ⏳ Интеграция с другими ботами (Лео, будущие AI-ассистенты)

---

## Ссылки на код

- **Edge Function:** `supabase/functions/val-chat/index.ts`
- **Slot Filling Validator:** строки 808–1056
- **Slot Prompt:** строки 98–150
- **Merge Slots:** строки 447–501
- **Safe Parse:** строки 413–442
- **Миграция БД:** `supabase/migrations/20251217_add_slot_filling_to_validations.sql`

---

**Версия документа:** 1.0  
**Дата последнего обновления:** 17.12.2024  
**Автор:** BizLevel Development Team
