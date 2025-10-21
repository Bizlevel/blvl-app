-- Phase 3: user_rhythm (activity patterns)

create table if not exists public.user_rhythm (
  user_id uuid primary key references auth.users(id) on delete cascade,
  day_of_week smallint[] default '{}',
  hours_histogram jsonb default '{}',
  updated_at timestamptz not null default now()
);

alter table public.user_rhythm enable row level security;
do $$ begin
  if not exists (
    select 1 from pg_policies where schemaname='public' and tablename='user_rhythm' and policyname='ur_owner'
  ) then
    create policy ur_owner on public.user_rhythm using (auth.uid() = user_id) with check (auth.uid() = user_id);
  end if;
end $$;

create or replace function public.refresh_user_rhythm(p_user uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_hours jsonb;
begin
  select jsonb_object_agg(h, cnt) into v_hours
  from (
    select extract(hour from coalesce(pl.applied_at::timestamptz, now()))::int as h,
           count(*) as cnt
    from public.practice_log pl
    where pl.user_id = p_user
    group by 1
  ) s;

  insert into public.user_rhythm as ur(user_id, hours_histogram)
  values (p_user, coalesce(v_hours, '{}'::jsonb))
  on conflict (user_id) do update set hours_histogram = excluded.hours_histogram, updated_at = now();
end;
$$;



