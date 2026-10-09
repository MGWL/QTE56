#!/bin/bash
# build_wren.sh — сборка libwren_bridge.so (Linux) / libwren_bridge.dylib (macOS)
#
# Использование:
#   bash wren/build_wren.sh [--verbose] [--clean]
#
# Требования Linux:
#   sudo dnf install qt5-qtbase-devel gcc-c++ make
# Требования macOS:
#   brew install qt@5
#   export PATH=/usr/local/opt/qt@5/bin:$PATH
#
# Результат:
#   Linux:  arch_new/lib/libwren_bridge.so
#   macOS:  arch_new/lib/libwren_bridge.dylib

cd "$(dirname "$0")/.."   # arch_new/

VERBOSE=0
CLEAN=0
for arg in "$@"; do
    case "$arg" in
        --verbose) VERBOSE=1 ;;
        --clean)   CLEAN=1 ;;
    esac
done

# ── Платформа ─────────────────────────────────────────────────────────────────
OS=$(uname -s)
if [ "$OS" = "Darwin" ]; then
    NPROC=$(sysctl -n hw.logicalcpu 2>/dev/null || echo 4)
    QMAKE_SPEC=""          # Homebrew qmake авто-определяет macx-clang
    SO_EXT="dylib"
else
    NPROC=$(nproc 2>/dev/null || echo 4)
    QMAKE_SPEC="linux-g++"
    SO_EXT="so"
fi

# ── Найти qmake ───────────────────────────────────────────────────────────────
QMAKE=$(which qmake-qt5 2>/dev/null || which qmake 2>/dev/null || echo "")
if [ -z "$QMAKE" ]; then
    echo "ERROR: qmake не найден."
    [ "$OS" = "Darwin" ] && echo "  brew install qt@5 && export PATH=/usr/local/opt/qt@5/bin:\$PATH"
    [ "$OS" != "Darwin" ] && echo "  sudo dnf install qt5-qtbase-devel"
    exit 1
fi

# Версия Qt через sed (grep -o возвращает несколько строк на macOS)
QT_VER=$("$QMAKE" --version 2>&1 | sed -n 's/.*Qt version \([0-9][0-9]*\).*/\1/p' | head -1)
if [ "$QT_VER" != "5" ]; then
    echo "ERROR: нужен qmake для Qt5 (найден: $("$QMAKE" --version 2>&1 | head -1))"
    exit 1
fi

mkdir -p lib

echo "=== Сборка libwren_bridge.$SO_EXT ==="
echo "    qmake    : $QMAKE"
echo "    platform : $OS"
echo "    jobs     : $NPROC"
echo ""

pushd wren/c > /dev/null

if [ "$CLEAN" -eq 1 ]; then
    echo "-- clean --"
    make clean 2>/dev/null || true
    rm -f Makefile
fi

# Spec передаём только на Linux; на macOS qmake сам определяет платформу
SPEC_ARG=()
[ -n "$QMAKE_SPEC" ] && SPEC_ARG=(-spec "$QMAKE_SPEC")

if [ "$VERBOSE" -eq 1 ]; then
    "$QMAKE" wren_bridge.pro "${SPEC_ARG[@]}" CONFIG+=release
    rc_q=$?
else
    "$QMAKE" wren_bridge.pro "${SPEC_ARG[@]}" CONFIG+=release > /dev/null 2>&1
    rc_q=$?
fi

if [ $rc_q -ne 0 ]; then
    echo "FAIL: qmake"
    popd > /dev/null
    exit 1
fi

if [ "$VERBOSE" -eq 1 ]; then
    make -j"$NPROC"
    rc_m=$?
else
    make -j"$NPROC" 2>&1 | grep -E "error:|warning:|undefined" || true
    make -j"$NPROC" > /dev/null 2>&1
    rc_m=$?
fi

popd > /dev/null

if [ $rc_m -ne 0 ]; then
    echo "FAIL: make"
    echo "Повторите с --verbose для деталей"
    exit 1
fi

SO="lib/libwren_bridge.$SO_EXT"
if [ -f "$SO" ]; then
    sz=$(du -h "$SO" | cut -f1)
    echo "OK: $SO  ($sz)"
else
    echo "WARN: файл $SO не найден — проверьте DESTDIR в wren_bridge.pro"
    exit 1
fi
