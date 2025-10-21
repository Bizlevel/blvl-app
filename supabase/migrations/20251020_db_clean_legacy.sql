-- Final legacy cleanup (idempotent)

-- Drop legacy tables if still present
do $$ begin
  if to_regclass('public.weekly_progress') is not null then
    drop table public.weekly_progress cascade;
  end if;
  if to_regclass('public.goal_checkpoint_progress') is not null then
    drop table public.goal_checkpoint_progress cascade;
  end if;
  if to_regclass('public.core_goals') is not null then
    drop table public.core_goals cascade;
  end if;
end $$;

-- Drop legacy RPC/functions if still present
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM pg_proc p JOIN pg_namespace n ON p.pronamespace = n.oid
    WHERE n.nspname = 'public' AND p.proname = 'update_goal_sprint'
  ) THEN
    DROP FUNCTION public.update_goal_sprint(text, date);
  END IF;

  IF EXISTS (
    SELECT 1 FROM pg_proc p JOIN pg_namespace n ON p.pronamespace = n.oid
    WHERE n.nspname = 'public' AND p.proname = 'upsert_goal_field'
  ) THEN
    DROP FUNCTION public.upsert_goal_field(integer, text, text);
  END IF;

  IF EXISTS (
    SELECT 1 FROM pg_proc p JOIN pg_namespace n ON p.pronamespace = n.oid
    WHERE n.nspname = 'public' AND p.proname = 'fetch_goal_state'
  ) THEN
    DROP FUNCTION public.fetch_goal_state();
  END IF;
END $$;

