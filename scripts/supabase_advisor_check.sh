#!/usr/bin/env bash
# Script: supabase_advisor_check.sh
# Purpose: Fails CI if Supabase security advisors report any CRITICAL issues.

set -euo pipefail

PROJECT_ID="${SUPABASE_PROJECT_ID:-acevqbdpzgbtqznbpgzr}"

if [[ -z "$PROJECT_ID" ]]; then
  echo "Supabase project ID not provided via SUPABASE_PROJECT_ID env var" >&2
  exit 1
fi

# Fetch security advisors via supabase-mcp CLI (must be pre-installed)
ADVISORS_JSON=$(supabase-mcp get_advisors --project_id "$PROJECT_ID" --type security)

echo "Supabase security advisors output:" >&2
echo "$ADVISORS_JSON" | jq .

# Check for critical lints
if echo "$ADVISORS_JSON" | jq -e '.lints[] | select(.level == "CRITICAL")' >/dev/null; then
  echo "❌ Critical security advisors found. Failing CI." >&2
  exit 1
fi

echo "✅ No critical security advisors detected." >&2 