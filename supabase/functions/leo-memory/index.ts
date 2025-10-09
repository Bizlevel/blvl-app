// @ts-nocheck
import { serve } from "https://deno.land/std@0.192.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.7.0";
import OpenAI from "https://esm.sh/openai@4.20.1";

const corsHeaders: Record<string, string> = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type, x-cron-secret",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

const supabaseAdmin = createClient(
  Deno.env.get("SUPABASE_URL"),
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")
);

const openai = new OpenAI();

function normalizeMemory(text: string): string {
  if (!text) return "";
  let s = text.trim();
  s = s.replace(/\s+/g, " ");
  s = s.replace(/^"|"$/g, "");
  s = s.replace(/[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}/gi, "[email]");
  s = s.replace(/\+?\d[\d\s\-()]{7,}\d/g, "[phone]");
  if (s.length > 280) s = s.slice(0, 280) + "…";
  return s;
}

async function extractAndUpsertMemoriesForUser(
  userId: string,
  chatMessages: Array<{ role: string; content: string }>,
  maxMemories: number
): Promise<number> {
  if (chatMessages.length === 0) {
    console.log('⚠️ No chat messages to process');
    return 0;
  }

  // 1) Фильтрация качества: только сообщения пользователя, длина >= 50, без односложных ответов
  const meaningful = chatMessages
    .filter((m) => m && m.role === 'user' && typeof m.content === 'string')
    .map((m) => ({ ...m, content: (m.content || '').trim() }))
    .filter((m) => m.content.length >= 50)
    .filter((m) => !/^\s*(да|нет|ок|спасибо|привет)\b/i.test(m.content));

  if (meaningful.length === 0) {
    console.log('⚠️ No meaningful user messages (>=50 chars)');
    return 0;
  }

  const transcript = meaningful
    .map((m) => `${m.role.toUpperCase()}: ${m.content}`)
    .join('\n');

  const extractPrompt = `Ты аналитик BizLevel. Извлеки максимум ${maxMemories} БИЗНЕС-фактов о пользователе.

ПРИОРИТЕТ 1 (сначала):
- Главная бизнес-цель (месяц) и ключевая метрика (база/цель)
- Сфера/ниша и размер команды/стадия
- Главная боль/препятствие сейчас

ПРИОРИТЕТ 2:
- ЦА/каналы/инструменты, планы ближайших недель

ФОРМАТ:
- Один факт — одна короткая строка (5–20 слов)
- Без местоимений, без цитат, без PII (email/телефоны)
- Ответ строго JSON-массивом строк: ["факт 1", "факт 2", ...]

Диалог:
${transcript}`;

  try {
    const completion = await openai.chat.completions.create({
      model: Deno.env.get("OPENAI_MODEL") || "gpt-4.1-mini",
      temperature: 0,
      messages: [
        {
          role: "system",
          content: "Извлекай структурированные факты, отвечай строго JSON-массивом строк."
        },
        {
          role: "user",
          content: extractPrompt
        }
      ]
    });

    const raw = completion.choices?.[0]?.message?.content?.trim() || "[]";
    let extracted: string[] = [];

    try {
      extracted = JSON.parse(raw);
      if (!Array.isArray(extracted)) {
        console.log('⚠️ OpenAI response is not an array, treating as empty');
        extracted = [];
      }
    } catch (parseError) {
      console.log('❌ Failed to parse OpenAI response as JSON:', parseError);
      extracted = [];
    }

    const normalizedSet = new Set<string>();
    for (const m of extracted) {
      if (typeof m === 'string' && m.trim().length > 0) {
        const norm = normalizeMemory(m);
        if (norm) normalizedSet.add(norm);
      }
    }

    const memories = Array.from(normalizedSet);
    if (memories.length === 0) {
      console.log('⚠️ No valid memories after normalization');
      return 0;
    }

    const embeddingModel = Deno.env.get("OPENAI_EMBEDDING_MODEL") || "text-embedding-3-small";
    const embRes = await openai.embeddings.create({
      model: embeddingModel,
      input: memories
    });

    const vectors = embRes.data.map((d) => d.embedding);
    const rows = memories.map((content, i) => ({
      user_id: userId,
      content,
      embedding: vectors[i],
      weight: 1,
      updated_at: new Date().toISOString()
    }));

    const { error: upsertErr } = await supabaseAdmin
      .from('user_memories')
      .upsert(rows, {
        onConflict: 'user_id,content'
      });

    if (upsertErr) {
      console.error('❌ Database upsert error:', upsertErr.message);
      throw new Error(`upsert_failed: ${upsertErr.message}`);
    }

    console.log(`✅ Successfully saved ${rows.length} memories to database`);

    // 4) Гарантируем лимит «горячих» записей (HOT_MEM_LIMIT, дефолт 50)
    const hotLimit = parseInt(Deno.env.get('HOT_MEM_LIMIT') || '50');
    if (Number.isFinite(hotLimit) && hotLimit > 0) {
      // Получаем все записи пользователя с сортировкой по updated_at desc
      const { data: allMem, error: selErr } = await supabaseAdmin
        .from('user_memories')
        .select('id, user_id, content, created_at')
        .eq('user_id', userId)
        .order('updated_at', { ascending: false });
      if (!selErr && Array.isArray(allMem) && allMem.length > hotLimit) {
        const extras = allMem.slice(hotLimit); // хвост к архиву
        const extraIds = extras.map((r) => r.id);
        try {
          if (extras.length > 0) {
            // Перенос в архив
            const payload = extras.map((r) => ({ user_id: r.user_id, content: r.content, created_at: r.created_at }));
            const { error: insArcErr } = await supabaseAdmin.from('memory_archive').insert(payload);
            if (insArcErr) console.error('❌ archive insert error:', insArcErr.message);
            // Удаление из горячего слоя
            const { error: delErr } = await supabaseAdmin.from('user_memories').delete().in('id', extraIds);
            if (delErr) console.error('❌ hot trim delete error:', delErr.message);
          }
        } catch (e) {
          console.error('💥 hot trim exception:', e?.message || String(e));
        }
      }
    }

    return rows.length;
  } catch (error) {
    console.error('💥 Error in memory extraction:', error);
    throw error;
  }
}

async function updateChatSummary(
  chatId: string,
  chatMessages: Array<{ role: string; content: string }>
): Promise<void> {
  try {
    const transcript = chatMessages
      .filter((m) => m && typeof m.content === 'string' && m.content.trim().length > 0)
      .map((m) => `${m.role.toUpperCase()}: ${m.content}`)
      .join('\n');

    const prompt = `Ты аналитик беседы. Сжато подведи итог и выдели темы. 
Верни строго JSON {"summary":"...","topics":[...max 5]}.

Диалог:
${transcript}`;

    const comp = await openai.chat.completions.create({
      model: Deno.env.get("OPENAI_MODEL") || "gpt-4.1-mini",
      temperature: 0,
      messages: [
        {
          role: 'system',
          content: 'Резюмируй беседу коротко и выдели темы. Отвечай строго JSON.'
        },
        {
          role: 'user',
          content: prompt
        }
      ]
    });

    let summary = '';
    let topics: string[] = [];

    try {
      const raw = comp.choices?.[0]?.message?.content?.trim() || '{}';
      const parsed = JSON.parse(raw);
      if (parsed && typeof parsed === 'object') {
        summary = typeof parsed.summary === 'string' ? parsed.summary : '';
        topics = Array.isArray(parsed.topics) 
          ? parsed.topics.filter((t) => typeof t === 'string').slice(0, 5) 
          : [];
      }
    } catch (parseError) {
      console.log('❌ Failed to parse summary response:', parseError);
    }

    const { error: updateErr } = await supabaseAdmin
      .from('leo_chats')
      .update({
        summary,
        last_topics: topics,
        updated_at: new Date().toISOString()
      })
      .eq('id', chatId);

    if (updateErr) {
      console.error('❌ Error updating chat summary:', updateErr.message);
      throw updateErr;
    }

    console.log('✅ Chat summary updated successfully');
  } catch (error) {
    console.error('💥 Error updating chat summary:', error);
    throw error;
  }
}

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", {
      headers: corsHeaders
    });
  }

  try {
    let body: any = {};
    try {
      body = await req.json();
    } catch (parseError) {
      console.log('⚠️ No body or invalid JSON:', parseError);
      body = {};
    }

    // Webhook mode: Supabase sends the inserted row data
    const cronSecret = req.headers.get('x-cron-secret');
    const expectedSecret = Deno.env.get('CRON_SECRET');

    if (cronSecret && cronSecret === expectedSecret) {
      console.log('🎯 === WEBHOOK CALL RECEIVED ===');
      
      // Extract data from webhook payload
      let message_id: string, chat_id: string, user_id: string, role: string, content: string;
      
      if (body.type === 'INSERT' && body.record) {
        // Webhook format: { type: "INSERT", table: "leo_messages", record: {...} }
        message_id = body.record.id;
        chat_id = body.record.chat_id;
        user_id = body.record.user_id;
        role = body.record.role;
        content = body.record.content;
      } else {
        // Direct format: { id, chat_id, user_id, role, content }
        message_id = body.id;
        chat_id = body.chat_id;
        user_id = body.user_id;
        role = body.role;
        content = body.content;
      }

      if (role === 'assistant' && message_id && chat_id && user_id) {
        console.log('✅ Valid assistant message, starting processing...');
        
        try {
          // Mark as processed
          const { error: markError } = await supabaseAdmin
            .from('leo_messages_processed')
            .upsert({ message_id });

          if (markError) {
            console.error('❌ Error marking as processed:', markError.message);
            throw markError;
          }

          // Fetch recent messages for this chat
          const { data: msgs, error: msgsError } = await supabaseAdmin
            .from('leo_messages')
            .select('role, content, created_at')
            .eq('chat_id', chat_id)
            .order('created_at', { ascending: false })
            .limit(40);

          if (msgsError) {
            console.error('❌ Error fetching messages:', msgsError.message);
            throw msgsError;
          }

          if (msgs && msgs.length > 0) {
            const chatMsgs = msgs.reverse().map((m) => ({
              role: m.role === 'assistant' || m.role === 'system' ? m.role : 'user',
              content: m.content || ''
            }));

            // Extract memories
            const memoriesCount = await extractAndUpsertMemoriesForUser(user_id, chatMsgs, 8);
            
            // Update chat summary
            await updateChatSummary(chat_id, chatMsgs);

            return new Response(JSON.stringify({
              status: 'processed',
              message_id,
              chat_id,
              user_id,
              memories_count: memoriesCount
            }), {
              status: 200,
              headers: {
                ...corsHeaders,
                'Content-Type': 'application/json'
              }
            });
          } else {
            console.log('⚠️ No messages found for chat, skipping processing');
            return new Response(JSON.stringify({
              status: 'skipped',
              reason: 'no_messages',
              message_id
            }), {
              status: 200,
              headers: {
                ...corsHeaders,
                'Content-Type': 'application/json'
              }
            });
          }
        } catch (processingError) {
          console.error('💥 Processing failed with error:', processingError);
          return new Response(JSON.stringify({
            error: 'processing_failed',
            details: processingError.message,
            message_id
          }), {
            status: 500,
            headers: {
              ...corsHeaders,
              'Content-Type': 'application/json'
            }
          });
        }
      } else {
        console.log('❌ Invalid message data, skipping processing');
        return new Response(JSON.stringify({
          status: 'ignored',
          reason: 'invalid_data',
          details: { role, message_id, chat_id, user_id }
        }), {
          status: 200,
          headers: {
            ...corsHeaders,
            'Content-Type': 'application/json'
          }
        });
      }
    } else {
      console.log('�� Not a webhook call (wrong or missing cron secret)');
    }

    // Fallback: direct mode (per-user body), requires Bearer user
    if (!Array.isArray(body.messages)) {
      console.log('⚠️ Direct mode: messages must be an array');
      return new Response(JSON.stringify({
        error: "messages must be an array"
      }), {
        status: 400,
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json"
        }
      });
    }

    const authHeader = req.headers.get("Authorization") || req.headers.get("authorization");
    if (!authHeader?.startsWith("Bearer ")) {
      console.log('❌ Direct mode: missing bearer token');
      return new Response(JSON.stringify({
        error: "missing bearer token"
      }), {
        status: 401,
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json"
        }
      });
    }

    console.log('🔐 Direct mode: processing with bearer token');
    const jwt = authHeader.replace("Bearer ", "");
    const { data: { user }, error: authErr } = await supabaseAdmin.auth.getUser(jwt);
    
    if (authErr || !user) {
      console.log('❌ Direct mode: unauthorized user');
      return new Response(JSON.stringify({
        error: "unauthorized"
      }), {
        status: 401,
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json"
        }
      });
    }

    console.log('✅ Direct mode: user authorized, processing messages');
    const saved = await extractAndUpsertMemoriesForUser(user.id, body.messages, 8);
    
    return new Response(JSON.stringify({
      user_id: user.id,
      saved
    }), {
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  } catch (unexpectedError) {
    console.error('💥 === UNEXPECTED ERROR ===');
    console.error('💥 Error details:', {
      message: unexpectedError.message,
      stack: unexpectedError.stack,
      name: unexpectedError.name
    });
    
    return new Response(JSON.stringify({
      error: "internal_error",
      details: unexpectedError.message
    }), {
      status: 500,
      headers: {
        ...corsHeaders,
        "Content-Type": "application/json"
      }
    });
  }
});