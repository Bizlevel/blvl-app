// @ts-nocheck
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
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

// Initialize OpenAI client
const openai = new OpenAI();

serve(async (req: Request): Promise<Response> => {
  // Handle CORS pre-flight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { query, userContext, levelContext } = await req.json();
    
    // console.log('🔍 RAG запрос:', { query, userContext: userContext?.substring(0, 50), levelContext: levelContext?.substring(0, 50) });

    if (!query || typeof query !== 'string') {
      return new Response(
        JSON.stringify({ error: "query must be a string" }),
        {
          status: 400,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        },
      );
    }

    // Генерируем эмбеддинг для запроса
    // console.log('🔍 Создаем эмбеддинг для запроса:', query);
    const embeddingResponse = await openai.embeddings.create({
      input: query,
      model: Deno.env.get("OPENAI_EMBEDDING_MODEL") || "text-embedding-3-small"
    });
    // console.log('🔍 Embedding создан, размер:', embeddingResponse.data[0].embedding.length);

    // Ищем похожие документы в базе знаний
    // console.log('🔍 Ищем в таблице documents с порогом 0.3...');
    const { data: results, error } = await supabaseAdmin.rpc('match_documents', {
      query_embedding: embeddingResponse.data[0].embedding,
      match_threshold: 0.3,
      match_count: 5
    });

    // console.log('📚 Результаты поиска:', { found: results?.length || 0, error: error?.message });

    if (error) {
      console.error("Database search error:", error);
      return new Response(
        JSON.stringify({ error: "Database search failed", details: error.message }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Формируем контекст из найденных документов
    const context = results?.map((r: any) => r.content).join('\n\n') || '';
    
    // console.log('📝 Сформированный контекст:', context.substring(0, 200));
    
    // Добавляем контекст пользователя и уровня
    const enhancedContext = `
КОНТЕКСТ ПОЛЬЗОВАТЕЛЯ:
${userContext || 'Не указан'}

КОНТЕКСТ УРОКА:
${levelContext || 'Не указан'}

БАЗА ЗНАНИЙ:
${context}
`.trim();

    return new Response(
      JSON.stringify({ 
        context: enhancedContext,
        results: results || [],
        query,
        userContext,
        levelContext
      }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (err) {
    console.error("Leo RAG function error:", err);
    return new Response(
      JSON.stringify({ error: "Internal error", details: err.message }),
      {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      },
    );
  }
}); 