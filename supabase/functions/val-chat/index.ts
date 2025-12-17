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

// ============================
// Validation Steps Configuration
// ============================
interface ValidationStep {
  id: number;
  question: string;
  criteria: string[];
  exampleTemplate: string;
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
  validationId: string | null,
  usage: any,
  cost: number,
  model: string,
  requestType: string,
  supabaseAdminInstance: any
): Promise<void> {
  if (!userId) return; // Пропускаем, если пользователь не авторизован

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
    chat_id: null, // Валли не использует chat_id
    leo_message_id: null, // Валли не использует leo_message_id
    model_used: model,
    input_tokens: inputTokens,
    output_tokens: outputTokens,
    total_tokens: totalTokens,
    cost_usd: safeCost,
    bot_type: 'valli',
    request_type: requestType,
    // Добавляем reference на validation_id для связи
    metadata: validationId ? { validation_id: validationId } : null
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
    const { messages, validationId, mode = 'dialog' } = body;

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

    // Create user-authenticated client for GP operations (uses anon key + user JWT)
    const supabaseUser = createClient(supabaseUrl, supabaseAnonKey, {
      global: {
        headers: {
          Authorization: `Bearer ${authHeader}`,
        },
      },
    });

    // ============================
    // GP Economy: Check if payment required
    // ============================
    // First validation is FREE, subsequent validations cost 100 GP
    // Check on EVERY dialog message to ensure payment
    if (mode === 'dialog') {
      // Check how many completed validations user has
      const { count, error: countError } = await supabaseAdmin
        .from('idea_validations')
        .select('*', { count: 'exact', head: true })
        .eq('user_id', userId)
        .eq('status', 'completed');

      if (countError) {
        console.error('ERR count_validations', { message: countError.message });
      }

      const isFirstValidation = (count || 0) === 0;

      if (!isFirstValidation) {
        // Check if we already charged GP for this validation
        let alreadyCharged = false;
        
        if (validationId) {
          const { data: validation, error: validationError } = await supabaseAdmin
            .from('idea_validations')
            .select('gp_spent')
            .eq('id', validationId)
            .eq('user_id', userId)
            .single();
          
          if (validationError) {
            console.error('ERR check_gp_spent', { message: validationError.message });
          }
          
          alreadyCharged = validation?.gp_spent === 100;
        }
        
        if (!alreadyCharged) {
          // Charge 100 GP for validation
          // Call gp_spend RPC function with user auth context
          try {
            const { data: spendResult, error: spendError } = await supabaseUser
              .rpc('gp_spend', {
                p_type: 'spend_message',
                p_amount: 100,
                p_reference_id: validationId || '',
                p_idempotency_key: validationId ? `validation_${validationId}` : `validation_${userId}_${Date.now()}`,
              });

            if (spendError) {
              console.error('ERR gp_spend', { message: spendError.message });
              
              // Check if insufficient balance
              if (spendError.message?.includes('insufficient') || spendError.code === '23514') {
                return new Response(
                  JSON.stringify({ 
                    error: "insufficient_gp",
                    message: "Недостаточно GP. Нужно 100 GP для валидации идеи.",
                    required: 100
                  }),
                  { status: 402, headers: { ...corsHeaders, "Content-Type": "application/json" } }
                );
              }
              
              throw spendError;
            }

            console.log('INFO gp_spent', { amount: 100, type: 'spend_message', validationId, balance_after: spendResult });
            
            // Mark validation as charged
            if (validationId) {
              await supabaseAdmin
                .from('idea_validations')
                .update({ gp_spent: 100 })
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
          console.log('INFO gp_already_charged', { validationId });
        }
      } else {
        console.log('INFO first_validation_free', { userId });
      }
    }

    // Initialize OpenAI client (using xAI)
    const openai = new OpenAI({
      apiKey: xaiApiKey,
      baseURL: "https://api.x.ai/v1",
    });

    // Mode: DIALOG (default)
    if (mode === 'dialog') {
      // Получаем текущий шаг валидации
      let currentStep = 1;
      
      if (validationId) {
        const { data: validation, error: validationError } = await supabaseAdmin
          .from('idea_validations')
          .select('current_step')
          .eq('id', validationId)
          .eq('user_id', userId)
          .single();
        
        if (validationError) {
          console.error('ERR get_current_step', { message: validationError.message });
        } else if (validation) {
          currentStep = validation.current_step || 1;
        }
      }

      // Двухпроходная валидация: generator + validator
      const validationResult = await validateUserResponse(
        openai,
        messages,
        currentStep,
        userId,
        validationId,
        supabaseAdmin
      );

      // Если ответ достаточен и нужно продвинуть шаг
      if (validationResult.shouldAdvance && validationId && currentStep < 7) {
        const newStep = currentStep + 1;
        
        const { error: updateError } = await supabaseAdmin
          .from('idea_validations')
          .update({ current_step: newStep })
          .eq('id', validationId)
          .eq('user_id', userId);
        
        if (updateError) {
          console.error('ERR update_step', { message: updateError.message, currentStep, newStep });
        } else {
          console.log('INFO step_advanced', { validationId, from: currentStep, to: newStep });
        }
      } else if (!validationResult.shouldAdvance) {
        console.log('INFO step_blocked', { validationId, currentStep, isValid: validationResult.isValid });
      }

      return new Response(
        JSON.stringify({
          message: { role: "assistant", content: validationResult.response },
          metadata: {
            current_step: currentStep,
            is_valid: validationResult.isValid,
            should_advance: validationResult.shouldAdvance
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

      // Save to database if validationId provided
      if (validationId) {
        // Check if GP was spent (not first validation)
        const { count } = await supabaseAdmin
          .from('idea_validations')
          .select('*', { count: 'exact', head: true })
          .eq('user_id', userId)
          .eq('status', 'completed');
        
        const gpSpent = (count || 0) > 0 ? 100 : 0;

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
