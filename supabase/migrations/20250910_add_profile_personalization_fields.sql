-- Добавляет поля персонализации профиля в public.users
-- Минимальные изменения, обратно-совместимо

-- 1) Типы enum (если понадобятся). Для упрощения используем текстовые поля и массивы.
-- Если в будущем потребуется строгая типизация, можно мигрировать text -> enum безопасно.

-- 2) Новые колонки
alter table public.users
  add column if not exists business_size text,
  add column if not exists key_challenges text[],
  add column if not exists learning_style text,
  add column if not exists business_region text;

-- RLS сохраняется существующей политикой владельца; индексы не требуются


