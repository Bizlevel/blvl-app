-- Migration: Add atomic update function for idea_validations
-- Date: 2024-12-19
-- Description: Creates RPC function for atomic update of validation state (slots_state, current_step, retry_count)
-- This ensures transactional guarantee: all fields update together or rollback

BEGIN;

-- Функция для атомарного обновления состояния валидации
-- Обновляет slots_state, current_step и retry_count в одной транзакции
-- Гарантирует, что либо все поля обновятся, либо ничего не изменится
CREATE OR REPLACE FUNCTION public.update_validation_atomic(
  p_validation_id UUID,
  p_user_id UUID,
  p_slots_state JSONB DEFAULT NULL,
  p_current_step INT DEFAULT NULL,
  p_retry_count INT DEFAULT NULL
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_updated_rows INT;
BEGIN
  -- Проверка существования записи и принадлежности пользователю
  IF NOT EXISTS (
    SELECT 1 
    FROM public.idea_validations 
    WHERE id = p_validation_id 
      AND user_id = p_user_id
  ) THEN
    RAISE EXCEPTION 'Validation not found or access denied: validation_id=%, user_id=%', 
      p_validation_id, p_user_id;
  END IF;

  -- Атомарное обновление всех полей в одной транзакции
  UPDATE public.idea_validations
  SET
    -- Обновляем slots_state только если передан (NULL = не обновлять)
    slots_state = COALESCE(p_slots_state, slots_state),
    -- Обновляем current_step только если передан, с ограничением MAX_STEPS = 7
    current_step = CASE 
      WHEN p_current_step IS NOT NULL THEN LEAST(p_current_step, 7)
      ELSE current_step
    END,
    -- Обновляем retry_count только если передан
    retry_count = COALESCE(p_retry_count, retry_count)
  WHERE id = p_validation_id
    AND user_id = p_user_id;

  -- Проверка, что обновление произошло
  GET DIAGNOSTICS v_updated_rows = ROW_COUNT;
  
  IF v_updated_rows = 0 THEN
    RAISE EXCEPTION 'Failed to update validation: validation_id=%, user_id=%', 
      p_validation_id, p_user_id;
  END IF;
END;
$$;

-- Комментарий к функции
COMMENT ON FUNCTION public.update_validation_atomic IS 
'Atomically updates validation state (slots_state, current_step, retry_count) in a single transaction.
Ensures all-or-nothing update: either all fields update together or rollback.
Used by val-chat Edge Function for transactional guarantee.';

-- Предоставляем доступ authenticated пользователям
GRANT EXECUTE ON FUNCTION public.update_validation_atomic(UUID, UUID, JSONB, INT, INT) 
  TO authenticated;

COMMIT;
