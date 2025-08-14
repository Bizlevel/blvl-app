-- Этап 29.1: Добавление колонки bot в public.leo_chats
-- Цель: маркировать чаты по боту ('leo' | 'alex') для разделения списков и поведения

BEGIN;

-- 1) Добавить колонку (если отсутствует)
ALTER TABLE public.leo_chats
  ADD COLUMN IF NOT EXISTS bot text;

-- 2) Бэкфилл существующих строк
UPDATE public.leo_chats
   SET bot = 'leo'
 WHERE bot IS NULL;

-- 3) Значение по умолчанию и NOT NULL
ALTER TABLE public.leo_chats
  ALTER COLUMN bot SET DEFAULT 'leo';

ALTER TABLE public.leo_chats
  ALTER COLUMN bot SET NOT NULL;

-- 4) Ограничение допустимых значений
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'leo_chats_bot_chk'
  ) THEN
    ALTER TABLE public.leo_chats
      ADD CONSTRAINT leo_chats_bot_chk CHECK (bot IN ('leo','alex'));
  END IF;
END$$;

-- 5) Индекс для выборок списков
CREATE INDEX IF NOT EXISTS idx_leo_chats_user_bot_updated
  ON public.leo_chats(user_id, bot, updated_at DESC);

COMMIT;


