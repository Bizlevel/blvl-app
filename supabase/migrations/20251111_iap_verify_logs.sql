-- IAP verify diagnostic logs (owner-only)
BEGIN;

CREATE TABLE IF NOT EXISTS public.iap_verify_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  user_id UUID NOT NULL DEFAULT auth.uid(),
  platform TEXT,
  product_id TEXT,
  package_name TEXT,
  token_prefix TEXT,              -- первые 10 символов токена
  token_hash TEXT,                -- sha256 от токена (для корреляции, без PII)
  step TEXT,                      -- start / success / error / google_failed / credited
  http_status INT,                -- статус внешнего запроса (если есть)
  error TEXT,                     -- краткое сообщение ошибки
  google_payload JSONB            -- усечённый ответ Google (опционально)
);

ALTER TABLE public.iap_verify_logs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "iap_verify_logs_select_own" ON public.iap_verify_logs;
CREATE POLICY "iap_verify_logs_select_own" ON public.iap_verify_logs
  FOR SELECT USING ((select auth.uid()) = user_id);

DROP POLICY IF EXISTS "iap_verify_logs_insert_own" ON public.iap_verify_logs;
CREATE POLICY "iap_verify_logs_insert_own" ON public.iap_verify_logs
  FOR INSERT TO authenticated WITH CHECK ((select auth.uid()) = user_id);

COMMIT;


