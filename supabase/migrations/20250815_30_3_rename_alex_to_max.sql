-- Этап 30.3: Переименование бота 'alex' -> 'max'
-- Цель: унифицировать имя бота‑трекера в БД

BEGIN;

-- 1) Приведение существующих данных
UPDATE public.leo_chats SET bot = 'max' WHERE bot = 'alex';

-- 2) Обновление CHECK‑ограничения на допустимые значения
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'leo_chats_bot_chk'
  ) THEN
    ALTER TABLE public.leo_chats DROP CONSTRAINT leo_chats_bot_chk;
  END IF;
END$$;

ALTER TABLE public.leo_chats
  ADD CONSTRAINT leo_chats_bot_chk CHECK (bot IN ('leo','max'));

COMMIT;


