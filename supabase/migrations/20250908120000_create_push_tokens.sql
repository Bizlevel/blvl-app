-- Create push_tokens table for FCM device tokens
-- Owner-only RLS policies

create extension if not exists "pgcrypto";

create table if not exists public.push_tokens (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  token text not null,
  platform text not null check (platform in ('android','ios','web')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, token)
);

create index if not exists push_tokens_user_id_idx on public.push_tokens(user_id);

alter table public.push_tokens enable row level security;

create policy "push_tokens_owner_select" on public.push_tokens
  for select using (auth.uid() = user_id);

create policy "push_tokens_owner_insert" on public.push_tokens
  for insert with check (auth.uid() = user_id);

create policy "push_tokens_owner_update" on public.push_tokens
  for update using (auth.uid() = user_id);

create policy "push_tokens_owner_delete" on public.push_tokens
  for delete using (auth.uid() = user_id);

create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists set_updated_at_on_push_tokens on public.push_tokens;

create trigger set_updated_at_on_push_tokens
before update on public.push_tokens
for each row
execute function public.set_updated_at();


