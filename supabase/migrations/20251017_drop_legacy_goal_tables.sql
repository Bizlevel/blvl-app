-- Drop legacy goal tables and related functions safely (IF EXISTS)

-- goal versions / weekly (legacy)
DROP TABLE IF EXISTS public.weekly_progress CASCADE;
DROP TABLE IF EXISTS public.goal_checkpoint_progress CASCADE;
DROP TABLE IF EXISTS public.core_goals CASCADE;

-- old daily table (renamed earlier, keep safety)
DROP TABLE IF EXISTS public.daily_progress CASCADE;

-- legacy RPC/functions
DROP FUNCTION IF EXISTS public.upsert_goal_field(int, text, jsonb);
DROP FUNCTION IF EXISTS public.fetch_goal_state();
DROP FUNCTION IF EXISTS public.generate_daily_tasks_from_goal();

-- legacy triggers
DROP TRIGGER IF EXISTS trg_notify_goal_comment ON public.core_goals;
DROP TRIGGER IF EXISTS trg_weekly_checkin_notify ON public.weekly_progress;


