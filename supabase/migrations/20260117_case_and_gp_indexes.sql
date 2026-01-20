-- Ensure only one active mini-case per after_level
create unique index if not exists mini_cases_active_after_level_uniq
on public.mini_cases (after_level)
where active = true;

-- Remove duplicate idempotency index (keep idx_gp_ledger_idem)
drop index if exists public.gp_ledger_idempotency_key_idx;
