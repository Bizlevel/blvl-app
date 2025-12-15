// Edge Function: push-dispatch (OneSignal)
// Secrets (Supabase): ONESIGNAL_APP_ID, ONESIGNAL_REST_API_KEY, SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY

import { serve } from "https://deno.land/std@0.177.1/http/server.ts";

type DispatchRequest = {
  user_ids?: string[];
  data?: Record<string, unknown>;
  notification?: { title?: string; body?: string };
};

async function fetchTokens(userIds: string[]): Promise<string[]> {
  const adminKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  const url = Deno.env.get("SUPABASE_URL");
  if (!adminKey || !url) throw new Response("Missing Supabase env", { status: 500 });
  const q = new URL(url + "/rest/v1/push_tokens");
  q.searchParams.set("select", "token");
  q.searchParams.set("user_id", `in.(${userIds.join(",")})`);
  q.searchParams.set("provider", "eq.onesignal");
  const resp = await fetch(q, { headers: { apikey: adminKey, Authorization: `Bearer ${adminKey}` } });
  if (!resp.ok) throw new Response("Failed to fetch tokens", { status: 500 });
  const rows = await resp.json();
  return rows.map((r: { token: string }) => r.token).filter((t: string) => t && t.length > 0);
}

async function sendOneSignal(
  appId: string,
  apiKey: string,
  playerIds: string[],
  payload: DispatchRequest,
): Promise<void> {
  const body = {
    app_id: appId,
    include_player_ids: playerIds,
    contents: { en: payload.notification?.body ?? "Open the app" },
    headings: payload.notification?.title ? { en: payload.notification?.title } : undefined,
    data: payload.data ?? {},
  };
  const resp = await fetch("https://api.onesignal.com/notifications", {
    method: "POST",
    headers: {
      "content-type": "application/json",
      authorization: `Basic ${apiKey}`,
    },
    body: JSON.stringify(body),
  });
  if (!resp.ok) {
    const text = await resp.text();
    throw new Response(`OneSignal send failed: ${text}`, { status: 500 });
  }
}

serve(async (req: Request) => {
  if (req.method !== "POST") return new Response("Method Not Allowed", { status: 405 });

  const appId = Deno.env.get("ONESIGNAL_APP_ID");
  const apiKey = Deno.env.get("ONESIGNAL_REST_API_KEY");
  if (!appId || !apiKey) return new Response("Missing OneSignal env", { status: 500 });

  let payload: DispatchRequest;
  try {
    payload = await req.json();
  } catch {
    return new Response("Invalid JSON", { status: 400 });
  }

  const userIds = payload.user_ids ?? [];
  if (userIds.length === 0) return new Response("user_ids required", { status: 400 });

  const tokens = await fetchTokens(userIds);
  if (tokens.length === 0) return new Response(JSON.stringify({ sent: 0 }), { status: 200 });

  // OneSignal ограничивает размер запроса; шлём батчами
  const chunk = (arr: string[], size: number) => {
    const res: string[][] = [];
    for (let i = 0; i < arr.length; i += size) res.push(arr.slice(i, i + size));
    return res;
  };
  for (const batch of chunk(tokens, 2000)) {
    await sendOneSignal(appId, apiKey, batch, payload);
  }

  return new Response(JSON.stringify({ sent: tokens.length }), { status: 200 });
});


