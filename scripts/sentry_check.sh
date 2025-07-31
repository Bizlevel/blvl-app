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

# Define patterns that are considered non-critical and can be ignored
WHITELIST_REGEX="RenderFlex overflow|Layout|BackdropFilter performance"

# Filter out whitelisted issues
CRITICAL_JSON=$(echo "$ISSUES_JSON" | jq --arg re "$WHITELIST_REGEX" 'map(select(.title | test($re; "i") | not))')

# Count remaining critical issues
CRITICAL_COUNT=$(echo "$CRITICAL_JSON" | jq 'length')

if [[ "$CRITICAL_COUNT" -gt 0 ]]; then
  echo "::error::Found $CRITICAL_COUNT critical unresolved issues in the last 24h. Failing build."
  echo "$CRITICAL_JSON" | jq -r '.[] | "- " + .shortId + " " + .title + " (" + .permalink + ")"'
  exit 1
fi

echo "✅ No unresolved issues found – proceeding." 