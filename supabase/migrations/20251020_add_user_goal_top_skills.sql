-- Phase 2: user_goal.top_skills (text[])

alter table public.user_goal
  add column if not exists top_skills text[] default '{}';

-- Optional helper function to refresh top_skills from practice_log (to be called by Edge or cron)
create or replace function public.refresh_user_goal_top_skills(p_user uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_top text[] := '{}';
begin
  select coalesce(array_agg(t order by cnt desc)[:3], '{}') into v_top
  from (
    select unnest(pl.applied_tools)::text as t, count(*) as cnt
    from public.practice_log pl
    where pl.user_id = p_user
    group by 1
  ) s;

  update public.user_goal ug
    set top_skills = v_top,
        updated_at = now()
  where ug.user_id = p_user;
end;
$$;



