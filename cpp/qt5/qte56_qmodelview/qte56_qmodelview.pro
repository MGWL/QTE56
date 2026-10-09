QT       += core gui widgets
TARGET    = qte56_qmodelview
TEMPLATE  = lib
CONFIG   += shared c++11
CONFIG   -= debug_and_release

DEFINES  += QTE56_QMODELVIEW_BUILD

INCLUDEPATH += ../qte56_qobject

SOURCES   = qte56_qmodelview.cpp
HEADERS   = qte56_qmodelview.h

# Выбор папки назначения по QTE56_ARCH (32 или 64)
QTE56_ARCH = $$(QTE56_ARCH)
isEmpty(QTE56_ARCH) {
    QTE56_ARCH = 32
}

equals(QTE56_ARCH, 64) {
    DESTDIR = ../../../dll/dll64
} else {
    DESTDIR = ../../../dll/dll32
}

unix: DESTDIR = ../../../lib

LIBS += -L$$DESTDIR -lqte56_foundation
