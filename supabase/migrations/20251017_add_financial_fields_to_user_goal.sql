-- Add optional fields to user_goal for L4/L7 linkage
ALTER TABLE public.user_goal
  ADD COLUMN IF NOT EXISTS financial_focus text,
  ADD COLUMN IF NOT EXISTS action_plan_note text;

-- Helpful composite index for practice log aggregations (Z/W)
CREATE INDEX IF NOT EXISTS ix_practice_log_user_applied_at
  ON public.practice_log (user_id, applied_at DESC);

-- RLS is assumed owner-only as per project baseline; no changes here


