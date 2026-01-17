-- 2026-01-17: Referrals and promo codes (GP rewards)

-- 1) Promo codes
create table if not exists public.promo_codes (
  code text primary key,
  reward_gp integer not null check (reward_gp > 0),
  max_uses integer check (max_uses is null or max_uses > 0),
  used_count integer not null default 0 check (used_count >= 0),
  expires_at timestamptz,
  is_active boolean not null default true,
  campaign text,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.promo_codes enable row level security;

create table if not exists public.promo_redemptions (
  user_id uuid not null references auth.users(id) on delete cascade,
  code text not null references public.promo_codes(code) on delete cascade,
  reward_gp integer not null check (reward_gp > 0),
  redeemed_at timestamptz not null default now(),
  idempotency_key text,
  metadata jsonb not null default '{}'::jsonb,
  primary key (user_id, code)
);

alter table public.promo_redemptions enable row level security;

-- 2) Referral codes and referrals
create table if not exists public.referral_codes (
  user_id uuid primary key references auth.users(id) on delete cascade,
  code text not null unique,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.referral_codes enable row level security;

create table if not exists public.referrals (
  referrer_id uuid not null references auth.users(id) on delete cascade,
  referred_user_id uuid not null references auth.users(id) on delete cascade,
  status text not null check (status in ('registered', 'activated', 'rewarded')),
  reward_gp integer not null check (reward_gp > 0),
  created_at timestamptz not null default now(),
  activated_at timestamptz,
  rewarded_at timestamptz,
  metadata jsonb not null default '{}'::jsonb,
  primary key (referred_user_id)
);

create index if not exists referrals_referrer_idx on public.referrals (referrer_id);
create index if not exists referrals_status_idx on public.referrals (status);

alter table public.referrals enable row level security;

-- Default referral reward (configurable)
insert into public.app_settings(key, value)
values ('referral_reward_gp', '100')
on conflict (key) do nothing;

-- 3) Shared GP bonus helper (for promo/referral payouts)
create or replace function public._gp_apply_bonus(
  p_user_id uuid,
  p_amount integer,
  p_reference_id text,
  p_idempotency_key text,
  p_metadata jsonb
)
returns integer
language plpgsql
security definer
set search_path to 'public'
as $$
declare
  v_balance int;
  v_earned int;
  v_spent int;
begin
  if p_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;
  if p_amount is null or p_amount <= 0 then
    raise exception 'gp_invalid_amount';
  end if;

  insert into public.gp_ledger(
    id,
    user_id,
    amount,
    type,
    reference_id,
    metadata,
    idempotency_key,
    created_at
  ) values (
    gen_random_uuid(),
    p_user_id,
    p_amount,
    'bonus'::public.gp_transaction_type,
    p_reference_id,
    coalesce(p_metadata, '{}'::jsonb),
    p_idempotency_key,
    now()
  )
  on conflict (idempotency_key) do nothing;

  select balance, total_earned, total_spent
    into v_balance, v_earned, v_spent
  from public._gp_compute_wallet(p_user_id);

  insert into public.gp_wallets(user_id, balance, total_earned, total_spent, updated_at)
  values (p_user_id, v_balance, v_earned, v_spent, now())
  on conflict (user_id) do update
    set balance = excluded.balance,
        total_earned = excluded.total_earned,
        total_spent = excluded.total_spent,
        updated_at = now();

  return v_balance;
end;
$$;

-- 4) Referral code getter (generate on demand)
create or replace function public.get_referral_code()
returns text
language plpgsql
security definer
set search_path to 'public'
as $$
declare
  v_user uuid := auth.uid();
  v_code text;
  v_attempts int := 0;
begin
  if v_user is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;

  select code into v_code
  from public.referral_codes
  where user_id = v_user;

  if v_code is not null then
    return v_code;
  end if;

  loop
    v_code := 'BZ' || upper(encode(gen_random_bytes(4), 'hex'));
    begin
      insert into public.referral_codes(user_id, code)
      values (v_user, v_code);
      return v_code;
    exception when unique_violation then
      v_attempts := v_attempts + 1;
      if v_attempts > 5 then
        raise exception 'referral_code_generation_failed';
      end if;
      -- If collision is on user_id, return existing code.
      select code into v_code
      from public.referral_codes
      where user_id = v_user;
      if v_code is not null then
        return v_code;
      end if;
    end;
  end loop;
end;
$$;

-- 5) Apply referral code
create or replace function public.apply_referral_code(p_code text)
returns boolean
language plpgsql
security definer
set search_path to 'public'
as $$
declare
  v_user uuid := auth.uid();
  v_code text := upper(trim(p_code));
  v_referrer uuid;
  v_reward int;
  v_inserted int;
begin
  if v_user is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;
  if v_code is null or length(v_code) < 4 then
    raise exception 'referral_invalid_code';
  end if;

  select user_id into v_referrer
  from public.referral_codes
  where code = v_code;

  if not found or v_referrer is null then
    raise exception 'referral_invalid_code';
  end if;
  if v_referrer = v_user then
    raise exception 'referral_self';
  end if;

  v_reward := coalesce(
    nullif((select value from public.app_settings where key = 'referral_reward_gp'), ''),
    '100'
  )::int;

  insert into public.referrals(
    referrer_id,
    referred_user_id,
    status,
    reward_gp,
    created_at
  ) values (
    v_referrer,
    v_user,
    'registered',
    v_reward,
    now()
  )
  on conflict (referred_user_id) do nothing;

  get diagnostics v_inserted = row_count;
  if v_inserted = 0 then
    raise exception 'referral_already_applied';
  end if;

  return true;
end;
$$;

-- 6) Redeem promo code
create or replace function public.redeem_promo_code(p_code text)
returns table(balance_after integer)
language plpgsql
security definer
set search_path to 'public'
as $$
declare
  v_user uuid := auth.uid();
  v_code text := upper(trim(p_code));
  v_row public.promo_codes%rowtype;
  v_reward int;
  v_idem text;
  v_now timestamptz := now();
begin
  if v_user is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;
  if v_code is null or length(v_code) = 0 then
    raise exception 'promo_invalid_code';
  end if;

  select * into v_row
  from public.promo_codes
  where code = v_code
  for update;

  if not found or v_row.is_active is false then
    raise exception 'promo_invalid_code';
  end if;
  if v_row.expires_at is not null and v_row.expires_at < v_now then
    raise exception 'promo_expired';
  end if;
  if v_row.max_uses is not null and v_row.used_count >= v_row.max_uses then
    raise exception 'promo_exhausted';
  end if;

  insert into public.promo_redemptions(
    user_id,
    code,
    reward_gp,
    redeemed_at,
    idempotency_key,
    metadata
  ) values (
    v_user,
    v_code,
    v_row.reward_gp,
    v_now,
    'promo:' || v_user::text || ':' || v_code,
    jsonb_build_object('campaign', v_row.campaign)
  )
  on conflict (user_id, code) do nothing;

  if not found then
    raise exception 'promo_already_used';
  end if;

  update public.promo_codes
  set used_count = used_count + 1,
      updated_at = v_now
  where code = v_code;

  v_idem := 'promo:' || v_user::text || ':' || v_code;
  v_reward := v_row.reward_gp;

  return query
    select public._gp_apply_bonus(
      v_user,
      v_reward,
      v_code,
      v_idem,
      jsonb_build_object('kind', 'promo', 'code', v_code, 'campaign', v_row.campaign)
    );
end;
$$;

-- 7) Referral reward after completing levels 0 and 1
create or replace function public._referral_has_completed_level(
  p_user_id uuid,
  p_level_number int
)
returns boolean
language plpgsql
security definer
set search_path to 'public'
as $$
declare
  v_level_id int;
begin
  select id into v_level_id from public.levels where number = p_level_number limit 1;
  if v_level_id is null then
    return false;
  end if;
  perform 1
  from public.user_progress
  where user_id = p_user_id
    and level_id = v_level_id
    and is_completed = true;
  return found;
end;
$$;

create or replace function public._grant_referral_reward(p_referred_user uuid)
returns void
language plpgsql
security definer
set search_path to 'public'
as $$
declare
  v_ref public.referrals%rowtype;
  v_reward int;
  v_idem text;
begin
  select * into v_ref
  from public.referrals
  where referred_user_id = p_referred_user
  limit 1;

  if not found then
    return;
  end if;

  if v_ref.rewarded_at is not null then
    return;
  end if;

  update public.referrals
  set status = 'activated',
      activated_at = coalesce(activated_at, now())
  where referred_user_id = p_referred_user
    and status = 'registered';

  v_reward := v_ref.reward_gp;
  v_idem := 'referral:' || v_ref.referrer_id::text || ':' || p_referred_user::text || ':level1';

  perform public._gp_apply_bonus(
    v_ref.referrer_id,
    v_reward,
    p_referred_user::text,
    v_idem,
    jsonb_build_object(
      'kind', 'referral',
      'referred_user_id', p_referred_user
    )
  );

  update public.referrals
  set status = 'rewarded',
      rewarded_at = now()
  where referred_user_id = p_referred_user;
end;
$$;

create or replace function public._on_user_progress_completed()
returns trigger
language plpgsql
security definer
set search_path to 'public'
as $$
declare
  v_level_number int;
  v_ok0 boolean;
begin
  if new.is_completed is true and (old.is_completed is distinct from true) then
    select number into v_level_number from public.levels where id = new.level_id;
    if v_level_number = 1 then
      v_ok0 := public._referral_has_completed_level(new.user_id, 0);
      if v_ok0 then
        perform public._grant_referral_reward(new.user_id);
      end if;
    end if;
  end if;
  return new;
end;
$$;

drop trigger if exists trg_user_progress_referral_reward on public.user_progress;
create trigger trg_user_progress_referral_reward
after insert or update on public.user_progress
for each row
execute function public._on_user_progress_completed();

-- 8) RLS policies
drop policy if exists promo_redemptions_read_own on public.promo_redemptions;
create policy promo_redemptions_read_own
on public.promo_redemptions
for select
using (auth.uid() = user_id);

drop policy if exists referral_codes_read_own on public.referral_codes;
create policy referral_codes_read_own
on public.referral_codes
for select
using (auth.uid() = user_id);

drop policy if exists referrals_read_own on public.referrals;
create policy referrals_read_own
on public.referrals
for select
using (auth.uid() = referrer_id or auth.uid() = referred_user_id);
