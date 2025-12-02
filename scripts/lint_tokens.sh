#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

WARN_MODE=false
if [[ "${1:-}" == "--warn" ]]; then
  WARN_MODE=true
fi

ERRORS=0

check_pattern() {
  local desc="$1"
  local pattern="$2"
  local suggestion="$3"
  
  echo "Checking: $desc..."
  local matches
  matches=$(rg -n --glob 'lib/**/*.dart' "$pattern" | grep -v 'lib/theme/' || true)
  if [[ -n "$matches" ]]; then
    echo "⚠️  Found issues: $desc" >&2
    echo "$matches" | head -10 >&2
    echo "   → $suggestion" >&2
    if [[ "$WARN_MODE" == "false" ]]; then
      ERRORS=$((ERRORS + 1))
    fi
  fi
}

# 1. EdgeInsets с хардкод числами
check_pattern \
  "inline EdgeInsets with numbers" \
  'EdgeInsets\.(all|symmetric|only)\([^)]*\d' \
  "Use AppSpacing.insetsAll/insetsSymmetric"

# 2. SizedBox с хардкод числами
check_pattern \
  "inline SizedBox with numbers" \
  'SizedBox\((height|width)\s*:\s*\d+' \
  "Use AppSpacing.gapH/gapW"

# 3. BorderRadius.circular с хардкод числами
check_pattern \
  "inline BorderRadius.circular with numbers" \
  'BorderRadius\.circular\([0-9]+' \
  "Use AppDimensions.radius*"

# 4. Duration с хардкод milliseconds
check_pattern \
  "inline Duration with hardcoded milliseconds" \
  'Duration\(milliseconds:\s*[0-9]+\)' \
  "Use AppAnimations.* tokens"

# 5. TextStyle с хардкод fontSize
check_pattern \
  "inline TextStyle with fontSize" \
  'TextStyle\([^)]*fontSize\s*:\s*\d' \
  "Use Theme.of(context).textTheme.*"

# 6. AppSpacing.small/medium/large (deprecated)
check_pattern \
  "deprecated AppSpacing aliases (small/medium/large)" \
  'AppSpacing\.(small|medium|large)' \
  "Use AppSpacing.sm/lg/xl instead"

if [[ $ERRORS -gt 0 ]]; then
  echo "❌ Token hygiene: $ERRORS issue(s) found." >&2
  exit 1
else
  echo "✅ Token hygiene passed."
fi


