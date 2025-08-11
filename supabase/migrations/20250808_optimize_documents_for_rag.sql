-- 26.6: Optimize documents for RAG (indexes + metadata enrichment)

-- Ensure required extensions
create extension if not exists vector;

-- ANN index on documents.embedding: prefer HNSW, fallback to IVFFLAT
do $$
begin
  begin
    execute 'create index if not exists documents_embedding_hnsw on public.documents using hnsw (embedding vector_cosine_ops) with (m=16, ef_construction=64)';
  exception
    when undefined_object then
      execute 'create index if not exists documents_embedding_ivfflat on public.documents using ivfflat (embedding vector_cosine_ops) with (lists=100)';
    when feature_not_supported then
      execute 'create index if not exists documents_embedding_ivfflat on public.documents using ivfflat (embedding vector_cosine_ops) with (lists=100)';
  end;
end $$;

-- JSONB GIN index for metadata filters
create index if not exists documents_metadata_gin on public.documents using gin (metadata);

-- Temporary mapping table for metadata backfill (idempotent; safe to keep empty)
create table if not exists public.documents_backfill_map (
  file_id text primary key,
  level_id int,
  skill_id int,
  title text,
  section text,
  tags text[]
);

-- Backfill metadata keys from mapping where missing; will no-op if mapping empty
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


