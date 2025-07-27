BEGIN;

-- 1. Исправляем функцию: записываем следующий номер уровня, а не id.
CREATE OR REPLACE FUNCTION public.update_current_level(p_level_id integer)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER SET search_path TO public AS $$
DECLARE
  lvl_num integer;
BEGIN
  SELECT number INTO lvl_num FROM levels WHERE id = p_level_id;

  -- Если уровень не найден, выходим без изменений
  IF lvl_num IS NULL THEN
    RAISE NOTICE 'Level id % not found', p_level_id;
    RETURN;
  END IF;

  -- Обновляем current_level только если он меньше следующего уровня
  UPDATE users
  SET current_level = lvl_num + 1
  WHERE id = auth.uid()
    AND (current_level IS NULL OR current_level < lvl_num + 1);
END;
$$;

-- 2. Одноразовое исправление "сломанных" current_level, где вместо номера записан id.
UPDATE users u
SET current_level = l.number + 1
FROM levels l
WHERE u.current_level = l.id
  AND u.current_level > 10; -- id уровней начинаются с 11

COMMIT; 