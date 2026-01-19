#!/usr/bin/env bash
set -euo pipefail

if ! command -v sentry-cli >/dev/null 2>&1; then
  echo "sentry-cli not found in PATH" >&2
  exit 1
fi

if [[ -z "${SENTRY_AUTH_TOKEN:-}" || -z "${SENTRY_ORG:-}" || -z "${SENTRY_PROJECT:-}" ]]; then
  echo "Missing SENTRY_AUTH_TOKEN/SENTRY_ORG/SENTRY_PROJECT" >&2
  exit 1
fi

if [[ -z "${SENTRY_RELEASE:-}" ]]; then
  echo "Missing SENTRY_RELEASE (example: bizlevel@1.0.28+28)" >&2
  exit 1
fi

DSYM_PATH="${DSYM_PATH:-ios/build}"
ANDROID_MAPPING_PATH="${ANDROID_MAPPING_PATH:-build/app/outputs/mapping/release/mapping.txt}"
FLUTTER_SYMBOLS_PATH="${FLUTTER_SYMBOLS_PATH:-build/symbols}"

echo "Uploading symbols for release: $SENTRY_RELEASE"

if [[ -d "$DSYM_PATH" ]]; then
  sentry-cli upload-dsym \
    --org "$SENTRY_ORG" \
    --project "$SENTRY_PROJECT" \
    --release "$SENTRY_RELEASE" \
    "$DSYM_PATH"
else
  echo "dSYM path not found: $DSYM_PATH (skipped)"
fi

if [[ -f "$ANDROID_MAPPING_PATH" ]]; then
  sentry-cli upload-proguard \
    --org "$SENTRY_ORG" \
    --project "$SENTRY_PROJECT" \
    --release "$SENTRY_RELEASE" \
    "$ANDROID_MAPPING_PATH"
else
  echo "Android mapping not found: $ANDROID_MAPPING_PATH (skipped)"
fi

if [[ -d "$FLUTTER_SYMBOLS_PATH" ]]; then
  sentry-cli debug-files upload \
    --org "$SENTRY_ORG" \
    --project "$SENTRY_PROJECT" \
    --release "$SENTRY_RELEASE" \
    --include-sources \
    "$FLUTTER_SYMBOLS_PATH"
else
  echo "Flutter symbols path not found: $FLUTTER_SYMBOLS_PATH (skipped)"
fi
