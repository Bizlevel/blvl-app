-- Create table: user_goal (single goal per user, no versions)
create table if not exists public.user_goal (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  goal_text text not null default '',
  metric_type text,
  metric_current numeric,
  metric_target numeric,
  readiness_score integer,
  start_date date,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint user_goal_user_unique unique (user_id)
);

-- Generic updated_at trigger helper (idempotent)
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists trg_user_goal_updated_at on public.user_goal;
create trigger trg_user_goal_updated_at
before update on public.user_goal
for each row execute function public.set_updated_at();

-- RLS: owner-only
alter table public.user_goal enable row level security;

do $$
begin
  if not exists (
    select 1 from pg_policies where schemaname = 'public' and tablename = 'user_goal' and policyname = 'Allow owner read'
  ) then
    create policy "Allow owner read" on public.user_goal
      for select
      using (auth.uid() = user_id);
  end if;

  if not exists (
    select 1 from pg_policies where schemaname = 'public' and tablename = 'user_goal' and policyname = 'Allow owner insert'
  ) then
    create policy "Allow owner insert" on public.user_goal
      for insert
      with check (auth.uid() = user_id);
  end if;

  if not exists (
    select 1 from pg_policies where schemaname = 'public' and tablename = 'user_goal' and policyname = 'Allow owner update'
  ) then
    create policy "Allow owner update" on public.user_goal
      for update
      using (auth.uid() = user_id)
      with check (auth.uid() = user_id);
  end if;

  if not exists (
    select 1 from pg_policies where schemaname = 'public' and tablename = 'user_goal' and policyname = 'Allow owner delete'
  ) then
    create policy "Allow owner delete" on public.user_goal
      for delete
      using (auth.uid() = user_id);
  end if;
end $$;

-- Helpful indexes
create index if not exists idx_user_goal_user on public.user_goal(user_id);
create index if not exists idx_user_goal_updated_at on public.user_goal(updated_at desc);


