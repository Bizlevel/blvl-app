-- Drop weekly_progress, goal_checkpoint_progress and related RPC/triggers

-- Safely drop RPC/functions if exist
do $$ begin
  if exists (select 1 from pg_proc p join pg_namespace n on p.pronamespace=n.oid where n.nspname='public' and p.proname='update_goal_sprint') then
    drop function public.update_goal_sprint(text, date);
  end if;
exception when others then null; end $$;

do $$ begin
  if exists (select 1 from pg_proc p join pg_namespace n on p.pronamespace=n.oid where n.nspname='public' and p.proname='upsert_goal_field') then
    drop function public.upsert_goal_field(integer, text, text);
  end if;
exception when others then null; end $$;

do $$ begin
  if exists (select 1 from pg_proc p join pg_namespace n on p.pronamespace=n.oid where n.nspname='public' and p.proname='fetch_goal_state') then
    drop function public.fetch_goal_state();
  end if;
exception when others then null; end $$;

-- Drop triggers if remain
do $$ begin
  if exists (select 1 from pg_trigger t join pg_class c on t.tgrelid=c.oid join pg_namespace n on c.relnamespace=n.oid where n.nspname='public' and c.relname='weekly_progress' and t.tgname='trg_weekly_updated_at') then
    drop trigger trg_weekly_updated_at on public.weekly_progress;
  end if;
exception when others then null; end $$;

-- Drop tables if exist
do $$ begin
  if to_regclass('public.weekly_progress') is not null then
    drop table public.weekly_progress cascade;
  end if;
exception when others then null; end $$;

do $$ begin
  if to_regclass('public.goal_checkpoint_progress') is not null then
    drop table public.goal_checkpoint_progress cascade;
  end if;
exception when others then null; end $$;


