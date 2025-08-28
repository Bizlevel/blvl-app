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
    // Read request body once to support additional parameters
    const body = await req.json();
    const mode = typeof body?.mode === 'string' ? String(body.mode) : '';
    const messages = body?.messages;
    const userContext = body?.userContext;
    const levelContext = body?.levelContext;
    const knowledgeContext = body?.knowledgeContext;
    let bot: string = typeof body?.bot === 'string' ? String(body.bot) : 'leo';
    // Backward compatibility: treat 'alex' as 'max'
    if (bot === 'alex') bot = 'max';
    const isMax = bot === 'max';

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
Если ответ верный: поздравь (1 фраза) и добавь 2–3 строки, как применить знание с учётом персонализации пользователя (если передана).`;

        const userMsgParts = [
          question ? `Вопрос: ${question}` : '',
          options.length ? `Варианты: ${options.join(' | ')}` : '',
          `Выбранный индекс: ${selectedIndex}`,
          `Правильный индекс: ${correctIndex}`,
          typeof userContext === 'string' && userContext.trim() ? `Персонализация: ${userContext.trim()}` : '',
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
    let userContextText = "";
    let profileText = ""; // формируем отдельно, чтобы при отсутствии JWT всё равно использовать client userContext
    let personaSummary = "";
    let userId: string | null = null;

    // No PII: do not log tokens, only presence
    console.log('INFO auth_header_present', { present: Boolean(authHeader) });
    
    if (authHeader?.startsWith("Bearer ")) {
      const jwt = authHeader.replace("Bearer ", "");
      // Do not log JWT content or length

      const { data: { user }, error } = await supabaseAdmin.auth.getUser(jwt);
      console.log('INFO auth_get_user', { ok: !error, user: user?.id ? 'present' : 'absent' });

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
    }

    // Объединяем профиль и клиентский контекст независимо от авторизации
    if (typeof userContext === 'string' && userContext.trim().length > 0) {
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
            console.error('ERR rag_match_documents', { message: matchError.message });
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
      knowledgeContext_present: Boolean(knowledgeContext),
      bot: isMax ? 'max' : 'leo',
      mode,
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

    // Alex (goal tracker) prompt — коротко, конкретно, приоритет цели/спринтов
    const systemPromptAlex = `## Твоя роль и тон:
Ты — Макс, трекер цели BizLevel. Отвечай коротко, конкретно и по делу.
Фокус: помочь пользователю сформулировать и кристаллизовать цель, поддерживать её достижение в 28‑дневных спринтах.
Представляйся только в первом ответе новой сессии или если пользователь явно спрашивает «кто ты?».
Не используй таблицы и не предлагай «дополнительную помощь». Сразу давай следующий шаг.

## Приоритет ответа:
1) Цель и метрики пользователя → 2) Следующие микро‑шаги на сегодня/неделю → 3) Дополнение из базы знаний курса (если нужно) → 4) Краткое завершение.
Если цель присутствует в блоках «Персонализация» или «Цель», НЕ проси пользователя повторять её. Кратко перескажи и предложи шаг. Если данных совсем нет, тогда запроси одно ключевое уточнение.

## Данные пользователя и контекст:
${personaSummary ? `Персона: ${personaSummary}\n` : ''}
${goalBlock ? `Цель: ${goalBlock}\n` : ''}
${sprintBlock ? `Спринт: ${sprintBlock}\n` : ''}
${remindersBlock ? `Незафиксированные напоминания:\n${remindersBlock}\n` : ''}
${recentSummaries ? `Итоги прошлых обсуждений:\n${recentSummaries}\n` : ''}
${memoriesText ? `Личные заметки:\n${memoriesText}\n` : ''}
${userContextText ? `Персонализация: ${userContextText}\n` : ''}
${levelContext ? `Контекст экрана/урока: ${levelContext}\n` : ''}
${quoteBlock ? `Цитата дня: ${quoteBlock}\n` : ''}

## Правила формата:
- Без таблиц, эмодзи и вводных фраз. 2–5 коротких абзацев или маркированный список.
- Всегда укажи один следующий шаг (микро‑действие) c реалистичным сроком в ближайшие 1–3 дня.
- Если данных недостаточно — попроси уточнение по одному самому важному пункту.
- Не говори, что у тебя нет доступа к профилю. Используй данные из разделов выше (Персонализация, Персона, Память, Итоги) и отвечай по ним.`;

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