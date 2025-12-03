import { serve } from "https://deno.land/std@0.177.1/http/server.ts";

type ReminderRow = {
  user_id: string;
};

const SUPABASE_URL = Deno.env.get("SUPABASE_URL") ?? "";
const SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";

if (!SUPABASE_URL || !SERVICE_ROLE_KEY) {
  console.error("Missing Supabase env variables");
}

const JSON_HEADERS = {
  "content-type": "application/json",
  apikey: SERVICE_ROLE_KEY,
  Authorization: `Bearer ${SERVICE_ROLE_KEY}`,
};

async function fetchDueReminders(
  windowMinutes: number,
): Promise<ReminderRow[]> {
  const resp = await fetch(
    `${SUPABASE_URL}/rest/v1/rpc/due_practice_reminders`,
    {
      method: "POST",
      headers: JSON_HEADERS,
      body: JSON.stringify({ p_window_minutes: windowMinutes }),
    },
  );
  if (!resp.ok) {
    const text = await resp.text();
    throw new Error(`due_practice_reminders failed: ${text}`);
  }
  const json = await resp.json();
  return Array.isArray(json) ? json : [];
}

async function markNotified(userIds: string[]): Promise<void> {
  if (userIds.length === 0) return;
  const resp = await fetch(
    `${SUPABASE_URL}/rest/v1/rpc/mark_practice_reminders_notified`,
    {
      method: "POST",
      headers: JSON_HEADERS,
      body: JSON.stringify({ p_user_ids: userIds }),
    },
  );
  if (!resp.ok) {
    const text = await resp.text();
    throw new Error(`mark_practice_reminders_notified failed: ${text}`);
  }
}

async function dispatchPush(userIds: string[]): Promise<void> {
  if (userIds.length === 0) return;
  const chunkSize = 50;
  for (let i = 0; i < userIds.length; i += chunkSize) {
    const chunk = userIds.slice(i, i + chunkSize);
    const resp = await fetch(`${SUPABASE_URL}/functions/v1/push-dispatch`, {
      method: "POST",
      headers: JSON_HEADERS,
      body: JSON.stringify({
        user_ids: chunk,
        notification: {
          title: "Время практики",
          body: "Загляните в цель и отметьте действие за сегодня.",
        },
        data: {
          route: "/goal",
          type: "goal_reminder",
        },
        android: { channel_id: "goal_reminder" },
      }),
    });
    if (!resp.ok) {
      const text = await resp.text();
      throw new Error(`push-dispatch failed: ${text}`);
    }
  }
}

serve(async (req) => {
  if (req.method !== "POST") {
    return new Response("Method Not Allowed", { status: 405 });
  }
  const authHeader = req.headers.get("authorization") ?? "";
  if (!authHeader.includes(SERVICE_ROLE_KEY)) {
    return new Response("Forbidden", { status: 403 });
  }

  try {
    const { window_minutes } = await req.json().catch(() => ({ window_minutes: 10 }));
    const due = await fetchDueReminders(window_minutes ?? 10);
    const userIds = [...new Set(due.map((row) => row.user_id).filter(Boolean))];

    if (userIds.length === 0) {
      return new Response(JSON.stringify({ sent: 0 }), { status: 200 });
    }

    await dispatchPush(userIds);
    await markNotified(userIds);
    return new Response(JSON.stringify({ sent: userIds.length }), {
      status: 200,
    });
  } catch (error) {
    console.error(error);
    return new Response(
      JSON.stringify({ error: (error as Error).message ?? "unknown" }),
      { status: 500 },
    );
  }
});



