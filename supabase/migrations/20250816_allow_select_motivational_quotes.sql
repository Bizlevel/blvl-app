-- Allow public read of motivational_quotes (RLS is enabled but no policy existed)
alter table if exists public.motivational_quotes enable row level security;

do $$ begin
  if not exists (
    select 1 from pg_policies
    where schemaname = 'public'
      and tablename = 'motivational_quotes'
      and policyname = 'motivational_quotes_read_all'
  ) then
    create policy motivational_quotes_read_all on public.motivational_quotes
      for select to anon, authenticated
      using (true);
  end if;
end $$;

