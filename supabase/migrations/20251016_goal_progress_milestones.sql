-- GP bonuses for goal progress milestones (50% and 100%)
-- Idempotent inserts into gp_bonus_rules
insert into public.gp_bonus_rules(rule_key, amount, is_active, single_per_day)
values
  ('goal_progress_50', 30, true, false),
  ('goal_progress_100', 100, true, false)
on conflict (rule_key) do update set
  amount = excluded.amount,
  is_active = excluded.is_active,
  single_per_day = excluded.single_per_day;

-- Helper RPC to claim milestone by key (auth.uid based)
create or replace function public.gp_claim_goal_progress(p_key text)
returns table(balance_after int) as $$
begin
  return query select balance_after from public.gp_bonus_claim(p_key);
end;$$ language plpgsql security definer;



