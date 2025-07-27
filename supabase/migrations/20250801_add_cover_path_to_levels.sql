-- Добавляет колонку cover_path в таблицу levels, если отсутствует
alter table public.levels
    add column if not exists cover_path text;

-- RLS-политики уже настроены на уровне таблицы; дополнительных изменений не требуется. 