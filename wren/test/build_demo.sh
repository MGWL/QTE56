#!/bin/bash
# build_demo.sh — сборка и запуск Wren-демо на Linux / macOS
#
# Использование:
#   bash wren/test/build_demo.sh [--no-rebuild]
#
# Требования Linux:
#   sudo dnf install qt5-qtbase-devel gcc-c++ make ldc
# Требования macOS:
#   brew install qt@5
#   export PATH=/usr/local/opt/qt@5/bin:$PATH

cd "$(dirname "$0")/../.."   # arch_new/

REBUILD=1
[ "$1" = "--no-rebuild" ] && REBUILD=0

# ── Платформа ─────────────────────────────────────────────────────────────────
OS=$(uname -s)
if [ "$OS" = "Darwin" ]; then
    NPROC=$(sysctl -n hw.logicalcpu 2>/dev/null || echo 4)
    QMAKE_SPEC=""
    SO_EXT="dylib"
    LIB_PATH_VAR="DYLD_LIBRARY_PATH"
    RPATH="-L-rpath -L@loader_path/../lib"
else
    NPROC=$(nproc 2>/dev/null || echo 4)
    QMAKE_SPEC="linux-g++"
    SO_EXT="so"
    LIB_PATH_VAR="LD_LIBRARY_PATH"
    RPATH="-L-Wl,-rpath,\$ORIGIN/../lib"
fi

QMAKE=$(which qmake-qt5 2>/dev/null || which qmake 2>/dev/null || echo "")
if [ -z "$QMAKE" ]; then
    echo "ERROR: qmake не найден"
    exit 1
fi

# ── Шаг 1: собрать wren_bridge ────────────────────────────────────────────────
if [ "$REBUILD" -eq 1 ]; then
    echo "=== Шаг 1: сборка libwren_bridge.$SO_EXT ==="
    pushd wren/c > /dev/null
    SPEC_ARG=()
    [ -n "$QMAKE_SPEC" ] && SPEC_ARG=(-spec "$QMAKE_SPEC")
    "$QMAKE" wren_bridge.pro "${SPEC_ARG[@]}" CONFIG+=release
    make -j"$NPROC"
    popd > /dev/null
    echo ""
fi

# ── Шаг 2: компиляция D-демо ──────────────────────────────────────────────────
echo "=== Шаг 2: компиляция demo.d ==="

D_SOURCES=(
    wren/test/demo.d
    wren/d/wren_vm.d
    d/qte56_core.d
    d/qte56_loader.d
    d/qte56_enums.d
    d/gen/gen_qcore.d
    d/gen/gen_qobject.d
    d/gen/gen_qfont.d
    d/gen/gen_qwidget.d
    d/gen/gen_qframe.d
    d/gen/gen_qlayout.d
    d/gen/gen_qlabel.d
    d/gen/gen_qpushbutton.d
    d/gen/gen_qlineedit.d
    d/gen/gen_qcheckbox.d
    d/gen/gen_qcombobox.d
    d/gen/gen_qspinbox.d
    d/gen/gen_qgroupbox.d
    d/gen/gen_qabstractbutton.d
    d/gen/gen_qabstractspinbox.d
    d/gen/gen_qabstractscrollarea.d
    d/gen/gen_qabstractitemview.d
    d/gen/gen_qlistwidget.d
    d/gen/gen_qabstractslider.d
    d/gen/gen_qplaintextedit.d
)

if command -v ldc2 &>/dev/null; then
    DC=ldc2
    DC_FLAGS="-i -I=d -I=d/gen -I=wren/d"
elif command -v dmd &>/dev/null; then
    DC=dmd
    DC_FLAGS="-Id -Id/gen -Iwren/d"
else
    echo "ERROR: не найден ldc2 или dmd."
    exit 1
fi

echo "Компилятор: $DC  platform: $OS"
"$DC" $DC_FLAGS $RPATH "${D_SOURCES[@]}" -of=wren/test/demo

if [ $? -ne 0 ]; then
    echo "=== ОШИБКА КОМПИЛЯЦИИ ==="
    exit 1
fi

echo ""
echo "=== Шаг 3: запуск ==="
eval "${LIB_PATH_VAR}=\"$(pwd)/lib:\$${LIB_PATH_VAR}\" wren/test/demo"
