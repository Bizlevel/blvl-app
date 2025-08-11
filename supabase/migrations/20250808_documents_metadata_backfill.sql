-- 26.10: Documents metadata backfill using mapping table

-- Ensure mapping table exists (populated externally by script)
create table if not exists public.documents_backfill_map (
  file_id text primary key,
  level_id int,
  skill_id int,
  title text,
  section text,
  tags text[]
);

-- Perform backfill (idempotent update)
update public.documents d
set metadata = coalesce(d.metadata, '{}'::jsonb)
              || coalesce(jsonb_build_object('level_id', m.level_id), '{}'::jsonb)
              || coalesce(jsonb_build_object('skill_id', m.skill_id), '{}'::jsonb)
              || coalesce(jsonb_build_object('title', m.title), '{}'::jsonb)
              || coalesce(jsonb_build_object('section', m.section), '{}'::jsonb)
              || coalesce(jsonb_build_object('tags', to_jsonb(m.tags)), '{}'::jsonb)
from public.documents_backfill_map m
where (d.metadata->>'file_id') is not null
  and m.file_id = (d.metadata->>'file_id')
  and (
    (d.metadata ? 'level_id') is false
    or (d.metadata ? 'skill_id') is false
    or (d.metadata ? 'title') is false
    or (d.metadata ? 'section') is false
    or (d.metadata ? 'tags') is false
  );


