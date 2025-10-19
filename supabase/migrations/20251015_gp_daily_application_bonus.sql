-- Insert GP bonus rule for daily application (idempotent)
insert into public.gp_bonus_rules(rule_key, amount, is_active)
values ('daily_application', 5, true)
on conflict (rule_key) do update set amount=excluded.amount, is_active=excluded.is_active;

-- Optional helper function to claim once per day (by idempotency key)
create or replace function public.gp_claim_daily_application()
returns table(balance_after integer)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user uuid := auth.uid();
  v_key text := 'bonus:daily_application:' || (now()::date)::text;
  v_result record;
begin
  if v_user is null then
    raise exception 'not authorized';
  end if;

  return query
  select * from public.gp_bonus_claim('daily_application');
exception when others then
  -- Fallback to idempotent ledger guard
  return query
  select balance_after from public.gp_bonus_claim('daily_application');
end;
$$;


