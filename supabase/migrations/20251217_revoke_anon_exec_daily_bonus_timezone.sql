-- 2025-12-17: Tighten privileges for daily bonus + timezone RPCs (authenticated only)

revoke all on function public.user_set_timezone(text) from anon;
revoke all on function public.gp_claim_daily_application() from anon;
revoke all on function public._gp_resolve_user_timezone(uuid) from anon;






