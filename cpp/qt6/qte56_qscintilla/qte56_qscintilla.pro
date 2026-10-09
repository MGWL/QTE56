QT += core core5compat gui widgets printsupport
TARGET    = qte56_qscintilla
TEMPLATE  = lib
CONFIG   += shared c++17
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
    INCLUDEPATH += ../../../QScintilla_2.13/src
    equals(QTE56_ARCH, 64) {
        LIBS += -L$$DESTDIR -lqscintilla2_qt6
    } else {
        LIBS += -L$$DESTDIR -lqscintilla2_qt5
    }
}

unix {
    # Всегда используем локальную QScintilla_2.13 — гарантия совместимости ABI с ./lib/
    INCLUDEPATH += ../../../QScintilla_2.13/src
    equals(QTE56_ARCH, 64) {
        LIBS += -L../../lib -lqscintilla2_qt6
    } else {
        LIBS += -L../../lib -lqscintilla2_qt5
    }
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
