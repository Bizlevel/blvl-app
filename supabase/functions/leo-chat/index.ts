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
    const { messages } = await req.json();

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

    if (authHeader?.startsWith("Bearer ")) {
      const jwt = authHeader.replace("Bearer ", "");

      const { data: { user }, error } = await supabaseAdmin.auth.getUser(jwt);

      if (!error && user) {
        const { data: profile } = await supabaseAdmin
          .from("users")
          .select("name, about, goal")
          .eq("id", user.id)
          .single();

        if (profile) {
          const { name, about, goal } = profile;
          userContextText =
            `Имя пользователя: ${name ?? "не указано"}. Цель: ${goal ?? "не указана"}. О себе: ${about ?? "нет информации"}.`;
        }
      }
    }

    // Compose chat with system prompt that includes user context
    const completion = await openai.chat.completions.create({
      model: "gpt-3.5-turbo",
      messages: [
        {
          role: "system",
          content:
            `Ты Leo — дружелюбный AI-ментор по развитию бизнеса. Отвечай лаконично на русском языке. ${userContextText}`,
        },
        ...messages,
      ],
    });

    const assistantMessage = completion.choices[0].message;
    const usage = completion.usage; // prompt/completion/total tokens

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