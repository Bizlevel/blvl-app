-- Migrate data from core_goals(versioned) to user_goal(flat) and drop legacy table

-- Insert/Upsert latest goal per user into user_goal
with latest as (
  select
    cg.*,
    row_number() over (partition by cg.user_id order by cg.updated_at desc nulls last, cg.version desc) as rn
  from public.core_goals cg
)
insert into public.user_goal as ug (
  user_id,
  goal_text,
  metric_type,
  metric_current,
  metric_target,
  readiness_score,
  start_date
)
select
  l.user_id,
  coalesce(l.goal_text,
           l.version_data->>'concrete_result',
           l.version_data->>'goal_smart',
           '') as goal_text,
  nullif(l.version_data->>'metric_type','') as metric_type,
  case when (l.version_data->>'metric_current') ~ '^-?\\d+(\\.\\d+)?$' then (l.version_data->>'metric_current')::numeric end as metric_current,
  case when (l.version_data->>'metric_target') ~ '^-?\\d+(\\.\\d+)?$' then (l.version_data->>'metric_target')::numeric end as metric_target,
  case when (l.version_data->>'readiness_score') ~ '^\\d+$' then (l.version_data->>'readiness_score')::int end as readiness_score,
  coalesce(l.sprint_start_date,
           case when (l.version_data->>'start_date') ~ '^\\d{4}-\\d{2}-\\d{2}$' then (l.version_data->>'start_date')::date end) as start_date
from latest l
where l.rn = 1
on conflict (user_id) do update set
  goal_text = excluded.goal_text,
  metric_type = excluded.metric_type,
  metric_current = excluded.metric_current,
  metric_target = excluded.metric_target,
  readiness_score = excluded.readiness_score,
  start_date = excluded.start_date,
  updated_at = now();

-- Drop legacy artifacts: table core_goals and dependencies
do $$
begin
  if to_regclass('public.core_goals') is not null then
    drop table public.core_goals cascade;
  end if;
exception when others then null;
end $$;


