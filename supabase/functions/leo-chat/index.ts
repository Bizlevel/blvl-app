// @ts-nocheck
import "jsr:@supabase/functions-js/edge-runtime.d.ts";

import { serve } from "https://deno.land/std@0.192.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.7.0";
import OpenAI from "https://deno.land/x/openai@v4.20.1/mod.ts";

// =====================
// In-memory caches (Deno isolate, reset on cold start)
// =====================
type CacheEntry = { value: string; expiresAt: number };
const personaCache: Map<string, CacheEntry> = new Map();
const ragCache: Map<string, CacheEntry> = new Map();

function nowMs(): number { return Date.now(); }
function ttlMsFromEnv(name: string, defSeconds: number): number {
  const sec = parseInt(Deno.env.get(name) || `${defSeconds}`);
  return (isFinite(sec) && sec > 0 ? sec : defSeconds) * 1000;
}

function getCached(map: Map<string, CacheEntry>, key: string): string | undefined {
  const hit = map.get(key);
  if (!hit) return undefined;
  if (hit.expiresAt <= nowMs()) { map.delete(key); return undefined; }
  return hit.value;
}

function setCached(map: Map<string, CacheEntry>, key: string, value: string, ttlMs: number): void {
  map.set(key, { value, expiresAt: nowMs() + ttlMs });
}

function hashQuery(s: string): string {
  // DJB2 hash for stable keying
  let h = 5381;
  for (let i = 0; i < s.length; i++) { h = ((h << 5) + h) + s.charCodeAt(i); }
  return (h >>> 0).toString(16);
}

function approximateTokenCount(text: string): number {
  // very rough: ~4 chars per token
  return Math.ceil(text.length / 4);
}

function limitByTokens(text: string, maxTokens: number): string {
  if (!text) return text;
  const approxTokens = approximateTokenCount(text);
  if (approxTokens <= maxTokens) return text;
  // trim by ratio
  const ratio = maxTokens / approxTokens;
  return text.slice(0, Math.max(0, Math.floor(text.length * ratio)));
}

function summarizeChunk(content: string, maxChars = 400): string {
  if (!content) return '';
  const clean = content.replace(/\s+/g, ' ').trim();
  // Try to take first 2 sentences
  const parts = clean.split(/(?<=[\.!?])\s+/).slice(0, 2).join(' ');
  const summary = parts || clean;
  return (summary.length > maxChars ? summary.slice(0, maxChars) + '…' : summary);
}

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

// Функция для сохранения данных о стоимости AI запроса
async function saveAIMessageData(
  userId: string | null,
  chatId: string | null,
  leoMessageId: string | null,
  usage: any,
  cost: number,
  model: string,
  bot: string,
  requestType: string = 'chat'
): Promise<void> {
  if (!userId) return; // Пропускаем, если пользователь не авторизован

  // Безопасное преобразование к integer
  const safeInt = (v: any) => {
    const n = parseInt(v);
    return isNaN(n) ? 0 : Math.min(Math.max(n, 0), 2147483647);
  };

  const inputTokens = safeInt(usage?.prompt_tokens);
  const outputTokens = safeInt(usage?.completion_tokens);
  const totalTokens = safeInt(
    usage?.total_tokens ?? (usage?.prompt_tokens ?? 0) + (usage?.completion_tokens ?? 0)
  );

  // Проверка cost
  let safeCost = cost;
  if (typeof safeCost !== 'number' || isNaN(safeCost)) {
    console.warn('WARN: cost is NaN or not a number, setting to 0', { cost });
    safeCost = 0;
  }

  const payload = {
    user_id: userId,
    chat_id: chatId,
    leo_message_id: leoMessageId,
    model_used: model,
    input_tokens: inputTokens,
    output_tokens: outputTokens,
    total_tokens: totalTokens,
    cost_usd: safeCost,
    bot_type: bot === 'max' ? 'max' : (requestType === 'quiz' ? 'quiz' : 'leo'),
    request_type: requestType,
  };

  try {
    const { error } = await supabaseAdmin
      .from('ai_message')
      .insert(payload);

    if (error) {
      console.error('ERR save_ai_message', { message: error.message });
    } else {
      console.log('INFO ai_message_saved', { userId, botType: bot, cost: safeCost });
    }
  } catch (e: any) {
    console.error('ERR save_ai_message_exception', { message: String(e).slice(0, 200) });
  }
}

// CORS headers for mobile app requests
const corsHeaders: Record<string, string> = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type, x-user-jwt",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

// Lazy init clients to avoid module-load failures if secrets are missing
let supabaseAdmin: ReturnType<typeof createClient> | null = null;
let supabaseAuth: ReturnType<typeof createClient> | null = null;
let openai: OpenAI | null = null;

serve(async (req: Request): Promise<Response> => {
  // Handle CORS pre-flight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  // DEBUG: Add version marker
  console.log('🔧 DEBUG: leo-chat v2.0 started - JWT debugging version');
  console.log('🔧 DEBUG: Request method:', req.method);
  console.log('🔧 DEBUG: Request URL:', req.url);

  // Validate environment variables
  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  const supabaseAnonKey = Deno.env.get("SUPABASE_ANON_KEY");
  const openaiKey = Deno.env.get("OPENAI_API_KEY");

  console.log('INFO env_check', {
    supabaseUrl: supabaseUrl?.substring(0, 30) + '...',
    hasServiceKey: Boolean(supabaseServiceKey),
    hasAnonKey: Boolean(supabaseAnonKey),
    hasOpenaiKey: Boolean(openaiKey)
  });

  if (!supabaseUrl || !supabaseServiceKey || !openaiKey) {
    console.error("ERR missing_env_vars", { 
      hasSupabaseUrl: Boolean(supabaseUrl),
      hasSupabaseServiceKey: Boolean(supabaseServiceKey),
      hasSupabaseAnonKey: Boolean(supabaseAnonKey),
      hasOpenaiKey: Boolean(openaiKey)
    });
    return new Response(
      JSON.stringify({ 
        error: "Configuration error", 
        details: "Missing required environment variables",
        missing: {
          supabaseUrl: !supabaseUrl,
          supabaseServiceKey: !supabaseServiceKey,
          supabaseAnonKey: !supabaseAnonKey,
          openaiKey: !openaiKey
        }
      }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }

  try {
    // Initialize clients lazily after env validation
    if (!supabaseAdmin) {
      supabaseAdmin = createClient(supabaseUrl!, supabaseServiceKey!);
    }
    if (!supabaseAuth) {
      supabaseAuth = createClient(supabaseUrl!, supabaseAnonKey!);
    }
    if (!openai) {
      openai = new OpenAI();
    }
    // Read request body once to support additional parameters
    const body = await req.json();
    console.log('🔧 DEBUG: Request body parsed successfully');
    
    // TEMPORARY: Return version info to confirm deployment
    if (body?.version_check === true) {
      return new Response(
        JSON.stringify({ 
          version: "v2.0-jwt-debug",
          timestamp: new Date().toISOString(),
          env_vars: {
            hasSupabaseUrl: Boolean(Deno.env.get("SUPABASE_URL")),
            hasServiceKey: Boolean(Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")),
            hasAnonKey: Boolean(Deno.env.get("SUPABASE_ANON_KEY")),
            hasOpenaiKey: Boolean(Deno.env.get("OPENAI_API_KEY"))
          }
        }),
        { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }
    
    const mode = typeof body?.mode === 'string' ? String(body.mode) : '';
    const messages = body?.messages;
    const userContext = body?.userContext;
    const levelContext = body?.levelContext;
    const chatId = body?.chatId; // Добавляем извлечение chatId
    let bot: string = typeof body?.bot === 'string' ? String(body.bot) : 'leo';
    // Backward compatibility: treat 'alex' as 'max'
    if (bot === 'alex') bot = 'max';
    const isMax = bot === 'max';

    // Добавляем логирование chatId
    console.log('🔧 DEBUG: chatId из запроса:', chatId);
    // Предварительное объявление userId, чтобы избежать TDZ при обращении в режимах выше по коду
    let userId: string | null = null;
    
    // Логируем входящие параметры для отладки
    console.log('🔧 DEBUG: Входящие параметры:', {
      mode,
      messagesCount: Array.isArray(messages) ? messages.length : 0,
      userContext: userContext ? `"${userContext}"` : 'НЕТ',
      levelContext: levelContext ? `"${levelContext}"` : 'НЕТ',
      bot,
      isMax,
    });
    
    // Дополнительная отладка для проверки типов
    console.log('🔧 DEBUG: Типы параметров:', {
      userContextType: typeof userContext,
      levelContextType: typeof levelContext,
      userContextIsNull: userContext === null,
      levelContextIsNull: levelContext === null,
      userContextIsUndefined: userContext === undefined,
      levelContextIsUndefined: levelContext === undefined,
    });
    
    // Дополнительная отладка для проверки значений
    console.log('🔧 DEBUG: Значения параметров:', {
      userContextValue: userContext,
      levelContextValue: levelContext,
      userContextIsStringNull: userContext === 'null',
      levelContextIsStringNull: levelContext === 'null',
    });

    // ==============================
    // GOAL_COMMENT MODE (short reply to field save, no RAG, no GP spend)
    // Disabled by default via feature flag
    // ==============================
    if (mode === 'goal_comment') {
      const goalCommentFlag = (Deno.env.get('ENABLE_GOAL_COMMENT') || 'false').toLowerCase();
      if (goalCommentFlag !== 'true') {
        return new Response(null, { status: 204, headers: corsHeaders });
      }
      try {
        // Вебхук приходит из БД-триггера с заголовком Authorization: Bearer <CRON_SECRET>
        const cronSecret = (Deno.env.get('CRON_SECRET') || '').trim();
        const authHeader = req.headers.get('authorization') || '';
        const bearerOk = cronSecret && authHeader.startsWith('Bearer ') && authHeader.replace('Bearer ', '').trim() === cronSecret;
        if (!bearerOk) {
          return new Response(
            JSON.stringify({ error: 'unauthorized_webhook' }),
            { status: 401, headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
          );
        }

        // Данные события: версия и поле
        const version: number = Number.isFinite(body?.version) ? Number(body.version) : Number(body?.goalVersion);
        const fieldName: string = typeof body?.field_name === 'string' ? body.field_name : (typeof body?.fieldName === 'string' ? body.fieldName : '');
        const fieldValue: any = body?.field_value ?? body?.fieldValue ?? null;
        const allFields: any = body?.all_fields ?? body?.allFields ?? {};

        // Системный промпт (короткий стиль Макса)
        const basePrompt = `Ты - Макс, трекер целей BizLevel. Отвечай по-русски, кратко (2–3 предложения), без вводных фраз.
КОНТЕКСТ: пользователь заполняет версию цели v${version}. Сейчас заполнено поле "${fieldName}".
СТИЛЬ: простые слова, локальный контекст (Казахстан, тенге), на «ты». Структура ответа: 1) короткий комментарий к введённому значению; 2) подсказка или вопрос к следующему шагу; 3) (опционально) микро-совет.
ЗАПРЕЩЕНО: общие фразы «отлично/молодец/правильно», вопросы «чем помочь?», лишние вводные.`;

        // Пользовательское сообщение для модели
        const userParts: string[] = [];
        if (fieldName) userParts.push(`Поле: ${fieldName}`);
        if (fieldValue !== null && fieldValue !== undefined) userParts.push(`Значение: ${typeof fieldValue === 'string' ? fieldValue : JSON.stringify(fieldValue)}`);
        if (allFields && typeof allFields === 'object') userParts.push(`Все поля версии: ${JSON.stringify(allFields)}`);

        // Рекомендованные чипы (по версии/следующим шагам)
        let recommended_chips: string[] | undefined;
        if (version === 1) {
          // v1: concrete_result → main_pain → first_action
          if (fieldName === 'concrete_result') recommended_chips = ['Главная проблема', 'Что мешает сейчас?'];
          else if (fieldName === 'main_pain') recommended_chips = ['Действие на завтра', 'Начну с …'];
          else recommended_chips = ['Уточнить результат', 'Добавить цифру в цель'];
        } else if (version === 2) {
          if (fieldName === 'metric_type') recommended_chips = ['Сколько сейчас?', 'Текущее значение'];
          else if (fieldName === 'metric_current') recommended_chips = ['Целевое значение', 'Хочу к концу месяца …'];
          else recommended_chips = ['Пересчитать % роста'];
        } else if (version === 3) {
          recommended_chips = ['Неделя 1: фокус', 'Неделя 2: фокус', 'Неделя 3: фокус', 'Неделя 4: фокус'];
        } else if (version === 4) {
          if (fieldName === 'readiness_score') recommended_chips = ['Дата старта', 'Начать в понедельник'];
          else if (fieldName === 'start_date') recommended_chips = ['Кому расскажу', 'Никому'];
          else if (fieldName === 'accountability_person') recommended_chips = ['План на 3 дня'];
          else recommended_chips = ['Готовность 7/10'];
        }

        const apiKey = Deno.env.get('OPENAI_API_KEY');
        if (!apiKey || apiKey.trim().length < 20) {
          return new Response(
            JSON.stringify({ error: 'openai_config_error' }),
            { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
          );
        }

        const completion = await openai.chat.completions.create({
          model: Deno.env.get('OPENAI_MODEL') || 'gpt-4.1-mini',
          temperature: 0.3,
          max_tokens: 120,
          messages: [
            { role: 'system', content: basePrompt },
            { role: 'user', content: userParts.join('\n') || 'Новое поле сохранено' },
          ],
        });

        const assistantMessage = completion.choices[0].message;
        const usage = completion.usage;

        // Breadcrumbs (без PII)
        console.log('BR goal_comment_done', { version, fieldName, hasAllFields: Boolean(allFields) });
        return new Response(
          JSON.stringify({ message: assistantMessage, usage, ...(recommended_chips ? { recommended_chips } : {}) }),
          { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
        );
      } catch (e: any) {
        const short = (e?.message || String(e)).slice(0, 240);
        console.error('BR goal_comment_error', { details: short.slice(0, 120) });
        return new Response(
          JSON.stringify({ error: 'goal_comment_error', details: short }),
          { status: 502, headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
        );
      }
    }

    // ==============================
    // WEEKLY_CHECKIN MODE (short reaction to weekly check-in, no RAG/GP)
    // Disabled by default via feature flag
    // ==============================
    if (mode === 'weekly_checkin') {
      // Feature flag: allow disabling weekly reaction quickly (default OFF)
      const flag = (Deno.env.get('ENABLE_WEEKLY_REACTION') || 'false').toLowerCase();
      if (flag !== 'true') {
        return new Response(null, { status: 204, headers: corsHeaders });
      }
      try {
        // Webhook: Authorization: Bearer <CRON_SECRET>
        const cronSecret = (Deno.env.get('CRON_SECRET') || '').trim();
        const authHeader = req.headers.get('authorization') || '';
        const bearerOk = cronSecret && authHeader.startsWith('Bearer ') && authHeader.replace('Bearer ', '').trim() === cronSecret;
        if (!bearerOk) {
          return new Response(
            JSON.stringify({ error: 'unauthorized_webhook' }),
            { status: 401, headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
          );
        }

        const weekNumber: number = Number.isFinite(body?.week_number) ? Number(body.week_number) : -1;
        const weekResult: string = typeof body?.week_result === 'string' ? body.week_result : '';
        const metricValue: number | null = (typeof body?.metric_value === 'number') ? body.metric_value : (Number.isFinite(body?.metric_value) ? Number(body.metric_value) : null);
        const usedTools: string[] = Array.isArray(body?.used_tools) ? body.used_tools.map((x: any) => String(x)) : [];

        const basePrompt = `Ты — Макс, трекер целей BizLevel. Отвечай кратко (2–3 предложения), по-русски.
КОНТЕКСТ: недельный чек-ин пользователя (Неделя ${weekNumber > 0 ? weekNumber : '?'}).
СТИЛЬ: простые слова, локальный контекст (Казахстан, тенге), на «ты». Структура: 1) короткая реакция на результат недели/метрику; 2) подсказка к следующему шагу; 3) (опц.) микро-совет.
ЗАПРЕЩЕНО: общие фразы «отлично/молодец/правильно», вопросы «чем помочь?», лишние вводные.`;

        const parts: string[] = [];
        if (weekResult) parts.push(`Итог недели: ${weekResult}`);
        if (metricValue !== null) parts.push(`Метрика (факт): ${metricValue}`);
        if (usedTools.length) parts.push(`Инструменты: ${usedTools.join(', ')}`);

        // Recommended chips: next-week focus
        const recommended_chips = ['Фокус следующей недели', 'Как усилить результат', 'Что мешает сейчас?'];

        const apiKey = Deno.env.get('OPENAI_API_KEY');
        if (!apiKey || apiKey.trim().length < 20) {
          return new Response(
            JSON.stringify({ error: 'openai_config_error' }),
            { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
          );
        }

        const completion = await openai.chat.completions.create({
          model: Deno.env.get('OPENAI_MODEL') || 'gpt-4.1-mini',
          temperature: 0.3,
          max_tokens: 120,
          messages: [
            { role: 'system', content: basePrompt },
            { role: 'user', content: parts.join('\n') || 'Чек-ин сохранён' },
          ],
        });

        const assistantMessage = completion.choices[0].message;
        const usage = completion.usage;

        // Breadcrumbs (без PII)
        console.log('BR weekly_checkin_done', { weekNumber, hasTools: usedTools.length > 0 });
        return new Response(
          JSON.stringify({ message: assistantMessage, usage, recommended_chips }),
          { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
        );
      } catch (e: any) {
        const short = (e?.message || String(e)).slice(0, 240);
        console.error('BR weekly_checkin_error', { details: short.slice(0, 120) });
        return new Response(
          JSON.stringify({ error: 'weekly_checkin_error', details: short }),
          { status: 502, headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
        );
      }
    }

    // ==============================
    // QUIZ MODE (short reply, no RAG)
    // ==============================
    if (mode === 'quiz') {
      try {
        const isCorrect: boolean = Boolean(body?.isCorrect);
        const quiz = body?.quiz || {};
        const question: string = String(quiz?.question || '');
        const options: string[] = Array.isArray(quiz?.options) ? quiz.options.map((x: any) => String(x)) : [];
        const selectedIndex: number = Number.isFinite(quiz?.selectedIndex) ? Number(quiz.selectedIndex) : -1;
        const correctIndex: number = Number.isFinite(quiz?.correctIndex) ? Number(quiz.correctIndex) : -1;
        const maxTokens = Number.isFinite(body?.maxTokens) ? Number(body.maxTokens) : 180;

        const systemPromptQuiz = `Ты отвечаешь как Лео в режиме проверки знаний. Пиши коротко, по‑русски, без вступительных фраз и без предложений помощи.
Если ответ неверный: поддержи и дай мягкую подсказку в 1–2 предложения, не раскрывай правильный вариант.
Если ответ верный: поздравь (1 фраза) и добавь 2–3 строки, как применить знание в жизни с учётом персонализации пользователя (если передана).`;

        const userMsgParts = [
          question ? `Вопрос: ${question}` : '',
          options.length ? `Варианты: ${options.join(' | ')}` : '',
          `Выбранный индекс: ${selectedIndex}`,
          `Правильный индекс: ${correctIndex}`,
          typeof userContext === 'string' && userContext.trim() && userContext !== 'null' ? `Персонализация: ${userContext.trim()}` : '',
          `Результат: ${isCorrect ? 'верно' : 'неверно'}`,
        ].filter(Boolean).join('\n');

        const apiKey = Deno.env.get("OPENAI_API_KEY");
        if (!apiKey || apiKey.trim().length < 20) {
          return new Response(
            JSON.stringify({ error: "openai_config_error" }),
            { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } },
          );
        }

        const completion = await openai.chat.completions.create({
          model: Deno.env.get("OPENAI_MODEL") || "gpt-4.1-mini",
          temperature: 0.2,
          max_tokens: Math.max(60, Math.min(300, maxTokens)),
          messages: [
            { role: "system", content: systemPromptQuiz },
            { role: "user", content: userMsgParts },
          ],
        });

        const assistantMessage = completion.choices[0].message;
        const usage = completion.usage;
        const model = Deno.env.get("OPENAI_MODEL") || "gpt-4.1-mini";
        const cost = calculateCost(usage, model);
        
        // Сохраняем данные о стоимости (но НЕ возвращаем пользователю)
        // В quiz режиме нет chatId и leoMessageId
        await saveAIMessageData(userId, null, null, usage, cost, model, 'quiz', 'quiz');
        
        return new Response(
          JSON.stringify({ message: assistantMessage, usage }),
          { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } },
        );
      } catch (e: any) {
        const short = (e?.message || String(e)).slice(0, 240);
        return new Response(
          JSON.stringify({ error: "quiz_mode_error", details: short }),
          { status: 502, headers: { ...corsHeaders, "Content-Type": "application/json" } },
        );
      }
    }

    if (!Array.isArray(messages)) {
      return new Response(
        JSON.stringify({ error: "invalid_messages" }),
        {
          status: 400,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        },
      );
    }

    // Try to extract user context from bearer token (optional)
    const authHeader = req.headers.get("Authorization") || req.headers.get("authorization");
    const userJwtHeader = req.headers.get("x-user-jwt");
    let userContextText = "";
    let profileText = ""; // формируем отдельно, чтобы при отсутствии JWT всё равно использовать client userContext
    let personaSummary = "";
    let maxCompletedLevel = 0; // Максимальный пройденный уровень пользователя

    // No PII: do not log tokens, only presence
    console.log('INFO auth_header_present', { present: Boolean(authHeader), userJwtPresent: Boolean(userJwtHeader) });
      // Prefer explicit user JWT header; otherwise try Authorization
      let jwt: string | null = null;
      if (typeof userJwtHeader === 'string' && userJwtHeader.trim().length > 20) {
        jwt = userJwtHeader.trim();
      } else if (authHeader?.startsWith("Bearer ")) {
        const token = authHeader.replace("Bearer ", "").trim();
        const anon = (Deno.env.get("SUPABASE_ANON_KEY") || '').trim();
        const service = (Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") || '').trim();
        // Ignore anon/service keys, only treat as user JWT if different
        if (token && token !== anon && token !== service) {
          jwt = token;
        }
      }

      if (!jwt) {
        return new Response(
          JSON.stringify({ code: 401, message: "Missing authorization header" }),
          { status: 401, headers: { ...corsHeaders, "Content-Type": "application/json" } }
        );
      }

      try {
        // Do not log JWT or any part of it
        console.log('INFO processing_jwt', {
          jwtLength: jwt.length,
          hasSupabaseUrl: Boolean(Deno.env.get("SUPABASE_URL")),
          hasServiceKey: Boolean(Deno.env.get("SUPABASE_SERVICE_ROLE_KEY"))
        });

        // Try with auth client first (anon key), fallback to admin client
        let authResult = await (supabaseAuth as any).auth.getUser(jwt);
        if (authResult.error) {
          console.log('WARN auth_client_failed, trying admin client');
          authResult = await (supabaseAdmin as any).auth.getUser(jwt);
        }
        const { data: { user }, error } = authResult as any;
        console.log('INFO auth_get_user', { ok: !error, user: user?.id ? 'present' : 'absent' });

        if (error) {
          console.log('ERROR auth_error', { message: error.message, code: error.code, details: error });
          return new Response(
            JSON.stringify({
              error: "JWT validation failed",
              details: {
                message: error.message,
                code: error.code,
                supabaseUrl: Deno.env.get("SUPABASE_URL"),
                hasServiceKey: Boolean(Deno.env.get("SUPABASE_SERVICE_ROLE_KEY"))
              }
            }),
            { status: 401, headers: { ...corsHeaders, "Content-Type": "application/json" } }
          );
        }

        if (user) {
          userId = user.id;
          const personaTtlMs = ttlMsFromEnv('PERSONA_CACHE_TTL_SEC', 180);
          // Try persona cache first
          const cachedPersona = getCached(personaCache, user.id);
          if (cachedPersona) {
            personaSummary = cachedPersona;
          }

          // Получаем максимальный пройденный уровень пользователя
          try {
            const { data: maxLevelData, error: maxLevelError } = await (supabaseAdmin as any)
              .from('user_progress')
              .select('level_id')
              .eq('user_id', user.id)
              .eq('is_completed', true)
              .order('level_id', { ascending: false })
              .limit(1);
            
            console.log('🔧 DEBUG: maxLevelData:', JSON.stringify(maxLevelData, null, 2));
            console.log('🔧 DEBUG: maxLevelError:', maxLevelError);
            
            if (maxLevelData && maxLevelData.length > 0) {
              // Маппинг level_id в номер уровня
              const levelIdToNumber: { [key: string]: number } = {
                '11': 1, '12': 2, '13': 3, '14': 4, '15': 5,
                '16': 6, '17': 7, '18': 8, '19': 9, '20': 10, '22': 0
              };
              const levelId = maxLevelData[0].level_id;
              console.log('🔧 DEBUG: levelId получен:', levelId);
              console.log('🔧 DEBUG: typeof levelId:', typeof levelId);
              console.log('🔧 DEBUG: levelId как строка:', String(levelId));
              console.log('🔧 DEBUG: levelIdToNumber[String(levelId)]:', levelIdToNumber[String(levelId)]);
              console.log('🔧 DEBUG: levelIdToNumber object:', JSON.stringify(levelIdToNumber, null, 2));
              
              maxCompletedLevel = levelIdToNumber[String(levelId)] || 0;
              console.log('🔧 DEBUG: maxCompletedLevel установлен в:', maxCompletedLevel);
            } else {
              console.log('🔧 DEBUG: Нет данных в maxLevelData или массив пустой');
            }
            if (maxLevelError) {
              console.error('ERR max_completed_level', { message: maxLevelError.message });
            }
          } catch (e) {
            console.error('ERR max_completed_level_exception', { message: String(e).slice(0, 200) });
          }

          // (Опционально) Получаем current_level из users
          let currentLevel = null;
          try {
            const { data: userData, error: userError } = await (supabaseAdmin as any)
              .from('users')
              .select('current_level')
              .eq('id', user.id)
              .single();
            if (userData && userData.current_level !== undefined && userData.current_level !== null) {
              currentLevel = userData.current_level;
            }
            if (userError) {
              console.error('ERR current_level', { message: userError.message });
            }
          } catch (e) {
            console.error('ERR current_level_exception', { message: String(e).slice(0, 200) });
          }

          const { data: profile } = await (supabaseAdmin as any)
            .from("users")
            .select("name, about, goal, business_area, experience_level, persona_summary")
            .eq("id", user.id)
            .single();

          if (profile) {
            const { name, about, goal, business_area, experience_level, persona_summary } = profile as any;
            // Собираем профиль пользователя
            profileText = `Имя пользователя: ${name ?? "не указано"}. Цель: ${goal ?? "не указана"}. О себе: ${about ?? "нет информации"}. Сфера деятельности: ${business_area ?? "не указана"}. Уровень опыта: ${experience_level ?? "не указан"}.`;

            // Персона: берём сохранённую, иначе кратко формируем из профиля
            if (!personaSummary) {
              if (typeof persona_summary === 'string' && persona_summary.trim().length > 0) {
                personaSummary = persona_summary.trim();
              } else {
                const compact = [name && `Имя: ${name}`, goal && `Цель: ${goal}`, business_area && `Сфера: ${business_area}`, experience_level && `Опыт: ${experience_level}`]
                  .filter(Boolean).join('; ');
                personaSummary = compact || '';
              }
            }
            if (personaSummary) {
              setCached(personaCache, user.id, personaSummary, personaTtlMs);
            }
          }
        }
      } catch (authErr: any) {
        console.log('ERR auth_process', { message: String(authErr).slice(0, 200) });
      }

    // Объединяем профиль и клиентский контекст независимо от авторизации
    // Фильтруем строки "null" и пустые значения
    if (typeof userContext === 'string' && userContext.trim().length > 0 && userContext !== 'null') {
      userContextText = `${profileText ? profileText + "\n" : ''}${userContext.trim()}`;
    } else {
      userContextText = profileText;
    }

    // Извлекаем последний запрос пользователя
    const lastUserMessage = Array.isArray(messages)
      ? [...messages].reverse().find((m: any) => m?.role === 'user')?.content ?? ''
      : '';

    // Встроенный RAG: эмбеддинг + match_documents (с кешем)
    // Для Max (бот-трекер) RAG отключаем полностью
    let ragContext = '';
    if (!isMax && typeof lastUserMessage === 'string' && lastUserMessage.trim().length > 0) {
      console.log('🔧 DEBUG: RAG включен для бота:', bot, 'последнее сообщение:', lastUserMessage.substring(0, 100));
      
      // Проверяем, не относится ли вопрос к непройденным уровням
      const questionLower = lastUserMessage.toLowerCase();
      let questionLevel = 0;
      
      // Определяем уровень вопроса по ключевым словам
      if (questionLower.includes('элеватор питч') || questionLower.includes('elevator pitch') || questionLower.includes('презентация бизнеса') || questionLower.includes('60 секунд')) {
        questionLevel = 6;
      } else if (questionLower.includes('утп') || questionLower.includes('уникальное торговое предложение') || questionLower.includes('конкурентный анализ')) {
        questionLevel = 5;
      } else if (questionLower.includes('матрица эйзенхауэра') || questionLower.includes('приоритизация') || questionLower.includes('планирование задач')) {
        questionLevel = 3;
      } else if (questionLower.includes('учёт доходов') || questionLower.includes('финансы') || questionLower.includes('денежные потоки')) {
        questionLevel = 4;
      } else if (questionLower.includes('стресс-менеджмент') || questionLower.includes('управление стрессом') || questionLower.includes('дыхательные техники')) {
        questionLevel = 2;
      } else if (questionLower.includes('цели') || questionLower.includes('мотивация') || questionLower.includes('smart-цели')) {
        questionLevel = 1;
      }
      
      console.log('🔧 DEBUG: Определен уровень вопроса:', questionLevel, 'maxCompletedLevel:', maxCompletedLevel);
      
      // Если вопрос относится к непройденным уровням, НЕ загружаем RAG
      if (questionLevel > maxCompletedLevel) {
        console.log('🔧 DEBUG: RAG отключен - вопрос относится к непройденному уровню', questionLevel);
        ragContext = '';
      } else {
        try {
          const embeddingModel = Deno.env.get("OPENAI_EMBEDDING_MODEL") || "text-embedding-3-small";
          const matchThreshold = parseFloat(Deno.env.get("RAG_MATCH_THRESHOLD") || "0.35");
          const matchCount = parseInt(Deno.env.get("RAG_MATCH_COUNT") || "6");
          const ragTtlMs = ttlMsFromEnv('RAG_CACHE_TTL_SEC', 180);

          const normalized = (lastUserMessage || '').toLowerCase().trim();
          const ragKeyBase = `${userId || 'anon'}::${hashQuery(normalized)}`;
          const cachedRag = getCached(ragCache, ragKeyBase);
          if (cachedRag) {
            ragContext = cachedRag;
          } else {
            const embeddingResponse = await openai.embeddings.create({ input: lastUserMessage, model: embeddingModel });
            const queryEmbedding = embeddingResponse.data[0].embedding;

            // Передаём фильтры метаданных, если есть levelContext/skill внутри него (ожидается как "level_id: X" или JSON)
            let metadataFilter: any = {};
            try {
              if (levelContext && typeof levelContext === 'string' && levelContext !== 'null') {
                const m = levelContext.match(/level[_ ]?id\s*[:=]\s*(\d+)/i);
                if (m) metadataFilter.level_id = parseInt(m[1]);
              } else if (levelContext && typeof levelContext === 'object') {
                const lid = (levelContext as any).level_id ?? (levelContext as any).levelId;
                if (lid != null) metadataFilter.level_id = parseInt(String(lid));
              }
            } catch (_) {}

            const { data: results, error: matchError } = await (supabaseAdmin as any).rpc('match_documents', {
              query_embedding: queryEmbedding,
              match_threshold: matchThreshold,
              match_count: matchCount,
              metadata_filter: Object.keys(metadataFilter).length ? metadataFilter : undefined,
            });
            if (matchError) {
              console.error('ERR rag_match_documents', { message: matchError.message });
            }
            
            console.log('🔧 DEBUG: RAG результаты:', { 
              found: Array.isArray(results) ? results.length : 0, 
              error: matchError?.message || 'none',
              metadataFilter: Object.keys(metadataFilter).length ? metadataFilter : 'none'
            });

            const docs = Array.isArray(results) ? results : [];
            // Сжатие чанков в тезисы
            const compressedBullets = docs.map((r: any) => `- ${summarizeChunk(r.content || '')}`).filter(Boolean);
            let joined = compressedBullets.join('\n');
            // Ограничение по токенам
            const maxTokens = parseInt(Deno.env.get('RAG_MAX_TOKENS') || '1200');
            joined = limitByTokens(joined, isFinite(maxTokens) && maxTokens > 0 ? maxTokens : 1200);
            ragContext = joined;
            if (ragContext) {
              setCached(ragCache, ragKeyBase, ragContext, ragTtlMs);
              console.log('🔧 DEBUG: RAG контекст создан, длина:', ragContext.length, 'символов');
            } else {
              console.log('🔧 DEBUG: RAG контекст пустой');
            }
          }
        } catch (e) {
          console.error('ERR rag_pipeline', { message: String(e).slice(0, 240) });
        }
      }
    }

    // Последние личные заметки пользователя (память)
    let memoriesText = '';
    let recentSummaries = '';
    if (userId) {
      try {
        const { data: memories } = await supabaseAdmin
          .from('user_memories')
          .select('content, updated_at')
          .eq('user_id', userId)
          .order('updated_at', { ascending: false })
          .limit(5);
        if (memories && memories.length > 0) {
          memoriesText = memories.map((m: any) => `• ${m.content}`).join('\n');
        }
      } catch (e) {
        console.error('ERR user_memories', { message: String(e).slice(0, 200) });
      }

      // При старте новой сессии: подтянуть свёртки прошлых чатов (2–3 последних)
      try {
        const { data: summaries } = await supabaseAdmin
          .from('leo_chats')
          .select('summary')
          .eq('user_id', userId)
          .eq('bot', isMax ? 'max' : 'leo')
          .not('summary', 'is', null)
          .order('updated_at', { ascending: false })
          .limit(3);
        if (Array.isArray(summaries) && summaries.length > 0) {
          const items = summaries
            .map((r: any) => (r?.summary || '').toString().trim())
            .filter((s: string) => s.length > 0);
          if (items.length > 0) {
            recentSummaries = items.map((s) => `• ${s}`).join('\n');
          }
        }
      } catch (e) {
        console.error('ERR chat_summaries', { message: String(e).slice(0, 200) });
      }
    }

    console.log('INFO request_meta', {
      messages_count: Array.isArray(messages) ? messages.length : 0,
      userContext_present: Boolean(userContext),
      levelContext_present: Boolean(levelContext),
      ragContext_present: Boolean(ragContext),
      bot: isMax ? 'max' : 'leo',
      mode,
      lastUserMessage: Array.isArray(messages) ? [...messages].reverse().find((m: any) => m?.role === 'user')?.content?.substring(0, 100) : 'none',
    });
    
    // Extra goal/sprint/reminders/quote context for Max (tracker)
    let goalBlock = '';
    let sprintBlock = '';
    let remindersBlock = '';
    let quoteBlock = '';
    if (isMax && userId) {
      try {
        // Latest goal version
        const { data: goals } = await supabaseAdmin
          .from('core_goals')
          .select('version, goal_text, version_data, updated_at')
          .eq('user_id', userId)
          .order('version', { ascending: false })
          .limit(1);
        if (Array.isArray(goals) && goals.length > 0) {
          const g = goals[0] as any;
          const version = g?.version;
          const goalText = g?.goal_text || '';
          const versionData = typeof g?.version_data === 'object' ? JSON.stringify(g?.version_data) : String(g?.version_data || '');
          goalBlock = `Версия цели: v${version}. Кратко: ${goalText}. Данные версии: ${versionData}`;
        }
      } catch (e) {
        console.error('ERR alex_goal', { message: String(e).slice(0, 200) });
      }
      try {
        // Latest weekly progress
        const { data: progress } = await supabaseAdmin
          .from('weekly_progress')
          .select('sprint_number, achievement, metric_actual, created_at')
          .eq('user_id', userId)
          .order('created_at', { ascending: false })
          .limit(1);
        if (Array.isArray(progress) && progress.length > 0) {
          const p = progress[0] as any;
          sprintBlock = `Спринт: ${p?.sprint_number ?? ''}. Итоги: ${p?.achievement ?? ''}. Метрика (факт): ${p?.metric_actual ?? ''}`;
        }
      } catch (e) {
        console.error('ERR alex_progress', { message: String(e).slice(0, 200) });
      }
      try {
        // Recent unchecked reminders (up to 5)
        const { data: reminders } = await supabaseAdmin
          .from('reminder_checks')
          .select('day_number, reminder_text, is_completed')
          .eq('user_id', userId)
          .eq('is_completed', false)
          .order('day_number', { ascending: true })
          .limit(5);
        if (Array.isArray(reminders) && reminders.length > 0) {
          const lines = reminders.map((r: any) => `• День ${r?.day_number}: ${r?.reminder_text}`);
          remindersBlock = lines.join('\n');
        }
      } catch (e) {
        console.error('ERR alex_reminders', { message: String(e).slice(0, 200) });
      }
      try {
        // Daily quote (any active)
        const { data: quotes } = await supabaseAdmin
          .from('motivational_quotes')
          .select('quote_text, author')
          .eq('is_active', true)
          .limit(1);
        if (Array.isArray(quotes) && quotes.length > 0) {
          const q = quotes[0] as any;
          const author = q?.author ? ` — ${q.author}` : '';
          quoteBlock = `${q?.quote_text || ''}${author}`;
        }
      } catch (e) {
        console.error('ERR alex_quotes', { message: String(e).slice(0, 200) });
      }
    }
    
    // Enhanced system prompt for Leo AI mentor
    const systemPromptLeo = `## КРИТИЧЕСКОЕ ОГРАНИЧЕНИЕ ПО ПРОГРЕССУ (ПЕРВЫЙ ПРИОРИТЕТ):
Пользователь прошёл уровней: ${maxCompletedLevel}. 
ЗАПРЕЩЕНО отвечать на вопросы по темам уровней выше ${maxCompletedLevel}.
Если вопрос относится к непройденным уровням, ОБЯЗАТЕЛЬНО отвечай: 
"Этот вопрос разбирается в уроке X. Мы до него дойдем позже"

ВАЖНО: Вопросы про "Elevator Pitch", "элеватор питч", "презентацию бизнеса за 60 секунд" относятся к УРОВНЮ 6.
Вопросы про "УТП", "уникальное торговое предложение" относятся к УРОВНЮ 5.
Вопросы про "матрицу Эйзенхауэра", "приоритизацию" относятся к УРОВНЮ 3.

## ПРАВИЛО ПЕРВОЙ ПРОВЕРКИ:
ПЕРЕД ЛЮБЫМ ОТВЕТОМ сначала проверь уровень вопроса. Если уровень > ${maxCompletedLevel}, НЕ ДАВАЙ ОТВЕТА, а только скажи про прохождение уроков.

## АЛГОРИТМ ПРОВЕРКИ ПЕРЕД ОТВЕТОМ:
1. Определи, к какому уровню относится вопрос пользователя по следующим примерам:
   - Уровень 1: цели, мотивация, SMART-цели
   - Уровень 2: стресс-менеджмент, управление стрессом, дыхательные техники
   - Уровень 3: матрица Эйзенхауэра, приоритизация, планирование задач
   - Уровень 4: учёт доходов/расходов, финансы, денежные потоки
   - Уровень 5: УТП, уникальное торговое предложение, конкурентный анализ
   - Уровень 6: Elevator Pitch, презентация бизнеса, 60 секунд
   - Уровень 7: еженедельное планирование, SMART-задачи
   - Уровень 8: опрос клиентов, обратная связь, интервью
   - Уровень 9: юридические аспекты, налоги, чек-лист
   - Уровень 10: интеграция инструментов, карта действий

2. Если уровень > ${maxCompletedLevel}, НЕ ОТВЕЧАЙ на вопрос
3. Вместо ответа скажи: "Этот материал изучается в уроке X. Пройдите предыдущие уроки."
4. НЕ ИСПОЛЬЗУЙ материалы из RAG, если они относятся к непройденным уровням

## Твоя Роль и Личность:
Ты — Лео, харизматичный ИИ-консультант программы «БизЛевел» в Казахстане. 
Твоя задача — помогать пользователю применять материалы курса в жизни, строго следуя правилам ниже.

## Представление и первый вопрос:
— Представляйся только в первом ответе новой сессии или если пользователь явно спрашивает «кто ты?». Представься как ИИ-консультант, помогающий применять материалы курса.
— В первом ответе обязательно задай вопрос: «Какой у вас вопрос по применению пройденных уроков курса в жизни?» или аналогичный по смыслу.
— Обязательно напомни: качество ответов зависит от заполненности профиля пользователя.

## Приоритеты ответа:
— Всегда в первую очередь используй персональные данные пользователя (сфера деятельности, цель, опыт, информация о себе) для примеров и объяснений.
— Если есть раздел «ПЕРСОНАЛИЗАЦИЯ ДЛЯ ПОЛЬЗОВАТЕЛЯ», обязательно используй его в ответе.
— После персонализации используй только материалы из базы знаний курса, относящиеся к уже пройденным пользователем урокам.
— Если вопрос пользователя относится к материалам ещё не пройденных уроков, не отвечай на него. Жёстко запрещено помогать или давать советы по этим темам. Вместо этого мягко подтолкни пользователя к прохождению соответствующего урока, например: «Этот вопрос разбирается в уроке 5. Пройдите этот урок, чтобы получить ответ».

## Запреты:
— Категорически запрещено создавать таблицы или использовать символы |, +, -, = для их имитации. Если пользователь просит таблицу, отвечай: «Таблицы неудобно читать в мессенджере, представлю информацию списком:» и выдай структурированный список.
— Запрещено предлагать дополнительную помощь, завершать ответы фразами типа: «Могу помочь с...», «Нужна помощь в...», «Готов помочь с...», «Могу объяснить ещё что-то?».
— Запрещено использовать вводные фразы вежливости и приветствия: не начинай ответы с «Отличный вопрос!», «Понимаю...», «Конечно!», «Давайте разберёмся!», «Привет», «Здравствуйте» и т.п. Сразу переходи к сути.
— Не придумывай факты, которых нет в базе знаний или профиле пользователя.
— Не используй эмодзи, разметку, символы форматирования, кроме простого текста.

## Структура и стиль ответа:
— Отвечай кратко, чётко, по делу, простым языком, без лишних слов.
— Всегда используй только актуальные или будущие даты (2026 год и далее) в примерах целей, планов, дедлайнов. Не используй даты из прошлого.
— Примеры адаптируй под сферу деятельности пользователя и локальный контекст (Казахстан, тенге, местные имена: Айбек, Алия, Айдана, Ержан, Арман, Жулдыз).
— Говори от первого лица.
— Отвечай на языке вопроса (русский/казахский/английский).
— Если нет информации для ответа, сообщи: «К сожалению, по вашему запросу я не смог найти точную информацию в базе знаний BizLevel».
— Завершай ответ без предложений помощи.

## Алгоритм ответа:
1. ПРОВЕРЬ УРОВЕНЬ ВОПРОСА - если > ${maxCompletedLevel}, НЕ ОТВЕЧАЙ
2. Проверь, не просит ли пользователь таблицу — если да, выдай список.
3. Проверь наличие персонализации — если есть, используй её в первую очередь.
4. Определи, к какому уроку относится вопрос. Если урок ещё не пройден, не отвечай, а мотивируй пройти урок.
5. Используй только материалы из уже пройденных уроков и персональные данные пользователя.
6. Если информации недостаточно, сообщи об этом.
7. Структурируй ответ: чёткое объяснение с примером, без вводных и без предложений помощи.

Ты — лицо школы BizLevel. Работай строго по инструкции. Нарушение любого из пунктов недопустимо.

${personaSummary ? `\n## Персона пользователя:\n${personaSummary}` : ''}
${memoriesText ? `\n## Личные заметки (память):\n${memoriesText}` : ''}
${recentSummaries ? `\n## Итоги прошлых обсуждений:\n${recentSummaries}` : ''}
${ragContext ? `\n## RAG контекст (база знаний):\n${ragContext}` : ''}
${userContextText ? `\n## ПЕРСОНАЛИЗАЦИЯ ДЛЯ ПОЛЬЗОВАТЕЛЯ:\n${userContextText}` : ''}
${levelContext && levelContext !== 'null' ? `\n## КОНТЕКСТ УРОКА:\n${levelContext}` : ''}`;

    // Max (goal tracker) prompt — коротко, конкретно, приоритет цели/спринтов
    const systemPromptAlex = `## Твоя роль и тон:
Ты — Макс, трекер цели BizLevel. 
Твоя задача — помогать пользователю кристаллизовать и достигать его цели, строго следуя правилам ниже.
Включение и область ответственности:
— Полностью включайся в работу только после того, как пользователь прошёл урок 4. До этого момента мягко мотивируй пройти первые четыре урока, не обсуждай цели подробно.
— Обсуждай исключительно цели пользователя, их формулировку, уточнение, достижение и прогресс. Не помогай с материалами уроков, не объясняй их и не давай советов по ним.
Первый ответ и напоминания:
— В первом ответе новой сессии или при явном вопросе «кто ты?» представься как ИИ-трекер целей, который помогает формулировать и достигать цели.
— Если в профиле пользователя отсутствует цель или важная информация (сфера деятельности, опыт, метрика), обязательно напомни: «Для качественной работы трекера заполните профиль максимально подробно. Это критически важно для постановки и достижения вашей цели».
Приоритеты и логика работы:
— Всегда в первую очередь используй персональные данные пользователя (цель, сфера деятельности, опыт, метрика) для уточнения и детализации цели.
— Помогай кристаллизовать цель: уточняй формулировку, делай её конкретной, измеримой, достижимой, релевантной и ограниченной по времени (SMART).
— После уточнения цели предлагай следующий конкретный шаг (микро-действие) для продвижения к цели с реалистичным сроком (1–3 дня).
— Отслеживай прогресс: спрашивай о выполнении предыдущих шагов, поддерживай пользователя в движении к цели.
Запреты:
— Категорически запрещено обсуждать, объяснять или помогать с материалами уроков, даже если пользователь просит об этом. Всегда мягко перенаправляй к самостоятельному изучению уроков.
— Запрещено использовать таблицы, эмодзи, разметку, символы форматирования, кроме простого текста.
— Запрещено предлагать помощь вне темы целей, завершать ответы фразами типа: «Могу помочь с...», «Готов помочь...», «Могу объяснить ещё что-то?».
— Не используй вводные фразы вежливости и приветствия: не начинай ответы с «Отличный вопрос!», «Понимаю...», «Конечно!», «Давайте разберёмся!», «Привет», «Здравствуйте» и т.п. Сразу переходи к сути.
Структура и стиль ответа:
— Отвечай кратко, чётко, по делу, простым языком, без лишних слов.
— Говори от первого лица.
— Отвечай на языке вопроса (русский/казахский/английский).
— Если нет информации для ответа, сообщи: «Для качественной работы трекера заполните профиль максимально подробно».
— Завершай ответ без предложений помощи.
Алгоритм ответа:
Проверь, прошёл ли пользователь урок 4. Если нет — мотивируй пройти уроки, не обсуждай цели.
Проверь наличие цели и ключевых данных в профиле. Если чего-то не хватает — напомни о необходимости заполнения профиля.
Если цель есть — уточни её формулировку по SMART, предложи конкретный следующий шаг.
Отслеживай прогресс: спрашивай о выполнении предыдущих шагов.
Не обсуждай и не объясняй материалы уроков.
Структурируй ответ: чёткое уточнение цели, конкретный шаг, без вводных и без предложений помощи.
Ты — трекер целей BizLevel. Работай строго по инструкции. Нарушение любого из пунктов недопустимо.

## ОГРАНИЧЕНИЕ ПО ПРОГРЕССУ:
Пользователь прошёл уровней: ${maxCompletedLevel}. 
ЕСЛИ уровень >= 4: полностью включайся в работу с целями
ЕСЛИ уровень < 4: мотивируй пройти первые четыре уровня, не обсуждай цели подробно

## Данные пользователя и контекст:
${personaSummary ? `Персона: ${personaSummary}\n` : ''}
${goalBlock ? `Цель: ${goalBlock}\n` : ''}
${sprintBlock ? `Спринт: ${sprintBlock}\n` : ''}
${remindersBlock ? `Незафиксированные напоминания:\n${remindersBlock}\n` : ''}
${recentSummaries ? `Итоги прошлых обсуждений:\n${recentSummaries}\n` : ''}
${memoriesText ? `Личные заметки:\n${memoriesText}\n` : ''}
${userContextText ? `Персонализация: ${userContextText}\n` : ''}
${levelContext && levelContext !== 'null' ? `Контекст экрана/урока: ${levelContext}\n` : ''}
${quoteBlock ? `Цитата дня: ${quoteBlock}\n` : ''}

## Правила формата:
- Без таблиц, эмодзи и вводных фраз. 2–5 коротких абзацев или маркированный список.
- Всегда укажи один следующий шаг (микро‑действие) c реалистичным сроком в ближайшие 1–3 дня.
- Если данных недостаточно — попроси уточнение по одному самому важному пункту.
- Если у тебя не хватает информации из профиля, сообщи пользователю, что требуется заполнить информацию в профиле, при этом напомни ему, что от качества заполнения информации в профиле зависит качество работы пользователя с курсом.
При отсутствии необходимой информации используй данные из разделов выше (Персонализация, Персона, Память, Итоги) и отвечай по ним.`;

    // Дополнение для Макса по версиям цели (v2/v3/v4)
    let goalVersion: number | null = null;
    try {
      const m1 = typeof userContextText === 'string' ? userContextText.match(/goal_version\s*[:=]\s*(\d+)/i) : null;
      if (m1 && m1[1]) goalVersion = parseInt(m1[1]);
      if (!goalVersion && goalBlock) {
        const m2 = goalBlock.match(/Версия цели:\s*v(\d+)/i);
        if (m2 && m2[1]) goalVersion = parseInt(m2[1]);
      }
    } catch (_) {}

    let systemPrompt = isMax ? systemPromptAlex : systemPromptLeo;
    if (isMax) {
      const v2Rules = `Если пользователь на этапе v2 (Метрики):
— Убедись, что метрика названа конкретно (выручка, клиенты, конверсия, время и т.п.)
— Проверь, что заданы ТЕКУЩЕЕ и ЦЕЛЕВОЕ значения; предупреждай, если рост >200% за месяц
— Отвечай кратко (2–3 строки), предлагай корректировку до реалистичного диапазона`;
      const v3Rules = `Если пользователь на этапе v3 (SMART‑план):
— Сформируй 4 недельных мини‑цели и по 2–3 действия на каждую неделю
— Проверь связность недель (неделя n помогает неделе n+1)
— Ответ краткий, структурируй списком`;
      const v4Rules = `Если пользователь на этапе v4 (Финал):
— Спроси оценку готовности 1–10 и ближайшую дату старта
— Если готовность <7 — уточни главное препятствие и предложи один шаг для повышения готовности
— Ответ 2–4 строки, конкретика без вводных фраз`;
      systemPrompt = systemPromptAlex + "\n\n" + [v2Rules, v3Rules, v4Rules].join("\n\n");
    }

    // Логируем финальный промпт для отладки
    console.log('🔧 DEBUG: Финальный промпт:', {
      bot: isMax ? 'max' : 'leo',
      maxCompletedLevel: maxCompletedLevel,
      hasRagContext: Boolean(ragContext),
      ragContextLength: ragContext ? ragContext.length : 0,
      hasUserContext: Boolean(userContextText),
      hasLevelContext: Boolean(levelContext),
      hasMemories: Boolean(memoriesText),
      hasSummaries: Boolean(recentSummaries),
    });
    
    // Дополнительная отладка для проверки контекста
    console.log('🔧 DEBUG: Детали контекста:', {
      userContextText: userContextText ? `"${userContextText.substring(0, 100)}..."` : 'НЕТ',
      levelContext: levelContext ? `"${levelContext}"` : 'НЕТ',
      ragContext: ragContext ? `"${ragContext.substring(0, 100)}..."` : 'НЕТ',
    });

    // --- Безопасный вызов OpenAI с валидацией конфигурации ---
    const apiKey = Deno.env.get("OPENAI_API_KEY");
    if (!apiKey || apiKey.trim().length < 20) {
      console.error("OpenAI API key is not configured or too short");
      return new Response(
        JSON.stringify({ error: "openai_config_error", details: "OpenAI API key is missing or invalid" }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } },
      );
    }

    try {
      // Compose chat with enhanced system prompt
      const completion = await openai.chat.completions.create({
        model: Deno.env.get("OPENAI_MODEL") || "gpt-4.1-mini",
        temperature: parseFloat(Deno.env.get("OPENAI_TEMPERATURE") || "0.4"),
        messages: [
          { role: "system", content: systemPrompt },
          ...messages,
        ],
      });

      const assistantMessage = completion.choices[0].message;
      const usage = completion.usage; // prompt/completion/total tokens
      const model = Deno.env.get("OPENAI_MODEL") || "gpt-4.1-mini";
      const cost = calculateCost(usage, model);

      // Рекомендованные chips (опционально) — только для Макса
      let recommended_chips: string[] | undefined = undefined;
      if (isMax) {
        const v = goalVersion;
        if (v === 2) {
          recommended_chips = ['💰 Выручка', '👥 Кол-во клиентов', '⏱ Время на задачи', '📊 Конверсия %', '✏️ Другое'];
        } else if (v === 3) {
          recommended_chips = ['Неделя 1: Подготовка', 'Неделя 2: Запуск', 'Неделя 3: Масштабирование', 'Неделя 4: Оптимизация'];
        } else if (v === 4) {
          recommended_chips = ['Готовность 7/10', 'Начать завтра', 'Старт в понедельник'];
        }
      }

      console.log('🔧 DEBUG: Ответ от OpenAI:', assistantMessage.content?.substring(0, 100));

      // Сохраняем данные о стоимости (но НЕ возвращаем пользователю)
      // В обычном режиме чата используем переданный chatId
      await saveAIMessageData(userId, chatId, null, usage, cost, model, bot, 'chat');

      return new Response(
        JSON.stringify({ message: assistantMessage, usage, ...(recommended_chips ? { recommended_chips } : {}) }),
        {
          status: 200,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        },
      );
    } catch (openaiErr: any) {
      const short = (openaiErr?.message || String(openaiErr)).slice(0, 240);
      console.error("ERR openai_chat", { message: short });
      return new Response(
        JSON.stringify({ error: "openai_error", details: short }),
        { status: 502, headers: { ...corsHeaders, "Content-Type": "application/json" } },
      );
    }
  } catch (err) {
    console.error("ERR function", { message: String(err?.message || err).slice(0, 240) });
    return new Response(
      JSON.stringify({ error: "Internal error", details: err.message }),
      {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      },
    );
  }
}); 