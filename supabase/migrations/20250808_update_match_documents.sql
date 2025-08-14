-- 26.9: Update match_documents to support metadata filtering before ANN

create or replace function public.match_documents(
  query_embedding vector(1536),
  match_threshold double precision,
  match_count integer,
  metadata_filter jsonb default '{}'::jsonb
)
returns table(
  content text,
  metadata jsonb,
  similarity double precision
)
language sql
stable
as $$
  select
    d.content,
    d.metadata,
    1 - (d.embedding <=> query_embedding) as similarity
  from public.documents d
  where
    -- Apply metadata filters if provided (AND semantics)
    (coalesce((metadata_filter ? 'level_id')::boolean, false) is false or (d.metadata->>'level_id')::int = (metadata_filter->>'level_id')::int)
    and (coalesce((metadata_filter ? 'skill_id')::boolean, false) is false or (d.metadata->>'skill_id')::int = (metadata_filter->>'skill_id')::int)
    and (
      coalesce((metadata_filter ? 'tags')::boolean, false) is false
      or (
        exists (
          select 1
          from jsonb_array_elements_text(coalesce(metadata_filter->'tags', '[]'::jsonb)) t(tag)
          where (d.metadata->'tags') ? t.tag
        )
      )
    )
    and (1 - (d.embedding <=> query_embedding)) >= match_threshold
  order by d.embedding <=> query_embedding asc
  limit match_count;
$$;


