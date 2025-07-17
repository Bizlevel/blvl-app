#!/usr/bin/env bash
# Fail on any error
set -euo pipefail

echo "🔍 Checking Sentry for unresolved issues in the last 24h…"

if ! command -v sentry-cli >/dev/null 2>&1; then
  echo "❌ sentry-cli not found in PATH" >&2
  exit 1
fi

# Fetch issues as JSON using sentry-cli
ISSUES_JSON=$(sentry-cli issues list \
  --org "$SENTRY_ORG" \
  --project "$SENTRY_PROJECT" \
  --stats-period 24h \
  --query "is:unresolved" \
  --json || true)

# Count issues with jq (expects jq installed)
ISSUE_COUNT=$(echo "$ISSUES_JSON" | jq 'length')

if [[ "$ISSUE_COUNT" -gt 0 ]]; then
  echo "::error::Found $ISSUE_COUNT unresolved issues in the last 24h. Failing build."
  echo "$ISSUES_JSON" | jq -r '.[] | "- " + .shortId + " " + .title + " (" + .permalink + ")"'
  exit 1
fi

echo "✅ No unresolved issues found – proceeding." 