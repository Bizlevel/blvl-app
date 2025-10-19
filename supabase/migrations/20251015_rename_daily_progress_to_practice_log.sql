-- Rename daily_progress -> practice_log and reshape columns
do $$
begin
  -- If practice_log already exists, skip rename
  if to_regclass('public.practice_log') is null and to_regclass('public.daily_progress') is not null then
    alter table public.daily_progress rename to practice_log;
  end if;
exception when others then
  -- noop: allow idempotent reruns
  null;
end $$;

-- Add / adjust columns (idempotent guards)
do $$
begin
  if to_regclass('public.practice_log') is null then
    create table public.practice_log (
      id uuid primary key default gen_random_uuid(),
      user_id uuid not null references auth.users(id) on delete cascade,
      applied_at date not null default (now()::date),
      applied_tools text[] not null default '{}',
      note text,
      created_at timestamptz not null default now(),
      updated_at timestamptz not null default now()
    );
    alter table public.practice_log enable row level security;
  else
    -- Drop 28-day centric columns if exist
    begin
      alter table public.practice_log drop column if exists day_number;
    exception when undefined_column then null; end;
    -- Ensure new columns exist
    begin
      alter table public.practice_log add column if not exists applied_at date default (now()::date);
    exception when duplicate_column then null; end;
    begin
      alter table public.practice_log add column if not exists applied_tools text[] default '{}';
    exception when duplicate_column then null; end;
    begin
      alter table public.practice_log add column if not exists note text;
    exception when duplicate_column then null; end;
  end if;
end $$;

-- updated_at trigger
drop trigger if exists trg_practice_log_updated_at on public.practice_log;
create trigger trg_practice_log_updated_at
before update on public.practice_log
for each row execute function public.set_updated_at();

-- RLS policies owner-only (idempotent)
do $$
begin
  if not exists (
    select 1 from pg_policies where schemaname='public' and tablename='practice_log' and policyname='Allow owner select'
  ) then
    create policy "Allow owner select" on public.practice_log for select using (auth.uid() = user_id);
  end if;
  if not exists (
    select 1 from pg_policies where schemaname='public' and tablename='practice_log' and policyname='Allow owner insert'
  ) then
    create policy "Allow owner insert" on public.practice_log for insert with check (auth.uid() = user_id);
  end if;
  if not exists (
    select 1 from pg_policies where schemaname='public' and tablename='practice_log' and policyname='Allow owner update'
  ) then
    create policy "Allow owner update" on public.practice_log for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
  end if;
  if not exists (
    select 1 from pg_policies where schemaname='public' and tablename='practice_log' and policyname='Allow owner delete'
  ) then
    create policy "Allow owner delete" on public.practice_log for delete using (auth.uid() = user_id);
  end if;
end $$;

-- helpful indexes
create index if not exists idx_practice_log_user on public.practice_log(user_id);
create index if not exists idx_practice_log_applied_at on public.practice_log(user_id, applied_at desc);


