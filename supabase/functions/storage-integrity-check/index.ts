import { serve } from "https://deno.land/std@0.192.0/http/server.ts";
import { createClient, SupabaseClient } from "https://esm.sh/@supabase/supabase-js@2.7.0";

// Simple nightly job that checks that all files referenced in the database
// exist in the corresponding Supabase Storage buckets.
// Missing files are returned in the JSON response so that the CI workflow
// can forward them to Sentry/slack. The function is idempotent and safe to
// run frequently.

type MissingRecord = {
  table: "levels" | "lessons";
  id: number;
  column: string;
  path: string;
};

/**
 * Checks if a file exists by trying to create a signed URL. If the Storage API
 * responds with 404 we treat the file as missing. Any other error is returned
 * so that the caller can decide how to handle it.
 */
async function exists(
  client: SupabaseClient,
  bucket: string,
  path: string,
): Promise<boolean> {
  const { error } = await client.storage.from(bucket).createSignedUrl(path, 60);
  if (!error) return true;
  if (error.statusCode === 404 || error.statusCode === "404") return false;
  throw error; // propagate unexpected errors
}

serve(async (_req: Request): Promise<Response> => {
  // Admin client (service role key required)
  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  const missing: MissingRecord[] = [];

  // 1. Проверяем обложки уровней
  const { data: levels } = await supabase
    .from("levels")
    .select("id, cover_path")
    .neq("cover_path", "");

  if (levels) {
    for (const lvl of levels) {
      if (lvl.cover_path) {
        const ok = await exists(supabase, "level-covers", lvl.cover_path);
        if (!ok) {
          missing.push({
            table: "levels",
            id: lvl.id,
            column: "cover_path",
            path: lvl.cover_path,
          });
        }
      }
    }
  }

  // 2. Проверяем видео-уроки
  const { data: lessons } = await supabase
    .from("lessons")
    .select("id, video_url")
    .neq("video_url", "");

  if (lessons) {
    for (const lesson of lessons) {
      if (lesson.video_url) {
        const ok = await exists(supabase, "video", lesson.video_url);
        if (!ok) {
          missing.push({
            table: "lessons",
            id: lesson.id,
            column: "video_url",
            path: lesson.video_url,
          });
        }
      }
    }
  }

  const responseBody = {
    checkedAt: new Date().toISOString(),
    missingCount: missing.length,
    missing,
  };

  return new Response(JSON.stringify(responseBody), {
    headers: {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
    },
  });
}); 