-- Migration: 28.1 Goal feature core tables, RLS, triggers, and quotes seed
-- Safe to run multiple times (idempotent where possible)

-- Extensions
create extension if not exists "pgcrypto";

-- =============================================
-- Tables
-- =============================================

-- core_goals: goal versions 1..4 per user
create table if not exists public.core_goals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null,
  version int not null check (version between 1 and 4),
  goal_text text,
  version_data jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, version)
);

create index if not exists core_goals_user_updated_idx
  on public.core_goals(user_id, updated_at desc);

-- weekly_progress: weekly sprint check-ins
create table if not exists public.weekly_progress (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null,
  sprint_number int not null check (sprint_number between 1 and 4),
  achievement text,
  metric_actual text,
  used_artifacts boolean,
  consulted_leo boolean,
  applied_techniques boolean,
  key_insight text,
  created_at timestamptz not null default now()
);

create index if not exists weekly_progress_user_sprint_idx
  on public.weekly_progress(user_id, sprint_number desc);

-- reminder_checks: daily reminders (1..28)
create table if not exists public.reminder_checks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null,
  day_number int not null check (day_number between 1 and 28),
  reminder_text text,
  is_completed boolean not null default false,
  completed_at timestamptz,
  created_at timestamptz not null default now(),
  unique (user_id, day_number)
);

-- motivational_quotes: public read, no RLS required
create table if not exists public.motivational_quotes (
  id uuid primary key default gen_random_uuid(),
  quote_text text not null,
  author text,
  category text,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create index if not exists motivational_quotes_active_idx
  on public.motivational_quotes(is_active);

-- =============================================
-- RLS and Policies (owner-only for user-bound tables)
-- =============================================

alter table public.core_goals enable row level security;
alter table public.weekly_progress enable row level security;
alter table public.reminder_checks enable row level security;

-- core_goals policies
do $$ begin
  if not exists (
    select 1 from pg_policies where schemaname='public' and tablename='core_goals' and policyname='core_goals_owner_select'
  ) then
    create policy core_goals_owner_select on public.core_goals for select
      to authenticated using (auth.uid() = user_id);
  end if;
  if not exists (
    select 1 from pg_policies where schemaname='public' and tablename='core_goals' and policyname='core_goals_owner_all'
  ) then
    create policy core_goals_owner_all on public.core_goals for all
      to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
  end if;
end $$;

-- weekly_progress policies
do $$ begin
  if not exists (
    select 1 from pg_policies where schemaname='public' and tablename='weekly_progress' and policyname='weekly_progress_owner_select'
  ) then
    create policy weekly_progress_owner_select on public.weekly_progress for select
      to authenticated using (auth.uid() = user_id);
  end if;
  if not exists (
    select 1 from pg_policies where schemaname='public' and tablename='weekly_progress' and policyname='weekly_progress_owner_all'
  ) then
    create policy weekly_progress_owner_all on public.weekly_progress for all
      to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
  end if;
end $$;

-- reminder_checks policies
do $$ begin
  if not exists (
    select 1 from pg_policies where schemaname='public' and tablename='reminder_checks' and policyname='reminder_checks_owner_select'
  ) then
    create policy reminder_checks_owner_select on public.reminder_checks for select
      to authenticated using (auth.uid() = user_id);
  end if;
  if not exists (
    select 1 from pg_policies where schemaname='public' and tablename='reminder_checks' and policyname='reminder_checks_owner_all'
  ) then
    create policy reminder_checks_owner_all on public.reminder_checks for all
      to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
  end if;
end $$;

-- =============================================
-- Triggers to enforce ownership and timestamps
-- =============================================

-- set user_id to auth.uid() on insert
create or replace function public.tg_set_user_id()
returns trigger language plpgsql as $$
begin
  new.user_id := auth.uid();
  return new;
end; $$;

-- maintain updated_at
create or replace function public.tg_set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at := now();
  return new;
end; $$;

-- core_goals: allow updates only for latest version and forbid changing version
create or replace function public.tg_core_goals_update_guard()
returns trigger language plpgsql as $$
declare
  latest int;
begin
  if new.user_id <> old.user_id then
    raise exception 'Changing user_id is not allowed';
  end if;
  if new.version <> old.version then
    raise exception 'Changing version is not allowed';
  end if;
  select max(version) into latest from public.core_goals where user_id = auth.uid();
  if latest is null then
    latest := old.version; -- safety
  end if;
  if old.version <> latest then
    raise exception 'Only the latest version can be edited';
  end if;
  return new;
end; $$;

-- Attach triggers
do $$ begin
  -- core_goals
  if not exists (
    select 1 from pg_trigger where tgname = 'trg_core_goals_set_user_id'
  ) then
    create trigger trg_core_goals_set_user_id
      before insert on public.core_goals
      for each row execute function public.tg_set_user_id();
  end if;
  if not exists (
    select 1 from pg_trigger where tgname = 'trg_core_goals_updated_at'
  ) then
    create trigger trg_core_goals_updated_at
      before update on public.core_goals
      for each row execute function public.tg_set_updated_at();
  end if;
  if not exists (
    select 1 from pg_trigger where tgname = 'trg_core_goals_update_guard'
  ) then
    create trigger trg_core_goals_update_guard
      before update on public.core_goals
      for each row execute function public.tg_core_goals_update_guard();
  end if;

  -- weekly_progress
  if not exists (
    select 1 from pg_trigger where tgname = 'trg_weekly_progress_set_user_id'
  ) then
    create trigger trg_weekly_progress_set_user_id
      before insert on public.weekly_progress
      for each row execute function public.tg_set_user_id();
  end if;

  -- reminder_checks
  if not exists (
    select 1 from pg_trigger where tgname = 'trg_reminder_checks_set_user_id'
  ) then
    create trigger trg_reminder_checks_set_user_id
      before insert on public.reminder_checks
      for each row execute function public.tg_set_user_id();
  end if;
end $$;

-- =============================================
-- Seed data: Motivational Quotes (idempotent upsert by (quote_text, author))
-- =============================================

-- helper upsert function
create or replace function public.upsert_quote(p_text text, p_author text, p_category text)
returns void language plpgsql as $$
begin
  -- insert if not exists; uniqueness by text+author
  insert into public.motivational_quotes (id, quote_text, author, category, is_active)
  values (gen_random_uuid(), p_text, p_author, p_category, true)
  on conflict do nothing;
end $$;

-- Focus & Goal-setting (1..5)
select public.upsert_quote('Цель без плана — это просто желание.', 'Антуан де Сент-Экзюпери', 'focus');
select public.upsert_quote('Фокус — это умение сказать нет сотне хороших идей.', 'Стив Джобс', 'focus');
select public.upsert_quote('Ставьте цели, которые заставляют вас прыгать с кровати по утрам.', 'Ричард Брэнсон', 'focus');
select public.upsert_quote('Если вы не знаете, куда идёте, любая дорога приведёт вас туда.', 'Льюис Кэрролл', 'focus');
select public.upsert_quote('Цель — это мечта с дедлайном.', 'Наполеон Хилл', 'focus');

-- Action & Progress (6..10)
select public.upsert_quote('Путь в тысячу ли начинается с первого шага.', 'Лао-цзы', 'action');
select public.upsert_quote('Совершенство — не когда нечего добавить, а когда нечего убрать.', 'Антуан де Сент-Экзюпери', 'action');
select public.upsert_quote('Прогресс невозможен без изменений.', 'Джордж Бернард Шоу', 'action');
select public.upsert_quote('Делай сегодня то, что другие не хотят, завтра будешь жить так, как другие не могут.', 'Джерри Райс', 'action');
select public.upsert_quote('Успех — это сумма маленьких усилий, повторяемых день за днём.', 'Роберт Кольер', 'action');

-- Perseverance (11..15)
select public.upsert_quote('Я не проиграл. Я просто нашёл 10 000 способов, которые не работают.', 'Томас Эдисон', 'perseverance');
select public.upsert_quote('Неудача — это приправа, которая придаёт успеху его вкус.', 'Трумэн Капоте', 'perseverance');
select public.upsert_quote('Чемпионы продолжают играть, пока не добьются успеха.', 'Билли Джин Кинг', 'perseverance');
select public.upsert_quote('Упади семь раз, встань восемь.', 'Японская пословица', 'perseverance');
select public.upsert_quote('Единственный способ делать великую работу — любить то, что делаешь.', 'Стив Джобс', 'perseverance');

-- Vision & Ambition (16..20)
select public.upsert_quote('Будущее принадлежит тем, кто верит в красоту своей мечты.', 'Элеонора Рузвельт', 'vision');
select public.upsert_quote('Стреляйте в луну. Даже если промахнётесь, окажетесь среди звёзд.', 'Лес Браун', 'vision');
select public.upsert_quote('Ваше время ограничено, не тратьте его на чужую жизнь.', 'Стив Джобс', 'vision');
select public.upsert_quote('Если ваши мечты не пугают вас, они недостаточно велики.', 'Эллен Джонсон-Серлиф', 'vision');
select public.upsert_quote('Логика доведёт вас от А до Б. Воображение — куда угодно.', 'Альберт Эйнштейн', 'vision');

-- Discipline (21..25)
select public.upsert_quote('Мотивация заставляет начать. Привычка заставляет продолжать.', 'Джим Рон', 'discipline');
select public.upsert_quote('Дисциплина — это мост между целями и достижениями.', 'Джим Рон', 'discipline');
select public.upsert_quote('Мы есть то, что делаем постоянно. Совершенство — это не действие, а привычка.', 'Аристотель', 'discipline');
select public.upsert_quote('Успешные люди делают то, что неуспешные не хотят делать.', 'Джефф Олсон', 'discipline');
select public.upsert_quote('Секрет успеха в том, чтобы начать.', 'Марк Твен', 'discipline');

-- Opportunity (26..30)
select public.upsert_quote('В середине трудности лежит возможность.', 'Альберт Эйнштейн', 'opportunity');
select public.upsert_quote('Пессимист видит трудность в каждой возможности, оптимист — возможность в каждой трудности.', 'Уинстон Черчилль', 'opportunity');
select public.upsert_quote('Единственное невозможное — это то, что вы решили не делать.', 'Илон Маск', 'opportunity');
select public.upsert_quote('Лучшее время посадить дерево было 20 лет назад. Второе лучшее время — сейчас.', 'Китайская пословица', 'opportunity');
select public.upsert_quote('Возможности не приходят сами. Вы их создаёте.', 'Крис Гроссер', 'opportunity');

-- Results (31..35)
select public.upsert_quote('Результаты происходят со временем, а не сразу.', 'Уоррен Баффет', 'results');
select public.upsert_quote('Измеряйте всё важное. То, что измеряется, улучшается.', 'Питер Друкер', 'results');
select public.upsert_quote('Не считайте дни, сделайте так, чтобы дни считались.', 'Мохаммед Али', 'results');
select public.upsert_quote('Качество — это не действие, а привычка.', 'Аристотель', 'results');
select public.upsert_quote('Делайте что-то сегодня, за что ваше будущее я скажет спасибо.', 'Шон Патрик Флэнери', 'results');

-- Courage & Risk (36..40)
select public.upsert_quote('Корабль в гавани безопасен, но не для этого строят корабли.', 'Джон Ширра', 'courage');
select public.upsert_quote('Самый большой риск — не рисковать вообще.', 'Марк Цукерберг', 'courage');
select public.upsert_quote('Делай то, что можешь, с тем, что имеешь, там, где ты есть.', 'Теодор Рузвельт', 'courage');
select public.upsert_quote('20 лет спустя вы будете сожалеть о том, чего не сделали, а не о том, что сделали.', 'Марк Твен', 'courage');
select public.upsert_quote('Страх — это всего лишь состояние ума.', 'Наполеон Хилл', 'courage');

-- Simplicity & Clarity (41..45)
select public.upsert_quote('Простота — высшая степень утончённости.', 'Леонардо да Винчи', 'simplicity');
select public.upsert_quote('Усложнять просто, упрощать сложно.', 'Стив Джобс', 'simplicity');
select public.upsert_quote('Ясность приходит от вовлечённости, а не от размышлений.', 'Мария Форлео', 'simplicity');
select public.upsert_quote('Если вы не можете объяснить это просто, вы недостаточно хорошо это понимаете.', 'Альберт Эйнштейн', 'simplicity');
select public.upsert_quote('Величайшее богатство — жить, довольствуясь малым.', 'Платон', 'simplicity');

-- Time & Priorities (46..50)
select public.upsert_quote('Не говорите, что у вас нет времени. У вас столько же часов в сутках, сколько было у Леонардо да Винчи.', 'Х. Джексон Браун', 'time');
select public.upsert_quote('Ключ не в расстановке приоритетов в вашем расписании, а в планировании ваших приоритетов.', 'Стивен Кови', 'time');
select public.upsert_quote('Время — самый ценный ресурс. Его нельзя купить, но можно потерять.', 'Питер Друкер', 'time');
select public.upsert_quote('Вы можете делать что угодно, но не всё.', 'Дэвид Аллен', 'time');
select public.upsert_quote('Каждое утро у вас есть два выбора: продолжить спать с мечтами или проснуться и идти их осуществлять.', 'Кармело Энтони', 'time');

-- Cleanup helper
drop function if exists public.upsert_quote(text, text, text);


