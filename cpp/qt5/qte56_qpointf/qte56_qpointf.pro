# ===GENERATOR-INFO-START===
# generator: main.py 2.1.0-knowledge
# timestamp: 2026-07-25T22:55:53
# command: python main.py C:/Qt5_13_2/5.13.2/mingw73_32/include/QtCore/qpoint.h --module QPointF --qt-mod core --cpp-out ../cpp/qt5/qte56_qpointf --d-out ../d/gen --index-start 21800
# header: C:/Qt5_13_2/5.13.2/mingw73_32/include/QtCore/qpoint.h
# qt: 5.13.2
# module: QPointF
# dll: qte56_qpointf.dll
# d-parent: (root class)
# index-block: 21800 (--index-start)
# index-range: 21800-21808
# knowledge: qt_knowledge.json 2026-07-25T21:58:10
# methods: 7 wrapper(s), 0 signal(s), lifecycle=no
# skipped-unsupported: 2
#   qreal & rx() [method] — return type 'qreal &'
#   qreal & ry() [method] — return type 'qreal &'
# ===GENERATOR-INFO-END===
QT       += core
TARGET    = qte56_qpointf
TEMPLATE  = lib
CONFIG   += shared c++11
CONFIG   -= debug_and_release
DEFINES  += QTE56_QPOINTF_BUILD
# Выбор папки назначения по QTE56_ARCH (32 или 64)
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

SOURCES   = qte56_qpointf.cpp
HEADERS   = qte56_qpointf.h
