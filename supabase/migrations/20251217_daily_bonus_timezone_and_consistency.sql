-- 2025-12-17: Daily practice bonus (once per local day) + user timezone + gp_bonus_rules active/is_active sync

-- 1) Store user's IANA timezone (e.g. "Asia/Almaty")
alter table public.users
  add column if not exists timezone text;

-- 2) RPC: user sets their timezone (validated against pg_timezone_names)
create or replace function public.user_set_timezone(p_timezone text)
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user uuid := auth.uid();
  v_tz text := nullif(trim(p_timezone), '');
begin
  if v_user is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;

  -- Allow clearing
  if v_tz is null then
    update public.users
      set timezone = null,
          updated_at = now()
      where id = v_user;
    return null;
  end if;

  perform 1 from pg_timezone_names where name = v_tz;
  if not found then
    raise exception 'invalid_timezone' using errcode = '22023';
  end if;

  update public.users
    set timezone = v_tz,
        updated_at = now()
    where id = v_user;

  return v_tz;
end;
$$;

revoke all on function public.user_set_timezone(text) from public;
grant execute on function public.user_set_timezone(text) to authenticated;

-- 3) Helper: resolve user's timezone (fallback to Asia/Almaty)
create or replace function public._gp_resolve_user_timezone(p_user_id uuid)
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  v_tz text;
begin
  select nullif(u.timezone, '') into v_tz
  from public.users u
  where u.id = p_user_id;

  if v_tz is not null then
    perform 1 from pg_timezone_names where name = v_tz;
    if found then
      return v_tz;
    end if;
  end if;

  return 'Asia/Almaty';
end;
$$;

revoke all on function public._gp_resolve_user_timezone(uuid) from public;
grant execute on function public._gp_resolve_user_timezone(uuid) to authenticated;

-- 4) Ensure daily bonus rule is present and enabled (keep active and is_active in sync)
insert into public.gp_bonus_rules(rule_key, amount, active, is_active)
values ('daily_application', 5, true, true)
on conflict (rule_key) do update
set amount = excluded.amount,
    active = excluded.active,
    is_active = excluded.is_active;

-- 5) Daily bonus claim: once per user per local day, only if practice_log entry exists for that local day
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

  -- Must have at least one practice log entry for the same local day.
  -- Use applied_at (UTC) bounds derived from local day to keep index usage (user_id, applied_at).
  perform 1
  from public.practice_log pl
  where pl.user_id = v_user
    and pl.applied_at >= v_day_start
    and pl.applied_at < v_day_end
  limit 1;

  if not found then
    -- No entry today -> no bonus. Return current balance.
    select w.balance into v_balance
    from public.gp_wallets w
    where w.user_id = v_user;

    if not found then
      select balance into v_balance
      from public._gp_compute_wallet(v_user);
    end if;

    return query select coalesce(v_balance, 0);
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

-- 6) Keep gp_bonus_rules.active and gp_bonus_rules.is_active consistent (avoid config drift)
create or replace function public._gp_bonus_rules_sync_active_flags()
returns trigger
language plpgsql
as $$
begin
  if tg_op = 'INSERT' then
    new.is_active := new.active;
    return new;
  end if;

  if new.active is distinct from new.is_active then
    -- If only one of the flags changed, propagate that change to the other.
    if new.active is distinct from old.active and new.is_active is not distinct from old.is_active then
      new.is_active := new.active;
    elsif new.is_active is distinct from old.is_active and new.active is not distinct from old.active then
      new.active := new.is_active;
    else
      -- If both changed (or unclear), prefer `active` (used by gp_bonus_claim).
      new.is_active := new.active;
    end if;
  end if;

  return new;
end;
$$;

drop trigger if exists trg_gp_bonus_rules_sync_active_flags on public.gp_bonus_rules;
create trigger trg_gp_bonus_rules_sync_active_flags
before insert or update on public.gp_bonus_rules
for each row execute function public._gp_bonus_rules_sync_active_flags();






