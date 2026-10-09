QT = core gui widgets
TEMPLATE = lib
CONFIG += dll c++11
TARGET = wren_bridge
CONFIG -= debug_and_release
CONFIG += release

INCLUDEPATH += wren-src/src/vm wren-src/src/include wren-src/src/optional

SOURCES += wren_bridge.cpp
SOURCES += wren_inspector_glue.cpp
SOURCES += wren-src/src/vm/wren_compiler.c
SOURCES += wren-src/src/vm/wren_core.c
SOURCES += wren-src/src/vm/wren_debug.c
SOURCES += wren-src/src/vm/wren_primitive.c
SOURCES += wren-src/src/vm/wren_utils.c
SOURCES += wren-src/src/vm/wren_value.c
SOURCES += wren-src/src/vm/wren_vm.c
SOURCES += wren-src/src/optional/wren_opt_meta.c
SOURCES += wren-src/src/optional/wren_opt_random.c

HEADERS += wren_bridge.h
HEADERS += wren_inspector_glue.h

# Выбор папки назначения по QTE56_ARCH
# Настройка компилятора через PATH (a.cmd)
QTE56_ARCH = $$(QTE56_ARCH)
isEmpty(QTE56_ARCH) {
    QTE56_ARCH = win32_qt5
}

equals(QTE56_ARCH, 64)|equals(QTE56_ARCH, win64_qt6) {
    DESTDIR = ../../dll/dll64
} else {
    DESTDIR = ../../dll/dll32
}

unix: DESTDIR = ../../lib
unix: QMAKE_CFLAGS += -fPIC
unix: QMAKE_CXXFLAGS += -fPIC

macx {
    # macx-clang mkspec включает -fvisibility=hidden глобально —
    # переопределяем чтобы extern "C" функции были видны в dylib
    QMAKE_CXXFLAGS += -fvisibility=default
    QMAKE_CFLAGS   += -fvisibility=default
}
