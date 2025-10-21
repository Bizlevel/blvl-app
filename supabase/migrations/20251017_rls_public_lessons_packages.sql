-- Enable RLS and add SELECT policies for public data used by the app

-- lesson_metadata
ALTER TABLE public.lesson_metadata ENABLE ROW LEVEL SECURITY;
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE schemaname='public' AND tablename='lesson_metadata' AND policyname='lesson_metadata_select_auth'
  ) THEN
    CREATE POLICY lesson_metadata_select_auth
      ON public.lesson_metadata
      FOR SELECT
      TO authenticated
      USING (true);
  END IF;
END $$;

-- lesson_facts
ALTER TABLE public.lesson_facts ENABLE ROW LEVEL SECURITY;
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE schemaname='public' AND tablename='lesson_facts' AND policyname='lesson_facts_select_auth'
  ) THEN
    CREATE POLICY lesson_facts_select_auth
      ON public.lesson_facts
      FOR SELECT
      TO authenticated
      USING (true);
  END IF;
END $$;

-- package_items
ALTER TABLE public.package_items ENABLE ROW LEVEL SECURITY;
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE schemaname='public' AND tablename='package_items' AND policyname='package_items_select_auth'
  ) THEN
    CREATE POLICY package_items_select_auth
      ON public.package_items
      FOR SELECT
      TO authenticated
      USING (true);
  END IF;
END $$;


