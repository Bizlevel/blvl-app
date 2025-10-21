-- Add target_date to user_goal for progress deadline
ALTER TABLE public.user_goal
  ADD COLUMN IF NOT EXISTS target_date date;

-- Optional index to filter/sort by target_date (reports)
CREATE INDEX IF NOT EXISTS user_goal_target_date_idx
  ON public.user_goal (target_date);

