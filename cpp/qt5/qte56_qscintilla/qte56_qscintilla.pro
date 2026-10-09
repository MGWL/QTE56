QT       += core gui widgets printsupport
TARGET    = qte56_qscintilla
TEMPLATE  = lib
CONFIG   += shared c++11
CONFIG   -= debug_and_release
DEFINES  += QTE56_QSCINTILLA_BUILD QSCINTILLA_DLL
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




win32 {
    INCLUDEPATH += ../../../QScintilla_src-2.14.1/src
    LIBS += -L$$DESTDIR -lqscintilla2_qt5
}

unix {
    # Всегда используем локальную QScintilla 2.14.1 — гарантия совместимости ABI с ./lib/
    INCLUDEPATH += ../../../QScintilla_src-2.14.1/src
    LIBS += -L../../lib -lqscintilla2_qt5
}

unix:!macx {
    # Linux: RPATH $ORIGIN — libqscintilla2_qt5.so ищется рядом с libqte56_qscintilla.so
    QMAKE_LFLAGS += -Wl,-rpath,\'$$ORIGIN\'
}

macx {
    # macOS: @loader_path — эквивалент $ORIGIN для dylib
    QMAKE_LFLAGS += -Wl,-rpath,@loader_path
    # macx-clang mkspec включает -fvisibility=hidden глобально —
    # переопределяем чтобы extern "C" функции были видны в dylib
    QMAKE_CXXFLAGS += -fvisibility=default
    QMAKE_CFLAGS   += -fvisibility=default
}

SOURCES   = qte56_qscintilla.cpp
HEADERS   = qte56_qscintilla.h

LIBS += -L$$DESTDIR -lqte56_foundation
