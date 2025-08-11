-- Create table to mark processed chat messages for leo-memory cron
create table if not exists public.leo_messages_processed (
  message_id uuid primary key,
  processed_at timestamptz not null default now()
);

-- Disable RLS (service-role only via Edge Function)
alter table public.leo_messages_processed disable row level security;


