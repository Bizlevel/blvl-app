-- 26.13: Leo Memory Trigger and Anti-duplicate Protection
-- Add app_settings, pg_net integration, call_leo_memory function, and anti-duplicate trigger

-- Enable pg_net extension for HTTP calls from Postgres
create extension if not exists pg_net;

-- Create app_settings table for configuration
create table if not exists public.app_settings (
  key text primary key,
  value text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Insert Leo memory cron secret
insert into public.app_settings (key, value) 
values ('leo_memory_cron_secret', 'Cron_Bizlevel_2025')
on conflict (key) do update set 
  value = excluded.value,
  updated_at = now();

-- Enable RLS on app_settings
alter table public.app_settings enable row level security;

-- Policy for SECURITY DEFINER functions to read settings
create policy "allow_sd_select_app_settings" on public.app_settings
  for select using (true);

-- Function to get Leo memory secret (SECURITY DEFINER)
create or replace function public.get_leo_memory_secret()
returns text
language plpgsql
security definer
as $$
begin
  return (select value from public.app_settings where key = 'leo_memory_cron_secret');
end;
$$;

-- Function to call leo-memory Edge Function (SECURITY DEFINER)
create or replace function public.call_leo_memory(
  message_id uuid,
  chat_id uuid,
  user_id uuid,
  content text,
  level_id int default null
)
returns void
language plpgsql
security definer
as $$
declare
  secret text;
  url text;
  payload jsonb;
  headers jsonb;
  timeout int := 3000; -- 3 seconds
begin
  -- Get secret from app_settings
  secret := public.get_leo_memory_secret();
  
  -- Construct Edge Function URL
  url := current_setting('app.supabase_url') || '/functions/v1/leo-memory';
  
  -- Prepare payload
  payload := jsonb_build_object(
    'message_id', message_id,
    'chat_id', chat_id,
    'user_id', user_id,
    'content', content,
    'level_id', level_id,
    'job', 'trigger'
  );
  
  -- Prepare headers with secret
  headers := jsonb_build_object(
    'Authorization', 'Bearer ' || current_setting('app.service_role_key'),
    'Content-Type', 'application/json',
    'X-Cron-Secret', secret
  );
  
  -- Call Edge Function via pg_net
  perform net.http_post(
    url := url,
    body := payload,
    params := '{}'::jsonb,
    headers := headers,
    timeout_milliseconds := timeout
  );
end;
$$;

-- Function to handle trigger calls (SECURITY DEFINER)
create or replace function public.call_leo_memory_trigger()
returns trigger
language plpgsql
security definer
as $$
begin
  -- Only process assistant messages
  if NEW.role = 'assistant' then
    -- Call leo-memory asynchronously
    perform public.call_leo_memory(
      message_id := NEW.id,
      chat_id := NEW.chat_id,
      user_id := NEW.user_id,
      content := NEW.content
    );
  end if;
  
  return NEW;
end;
$$;

-- Function to deduplicate assistant messages (anti-duplicate)
create or replace function public.leo_messages_dedupe()
returns trigger
language plpgsql
as $$
begin
  -- Check if this is an assistant message
  if NEW.role = 'assistant' then
    -- Look for duplicate assistant messages in the same chat within 3 seconds
    if exists (
      select 1 from public.leo_messages 
      where chat_id = NEW.chat_id 
        and role = 'assistant' 
        and content = NEW.content
        and created_at > NEW.created_at - interval '3 seconds'
        and id != NEW.id
    ) then
      -- Duplicate found, abort insert
      return null;
    end if;
  end if;
  
  return NEW;
end;
$$;

-- Create trigger to call leo-memory after insert
drop trigger if exists trg_call_leo_memory on public.leo_messages;
create trigger trg_call_leo_memory
  after insert on public.leo_messages
  for each row
  execute function public.call_leo_memory_trigger();

-- Create trigger to prevent duplicate assistant messages
drop trigger if exists trg_leo_messages_dedupe on public.leo_messages;
create trigger trg_leo_messages_dedupe
  before insert on public.leo_messages
  for each row
  execute function public.leo_messages_dedupe();

-- Grant necessary permissions
grant usage on schema net to service_role;
grant execute on all functions in schema net to service_role;
