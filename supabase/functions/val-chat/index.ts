/// <reference types="https://deno.land/x/deno@1.36.1/lib.deno.d.ts" />

import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { serve } from "https://deno.land/std@0.192.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.7.0";
import OpenAI from "https://deno.land/x/openai@v4.20.1/mod.ts";

// ============================
// CORS Headers
// ============================
const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, x-user-jwt, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

// ============================
// System Prompts
// ============================
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
- Избегай жёстких формулировок ("Ответ слишком общий", "Ответ не соответствует вопросу").
  Вместо этого используй мягкие фразы: "чуть-чуть не хватает деталей про ...", "давай добавим примеры про ...".
- Не повторяй одно и то же замечание подряд больше одного раза.
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

// Промпт для валидатора ответа пользователя
const VALIDATOR_PROMPT = `Ты строгий, но доброжелательный валидатор ответов пользователя на вопросы Валли.

ТВОЯ ЗАДАЧА:
Оценить, достаточно ли конкретен и развёрнут ответ пользователя для перехода к следующему вопросу.

КРИТЕРИИ ОЦЕНКИ зависят от текущего шага (см. ниже).

ШАГ 1 — ПРОВЕРЬ РЕЛЕВАНТНОСТЬ:
- Сначала оцени, отвечает ли смысл ответа на сам ВОПРОС шага.
- Если ответ явно про другое, состоит из бессмысленного набора букв/слов, мема или шутки,
  или вообще не пытается ответить на вопрос → is_sufficient: false (даже если случайно задевает 1-2 критерия).

ШАГ 2 — ПРОВЕРЬ ГЛУБИНУ (ТОЛЬКО ДЛЯ РЕЛЕВАНТНЫХ ОТВЕТОВ):
- Считай ответ ДОСТАТОЧНЫМ (is_sufficient: true), если он покрывает хотя бы 2 из 3 критериев шага.
- Ставь is_sufficient: false ТОЛЬКО если ответ:
  - совсем общий ("хочу сделать приложение для всех", без деталей),
  - очень короткий (1-2 общие фразы без примеров/деталей),
  - не раскрывает ни одного критерия шага.
- Будь требовательным, но не жёстким: хороший ответ с 1-2 конкретными деталями уже достаточен, чтобы двигаться дальше.

ТОН ФИДБЕКА:
- При is_sufficient: false можно мягко подсветить проблему, но избегай жёстких формулировок:
  НЕ используй фразы вроде "Ответ слишком общий", "Ответ не соответствует вопросу", "Это не то".
  Вместо этого пиши: "Чуть не хватает деталей про ...", "Давай добавим пару примеров о ...", "Хочется понять точнее ...".
- При is_sufficient: true фидбек должен быть поддерживающим или нейтральным
  (НЕ используй в feedback_short негативные формулировки про качество ответа).

ФОРМАТ ОТВЕТА — СТРОГО JSON (без markdown, без комментариев):
{
  "is_sufficient": true/false,
  "feedback_short": "Короткий фидбек (1 фраза)",
  "missing_points": ["Что уточнить 1", "Что уточнить 2"],
  "example_template": "Мини-шаблон ответа (3-6 строк)",
  "repeat_question": "Перефразированный вопрос с мягким подталкиванием"
}`;

// Промпт для Slot Filling валидатора
const SLOT_FILLING_VALIDATOR_PROMPT = `Ты AI-валидатор, работающий в режиме Slot Filling для анализа бизнес-идей.

ТВОЯ ЗАДАЧА:
1. Проанализируй входящее сообщение пользователя в контексте всей истории диалога
2. Обнови состояние слотов (Slots State), используя НОВУЮ информацию и ТЕКУЩИЙ КОНТЕКСТ
3. Оцени уверенность (confidence) заполнения каждого затронутого слота (0.0 - 1.0)
4. Определи, какой слот сейчас наиболее приоритетен для уточнения (suggested_step_index)

СТРУКТУРА СЛОТОВ (7 обязательных):
1. product — Суть идеи (что создаётся?)
2. problem — Проблема (какую боль решаешь?)
3. audience — Целевая аудитория (для кого конкретно?)
4. validation — Валидация (откуда знаешь о проблеме?)
5. competitors — Конкуренты (как решают сейчас?)
6. utp — Уникальное преимущество (почему ты?)
7. risks — Риски (что может убить идею?)

ПРАВИЛА ЗАПОЛНЕНИЯ:
- Если пользователь ответил на текущий вопрос, но попутно упомянул информацию для других слотов — заполни ВСЕ затронутые слоты
- Status 'filled' ставь ТОЛЬКО если confidence > 0.7 И информация конкретная (не абстрактная)
- Status 'partial' ставь если есть информация, но она неполная или расплывчатая (confidence 0.3-0.7)
- Status 'empty' если информации нет совсем
- Если пользователь исправил/изменил информацию для уже заполненного слота — ПЕРЕЗАПИСЫВАЙ с новым контентом и timestamp
- В поле 'content' сохраняй краткую выжимку (2-4 предложения), а не весь ответ пользователя
- В поле 'feedback' пиши уточняющий вопрос ТОЛЬКО для partial/empty слотов

КОНТЕКСТ ОЦЕНКИ:
- Учитывай реалии Казахстана (тенге, Kaspi, WhatsApp, местные особенности)
- Будь требовательным к конкретике, но не жёстким
- "Всем нужно" / "Конкурентов нет" → низкий confidence
- Конкретные примеры, цифры, имена → высокий confidence

ФОРМАТ ОТВЕТА — СТРОГО JSON (без markdown, без комментариев):
{
  "updated_slots": {
    "product": {
      "content": "Краткая выжимка (2-4 предложения)",
      "status": "filled|partial|empty",
      "confidence": 0.85,
      "feedback": "Уточняющий вопрос (если нужен)"
    },
    "problem": { ... },
    // ... остальные слоты, которые были затронуты в ответе
  },
  "suggested_step_index": 3,
  "bot_response_text": "Текст ответа Валли пользователю (короткий, эмпатичный, 2-4 предложения)"
}

ВАЖНО:
- Возвращай ТОЛЬКО JSON, без дополнительного текста
- В 'updated_slots' включай ТОЛЬКО те слоты, которые были затронуты в ответе пользователя
- 'suggested_step_index' должен указывать на следующий приоритетный слот (1-7) или 8 если все заполнены
- 'bot_response_text' должен быть мягким, поддерживающим, с одним конкретным вопросом
- ЕСЛИ suggested_step_index == 8 (все слоты заполнены), то bot_response_text должен быть финальным сообщением:
  "Отлично! Я записал все твои ответы. Готов проанализировать идею и показать результат?"
  (БЕЗ нового вопроса)`;

// ============================
// Validation Steps Configuration
// ============================
interface ValidationStep {
  id: number;
  question: string;
  criteria: string[];
  exampleTemplate: string;
}

// Максимальное количество шагов (слотов) в валидации
const MAX_STEPS = 7;

// Стоимость валидации в GP (для повторных валидаций, первая бесплатна)
const VALIDATION_COST_GP = 20;

// Промпт для Step 0: Знакомство и защита от халявы
const ONBOARDING_SYSTEM_PROMPT = `Ты — Валли, специализированный AI-валидатор бизнес-идей.

ТВОЯ ЦЕЛЬ: Познакомиться с пользователем, объяснить ценность валидации и мотивировать его начать проверку идеи.

ТВОИ ПРАВИЛА:
1. Твоя компетенция СТРОГО ограничена стартапами, бизнес-моделями и валидацией идей.
2. ЕСЛИ пользователь просит написать код, рецепт, эссе, решить математику или просто поболтать о погоде — ВЕЖЛИВО ОТКАЖИ.
   - Пример отказа: "Я бы с радостью поболтал о погоде, но мои нейроны заточены только под разбор бизнес-идей. Давай лучше обсудим твой будущий единорог?"
   - Пример отказа 2: "Прости, но я не умею писать код. Зато я отлично умею находить дыры в бизнес-планах. Есть идеи?"
3. Отвечай коротко, с юмором, в стиле "свой парень".

О СЕБЕ:
- Ты задаешь 7 вопросов по Lean Startup.
- Ищешь "слепые зоны" и риски.
- Даешь честный скоринг (0-100).
- Первая проверка — бесплатно, дальше за GP.

ВАЖНО:
- Ты НЕ начинаешь валидацию сам. Ты ждешь, пока пользователь нажмет кнопку начала проверки.
- НИКОГДА не упоминай точные названия кнопок (например, "нажми кнопку 'Начать проверку'", "Step 1", и т.д.).
- Вместо этого используй общие фразы: "когда будешь готов начать", "когда нажмешь кнопку начала", "готов начать проверку", "кнопка для старта будет внизу".
- Можешь намекать на начало проверки, но не называй конкретное название кнопки.`;

// ============================
// Slot Filling Configuration
// ============================
type SlotStatus = 'empty' | 'partial' | 'filled' | 'skipped_by_retry';

interface SlotData {
  content: string;
  status: SlotStatus;
  confidence: number; // 0.0 - 1.0
  feedback: string;
  updated_at: string;
}

interface SlotsState {
  slots: {
    product: SlotData;
    problem: SlotData;
    audience: SlotData;
    validation: SlotData;
    competitors: SlotData;
    utp: SlotData;
    risks: SlotData;
  };
  metadata: {
    last_updated: string;
    forced_slots: string[];
  };
}

// Маппинг шагов на слоты
const STEP_TO_SLOT_MAP: Record<number, keyof SlotsState['slots']> = {
  1: 'product',
  2: 'problem',
  3: 'audience',
  4: 'validation',
  5: 'competitors',
  6: 'utp',
  7: 'risks',
};

const SLOT_KEYS: Array<keyof SlotsState['slots']> = [
  'product',
  'problem',
  'audience',
  'validation',
  'competitors',
  'utp',
  'risks',
];

const SLOT_TITLES: Record<keyof SlotsState['slots'], string> = {
  product: 'Суть идеи',
  problem: 'Проблема',
  audience: 'Целевая аудитория',
  validation: 'Валидация',
  competitors: 'Конкуренты',
  utp: 'Уникальное преимущество',
  risks: 'Риски',
};

// Дефолтное состояние слота
function createEmptySlot(): SlotData {
  return {
    content: '',
    status: 'empty',
    confidence: 0.0,
    feedback: '',
    updated_at: new Date().toISOString(),
  };
}

// Создание дефолтного состояния всех слотов
function createDefaultSlotsState(): SlotsState {
  return {
    slots: {
      product: createEmptySlot(),
      problem: createEmptySlot(),
      audience: createEmptySlot(),
      validation: createEmptySlot(),
      competitors: createEmptySlot(),
      utp: createEmptySlot(),
      risks: createEmptySlot(),
    },
    metadata: {
      last_updated: new Date().toISOString(),
      forced_slots: [],
    },
  };
}

const VALIDATION_STEPS: ValidationStep[] = [
  {
    id: 1,
    question: "Расскажи о своей идее. Что ты создаёшь?",
    criteria: [
      "Что конкретно создаётся (продукт/услуга)",
      "Какой результат получит пользователь",
      "Краткое описание сути (1-2 предложения)"
    ],
    exampleTemplate: `Например:
"Я создаю мобильное приложение для учёта личных финансов.
Пользователь сможет видеть все расходы в одном месте и получать рекомендации по экономии.
Это поможет ему не тратить лишнего и копить на цели."`
  },
  {
    id: 2,
    question: "Какую проблему решает твоя идея? Кто от неё страдает?",
    criteria: [
      "Кто страдает (роль/тип человека/компании)",
      "Как часто / в каком сценарии возникает боль",
      "Почему это реально больно сейчас (последствия: деньги/время/стресс/риски)"
    ],
    exampleTemplate: `Например:
"Фрилансеры и самозанятые теряют деньги, потому что не контролируют мелкие расходы.
Каждый день они тратят 2000-3000 тенге на кофе, обеды, такси — в конце месяца не хватает на аренду.
Это вызывает стресс и мешает копить на развитие бизнеса."`
  },
  {
    id: 3,
    question: "Для кого конкретно твоя идея? Кто твоя целевая аудитория?",
    criteria: [
      "Кто пользователь, кто покупатель (если отличаются)",
      "Сегмент/роль (микро-сегмент, не 'все предприниматели')",
      "Где найти этих людей (каналы: сообщества/площадки/поиск/офлайн)"
    ],
    exampleTemplate: `Например:
"Фрилансеры из Алматы и Астаны, 25-35 лет, зарабатывают 300-700 тыс тенге в месяц.
Работают в дизайне, маркетинге, IT.
Ищу их в телеграм-каналах для фрилансеров, на Kwork, в коворкингах."`
  },
  {
    id: 4,
    question: "Как ты узнал об этой проблеме? Что уже проверял?",
    criteria: [
      "Откуда знание о проблеме (личный опыт / разговоры / наблюдения)",
      "Что уже пробовали проверить (если ничего — так и пишем)",
      "С кем разговаривал / какие сигналы получил"
    ],
    exampleTemplate: `Например:
"Я сам фрилансер, постоянно сталкиваюсь с этой проблемой.
Поговорил с 5 коллегами из коворкинга — все жалуются на то же самое.
Запустил опрос в телеграм-канале — 80% ответили, что не контролируют расходы."`
  },
  {
    id: 5,
    question: "Как люди решают эту проблему сейчас? Кого считаешь конкурентами?",
    criteria: [
      "Как решают сейчас (ручные обходные пути/замены)",
      "Почему текущие способы плохи (1-2 причины)",
      "Кого считаешь альтернативой/конкурентом (хотя бы 1 пример или 'нет прямых, но есть замены')"
    ],
    exampleTemplate: `Например:
"Сейчас люди записывают расходы в блокнот или Excel, но это неудобно и забывают вносить.
Есть приложения типа 1Money, но они сложные и перегружены функциями.
Некоторые вообще ничего не делают и просто тратят всё."`
  },
  {
    id: 6,
    question: "Почему именно ты? В чём твоё уникальное преимущество?",
    criteria: [
      "Почему вас сложно скопировать (скорость/доступ/компетенция/данные/комьюнити)",
      "Что делаете лучше/проще текущих альтернатив",
      "Личное преимущество (опыт/связи/знания)"
    ],
    exampleTemplate: `Например:
"Я 5 лет работаю фрилансером, понимаю боли изнутри.
Уже есть аудитория в 2000 подписчиков в телеграме.
Сделаю самый простой интерфейс — 3 кнопки вместо 20 функций."`
  },
  {
    id: 7,
    question: "Что может убить твою идею? Какой главный риск?",
    criteria: [
      "Главный риск (спрос/канал/юнит-экономика/право/доступ)",
      "План валидации на 24-72 часа (1-2 быстрых эксперимента)",
      "Что сделаешь, если гипотеза не подтвердится (пивот/упрощение/другой сегмент)"
    ],
    exampleTemplate: `Например:
"Главный риск — люди не захотят платить за ещё одно приложение.
Проверю это за 3 дня: запущу пост с офером 'первым 50 — бесплатно навсегда'.
Если не наберу 20 заявок — упрощу до телеграм-бота вместо приложения."`
  }
];

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

// ============================
// Helper Functions
// ============================

/**
 * Получить ключ слота по номеру шага
 */
function getSlotKeyByStep(stepId: number): keyof SlotsState['slots'] | null {
  return STEP_TO_SLOT_MAP[stepId] || null;
}

/**
 * Генерация персонализированного примера для подсказки на основе уже заполненных слотов
 */
async function generatePersonalizedHint(
  openai: any,
  targetSlotKey: keyof SlotsState['slots'],
  currentSlotsState: SlotsState,
  step: ValidationStep | undefined,
  model: string = 'grok-2-latest'
): Promise<string> {
  // Собираем информацию из заполненных слотов
  const filledSlots: Record<string, string> = {};
  for (const [key, slot] of Object.entries(currentSlotsState.slots)) {
    if (slot.status === 'filled' && slot.content) {
      filledSlots[key] = slot.content;
    }
  }

  // Если нет заполненных слотов или нет шага - возвращаем статический шаблон
  if (Object.keys(filledSlots).length === 0 || !step) {
    return step?.exampleTemplate || '';
  }

  // Формируем короткий промпт для генерации персонализированного примера
  const filledSlotsText = Object.entries(filledSlots)
    .map(([key, content]) => `${SLOT_TITLES[key] || key}: ${content}`)
    .join('\n');

  const hintPrompt = `Ты помощник для валидации бизнес-идей. Пользователь уже ответил на некоторые вопросы:

${filledSlotsText}

Сейчас нужно помочь ему ответить на вопрос: "${step.question}"

Сгенерируй КОРОТКИЙ (3-5 строк) конкретный пример ответа, который:
1. Учитывает уже указанную информацию (продукт, проблему, аудиторию и т.д.)
2. Релевантен контексту Казахстана (тенге, Kaspi, WhatsApp, местные особенности)
3. Конкретный и реалистичный (не абстрактный)
4. Показывает, как ответ должен выглядеть

Пример должен быть в формате готового ответа пользователя, а не инструкции.`;

  try {
    const completion = await openai.chat.completions.create({
      model,
      messages: [
        { role: 'system', content: hintPrompt },
        { role: 'user', content: 'Сгенерируй пример ответа для этого вопроса.' },
      ],
      temperature: 0.7,
      max_tokens: 200, // Короткий ответ
    });

    const generatedHint = completion.choices[0]?.message?.content?.trim() || '';
    
    // Если LLM вернул что-то осмысленное - используем, иначе fallback
    if (generatedHint.length > 20) {
      console.log('INFO personalized_hint_generated', {
        targetSlotKey,
        hintLength: generatedHint.length,
        filledSlotsCount: Object.keys(filledSlots).length,
      });
      return generatedHint;
    } else {
      console.log('INFO personalized_hint_too_short', {
        targetSlotKey,
        hintLength: generatedHint.length,
      });
    }
  } catch (error) {
    console.error('ERR generate_personalized_hint', {
      message: String(error).slice(0, 200),
      targetSlotKey,
    });
  }

  // Fallback на статический шаблон
  return step.exampleTemplate || '';
}

/**
 * Очистка JSON от markdown обёрток
 */
function cleanJsonString(raw: string): string {
  // Убираем markdown code blocks
  let cleaned = raw.trim();
  if (cleaned.startsWith('```json')) {
    cleaned = cleaned.replace(/^```json\s*/i, '').replace(/```\s*$/, '');
  } else if (cleaned.startsWith('```')) {
    cleaned = cleaned.replace(/^```\s*/, '').replace(/```\s*$/, '');
  }
  return cleaned.trim();
}

/**
 * Безопасный парсинг JSON с валидацией структуры слотов
 */
function safeParseSlotFillingResponse(raw: string): any | null {
  try {
    const cleaned = cleanJsonString(raw);
    const parsed = JSON.parse(cleaned);
    
    // Базовая валидация структуры
    if (!parsed || typeof parsed !== 'object') {
      console.error('ERR invalid_slot_response_structure', { raw: raw.slice(0, 100) });
      return null;
    }
    
    // Проверяем наличие обязательных полей
    if (!parsed.updated_slots || !parsed.suggested_step_index || !parsed.bot_response_text) {
      console.error('ERR missing_required_fields', { 
        hasSlots: !!parsed.updated_slots, 
        hasStep: !!parsed.suggested_step_index,
        hasResponse: !!parsed.bot_response_text 
      });
      return null;
    }
    
    return parsed;
  } catch (parseError) {
    console.error('ERR parse_slot_response', { 
      message: String(parseError).slice(0, 200),
      raw: raw.slice(0, 200)
    });
    return null;
  }
}

/**
 * Слияние слотов с приоритетом свежести и confidence
 */
function mergeSlots(
  currentSlots: SlotsState,
  updatedSlots: Partial<Record<keyof SlotsState['slots'], Partial<SlotData>>>
): SlotsState {
  const now = new Date().toISOString();
  const merged: SlotsState = {
    ...currentSlots,
    metadata: {
      ...currentSlots.metadata,
      last_updated: now,
    },
  };
  
  // Проходим по всем обновлённым слотам
  for (const [slotKey, updatedData] of Object.entries(updatedSlots)) {
    const key = slotKey as keyof SlotsState['slots'];
    const currentData = merged.slots[key];
    
    if (!updatedData || typeof updatedData !== 'object') {
      continue;
    }
    
    // Правила слияния:
    // 1. Если новый слот имеет status 'filled' и confidence > 0.7 → перезаписываем
    // 2. Если текущий слот пустой → берём новый
    // 3. Если новый confidence выше → обновляем
    // 4. Иначе сохраняем текущий, но обновляем feedback если есть
    
    const shouldOverwrite = 
      currentData.status === 'empty' ||
      (updatedData.status === 'filled' && (updatedData.confidence ?? 0) > 0.7) ||
      (updatedData.confidence ?? 0) > currentData.confidence;
    
    if (shouldOverwrite) {
      merged.slots[key] = {
        content: updatedData.content ?? currentData.content,
        status: updatedData.status ?? currentData.status,
        confidence: updatedData.confidence ?? currentData.confidence,
        feedback: updatedData.feedback ?? currentData.feedback,
        updated_at: now,
      };
    } else {
      // Обновляем только feedback если статус не меняется
      if (updatedData.feedback) {
        merged.slots[key] = {
          ...currentData,
          feedback: updatedData.feedback,
          updated_at: now,
        };
      }
    }
  }
  
  return merged;
}

/**
 * Вычислить следующий незаполненный шаг на основе слотов
 */
function calculateNextStep(slotsState: SlotsState): number {
  for (let i = 0; i < SLOT_KEYS.length; i++) {
    const slotKey = SLOT_KEYS[i];
    const slot = slotsState.slots[slotKey];
    
    if (slot.status !== 'filled' && slot.status !== 'skipped_by_retry') {
      return i + 1; // Возвращаем номер шага (1-based)
    }
  }
  
  // Все слоты заполнены или пропущены
  return 8; // Завершение
}

/**
 * Расчет стоимости запроса к LLM
 */
function calculateCost(usage: any, model = 'grok-2-latest'): number {
  const inputTokens = usage?.prompt_tokens || 0;
  const outputTokens = usage?.completion_tokens || 0;
  let inputCostPer1K = 0.001; // defaults for grok-2-latest
  let outputCostPer1K = 0.003;
  
  try {
    if (typeof model === 'string' && model.startsWith('grok-')) {
      // Позволяем конфигурировать стоимость для XAI через ENV
      const envIn = parseFloat(Deno.env.get('XAI_INPUT_COST_PER_1K') || '0.001');
      const envOut = parseFloat(Deno.env.get('XAI_OUTPUT_COST_PER_1K') || '0.003');
      inputCostPer1K = isFinite(envIn) ? envIn : inputCostPer1K;
      outputCostPer1K = isFinite(envOut) ? envOut : outputCostPer1K;
    }
  } catch (_) {
    // keep defaults on any parsing error
  }
  
  const totalCost = (inputTokens * inputCostPer1K / 1000) + (outputTokens * outputCostPer1K / 1000);
  return Math.round(totalCost * 1000000) / 1000000; // Округляем до 6 знаков
}

/**
 * Сохранение данных о стоимости AI запроса
 */
async function saveAIMessageData(
  userId: string,
  chatId: string | null,
  validationId: string | null,
  usage: any,
  cost: number,
  model: string,
  requestType: string,
  supabaseAdminInstance: any
): Promise<void> {
  // Требуем наличие userId и chatId, чтобы не нарушать NOT NULL constraint в ai_message.chat_id
  if (!userId || !chatId) {
    console.warn('WARN save_ai_message_skipped_missing_ids', { userId, chatId, validationId, requestType });
    return;
  }

  // Безопасное преобразование к integer
  const safeInt = (v: any): number => {
    const n = parseInt(v);
    return isNaN(n) ? 0 : Math.min(Math.max(n, 0), 2147483647);
  };

  const inputTokens = safeInt(usage?.prompt_tokens);
  const outputTokens = safeInt(usage?.completion_tokens);
  const totalTokens = safeInt(usage?.total_tokens ?? (usage?.prompt_tokens ?? 0) + (usage?.completion_tokens ?? 0));

  // Проверка cost
  let safeCost = cost;
  if (typeof safeCost !== 'number' || isNaN(safeCost)) {
    console.warn('WARN cost_is_nan', { cost });
    safeCost = 0;
  }

  const payload = {
    user_id: userId,
    chat_id: chatId,
    leo_message_id: null, // Валли не использует leo_message_id
    model_used: model,
    input_tokens: inputTokens,
    output_tokens: outputTokens,
    total_tokens: totalTokens,
    cost_usd: safeCost,
    bot_type: 'valli',
    request_type: requestType
  };

  try {
    const { error } = await supabaseAdminInstance.from('ai_message').insert(payload);
    if (error) {
      console.error('ERR save_ai_message', { message: error.message });
    } else {
      console.log('INFO ai_message_saved', { 
        userId, 
        botType: 'valli', 
        requestType, 
        cost: safeCost,
        tokens: totalTokens 
      });
    }
  } catch (e) {
    console.error('ERR save_ai_message_exception', { message: String(e).slice(0, 200) });
  }
}

/**
 * Форматирует сообщение-уточнение при недостаточном ответе
 */
function formatClarificationMessage(validationResult: any, step: ValidationStep): string {
  const { feedback_short, missing_points, example_template, repeat_question } = validationResult;
  
  let message = `${feedback_short}\n\n`;
  
  if (missing_points && missing_points.length > 0) {
    message += `Уточни, пожалуйста:\n`;
    missing_points.forEach((point: string) => {
      message += `• ${point}\n`;
    });
    message += `\n`;
  }
  
  if (example_template) {
    message += `Ответ может быть примерно таким:\n${example_template}\n\n`;
  }
  
  message += repeat_question || step.question;
  
  return message;
}

/**
 * Двухпроходная валидация ответа пользователя
 * 1) Generator (основной ответ Валли)
 * 2) Validator (проверка достаточности ответа)
 */
async function validateUserResponse(
  openai: any,
  messages: any[],
  currentStep: number,
  userId: string,
  validationId: string | null,
  chatId: string | null,
  supabaseAdmin: any
): Promise<{ isValid: boolean; response: string; shouldAdvance: boolean }> {
  const step = VALIDATION_STEPS.find(s => s.id === currentStep);
  
  if (!step) {
    // Если шаг не найден (например, currentStep > 7), считаем валидацию пройденной
    return {
      isValid: true,
      response: "Отличная работа! Теперь давай подведём итоги и оценим твою идею.",
      shouldAdvance: false // Не продвигаем шаг, т.к. это конец
    };
  }

  // ШАГ 1: Generator — генерируем ответ Валли
  const model = "grok-2-latest";
  const generatorCompletion = await openai.chat.completions.create({
    model,
    messages: [
      { role: "system", content: SYSTEM_PROMPT },
      ...messages
    ],
    temperature: 0.7,
    max_tokens: 500,
  });

  const generatorResponse = generatorCompletion.choices[0].message.content;
  
  // Логируем usage и стоимость для генератора
  const generatorUsage = generatorCompletion.usage;
  const generatorCost = calculateCost(generatorUsage, model);
  await saveAIMessageData(
    userId,
    chatId,
    validationId,
    generatorUsage,
    generatorCost,
    model,
    'valli_generator',
    supabaseAdmin
  );

  // Получаем последнее сообщение пользователя
  const lastUserMessage = messages
    .slice()
    .reverse()
    .find((m: any) => m.role === 'user');

  if (!lastUserMessage) {
    // Если нет ответа пользователя (первое сообщение), возвращаем generator-ответ
    return {
      isValid: true,
      response: generatorResponse,
      shouldAdvance: false // Первый вопрос, не продвигаем шаг
    };
  }

  // ТЕХНИЧЕСКИЙ ФИЛЬТР КАЧЕСТВА ОТВЕТА (до вызова валидатора)
  const rawUserContent = String(lastUserMessage.content ?? '').trim();
  const lettersOnly = rawUserContent.replace(/[^a-zA-ZА-Яа-яЁё]/g, '');

  const isTooShort = rawUserContent.length < 15;
  const hasFewLetters = lettersOnly.length < 5;

  if (isTooShort || hasFewLetters) {
    // Ответ слишком короткий/мусорный — мягко просим уточнить, не продвигаем шаг
    const fallbackValidation = {
      feedback_short: "Пока ответ очень короткий, давай добавим чуть больше деталей.",
      missing_points: step.criteria,
      example_template: step.exampleTemplate,
      repeat_question: step.question,
    };

    const clarificationMessage = formatClarificationMessage(fallbackValidation, step);

    return {
      isValid: false,
      response: clarificationMessage,
      shouldAdvance: false,
    };
  }

  // ШАГ 2: Validator — проверяем достаточность ответа
  const criteriaText = step.criteria.map((c, i) => `${i + 1}. ${c}`).join('\n');
  
  const validatorPrompt = `${VALIDATOR_PROMPT}

ТЕКУЩИЙ ШАГ: ${step.id}/7
ВОПРОС ВАЛЛИ: "${step.question}"

КРИТЕРИИ ДОСТАТОЧНОСТИ:
${criteriaText}

ОТВЕТ ПОЛЬЗОВАТЕЛЯ:
"${lastUserMessage.content}"

Оцени, достаточен ли ответ для перехода к следующему вопросу.`;

  try {
    const validatorCompletion = await openai.chat.completions.create({
      model,
      messages: [
        { role: "system", content: validatorPrompt },
        { role: "user", content: "Оцени ответ пользователя согласно критериям." }
      ],
      temperature: 0.3,
      max_tokens: 600,
      response_format: { type: "json_object" },
    });

    const rawValidation = validatorCompletion.choices[0].message.content || "{}";
    const validationResult = JSON.parse(rawValidation);
    
    // Логируем usage и стоимость для валидатора
    const validatorUsage = validatorCompletion.usage;
    const validatorCost = calculateCost(validatorUsage, model);
    await saveAIMessageData(
      userId,
      chatId,
      validationId,
      validatorUsage,
      validatorCost,
      model,
      'valli_validator',
      supabaseAdmin
    );

    if (validationResult.is_sufficient === true) {
      // Ответ достаточен → продвигаем шаг, возвращаем generator-ответ
      return {
        isValid: true,
        response: generatorResponse,
        shouldAdvance: true
      };
    } else {
      // Ответ недостаточен → НЕ продвигаем шаг, возвращаем уточняющее сообщение
      const clarificationMessage = formatClarificationMessage(validationResult, step);
      return {
        isValid: false,
        response: clarificationMessage,
        shouldAdvance: false
      };
    }
  } catch (validatorError) {
    // Fail-safe: при ошибке валидатора НЕ продвигаем шаг
    console.error('ERR validator_failed', { message: String(validatorError).slice(0, 200), step: currentStep });
    
    // Возвращаем стандартное уточнение
    return {
      isValid: false,
      response: `Хм, не совсем понял твой ответ. Попробуй ответить более развёрнуто, чтобы я мог лучше оценить идею.\n\n${step.exampleTemplate}\n\n${step.question}`,
      shouldAdvance: false
    };
  }
}

/**
 * Slot Filling валидация ответа пользователя (НОВАЯ АРХИТЕКТУРА)
 * Вместо инкрементального шага анализирует всю картину и обновляет слоты
 */
async function validateUserResponseSlotFilling(
  openai: any,
  messages: any[],
  validationId: string | null,
  userId: string,
  chatId: string | null,
  supabaseAdmin: any
): Promise<{ 
  response: string; 
  newStep: number; 
  slotsState: SlotsState;
  retryCount: number;
  isComplete?: boolean;
}> {
  const model = "grok-2-latest";

  // 1. Загружаем текущий стейт из БД
  let currentSlotsState: SlotsState = createDefaultSlotsState();
  let currentStep = 1;
  let retryCount = 0;
  
  if (validationId) {
    try {
      const { data: validation, error: validationError } = await supabaseAdmin
        .from('idea_validations')
        .select('slots_state, current_step, retry_count')
        .eq('id', validationId)
        .eq('user_id', userId)
        .single();
      
      if (validationError) {
        console.error('ERR get_validation_state', { message: validationError.message });
      } else if (validation) {
        currentStep = validation.current_step || 1;
        retryCount = validation.retry_count || 0;
        
        // Парсим slots_state из БД (может быть пустым объектом)
        if (validation.slots_state && typeof validation.slots_state === 'object') {
          const savedSlots = validation.slots_state as any;
          
          // Мержим с дефолтным состоянием (на случай если в БД не все слоты)
          if (savedSlots.slots) {
            currentSlotsState = {
              ...currentSlotsState,
              slots: {
                ...currentSlotsState.slots,
                ...savedSlots.slots,
              },
              metadata: savedSlots.metadata || currentSlotsState.metadata,
            };
          }
        }
      }
    } catch (e) {
      console.error('ERR load_slots_state', { message: String(e).slice(0, 200) });
    }
  }

  // 2. Получаем последнее сообщение пользователя
  const lastUserMessage = messages
    .slice()
    .reverse()
    .find((m: any) => m.role === 'user');

  if (!lastUserMessage) {
    // Если нет ответа пользователя (первое сообщение), возвращаем приветствие
    const step = VALIDATION_STEPS.find(s => s.id === currentStep);
    return {
      response: step?.question || "Привет! Расскажи о своей идее. Что ты создаёшь?",
      newStep: currentStep,
      slotsState: currentSlotsState,
      retryCount: 0,
      isComplete: false,
    };
  }

  // 3. ТЕХНИЧЕСКИЙ ФИЛЬТР КАЧЕСТВА ОТВЕТА
  const rawUserContent = String(lastUserMessage.content ?? '').trim();
  const lettersOnly = rawUserContent.replace(/[^a-zA-ZА-Яа-яЁё]/g, '');

  const isTooShort = rawUserContent.length < 15;
  const hasFewLetters = lettersOnly.length < 5;

  if (isTooShort || hasFewLetters) {
    // FIX: Увеличиваем счётчик даже на мусорных ответах, чтобы не держать юзера вечно
    const newRetryCount = retryCount + 1;

    // Ищем первый незаполненный слот для релевантной подсказки
    let targetSlotKey = SLOT_KEYS[currentStep - 1]; // Fallback на текущий шаг

    if (currentSlotsState && currentSlotsState.slots) {
      const firstUnfinished = SLOT_KEYS.find(key => {
        const slot = currentSlotsState.slots[key];
        return slot.status !== 'filled' && slot.status !== 'skipped_by_retry';
      });

      if (firstUnfinished) {
        targetSlotKey = firstUnfinished;
      }
    }

    // Если пользователь уже несколько раз отвечает мусором — применяем soft-skip прямо здесь
    if (newRetryCount >= 2) {
      const now = new Date().toISOString();

      // Определяем текущий слот по шагу
      const currentSlotKey =
        getSlotKeyByStep(currentStep) || (targetSlotKey as keyof SlotsState['slots']);

      let updatedSlotsState = currentSlotsState;
      let nextStep = currentStep;

      if (currentSlotKey) {
        updatedSlotsState = {
          ...currentSlotsState,
          slots: {
            ...currentSlotsState.slots,
            [currentSlotKey]: {
              ...currentSlotsState.slots[currentSlotKey],
              status: 'skipped_by_retry',
              feedback:
                'Слот пропущен из-за множественных попыток уточнения. Рекомендуется вернуться позже.',
              updated_at: now,
            },
          },
          metadata: {
            ...currentSlotsState.metadata,
            last_updated: now,
            forced_slots: Array.from(
              new Set([
                ...currentSlotsState.metadata.forced_slots,
                String(currentSlotKey),
              ]),
            ),
          },
        };

        // Двигаем шаг вперёд (до 8, где 8 = все слоты пройдены логически,
        // но в БД храним максимум 7 из-за CHECK-constraint)
        nextStep = Math.min(8, currentStep + 1);
      }

      const isComplete = nextStep >= 8;

      // Сохраняем в БД: помеченный слот, новый шаг (с ограничением по CHECK) и сброшенный retry_count
      if (validationId) {
        try {
          const dbStep = Math.min(nextStep, MAX_STEPS);
          await supabaseAdmin
            .from('idea_validations')
            .update({
              slots_state: updatedSlotsState,
              current_step: dbStep,
              retry_count: 0,
            })
            .eq('id', validationId)
            .eq('user_id', userId);

          console.log('INFO soft_validation_short_answer', {
            validationId,
            currentStep,
            nextStep,
            slotKey: currentSlotKey,
            retryCount: newRetryCount,
          });
        } catch (updateError) {
          console.error('ERR update_short_answer_soft_skip', {
            message: String(updateError).slice(0, 200),
            validationId,
          });
        }
      }

      let responseText: string;
      if (isComplete) {
        responseText =
          'Вижу, что с этим вопросом сейчас сложно. Давай перейдём к анализу твоих ответов.';
      } else {
        const nextStepConfig = VALIDATION_STEPS.find(s => s.id === nextStep);
        responseText = `Вижу, что с этим вопросом сейчас сложно. Давай пока пойдём дальше.\n\n${
          nextStepConfig?.question || ''
        }`;
      }

      return {
        response: responseText,
        newStep: Math.min(nextStep, MAX_STEPS), // Ограничиваем для БД
        slotsState: updatedSlotsState,
        retryCount: 0,
        isComplete, // Определяется по логическому nextStep >= 8
      };
    }

    // Иначе (первые 1–2 мусорных ответа) — просто подсказка по релевантному слоту
    if (validationId) {
      await supabaseAdmin
        .from('idea_validations')
        .update({ retry_count: newRetryCount })
        .eq('id', validationId)
        .eq('user_id', userId);
    }

    // Находим индекс шага для получения релевантного шаблона
    const targetStepIndex = SLOT_KEYS.indexOf(targetSlotKey);
    const step =
      VALIDATION_STEPS[targetStepIndex] ||
      VALIDATION_STEPS.find(s => s.id === currentStep);

    // Генерируем персонализированный пример на основе уже заполненных слотов
    const personalizedHint = await generatePersonalizedHint(
      openai,
      targetSlotKey as keyof SlotsState['slots'],
      currentSlotsState,
      step,
      model
    );

    return {
      response: `Пока ответ очень короткий, давай добавим чуть больше деталей.\n\n${
        personalizedHint || ''
      }\n\n${step?.question || 'Расскажи подробнее.'}`,
      newStep: currentStep,
      slotsState: currentSlotsState,
      retryCount: newRetryCount,
      isComplete: false,
    };
  }

  // 4. Формируем контекст для Slot Filling валидатора
  const conversationHistory = messages
    .map((m: any) => `${m.role === 'user' ? 'Пользователь' : 'Валли'}: ${m.content}`)
    .join('\n\n');

  const currentSlotsJson = JSON.stringify(currentSlotsState.slots, null, 2);

  const slotFillingPrompt = `${SLOT_FILLING_VALIDATOR_PROMPT}

ТЕКУЩЕЕ СОСТОЯНИЕ СЛОТОВ:
${currentSlotsJson}

ИСТОРИЯ ДИАЛОГА:
${conversationHistory}

ПОСЛЕДНИЙ ОТВЕТ ПОЛЬЗОВАТЕЛЯ:
"${lastUserMessage.content}"

Проанализируй ответ пользователя и обнови состояние слотов.`;

  // 5. Вызываем LLM для Slot Filling анализа
  try {
    const slotFillingCompletion = await openai.chat.completions.create({
      model,
      messages: [
        { role: "system", content: slotFillingPrompt },
        { role: "user", content: "Проанализируй ответ и верни обновлённое состояние слотов в формате JSON." }
      ],
      temperature: 0.3,
      max_tokens: 1500,
      response_format: { type: "json_object" },
    });

    const rawResponse = slotFillingCompletion.choices[0].message.content || "{}";
    
    // Логируем usage и стоимость
    const usage = slotFillingCompletion.usage;
    const cost = calculateCost(usage, model);
    await saveAIMessageData(
      userId,
      chatId,
      validationId,
      usage,
      cost,
      model,
      'valli_slot_filling',
      supabaseAdmin
    );

    // 6. Безопасный парсинг ответа
    const slotFillingResult = safeParseSlotFillingResponse(rawResponse);
    
    if (!slotFillingResult) {
      // Fallback: если парсинг провалился, используем персонализированную подсказку
      console.error('ERR slot_filling_parse_failed', { validationId, currentStep });
      const step = VALIDATION_STEPS.find(s => s.id === currentStep);
      const currentSlotKey = getSlotKeyByStep(currentStep);
      
      const personalizedHint = await generatePersonalizedHint(
        openai,
        currentSlotKey || 'product',
        currentSlotsState,
        step,
        model
      );
      
      return {
        response: `Хм, не совсем понял твой ответ. Попробуй ответить более развёрнуто.\n\n${personalizedHint}\n\n${step?.question || 'Расскажи подробнее.'}`,
        newStep: currentStep,
        slotsState: currentSlotsState,
        retryCount: retryCount + 1,
        isComplete: false,
      };
    }

    // 7. Мержим слоты
    const mergedSlotsState = mergeSlots(currentSlotsState, slotFillingResult.updated_slots);

    // 8. Применяем Soft Validation (форсированное продвижение после 2 попыток)
    // Сохраняем исходный suggested_step_index для определения isComplete
    const originalSuggestedStep = slotFillingResult.suggested_step_index;
    // Ограничиваем suggested_step_index для вычисления nextStep
    let suggestedStepIndex = Math.min(originalSuggestedStep, MAX_STEPS);
    let newRetryCount = 0;

    if (retryCount >= 2 && suggestedStepIndex === currentStep) {
      // Форсируем переход, помечая текущий слот как 'skipped_by_retry'
      const currentSlotKey = getSlotKeyByStep(currentStep);
      
      if (currentSlotKey) {
        mergedSlotsState.slots[currentSlotKey] = {
          ...mergedSlotsState.slots[currentSlotKey],
          status: 'skipped_by_retry',
          feedback: 'Слот пропущен из-за множественных попыток уточнения. Рекомендуется вернуться позже.',
          updated_at: new Date().toISOString(),
        };
        
        mergedSlotsState.metadata.forced_slots.push(currentSlotKey);
        
        // Искусственно двигаем шаг вперёд (но не больше MAX_STEPS для БД)
        suggestedStepIndex = Math.min(currentStep + 1, MAX_STEPS);
        
        console.log('INFO soft_validation_triggered', { 
          validationId, 
          currentStep, 
          slotKey: currentSlotKey,
          retryCount 
        });
      }
    }

    // 9. Вычисляем новый шаг (не позволяем откатываться назад, но ограничиваем MAX_STEPS)
    const nextStep = Math.min(Math.max(currentStep, suggestedStepIndex), MAX_STEPS);
    
    // Определяем isComplete по исходному suggested_step_index (до ограничения)
    // Если LLM вернул 8+, значит все слоты заполнены
    const isComplete = originalSuggestedStep >= 8;
    
    // Сбрасываем retry_count если шаг изменился
    if (nextStep > currentStep) {
      newRetryCount = 0;
    } else {
      newRetryCount = retryCount + 1;
    }

    // 10. Сохраняем обновлённое состояние в БД (с ограничением шага по CHECK-constraint)
    if (validationId) {
      try {
        const dbStep = Math.min(nextStep, MAX_STEPS);
        await supabaseAdmin
          .from('idea_validations')
          .update({
            slots_state: mergedSlotsState,
            current_step: dbStep,
            retry_count: newRetryCount,
          })
          .eq('id', validationId)
          .eq('user_id', userId);
        
        console.log('INFO slots_state_updated', { 
          validationId, 
          oldStep: currentStep, 
          newStep: nextStep,
          dbStep, // Шаг, сохранённый в БД (ограничен MAX_STEPS)
          isComplete,
          retryCount: newRetryCount 
        });
      } catch (updateError) {
        console.error('ERR update_slots_state', { 
          message: String(updateError).slice(0, 200),
          validationId 
        });
      }
    }

    return {
      response: slotFillingResult.bot_response_text,
      newStep: nextStep, // Ограничен MAX_STEPS для БД
      slotsState: mergedSlotsState,
      retryCount: newRetryCount,
      isComplete, // Определяется по originalSuggestedStep >= 8
    };

  } catch (slotFillingError) {
    // Fail-safe: при ошибке LLM используем fallback
    console.error('ERR slot_filling_failed', { 
      message: String(slotFillingError).slice(0, 200),
      validationId,
      currentStep 
    });
    
    const step = VALIDATION_STEPS.find(s => s.id === currentStep);
    return {
      response: `Хм, не совсем понял твой ответ. Попробуй ответить более развёрнуто.\n\n${step?.exampleTemplate || ''}\n\n${step?.question || 'Расскажи подробнее.'}`,
      newStep: currentStep,
      slotsState: currentSlotsState,
      retryCount: retryCount + 1,
      isComplete: false,
    };
  }
}

function getArchetypeDescription(archetype: string): string {
  const descriptions = {
    'МЕЧТАТЕЛЬ': 'Идея пока в голове — давай приземлим её на реальность',
    'ИССЛЕДОВАТЕЛЬ': 'Есть гипотезы, но мало доказательств. Время поговорить с клиентами',
    'СТРОИТЕЛЬ': 'Понимание есть, нужна система. Можно переходить к MVP',
    'ГОТОВ К ЗАПУСКУ': 'Фундамент крепкий. Время тестировать на реальных клиентах',
    'VALIDATED': 'У тебя уже есть первые продажи — масштабируй!'
  };
  return descriptions[archetype] || descriptions['МЕЧТАТЕЛЬ'];
}

function generateReport(scoringResult: any): string {
  const { total, archetype, strengths, red_flags, one_thing, recommended_levels } = scoringResult;

  let report = `━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 **ТВОЙ РЕЗУЛЬТАТ: ${total}/100**

🔍 Архетип: **${archetype}**

"${getArchetypeDescription(archetype)}"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ **ЧТО УЖЕ ХОРОШО**
`;

  if (Array.isArray(strengths) && strengths.length > 0) {
    report += '\n';
    strengths.forEach((strength: string) => {
      report += `- ${strength}\n`;
    });
  } else {
    report += '\n- (пока без явных сильных сторон — это тоже результат)\n';
  }

  report += `
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🚩 **КРАСНЫЕ ФЛАГИ** (вопросы без ответа)
`;

  if (Array.isArray(red_flags) && red_flags.length > 0) {
    report += '\n';
    red_flags.forEach((flag: string) => {
      report += `- ${flag}\n`;
    });
  } else {
    report += '\n- Явных красных флагов нет, но продолжай проверять гипотезы.\n';
  }

  report += `
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📚 **ЧТО ИЗУЧИТЬ В BIZLEVEL**
`;

  if (recommended_levels && recommended_levels.length > 0) {
    report += '\n';
    recommended_levels.forEach((level: any) => {
      report += `- **Уровень ${level.level_number}: ${level.name || 'Урок'}** — ${level.reason}\n`;
    });
  } else {
    report += '\n- Пока нет конкретных рекомендаций — продолжай валидацию!\n';
  }

  report += `
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 **ONE THING: Твоё действие на эту неделю**

${one_thing}

Это поднимет твой балл валидации на +10-15 пунктов по шкале 0-100.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`;

  return report;
}

// Маппинг критериев → уровни BizLevel
function getRecommendedLevels(scores: any): any[] {
  const recommendations: any[] = [];
  
  const criteriaMapping = {
    problem: { level_id: 8, level_number: 8, name: 'Блиц-опрос клиентов', reason: 'поможет проверить, реальна ли боль' },
    customer: { level_id: 5, level_number: 5, name: 'Создание УТП', reason: 'поможет определить целевую аудиторию' },
    validation: { level_id: 8, level_number: 8, name: 'Блиц-опрос', reason: 'поможет проверить гипотезы' },
    unique: { level_id: 6, level_number: 6, name: 'Elevator Pitch', reason: 'поможет выделить уникальность' },
    action: { level_id: 7, level_number: 7, name: 'SMART-планирование', reason: 'поможет составить план действий' }
  };

  // Находим 2 самых слабых критерия
  const sortedScores = Object.entries(scores.scores || {})
    .sort((a: any, b: any) => a[1] - b[1])
    .slice(0, 2);

  sortedScores.forEach(([criterion, _]: any) => {
    if (criteriaMapping[criterion]) {
      recommendations.push(criteriaMapping[criterion]);
    }
  });

  return recommendations;
}

/**
 * Подготовка структурированного контекста для Макса на основе SlotsState и итогового score
 */
function prepareContextForMax(slotsState: SlotsState | null, score: number | null): any | null {
  if (!slotsState || !slotsState.slots) {
    return null;
  }

  const safeScore = typeof score === 'number' && isFinite(score) ? score : 0;

  // 1. Собираем краткую структурированную выжимку по заполненным слотам
  const summaryLines: string[] = [];

  for (const [key, slot] of Object.entries(slotsState.slots)) {
    if (!slot) continue;
    if (slot.status === 'filled' || slot.status === 'partial') {
      const title = key.toUpperCase();
      const content = (slot as SlotData).content || '';
      if (content.trim().length > 0) {
        summaryLines.push(`${title}: ${content}`);
      }
    }
  }

  const structuredSummary = summaryLines.join('\n');

  // 2. Собираем слабые места: partial или принудительно пропущенные (skipped_by_retry)
  const forcedSlots = new Set<string>((slotsState.metadata?.forced_slots || []).map(String));
  const weakSpots: Array<{
    topic: string;
    issue: string;
    is_forced: boolean;
  }> = [];

  for (const [key, slot] of Object.entries(slotsState.slots)) {
    if (!slot) continue;
    const s = slot as SlotData;
    const isForced = s.status === 'skipped_by_retry' || forcedSlots.has(key);

    if (s.status === 'partial' || isForced) {
      weakSpots.push({
        topic: key,
        issue: s.feedback || (isForced ? 'Пропущено (soft validation)' : 'Хочется больше конкретики по этому пункту'),
        is_forced: isForced,
      });
    }
  }

  return {
    source: 'validator_wally_v2',
    validation_score: safeScore,
    structured_summary: structuredSummary,
    weak_spots: weakSpots,
    has_blind_spots: weakSpots.length > 0,
  };
}

// ============================
// Helper Functions
// ============================

/**
 * Определяет стоимость валидации для пользователя
 * @param userId ID пользователя
 * @param supabaseAdmin Admin клиент Supabase
 * @returns Объект с ценой и флагом бесплатности
 */
async function getValidationPrice(
  userId: string,
  supabaseAdmin: any
): Promise<{ price: number; isFree: boolean }> {
  const { count, error: countError } = await supabaseAdmin
    .from('idea_validations')
    .select('*', { count: 'exact', head: true })
    .eq('user_id', userId)
    .eq('status', 'completed');

  if (countError) {
    console.error('ERR get_validation_price', { message: countError.message });
    // В случае ошибки считаем платным (безопаснее)
    return { price: VALIDATION_COST_GP, isFree: false };
  }

  const isFree = (count || 0) === 0;
  return {
    price: isFree ? 0 : VALIDATION_COST_GP,
    isFree,
  };
}

// ============================
// Main Handler
// ============================
serve(async (req) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // Environment validation
    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
    const supabaseAnonKey = Deno.env.get("SUPABASE_ANON_KEY");
    const xaiApiKey = Deno.env.get("XAI_API_KEY");

    if (!supabaseUrl || !supabaseServiceKey || !supabaseAnonKey || !xaiApiKey) {
      throw new Error("Missing required environment variables");
    }

    // Initialize Supabase client
    const supabaseAdmin = createClient(supabaseUrl, supabaseServiceKey);

    // Parse request body
    const body = await req.json();
    const { messages, validationId, mode = 'dialog', action } = body;

    if (!Array.isArray(messages) || messages.length === 0) {
      return new Response(
        JSON.stringify({ error: "Messages array is required" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Authenticate user
    const authHeader = req.headers.get("x-user-jwt") || req.headers.get("authorization")?.replace("Bearer ", "");
    if (!authHeader) {
      return new Response(
        JSON.stringify({ error: "Missing authentication" }),
        { status: 401, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const { data: { user }, error: authError } = await supabaseAdmin.auth.getUser(authHeader);
    if (authError || !user) {
      return new Response(
        JSON.stringify({ error: "Authentication failed" }),
        { status: 401, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const userId = user.id;

    // Попробуем привязать валидацию к существующему leo-чату (idea_validations.chat_id)
    let chatId: string | null = null;
    if (validationId) {
      try {
        const { data: validationRow, error: chatErr } = await supabaseAdmin
          .from('idea_validations')
          .select('chat_id')
          .eq('id', validationId)
          .eq('user_id', userId)
          .single();

        if (chatErr) {
          console.error('ERR get_validation_chat_id', { message: chatErr.message, validationId, userId });
        } else if (validationRow?.chat_id) {
          chatId = String(validationRow.chat_id);
        } else {
          console.warn('WARN validation_chat_id_missing', { validationId, userId });
        }
      } catch (e) {
        console.error('ERR get_validation_chat_id_exception', { message: String(e).slice(0, 200), validationId, userId });
      }
    }

    // Create user-authenticated client for GP operations (uses anon key + user JWT)
    const supabaseUser = createClient(supabaseUrl, supabaseAnonKey, {
      global: {
        headers: {
          Authorization: `Bearer ${authHeader}`,
        },
      },
    });

    // ============================
    // Определяем текущий шаг валидации
    // ============================
    let currentStep = 1; // По умолчанию Step 1
    if (mode === 'dialog' && validationId) {
      try {
        const { data: validation, error: stepError } = await supabaseAdmin
          .from('idea_validations')
          .select('current_step')
          .eq('id', validationId)
          .eq('user_id', userId)
          .single();

        if (!stepError && validation?.current_step !== null && validation?.current_step !== undefined) {
          currentStep = validation.current_step;
        }
      } catch (e) {
        console.error('ERR get_current_step', { message: String(e).slice(0, 200) });
      }
    } else if (mode === 'dialog' && !validationId) {
      // Если нет validationId, значит это новый диалог - начинаем с Step 0
      currentStep = 0;
    }

    // ============================
    // GP Economy: Check if payment required
    // ============================
    // Списываем GP только при переходе на Step 1 (action === 'start_validation')
    // На Step 0 общение бесплатное
    if (mode === 'dialog' && action === 'start_validation') {
      const pricing = await getValidationPrice(userId, supabaseAdmin);
      
      if (!pricing.isFree) {
        // Списываем GP (gp_spend сама проверит баланс и вернет ошибку, если недостаточно)
        try {
          const { data: spendResult, error: spendError } = await supabaseUser
            .rpc('gp_spend', {
              p_type: 'spend_message',
              p_amount: VALIDATION_COST_GP,
              p_reference_id: validationId || '',
              p_idempotency_key: validationId ? `validation_${validationId}` : `validation_${userId}_${Date.now()}`,
            });

          if (spendError) {
            console.error('ERR gp_spend', { message: spendError.message });
            
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
            
            throw spendError;
          }

          console.log('INFO gp_spent_on_start', { amount: VALIDATION_COST_GP, validationId, balance_after: spendResult });

          // Отмечаем списание в валидации
          if (validationId) {
            await supabaseAdmin
              .from('idea_validations')
              .update({ gp_spent: VALIDATION_COST_GP, current_step: 1 })
              .eq('id', validationId)
              .eq('user_id', userId);
          }
        } catch (gpError) {
          console.error('ERR gp_spend_exception', { message: String(gpError).slice(0, 200) });
          return new Response(
            JSON.stringify({
              error: "gp_error",
              message: "Ошибка списания GP. Попробуйте позже."
            }),
            { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
          );
        }
      } else {
        console.log('INFO first_validation_free', { userId });
        
        // Обновляем шаг на 1 для бесплатной валидации
        if (validationId) {
          await supabaseAdmin
            .from('idea_validations')
            .update({ current_step: 1 })
            .eq('id', validationId)
            .eq('user_id', userId);
        }
      }
      
      // После списания GP переходим на Step 1
      currentStep = 1;
    }

    // Initialize OpenAI client (using xAI)
    const openai = new OpenAI({
      apiKey: xaiApiKey,
      baseURL: "https://api.x.ai/v1",
    });

    // Mode: DIALOG (default)
    if (mode === 'dialog') {
      // Step 0: Онбординг - бесплатное общение без списания GP
      // НО если action === 'start_validation', то currentStep уже обновлен на 1 выше
      if (currentStep === 0 && action !== 'start_validation') {
        // Определяем цену для метаданных кнопок
        const pricing = await getValidationPrice(userId, supabaseAdmin);
        
        // Генерируем ответ через обычный LLM вызов с ONBOARDING_SYSTEM_PROMPT
        const onboardingCompletion = await openai.chat.completions.create({
          model: "grok-2-latest",
          messages: [
            { role: "system", content: ONBOARDING_SYSTEM_PROMPT },
            ...messages
          ],
          temperature: 0.7,
          max_tokens: 300,
        });

        const botResponse = onboardingCompletion.choices[0].message.content;

        // Логируем usage (но не списываем GP)
        const usage = onboardingCompletion.usage;
        const cost = calculateCost(usage, "grok-2-latest");
        await saveAIMessageData(
          userId,
          chatId,
          validationId,
          usage,
          cost,
          "grok-2-latest",
          'valli_onboarding',
          supabaseAdmin
        );

        // Возвращаем ответ с метаданными для кнопок онбординга
        return new Response(
          JSON.stringify({
            message: { role: "assistant", content: botResponse },
            metadata: {
              current_step: 0,
              onboarding: {
                price: pricing.price,
                is_free: pricing.isFree,
                actions: [
                  {
                    id: 'start_validation',
                    label: pricing.isFree 
                      ? 'Начать проверку (Бесплатно)' 
                      : `Начать проверку (${pricing.price} GP)`,
                    is_primary: true
                  },
                  {
                    id: 'ask_about',
                    label: 'А что ты умеешь?',
                    is_primary: false
                  }
                ]
              }
            }
          }),
          { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } }
        );
      }

      // Step 1-7: Используем архитектуру Slot Filling
      const slotFillingResult = await validateUserResponseSlotFilling(
        openai,
        messages,
        validationId,
        userId,
        chatId,
        supabaseAdmin
      );

      // Проверяем завершение диалога (все слоты заполнены)
      const isComplete = slotFillingResult.isComplete || false;
      
      if (isComplete) {
        console.log('INFO validation_complete', { 
          validationId, 
          finalStep: slotFillingResult.newStep 
        });
      }

      return new Response(
        JSON.stringify({
          message: { role: "assistant", content: slotFillingResult.response },
          metadata: {
            current_step: slotFillingResult.newStep,
            retry_count: slotFillingResult.retryCount,
            is_complete: isComplete,
            slots_state: slotFillingResult.slotsState, // Возвращаем для отладки/UI
          }
        }),
        { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Mode: SCORE
    if (mode === 'score') {
      // Extract conversation text
      const conversationText = messages
        .map((m: any) => `${m.role}: ${m.content}`)
        .join('\n\n');

      const model = "grok-2-latest";
      const completion = await openai.chat.completions.create({
        model,
        messages: [
          { role: "system", content: SCORING_PROMPT },
          { role: "user", content: `Оцени эту беседу:\n\n${conversationText}` }
        ],
        temperature: 0.3,
        max_tokens: 1000,
        response_format: { type: "json_object" },
      });

      // Логируем usage и стоимость для scoring
      const scoringUsage = completion.usage;
      const scoringCost = calculateCost(scoringUsage, model);
      await saveAIMessageData(
        userId,
        chatId,
        validationId,
        scoringUsage,
        scoringCost,
        model,
        'valli_scoring',
        supabaseAdmin
      );

      let scoringResult;
      try {
        const rawContent = completion.choices[0].message.content || "{}";
        scoringResult = JSON.parse(rawContent);
      } catch (parseError) {
        console.error("Failed to parse scoring result:", parseError);
        return new Response(
          JSON.stringify({ error: "Failed to parse scoring result" }),
          { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
        );
      }

      // Add recommended levels
      scoringResult.recommended_levels = getRecommendedLevels(scoringResult);

      // Generate report
      const report = generateReport(scoringResult);

       // Подготовим контекст для Макса на основе slots_state (если есть)
       let maxContext: any | null = null;
       if (validationId) {
         try {
           const { data: validationForContext, error: contextError } = await supabaseAdmin
             .from('idea_validations')
             .select('slots_state')
             .eq('id', validationId)
             .eq('user_id', userId)
             .single();

           if (contextError) {
             console.error('ERR load_slots_state_for_max', { message: contextError.message, validationId, userId });
           } else if (validationForContext?.slots_state) {
             maxContext = prepareContextForMax(validationForContext.slots_state as SlotsState, scoringResult.total);
           }
         } catch (e) {
           console.error('ERR prepare_max_context', { message: String(e).slice(0, 200), validationId, userId });
         }
       }

      // Save to database if validationId provided
      if (validationId) {
        // Check if GP was spent (not first validation)
        const { count } = await supabaseAdmin
          .from('idea_validations')
          .select('*', { count: 'exact', head: true })
          .eq('user_id', userId)
          .eq('status', 'completed');
        
        const gpSpent = (count || 0) > 0 ? VALIDATION_COST_GP : 0;

        await supabaseAdmin
          .from('idea_validations')
          .update({
            scores: scoringResult.scores,
            total_score: scoringResult.total,
            archetype: scoringResult.archetype,
            report_markdown: report,
            one_thing: scoringResult.one_thing,
            recommended_levels: scoringResult.recommended_levels,
            status: 'completed',
            completed_at: new Date().toISOString(),
            gp_spent: gpSpent,
          })
          .eq('id', validationId)
          .eq('user_id', userId);
      }

      return new Response(
        JSON.stringify({
          scores: scoringResult,
          report: report,
          max_context: maxContext,
        }),
        { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Invalid mode
    return new Response(
      JSON.stringify({ error: "Invalid mode. Use 'dialog' or 'score'" }),
      { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );

  } catch (error) {
    console.error("Error in val-chat:", error);
    return new Response(
      JSON.stringify({ error: error.message || "Internal server error" }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
