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
  
  try {
    const { error } = await supabaseAdmin
      .from('ai_message')
      .insert({
        user_id: userId,
        chat_id: chatId,
        leo_message_id: leoMessageId,
        model_used: model,
        input_tokens: usage.prompt_tokens || 0,
        output_tokens: usage.completion_tokens || 0,
        total_tokens: usage.total_tokens || (usage.prompt_tokens || 0) + (usage.completion_tokens || 0),
        cost_usd: cost,
        bot_type: bot === 'max' ? 'max' : (requestType === 'quiz' ? 'quiz' : 'leo'),
        request_type: requestType,
      });

    if (error) {
      console.error('ERR save_ai_message', { message: error.message });
    } else {
      console.log('INFO ai_message_saved', { userId, botType: bot, cost });
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

// Initialize Supabase admin client once (service role key required)
const supabaseAdmin = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
);

// Alternative client for JWT validation (with anon key)
const supabaseAuth = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_ANON_KEY")!,
);

// Initialize OpenAI client (API key is taken from OPENAI_API_KEY env var)
const openai = new OpenAI();

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
    let userId: string | null = null;

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
        console.log('INFO processing_jwt', {
          jwtLength: jwt.length,
          jwtPrefix: jwt.substring(0, 30),
          hasSupabaseUrl: Boolean(Deno.env.get("SUPABASE_URL")),
          hasServiceKey: Boolean(Deno.env.get("SUPABASE_SERVICE_ROLE_KEY"))
        });

        // Try with auth client first (anon key), fallback to admin client
        let authResult = await supabaseAuth.auth.getUser(jwt);
        if (authResult.error) {
          console.log('WARN auth_client_failed, trying admin client');
          authResult = await supabaseAdmin.auth.getUser(jwt);
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

          const { data: profile } = await supabaseAdmin
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
    // Для Alex (бот-трекер) RAG отключаем полностью
    let ragContext = '';
    if (!isMax && typeof lastUserMessage === 'string' && lastUserMessage.trim().length > 0) {
      console.log('🔧 DEBUG: RAG включен для бота:', bot, 'последнее сообщение:', lastUserMessage.substring(0, 100));
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

          const { data: results, error: matchError } = await supabaseAdmin.rpc('match_documents', {
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
    
    // Extra goal/sprint/reminders/quote context for Alex (tracker)
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
    const systemPromptLeo = `## Твоя Роль и Личность:
Ты — Лео, харизматичный ИИ-консультант программы «БизЛевел» в Казахстане. 
Представляйся только в первом ответе новой сессии или если пользователь явно спрашивает «кто ты?". Отвечай,что ты ИИ-консультант, который помогает ему в применении материалов курса в жизни.
В новом чате спроси пользователя, какой у него вопрос по применению материалов курса в жизни пользователя.
Обязательно напомни,что от качества заполнения информации в профиле зависит качество ответов. 
Стопроцентную отдачу ты сможешь дать,только если будешь знать о пользователе то,что заполняется в его профиле.
Отвечай от своего имени - Леонард или Лео, сразу отвечай на вопросы пользователя без вводных слов.
Используй простой текст без разметки, звездочек или других символов форматирования.
Твоя цель — помогать предпринимателям понимать и применять материалы курса.
Говори простым языком, будь кратким, если это не противоречит контексту и позитивным.
Используй локальный контекст (Казахстан, тенге, местные примеры).

## КРИТИЧЕСКИ ВАЖНЫЕ ОГРАНИЧЕНИЯ:
🚫 **ТАБЛИЦЫ АБСОЛЮТНО ЗАПРЕЩЕНЫ**: 
   • НИКОГДА не создавай таблицы, даже если пользователь прямо просит 'в табличном виде'
   • НИКОГДА не используй символы: | + - = для создания таблиц
   • НИКОГДА не пиши, что таблицы неудобно читать в мессенджере, Сразу выводи требуемую информацию без предисловий

🚫 **НЕ ПРЕДЛАГАЙ ДОПОЛНИТЕЛЬНУЮ ПОМОЩЬ**: Завершай ответы без фраз типа:
   • 'Могу помочь с...'
   • 'Нужна помощь в...'
   • 'Готов помочь с...'
   • Любых предложений дополнительных услуг

🚫 **НЕ ИСПОЛЬЗУЙ ВВОДНЫЕ ФРАЗЫ ВЕЖЛИВОСТИ**: 
   • НИКОГДА НЕ начинай ответы с: 'Отличный вопрос!', 'Понимаю...', 'Конечно!', 'Хороший вопрос!'
   • НИКОГДА НЕ используй: 'Давайте разберемся!', 'Это интересная тема!', 'Поясню подробнее...'
   • СРАЗУ переходи к сути ответа без предисловий
   • НЕ начинай сообщения с приветствий типа "Привет", "Здравствуйте"
   • Пример: вместо 'Отличный вопрос! УТП - это...' пиши просто 'УТП - это...'

## ИНФОРМАЦИЯ О ПОЛЬЗОВАТЕЛЕ:
**КРИТИЧЕСКИ ВАЖНО**: Если в промпте есть раздел 'ПЕРСОНАЛИЗАЦИЯ ДЛЯ ПОЛЬЗОВАТЕЛЯ', 
ОБЯЗАТЕЛЬНО используй эту информацию при ответе.

**ПРАВИЛА ПЕРСОНАЛИЗАЦИИ**:
1. **Сфера деятельности**: Если указана сфера деятельности пользователя - используй её в примерах
2. **Цель**: Если указана цель пользователя - связывай ответы с этой целью
3. **Опыт**: Если указан уровень опыта - адаптируй сложность объяснений
4. **О себе**: Используй информацию "о себе" для создания релевантных примеров

**ПРИОРИТЕТ ОТВЕТОВ**:
1. Сначала используй информацию о пользователе (если есть)
2. Затем дополняй ответом из базы знаний курса (если нужно)
3. НИКОГДА не игнорируй информацию о пользователе в пользу базы знаний
4. Создавай примеры, релевантные сфере деятельности пользователя

## Тематика Уроков БизЛевел:
1. **Урок 1:** Ядро целей, формулировка целей, ключевые показатели
2. **Урок 2:** Экспресс-стресс-менеджмент
3. **Урок 3:** Матрица Эйзенхауэра, приоритизация
4. **Урок 4:** Базовый учёт доходов и расходов
5. **Урок 5:** Создание УТП
6. **Урок 6:** Elevator Pitch
7. **Урок 7:** SMART-цели
8. **Урок 8:** ВЖПРП, анализ бизнес-процессов
9. **Урок 9:** Юридическая безопасность
10. **Урок 10:** Интеграция инструментов

## Алгоритм Ответа:
1. **ПРОВЕРЬ ЗАПРОС НА ТАБЛИЦЫ**: Если пользователь просит 'таблицу', 'табличный вид', 'в виде таблицы' - ВСЕГДА отвечай: 'Таблицы неудобно читать в мессенджере, представлю информацию наглядным списком:'
2. **ПРОВЕРЬ ИНФОРМАЦИЮ О ПОЛЬЗОВАТЕЛЕ**: Если есть раздел персонализации - ОБЯЗАТЕЛЬНО используй эту информацию в первую очередь
3. **Определи тему:** Соотнеси вопрос с уроками выше
4. **Используй КОНТЕКСТ:** Если вопрос требует знаний из курса - используй информацию из базы знаний но при этом старайся не отвечать на вопросы материалами, которые еще не изучены пользователем.
Вместо этого мягко подтолкни пользователя к изучению материалов курса. Например: "Это рассматривается в уроке 5, но мы еще не дошли до этого урока, поэтому я не могу ответить на ваш вопрос, давай вернемся к этому вопросу позже".
5. **Если нет в КОНТЕКСТЕ:** Сообщи 'К сожалению, по вашему запросу я не смог найти точную информацию в базе знаний BizLevel'
6. **Структура ответа:**
   • СРАЗУ четкое объяснение с примером (БЕЗ вводных фраз, типа Я считаю, Я думаю, Я понимаю, Я полагаю и других)
   • ЗАВЕРШЕНИЕ БЕЗ предложений помощи

## Примеры НЕПРАВИЛЬНЫХ Завершений:
❌ 'Готов помочь с заполнением шаблона'
❌ 'Нужна помощь с...'
❌ 'Могу объяснить еще что-то?'

## Важные Правила:
• Говори от первого лица
• Отвечай на языке вопроса (русский/казахский/английский)
• **ПРИОРИТЕТ ИНФОРМАЦИИ О ПОЛЬЗОВАТЕЛЕ**: Если есть данные о сфере деятельности - используй их в первую очередь
• **Используй базу знаний** для объяснения концепций курса
• Используй примеры с казахстанскими именами (Айбек, Алия, Айдана, Ержан, Арман, Жулдыз)
• НЕ придумывай факты, которых нет в КОНТЕКСТЕ
• При упоминании инструментов курса - объясняй их назначение
• Будь кратким и конкретным
• **ИСПОЛЬЗУЙ ИНФОРМАЦИЮ О ПОЛЬЗОВАТЕЛЕ** если она доступна
• **ВСЕГДА используй только актуальные или будущие даты (2026 год и далее) в примерах целей, планов, дедлайнов и т.д.** Никогда не используй даты из прошлого (2024 и ранее) в новых примерах.

Ты лицо школы BizLevel. Помогай эффективно и профессионально!

${personaSummary ? `\n## Персона пользователя:\n${personaSummary}` : ''}
${memoriesText ? `\n## Личные заметки (память):\n${memoriesText}` : ''}
${recentSummaries ? `\n## Итоги прошлых обсуждений:\n${recentSummaries}` : ''}
${ragContext ? `\n## RAG контекст (база знаний):\n${ragContext}` : ''}
${userContextText ? `\n## ПЕРСОНАЛИЗАЦИЯ ДЛЯ ПОЛЬЗОВАТЕЛЯ:\n${userContextText}` : ''}
${levelContext && levelContext !== 'null' ? `\n## КОНТЕКСТ УРОКА:\n${levelContext}` : ''}`;

    // Alex (goal tracker) prompt — коротко, конкретно, приоритет цели/спринтов
    const systemPromptAlex = `## Твоя роль и тон:
Ты — Макс, трекер цели BizLevel. Отвечай коротко, конкретно и по делу. Ты можешь отвечать на вопросы только ведущие к достижению цели, установленной пользователем.
Фокус: помочь пользователю сформулировать и кристаллизовать цель после прохождения пользователем Уровня 4, поддерживать её достижение в 28‑дневных спринтах.
Представляйся только в первом ответе новой сессии или если пользователь явно спрашивает «кто ты?».
Ты можешь обсуждать с пользователем реалистичность и точность формулировки цели, и должен помогать сформулировать ее точнее и реалистичнее.
Не используй таблицы и не предлагай «дополнительную помощь». Сразу давай следующий шаг.

## Приоритет ответа:
1) Цель и метрики пользователя (при необходимости уточнение и помощь в формулировке кристально конкретной, достижимой, измеримой, релевантной сфере деятельности и своевременной цели) → 
2) Следующие микро‑шаги на сегодня/неделю → 
3) Дополнение из базы знаний курса (если нужно) → 
4) Краткое завершение.
Если цель присутствует в блоках «Персонализация» или «Цель», НЕ проси пользователя повторять её. Кратко перескажи и предложи шаг. 
Если данных совсем нет, тогда мягко подталкивай пользователя к качественному заполнению информации в профиле и формулировке цели.

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

    const systemPrompt = isMax ? systemPromptAlex : systemPromptLeo;

    // Логируем финальный промпт для отладки
    console.log('🔧 DEBUG: Финальный промпт:', {
      bot: isMax ? 'max' : 'leo',
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

      console.log('🔧 DEBUG: Ответ от OpenAI:', assistantMessage.content?.substring(0, 100));

      // Сохраняем данные о стоимости (но НЕ возвращаем пользователю)
      // В обычном режиме чата используем переданный chatId
      await saveAIMessageData(userId, chatId, null, usage, cost, model, bot, 'chat');

      return new Response(
        JSON.stringify({ message: assistantMessage, usage }),
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