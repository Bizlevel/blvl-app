-- 2025-12-17: Fix gp_claim_daily_application() early exit.
-- NOTE: In set-returning functions, `RETURN QUERY` does NOT exit the function.
-- We must explicitly `RETURN;` to prevent granting the bonus when there is no practice_log entry.

create or replace function public.gp_claim_daily_application()
returns table(balance_after integer)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user uuid := auth.uid();
  v_amount int;
  v_balance int;
  v_earned int;
  v_spent int;
  v_tz text;
  v_local_day date;
  v_day_start timestamptz;
  v_day_end timestamptz;
  v_idem text;
  v_meta jsonb := '{}'::jsonb;
begin
  if v_user is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;

  select amount into v_amount
  from public.gp_bonus_rules
  where rule_key = 'daily_application' and active = true;
  if not found or v_amount is null or v_amount <= 0 then
    raise exception 'gp_invalid_bonus_rule';
  end if;

  v_tz := public._gp_resolve_user_timezone(v_user);
  v_local_day := (now() at time zone v_tz)::date;
  v_day_start := (v_local_day::timestamp at time zone v_tz);
  v_day_end := v_day_start + interval '1 day';

  perform 1
  from public.practice_log pl
  where pl.user_id = v_user
    and pl.applied_at >= v_day_start
    and pl.applied_at < v_day_end
  limit 1;

  if not found then
    -- No entry today -> no bonus. Return current balance and EXIT.
    select w.balance into v_balance
    from public.gp_wallets w
    where w.user_id = v_user;

    if not found then
      select balance into v_balance
      from public._gp_compute_wallet(v_user);
    end if;

    return query select coalesce(v_balance, 0);
    return;
  end if;

  v_idem := 'bonus:daily_application:' || v_local_day::text || ':' || v_user::text;
  v_meta := jsonb_build_object(
    'rule_key', 'daily_application',
    'source', 'rpc',
    'local_day', v_local_day::text,
    'timezone', v_tz
  );

  insert into public.gp_ledger(id, user_id, amount, type, reference_id, metadata, idempotency_key, created_at)
  values (gen_random_uuid(), v_user, v_amount, 'bonus'::public.gp_transaction_type, 'daily_application', v_meta, v_idem, now())
  on conflict (idempotency_key) do nothing;

  select balance, total_earned, total_spent
    into v_balance, v_earned, v_spent
  from public._gp_compute_wallet(v_user);

  insert into public.gp_wallets(user_id, balance, total_earned, total_spent, updated_at)
  values (v_user, v_balance, v_earned, v_spent, now())
  on conflict (user_id) do update
    set balance = excluded.balance,
        total_earned = excluded.total_earned,
        total_spent = excluded.total_spent,
        updated_at = now();

  return query select v_balance;
end;
$$;

revoke all on function public.gp_claim_daily_application() from public;
grant execute on function public.gp_claim_daily_application() to authenticated;








