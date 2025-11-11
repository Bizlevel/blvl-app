-- log_practice_and_update_metric: вставка practice_log и обновление метрики в одной транзакции
create or replace function public.log_practice_and_update_metric(
  p_applied_tools text[],
  p_note text,
  p_applied_at timestamptz,
  p_metric_current numeric
) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user uuid := auth.uid();
  v_hist uuid;
begin
  if v_user is null then
    raise exception 'unauthorized';
  end if;

  select current_history_id into v_hist
  from user_goal
  where user_id = v_user
  for update;

  insert into practice_log(user_id, applied_tools, note, applied_at, goal_history_id)
  values (
    v_user,
    coalesce(p_applied_tools, array[]::text[]),
    nullif(p_note, ''),
    coalesce(p_applied_at, now() at time zone 'utc'),
    v_hist
  );

  if p_metric_current is not null then
    update user_goal
      set metric_current = p_metric_current,
          updated_at = now() at time zone 'utc'
      where user_id = v_user;

    if v_hist is not null then
      update user_goal_history
        set metric_current = p_metric_current
        where id = v_hist;
    end if;
  end if;
end;
$$;

revoke all on function public.log_practice_and_update_metric(text[], text, timestamptz, numeric) from public;
grant execute on function public.log_practice_and_update_metric(text[], text, timestamptz, numeric) to authenticated;

-- Индексы для производительности
create index if not exists ix_practice_log_user_goal_hist_applied_at
  on practice_log(user_id, goal_history_id, applied_at desc);

create index if not exists ix_user_goal_history_user_status
  on user_goal_history(user_id, status);


