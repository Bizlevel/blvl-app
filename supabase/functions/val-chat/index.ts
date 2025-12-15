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

  strengths.forEach((strength: string) => {
    report += `• ${strength}<br>\n`;
  });

  report += `
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🚩 **КРАСНЫЕ ФЛАГИ** (вопросы без ответа)

`;

  red_flags.forEach((flag: string) => {
    report += `• ${flag}<br>\n`;
  });

  report += `
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📚 **ЧТО ИЗУЧИТЬ В BIZLEVEL**

`;

  if (recommended_levels && recommended_levels.length > 0) {
    recommended_levels.forEach((level: any) => {
      report += `· **Уровень ${level.level_number}: ${level.name || 'Урок'}** — ${level.reason}<br>\n`;
    });
  } else {
    report += `· Пока нет конкретных рекомендаций — продолжай валидацию!<br>\n`;
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
    const xaiApiKey = Deno.env.get("XAI_API_KEY");

    if (!supabaseUrl || !supabaseServiceKey || !xaiApiKey) {
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

    // ============================
    // GP Economy: Check if payment required
    // ============================
    // First validation is FREE, subsequent validations cost 100 GP
    if (mode === 'dialog' && !validationId) {
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
        // Charge 100 GP for validation
        // Call gp_spend RPC function
        try {
          const { data: spendResult, error: spendError } = await supabaseAdmin
            .rpc('gp_spend', {
              p_type: 'idea_validation',
              p_amount: 100,
              p_reference_id: validationId || '',
              p_idempotency_key: `validation_${userId}_${Date.now()}`,
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

          console.log('INFO gp_spent', { amount: 100, type: 'idea_validation', balance_after: spendResult });
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
      }
    }

    // Initialize OpenAI client (using xAI)
    const openai = new OpenAI({
      apiKey: xaiApiKey,
      baseURL: "https://api.x.ai/v1",
    });

    // Mode: DIALOG (default)
    if (mode === 'dialog') {
      // Generate next question
      const completion = await openai.chat.completions.create({
        model: "grok-2-latest",
        messages: [
          { role: "system", content: SYSTEM_PROMPT },
          ...messages
        ],
        temperature: 0.7,
        max_tokens: 500,
      });

      const assistantMessage = completion.choices[0].message.content;

      return new Response(
        JSON.stringify({
          message: { role: "assistant", content: assistantMessage },
          usage: completion.usage,
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

      const completion = await openai.chat.completions.create({
        model: "grok-2-latest",
        messages: [
          { role: "system", content: SCORING_PROMPT },
          { role: "user", content: `Оцени эту беседу:\n\n${conversationText}` }
        ],
        temperature: 0.3,
        max_tokens: 1000,
        response_format: { type: "json_object" },
      });

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
