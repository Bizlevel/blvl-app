-- Migration: Allow current_step = 0 for onboarding (Step 0)
-- Date: 2024-12-18
-- Description: Updates check constraint on current_step to allow 0 for onboarding phase
-- Safe to run multiple times (idempotent)

BEGIN;

-- Drop the old constraint (PostgreSQL auto-generated name might be different)
DO $$
DECLARE
  constraint_name TEXT;
BEGIN
  -- Find the constraint name
  SELECT conname INTO constraint_name
  FROM pg_constraint
  WHERE conrelid = 'public.idea_validations'::regclass
    AND contype = 'c'
    AND pg_get_constraintdef(oid) LIKE '%current_step%'
  LIMIT 1;
  
  -- Drop it if found
  IF constraint_name IS NOT NULL THEN
    EXECUTE format('ALTER TABLE public.idea_validations DROP CONSTRAINT %I', constraint_name);
  END IF;
END$$;

-- Add new constraint that allows 0-7 (0 = onboarding, 1-7 = validation steps)
ALTER TABLE public.idea_validations 
ADD CONSTRAINT idea_validations_current_step_check 
CHECK (current_step >= 0 AND current_step <= 7);

-- Update default to 0 (onboarding) for new validations
ALTER TABLE public.idea_validations 
ALTER COLUMN current_step SET DEFAULT 0;

COMMIT;
