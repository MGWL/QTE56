QT += widgets
TEMPLATE = lib
CONFIG += shared
TARGET = qte56_qclipboard
# Выбор папки назначения по QTE56_ARCH (32 или 64)
# Настройка компилятора через PATH (a.cmd)
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

SOURCES += qte56_qclipboard.cpp
HEADERS += qte56_qclipboard.h
CONFIG -= debug_and_release
CONFIG += release
DEFINES += QT_NO_DEBUG
