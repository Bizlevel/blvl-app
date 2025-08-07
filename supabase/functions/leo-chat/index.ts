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

    console.log('🔧 DEBUG: Auth header:', authHeader ? 'ЕСТЬ' : 'НЕТ');
    
    if (authHeader?.startsWith("Bearer ")) {
      const jwt = authHeader.replace("Bearer ", "");
      console.log('🔧 DEBUG: JWT token length:', jwt.length);

      const { data: { user }, error } = await supabaseAdmin.auth.getUser(jwt);
      console.log('🔧 DEBUG: Auth result:', error ? `ERROR: ${error.message}` : `SUCCESS: user ${user?.id}`);

      if (!error && user) {
        const { data: profile } = await supabaseAdmin
          .from("users")
          .select("name, about, goal, business_area, experience_level")
          .eq("id", user.id)
          .single();

        if (profile) {
          const { name, about, goal, business_area, experience_level } = profile;
          // Используем контекст от клиента, если он передан, иначе строим из профиля
          if (userContext) {
            userContextText = userContext;
          } else {
            userContextText = `Имя пользователя: ${name ?? "не указано"}. Цель: ${goal ?? "не указана"}. О себе: ${about ?? "нет информации"}. Сфера деятельности: ${business_area ?? "не указана"}. Уровень опыта: ${experience_level ?? "не указан"}.`;
          }
        }
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

${userContextText ? `\n## ПЕРСОНАЛИЗАЦИЯ ДЛЯ ПОЛЬЗОВАТЕЛЯ:\n${userContextText}` : ''}
${levelContext ? `\n## КОНТЕКСТ УРОКА:\n${levelContext}` : ''}
${knowledgeContext ? `\n## БАЗА ЗНАНИЙ:\n${knowledgeContext}` : ''}`;

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