# ===GENERATOR-INFO-START===
# generator: main.py 2.1.0-knowledge
# timestamp: 2026-08-29T10:08:01
# command: python main.py G:/Qt5_13_2/5.13.2/mingw73_32/include/QtWidgets/qstyleditemdelegate.h --module QStyledItemDelegate --dll qte56_qstyleditemdelegate.dll --index-start 12100
# header: G:/Qt5_13_2/5.13.2/mingw73_32/include/QtWidgets/qstyleditemdelegate.h
# qt: 5.13.2
# module: QStyledItemDelegate
# dll: qte56_qstyleditemdelegate.dll
# d-parent: QAbstractItemDelegate (knowledge)
# index-block: 12100 (--index-start)
# index-range: 12100-12103
# knowledge: qt_knowledge.json 2026-07-25T21:58:10
# methods: 2 wrapper(s), 0 signal(s), lifecycle=tracked
# skipped-unsupported: 7
#   void paint(QPainter*, const QStyleOptionViewItem&, const QModelIndex&) [method] — param type 'QPainter*'
#   QSize sizeHint(const QStyleOptionViewItem&, const QModelIndex&) [method] — param type 'const QStyleOptionViewItem&'
#   QWidget * createEditor(QWidget*, const QStyleOptionViewItem&, const QModelIndex&) [method] — param type 'const QStyleOptionViewItem&'
#   void setEditorData(QWidget*, const QModelIndex&) [method] — param type 'const QModelIndex&'
#   void setModelData(QWidget*, QAbstractItemModel*, const QModelIndex&) [method] — param type 'const QModelIndex&'
#   void updateEditorGeometry(QWidget*, const QStyleOptionViewItem&, const QModelIndex&) [method] — param type 'const QStyleOptionViewItem&'
#   QString displayText(const QVariant&, const QLocale&) [method] — param type 'const QVariant&'
# ===GENERATOR-INFO-END===
QT       += core widgets
TARGET    = qte56_qstyleditemdelegate
TEMPLATE  = lib
CONFIG   += shared c++11
CONFIG   -= debug_and_release
DEFINES  += QTE56_QSTYLEDITEMDELEGATE_BUILD QTE56_QABSTRACTITEMDELEGATE_BUILD
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

SOURCES   = qte56_qstyleditemdelegate.cpp \
            qte56_qabstractitemdelegate.cpp
HEADERS   = qte56_qstyleditemdelegate.h \
            qte56_qabstractitemdelegate.h

# Lifecycle-трекер (qte_lifecycle_track) живёт в qte56_foundation
LIBS += -L$$DESTDIR -lqte56_foundation
