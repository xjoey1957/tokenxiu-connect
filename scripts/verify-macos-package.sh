#!/bin/bash
set -euo pipefail

archive="$1"
expected_arch="$2"
actual_arch="$(uname -m)"
test "$actual_arch" = "$expected_arch" || { echo "Expected runner $expected_arch, got $actual_arch"; exit 1; }

work="$(mktemp -d)"
pid=''
cleanup() {
  if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
    kill "$pid" 2>/dev/null || true
    wait "$pid" 2>/dev/null || true
  fi
  rm -rf "$work"
}
trap cleanup EXIT
/usr/bin/ditto -x -k "$archive" "$work/unpacked"
app="$work/unpacked/TokenXiu Connect/TokenXiu Connect.app"
exe="$app/Contents/MacOS/tokenxiu-connect"
test -x "$exe"
/usr/bin/lipo "$exe" -verify_arch arm64 x86_64
/usr/bin/lipo -archs "$exe"
/usr/bin/codesign --verify --deep --strict --verbose=2 "$app"
test "$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$app/Contents/Info.plist")" = "$(node -p "require('./package.json').version")"

# Run the executable extracted from the exact distribution ZIP, on its native CPU.
# A temporary HOME prevents access to the runner's real client configuration.
mkdir -p "$work/home"
HOME="$work/home" "$exe" >"$work/app.log" 2>&1 &
pid=$!
for _ in $(seq 1 15); do
  if ! kill -0 "$pid" 2>/dev/null; then
    wait "$pid" || true
    cat "$work/app.log"
    echo 'Application exited during startup.' >&2
    exit 1
  fi
  sleep 1
done
echo "Application stayed running for 15 seconds on $actual_arch."
