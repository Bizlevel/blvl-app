// @ts-nocheck
import { serve } from "https://deno.land/std@0.192.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.7.0";
import OpenAI from "https://deno.land/x/openai@v4.20.1/mod.ts";

const corsHeaders: Record<string, string> = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

const supabaseAdmin = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
);

const openai = new OpenAI();

type ChatMessage = { role: "system" | "user" | "assistant"; content: string };

function normalizeMemory(text: string): string {
  if (!text) return "";
  let s = text.trim();
  // Collapse whitespace
  s = s.replace(/\s+/g, " ");
  // Strip quotes around
  s = s.replace(/^"|"$/g, "");
  // Remove simple PII (emails, phones)
  s = s.replace(/[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}/gi, "[email]");
  s = s.replace(/\+?\d[\d\s\-()]{7,}\d/g, "[phone]");
  // Limit length
  if (s.length > 280) s = s.slice(0, 280) + "…";
  return s;
}

async function extractAndUpsertMemoriesForUser(userId: string, chatMessages: ChatMessage[], maxMemories: number): Promise<number> {
  const transcript = (chatMessages as ChatMessage[])
    .filter(m => m && typeof m.content === 'string')
    .map(m => `${m.role.toUpperCase()}: ${m.content}`)
    .join("\n");

  const extractPrompt = `Ты аналитик. Извлеки максимум ${maxMemories} кратких фактoв о пользователе для долговременной памяти.
Правила:\n- Только факты, полезные для персонализации: цели, предпочтения, ограничения, стиль, опыт, бизнес-контекст\n- Один факт — одна короткая строка (5–20 слов), без местоимений, без частных цитат\n- Без PII (e-mail, телефоны)\n- Ответ строго в JSON-массиве строк: ["факт 1", "факт 2", ...]\n\nДиалог:\n${transcript}`;

  const completion = await openai.chat.completions.create({
    model: Deno.env.get("OPENAI_MODEL") || "gpt-4.1-mini",
    temperature: 0,
    messages: [
      { role: "system", content: "Извлекай структурированные факты, отвечай строго JSON-массивом строк." },
      { role: "user", content: extractPrompt },
    ],
  });

  const raw = completion.choices?.[0]?.message?.content?.trim() || "[]";
  let extracted: string[] = [];
  try {
    extracted = JSON.parse(raw);
    if (!Array.isArray(extracted)) extracted = [];
  } catch {
    extracted = [];
  }

  const normalizedSet = new Set<string>();
  for (const m of extracted) {
    if (typeof m === 'string') {
      const norm = normalizeMemory(m);
      if (norm) normalizedSet.add(norm);
    }
  }
  const memories = Array.from(normalizedSet);
  if (memories.length === 0) return 0;

  const embeddingModel = Deno.env.get("OPENAI_EMBEDDING_MODEL") || "text-embedding-3-small";
  const embRes = await openai.embeddings.create({ model: embeddingModel, input: memories });
  const vectors = embRes.data.map(d => d.embedding);

  const rows = memories.map((content, i) => ({
    user_id: userId,
    content,
    embedding: vectors[i],
    weight: 1,
    updated_at: new Date().toISOString(),
  }));

  const { error: upsertErr } = await supabaseAdmin
    .from('user_memories')
    .upsert(rows, { onConflict: 'user_id,content' });
  if (upsertErr) {
    console.error('user_memories upsert error:', upsertErr.message);
    throw new Error(`upsert_failed: ${upsertErr.message}`);
  }
  return rows.length;
}

serve(async (req: Request): Promise<Response> => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    let body: any = {};
    try { body = await req.json(); } catch { body = {}; }
    const { messages, maxMemories = 8, mode, job } = body;

    // Cron/trigger mode: authorized by secret header
    const cronSecret = req.headers.get('x-cron-secret');
    if (cronSecret && cronSecret === Deno.env.get('LEO_MEMORY_CRON_SECRET')) {
      const windowMin = parseInt(Deno.env.get('LEO_MEMORY_WINDOW_MINUTES') || '3');
      const maxPerUser = parseInt(Deno.env.get('LEO_MEMORY_MAX_PER_USER') || '40');
      const sinceIso = new Date(Date.now() - windowMin * 60 * 1000).toISOString();

      // If payload provided from trigger, process it idempotently and return 202 quickly
      if (job && typeof job === 'object' && job.message_id && job.user_id) {
        try {
          // idempotency: mark processed if not exists
          await supabaseAdmin.from('leo_messages_processed')
            .upsert({ message_id: job.message_id as string });
          // Fetch last small window of messages for this chat to build short transcript
          const { data: msgs } = await supabaseAdmin
            .from('leo_messages')
            .select('role, content, created_at')
            .eq('chat_id', job.chat_id as string)
            .order('created_at', { ascending: false })
            .limit(maxPerUser);
          const arr = Array.isArray(msgs) ? msgs.reverse() : [];
          const chatMsgs = arr.map((m: any) => ({ role: (m.role === 'assistant' || m.role === 'system') ? m.role : 'user', content: m.content || '' }));
          await extractAndUpsertMemoriesForUser(job.user_id as string, chatMsgs, maxMemories);
          // Also update chat summaries for this chat
          if ((job.chat_id as string)) {
            const transcript = chatMsgs.map(m => `${m.role.toUpperCase()}: ${m.content}`).join('\n');
            const prompt = `Ты аналитик беседы. Сжато подведи итог и выдели темы. Верни строго JSON {"summary":"...","topics":[...max 5]}.\nДиалог:\n${transcript}`;
            const comp = await openai.chat.completions.create({
              model: Deno.env.get('OPENAI_MODEL') || 'gpt-4.1-mini',
              temperature: 0,
              messages: [
                { role: 'system', content: 'Резюмируй беседу коротко и выдели темы. Отвечай строго JSON.' },
                { role: 'user', content: prompt },
              ],
            });
            let summary = '';
            let topics: string[] = [];
            try {
              const parsed = JSON.parse(comp.choices?.[0]?.message?.content?.trim() || '{}');
              if (parsed && typeof parsed === 'object') {
                summary = typeof parsed.summary === 'string' ? parsed.summary : '';
                topics = Array.isArray(parsed.topics) ? parsed.topics.filter((t: any) => typeof t === 'string').slice(0, 5) : [];
              }
            } catch {}
            await supabaseAdmin.from('leo_chats').update({
              summary,
              last_topics: topics,
              updated_at: new Date().toISOString(),
            }).eq('id', job.chat_id as string);
          }
          return new Response(JSON.stringify({ status: 'accepted' }), { status: 202, headers: { ...corsHeaders, 'Content-Type': 'application/json' } });
        } catch (e) {
          console.error('trigger job failed:', e);
          return new Response(JSON.stringify({ error: 'job_failed' }), { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } });
        }
      }

      // 1) Fetch recent messages
      const { data: msgs, error: mErr } = await supabaseAdmin
        .from('leo_messages')
        .select('id, chat_id, role, content, created_at')
        .gte('created_at', sinceIso);
      if (mErr) throw new Error(`messages_fetch_failed: ${mErr.message}`);
      const allMsgs = Array.isArray(msgs) ? msgs : [];

      if (allMsgs.length === 0) {
        return new Response(JSON.stringify({ processed_users: 0, processed_messages: 0 }), { headers: { ...corsHeaders, 'Content-Type': 'application/json' } });
      }

      const messageIds = allMsgs.map((m: any) => m.id);
      // 2) Load processed ids
      const { data: processedRows, error: pErr } = await supabaseAdmin
        .from('leo_messages_processed')
        .select('message_id')
        .in('message_id', messageIds);
      if (pErr) throw new Error(`processed_fetch_failed: ${pErr.message}`);
      const processedSet = new Set((processedRows || []).map((r: any) => r.message_id));

      // 3) Load chats → user mapping
      const chatIds = Array.from(new Set(allMsgs.map((m: any) => m.chat_id)));
      const { data: chats, error: cErr } = await supabaseAdmin
        .from('leo_chats')
        .select('id, user_id')
        .in('id', chatIds);
      if (cErr) throw new Error(`chats_fetch_failed: ${cErr.message}`);
      const chatToUser = new Map<string, string>();
      (chats || []).forEach((c: any) => { if (c && c.id && c.user_id) chatToUser.set(c.id, c.user_id); });

      // 4) Group by user and by chat, build message arrays (skip already processed)
      const perUser: Record<string, ChatMessage[]> = {};
      const perChat: Record<string, ChatMessage[]> = {};
      const toMarkProcessed: string[] = [];
      for (const m of allMsgs) {
        if (!m || processedSet.has(m.id)) continue;
        const userId = chatToUser.get(m.chat_id);
        if (!userId) continue;
        const role = (m.role === 'assistant' || m.role === 'system') ? m.role : 'user';
        if (!perUser[userId]) perUser[userId] = [];
        if (perUser[userId].length < maxPerUser) {
          perUser[userId].push({ role, content: m.content || '' });
          toMarkProcessed.push(m.id);
        }
        if (!perChat[m.chat_id]) perChat[m.chat_id] = [];
        if (perChat[m.chat_id].length < maxPerUser) {
          perChat[m.chat_id].push({ role, content: m.content || '' });
        }
      }

      // 5) Extract and upsert per user
      let usersProcessed = 0, messagesProcessed = toMarkProcessed.length, factsSaved = 0;
      for (const [uid, msgsArr] of Object.entries(perUser)) {
        if (msgsArr.length === 0) continue;
        try {
          const saved = await extractAndUpsertMemoriesForUser(uid, msgsArr, maxMemories);
          factsSaved += saved;
          usersProcessed += 1;
        } catch (e) {
          console.error('extract/upsert per user failed:', uid, e);
        }
      }

      // 6) Build chat summaries & last topics
      for (const [chatId, chatMsgs] of Object.entries(perChat)) {
        if (chatMsgs.length === 0) continue;
        try {
          const chatTranscript = chatMsgs
            .filter(m => m && typeof m.content === 'string')
            .map(m => `${m.role.toUpperCase()}: ${m.content}`)
            .join('\n');
          const prompt = `Ты аналитик беседы. Сжато подведи итог и выдели темы. Верни строго JSON вида {"summary": "строка", "topics": ["тема1", ...] (max 5)}.\nДиалог:\n${chatTranscript}`;
          const comp = await openai.chat.completions.create({
            model: Deno.env.get('OPENAI_MODEL') || 'gpt-4.1-mini',
            temperature: 0,
            messages: [
              { role: 'system', content: 'Резюмируй беседу коротко и выдели темы. Отвечай строго JSON.' },
              { role: 'user', content: prompt },
            ],
          });
          let summary = '';
          let topics: string[] = [];
          try {
            const parsed = JSON.parse(comp.choices?.[0]?.message?.content?.trim() || '{}');
            if (parsed && typeof parsed === 'object') {
              summary = typeof parsed.summary === 'string' ? parsed.summary : '';
              topics = Array.isArray(parsed.topics) ? parsed.topics.filter((t: any) => typeof t === 'string').slice(0, 5) : [];
            }
          } catch (_) { /* ignore parse errors */ }
          await supabaseAdmin.from('leo_chats').update({
            summary,
            last_topics: topics,
            updated_at: new Date().toISOString(),
          }).eq('id', chatId);
        } catch (e) {
          console.error('chat summary failed:', chatId, e);
        }
      }

      // 7) Mark processed
      if (toMarkProcessed.length > 0) {
        const rows = toMarkProcessed.map(id => ({ message_id: id }));
        const { error: markErr } = await supabaseAdmin
          .from('leo_messages_processed')
          .upsert(rows, { onConflict: 'message_id' });
        if (markErr) console.error('mark processed failed:', markErr.message);
      }

      return new Response(
        JSON.stringify({ usersProcessed, messagesProcessed, factsSaved }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
      );
    }

    // Fallback: direct mode (per-user body), requires Bearer user
    if (!Array.isArray(messages)) {
      return new Response(
        JSON.stringify({ error: "messages must be an array" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } },
      );
    }

    const authHeader = req.headers.get("Authorization") || req.headers.get("authorization");
    if (!authHeader?.startsWith("Bearer ")) {
      return new Response(
        JSON.stringify({ error: "missing bearer token" }),
        { status: 401, headers: { ...corsHeaders, "Content-Type": "application/json" } },
      );
    }
    const jwt = authHeader.replace("Bearer ", "");
    const { data: { user }, error: authErr } = await supabaseAdmin.auth.getUser(jwt);
    if (authErr || !user) {
      return new Response(
        JSON.stringify({ error: "unauthorized" }),
        { status: 401, headers: { ...corsHeaders, "Content-Type": "application/json" } },
      );
    }

    const saved = await extractAndUpsertMemoriesForUser(user.id, messages as ChatMessage[], maxMemories);
    return new Response(JSON.stringify({ user_id: user.id, saved }), { headers: { ...corsHeaders, 'Content-Type': 'application/json' } });
  } catch (err) {
    console.error('leo-memory error:', err);
    return new Response(
      JSON.stringify({ error: 'internal_error', details: (err as Error).message }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }
});


