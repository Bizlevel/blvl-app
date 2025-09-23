// Minimal Edge Function: push-dispatch
// Sends FCM messages using HTTP v1 via Service Account JSON stored in Supabase secrets
// No secrets in repo. Configure secrets:
// supabase secrets set FCM_SERVICE_ACCOUNT_JSON='...'

import { serve } from "https://deno.land/std@0.177.1/http/server.ts";

type DispatchRequest = {
  user_ids?: string[];
  data?: Record<string, unknown>;
  notification?: { title?: string; body?: string };
  android?: { channel_id?: string };
};

async function getServiceAccount() {
  const raw = Deno.env.get("FCM_SERVICE_ACCOUNT_JSON");
  if (!raw) throw new Response("Missing FCM credentials", { status: 500 });
  return JSON.parse(raw);
}

async function getAccessToken(): Promise<string> {
  const sa = await getServiceAccount();
  const now = Math.floor(Date.now() / 1000);
  const header = { alg: "RS256", typ: "JWT" };
  const scope = "https://www.googleapis.com/auth/firebase.messaging";
  const claims = {
    iss: sa.client_email,
    sub: sa.client_email,
    aud: "https://oauth2.googleapis.com/token",
    iat: now,
    exp: now + 3600,
    scope,
  };
  const enc = (obj: unknown) => btoa(JSON.stringify(obj));
  const toSign = `${enc(header)}.${enc(claims)}`;
  const key = await crypto.subtle.importKey(
    "pkcs8",
    Uint8Array.from(atob(sa.private_key.split("\n").slice(1, -1).join("")), (c) => c.charCodeAt(0)),
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["sign"],
  );
  const sig = await crypto.subtle.sign("RSASSA-PKCS1-v1_5", key, new TextEncoder().encode(toSign));
  const jwt = `${toSign}.${btoa(String.fromCharCode(...new Uint8Array(sig)))}`;
  const resp = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "content-type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({ grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer", assertion: jwt }),
  });
  if (!resp.ok) throw new Response("Failed to obtain access token", { status: 500 });
  const json = await resp.json();
  return json.access_token as string;
}

async function fetchTokens(userIds: string[]): Promise<string[]> {
  const adminKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  const url = Deno.env.get("SUPABASE_URL");
  if (!adminKey || !url) throw new Response("Missing Supabase env", { status: 500 });
  const q = new URL(url + "/rest/v1/push_tokens");
  q.searchParams.set("select", "token");
  q.searchParams.set("user_id", `in.(${userIds.join(',')})`);
  const resp = await fetch(q, { headers: { apikey: adminKey, Authorization: `Bearer ${adminKey}` } });
  if (!resp.ok) throw new Response("Failed to fetch tokens", { status: 500 });
  const rows = await resp.json();
  return rows.map((r: { token: string }) => r.token);
}

serve(async (req: Request) => {
  if (req.method !== "POST") return new Response("Method Not Allowed", { status: 405 });

  const adminKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  if (!adminKey) return new Response("Forbidden", { status: 403 });

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

  const accessToken = await getAccessToken();
  const sa = await getServiceAccount();
  const projectId = sa.project_id;

  const messages = tokens.map((token) => ({
    token,
    notification: payload.notification,
    data: (payload.data ?? {}) as Record<string, string>,
    android: payload.android?.channel_id ? { notification: { channel_id: payload.android.channel_id } } : undefined,
  }));

  const resp = await fetch(`https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`, {
    method: "POST",
    headers: { Authorization: `Bearer ${accessToken}`, "content-type": "application/json" },
    body: JSON.stringify({ validate_only: false, message: messages[0] }),
  });
  if (!resp.ok) return new Response("FCM send failed", { status: 500 });
  return new Response(JSON.stringify({ sent: tokens.length }), { status: 200 });
});


