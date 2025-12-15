-- Migration: Расширение leo_chats для поддержки бота Валли
-- Цель: добавить 'vali' в список допустимых значений bot
-- Safe to run multiple times (idempotent)

BEGIN;

-- Удаляем существующий CHECK constraint (если есть)
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'leo_chats_bot_chk'
  ) THEN
    ALTER TABLE public.leo_chats DROP CONSTRAINT leo_chats_bot_chk;
  END IF;
END$$;

-- Добавляем новый CHECK constraint с поддержкой 'vali'
ALTER TABLE public.leo_chats 
  ADD CONSTRAINT leo_chats_bot_chk CHECK (bot IN ('leo', 'max', 'vali'));

COMMIT;
