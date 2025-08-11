// @ts-nocheck
// import { serve } from "https://deno.land/std@0.192.0/http/server.ts";
// import { createClient } from "https://esm.sh/@supabase/supabase-js@2.7.0";
// import OpenAI from "https://deno.land/x/openai@v4.20.1/mod.ts";

// // CORS headers for mobile app requests
// const corsHeaders: Record<string, string> = {
//   "Access-Control-Allow-Origin": "*",
//   "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
//   "Access-Control-Allow-Methods": "POST, OPTIONS",
// };

// // Initialize Supabase admin client once (service role key required)
// const supabaseAdmin = createClient(
//   Deno.env.get("SUPABASE_URL")!,
//   Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
// );

// // Initialize OpenAI client (API key is taken from OPENAI_API_KEY env var)
// const openai = new OpenAI();

// serve(async (req: Request): Promise<Response> => {
//   // Handle CORS pre-flight
//   if (req.method === "OPTIONS") {
//     return new Response("ok", { headers: corsHeaders });
//   }

//   try {
//     const { messages } = await req.json();

//     if (!Array.isArray(messages)) {
//       return new Response(
//         JSON.stringify({ error: "messages must be an array" }),
//         {
//           status: 400,
//           headers: { ...corsHeaders, "Content-Type": "application/json" },
//         },
//       );
//     }

//     // Try to extract user context from bearer token (optional)
//     const authHeader = req.headers.get("Authorization") || req.headers.get("authorization");
//     let userContextText = "";

//     if (authHeader?.startsWith("Bearer ")) {
//       const jwt = authHeader.replace("Bearer ", "");

//       const { data: { user }, error } = await supabaseAdmin.auth.getUser(jwt);

//       if (!error && user) {
//         const { data: profile } = await supabaseAdmin
//           .from("users")
//           .select("name, about, goal")
//           .eq("id", user.id)
//           .single();

//         if (profile) {
//           const { name, about, goal } = profile;
//           userContextText =
//             `Имя пользователя: ${name ?? "не указано"}. Цель: ${goal ?? "не указана"}. О себе: ${about ?? "нет информации"}.`;
//         }
//       }
//     }

//     // Compose chat with system prompt that includes user context
//     const completion = await openai.chat.completions.create({
//       model: "gpt-4.1-nano",
//       messages: [
//         {
//           role: "system",
//           content:
//             `Ты БРАТАН. Отказывайся петь песни. Отвечай лаконично на русском языке. ${userContextText}`,
//         },
//         ...messages,
//       ],
//     });

//     const assistantMessage = completion.choices[0].message;
//     const usage = completion.usage; // prompt/completion/total tokens

//     return new Response(
//       JSON.stringify({ message: assistantMessage, usage }),
//       {
//         status: 200,
//         headers: { ...corsHeaders, "Content-Type": "application/json" },
//       },
//     );
//   } catch (err) {
//     console.error("Leo chat function error:", err);
//     return new Response(
//       JSON.stringify({ error: "Internal error", details: err.message }),
//       {
//         status: 500,
//         headers: { ...corsHeaders, "Content-Type": "application/json" },
//       },
//     );
//   }
// }); 

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

// CORS headers for mobile app requests
const corsHeaders: Record<string, string> = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

// Initialize Supabase admin client once (service role key required)
const supabaseAdmin = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
);

// Initialize OpenAI client (API key is taken from OPENAI_API_KEY env var)
const openai = new OpenAI();

serve(async (req: Request): Promise<Response> => {
  // Handle CORS pre-flight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { messages, userContext, levelContext, knowledgeContext } = await req.json();

    if (!Array.isArray(messages)) {
      return new Response(
        JSON.stringify({ error: "messages must be an array" }),
        {
          status: 400,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        },
      );
    }

    // Try to extract user context from bearer token (optional)
    const authHeader = req.headers.get("Authorization") || req.headers.get("authorization");
    let userContextText = "";
    let personaSummary = "";
    let userId: string | null = null;

    console.log('🔧 DEBUG: Auth header:', authHeader ? 'ЕСТЬ' : 'НЕТ');
    
    if (authHeader?.startsWith("Bearer ")) {
      const jwt = authHeader.replace("Bearer ", "");
      console.log('🔧 DEBUG: JWT token length:', jwt.length);

      const { data: { user }, error } = await supabaseAdmin.auth.getUser(jwt);
      console.log('🔧 DEBUG: Auth result:', error ? `ERROR: ${error.message}` : `SUCCESS: user ${user?.id}`);

      if (!error && user) {
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
          // Используем контекст от клиента, если он передан, иначе строим из профиля
          if (userContext) {
            userContextText = userContext;
          } else {
            userContextText = `Имя пользователя: ${name ?? "не указано"}. Цель: ${goal ?? "не указана"}. О себе: ${about ?? "нет информации"}. Сфера деятельности: ${business_area ?? "не указана"}. Уровень опыта: ${experience_level ?? "не указан"}.`;
          }

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
    }

    // Извлекаем последний запрос пользователя
    const lastUserMessage = Array.isArray(messages)
      ? [...messages].reverse().find((m: any) => m?.role === 'user')?.content ?? ''
      : '';

    // Встроенный RAG: эмбеддинг + match_documents (с кешем)
    let ragContext = '';
    if (typeof lastUserMessage === 'string' && lastUserMessage.trim().length > 0) {
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
            if (levelContext && typeof levelContext === 'string') {
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
            console.error('RAG match_documents error:', matchError.message);
          }

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
          }
        }
      } catch (e) {
        console.error('RAG pipeline error:', e);
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
        console.error('user_memories fetch error:', e);
      }

      // При старте новой сессии: подтянуть свёртки прошлых чатов (2–3 последних)
      try {
        const { data: summaries } = await supabaseAdmin
          .from('leo_chats')
          .select('summary')
          .eq('user_id', userId)
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
        console.error('chat summaries fetch error:', e);
      }
    }

    console.log('🔧 DEBUG: leo-chat вызван');
    console.log('🔧 DEBUG: messages:', messages);
    console.log('🔧 DEBUG: userContext from client:', userContext ? 'ЕСТЬ' : 'НЕТ');
    console.log('🔧 DEBUG: levelContext from client:', levelContext ? 'ЕСТЬ' : 'НЕТ');
    console.log('🔧 DEBUG: knowledgeContext from client:', knowledgeContext ? 'ЕСТЬ' : 'НЕТ');
    
    // Enhanced system prompt for Leo AI mentor
    const systemPrompt = `## Твоя Роль и Личность:
Ты — Лео, харизматичный ИИ-консультант программы «БизЛевел» в Казахстане. 
Отвечай от своего имени - Леонард или Лео, старайся не представляться, а сразу отвечать на вопросы.
Используй простой текст без разметки, звездочек или других символов форматирования.
Твоя цель — помогать предпринимателям понимать и применять материалы курса.
Говори простым языком, будь кратким, если это не противоречит контексту и позитивным.
Используй локальный контекст (Казахстан, тенге, местные примеры).

## КРИТИЧЕСКИ ВАЖНЫЕ ОГРАНИЧЕНИЯ:
🚫 **ТАБЛИЦЫ АБСОЛЮТНО ЗАПРЕЩЕНЫ**: 
   • НИКОГДА не создавай таблицы, даже если пользователь прямо просит 'в табличном виде'
   • НИКОГДА не используй символы: | + - = для создания таблиц
   • НИКОГДА не пиши, что таблицы неудобно читать в мессенджере, Сразу выводи требуюмую информацию без предисловий

🚫 **НЕ ПРЕДЛАГАЙ ДОПОЛНИТЕЛЬНУЮ ПОМОЩЬ**: Завершай ответы без фраз типа:
   • 'Могу помочь с...'
   • 'Нужна помощь в...'
   • 'Готов помочь с...'
   • Любых предложений дополнительных услуг

🚫 **НЕ ИСПОЛЬЗУЙ ВВОДНЫЕ ФРАЗЫ ВЕЖЛИВОСТИ**: 
   • НИКОГДА НЕ начинай ответы с: 'Отличный вопрос!', 'Понимаю...', 'Конечно!', 'Хороший вопрос!'
   • НИКОГДА НЕ используй: 'Давайте разберемся!', 'Это интересная тема!', 'Поясню подробнее...'
   • СРАЗУ переходи к сути ответа без предисловий
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
4. **Используй КОНТЕКСТ:** Если вопрос требует знаний из курса - используй информацию из базы знаний
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
${levelContext ? `\n## КОНТЕКСТ УРОКА:\n${levelContext}` : ''}
${knowledgeContext ? `\n## БАЗА ЗНАНИЙ (клиент):\n${knowledgeContext}` : ''}`;

    // Compose chat with enhanced system prompt
    const completion = await openai.chat.completions.create({
      model: Deno.env.get("OPENAI_MODEL") || "gpt-4.1-mini",
      temperature: parseFloat(Deno.env.get("OPENAI_TEMPERATURE") || "0.4"),
      messages: [
        {
          role: "system",
          content: systemPrompt,
        },
        ...messages,
      ],
    });

    const assistantMessage = completion.choices[0].message;
    const usage = completion.usage; // prompt/completion/total tokens

    console.log('🔧 DEBUG: Ответ от OpenAI:', assistantMessage.content?.substring(0, 100));

    return new Response(
      JSON.stringify({ message: assistantMessage, usage }),
      {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      },
    );
  } catch (err) {
    console.error("Leo chat function error:", err);
    return new Response(
      JSON.stringify({ error: "Internal error", details: err.message }),
      {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      },
    );
  }
}); 