#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "Checking for inline paddings/margins (EdgeInsets with numbers)..."
if rg -n --glob 'lib/**/*.dart' 'EdgeInsets\.(all|symmetric|only)\([^)]*\d' | grep -v 'lib/theme/'; then
  echo "Found inline EdgeInsets with numbers. Please use AppSpacing.*" >&2
  exit 1
fi

echo "Checking for inline SizedBox with numbers..."
if rg -n --glob 'lib/**/*.dart' 'SizedBox\((height|width)\s*:\s*\d+' | grep -v 'lib/theme/'; then
  echo "Found inline SizedBox sizes. Please use AppSpacing.gapH/gapW or AppDimensions." >&2
  exit 1
fi

echo "Checking for inline TextStyle fontSize..."
if rg -n --glob 'lib/**/*.dart' 'TextStyle\([^)]*fontSize\s*:\s*\d' | grep -v 'lib/theme/'; then
  echo "Found inline TextStyle with fontSize. Please use Theme.of(context).textTheme.*" >&2
  exit 1
fi

echo "OK: token hygiene passed."


