-- Ensure single goal per user
ALTER TABLE public.user_goal
  ADD CONSTRAINT IF NOT EXISTS user_goal_user_id_unique UNIQUE (user_id);


