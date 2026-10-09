#!/usr/bin/env bash
# tools/qte/build.sh — сборка qte CLI-утилиты на Linux/macOS.
set -euo pipefail

cd "$(dirname "$0")/../.."

DMD="${DMD:-dmd}"
SOURCES=(tools/qte/main.d tools/qte/cmd_index.d tools/qte/cmd_class.d tools/qte/cmd_check.d tools/qte/cmd_signals.d tools/qte/cmd_trace.d tools/qte/cmd_dll.d tools/qte/cmd_deps.d tools/qte/cmd_scan.d tools/lib/qte_meta.d tools/lib/qte_cli.d)
OUT=tools/qte/qte

case "${1:-build}" in
    --unittest)
        echo "=== Compiling qte unit tests ==="
        $DMD -unittest -main -of="$OUT"_test "${SOURCES[@]}" -Itools/lib
        echo "=== Running tests ==="
        "$OUT"_test
        ;;
    --release)
        echo "=== Building qte (release) ==="
        $DMD -O -release -inline -of="$OUT" "${SOURCES[@]}" -Itools/lib
        ;;
    *)
        echo "=== Building qte ==="
        $DMD -of="$OUT" "${SOURCES[@]}" -Itools/lib
        ;;
esac

echo "=== BUILD OK -> $OUT ==="
"$OUT" --version
