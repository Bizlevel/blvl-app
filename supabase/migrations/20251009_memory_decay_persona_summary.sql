-- Memory decay and weekly persona_summary refresh
-- Safe to re-run: use CREATE IF NOT EXISTS / CREATE OR REPLACE

-- 1) Ensure helper columns exist
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' AND table_name = 'user_memories' AND column_name = 'access_count'
  ) THEN
    ALTER TABLE public.user_memories ADD COLUMN access_count integer NOT NULL DEFAULT 0;
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' AND table_name = 'user_memories' AND column_name = 'last_accessed'
  ) THEN
    ALTER TABLE public.user_memories ADD COLUMN last_accessed timestamptz;
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' AND table_name = 'user_memories' AND column_name = 'relevance_score'
  ) THEN
    ALTER TABLE public.user_memories ADD COLUMN relevance_score numeric DEFAULT 1.0;
  END IF;
END$$;

-- 2) RPC to touch memories (already used by edge; create or replace)
CREATE OR REPLACE FUNCTION public.touch_user_memories(p_ids uuid[])
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  UPDATE public.user_memories
  SET access_count = COALESCE(access_count,0) + 1,
      last_accessed = NOW(),
      relevance_score = LEAST(10.0, COALESCE(relevance_score,1.0) + 0.2)
  WHERE id = ANY(p_ids);
END$$;

-- 3) Weekly decay job: gently reduce relevance for untouched memories
CREATE OR REPLACE FUNCTION public.memory_decay()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Decay rule: -0.15 for memories not accessed in 14+ days, clamp to [0, 10]
  UPDATE public.user_memories
  SET relevance_score = GREATEST(0.0, COALESCE(relevance_score,1.0) - 0.15)
  WHERE (last_accessed IS NULL AND created_at < NOW() - INTERVAL '14 days')
     OR (last_accessed IS NOT NULL AND last_accessed < NOW() - INTERVAL '14 days');
END$$;

-- 4) Persona summary refresh: aggregate top facts and chats into compact summary
CREATE OR REPLACE FUNCTION public.refresh_persona_summary(p_user_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_summary text;
BEGIN
  WITH mem AS (
    SELECT content
    FROM public.user_memories
    WHERE user_id = p_user_id
    ORDER BY COALESCE(relevance_score,1.0) DESC, COALESCE(last_accessed, updated_at) DESC
    LIMIT 12
  ),
  chats AS (
    SELECT summary
    FROM public.leo_chats
    WHERE user_id = p_user_id AND summary IS NOT NULL
    ORDER BY updated_at DESC
    LIMIT 3
  )
  SELECT (
    'Ключевые факты: ' || COALESCE(string_agg(mem.content, '; '), '') ||
    CASE WHEN EXISTS(SELECT 1 FROM chats) THEN
      E'\nИтоги бесед: ' || COALESCE((SELECT string_agg(chats.summary, '; ') FROM chats), '')
    ELSE '' END
  ) INTO v_summary
  FROM mem;

  UPDATE public.users
  SET persona_summary = NULLIF(TRIM(v_summary), '')
  WHERE id = p_user_id;
END$$;

-- 5) pg_net/cron wiring (if available)
-- Requires pg_cron or Supabase cron. Use cron.schedule if extension is present.
DO $$
BEGIN
  -- decay weekly
  PERFORM cron.schedule('memory_decay_weekly', '0 4 * * 1', $$SELECT public.memory_decay();$$);
EXCEPTION WHEN undefined_function THEN
  -- cron extension may be unavailable in local dev; ignore
  NULL;
END$$;

-- 6) Optional: weekly persona refresh runner (batch)
CREATE OR REPLACE FUNCTION public.refresh_persona_summary_all()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  r record;
BEGIN
  FOR r IN SELECT id FROM public.users LOOP
    PERFORM public.refresh_persona_summary(r.id);
  END LOOP;
END$$;

DO $$
BEGIN
  PERFORM cron.schedule('persona_summary_weekly', '30 4 * * 1', $$SELECT public.refresh_persona_summary_all();$$);
EXCEPTION WHEN undefined_function THEN
  NULL;
END$$;


