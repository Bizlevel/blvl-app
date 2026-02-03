-- 2026-02-02: Referral bonus to both referrer and referred after L0+L1
-- Logic change: same reward and same condition for both sides.

create or replace function public._grant_referral_reward(p_referred_user uuid)
returns void
language plpgsql
security definer
set search_path to 'public'
as $$
declare
  v_ref public.referrals%rowtype;
  v_reward int;
  v_idem_referrer text;
  v_idem_referred text;
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
  v_idem_referrer := 'referral:referrer:' || v_ref.referrer_id::text || ':' || p_referred_user::text || ':level1';
  v_idem_referred := 'referral:referred:' || p_referred_user::text || ':level1';

  -- Bonus for referrer
  perform public._gp_apply_bonus(
    v_ref.referrer_id,
    v_reward,
    p_referred_user::text,
    v_idem_referrer,
    jsonb_build_object(
      'kind', 'referral',
      'role', 'referrer',
      'referred_user_id', p_referred_user
    )
  );

  -- Bonus for referred user
  perform public._gp_apply_bonus(
    p_referred_user,
    v_reward,
    v_ref.referrer_id::text,
    v_idem_referred,
    jsonb_build_object(
      'kind', 'referral',
      'role', 'referred',
      'referrer_user_id', v_ref.referrer_id
    )
  );

  update public.referrals
  set status = 'rewarded',
      rewarded_at = now()
  where referred_user_id = p_referred_user;
end;
$$;
