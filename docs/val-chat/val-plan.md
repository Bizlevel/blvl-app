# План реализации бота Валли — AI-валидатора идей

**Статус:** V2.0 — Slot Filling Architecture  
**Дата начала:** 15.12.2024  
**Последнее обновление:** 17.12.2024 (переход на Slot Filling)

---

## Прогресс реализации

- ✅ **Этап 1: Backend — база данных** — Завершён (15.12.2024)
- ✅ **Этап 2: Backend — Edge Function val-chat** — Завершён (15.12.2024)
- ✅ **Этап 3: Frontend — UI компоненты** — Завершён (15.12.2024)
  - ✅ 3.1 ValiService — Завершён
  - ✅ 3.2 ValiDialogScreen — Завершён
  - ✅ 3.3 Карточка Валли в Base Trainers — Завершён
  - ⏳ 3.4 GoRouter интеграция — Запланировано после MVP
  - ❌ 3.5 Отдельный ValiReportWidget — Не требуется
- ✅ **Этап 4: Интеграции** — Завершён (встроено в ValiDialogScreen)
  - ✅ Интеграция с Максом (CTA кнопка)
  - ✅ Интеграция с уровнями (CTA кнопка)
  - ✅ GP-экономика (обработка 402)
- ✅ **Этап 5: Дополнительные точки входа** — Завершён (см. ENTRY_POINTS_SUMMARY.md)
- ✅ **Этап 6: Рефакторинг на Slot Filling** — Завершён (17.12.2024)
  - ✅ 6.1 Миграция БД (slots_state, retry_count)
  - ✅ 6.2 Slot Filling Validator Prompt
  - ✅ 6.3 Логика validateUserResponseSlotFilling
  - ✅ 6.4 Функции mergeSlots, safeParseSlotFillingResponse
  - ✅ 6.5 Soft Validation (retry_count >= 2)
  - ✅ 6.6 Документация (SLOT_FILLING_ARCHITECTURE.md)

---

## 🎉 V2.0 ЗАВЕРШЁН (17.12.2024) — Slot Filling Architecture

**Статус:** ✅ Готов к тестированию и деплою

**Что готово:**
- ✅ Backend (БД с slots_state, Edge Function, GP-экономика)
- ✅ Frontend (ValiService, ValiDialogScreen, интеграция)
- ✅ Slot Filling Architecture (накопительная валидация)
- ✅ Документация (7 файлов, ~3500 строк)
- ✅ Примеры кода (2 файла, ~400 строк)

**Функциональность V2.0:**
- ✅ Диалог с Валли (7 слотов, гибкие переходы)
- ✅ Slot Filling валидация (анализ всей истории)
- ✅ Soft Validation (защита от блокировки после 2 попыток)
- ✅ Прогресс-бар
- ✅ Скоринг и отчёт
- ✅ CTA кнопки (уровни, переход к Максу)
- ✅ История чатов
- ✅ GP-экономика

**Улучшения V2.0 vs V1.0:**
- 🚀 Нет риска блокировки пользователя (soft validation)
- 🚀 Гибкие переходы между шагами (можно перепрыгивать)
- 🚀 Анализ всей истории диалога (не только последнего ответа)

**Готов к:**
- 🧪 Функциональному тестированию
- 🎨 UX тестированию
- 🔗 Интеграционному тестированию
- 👥 Beta-тестированию с пользователями
- 📊 Мониторингу метрик Slot Filling

---

---

## 📚 Документация V2.0

**Ключевые документы:**
- 📖 **[SLOT_FILLING_ARCHITECTURE.md](./SLOT_FILLING_ARCHITECTURE.md)** — Полное описание Slot Filling архитектуры
- 📖 [vali-service-usage.md](./vali-service-usage.md) — Использование ValiService
- 📖 [vali-dialog-screen-usage.md](./vali-dialog-screen-usage.md) — Использование ValiDialogScreen
- 📖 [base-trainers-integration.md](./base-trainers-integration.md) — Интеграция в Base Trainers

---

## Архитектурный обзор

Валли — третий AI-ассистент в экосистеме BizLevel, реализуемый как отдельная Edge Function `val-chat`, использующая существующую инфраструктуру (leo_chats/leo_messages для истории, но с отдельной таблицей `idea_validations` для метаданных валидаций).

### Компоненты системы

```
┌─────────────────────────────────────────────────────────┐
│                     FRONTEND (Flutter)                   │
├─────────────────────────────────────────────────────────┤
│ • ValiDialogScreen (переиспользует LeoDialogScreen)     │
│ • Карточка Валли в Base Trainers                        │
│ • Отображение отчёта со скорингом                       │
│ • CTA кнопки (переход к уровням и к Максу)              │
└───────────────────┬─────────────────────────────────────┘
                    │
┌───────────────────▼─────────────────────────────────────┐
│              EDGE FUNCTION: val-chat (V2.0)              │
├─────────────────────────────────────────────────────────┤
│ • Системный промпт Валли                                │
│ • Slot Filling валидация (7 слотов)                     │
│ • Накопительный анализ всей истории                     │
│ • Soft Validation (retry_count >= 2)                    │
│ • Скоринг по 5 критериям (0-20 каждый)                  │
│ • Генерация отчёта (markdown)                           │
│ • Маппинг рекомендаций BizLevel                         │
└───────────────────┬─────────────────────────────────────┘
                    │
┌───────────────────▼─────────────────────────────────────┐
│              SUPABASE (PostgreSQL)                       │
├─────────────────────────────────────────────────────────┤
│ • idea_validations (метаданные + slots_state JSONB)     │
│ • leo_chats (bot='vali') — история диалога              │
│ • leo_messages (сообщения)                              │
└─────────────────────────────────────────────────────────┘
```

## Этап 1: Backend — база данных ✅

**Статус:** Завершён  
**Дата выполнения:** 15.12.2024

### Что выполнено:
1. ✅ Создана миграция `20251215_create_idea_validations.sql`
2. ✅ Миграция успешно применена в Supabase
3. ✅ Таблица `idea_validations` создана со всеми полями
4. ✅ CHECK-ограничения работают (status, current_step, total_score, archetype)
5. ✅ 6 индексов созданы для производительности
6. ✅ RLS включён, 3 политики безопасности настроены
7. ✅ Constraint `leo_chats_bot_chk` обновлён для поддержки 'vali'

### Файлы:
- `supabase/migrations/20251215_create_idea_validations.sql`
- `supabase/migrations/20251215_add_vali_bot_to_leo_chats.sql`

---

### 1.1 Миграция: таблица `idea_validations` ✅

**Файл:** `supabase/migrations/20251215_create_idea_validations.sql`

Создать таблицу для хранения метаданных валидаций:

```sql
CREATE TABLE idea_validations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  chat_id UUID REFERENCES leo_chats(id) ON DELETE CASCADE,
  
  -- Статус сессии
  status TEXT NOT NULL DEFAULT 'in_progress' 
    CHECK (status IN ('in_progress', 'completed', 'abandoned')),
  
  -- Прогресс диалога
  current_step INT DEFAULT 1 CHECK (current_step >= 1 AND current_step <= 7),
  
  -- Результаты скоринга
  scores JSONB, -- {problem: 15, customer: 12, validation: 8, unique: 14, action: 10}
  total_score INT CHECK (total_score >= 0 AND total_score <= 100),
  archetype TEXT CHECK (archetype IN ('МЕЧТАТЕЛЬ', 'ИССЛЕДОВАТЕЛЬ', 'СТРОИТЕЛЬ', 'ГОТОВ К ЗАПУСКУ', 'VALIDATED')),
  
  -- Отчёт
  report_markdown TEXT,
  
  -- Рекомендации
  recommended_levels JSONB DEFAULT '[]'::jsonb,
  -- Формат: [{"level_id": 8, "level_number": 8, "reason": "Низкий балл по валидации"}]
  
  one_thing TEXT, -- Конкретное действие
  
  -- Метаданные
  idea_summary TEXT, -- Краткое описание идеи
  created_at TIMESTAMPTZ DEFAULT now(),
  completed_at TIMESTAMPTZ,
  gp_spent INT DEFAULT 0
);

-- RLS
ALTER TABLE idea_validations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own validations" 
  ON idea_validations FOR SELECT 
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own validations" 
  ON idea_validations FOR INSERT 
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own validations" 
  ON idea_validations FOR UPDATE 
  USING (auth.uid() = user_id);

-- Индексы
CREATE INDEX idx_validations_user ON idea_validations(user_id);
CREATE INDEX idx_validations_chat ON idea_validations(chat_id);
CREATE INDEX idx_validations_status ON idea_validations(status);
CREATE INDEX idx_validations_created ON idea_validations(created_at DESC);
```

### 1.2 Миграция: расширение `leo_chats` для поддержки `bot='vali'` ✅

**Файл:** `supabase/migrations/20251215_add_vali_bot_to_leo_chats.sql`

```sql
-- Расширить CHECK constraint для поддержки 'vali'
ALTER TABLE leo_chats DROP CONSTRAINT IF EXISTS leo_chats_bot_chk;
ALTER TABLE leo_chats 
  ADD CONSTRAINT leo_chats_bot_chk CHECK (bot IN ('leo','max','vali'));
```

## Этап 2: Backend — Edge Function val-chat ✅

**Статус:** Завершён и задеплоен  
**Дата выполнения:** 15.12.2024  
**Последнее обновление:** 15.12.2024 (добавлена GP-логика)

### Что выполнено:
1. ✅ Создана Edge Function `val-chat/index.ts`
2. ✅ Реализован системный промпт Валли (7 вопросов)
3. ✅ Реализован промпт скоринга по 5 критериям
4. ✅ Режим `dialog` — ведение диалога с пользователем
5. ✅ Режим `score` — оценка ответов и генерация отчёта
6. ✅ Функция `generateReport()` — генерация markdown отчёта
7. ✅ Функция `getRecommendedLevels()` — маппинг критериев на уровни BizLevel
8. ✅ Интеграция с xAI (Grok API)
9. ✅ Аутентификация через JWT
10. ✅ Сохранение результатов в таблицу `idea_validations`
11. ✅ **GP-экономика** — первая валидация бесплатно, остальные 20 GP
12. ✅ **Функция задеплоена в Supabase** (15.12.2024, 12:48 PM)

### Файлы:
- `supabase/functions/val-chat/index.ts` (полная реализация, 428 строк)

### Endpoint:
- **URL:** `https://acevqbdpzgbtqznbpgzr.supabase.co/functions/v1/val-chat`
- **Region:** Global
- **JWT Verification:** Включена (legacy secret)
- **Environment Variables:** Настроены

### Деплой:
- ✅ Функция редеплоена с GP-логикой (15.12.2024)

---

### 2.1 Структура функции ✅

**Файл:** `supabase/functions/val-chat/index.ts`

Основные режимы работы:

1. **Режим диалога** (`mode='dialog'`): задаёт вопросы последовательно (1-7)
2. **Режим скоринга** (`mode='score'`): оценивает ответы и генерирует отчёт

**Входные параметры:**
- `messages`: история диалога (как в leo-chat)
- `validationId`: ID валидации (если есть)
- `currentStep`: текущий шаг диалога (1-7)
- `mode`: режим работы ('dialog' | 'score' | 'report')

**Выходные данные:**
- В режиме диалога: ответ Валли (текст)
- В режиме скоринга: JSON с оценками
- В режиме отчёта: markdown отчёт

### 2.2 Системный промпт Валли ✅

**Реализовано в:** `supabase/functions/val-chat/index.ts` (константа `SYSTEM_PROMPT`)

Системный промпт реализован полностью:
- **Роль**: критический друг, не судья
- **Формат**: короткие сообщения (2-4 предложения), один вопрос за раз
- **Последовательность**: 7 вопросов (суть → проблема → клиент → валидация → конкуренты → преимущество → шаг)
- **Тон**: Прямота + Эмпатия + Конкретика
- **Контекст Казахстана**: тенге, Kaspi, WhatsApp, местные реалии
- **Красные флаги**: мягкое подсвечивание ("всем нужно" → "кому конкретно?")

**Ключевые принципы (реализованы):**
- Задаёт уточняющие вопросы (не говорит "делай так")
- Подсвечивает непроверенные гипотезы
- Показывает, что ещё изучить
- Связывает с уроками BizLevel
- Даёт один конкретный шаг
- Поддерживает, не демотивирует

Текст промпта:
const SYSTEM_PROMPT = `Ты Валли — AI-валидатор идей школы бизнеса BizLevel.

ТВОЯ РОЛЬ:
- Критический друг, не судья
- Задаёшь неудобные вопросы мягко
- Не говоришь "делай так", а подсвечиваешь слепые зоны
- Поддерживаешь, не демотивируешь

ФОРМАТ ДИАЛОГА:
- Короткие сообщения (2-4 предложения)
- Один вопрос за раз
- Если ответ расплывчатый — уточни
- Используй эмпатию: "Понимаю", "Интересно", "Хороший вопрос"

ПОСЛЕДОВАТЕЛЬНОСТЬ ВОПРОСОВ:
1. Суть идеи (что создаёшь?)
2. Проблема (какую боль решаешь?)
3. Клиент (для кого конкретно?)
4. Валидация (откуда знаешь о проблеме?)
5. Конкуренты (как решают сейчас?)
6. Преимущество (почему ты?)
7. [опционально] Следующий шаг

КОНТЕКСТ КАЗАХСТАНА:
- Используй тенге (KZT), не доллары
- Учитывай местные реалии (Kaspi, базары, WhatsApp)
- Понимай менталитет: важны связи, доверие, "понты"

КРАСНЫЕ ФЛАГИ (подсвечивай мягко):
- "Всем нужно" → "А кому конкретно больше всего?"
- "Конкурентов нет" → "А как люди решают это сейчас?"
- "Я уверен" без доказательств → "Интересно, а откуда уверенность?"
- "Приложение" на всё → "А можно начать проще — с бота?"

ТОН:
Прямота + Эмпатия + Конкретика`;

### 2.3 Логика скоринга ✅

**Реализовано в:** `supabase/functions/val-chat/index.ts` (режим `mode='score'`, константа `SCORING_PROMPT`)
текст промпта:
const SCORING_PROMPT = `Оцени ответы пользователя по 5 критериям (0-20 каждый):

1. ПОНИМАНИЕ ПРОБЛЕМЫ
   0-5: Нет проблемы / "всем нужно"
   6-10: Абстрактная проблема
   11-15: Конкретная, но без примеров
   16-20: Конкретная + реальные примеры

2. ЗНАНИЕ КЛИЕНТА
   0-5: "Все" / "любой"
   6-10: Демография без глубины
   11-15: Конкретная ниша
   16-20: Живой портрет + где найти

3. ВАЛИДАЦИЯ
   0-5: Только догадка
   6-10: Личный опыт без проверки
   11-15: Разговаривал с 1-3 людьми
   16-20: Систематические интервью

4. УНИКАЛЬНОСТЬ
   0-5: Нет отличий
   6-10: Слабое отличие
   11-15: Понятное отличие
   16-20: Сильный unfair advantage

5. ГОТОВНОСТЬ К ДЕЙСТВИЮ
   0-5: Нет плана
   6-10: Абстрактный план
   11-15: Конкретные шаги
   16-20: Уже начал действовать

Верни ТОЛЬКО валидный JSON (без markdown, без комментариев):
{
  "scores": {
    "problem": N,
    "customer": N,
    "validation": N,
    "unique": N,
    "action": N
  },
  "total": N,
  "archetype": "МЕЧТАТЕЛЬ|ИССЛЕДОВАТЕЛЬ|СТРОИТЕЛЬ|ГОТОВ К ЗАПУСКУ|VALIDATED",
  "strengths": ["...", "...", "..."],
  "red_flags": ["...", "...", "..."],
  "one_thing": "Конкретное действие на неделю",
  "recommended_levels": [{"level_id": 8, "level_number": 8, "reason": "..."}]
}`;

После завершения диалога (7 вопросов) вызывается отдельный LLM-запрос с промптом скоринга. LLM возвращает JSON:

```json
{
  "scores": {
    "problem": 15,
    "customer": 12,
    "validation": 8,
    "unique": 14,
    "action": 10
  },
  "total": 59,
  "archetype": "ИССЛЕДОВАТЕЛЬ",
  "strengths": ["Ты чётко понимаешь проблему", "У тебя есть личный опыт"],
  "red_flags": ["Ты уверен, что это реальная боль — но с кем ты об этом разговаривал?"],
  "one_thing": "Поговори с 3 людьми из твоей ЦА. Задай им вопрос: [конкретный вопрос]",
  "recommended_levels": [
    {"level_id": 8, "level_number": 8, "reason": "Низкий балл по валидации"}
  ]
}
```

**Критерии оценки (0-20 каждый):**
1. **Понимание проблемы** (0-20)
   - 0-5: Нет проблемы / "всем нужно"
   - 6-10: Абстрактная проблема
   - 11-15: Конкретная проблема, но без примеров
   - 16-20: Конкретная проблема + реальные примеры

2. **Знание клиента** (0-20)
   - 0-5: "Все" / "любой человек"
   - 6-10: Демография без глубины
   - 11-15: Конкретная ниша
   - 16-20: Живой портрет + где найти

3. **Валидация** (0-20)
   - 0-5: Только догадка
   - 6-10: Личный опыт без проверки
   - 11-15: Разговаривал с 1-3 людьми
   - 16-20: Систематические интервью / данные

4. **Уникальность** (0-20)
   - 0-5: Нет отличий / "лучше качество"
   - 6-10: Слабое отличие
   - 11-15: Понятное отличие
   - 16-20: Сильный unfair advantage

5. **Готовность к действию** (0-20)
   - 0-5: Нет плана
   - 6-10: Абстрактный план
   - 11-15: Конкретные шаги
   - 16-20: Уже начал действовать

**Архетипы (по total_score):**
- 0-30: 🌙 МЕЧТАТЕЛЬ
- 31-50: 🔍 ИССЛЕДОВАТЕЛЬ
- 51-70: 🔨 СТРОИТЕЛЬ
- 71-90: 🚀 ГОТОВ К ЗАПУСКУ
- 91-100: ⭐ VALIDATED

### 2.4 Генерация отчёта ✅

**Реализовано в:** `supabase/functions/val-chat/index.ts` (функция `generateReport()`)

Шаблон markdown отчёта (из `plan_valli.md`, секция 6.2):

```markdown
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 **ТВОЙ РЕЗУЛЬТАТ: {total}/100**

🔍 Архетип: **{archetype}**

"{описание архетипа}"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ **ЧТО УЖЕ ХОРОШО**

• {strength 1}
• {strength 2}
• {strength 3}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🚩 **КРАСНЫЕ ФЛАГИ** (вопросы без ответа)

• {red_flag 1}
• {red_flag 2}
• {red_flag 3}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📚 **ЧТО ИЗУЧИТЬ В BIZLEVEL**

• **Уровень {X}: {Название}** — {reason}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 **ONE THING: Твоё действие на эту неделю**

{one_thing}

Это поднимет твой балл на +10-15 пунктов.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 2.5 Интеграция с уровнями BizLevel ✅

**Реализовано в:** `supabase/functions/val-chat/index.ts` (функция `getRecommendedLevels()`)

Реализована функция, которая автоматически выбирает 2 самых слабых критерия и рекомендует соответствующие уровни.

Маппинг слабых критериев на уровни/артефакты (из `plan_valli.md`, секция 7.1):

```typescript
const levelMapping = {
  problem: [
    { level_id: 8, level_number: 8, name: 'Блиц-опрос клиентов', reason: 'поможет проверить, реальна ли боль' },
    { artifact: '5 вопросов ВЖПРП', reason: 'готовый сценарий для интервью' }
  ],
  customer: [
    { level_id: 5, level_number: 5, name: 'Создание УТП', reason: 'поможет определить целевую аудиторию' },
    { artifact: 'Конструктор УТП', reason: 'поможет создать портрет клиента' }
  ],
  unique: [
    { level_id: 6, level_number: 6, name: 'Elevator Pitch', reason: 'поможет выделить уникальность' },
    { artifact: 'Карточка питча', reason: 'поможет сформулировать отличия' }
  ],
  action: [
    { level_id: 7, level_number: 7, name: 'SMART-планирование', reason: 'поможет составить план действий' },
    { level_id: 3, level_number: 3, name: 'Матрица Эйзенхауэра', reason: 'поможет приоритизировать задачи' }
  ],
  validation: [
    { level_id: 8, level_number: 8, name: 'Блиц-опрос', reason: 'поможет проверить гипотезы' }
  ]
};
```

### 2.6 GP-экономика ✅

**Статус:** Реализовано  
**Дата выполнения:** 15.12.2024

**Модель монетизации:**
- Первая валидация — **БЕСПЛАТНО** (онбординг)
- Повторные валидации — **20 GP** за сессию
- История валидаций — всегда доступна

**Что реализовано:**
1. ✅ Проверка количества завершённых валидаций пользователя
2. ✅ Списание 20 GP через RPC функцию `gp_spend`
3. ✅ Обработка ошибки недостаточного баланса (402 Payment Required)
4. ✅ Логирование бесплатной первой валидации
5. ✅ Сохранение `gp_spent` в таблице `idea_validations`
6. ✅ Идемпотентность через `idempotency_key`

**Реализация в Edge Function:**

```typescript
// Проверяем количество завершённых валидаций
const { count } = await supabaseAdmin
  .from('idea_validations')
  .select('*', { count: 'exact', head: true })
  .eq('user_id', userId)
  .eq('status', 'completed');

const isFirstValidation = (count || 0) === 0;

if (!isFirstValidation) {
  // Списываем VALIDATION_COST_GP через RPC
  const { data: spendResult, error: spendError } = await supabaseAdmin
    .rpc('gp_spend', {
      p_type: 'idea_validation',
      p_amount: VALIDATION_COST_GP,
      p_reference_id: validationId || '',
      p_idempotency_key: `validation_${userId}_${Date.now()}`,
    });

  if (spendError) {
    // Обработка ошибки недостаточного баланса
    if (spendError.message?.includes('insufficient') || spendError.code === '23514') {
      return new Response(
        JSON.stringify({ 
          error: "insufficient_gp",
          message: `Недостаточно GP. Нужно ${VALIDATION_COST_GP} GP для валидации идеи.`,
          required: VALIDATION_COST_GP
        }),
        { status: 402, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }
  }
} else {
  console.log('INFO first_validation_free', { userId });
}
```

**Требуется деплой:** Обновлённая версия функции с GP-логикой - выполнено.

## Этап 3: Frontend — UI компоненты ⏳

**Статус:** В процессе реализации  
**Планируемое начало:** После деплоя Edge Function

---

### 3.1 Сервис ValiService ✅

**Статус:** Завершён  
**Дата выполнения:** 15.12.2024

**Файл:** `lib/services/vali_service.dart`  
**Документация:** `docs/val-chat/vali-service-usage.md`

Переиспользует логику `LeoService`, но вызывает `/functions/v1/val-chat`:

**Что реализовано:**

1. ✅ Класс `ValiService` с полным DI через `SupabaseClient`
2. ✅ Dio-клиент для вызова Edge Function `/val-chat`
3. ✅ Методы API:
   - `sendMessage()` — диалог (режим dialog)
   - `scoreValidation()` — скоринг (режим score)
   - `createValidation()` — создание записи в idea_validations
   - `getValidation()` — получение валидации по ID
   - `updateValidationProgress()` — обновление current_step
   - `saveValidationResults()` — сохранение результатов скоринга
   - `getUserValidations()` — список всех валидаций
   - `isFirstValidation()` — проверка первой валидации (для GP)
   - `abandonValidation()` — пометка как заброшенной
   - `saveConversation()` — сохранение в leo_chats/leo_messages
4. ✅ Обработка ошибок:
   - Аутентификация (401) с автоматическим refresh
   - Недостаточно GP (402) — специальная обработка
   - Сетевые ошибки (SocketException)
   - Timeout (30 сек)
   - Серверные ошибки (500+)
5. ✅ Retry механизм с экспоненциальным backoff
6. ✅ Sentry breadcrumbs для отладки
7. ✅ Typed exception `ValiFailure` с кодом и данными
8. ✅ Интеграция с `GpService` (проверка баланса)

**Пример использования:**

```dart
final valiService = ValiService(Supabase.instance.client);

// Создание валидации
final validationId = await valiService.createValidation();

// Отправка сообщения
final response = await valiService.sendMessage(
  messages: [{'role': 'user', 'content': 'Моя идея...'}],
  validationId: validationId,
);

// Скоринг валидации
final result = await valiService.scoreValidation(
  messages: messages,
  validationId: validationId,
);

// Обработка ошибки 402 (недостаточно GP)
try {
  await valiService.sendMessage(...);
} on ValiFailure catch (e) {
  if (e.statusCode == 402) {
    // Показать диалог пополнения GP
    final required = e.data?['required'] ?? 100;
    showGpTopUpDialog(required);
  }
}
        'scores': scores,
        'total_score': totalScore,
        'archetype': archetype,
        'report_markdown': reportMarkdown,
        'one_thing': oneThing,
        'recommended_levels': recommendedLevels,
        'status': 'completed',
        'completed_at': DateTime.now().toIso8601String(),
      })
      .eq('id', validationId);
  }
}
```

### 3.2 Экран диалога с Валли ✅

**Статус:** Завершён  
**Дата выполнения:** 15.12.2024

**Файл:** `lib/screens/vali_dialog_screen.dart`  
**Provider:** `lib/providers/vali_service_provider.dart`

Важно: Создал временный  ассет Валли!

**Реализован Вариант 1**: Переиспользование `LeoDialogScreen` с модификациями

**Что реализовано:**
1. ✅ **Диалоговый режим** — чат с Валли (7 вопросов)
2. ✅ **Прогресс-бар** — индикатор шага (1/7, 2/7, ..., 7/7) в AppBar
3. ✅ **Автоматическое создание валидации** — при старте нового чата
4. ✅ **Загрузка существующей валидации** — по `validationId`
5. ✅ **Сохранение сообщений** — в `leo_chats`/`leo_messages` с `bot='vali'`
6. ✅ **Обновление прогресса** — `current_step` после каждого вопроса
7. ✅ **Запрос скоринга** — после 7-го вопроса (диалоговое подтверждение)
8. ✅ **Отображение отчёта** — режим просмотра с markdown рендерингом
9. ✅ **CTA кнопки после отчёта**:
   - "Пройти рекомендованный урок" (навигация к уровню)
   - "Поставить цель с Максом" (переход к Max)
   - "Проверить другую идею" (новая валидация)
   - "Вернуться в Башню" (назад)
10. ✅ **Обработка ошибок**:
   - 402 (недостаточно GP) — диалог пополнения
   - Сетевые ошибки
   - Timeout
11. ✅ **UX элементы**:
   - Typing indicator при ожидании ответа
   - FAB "Scroll to bottom"
   - Анимация появления сообщений
   - Debounce отправки (500ms)
12. ✅ **Интеграция с Riverpod** — `valiServiceProvider`

**Особенности реализации:**
- Переиспользует виджеты из LeoDialogScreen (`LeoMessageBubble`, `TypingIndicator`)
- Автоматический скроллинг к последнему сообщению
- Markdown рендеринг отчёта через `flutter_markdown`
- Sentry breadcrumbs для отладки
- Обновление GP баланса после отправки сообщения

**Структура:**
```dart
class ValiDialogScreen extends StatefulWidget {
  final String? chatId;
  final String? validationId;
  
  // ...
}

class _ValiDialogScreenState extends State<ValiDialogScreen> {
  String? _validationId;
  Map<String, dynamic>? _validationData;
  List<Map<String, dynamic>> _messages = [];
  int _currentStep = 1;
  bool _isSending = false;
  
  @override
  void initState() {
    super.initState();
    _loadValidation();
  }
  
  Future<void> _loadValidation() async {
    if (widget.validationId != null) {
      _validationData = await _valiService.getValidation(widget.validationId!);
      if (_validationData?['status'] == 'completed') {
        // Показать отчёт
      }
    }
  }
  
  Future<void> _sendMessage(String text) async {
    // 1. Сохранить сообщение пользователя
    // 2. Вызвать ValiService.sendMessage
    // 3. Получить ответ Валли
    // 4. Обновить current_step
    // 5. Если current_step == 7, инициировать скоринг
  }
  
  Widget _buildReportView() {
    // Отобразить ValiReportWidget
  }
  
  // ...
}
```

### 3.3 Карточка Валли в Base Trainers ✅

**Статус:** Завершён  
**Дата выполнения:** 15.12.2024

**Файл:** `lib/screens/leo_chat_screen.dart` (модификация `_buildBotSelectorCards`)

**Что реализовано:**

1. ✅ **Третья карточка Валли** — добавлена в `_buildBotSelectorCards()`
2. ✅ **Изменён layout** — с горизонтального Row на вертикальный Column
3. ✅ **Навигация к ValiDialogScreen** — через `_onNewChat('vali')`
4. ✅ **Поддержка в истории чатов** — отображение чатов с `bot='vali'`
5. ✅ **Аватар и метаданные** — `avatar_vali.png`, "Vali AI", "Проверь идею на прочность"

**Реализованная структура карточек:**

```dart
// Вертикальный layout (Column) для 3 карточек
return Column(
  children: [
    buildCard(
      bot: 'leo',
      name: 'Leo AI',
      subtitle: 'Твой бизнес‑ментор',
      avatar: 'assets/images/avatars/avatar_leo.png',
    ),
    buildCard(
      bot: 'max',
      name: 'Max AI',
      subtitle: 'Твой помощник в достижении цели',
      avatar: 'assets/images/avatars/avatar_max.png',
    ),
    buildCard(
      bot: 'vali',
      name: 'Vali AI',
      subtitle: 'Проверь идею на прочность',
      avatar: 'assets/images/avatars/avatar_vali.png',
    ),
  ],
);
```

**Навигация (`_onNewChat`):**

```dart
void _onNewChat(String bot) {
  if (bot == 'vali') {
    // Валли → ValiDialogScreen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ValiDialogScreen(),
      ),
    );
  } else {
    // Лео/Макс → LeoDialogScreen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FutureBuilder<List<String?>>(
            // Существующая логика для Leo/Max
          );
        }
      },
    ),
  );
}
```

**История чатов (обработка `bot='vali'`):**

```dart
// В _buildChats() добавлена поддержка Валли
final String botRaw = (chat['bot'] as String?)?.toLowerCase() ?? 'leo';
final String bot = ['leo', 'max', 'vali'].contains(botRaw) ? botRaw : 'leo';

// Для чатов Валли используем ValiDialogScreen
if (bot == 'vali') {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => ValiDialogScreen(
        chatId: chat['id'],
      ),
    ),
  );
}
```

**Ключевые изменения:**

1. **Layout изменён с Row на Column** — для размещения 3 карточек вертикально
2. **Убран `Expanded` wrapper** — карточки теперь занимают естественную высоту
3. **Добавлен вертикальный margin** — `margin: AppSpacing.insetsSymmetric(v: 6)`
4. **Import ValiDialogScreen** — добавлен импорт в начале файла
5. **Условная навигация** — проверка `bot == 'vali'` в двух местах:
   - `_onNewChat()` — для новых чатов
   - `_buildChats()` — для истории чатов

### 3.4 Отображение отчёта ✅

**Статус:** Уже реализовано в ValiDialogScreen  
**Дата:** 15.12.2024

Отображение отчёта полностью реализовано в `ValiDialogScreen._buildReportView()`:

- ✅ Markdown рендеринг через `flutter_markdown`
- ✅ Карточка с баллом и архетипом
- ✅ CTA кнопки (уровни, переход к Максу, новая валидация)
- ✅ Responsive layout

**Примечание:** Отдельный виджет `ValiReportWidget` не требуется, так как логика уже встроена в ValiDialogScreen.

### 3.4 Интеграция с GoRouter (Запланировано после MVP) ⏳

**Статус:** Запланировано на будущее  
**Приоритет:** Низкий (не критично для MVP)

**Текущее решение:** Используется `Navigator.push` с `MaterialPageRoute`, что работает отлично для MVP.

**Планируемая реализация (после тестирования MVP):**

Добавить роуты в GoRouter конфигурацию:

```dart
// В файле конфигурации роутера (например, lib/router/app_router.dart)
GoRoute(
  path: '/chat/vali',
  builder: (context, state) {
    final validationId = state.uri.queryParameters['validationId'];
    final chatId = state.uri.queryParameters['chatId'];
    return ValiDialogScreen(
      validationId: validationId,
      chatId: chatId,
    );
  },
),
```

**Преимущества GoRouter (для будущих версий):**
- Deep links: `bizlevel://chat/vali?validationId=123`
- Навигация через URL: `context.push('/chat/vali')`
- История браузера (для веб-версии)
- Typed routes с code generation

**Почему не в MVP:**
- `Navigator.push` полностью покрывает текущие потребности
- Не требуется deep linking на данном этапе
- Нет веб-версии
- Экономия времени на разработку

### 3.5 (Устарел) Отдельный виджет отчёта

**Статус:** Не требуется  
**Причина:** Отчёт уже реализован в `ValiDialogScreen._buildReportView()`

Изначально планировался отдельный виджет для отображения markdown отчёта:

```dart
class ValiReportWidget extends StatelessWidget {
  final String reportMarkdown;
  final Map<String, dynamic> validationData;
  
  const ValiReportWidget({
    required this.reportMarkdown,
    required this.validationData,
  });
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Парсинг markdown (использовать flutter_markdown)
          MarkdownBody(data: reportMarkdown),
          
          SizedBox(height: 24),
          
          // CTA кнопки
          _buildActionButtons(context),
        ],
      ),
    );
  }
  
  Widget _buildActionButtons(BuildContext context) {
    final recommendedLevels = validationData['recommended_levels'] as List? ?? [];
    
    return Column(
      children: [
        // Кнопка к Максу (только переход, без передачи данных Валли)
        ElevatedButton(
          onPressed: () {
            // Переход к Max
          },
          child: Text('Поставить цель с Максом'),
        ),
        
        // Кнопки к уровням
        ...recommendedLevels.map((level) => 
          ElevatedButton(
            onPressed: () {
              // Навигация к уровню
            },
            child: Text('Пройти Уровень ${level['level_number']}'),
          ),
        ),
        
        // Кнопка новой валидации
        OutlinedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => ValiDialogScreen()),
            );
          },
          child: Text('Проверить другую идею'),
        ),
      ],
    );
  }
}
```

## Этап 4: Интеграции

### 4.1 Навигация к уровням

При нажатии "Пройти Уровень X":

```dart
void _navigateToLevel(BuildContext context, int levelNumber) {
  // Использовать существующую навигацию к уровням
  // Например, через GoRouter или существующий механизм
  context.go('/levels/$levelNumber');
  
  // Или показать SnackBar с пояснением:
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Валли рекомендовал этот уровень для твоей идеи'),
    ),
  );
}
```

### 4.2 GP-экономика (Frontend)

В `ValiService` добавить проверку перед созданием валидации:

```dart
Future<String> createValidation({String? chatId}) async {
  // Проверяем количество завершённых валидаций
  final { count } = await _client
    .from('idea_validations')
    .select('*', { count: 'exact', head: true })
    .eq('user_id', _client.auth.currentUser!.id)
    .eq('status', 'completed');
  
  final isFirstValidation = count == 0;
  
  if (!isFirstValidation) {
    // Проверяем баланс GP
    final gpService = GpService(_client);
    final balance = await gpService.getBalance();
    
    if (balance < 100) {
      throw ValiFailure('Недостаточно GP. Нужно 20 GP для валидации идеи.');
    }
    
    // Списываем GP (или это делается на сервере?)
    // В зависимости от архитектуры GP-системы
  }
  
  // Создаём валидацию
  // ...
}
```

## Этап 5: Дополнительные точки входа (опционально для MVP)

### 5.1 Карточка на Main Street

**Файл:** `lib/screens/main_street_screen.dart`

Добавить карточку "Лаборатория идей" рядом с Башней (после Уровня 5).

### 5.2 Библиотека

**Файл:** `lib/screens/library_screen.dart`

Добавить раздел "Проверить идею" в библиотеке.

### 5.3 После Уровня 5

После завершения Уровня 5 (УТП) показывать предложение проверить идею.

*(Эти точки входа можно реализовать во второй фазе)*

## Порядок реализации (MVP)

### Sprint 1: Backend Foundation ✅ ЗАВЕРШЁН (15.12.2024)

1. ✅ **Миграция**: таблица `idea_validations` — выполнено
2. ✅ **Миграция**: расширение `leo_chats.bot` для 'vali' — выполнено
3. ✅ **Edge Function `val-chat`**: полная реализация — выполнено
   - Системный промпт Валли (7 вопросов) ✅
   - Логика диалога (режим `dialog`) ✅
   - Логика скоринга (режим `score`, JSON output) ✅
   - Генерация отчёта (markdown) ✅
   - Маппинг рекомендаций BizLevel ✅
4. ✅ **GP-логика**: проверка первой валидации, списание 20 GP — выполнено
   - Проверка количества завершённых валидаций ✅
   - Списание через RPC `gp_spend` ✅
   - Обработка ошибки недостаточного баланса ✅
   - Сохранение `gp_spent` в таблице ✅
5. ✅ **Деплой** в Supabase — выполнено (12:48 PM, 15.12.2024)

**Результат:** Backend полностью готов и редеплоен! Edge Function работает и доступна по URL:
`https://acevqbdpzgbtqznbpgzr.supabase.co/functions/v1/val-chat`

### Sprint 2: Frontend Integration ✅ ЗАВЕРШЁН (15.12.2024)

1. ✅ **`ValiService`**: сервис для вызова val-chat — выполнено
   - 10 методов (sendMessage, scoreValidation, createValidation и др.) ✅
   - Обработка всех типов ошибок ✅
   - Retry механизм ✅
   - Sentry breadcrumbs ✅
2. ✅ **Модификация `LeoChatScreen`**: добавление карточки Валли — выполнено
   - Карточка "Vali AI" добавлена ✅
   - Layout изменён на Column ✅
   - Навигация к ValiDialogScreen ✅
   - История чатов с поддержкой bot='vali' ✅
3. ✅ **`ValiDialogScreen`**: экран диалога с Валли — выполнено
   - Поддержка диалога (7 вопросов) ✅
   - Прогресс-бар (1/7, 2/7, ..., 7/7) ✅
   - Скоринг после завершения ✅
   - Отображение отчёта (markdown) ✅
4. ✅ **CTA кнопки**: действия после валидации — выполнено
   - "Пройти рекомендованный урок" ✅
   - "Поставить цель с Максом" (переход в Max без передачи данных Валли) ✅
   - "Проверить другую идею" ✅
5. ✅ **GP-логика на фронтенде**: обработка 402 ошибки — выполнено
   - Диалог пополнения GP ✅
   - Навигация к GP Purchase ✅
6. ✅ **Документация**: полное руководство — выполнено
   - vali-service-usage.md ✅
   - vali-dialog-screen-usage.md ✅
   - base-trainers-integration.md ✅

**Результат:** Frontend полностью готов! MVP Валли функционален и готов к тестированию.

### Sprint 3: Полировка (Запланировано после тестирования MVP)

**Приоритет:** Низкий (не блокирует релиз)

1. ⏳ **GoRouter интеграция** — deep links для валидаций
2. ⏳ **ValiHistoryScreen** — отдельный экран истории валидаций
3. ⏳ **Уникальный аватар** — заменить копию Лео на уникальный дизайн
4. ⏳ **Подсказки (chips)** — рекомендованные вопросы
5. ⏳ **Аналитика** — трекинг метрик валидаций
6. ⏳ **A/B тестирование** — формулировок вопросов
7. ⏳ **Дополнительные точки входа** — Main Street, Библиотека

## Файлы для изменения/создания

### Новые файлы

#### Созданные (Backend):
- ✅ `supabase/migrations/20251215_create_idea_validations.sql`
- ✅ `supabase/migrations/20251215_add_vali_bot_to_leo_chats.sql`
- ✅ `supabase/functions/val-chat/index.ts`

#### Созданные (Frontend):
- ✅ `lib/services/vali_service.dart` (~600 строк)
- ✅ `lib/services/vali_service_example.dart` (~250 строк)
- ✅ `lib/providers/vali_service_provider.dart`
- ✅ `lib/screens/vali_dialog_screen.dart` (~800 строк)
- ✅ `lib/screens/vali_dialog_screen_example.dart` (~150 строк)
- ✅ `assets/images/avatars/avatar_vali.png` (временная копия Лео)

#### Созданные (Документация):
- ✅ `docs/val-chat/README.md`
- ✅ `docs/val-chat/val-plan.md` (этот файл, 1200+ строк)
- ✅ `docs/val-chat/vali-service-usage.md` (~460 строк)
- ✅ `docs/val-chat/vali-dialog-screen-usage.md` (~650 строк)
- ✅ `docs/val-chat/base-trainers-integration.md` (~310 строк)

### Модифицированные файлы

- ✅ `lib/screens/leo_chat_screen.dart` — добавлена карточка Валли, обновлена навигация
- ✅ `pubspec.yaml` — добавлена зависимость `flutter_markdown: ^0.7.4+1`

### Файлы НЕ требуется создавать:

- ❌ `lib/widgets/vali_report_widget.dart` — не нужен, логика встроена в ValiDialogScreen
- ❌ Изменения в `lib/services/leo_service.dart` — не требуется, ValiService независим

## Технические детали

### System Prompt для val-chat

Полный промпт должен включать (из `plan_valli.md`, секция 8.2):

```typescript
const SYSTEM_PROMPT = `
Ты Валли — AI-валидатор идей школы бизнеса BizLevel.

ТВОЯ РОЛЬ:
- Критический друг, не судья
- Задаёшь неудобные вопросы мягко
- Не говоришь "делай так", а подсвечиваешь слепые зоны
- Поддерживаешь, не демотивируешь

ФОРМАТ ДИАЛОГА:
- Короткие сообщения (2-4 предложения)
- Один вопрос за раз
- Если ответ расплывчатый — уточни
- Используй эмпатию: "Понимаю", "Интересно", "Хороший вопрос"

ПОСЛЕДОВАТЕЛЬНОСТЬ ВОПРОСОВ:
1. Суть идеи (что создаёшь?)
2. Проблема (какую боль решаешь?)
3. Клиент (для кого конкретно?)
4. Валидация (откуда знаешь о проблеме?)
5. Конкуренты (как решают сейчас?)
6. Преимущество (почему ты?)
7. [опционально] Следующий шаг

КОНТЕКСТ КАЗАХСТАНА:
- Используй тенге (KZT), не доллары
- Учитывай местные реалии (Kaspi, базары, WhatsApp)
- Понимай менталитет: важны связи, доверие, "понты"

КРАСНЫЕ ФЛАГИ (подсвечивай мягко):
- "Всем нужно" → "А кому конкретно больше всего?"
- "Конкурентов нет" → "А как люди решают это сейчас?"
- "Я уверен" без доказательств → "Интересно, а откуда уверенность?"
- "Приложение" на всё → "А можно начать проще — с бота?"

ТОН:
Прямота + Эмпатия + Конкретика
`;
```

### Scoring Prompt

Отдельный промпт для LLM, который оценивает ответы по 5 критериям (0-20 каждый) и возвращает JSON:

```typescript
const SCORING_PROMPT = `
Оцени ответы пользователя по 5 критериям (0-20 каждый):

1. ПОНИМАНИЕ ПРОБЛЕМЫ
   0-5: Нет проблемы / "всем нужно"
   6-10: Абстрактная проблема
   11-15: Конкретная, но без примеров
   16-20: Конкретная + реальные примеры

2. ЗНАНИЕ КЛИЕНТА
   0-5: "Все" / "любой"
   6-10: Демография без глубины
   11-15: Конкретная ниша
   16-20: Живой портрет + где найти

3. ВАЛИДАЦИЯ
   0-5: Только догадка
   6-10: Личный опыт без проверки
   11-15: Разговаривал с 1-3 людьми
   16-20: Систематические интервью

4. УНИКАЛЬНОСТЬ
   0-5: Нет отличий
   6-10: Слабое отличие
   11-15: Понятное отличие
   16-20: Сильный unfair advantage

5. ГОТОВНОСТЬ К ДЕЙСТВИЮ
   0-5: Нет плана
   6-10: Абстрактный план
   11-15: Конкретные шаги
   16-20: Уже начал действовать

Верни JSON:
{
  "scores": {
    "problem": N,
    "customer": N,
    "validation": N,
    "unique": N,
    "action": N
  },
  "total": N,
  "archetype": "МЕЧТАТЕЛЬ|ИССЛЕДОВАТЕЛЬ|СТРОИТЕЛЬ|ГОТОВ К ЗАПУСКУ",
  "strengths": ["...", "..."],
  "red_flags": ["...", "..."],
  "one_thing": "Конкретное действие на неделю",
  "recommended_levels": [{"level_id": 8, "level_number": 8, "reason": "..."}]
}
`;
```

### Рекомендации BizLevel

Хардкод маппинга критериев → уровни (см. секцию 2.5).

## Метрики успеха

### Ключевые метрики (из `plan_valli.md`, секция 10)

**ВОВЛЕЧЕНИЕ:**
- Completion Rate: % начавших → завершивших (Target: >60%)
- Time to Complete: среднее время сессии (Target: 5-10 минут)
- Repeat Rate: % вернувшихся на повторную валидацию (Target: >20% в течение месяца)

**КОНВЕРСИЯ:**
- To Max: % перешедших к постановке цели (Target: >30%)
- To Level: % перешедших к рекомендованному уровню (Target: >25%)
- GP Conversion: % оплативших повторные сессии (Target: >15%)

**КАЧЕСТВО:**
- NPS: Net Promoter Score по фиче (Target: >40)
- Полезность ONE THING: % выполнивших действие (Target: >20%)

## Риски и митигация

| Риск | Вероятность | Митигация |
|------|-------------|-----------|
| Низкий Completion Rate | Средняя | Сократить до 5 вопросов, добавить progress bar |
| "Скучные" вопросы | Средняя | A/B тестирование формулировок, добавить примеры |
| Слишком критичный тон | Низкая | Настроить System Prompt на эмпатию |
| Неточный скоринг | Средняя | Итеративная калибровка на реальных кейсах |
| Конфликт с Лео | Низкая | Чёткое разделение: Лео учит, Валли проверяет |

---

*Документ создан на основе `docs/val-chat/plan_valli.md`*  
*Версия: 1.0*