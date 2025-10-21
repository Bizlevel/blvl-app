#!/usr/bin/env bash
# Fail on any error
set -euo pipefail

echo "🔍 Checking Sentry for unresolved issues in the last 24h…"

if ! command -v sentry-cli >/dev/null 2>&1; then
  echo "❌ sentry-cli not found in PATH" >&2
  exit 1
fi

MAX_RETRIES=${MAX_RETRIES:-3}
SLEEP_BASE=${SLEEP_BASE:-1}

fetch_issues_json() {
  sentry-cli issues list \
    --org "$SENTRY_ORG" \
    --project "$SENTRY_PROJECT" \
    --stats-period 24h \
    --query "is:unresolved" \
    --json
}

# Retry with exponential backoff if API returns non-JSON or fails
attempt=0
ISSUES_JSON=""
while :; do
  attempt=$((attempt+1))
  if OUTPUT=$(fetch_issues_json 2>&1); then
    ISSUES_JSON="$OUTPUT"
  else
    ISSUES_JSON=""
  fi

  # Validate JSON
  if echo "$ISSUES_JSON" | jq empty >/dev/null 2>&1; then
    break
  fi

  if [ "$attempt" -ge "$MAX_RETRIES" ]; then
    echo "::warning::Sentry API is unavailable or returned invalid JSON after $attempt attempts. Skipping blocking check."
    # Soft-fallback: do not fail the pipeline on Sentry API outages
    echo "[]" > /tmp/sentry_issues.json
    ISSUES_JSON="[]"
    break
  fi

  sleep_time=$((SLEEP_BASE * 2 ** (attempt-1)))
  echo "⚠️  Sentry API error (attempt $attempt/$MAX_RETRIES). Retrying in ${sleep_time}s…"
  sleep "$sleep_time"
done

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