QT       = core
TARGET   = qte56_qprocess
TEMPLATE = lib
CONFIG  += shared c++11
CONFIG  -= debug_and_release
DEFINES += QTE56_QPROCESS_BUILD
# Выбор папки назначения по QTE56_ARCH (32 или 64)
# Настройка компилятора через PATH (a.cmd)
QTE56_ARCH = $$(QTE56_ARCH)
isEmpty(QTE56_ARCH) {
    QTE56_ARCH = 32
}

equals(QTE56_ARCH, 64) {
    DESTDIR = ../../../dll/dll64
unix: DESTDIR = ../../../lib
} else {
    DESTDIR = ../../../dll/dll32
unix: DESTDIR = ../../../lib
}



SOURCES  = qte56_qprocess.cpp
HEADERS  = qte56_qprocess.h

macx {
    # macx-clang mkspec включает -fvisibility=hidden глобально —
    # переопределяем чтобы extern "C" функции были видны в dylib
    QMAKE_CXXFLAGS += -fvisibility=default
    QMAKE_CFLAGS   += -fvisibility=default
}

LIBS += -L$$DESTDIR -lqte56_foundation
