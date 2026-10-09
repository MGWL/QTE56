QT       += core
TARGET    = qte56_qobject
TEMPLATE  = lib
CONFIG   += shared c++11
CONFIG   -= debug_and_release
DEFINES  += QTE56_QOBJECT_BUILD
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



SOURCES   = qte56_qobject.cpp qte56_lifecycle.cpp
HEADERS   = qte56_qobject.h qte56_lifecycle.h
