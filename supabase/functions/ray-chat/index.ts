/// <reference types="https://deno.land/x/deno@1.36.1/lib.deno.d.ts" />

import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { serve } from "https://deno.land/std@0.192.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.7.0";
import OpenAI from "https://deno.land/x/openai@v4.20.1/mod.ts";
import { z } from "https://deno.land/x/zod@v3.23.8/mod.ts";

// ============================
// CORS Headers
// ============================
const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, x-user-jwt, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

// ============================
// CONFIG: PROMPTS & MODELS
// ============================
const SYSTEM_PROMPT = `Ты Рэй (Ray) — AI-валидатор идей школы бизнеса BizLevel.

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
Прямота + Эмпатия + Конкретика

СТИЛЬ ОБЩЕНИЯ:
- Дружелюбный, понятный, корректный, но профессиональный
- НЕ используй уличный сленг ("бро", "бабло", "поднять бабла", "свинья с крыльями" и т.д.)
- НЕ используй жаргон, который может быть непонятен
- Говори простым, но деловым языком
- Более 90% пользователей НЕ связаны с программированием/кодингом — НЕ упоминай кодинг, разработку, программирование, если это не критично для идеи пользователя`;

// Промпт для валидатора ответа пользователя
const VALIDATOR_PROMPT = `Ты строгий, но доброжелательный валидатор ответов пользователя на вопросы Рэя.

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
    // ... остальные слоты, которые были затронуты в ответе пользователя
  },
  "suggested_step_index": 3,
  "bot_response_text": "Текст ответа Рэя пользователю (короткий, эмпатичный, 2-4 предложения)"
}

ВАЖНО:
- Возвращай ТОЛЬКО JSON, без дополнительного текста
- В 'updated_slots' включай ТОЛЬКО те слоты, которые были затронуты в ответе пользователя
- 'suggested_step_index' должен указывать на следующий приоритетный слот (1-7) или 8 если все заполнены
- 'bot_response_text' должен быть мягким, поддерживающим, с одним конкретным вопросом
- ЕСЛИ suggested_step_index == 8 (все слоты заполнены), то bot_response_text должен быть финальным сообщением:
  "Отлично! Я записал все твои ответы. Готов проанализировать идею и показать результат?"
  (БЕЗ нового вопроса)


СТИЛЬ ОБЩЕНИЯ:
- Дружелюбный, понятный, корректный, но профессиональный
- НЕ используй уличный сленг ("бро", "бабло", "поднять бабла", "свинья с крыльями" и т.д.)
- НЕ используй жаргон, который может быть непонятен
- Говори простым, но деловым языком
- Более 90% пользователей НЕ связаны с программированием/кодингом — НЕ упоминай кодинг, разработку, программирование, если это не критично для идеи пользователя

ПОСЛЕДОВАТЕЛЬНОСТЬ ВОПРОСОВ (ОБЯЗАТЕЛЬНО ВСЕ 7):
1. product — Суть идеи (что создаётся?)
2. problem — Проблема (какую боль решаешь?)
3. audience — Целевая аудитория (для кого конкретно?)
4. validation — Валидация (откуда знаешь о проблеме?)
5. competitors — Конкуренты (как решают сейчас?)
6. utp — Уникальное преимущество (почему ты?)
7. risks — Риски (что может убить идею?)
- НЕ пропускай вопросы! Задавай ВСЕ 7 вопросов последовательно. Если пользователь упомянул информацию в других слотах, напиши (давай уточним)`;

// ============================
// TYPES & DOMAIN MODELS
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
const ONBOARDING_SYSTEM_PROMPT = `Ты — Рэй (Ray), специализированный AI-валидатор бизнес-идей.

ТВОЯ ЦЕЛЬ: Познакомиться с пользователем, объяснить ценность валидации и мотивировать его начать проверку идеи.

ТВОИ ПРАВИЛА:
1. Твоя компетенция СТРОГО ограничена стартапами, бизнес-моделями и валидацией идей.
2. ЕСЛИ пользователь просит написать код, рецепт, эссе, решить математику или просто поболтать о погоде — ВЕЖЛИВО ОТКАЖИ.
   - Пример отказа: "Я бы с радостью поболтал о погоде, но мои нейроны заточены только под разбор бизнес-идей. Давай лучше обсудим твой будущий единорог?"
   - Пример отказа 2: "Прости, но я не умею писать код. Зато я отлично умею находить дыры в бизнес-планах. Есть идеи?"
3. Отвечай коротко, с юмором, но профессионально (не "свой парень", а дружелюбный коллега).

О СЕБЕ:
- Ты задаешь 7 вопросов по Lean Startup.
- Ищешь "слепые зоны" и риски.
- Даешь честный скоринг (0-100).
- Первая проверка — бесплатно, дальше за GP.

ВАРИАТИВНОСТЬ ОТВЕТОВ:
- Чередуй начало: "Ха,", "Окей,", "Понял,", "Ага,", "Слушай,", "О,", "Ну,"
- Меняй концовку: "Готов начать разбор?", "Расскажи о своей идее", "Что задумал?", "Готов начать?", "Расскажи, что планируешь"
- Избегай повторения одной и той же фразы подряд

ВАРИАТИВНОСТЬ ОТВЕТОВ:
- Чередуй начало: "Ха,", "Окей,", "Понял,", "Ага,", "Слушай,", "О,", "Ну,"
- Меняй концовку: "Готов начать разбор?", "Расскажи о своей идее", "Что задумал?", "Готов начать?", "Расскажи, что планируешь"
- Избегай повторения одной и той же фразы подряд

СТИЛЬ ОБЩЕНИЯ:
- Дружелюбный, понятный, но профессиональный
- НЕ используй уличный сленг ("бро", "бабло", "поднять бабла", "свинья с крыльями" и т.д.)
- НЕ используй жаргон, который может быть непонятен
- Говори простым, но деловым языком
- Более 90% пользователей НЕ связаны с программированием/кодингом — НЕ упоминай кодинг, разработку, программирование, если это не критично для идеи пользователя

ВАЖНО:
- Ты НЕ начинаешь валидацию сам. Ты ждешь, пока пользователь нажмет кнопку начала проверки.
- НИКОГДА не упоминай точные названия кнопок (например, "нажми кнопку 'Начать проверку'", "Step 1", и т.д.).
- Вместо этого используй общие фразы: "когда будешь готов начать", "когда нажмешь кнопку начала", "готов начать проверку", "кнопка для старта будет внизу".
- Можешь намекать на начало проверки, но не называй конкретное название кнопки.`;

// ============================
// SLOT FILLING CONFIGURATION
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

// ============================
// CORE TYPES & ERRORS
// ============================

interface ActionResponse {
  message: {
    role: "assistant";
    content: string;
  };
  metadata: {
    current_step: number;
    retry_count?: number;
    is_complete?: boolean;
    slots_state?: SlotsState;
    onboarding?: {
      price: number;
      is_free: boolean;
      actions: Array<{
        id: string;
        label: string;
        is_primary: boolean;
      }>;
    };
    [key: string]: unknown;
  };
}

interface RayContext {
  aiClient: any;
  dbAdmin: any;
  dbUser: any;
  user: {
    id: string;
    jwt: string;
  };
  /**
   * Корреляционный идентификатор для склейки логов (requestId / traceId / correlationId).
   * Может приходить из Supabase или из заголовков запроса.
   */
  correlationId?: string | null;
  validationId: string | null;
  chatId: string | null;
}

class RayError extends Error {
  public readonly code:
    | "insufficient_gp"
    | "gp_error"
    | "validation_not_found"
    | "bad_request";
  public readonly payload?: unknown;

  constructor(code: RayError["code"], message?: string, payload?: unknown) {
    super(message ?? code);
    this.code = code;
    this.payload = payload;
    this.name = "RayError";
  }
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

const CONFIG = {
  MODELS: {
    DEFAULT: 'grok-4-fast-non-reasoning',
    FAST: 'grok-beta',
  },
  PROMPTS: {
    SYSTEM: SYSTEM_PROMPT,
    VALIDATOR: VALIDATOR_PROMPT,
    SLOT_FILLING_VALIDATOR: SLOT_FILLING_VALIDATOR_PROMPT,
    ONBOARDING: ONBOARDING_SYSTEM_PROMPT,
    SCORING: SCORING_PROMPT,
  },
} as const;

// ============================
// VALIDATION LIMITS & THRESHOLDS
// ============================
const VALIDATION_LIMITS = {
  // Минимальные требования к ответу пользователя
  MIN_CHAR_LENGTH: 15,
  MIN_LETTER_COUNT: 5,
  
  // Максимальное количество ретраев перед soft-skip
  MAX_RETRIES: 2,
  
  // Порог confidence для статуса 'filled' слота
  CONFIDENCE_THRESHOLD: 0.7,
  
  // Лимиты токенов для разных типов AI-запросов
  MAX_TOKENS: {
    SLOT_FILLING: 1500,
    SCORING: 2000,
    VALIDATOR: 600,
    GENERATOR: 500,
    ONBOARDING: 300,
    DEFAULT: 512,
    HINT: 200,
  },
  
  // Температура по умолчанию для AI-запросов
  TEMPERATURE_DEFAULT: 0.7,
  
  // Максимальная длина для логирования raw snippets
  LOG_SNIPPET_MAX_LENGTH: 500,
} as const;

// ============================
// CORE HELPERS (Slots, JSON, Scoring)
// ============================

// ============================
// Zod Schemas for LLM JSON Responses
// ============================

// SlotData / SlotsState схемы для безопасного хранения в БД
const SlotDataSchema = z.object({
  content: z.string(),
  status: z.enum(['empty', 'partial', 'filled', 'skipped_by_retry']),
  confidence: z.number().min(0).max(1),
  feedback: z.string(),
  updated_at: z.string(),
});

const SlotsStateSchema = z.object({
  slots: z.object({
    product: SlotDataSchema,
    problem: SlotDataSchema,
    audience: SlotDataSchema,
    validation: SlotDataSchema,
    competitors: SlotDataSchema,
    utp: SlotDataSchema,
    risks: SlotDataSchema,
  }),
  metadata: z.object({
    last_updated: z.string(),
    forced_slots: z.array(z.string()),
  }),
});

const SlotFillingSlotDataSchema = z.object({
  content: z.string().optional().default(""),
  status: z.enum(["empty", "partial", "filled", "skipped_by_retry"]).optional(),
  confidence: z.number().min(0).max(1).optional(),
  feedback: z.string().optional().default(""),
});

const SlotFillingUpdatedSlotsSchema = z.record(
  z.enum(["product", "problem", "audience", "validation", "competitors", "utp", "risks"]),
  SlotFillingSlotDataSchema.partial(),
);

const SlotFillingResponseSchema = z.object({
  updated_slots: SlotFillingUpdatedSlotsSchema.default({}),
  suggested_step_index: z.number().int().min(1).max(8).default(1),
  bot_response_text: z.string().default(""),
});

const ScoringResultSchema = z.object({
  scores: z.object({
    problem: z.number().int(),
    customer: z.number().int(),
    validation: z.number().int(),
    unique: z.number().int(),
    action: z.number().int(),
  }),
  total: z.number().int(),
  archetype: z.enum([
    "МЕЧТАТЕЛЬ",
    "ИССЛЕДОВАТЕЛЬ",
    "СТРОИТЕЛЬ",
    "ГОТОВ К ЗАПУСКУ",
    "VALIDATED",
  ]),
  strengths: z.array(z.string()),
  red_flags: z.array(z.string()),
  one_thing: z.string(),
  recommended_levels: z
    .array(
      z.object({
        level_id: z.number().int(),
        level_number: z.number().int(),
        reason: z.string(),
        name: z.string().optional(),
      }),
    )
    .default([]),
});

const ValidationResponseSchema = z.object({
  is_sufficient: z.boolean(),
  feedback_short: z.string().default(""),
  missing_points: z.array(z.string()).default([]),
  example_template: z.string().default(""),
  repeat_question: z.string().default(""),
});

function validateWithSchema<T>(
  raw: any,
  schema: z.ZodSchema<T>,
  fallback: T,
  context: string,
): T {
  const result = schema.safeParse(raw);
  if (!result.success) {
    console.error("ERR zod_validation_failed", {
      context,
      issues: result.error.issues?.slice(0, 10),
    });
    return fallback;
  }
  return result.data;
}

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
  model: string = CONFIG.MODELS.DEFAULT
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
      temperature: VALIDATION_LIMITS.TEMPERATURE_DEFAULT,
      max_tokens: VALIDATION_LIMITS.MAX_TOKENS.HINT,
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
 * Явно логирует ошибки парсинга (_parseError)
 */
function safeParseSlotFillingResponse(raw: string): any | null {
  try {
    const fallback = SlotFillingResponseSchema.parse({});
    const cleaned = cleanJsonString(raw);
    const parsedJson = JSON.parse(cleaned);
    const result = validateWithSchema(parsedJson, SlotFillingResponseSchema, fallback, "slot_filling_response");
    
    // Проверяем, не был ли установлен _parseError в validateWithSchema (через safeParseJson)
    // Это может произойти, если validateWithSchema использует старый safeParseJson
    if (result && (result as any)._parseError === true) {
      console.warn('WARN slot_filling_parse_error', {
        rawSnippet: (result as any)._rawSnippet || raw.slice(0, 200),
        context: (result as any)._context || 'slot_filling_response',
        message: 'Slot filling JSON parse failed - using fallback',
      });
    }
    
    return result;
  } catch (parseError) {
    console.error('ERR parse_slot_response', { 
      message: String(parseError).slice(0, 200),
      raw: raw.slice(0, 200)
    });
    const errorResult = {
      updated_slots: {},
      suggested_step_index: 1,
      bot_response_text: '',
      _parseError: true,
      _rawSnippet: raw.slice(0, 200),
      _context: 'slot_filling_response',
    };
    
    // Явное логирование ошибки
    console.warn('WARN slot_filling_parse_error_exception', {
      rawSnippet: errorResult._rawSnippet,
      context: errorResult._context,
      message: 'Slot filling JSON parse exception - using fallback',
    });
    
    return errorResult;
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
    // 1. Если новый слот имеет status 'filled' и confidence > CONFIDENCE_THRESHOLD → перезаписываем
    // 2. Если текущий слот пустой → берём новый
    // 3. Если новый confidence выше → обновляем
    // 4. Иначе сохраняем текущий, но обновляем feedback если есть
    
    const shouldOverwrite = 
      currentData.status === 'empty' ||
      (updatedData.status === 'filled' && (updatedData.confidence ?? 0) > VALIDATION_LIMITS.CONFIDENCE_THRESHOLD) ||
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
function calculateCost(usage: any, model: string = CONFIG.MODELS.DEFAULT): number {
  const inputTokens = usage?.prompt_tokens || 0;
  const outputTokens = usage?.completion_tokens || 0;
  let inputCostPer1K = 0.001; // defaults for grok-4-fast-non-reasoning
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

// ============================
// AI SERVICE LAYER
// ============================

type AiTaskType =
  | 'onboarding'
  | 'dialog_generator'
  | 'dialog_validator'
  | 'slot_filling'
  | 'scoring'
  | 'hint';

const AI_TASK_REQUEST_TYPE: Record<AiTaskType, string> = {
  onboarding: 'ray_onboarding',
  dialog_generator: 'ray_generator',
  dialog_validator: 'ray_validator',
  slot_filling: 'ray_slot_filling',
  scoring: 'ray_scoring',
  hint: 'ray_hint',
} as const;

interface AiTaskParams {
  taskType: AiTaskType;
  /**
   * Человекочитаемое описание задачи — помогает в логах и дебаге.
   * Пример: "onboarding dialog before paid validation", "slot_filling v2".
   */
  userHint: string;
  model: string;
  messages: Array<{ role: 'system' | 'user' | 'assistant'; content: string }>;
  temperature?: number;
  maxTokens?: number;
  responseFormat?: { type: 'json_object' | 'text' };
  /**
   * Структура по умолчанию при неудачном JSON-парсинге.
   * safeParseJson всегда вернёт объект (никогда null), пометив _parseError.
   */
  jsonFallback?: any;
}

/**
 * Неубиваемый JSON-парсер:
 * - Никогда не возвращает null
 * - Всегда возвращает объект (fallback или распарсенный)
 * - Помечает ошибки полем _parseError и _rawSnippet
 */
function safeParseJson(
  raw: string,
  fallback: any,
  context: string,
): any {
  try {
    const cleaned = cleanJsonString(raw);
    const parsed = JSON.parse(cleaned);

    if (!parsed || typeof parsed !== 'object') {
      console.error('ERR safe_parse_json_invalid', {
        context,
        raw: raw.slice(0, 200),
      });
      return {
        ...(fallback || {}),
        _parseError: true,
        _rawSnippet: raw.slice(0, 200),
        _context: context,
      };
    }

    return parsed;
  } catch (e) {
    console.error('ERR safe_parse_json_exception', {
      context,
      message: String(e).slice(0, 200),
      raw: raw.slice(0, 200),
    });
    return {
      ...(fallback || {}),
      _parseError: true,
      _rawSnippet: raw.slice(0, 200),
      _context: context,
    };
  }
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
    leo_message_id: null, // Рэй не использует leo_message_id
    model_used: model,
    input_tokens: inputTokens,
    output_tokens: outputTokens,
    total_tokens: totalTokens,
    cost_usd: safeCost,
    bot_type: 'ray',
    request_type: requestType
  };

  try {
    const { error } = await supabaseAdminInstance.from('ai_message').insert(payload);
    if (error) {
      console.error('ERR save_ai_message', { message: error.message });
    } else {
      console.log('INFO ai_message_saved', { 
        userId, 
        botType: 'ray', 
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
 * Отправка алерта о критической ошибке парсинга JSON от LLM
 * В будущем можно интегрировать с системой мониторинга (Sentry, Datadog, etc.)
 */
function alertParseError(
  taskType: AiTaskType,
  context: string,
  rawSnippet: string | undefined,
  validationId: string | null,
  userId: string,
): void {
  // Критический алерт для scoring, т.к. это финальный этап валидации
  const isCritical = taskType === 'scoring';
  const logLevel = isCritical ? 'ERROR' : 'WARN';
  
  console.error(`ERR parse_error_alert_${logLevel.toLowerCase()}`, {
    taskType,
    context,
    validationId,
    userId,
    rawSnippet: rawSnippet?.slice(0, VALIDATION_LIMITS.LOG_SNIPPET_MAX_LENGTH),
    isCritical,
    message: `LLM вернул невалидный JSON для ${taskType}. Используется fallback.`,
  });

  // TODO: Интеграция с системой мониторинга
  // if (isCritical && MONITORING_ENABLED) {
  //   sendAlertToMonitoring({
  //     severity: 'error',
  //     message: `JSON parse error in ${taskType}`,
  //     context: { validationId, userId, rawSnippet },
  //   });
  // }
}

/**
 * Унифицированная обёртка над LLM-вызовами:
 * - вызывает xAI
 * - считает стоимость
 * - логирует в ai_message (если есть chatId)
 * - безопасно парсит JSON-ответ при необходимости
 * - явно логирует ошибки парсинга (_parseError)
 */
async function executeAiTask(
  ctx: RayContext,
  params: AiTaskParams,
): Promise<{ text: string; json?: any }> {
  const {
    taskType,
    userHint,
    model,
    messages,
    temperature = VALIDATION_LIMITS.TEMPERATURE_DEFAULT,
    maxTokens = VALIDATION_LIMITS.MAX_TOKENS.DEFAULT,
    responseFormat,
    jsonFallback,
  } = params;

  const requestType = AI_TASK_REQUEST_TYPE[taskType];

  const completion = await ctx.aiClient.chat.completions.create({
    model,
    messages,
    temperature,
    max_tokens: maxTokens,
    ...(responseFormat ? { response_format: { type: responseFormat.type } } : {}),
  });

  const text = completion.choices[0]?.message?.content || '';
  const usage = completion.usage;
  const cost = calculateCost(usage, model);

  // Логируем в ai_message только если есть chatId (иначе мягко скипаем)
  try {
    await saveAIMessageData(
      ctx.user.id,
      ctx.chatId,
      ctx.validationId,
      usage,
      cost,
      model,
      requestType,
      ctx.dbAdmin,
    );
  } catch {
    // saveAIMessageData уже логирует свои ошибки; здесь не падаем
  }

  if (responseFormat && responseFormat.type === 'json_object') {
    const json = safeParseJson(text, jsonFallback ?? {}, userHint);
    
    // Явная проверка _parseError: не используем fallback как нормальное состояние
    if (json && json._parseError === true) {
      alertParseError(
        taskType,
        userHint,
        json._rawSnippet,
        ctx.validationId,
        ctx.user.id,
      );
      
      // Дополнительное логирование для критических задач
      if (taskType === 'scoring') {
        console.error('ERR scoring_parse_error_critical', {
          validationId: ctx.validationId,
          userId: ctx.user.id,
          rawSnippet: json._rawSnippet,
          context: json._context,
          message: 'Scoring JSON parse failed - using fallback. This affects final validation result.',
        });
      }
    }
    
    return { text, json };
  }

  return { text };
}

// ============================
// RayEngine – Orchestrator
// ============================

class RayEngine {
  private ctx: RayContext;

  constructor(ctx: RayContext) {
    this.ctx = ctx;
  }

  /**
   * Обработка диалога (режим 'dialog'):
   * - Step 0: онбординг без списания GP
   * - Step 1-7: Slot Filling пайплайн
   */
  async handleDialog(
    messages: any[],
    action: string | undefined,
    currentStep: number,
  ): Promise<ActionResponse> {
    const { user, dbAdmin, validationId } = this.ctx;
    const userId = user.id;

    // Step 0: Онбординг - бесплатное общение без списания GP
    // НО если action === 'start_validation', то currentStep уже обновлен на 1 выше снаружи
    if (currentStep === 0 && action !== 'start_validation') {
      const pricing = await getValidationPrice(userId, dbAdmin);

      const onboardingResult = await executeAiTask(this.ctx, {
        taskType: 'onboarding',
        userHint: 'onboarding dialog before paid validation',
        model: CONFIG.MODELS.DEFAULT,
        messages: [
          { role: "system", content: CONFIG.PROMPTS.ONBOARDING },
          ...messages,
        ],
        temperature: VALIDATION_LIMITS.TEMPERATURE_DEFAULT,
        maxTokens: VALIDATION_LIMITS.MAX_TOKENS.ONBOARDING,
        responseFormat: { type: 'text' },
      });

      const botResponse = onboardingResult.text;

      return {
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
                is_primary: true,
              },
              {
                id: 'ask_about',
                label: 'А что ты умеешь?',
                is_primary: false,
              },
            ],
          },
        },
      };
    }

    // Step 1-7: Slot Filling
    const slotFillingResult = await validateUserResponseSlotFilling(
      this.ctx.aiClient,
      messages,
      validationId,
      userId,
      this.ctx.chatId,
      dbAdmin,
    );

    const isComplete = slotFillingResult.isComplete || false;
    if (isComplete) {
      console.log('INFO validation_complete', {
        validationId,
        finalStep: slotFillingResult.newStep,
      });
    }

    return {
      message: { role: "assistant", content: slotFillingResult.response },
      metadata: {
        current_step: slotFillingResult.newStep,
        retry_count: slotFillingResult.retryCount,
        is_complete: isComplete,
        slots_state: slotFillingResult.slotsState,
      },
    };
  }

  /**
   * Обработка режима 'score':
   * - вызывает LLM для скоринга через executeAiTask
   * - обновляет idea_validations, если есть validationId
   * - подготавливает контекст для Макса
   */
  async handleScore(
    messages: any[],
  ): Promise<{ scores: any; report: string; max_context: any | null }> {
    const { dbAdmin, validationId, user } = this.ctx;
    const userId = user.id;

    const conversationText = messages
      .map((m: any) => `${m.role}: ${m.content}`)
      .join('\n\n');

    const jsonFallback = {
      scores: {
        problem: 0,
        customer: 0,
        validation: 0,
        unique: 0,
        action: 0,
      },
      total: 0,
      archetype: 'МЕЧТАТЕЛЬ',
      strengths: [],
      red_flags: [],
      one_thing: '',
      recommended_levels: [],
    };

    const { json } = await executeAiTask(this.ctx, {
      taskType: 'scoring',
      userHint: 'scoring of full ray conversation',
      model: CONFIG.MODELS.DEFAULT,
      messages: [
        { role: "system", content: CONFIG.PROMPTS.SCORING },
        { role: "user", content: `Оцени эту беседу:\n\n${conversationText}` },
      ],
      temperature: 0.3,
      maxTokens: VALIDATION_LIMITS.MAX_TOKENS.SCORING,
      responseFormat: { type: 'json_object' },
      jsonFallback,
    });

    // Явная проверка _parseError перед валидацией схемы
    // Scoring - критический этап, поэтому логируем как ERROR
    if (json && json._parseError === true) {
      console.error('ERR scoring_parse_error_before_validation', {
        validationId,
        userId,
        rawSnippet: json._rawSnippet,
        context: json._context,
        message: 'Scoring JSON parse failed BEFORE schema validation. This is critical - using fallback.',
      });
      
      // Отправляем алерт (уже сделано в executeAiTask, но дублируем для ясности)
      alertParseError(
        'scoring',
        'scoring of full ray conversation',
        json._rawSnippet,
        validationId,
        userId,
      );
    }

    const scoringResult = validateWithSchema(
      json || jsonFallback,
      ScoringResultSchema,
      jsonFallback,
      'scoring_result',
    );

    // Добавляем рекомендованные уровни и генерируем отчёт
    // Type assertion необходим, т.к. Zod с .default([]) выводит never[] для пустого массива
    (scoringResult as any).recommended_levels = getRecommendedLevels(scoringResult);
    const report = generateReport(scoringResult);

    // Подготовим контекст для Макса на основе slots_state (если есть)
    let maxContext: any | null = null;
    if (validationId) {
      try {
        const { data: validationForContext, error: contextError } = await dbAdmin
          .from('idea_validations')
          .select('slots_state')
          .eq('id', validationId)
          .eq('user_id', userId)
          .single();

        if (contextError) {
          console.error('ERR load_slots_state_for_max', {
            message: contextError.message,
            validationId,
            userId,
          });
        } else if (validationForContext?.slots_state) {
          maxContext = prepareContextForMax(
            validationForContext.slots_state as SlotsState,
            scoringResult.total,
          );
        }
      } catch (e) {
        console.error('ERR prepare_max_context', {
          message: String(e).slice(0, 200),
          validationId,
          userId,
        });
      }
    }

    // Обновляем idea_validations, если есть validationId
    if (validationId) {
      const { count } = await dbAdmin
        .from('idea_validations')
        .select('*', { count: 'exact', head: true })
        .eq('user_id', userId)
        .eq('status', 'completed');

      const gpSpent = (count || 0) > 0 ? VALIDATION_COST_GP : 0;

      await dbAdmin
        .from('idea_validations')
        .update({
          scores: (scoringResult as any).scores,
          total_score: (scoringResult as any).total,
          archetype: (scoringResult as any).archetype,
          report_markdown: report,
          one_thing: (scoringResult as any).one_thing,
          recommended_levels: (scoringResult as any).recommended_levels,
          status: 'completed',
          completed_at: new Date().toISOString(),
          gp_spent: gpSpent,
        })
        .eq('id', validationId)
        .eq('user_id', userId);
    }

    return {
      scores: scoringResult,
      report,
      max_context: maxContext,
    };
  }
}
// ============================
// PIPELINE: SLOT FILLING – GUARD LAYER
// ============================

interface SlotFillingGuardParams {
  rawUserContent: string;
  lettersOnly: string;
  currentSlotsState: SlotsState;
  currentStep: number;
  retryCount: number;
  validationId: string | null;
  userId: string;
  supabaseAdmin: any;
  openai: any;
  model: string;
}

/**
 * Guard-слой для Slot Filling:
 * - фильтрует мусорные ответы (слишком короткие / мало букв)
 * - инкрементирует retry_count
 * - при повторных мусорных ответах применяет soft-skip текущего слота
 * - возвращает ранний ответ или null, если можно продолжать пайплайн
 * 
 * Soft-skip двухфазный подход (Фаза 1 - Guard):
 * 
 * Эта функция реализует ПЕРВУЮ фазу soft-skip механизма:
 * - Проверяет retryCount >= 2 БЕЗ вызова LLM
 * - Экономит токены при явном спаме/мусорных ответах
 * - Помечает слот как skipped_by_retry и двигает шаг вперёд
 * - Сохраняет состояние в БД и возвращает ранний ответ
 * 
 * Когда срабатывает:
 * - Пользователь отправляет короткие ответы (< 15 символов или < 5 букв)
 * - И уже было >= 2 попыток (retryCount >= 2)
 * 
 * Взаимодействие с Фазой 2 (navigateNextStep):
 * - Если Guard не сработал (ответ нормальный или retryCount < 2),
 *   пайплайн продолжается → LLM обрабатывает ответ → Navigator проверяет снова
 * - Если Guard сработал, пайплайн прерывается, LLM не вызывается
 * 
 * Результат: Одинаковая логика soft-skip в двух местах, две гарантии защиты
 */
async function guardUserInputQuality(
  params: SlotFillingGuardParams,
): Promise<{
  response: string;
  newStep: number;
  slotsState: SlotsState;
  retryCount: number;
  isComplete?: boolean;
} | null> {
  const {
    rawUserContent,
    lettersOnly,
    currentSlotsState,
    currentStep,
    retryCount,
    validationId,
    userId,
    supabaseAdmin,
    openai,
    model,
  } = params;

  const isTooShort = rawUserContent.length < VALIDATION_LIMITS.MIN_CHAR_LENGTH;
  const hasFewLetters = lettersOnly.length < VALIDATION_LIMITS.MIN_LETTER_COUNT;

  if (!isTooShort && !hasFewLetters) {
    return null;
  }

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

  // Фаза 1 Soft-skip: Если пользователь уже несколько раз отвечает мусором —
  // применяем soft-skip БЕЗ вызова LLM (экономия токенов)
  if (newRetryCount >= VALIDATION_LIMITS.MAX_RETRIES) {
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
        await updateValidationState(
          supabaseAdmin,
          userId,
          validationId,
          {
            slotsState: updatedSlotsState,
            currentStep: nextStep,
            retryCount: 0,
          },
        );

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
    try {
      await updateValidationState(
        supabaseAdmin,
        userId,
        validationId,
        { retryCount: newRetryCount },
      );
    } catch (updateError) {
      // Ошибка обновления retry_count - не критично, но логируем
      console.warn('WARN retry_count_update_failed', {
        message: String(updateError).slice(0, 200),
        validationId,
        userId,
        retryCount: newRetryCount,
      });
    }
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

// ============================
// PIPELINE: SLOT FILLING – PROCESSOR & NAVIGATOR
// ============================

interface SlotFillingProcessorResult {
  mergedSlotsState: SlotsState;
  suggestedStepIndex: number;
  botResponseText: string;
}

/**
 * Processor-слой:
 * - формирует компактный контекст диалога
 * - вызывает LLM через executeAiTask
 * - мержит слоты через mergeSlots
 * - возвращает готовый mergedSlotsState + suggestedStepIndex + текст ответа бота
 */
async function processSlotsStateWithLLM(
  openai: any,
  messages: any[],
  currentSlotsState: SlotsState,
  currentStep: number,
  validationId: string | null,
  userId: string,
  chatId: string | null,
  supabaseAdmin: any,
): Promise<SlotFillingProcessorResult> {
  const model = CONFIG.MODELS.DEFAULT;

  // Строим историю только по реальному диалогу (user/assistant)
  const conversationHistory = messages
    .filter((m: any) => m.role === 'user' || m.role === 'assistant')
    .map((m: any) => `${m.role === 'user' ? 'Пользователь' : 'Рэй'}: ${m.content}`)
    .join('\n\n');

  const currentSlotsJson = JSON.stringify(currentSlotsState.slots, null, 2);

  const slotFillingPrompt = `${CONFIG.PROMPTS.SLOT_FILLING_VALIDATOR}

ТЕКУЩЕЕ СОСТОЯНИЕ СЛОТОВ:
${currentSlotsJson}

ИСТОРИЯ ДИАЛОГА:
${conversationHistory}

ПОСЛЕДНИЙ ОТВЕТ ПОЛЬЗОВАТЕЛЯ:
"${String(
    messages
      .slice()
      .reverse()
      .find((m: any) => m.role === 'user')?.content ?? '',
  )}"

Проанализируй ответ пользователя и обнови состояние слотов.`;

  // Собираем минимальный контекст для executeAiTask
  const ctx: RayContext = {
    aiClient: openai,
    dbAdmin: supabaseAdmin,
    dbUser: null,
    user: {
      id: userId,
      jwt: '',
    },
    correlationId: null,
    validationId: validationId || null,
    chatId,
  };

  const jsonFallback = {
    updated_slots: {},
    suggested_step_index: currentStep,
    bot_response_text: '',
  };

  const { json } = await executeAiTask(ctx, {
    taskType: 'slot_filling',
    userHint: 'slot_filling v2: update SlotsState based on latest user message',
    model,
    messages: [
      { role: 'system', content: slotFillingPrompt },
      {
        role: 'user',
        content: 'Проанализируй ответ и верни обновлённое состояние слотов в формате JSON.',
      },
    ],
    temperature: 0.3,
    maxTokens: VALIDATION_LIMITS.MAX_TOKENS.SLOT_FILLING,
    responseFormat: { type: 'json_object' },
    jsonFallback,
  });

  // Явная проверка _parseError перед валидацией схемы
  if (json && json._parseError === true) {
    console.warn('WARN slot_filling_parse_error_before_validation', {
      validationId,
      userId,
      rawSnippet: json._rawSnippet,
      context: json._context,
      message: 'Slot filling JSON parse failed BEFORE schema validation - using fallback',
    });
  }

  const rawResult = validateWithSchema(
    json || jsonFallback,
    SlotFillingResponseSchema,
    jsonFallback,
    'slot_filling_response',
  );

  const updatedSlots = rawResult.updated_slots as Partial<
    Record<keyof SlotsState['slots'], Partial<SlotData>>
  >;

  const suggestedStepIndex = rawResult.suggested_step_index || currentStep;

  const botResponseText = rawResult.bot_response_text || '';

  const mergedSlotsState = mergeSlots(currentSlotsState, updatedSlots);

  return {
    mergedSlotsState,
    suggestedStepIndex,
    botResponseText,
  };
}

interface NavigateNextStepResult {
  nextStep: number;
  newRetryCount: number;
  isComplete: boolean;
  slotsState: SlotsState;
}

/**
 * Navigator-слой (pure function):
 * - принимает текущий шаг, retryCount, предложенный шаг от AI и mergedSlotsState
 * - решает, куда двигаться дальше
 * - помечает слоты как skipped_by_retry при soft validation
 * - НЕ трогает БД и не вызывает AI
 * 
 * Soft-skip двухфазный подход (Фаза 2 - Navigator):
 * 
 * Эта функция реализует ВТОРУЮ фазу soft-skip механизма:
 * - Вызывается ПОСЛЕ того, как LLM уже обработал ответ пользователя
 * - Проверяет, если retryCount >= 2 И AI не продвинул шаг (suggestedStepIndex === currentStep)
 * - Это backup-проверка на случай, если LLM "застрял" на одном шаге
 * - Применяет soft-skip, если AI не смог продвинуться, несмотря на нормальный ответ
 * 
 * Когда срабатывает:
 * - LLM обработал ответ, но не продвинул шаг (suggestedStepIndex === currentStep)
 * - И уже было >= 2 попыток (retryCount >= 2)
 * - Это означает, что даже нормальные ответы не помогают продвинуться
 * 
 * Взаимодействие с Фазой 1 (guardUserInputQuality):
 * - Guard срабатывает РАНЬШЕ и экономит токены при мусорных ответах
 * - Navigator срабатывает ПОСЛЕ LLM и ловит случаи "AI stuck"
 * - Обе проверки используют одинаковую логику (retryCount >= 2), но в разных контекстах
 * 
 * Результат: Одинаковая логика soft-skip в двух местах, две гарантии защиты
 */
function navigateNextStep(
  currentStep: number,
  retryCount: number,
  suggestedStepIndexFromAi: number,
  slotsState: SlotsState,
): NavigateNextStepResult {
  const originalSuggestedStep = suggestedStepIndexFromAi;
  let workingSlotsState = slotsState;
  let suggestedStepIndex = Math.min(suggestedStepIndexFromAi, MAX_STEPS);
  let newRetryCount = 0;

  // Фаза 2 Soft-skip: Если после нескольких попыток AI не двигает шаг вперёд,
  // помечаем текущий слот как skipped_by_retry и форсируем переход дальше.
  // Это backup-проверка после обработки LLM (в отличие от Guard, который работает до LLM).
  if (retryCount >= VALIDATION_LIMITS.MAX_RETRIES && suggestedStepIndex === currentStep) {
    const currentSlotKey = getSlotKeyByStep(currentStep);

    if (currentSlotKey) {
      const now = new Date().toISOString();

      workingSlotsState = {
        ...workingSlotsState,
        slots: {
          ...workingSlotsState.slots,
          [currentSlotKey]: {
            ...workingSlotsState.slots[currentSlotKey],
            status: 'skipped_by_retry',
            feedback:
              'Слот пропущен из-за множественных попыток уточнения. Рекомендуется вернуться позже.',
            updated_at: now,
          },
        },
        metadata: {
          ...workingSlotsState.metadata,
          last_updated: now,
          forced_slots: Array.from(
            new Set([
              ...workingSlotsState.metadata.forced_slots,
              String(currentSlotKey),
            ]),
          ),
        },
      };

      // Искусственно двигаем шаг вперёд (но не больше MAX_STEPS)
      suggestedStepIndex = Math.min(currentStep + 1, MAX_STEPS);
    }
  }

  // Не позволяем откатываться назад и не вылезаем за пределы MAX_STEPS
  const nextStep = Math.min(Math.max(currentStep, suggestedStepIndex), MAX_STEPS);

  // isComplete определяем по ИСХОДНОМУ предложению от AI (до ограничений)
  const isComplete = originalSuggestedStep >= 8;

  // Если шаг изменился вперёд — сбрасываем retryCount, иначе увеличиваем
  if (nextStep > currentStep) {
    newRetryCount = 0;
  } else {
    newRetryCount = retryCount + 1;
  }

  return {
    nextStep,
    newRetryCount,
    isComplete,
    slotsState: workingSlotsState,
  };
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

// ============================
// PIPELINE: LEGACY STEP-BY-STEP VALIDATION
// ============================

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

  // ШАГ 1: Generator — генерируем ответ Рэя через общий AI-сервис
  const model = CONFIG.MODELS.DEFAULT;
  const ctx: RayContext = {
    aiClient: openai,
    dbAdmin: supabaseAdmin,
    dbUser: null,
    user: { id: userId, jwt: '' },
    correlationId: null,
    validationId,
    chatId,
  };

  const generatorResult = await executeAiTask(ctx, {
    taskType: 'dialog_generator',
    userHint: 'legacy step-by-step ray dialog generator',
    model,
    messages: [
      { role: "system", content: CONFIG.PROMPTS.SYSTEM },
      ...messages,
    ],
    temperature: 0.7,
    maxTokens: VALIDATION_LIMITS.MAX_TOKENS.GENERATOR,
    responseFormat: { type: 'text' },
  });

  const generatorResponse = generatorResult.text;

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

  const isTooShort = rawUserContent.length < VALIDATION_LIMITS.MIN_CHAR_LENGTH;
  const hasFewLetters = lettersOnly.length < VALIDATION_LIMITS.MIN_LETTER_COUNT;

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
ВОПРОС РЭЯ: "${step.question}"

КРИТЕРИИ ДОСТАТОЧНОСТИ:
${criteriaText}

ОТВЕТ ПОЛЬЗОВАТЕЛЯ:
"${lastUserMessage.content}"

Оцени, достаточен ли ответ для перехода к следующему вопросу.`;

  try {
    const jsonFallback = {
      is_sufficient: true,
      feedback_short: '',
      missing_points: [],
      example_template: step.exampleTemplate,
      repeat_question: step.question,
    };

    const { json: validationResultRaw } = await executeAiTask(ctx, {
      taskType: 'dialog_validator',
      userHint: 'legacy ray answer sufficiency validator',
      model,
      messages: [
        { role: "system", content: validatorPrompt },
        { role: "user", content: "Оцени ответ пользователя согласно критериям." },
      ],
      temperature: 0.3,
      maxTokens: VALIDATION_LIMITS.MAX_TOKENS.VALIDATOR,
      responseFormat: { type: 'json_object' },
      jsonFallback,
    });

    // Явная проверка _parseError перед валидацией схемы
    if (validationResultRaw && validationResultRaw._parseError === true) {
      console.warn('WARN validation_response_parse_error_before_validation', {
        validationId,
        userId,
        currentStep,
        rawSnippet: validationResultRaw._rawSnippet,
        context: validationResultRaw._context,
        message: 'Validation response JSON parse failed BEFORE schema validation - using fallback',
      });
    }

    const validationResult = validateWithSchema(
      validationResultRaw || jsonFallback,
      ValidationResponseSchema,
      jsonFallback,
      'validation_response',
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
  // 1. Загружаем текущий стейт из БД
  const {
    slotsState: initialSlotsState,
    currentStep,
    retryCount,
  } = await getValidationState(supabaseAdmin, userId, validationId);
  let currentSlotsState = initialSlotsState;

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

  const guardResult = await guardUserInputQuality({
    rawUserContent,
    lettersOnly,
    currentSlotsState,
    currentStep,
    retryCount,
    validationId,
    userId,
    supabaseAdmin,
    openai,
    model: CONFIG.MODELS.DEFAULT,
  });

  if (guardResult) {
    return guardResult;
  }

  // 4-6. Основной Slot Filling пайплайн: LLM → merge → навигация → сохранение
  try {
    const processorResult = await processSlotsStateWithLLM(
      openai,
      messages,
      currentSlotsState,
      currentStep,
      validationId,
      userId,
      chatId,
      supabaseAdmin,
    );

    const nav = navigateNextStep(
      currentStep,
      retryCount,
      processorResult.suggestedStepIndex,
      processorResult.mergedSlotsState,
    );

    // Сохраняем обновлённое состояние в БД (через Repository-слой)
    // Атомарное обновление через RPC гарантирует, что все поля обновятся вместе или откатятся
    if (validationId) {
      try {
        await updateValidationState(
          supabaseAdmin,
          userId,
          validationId,
          {
            slotsState: nav.slotsState,
            currentStep: nav.nextStep,
            retryCount: nav.newRetryCount,
          },
        );

        console.log('INFO slots_state_updated', {
          validationId,
          oldStep: currentStep,
          newStep: nav.nextStep,
          isComplete: nav.isComplete,
          retryCount: nav.newRetryCount,
        });
      } catch (updateError) {
        // Ошибка атомарного обновления - критично, т.к. данные могут быть потеряны
        console.error('ERR slots_state_update_failed', {
          errorMessage: String(updateError).slice(0, 200),
          validationId,
          userId,
          oldStep: currentStep,
          newStep: nav.nextStep,
          retryCount: nav.newRetryCount,
          message: 'Atomic update failed - state may be inconsistent. User should retry.',
        });
        // НЕ пробрасываем ошибку дальше, чтобы не сломать ответ пользователю
        // Но логируем критическую ошибку для мониторинга
      }
    }

    return {
      response: processorResult.botResponseText,
      newStep: nav.nextStep,
      slotsState: nav.slotsState,
      retryCount: nav.newRetryCount,
      isComplete: nav.isComplete,
    };
  } catch (slotFillingError) {
    // Fail-safe: при ошибке LLM или процессора используем fallback
    console.error('ERR slot_filling_failed', {
      message: String(slotFillingError).slice(0, 200),
      validationId,
      currentStep,
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
  return (descriptions as any)[archetype] || (descriptions as any)['МЕЧТАТЕЛЬ'];
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
function getRecommendedLevels(scores: any): Array<{
  level_id: number;
  level_number: number;
  reason: string;
  name?: string;
}> {
  const recommendations: Array<{
    level_id: number;
    level_number: number;
    reason: string;
    name?: string;
  }> = [];
  
  const criteriaMapping: Record<string, {
    level_id: number;
    level_number: number;
    name: string;
    reason: string;
  }> = {
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
    if ((slot as SlotData).status === 'filled' || (slot as SlotData).status === 'partial') {
      const title = key.toUpperCase();
      const content = (slot as SlotData).content || '';
      if (content.trim().length > 0) {
        summaryLines.push(`${title}: ${content}`);
      }
    }
  }

  const structuredSummary = summaryLines.join('\n');

  // 2. Собираем слабые места: partial или принудительно пропущенные (skipped_by_retry)
  const forcedSlots = new Set<string>(((slotsState as any).metadata?.forced_slots || []).map(String));
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
    source: 'validator_ray_v1',
    validation_score: safeScore,
    structured_summary: structuredSummary,
    weak_spots: weakSpots,
    has_blind_spots: weakSpots.length > 0,
  };
}

// ============================
// DB REPOSITORY LAYER
// ============================

async function getValidationState(
  supabaseAdmin: any,
  userId: string,
  validationId: string | null,
): Promise<{ slotsState: SlotsState; currentStep: number; retryCount: number }> {
  let slotsState: SlotsState = createDefaultSlotsState();
  let currentStep = 1;
  let retryCount = 0;

  if (!validationId) {
    return { slotsState, currentStep, retryCount };
  }

  try {
    const { data: validation, error: validationError } = await supabaseAdmin
      .from('idea_validations')
      .select('slots_state, current_step, retry_count')
      .eq('id', validationId)
      .eq('user_id', userId)
      .single();

    if (validationError) {
      console.error('ERR get_validation_state', { message: validationError.message, validationId, userId });
      return { slotsState, currentStep, retryCount };
    }

    if (validation) {
      currentStep = (validation as any).current_step || 1;
      retryCount = (validation as any).retry_count || 0;

      if ((validation as any).slots_state && typeof (validation as any).slots_state === 'object') {
        const savedSlots = (validation as any).slots_state as any;

        if (savedSlots.slots) {
          slotsState = {
            ...slotsState,
            slots: {
              ...slotsState.slots,
              ...savedSlots.slots,
            },
            metadata: savedSlots.metadata || slotsState.metadata,
          };
        }
      }
    }
  } catch (e) {
    console.error('ERR load_validation_state', {
      message: String(e).slice(0, 200),
      validationId,
      userId,
    });
  }

  return { slotsState, currentStep, retryCount };
}

/**
 * Атомарное обновление состояния валидации через Supabase RPC
 * Гарантирует транзакционность: все поля обновляются вместе или откатываются
 */
async function updateValidationState(
  supabaseAdmin: any,
  userId: string,
  validationId: string | null,
  update: {
    slotsState?: SlotsState;
    currentStep?: number;
    retryCount?: number;
  },
): Promise<void> {
  if (!validationId) return;

  // Проверяем, что есть хотя бы одно поле для обновления
  const hasSlotsState = update.slotsState !== undefined && update.slotsState !== null;
  const hasCurrentStep = typeof update.currentStep === 'number';
  const hasRetryCount = typeof update.retryCount === 'number';

  if (!hasSlotsState && !hasCurrentStep && !hasRetryCount) {
    return; // Нет полей для обновления
  }

  try {
    // 1. Схемная валидация slots_state перед записью в БД
    let safeSlotsState: SlotsState | null = null;
    if (hasSlotsState) {
      try {
        const parsed = SlotsStateSchema.parse(update.slotsState);
        safeSlotsState = parsed as SlotsState;
      } catch (schemaError) {
        console.error('CRITICAL slots_state_schema_validation_failed', {
          validationId,
          userId,
          message: schemaError instanceof Error
            ? schemaError.message.slice(0, VALIDATION_LIMITS.LOG_SNIPPET_MAX_LENGTH)
            : String(schemaError).slice(0, VALIDATION_LIMITS.LOG_SNIPPET_MAX_LENGTH),
        });
        // Не пишем в базу заведомо битое состояние
        return;
      }
    }

    // Вызов атомарной SQL функции через RPC
    const { error } = await supabaseAdmin.rpc('update_validation_atomic', {
      p_validation_id: validationId,
      p_user_id: userId,
      p_slots_state: hasSlotsState ? safeSlotsState : null,
      p_current_step: hasCurrentStep ? update.currentStep : null,
      p_retry_count: hasRetryCount ? update.retryCount : null,
    });

    if (error) {
      console.error('ERR update_validation_state_atomic', {
        message: error.message,
        validationId,
        userId,
        hasSlotsState,
        hasCurrentStep,
        hasRetryCount,
      });
      throw error;
    }

    console.log('INFO validation_state_updated_atomic', {
      validationId,
      userId,
      updatedFields: {
        slotsState: hasSlotsState,
        currentStep: hasCurrentStep,
        retryCount: hasRetryCount,
      },
    });
  } catch (e) {
    console.error('ERR update_validation_state_exception', {
      message: String(e).slice(0, 200),
      validationId,
      userId,
      errorType: e instanceof Error ? e.constructor.name : typeof e,
    });
    throw e;
  }
}

async function spendGP(
  supabaseUser: any,
  supabaseAdmin: any,
  userId: string,
  validationId: string | null,
  amount: number,
  idempotencyKey: string,
): Promise<void> {
  try {
    const { data: spendResult, error: spendError } = await supabaseUser
      .rpc('gp_spend', {
        p_type: 'spend_message',
        p_amount: amount,
        p_reference_id: validationId || '',
        p_idempotency_key: idempotencyKey,
      });

    if (spendError) {
      console.error('ERR gp_spend', { message: spendError.message });

      if (spendError.message?.includes('insufficient') || spendError.code === '23514') {
        throw new RayError('insufficient_gp', 'Недостаточно GP для валидации идеи', {
          required: amount,
        });
      }

      throw new RayError('gp_error', 'Ошибка списания GP');
    }

    console.log('INFO gp_spent_on_start', {
      amount,
      validationId,
      balance_after: spendResult,
    });

    if (validationId) {
      await supabaseAdmin
        .from('idea_validations')
        .update({ gp_spent: amount, current_step: 1 })
        .eq('id', validationId)
        .eq('user_id', userId);
    }
  } catch (e) {
    if (e instanceof RayError) {
      throw e;
    }

    console.error('ERR gp_spend_exception', {
      message: String(e).slice(0, 200),
      validationId,
      userId,
    });
    throw new RayError('gp_error', 'Ошибка списания GP');
  }
}

// ============================
// DB HELPER FUNCTIONS
// ============================

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
    return { price: VALIDATION_COST_GP, isFree: false };
  }

  const isFree = (count || 0) === 0;
  return {
    price: isFree ? 0 : VALIDATION_COST_GP,
    isFree,
  };
}

// ============================
// EDGE HANDLER (serve) & GLOBAL ERROR HANDLER
// ============================
serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
    const supabaseAnonKey = Deno.env.get("SUPABASE_ANON_KEY");
    const xaiApiKey = Deno.env.get("XAI_API_KEY");

    if (!supabaseUrl || !supabaseServiceKey || !supabaseAnonKey || !xaiApiKey) {
      throw new Error("Missing required environment variables");
    }

    const supabaseAdmin = createClient(supabaseUrl, supabaseServiceKey);

    const body = await req.json();
    const { messages, validationId, mode = 'dialog', action } = body;

    if (!Array.isArray(messages) || messages.length === 0) {
      return new Response(
        JSON.stringify({ error: "Messages array is required" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

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

    const supabaseUser = createClient(supabaseUrl, supabaseAnonKey, {
      global: {
        headers: {
          Authorization: `Bearer ${authHeader}`,
        },
      },
    });

    let currentStep = 1;
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
      currentStep = 0;
    }

    if (mode === 'dialog' && action === 'start_validation') {
      const pricing = await getValidationPrice(userId, supabaseAdmin);
      
      if (!pricing.isFree) {
        const idempotencyKey = validationId
          ? `validation_${validationId}`
          : `validation_${userId}`;
        await spendGP(
          supabaseUser,
          supabaseAdmin,
          userId,
          validationId,
          VALIDATION_COST_GP,
          idempotencyKey,
        );
      } else {
        console.log('INFO first_validation_free', { userId });
        
        if (validationId) {
          await supabaseAdmin
            .from('idea_validations')
            .update({ current_step: 1 })
            .eq('id', validationId)
            .eq('user_id', userId);
        }
      }
      
      currentStep = 1;
    }

    const openai = new OpenAI({
      apiKey: xaiApiKey,
      baseURL: "https://api.x.ai/v1",
    });

    const ctx: RayContext = {
      aiClient: openai,
      dbAdmin: supabaseAdmin,
      dbUser: supabaseUser,
      user: {
        id: userId,
        jwt: authHeader,
      },
      correlationId: req.headers.get('x-correlation-id') || null,
      validationId: validationId || null,
      chatId,
    };

    const engine = new RayEngine(ctx);

    if (mode === 'dialog') {
      const result = await engine.handleDialog(messages, action, currentStep);
      return new Response(
        JSON.stringify(result),
        { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } },
      );
    }

    if (mode === 'score') {
      const result = await engine.handleScore(messages);
      return new Response(
        JSON.stringify(result),
        { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } },
      );
    }

    return new Response(
      JSON.stringify({ error: "Invalid mode. Use 'dialog' or 'score'" }),
      { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );

  } catch (error) {
    return handleGlobalError(error);
  }
});

function handleGlobalError(error: unknown): Response {
  console.error("Error in ray-chat:", error);

  if (error instanceof RayError) {
    const baseBody: any = {
      error: error.code,
      message: error.message,
    };
    if (error.payload && typeof error.payload === 'object') {
      Object.assign(baseBody, error.payload as Record<string, unknown>);
    }

    switch (error.code) {
      case 'insufficient_gp':
        return new Response(
          JSON.stringify(baseBody),
          {
            status: 402,
            headers: { ...corsHeaders, "Content-Type": "application/json" },
          },
        );
      case 'bad_request':
        return new Response(
          JSON.stringify(baseBody),
          {
            status: 400,
            headers: { ...corsHeaders, "Content-Type": "application/json" },
          },
        );
      case 'validation_not_found':
        return new Response(
          JSON.stringify(baseBody),
          {
            status: 404,
            headers: { ...corsHeaders, "Content-Type": "application/json" },
          },
        );
      case 'gp_error':
      default:
        return new Response(
          JSON.stringify(baseBody),
          {
            status: 500,
            headers: { ...corsHeaders, "Content-Type": "application/json" },
          },
        );
    }
  }

  const genericBody = {
    error: "internal_error",
    message: "Internal server error",
  };

  return new Response(
    JSON.stringify(genericBody),
    {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    },
  );
}
