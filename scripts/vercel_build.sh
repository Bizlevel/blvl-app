#!/usr/bin/env bash
set -euo pipefail

# Install Flutter SDK (shallow clone for speed)
FLUTTER_DIR="/tmp/flutter"
if [ ! -d "$FLUTTER_DIR" ]; then
  git clone --depth 1 -b stable https://github.com/flutter/flutter.git "$FLUTTER_DIR"
fi
export PATH="$FLUTTER_DIR/bin:$PATH"

# Print versions
flutter --version

# Install project dependencies
flutter pub get

# Build web release with env vars passed from Vercel
flutter build web --release \
  --dart-define="SUPABASE_URL=${SUPABASE_URL:-}" \
  --dart-define="SUPABASE_ANON_KEY=${SUPABASE_ANON_KEY:-}" \
  --dart-define="SENTRY_DSN=${SENTRY_DSN:-}"

# Remove the .env file from the build output to avoid exposing secrets
rm -f build/web/assets/.env