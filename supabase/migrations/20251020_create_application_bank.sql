-- Phase 2: application_bank (accumulative ledger of applications)
-- Idempotent creation with RLS owner-only

create table if not exists public.application_bank (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  applied_at timestamptz not null default now(),
  tool text not null,
  note text,
  created_at timestamptz not null default now()
);

-- Indexes for common queries
create index if not exists ix_application_bank_user_applied_at
  on public.application_bank(user_id, applied_at desc);
create index if not exists ix_application_bank_tool
  on public.application_bank(tool);

-- RLS: owner only policies
alter table public.application_bank enable row level security;
do $$ begin
  if not exists (
    select 1 from pg_policies
    where schemaname='public' and tablename='application_bank' and policyname='ab_owner_select'
  ) then
    create policy ab_owner_select on public.application_bank for select using (auth.uid() = user_id);
  end if;
  if not exists (
    select 1 from pg_policies
    where schemaname='public' and tablename='application_bank' and policyname='ab_owner_insert'
  ) then
    create policy ab_owner_insert on public.application_bank for insert with check (auth.uid() = user_id);
  end if;
  if not exists (
    select 1 from pg_policies
    where schemaname='public' and tablename='application_bank' and policyname='ab_owner_update'
  ) then
    create policy ab_owner_update on public.application_bank for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
  end if;
  if not exists (
    select 1 from pg_policies
    where schemaname='public' and tablename='application_bank' and policyname='ab_owner_delete'
  ) then
    create policy ab_owner_delete on public.application_bank for delete using (auth.uid() = user_id);
  end if;
end $$;



