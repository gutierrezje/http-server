#!/usr/bin/env bash
# Match CI locally: format check, Debug + tests, strict build, clang-tidy (Linux/macOS with clang-tidy-18 or clang-tidy on PATH).
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if [[ ! -f vcpkg/scripts/buildsystems/vcpkg.cmake ]]; then
  echo "vcpkg missing. Run: git submodule update --init --recursive"
  exit 1
fi

FMT="clang-format"
if command -v clang-format-18 &>/dev/null; then FMT="clang-format-18"; fi
mapfile -t FILES < <(git ls-files | grep -E '^(src|tests|benchmarks|fuzz)/.*\.(cpp|h|hpp)$' || true)
if [[ "${#FILES[@]}" -eq 0 ]]; then echo "No matching sources"; exit 1; fi
echo "==> Format check ($FMT)"
"$FMT" --dry-run --Werror "${FILES[@]}"

echo "==> Configure & build Debug"
cmake --preset debug
cmake --build --preset debug --parallel
echo "==> Tests"
ctest --preset debug --output-on-failure

echo "==> Strict build (-Werror)"
cmake --preset debug-strict
cmake --build --preset debug-strict --parallel

TIDY=""
if command -v clang-tidy-18 &>/dev/null; then TIDY="$(command -v clang-tidy-18)"; elif command -v clang-tidy &>/dev/null; then TIDY="$(command -v clang-tidy)"; fi
if [[ -n "$TIDY" ]]; then
  echo "==> clang-tidy ($TIDY)"
  cmake --preset clang-tidy -DHTTP_SERVER_CLANG_TIDY_EXECUTABLE="${TIDY}"
  cmake --build --preset clang-tidy --parallel
else
  echo "==> Skipping clang-tidy (install clang-tidy or clang-tidy-18 to match CI)"
fi

echo "Done."
