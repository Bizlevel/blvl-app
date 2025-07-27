-- Добавляет колонку avatar_id в таблицу users
alter table public.users
    add column if not exists avatar_id int;

-- Удаляем устаревшее хранение ссылок на аватар (оставляем колонку, но больше не используем)
-- alter table public.users
--     drop column if exists avatar_url; 