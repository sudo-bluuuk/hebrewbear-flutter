#!/bin/sh
# Fails if the bundle would rely on a library the target machine might not have.
#
# Exists because "the app launched without printing to stderr" is not the same
# as "the app works": a missing libsqlite3 surfaces as an error drawn inside the
# Flutter UI, which no amount of watching stderr will catch.
set -eu
bundle=${1:?usage: check-bundle.sh <bundle-dir>}

fail=0
for lib in libsqlite3.so; do
  if [ ! -f "$bundle/lib/$lib" ]; then
    echo "  MISSING from bundle: $lib" >&2
    fail=1
  fi
done

[ "$fail" = 0 ] || { echo "  Bundle is not self-contained." >&2; exit 1; }
echo "  bundle check: libsqlite3.so present"
