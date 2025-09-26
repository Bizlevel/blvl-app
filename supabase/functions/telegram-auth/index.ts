import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';
import { crypto } from 'https://deno.land/std@0.209.0/crypto/mod.ts';
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

const TELEGRAM_BOT_TOKEN = Deno.env.get('TELEGRAM_BOT_TOKEN');

async function checkTelegramAuth(data: URLSearchParams): Promise<Record<string, string>> {
  if (!TELEGRAM_BOT_TOKEN) {
    throw new Error('TELEGRAM_BOT_TOKEN is not set');
  }

  const hash = data.get('hash');
  data.delete('hash');

  const dataCheckArr = [];
  for (const [key, value] of data.entries()) {
    dataCheckArr.push(`${key}=${value}`);
  }
  const dataCheckString = dataCheckArr.sort().join('\n');

  const secretKey = await crypto.subtle.importKey(
    'raw',
    new TextEncoder().encode('WebAppData'),
    { name: 'HMAC', hash: 'SHA-256' },
    false,
    ['sign']
  );
  const hmac = await crypto.subtle.sign(
    'HMAC',
    secretKey,
    new TextEncoder().encode(dataCheckString)
  );

  if (hmac !== hash) {
    throw new Error('Telegram auth data is not valid');
  }
  
  return Object.fromEntries(data.entries());
}

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const url = new URL(req.url);
    const tgAuthDataParams = url.searchParams;
    const authData = await checkTelegramAuth(new URLSearchParams(tgAuthDataParams));
    const { id: tgUserId, first_name, last_name, username, photo_url } = authData;

    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '',
      { auth: { persistSession: false } }
    );

    let { data: user, error } = await supabaseAdmin.auth.admin.getUserById(tgUserId.toString());

    if (error && error.message.includes('User not found')) {
      const { data: newUserResponse, error: creationError } = await supabaseAdmin.auth.admin.createUser({
        id: tgUserId.toString(),
        email: `${tgUserId}@telegram.user`,
        user_metadata: {
          first_name,
          last_name,
          user_name: username,
          avatar_url: photo_url,
          provider: 'telegram',
        },
        email_confirm: true,
      });

      if (creationError) throw creationError;
      user = newUserResponse.user;
    } else if (error) {
      throw error;
    }

    if (!user) {
        throw new Error("Could not find or create user.");
    }

    const { data: sessionData, error: sessionError } = await supabaseAdmin.auth.admin.generateLink({
        type: 'magiclink',
        email: user.email!,
    });

    if (sessionError) throw sessionError;
    
    const accessToken = sessionData.properties?.access_token;
    const refreshToken = sessionData.properties?.refresh_token;

    if (!accessToken || !refreshToken) {
      throw new Error("Failed to create session tokens from magic link.");
    }

    // Redirect to a custom URL scheme that the app can handle
    const redirectUrl = `bizlevel://auth/callback?access_token=${accessToken}&refresh_token=${refreshToken}`;

    return new Response(null, {
      status: 302,
      headers: {
        ...corsHeaders,
        Location: redirectUrl,
      },
    });

  } catch (error) {
    console.error('Error in Telegram auth function:', error);
    return new Response(JSON.stringify({ error: error.message }), {
      status: 400,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    });
  }
});