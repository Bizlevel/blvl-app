-- 26.1: Personalization & Long-term Memories
-- Add persona/summary fields and user_memories table with RLS and ANN index

-- Extensions (id/uuid gen + vectors)
create extension if not exists pgcrypto;
create extension if not exists vector;

-- Users: persona summary
alter table public.users
  add column if not exists persona_summary text;

-- Leo chats: short summary and last topics
alter table if exists public.leo_chats
  add column if not exists summary text,
  add column if not exists last_topics jsonb not null default '[]'::jsonb;

-- Long-term user memories
create table if not exists public.user_memories (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users(id) on delete cascade,
  content text not null,
  embedding vector(1536),
  weight integer not null default 1,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Ensure semantic uniqueness to support upserts by (user_id, content)
-- Use a unique index instead of constraint to allow IF NOT EXISTS
create unique index if not exists user_memories_user_content_uidx
  on public.user_memories(user_id, content);

-- Helpful composite index for recent items per user
create index if not exists user_memories_user_time_idx
  on public.user_memories(user_id, updated_at desc);

-- ANN index for embeddings: prefer HNSW, fallback to IVFFLAT if HNSW/opclass unavailable
do $$
begin
  begin
    execute 'create index if not exists user_memories_embedding_hnsw on public.user_memories using hnsw (embedding vector_cosine_ops) with (m=16, ef_construction=64)';
  exception
    when undefined_object then
      execute 'create index if not exists user_memories_embedding_ivfflat on public.user_memories using ivfflat (embedding vector_cosine_ops) with (lists=100)';
    when feature_not_supported then
      execute 'create index if not exists user_memories_embedding_ivfflat on public.user_memories using ivfflat (embedding vector_cosine_ops) with (lists=100)';
  end;
end $$;

-- RLS: per-user isolation
alter table public.user_memories enable row level security;

drop policy if exists "Allow select own memories" on public.user_memories;
drop policy if exists "Allow insert own memories" on public.user_memories;
drop policy if exists "Allow update own memories" on public.user_memories;
drop policy if exists "Allow delete own memories" on public.user_memories;

create policy "Allow select own memories" on public.user_memories
  for select using (auth.uid() = user_id);

create policy "Allow insert own memories" on public.user_memories
  for insert with check (auth.uid() = user_id);

create policy "Allow update own memories" on public.user_memories
  for update using (auth.uid() = user_id);

create policy "Allow delete own memories" on public.user_memories
  for delete using (auth.uid() = user_id);


