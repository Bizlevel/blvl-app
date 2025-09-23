-- Fix update_current_level RPC to award skills points
-- This migration updates the RPC function to properly award skill points when completing levels

BEGIN;

-- 1. Update the RPC function to include skills points awarding
CREATE OR REPLACE FUNCTION public.update_current_level(p_level_id integer)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER SET search_path TO public AS $$
DECLARE
  lvl_num integer;
  lvl_skill_id integer;
BEGIN
  -- Get level number and skill_id
  SELECT number, skill_id INTO lvl_num, lvl_skill_id 
  FROM levels WHERE id = p_level_id;

  -- If level not found, exit without changes
  IF lvl_num IS NULL THEN
    RAISE NOTICE 'Level id % not found', p_level_id;
    RETURN;
  END IF;

  -- Update current_level only if it's less than the next level
  UPDATE users
  SET current_level = lvl_num + 1
  WHERE id = auth.uid()
    AND (current_level IS NULL OR current_level < lvl_num + 1);

  -- Award skill points if skill_id is not NULL
  IF lvl_skill_id IS NOT NULL THEN
    -- Upsert skill points (+1 point)
    INSERT INTO user_skills (user_id, skill_id, points)
    VALUES (auth.uid(), lvl_skill_id, 1)
    ON CONFLICT (user_id, skill_id)
    DO UPDATE SET 
      points = user_skills.points + 1,
      updated_at = now();
  END IF;
END;
$$;

-- 2. Add performance indexes if they don't exist
CREATE INDEX IF NOT EXISTS idx_levels_skill_id ON public.levels(skill_id);
CREATE INDEX IF NOT EXISTS idx_user_skills_skill ON public.user_skills(skill_id);
CREATE INDEX IF NOT EXISTS idx_user_progress_level_id ON public.user_progress(level_id);

COMMIT;
