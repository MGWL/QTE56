# ===GENERATOR-INFO-START===
# generator: main.py 2.1.0-knowledge
# timestamp: 2026-07-25T22:55:54
# command: python main.py C:/Qt5_13_2/5.13.2/mingw73_32/include/QtCore/qrect.h --module QRectF --qt-mod core --cpp-out ../cpp/qt5/qte56_qrectf --d-out ../d/gen --index-start 21900
# header: C:/Qt5_13_2/5.13.2/mingw73_32/include/QtCore/qrect.h
# qt: 5.13.2
# module: QRectF
# dll: qte56_qrectf.dll
# d-parent: (root class)
# index-block: 21900 (--index-start)
# index-range: 21900-21948
# knowledge: qt_knowledge.json 2026-07-25T21:58:10
# methods: 47 wrapper(s), 0 signal(s), lifecycle=no
# skipped-unsupported: 6
#   void getRect(qreal*, qreal*, qreal*, qreal*) [method] — param type 'qreal*'
#   void getCoords(qreal*, qreal*, qreal*, qreal*) [method] — param type 'qreal*'
#   QSizeF size() [method] — return type 'QSizeF'
#   void setSize(const QSizeF&) [method] — param type 'const QSizeF&'
#   QRectF marginsAdded(const QMarginsF&) [method] — param type 'const QMarginsF&'
#   QRectF marginsRemoved(const QMarginsF&) [method] — param type 'const QMarginsF&'
# ===GENERATOR-INFO-END===
QT       += core
TARGET    = qte56_qrectf
TEMPLATE  = lib
CONFIG   += shared c++11
CONFIG   -= debug_and_release
DEFINES  += QTE56_QRECTF_BUILD
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

SOURCES   = qte56_qrectf.cpp
HEADERS   = qte56_qrectf.h
