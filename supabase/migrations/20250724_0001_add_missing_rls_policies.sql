-- Migration: enable RLS and ensure essential policies
-- Generated 2025-07-24

BEGIN;

-- Enable RLS on core learning tables (safe if already enabled)
ALTER TABLE IF EXISTS public.lessons ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.levels ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.leo_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.user_progress ENABLE ROW LEVEL SECURITY;

-- Helper to create a policy only if it doesn't already exist
CREATE OR REPLACE FUNCTION public.__create_policy_if_absent(
  _schema TEXT,
  _table TEXT,
  _policy TEXT,
  _cmd TEXT,
  _check TEXT,
  _using TEXT DEFAULT NULL
) RETURNS void AS $$
BEGIN
  IF NOT EXISTS (
      SELECT 1 FROM pg_policies
      WHERE schemaname = _schema
        AND tablename = _table
        AND policyname = _policy
  ) THEN
    EXECUTE format('CREATE POLICY "%s" ON %I.%I %s %s %s',
                   _policy, _schema, _table,
                   _cmd,
                   CASE WHEN _check IS NOT NULL THEN 'WITH CHECK ('||_check||')' ELSE '' END,
                   CASE WHEN _using IS NOT NULL THEN 'USING ('||_using||')' ELSE '' END);
  END IF;
END;
$$ LANGUAGE plpgsql;

-- lessons + levels: public read-only access (includes anon)
SELECT public.__create_policy_if_absent('public','lessons','Public can view lessons','FOR SELECT TO public','', 'TRUE');
SELECT public.__create_policy_if_absent('public','levels','Public can view levels','FOR SELECT TO public','', 'TRUE');

-- leo_messages: owner-scoped CRUD
SELECT public.__create_policy_if_absent('public','leo_messages','Users can view own chat messages','FOR SELECT TO authenticated','','user_id = auth.uid()');
SELECT public.__create_policy_if_absent('public','leo_messages','Users can insert own chat messages','FOR INSERT TO authenticated','user_id = auth.uid()');

-- user_progress: owner-scoped CRUD
SELECT public.__create_policy_if_absent('public','user_progress','Users can view own progress','FOR SELECT TO authenticated','','user_id = auth.uid()');
SELECT public.__create_policy_if_absent('public','user_progress','Users can insert own progress','FOR INSERT TO authenticated','user_id = auth.uid()');
SELECT public.__create_policy_if_absent('public','user_progress','Users can update own progress','FOR UPDATE TO authenticated','user_id = auth.uid()','user_id = auth.uid()');

-- Clean-up helper function to avoid polluting public schema
DROP FUNCTION public.__create_policy_if_absent(TEXT,TEXT,TEXT,TEXT,TEXT,TEXT);

COMMIT; 