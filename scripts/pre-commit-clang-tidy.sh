#!/usr/bin/env bash
# Used by pre-commit. Requires a configured CMake build tree with compile_commands.json.
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"
if [[ ! -f build/compile_commands.json ]]; then
  echo "clang-tidy (pre-commit): no build/compile_commands.json — run: cmake --preset debug"
  exit 1
fi
exec clang-tidy -p build "$@"
