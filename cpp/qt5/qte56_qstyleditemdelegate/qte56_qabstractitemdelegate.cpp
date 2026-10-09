// ===GENERATOR-INFO-START===
// generator: main.py 2.1.0-knowledge
// timestamp: 2026-08-29T10:07:49
// command: python main.py G:/Qt5_13_2/5.13.2/mingw73_32/include/QtWidgets/qabstractitemdelegate.h --module QAbstractItemDelegate --dll qte56_qstyleditemdelegate.dll --index-start 12018
// header: G:/Qt5_13_2/5.13.2/mingw73_32/include/QtWidgets/qabstractitemdelegate.h
// qt: 5.13.2
// module: QAbstractItemDelegate
// dll: qte56_qstyleditemdelegate.dll
// d-parent: QObject (knowledge)
// index-block: 12018 (--index-start)
// index-range: 12018-12020
// knowledge: qt_knowledge.json 2026-07-25T21:58:10
// methods: 0 wrapper(s), 2 signal(s), lifecycle=tracked
// skipped-unsupported: 12
//   void paint(QPainter*, const QStyleOptionViewItem&, const QModelIndex&) [method] — param type 'QPainter*'
//   QSize sizeHint(const QStyleOptionViewItem&, const QModelIndex&) [method] — param type 'const QStyleOptionViewItem&'
//   QWidget * createEditor(QWidget*, const QStyleOptionViewItem&, const QModelIndex&) [method] — param type 'const QStyleOptionViewItem&'
//   void destroyEditor(QWidget*, const QModelIndex&) [method] — param type 'const QModelIndex&'
//   void setEditorData(QWidget*, const QModelIndex&) [method] — param type 'const QModelIndex&'
//   void setModelData(QWidget*, QAbstractItemModel*, const QModelIndex&) [method] — param type 'const QModelIndex&'
//   void updateEditorGeometry(QWidget*, const QStyleOptionViewItem&, const QModelIndex&) [method] — param type 'const QStyleOptionViewItem&'
//   bool editorEvent(QEvent*, QAbstractItemModel*, const QStyleOptionViewItem&, const QModelIndex&) [method] — param type 'const QStyleOptionViewItem&'
//   QString elidedText(const QFontMetrics&, int, Qt::TextElideMode, const QString&) [method] — param type 'const QFontMetrics&'
//   bool helpEvent(QHelpEvent*, QAbstractItemView*, const QStyleOptionViewItem&, const QModelIndex&) [method] — param type 'const QStyleOptionViewItem&'
//   QVector<int> paintingRoles() [method] — return type 'QVector<int>'
//   void sizeHintChanged(const QModelIndex&) [signal] — param type 'const QModelIndex&'
// ===GENERATOR-INFO-END===
#define QTE56_QABSTRACTITEMDELEGATE_BUILD
#include "qte56_qabstractitemdelegate.h"
#include <QAbstractItemDelegate>
#include <QString>
#include <QWidget>
#include <QPainter>
#include "../qte56_qobject/qte56_lifecycle.h"

// ─── Proxy для абстрактного класса ──────────────────────────────────────────
// QAbstractItemDelegate абстрактный (paint/sizeHint — pure virtual).
// Proxy-заглушки нужны только для создания объекта как промежуточного
// звена D-иерархии; реальная работа — в eQStyledItemDelegate
// (см. qte56_qstyleditemdelegate.cpp). Паттерн — как eQAbstractItemView.
class eQAbstractItemDelegate : public QAbstractItemDelegate {
public:
    explicit eQAbstractItemDelegate(QObject* parent = nullptr) : QAbstractItemDelegate(parent) {}

    void paint(QPainter*, const QStyleOptionViewItem&, const QModelIndex&) const override {}
    QSize sizeHint(const QStyleOptionViewItem&, const QModelIndex&) const override { return QSize(); }
};

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQAbstractItemDelegate_create(void* parent) {
    return qte_createTracked(new eQAbstractItemDelegate((QObject*)parent));
}

void qteQAbstractItemDelegate_delete(void* w) {
    delete (eQAbstractItemDelegate*)w;
}

// ── Lambda-connect (Qt-pointer signals) ─────────────────────────────────────
// Signal: commitData(QWidget*)
void qteQAbstractItemDelegate_connect_commitData(void* w, void* cb, void* dthis) {
    QObject::connect((QAbstractItemDelegate*)w, &QAbstractItemDelegate::commitData,
        [cb, dthis](QWidget* p) {
            if (cb) ((void(*)(void*,int,void*))cb)(dthis, 0, (void*)p);
        });
}

} // extern "C"
