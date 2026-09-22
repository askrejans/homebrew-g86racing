#!/usr/bin/env bash
# =============================================================================
# Bump a formula to a published version
# =============================================================================
# Downloads the macOS tarballs from https://g86racing.com/packages/mac, computes
# their checksums and rewrites the formula's version and sha256 lines.
#
# Usage:
#   ./scripts/bump-formula.sh ecu-to-mqtt 0.5.0
#
# Publish the tarballs first:
#   infra/deploy/scripts/publish-packages.sh --repo askrejans/ecu-to-mqtt --tag 0.5.0
# =============================================================================
set -euo pipefail

NAME="${1:-}"
VERSION="${2:-}"
BASE="${G86_PACKAGES_BASE:-https://g86racing.com/packages/mac}"

if [[ -z "$NAME" || -z "$VERSION" ]]; then
    sed -n '2,15p' "$0" | sed 's/^# \?//'
    exit 1
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FORMULA="$ROOT/Formula/$NAME.rb"
[[ -f "$FORMULA" ]] || { echo "No such formula: $FORMULA" >&2; exit 1; }

checksum_of() {
    local url="$1" tmp
    tmp="$(mktemp)"
    curl -fsSL "$url" -o "$tmp" || { echo "Cannot download $url" >&2; exit 1; }
    shasum -a 256 "$tmp" | awk '{print $1}'
    rm -f "$tmp"
}

ARM_URL="$BASE/${NAME}_${VERSION}_macos-arm64.tar.gz"
INTEL_URL="$BASE/${NAME}_${VERSION}_macos-x86_64.tar.gz"

echo "Fetching $ARM_URL"
ARM_SHA="$(checksum_of "$ARM_URL")"
echo "Fetching $INTEL_URL"
INTEL_SHA="$(checksum_of "$INTEL_URL")"

python3 - "$FORMULA" "$VERSION" "$ARM_SHA" "$INTEL_SHA" <<'PY'
import re, sys
path, version, arm_sha, intel_sha = sys.argv[1:5]
text = open(path).read()
text = re.sub(r'version "[^"]+"', f'version "{version}"', text, count=1)
# The first sha256 belongs to the on_arm block, the second to on_intel.
shas = iter([arm_sha, intel_sha])
text = re.sub(r'sha256 "[0-9a-f]{64}"', lambda _: f'sha256 "{next(shas)}"', text, count=2)
open(path, "w").write(text)
PY

echo
echo "Updated $FORMULA to $VERSION:"
grep -nE 'version "|sha256 "' "$FORMULA"
echo
echo "Test, then commit:"
echo "  brew install --build-from-source $FORMULA"
echo "  git -C $ROOT commit -am \"$NAME $VERSION\""
