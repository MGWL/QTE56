// ===GENERATOR-INFO-START===
// generator: main.py 2.1.0-knowledge
// timestamp: 2026-08-29T10:08:01
// command: python main.py G:/Qt5_13_2/5.13.2/mingw73_32/include/QtWidgets/qstyleditemdelegate.h --module QStyledItemDelegate --dll qte56_qstyleditemdelegate.dll --index-start 12100
// header: G:/Qt5_13_2/5.13.2/mingw73_32/include/QtWidgets/qstyleditemdelegate.h
// qt: 5.13.2
// module: QStyledItemDelegate
// dll: qte56_qstyleditemdelegate.dll
// d-parent: QAbstractItemDelegate (knowledge)
// index-block: 12100 (--index-start)
// index-range: 12100-12103
// knowledge: qt_knowledge.json 2026-07-25T21:58:10
// methods: 2 wrapper(s), 0 signal(s), lifecycle=tracked
// skipped-unsupported: 7
//   void paint(QPainter*, const QStyleOptionViewItem&, const QModelIndex&) [method] — param type 'QPainter*'
//   QSize sizeHint(const QStyleOptionViewItem&, const QModelIndex&) [method] — param type 'const QStyleOptionViewItem&'
//   QWidget * createEditor(QWidget*, const QStyleOptionViewItem&, const QModelIndex&) [method] — param type 'const QStyleOptionViewItem&'
//   void setEditorData(QWidget*, const QModelIndex&) [method] — param type 'const QModelIndex&'
//   void setModelData(QWidget*, QAbstractItemModel*, const QModelIndex&) [method] — param type 'const QModelIndex&'
//   void updateEditorGeometry(QWidget*, const QStyleOptionViewItem&, const QModelIndex&) [method] — param type 'const QStyleOptionViewItem&'
//   QString displayText(const QVariant&, const QLocale&) [method] — param type 'const QVariant&'
// ===GENERATOR-INFO-END===
#define QTE56_QSTYLEDITEMDELEGATE_BUILD
#include "qte56_qstyleditemdelegate.h"
#include <QStyledItemDelegate>
#include <QString>
#include <QPainter>
#include <QStyleOptionViewItem>
#include <QModelIndex>
#include <QWidget>
#include "../qte56_qobject/qte56_lifecycle.h"

// ─── Delegate proxy ─────────────────────────────────────────────────────────
// Трамплин виртуальных методов QStyledItemDelegate → D-коллбэки.
// Паттерн — как eQWidget (cb_XX/dt_XX + setEventHandler).
// Все указатели, передаваемые в D (painter/option/index/editor/model),
// ЗАИМСТВОВАННЫЕ: валидны только внутри коллбэка, D их не удаляет.
class eQStyledItemDelegate : public QStyledItemDelegate {
public:
    void* cb_01 = nullptr;  void* dt_01 = nullptr;  // 1: paint
    void* cb_02 = nullptr;  void* dt_02 = nullptr;  // 2: sizeHint
    void* cb_03 = nullptr;  void* dt_03 = nullptr;  // 3: createEditor
    void* cb_04 = nullptr;  void* dt_04 = nullptr;  // 4: setEditorData
    void* cb_05 = nullptr;  void* dt_05 = nullptr;  // 5: setModelData

    explicit eQStyledItemDelegate(QObject* parent = nullptr) : QStyledItemDelegate(parent) {}

    void paint(QPainter* painter, const QStyleOptionViewItem& option,
               const QModelIndex& index) const override {
        if (cb_01) {
            ((void(*)(void*,void*,void*,void*))cb_01)(
                dt_01, (void*)painter, (void*)&option, (void*)&index);
        } else {
            QStyledItemDelegate::paint(painter, option, index);
        }
    }

    QSize sizeHint(const QStyleOptionViewItem& option,
                   const QModelIndex& index) const override {
        if (cb_02) {
            int w = 0, h = 0;
            int handled = ((int(*)(void*,void*,int*,int*))cb_02)(
                dt_02, (void*)&index, &w, &h);
            if (handled) return QSize(w, h);
        }
        return QStyledItemDelegate::sizeHint(option, index);
    }

    QWidget* createEditor(QWidget* parent, const QStyleOptionViewItem& option,
                          const QModelIndex& index) const override {
        if (cb_03) {
            void* w = ((void*(*)(void*,void*,void*))cb_03)(
                dt_03, (void*)parent, (void*)&index);
            if (w) return (QWidget*)w;
        }
        return QStyledItemDelegate::createEditor(parent, option, index);
    }

    void setEditorData(QWidget* editor, const QModelIndex& index) const override {
        if (cb_04) {
            ((void(*)(void*,void*,void*))cb_04)(dt_04, (void*)editor, (void*)&index);
        } else {
            QStyledItemDelegate::setEditorData(editor, index);
        }
    }

    void setModelData(QWidget* editor, QAbstractItemModel* model,
                      const QModelIndex& index) const override {
        if (cb_05) {
            ((void(*)(void*,void*,void*,void*))cb_05)(
                dt_05, (void*)editor, (void*)model, (void*)&index);
        } else {
            QStyledItemDelegate::setModelData(editor, model, index);
        }
    }
};

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQStyledItemDelegate_create(void* parent) {
    return qte_createTracked(new eQStyledItemDelegate((QObject*)parent));
}

void qteQStyledItemDelegate_delete(void* w) {
    delete (eQStyledItemDelegate*)w;
}

// ── Methods ──────────────────────────────────────────────────────────────
void* qteQStyledItemDelegate_itemEditorFactory(void* _obj) {
    return (void*)((QStyledItemDelegate*)_obj)->itemEditorFactory();
}

void qteQStyledItemDelegate_setItemEditorFactory(void* _obj, void* factory) {
    ((QStyledItemDelegate*)_obj)->setItemEditorFactory((QItemEditorFactory*)factory);
}

// ── Virtual callbacks (MANUAL) ────────────────────────────────────────────
void qteQStyledItemDelegate_setEventCallback(void* w, int id, void* cb, void* dthis) {
    eQStyledItemDelegate* d = (eQStyledItemDelegate*)w;
    switch (id) {
        case 1: d->cb_01 = cb; d->dt_01 = dthis; break;
        case 2: d->cb_02 = cb; d->dt_02 = dthis; break;
        case 3: d->cb_03 = cb; d->dt_03 = dthis; break;
        case 4: d->cb_04 = cb; d->dt_04 = dthis; break;
        case 5: d->cb_05 = cb; d->dt_05 = dthis; break;
        default: break;
    }
}

// ── Helpers для коллбэков (MANUAL) ────────────────────────────────────────
void qteQStyledItemDelegate_callBasePaint(void* w, void* painter, void* option, void* index) {
    ((eQStyledItemDelegate*)w)->QStyledItemDelegate::paint(
        (QPainter*)painter, *(const QStyleOptionViewItem*)option, *(const QModelIndex*)index);
}

void qteQStyledItemDelegate_callBaseSizeHint(void* w, void* option, void* index, int* w_, int* h_) {
    QSize s = ((eQStyledItemDelegate*)w)->QStyledItemDelegate::sizeHint(
        *(const QStyleOptionViewItem*)option, *(const QModelIndex*)index);
    if (w_) *w_ = s.width();
    if (h_) *h_ = s.height();
}

void qteQStyledItemDelegate_optionRect(void* option, int* x, int* y, int* w, int* h) {
    QRect r = ((const QStyleOptionViewItem*)option)->rect;
    if (x) *x = r.x();
    if (y) *y = r.y();
    if (w) *w = r.width();
    if (h) *h = r.height();
}

int qteQStyledItemDelegate_optionState(void* option) {
    return (int)((const QStyleOptionViewItem*)option)->state;
}

} // extern "C"
