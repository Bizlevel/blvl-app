-- Этап 25.2: Добавление стартового уровня 0 «Первый шаг» и урока-онбординга
-- А также дефолта для users.current_level = 0 и корректировки существующих записей

-- 1) Дефолт для текущего уровня пользователя = 0 (для новых пользователей)
alter table public.users
    alter column current_level set default 0;

-- 2) Корректировка существующих пользователей: если current_level NULL или < 1, установить 0
update public.users
   set current_level = 0
 where current_level is null or current_level < 1;

-- 3) Добавление уровня 0 «Первый шаг», если ещё не существует
with existing as (
  select id from public.levels where number = 0
),
ins as (
  insert into public.levels (
    number,
    title,
    description,
    image_url,
    cover_path,
    is_free,
    artifact_title,
    artifact_description,
    artifact_url,
    created_at
  )
  select
    0,
    'Первый шаг',
    'Стартовый уровень: знакомство с BizLevel и настройка профиля.',
    coalesce((select image_url from public.levels where number = 1 limit 1), ''),
    null,
    true,
    '' , -- artifact_title (NOT NULL)
    '' , -- artifact_description (NOT NULL)
    '' , -- artifact_url (NOT NULL)
    now()
  where not exists (select 1 from existing)
  returning id
),
lvl as (
  select id from existing
  union all
  select id from ins
  limit 1
)
-- 4) Добавление урока-онбординга для уровня 0 (если ещё нет ни одного урока у уровня)
insert into public.lessons (
  level_id,
  "order",
  title,
  description,
  video_url,
  vimeo_id,
  duration_minutes,
  quiz_questions,
  correct_answers,
  created_at
)
select
  (select id from lvl limit 1) as level_id,
  1 as "order",
  'Онбординг' as title,
  'Краткое видео о том, как пользоваться приложением.' as description,
  null as video_url,
  null as vimeo_id,
  5 as duration_minutes,
  '[]'::jsonb as quiz_questions,
  '[]'::jsonb as correct_answers,
  now() as created_at
where not exists (
  select 1 from public.lessons l
   where l.level_id = (select id from lvl limit 1)
);


