#ifndef QTE56_QFILEDIALOG_BUILD
#define QTE56_QFILEDIALOG_BUILD
#endif
#include "qte56_qfiledialog.h"
#include <QFileDialog>
#include <QStringList>
#include <QString>
#include <QCloseEvent>
#include <QContextMenuEvent>
#include <QFocusEvent>
#include <QHideEvent>
#include <QKeyEvent>
#include <QMouseEvent>
#include <QMoveEvent>
#include <QResizeEvent>
#include <QShowEvent>
#include <QWheelEvent>

// ─── Event proxy ──────────────────────────────────────────────────────────────
class eQFileDialog : public QFileDialog {
public:
    void* cb_01 = nullptr;  void* dt_01 = nullptr;  // 1: mousePressEvent
    void* cb_02 = nullptr;  void* dt_02 = nullptr;  // 2: mouseReleaseEvent
    void* cb_03 = nullptr;  void* dt_03 = nullptr;  // 3: mouseDoubleClickEvent
    void* cb_04 = nullptr;  void* dt_04 = nullptr;  // 4: mouseMoveEvent
    void* cb_05 = nullptr;  void* dt_05 = nullptr;  // 5: keyPressEvent
    void* cb_06 = nullptr;  void* dt_06 = nullptr;  // 6: keyReleaseEvent
    void* cb_07 = nullptr;  void* dt_07 = nullptr;  // 7: resizeEvent
    void* cb_08 = nullptr;  void* dt_08 = nullptr;  // 8: moveEvent
    void* cb_09 = nullptr;  void* dt_09 = nullptr;  // 9: closeEvent
    void* cb_10 = nullptr;  void* dt_10 = nullptr;  // 10: showEvent
    void* cb_11 = nullptr;  void* dt_11 = nullptr;  // 11: hideEvent
    void* cb_12 = nullptr;  void* dt_12 = nullptr;  // 12: enterEvent
    void* cb_13 = nullptr;  void* dt_13 = nullptr;  // 13: leaveEvent
    void* cb_14 = nullptr;  void* dt_14 = nullptr;  // 14: wheelEvent
    void* cb_15 = nullptr;  void* dt_15 = nullptr;  // 15: focusInEvent
    void* cb_16 = nullptr;  void* dt_16 = nullptr;  // 16: focusOutEvent
    void* cb_17 = nullptr;  void* dt_17 = nullptr;  // 17: contextMenuEvent

    explicit eQFileDialog(QWidget* parent = nullptr) : QFileDialog(parent) {}

protected:
    void mousePressEvent(QMouseEvent* e) override {
        if (cb_01) ((void(*)(void*,int,int,int))cb_01)(dt_01, e->x(), e->y(), (int)e->button());
        else QFileDialog::mousePressEvent(e);
    }
    void mouseReleaseEvent(QMouseEvent* e) override {
        if (cb_02) ((void(*)(void*,int,int,int))cb_02)(dt_02, e->x(), e->y(), (int)e->button());
        else QFileDialog::mouseReleaseEvent(e);
    }
    void mouseDoubleClickEvent(QMouseEvent* e) override {
        if (cb_03) ((void(*)(void*,int,int,int))cb_03)(dt_03, e->x(), e->y(), (int)e->button());
        else QFileDialog::mouseDoubleClickEvent(e);
    }
    void mouseMoveEvent(QMouseEvent* e) override {
        if (cb_04) ((void(*)(void*,int,int))cb_04)(dt_04, e->x(), e->y());
        else QFileDialog::mouseMoveEvent(e);
    }
    void keyPressEvent(QKeyEvent* e) override {
        if (cb_05) ((void(*)(void*,int,int))cb_05)(dt_05, (int)e->key(), (int)e->modifiers());
        else QFileDialog::keyPressEvent(e);
    }
    void keyReleaseEvent(QKeyEvent* e) override {
        if (cb_06) ((void(*)(void*,int,int))cb_06)(dt_06, (int)e->key(), (int)e->modifiers());
        else QFileDialog::keyReleaseEvent(e);
    }
    void resizeEvent(QResizeEvent* e) override {
        if (cb_07) ((void(*)(void*,int,int))cb_07)(dt_07, e->size().width(), e->size().height());
        else QFileDialog::resizeEvent(e);
    }
    void moveEvent(QMoveEvent* e) override {
        if (cb_08) ((void(*)(void*,int,int))cb_08)(dt_08, e->pos().x(), e->pos().y());
        else QFileDialog::moveEvent(e);
    }
    void closeEvent(QCloseEvent* e) override {
        if (cb_09) {
            int accept = 1;
            ((void(*)(void*,int*))cb_09)(dt_09, &accept);
            if (!accept) e->ignore();
        } else {
            QFileDialog::closeEvent(e);
        }
    }
    void showEvent(QShowEvent* e) override {
        if (cb_10) ((void(*)(void*))cb_10)(dt_10);
        else QFileDialog::showEvent(e);
    }
    void hideEvent(QHideEvent* e) override {
        if (cb_11) ((void(*)(void*))cb_11)(dt_11);
        else QFileDialog::hideEvent(e);
    }
    void enterEvent(QEnterEvent* e) override {
        if (cb_12) ((void(*)(void*))cb_12)(dt_12);
        else QFileDialog::enterEvent(e);
    }
    void leaveEvent(QEvent* e) override {
        if (cb_13) ((void(*)(void*))cb_13)(dt_13);
        else QFileDialog::leaveEvent(e);
    }
    void wheelEvent(QWheelEvent* e) override {
        if (cb_14) ((void(*)(void*,int,int))cb_14)(dt_14, e->angleDelta().x(), e->angleDelta().y());
        else QFileDialog::wheelEvent(e);
    }
    void focusInEvent(QFocusEvent* e) override {
        if (cb_15) ((void(*)(void*,int))cb_15)(dt_15, (int)e->reason());
        else QFileDialog::focusInEvent(e);
    }
    void focusOutEvent(QFocusEvent* e) override {
        if (cb_16) ((void(*)(void*,int))cb_16)(dt_16, (int)e->reason());
        else QFileDialog::focusOutEvent(e);
    }
    void contextMenuEvent(QContextMenuEvent* e) override {
        if (cb_17) ((void(*)(void*,int,int,int))cb_17)(dt_17, e->x(), e->y(), (int)e->reason());
        else QFileDialog::contextMenuEvent(e);
    }
};

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQFileDialog_create(void* parent) {
    return new eQFileDialog((QWidget*)parent);
}

void qteQFileDialog_delete(void* w) {
    delete (eQFileDialog*)w;
}

// ── Methods ──────────────────────────────────────────────────────────────
void qteQFileDialog_setDirectory(void* _obj, void* directory) {
    ((QFileDialog*)_obj)->setDirectory(*(QString*)directory);
}

void qteQFileDialog_selectFile(void* _obj, void* filename) {
    ((QFileDialog*)_obj)->selectFile(*(QString*)filename);
}

void qteQFileDialog_setNameFilterDetailsVisible(void* _obj, int enabled) {
    // setNameFilterDetailsVisible removed in Qt6 — no-op
    (void)_obj; (void)enabled;
}

int qteQFileDialog_isNameFilterDetailsVisible(void* _obj) {
    // isNameFilterDetailsVisible removed in Qt6 — always return 0
    (void)_obj;
    return 0;
}

void qteQFileDialog_setNameFilter(void* _obj, void* filter) {
    ((QFileDialog*)_obj)->setNameFilter(*(QString*)filter);
}

void qteQFileDialog_selectNameFilter(void* _obj, void* filter) {
    ((QFileDialog*)_obj)->selectNameFilter(*(QString*)filter);
}

void* qteQFileDialog_selectedMimeTypeFilter(void* _obj) {
    return new QString(((QFileDialog*)_obj)->selectedMimeTypeFilter());
}

void* qteQFileDialog_selectedNameFilter(void* _obj) {
    return new QString(((QFileDialog*)_obj)->selectedNameFilter());
}

void qteQFileDialog_selectMimeTypeFilter(void* _obj, void* filter) {
    ((QFileDialog*)_obj)->selectMimeTypeFilter(*(QString*)filter);
}

int qteQFileDialog_filter(void* _obj) {
    return ((QFileDialog*)_obj)->filter();
}

void qteQFileDialog_setFilter(void* _obj, int filters) {
    ((QFileDialog*)_obj)->setFilter((QDir::Filters)filters);
}

void qteQFileDialog_setViewMode(void* _obj, int mode) {
    ((QFileDialog*)_obj)->setViewMode((QFileDialog::ViewMode)mode);
}

int qteQFileDialog_viewMode(void* _obj) {
    return ((QFileDialog*)_obj)->viewMode();
}

void qteQFileDialog_setFileMode(void* _obj, int mode) {
    ((QFileDialog*)_obj)->setFileMode((QFileDialog::FileMode)mode);
}

int qteQFileDialog_fileMode(void* _obj) {
    return ((QFileDialog*)_obj)->fileMode();
}

void qteQFileDialog_setAcceptMode(void* _obj, int mode) {
    ((QFileDialog*)_obj)->setAcceptMode((QFileDialog::AcceptMode)mode);
}

int qteQFileDialog_acceptMode(void* _obj) {
    return ((QFileDialog*)_obj)->acceptMode();
}

void qteQFileDialog_setReadOnly(void* _obj, int enabled) {
    // setReadOnly removed in Qt6 — no-op
    (void)_obj; (void)enabled;
}

int qteQFileDialog_isReadOnly(void* _obj) {
    // isReadOnly removed in Qt6 — always return 0
    (void)_obj;
    return 0;
}

void qteQFileDialog_setResolveSymlinks(void* _obj, int enabled) {
    // setResolveSymlinks removed in Qt6 — no-op
    (void)_obj; (void)enabled;
}

int qteQFileDialog_resolveSymlinks(void* _obj) {
    // resolveSymlinks removed in Qt6 — always return 0
    (void)_obj;
    return 0;
}

void qteQFileDialog_setConfirmOverwrite(void* _obj, int enabled) {
    // setConfirmOverwrite removed in Qt6 — no-op
    (void)_obj; (void)enabled;
}

int qteQFileDialog_confirmOverwrite(void* _obj) {
    // confirmOverwrite removed in Qt6 — always return 0
    (void)_obj;
    return 0;
}

void qteQFileDialog_setDefaultSuffix(void* _obj, void* suffix) {
    ((QFileDialog*)_obj)->setDefaultSuffix(*(QString*)suffix);
}

void* qteQFileDialog_defaultSuffix(void* _obj) {
    return new QString(((QFileDialog*)_obj)->defaultSuffix());
}

void qteQFileDialog_setItemDelegate(void* _obj, void* delegate) {
    ((QFileDialog*)_obj)->setItemDelegate((QAbstractItemDelegate*)delegate);
}

void* qteQFileDialog_itemDelegate(void* _obj) {
    return (void*)((QFileDialog*)_obj)->itemDelegate();
}

void qteQFileDialog_setIconProvider(void* _obj, void* provider) {
    // setIconProvider removed in Qt6 — no-op
    (void)_obj; (void)provider;
}

void* qteQFileDialog_iconProvider(void* _obj) {
    // iconProvider removed in Qt6 — return nullptr
    (void)_obj;
    return nullptr;
}

void qteQFileDialog_setLabelText(void* _obj, int label, void* text) {
    ((QFileDialog*)_obj)->setLabelText((QFileDialog::DialogLabel)label, *(QString*)text);
}

void* qteQFileDialog_labelText(void* _obj, int label) {
    return new QString(((QFileDialog*)_obj)->labelText((QFileDialog::DialogLabel)label));
}

void qteQFileDialog_setProxyModel(void* _obj, void* model) {
    ((QFileDialog*)_obj)->setProxyModel((QAbstractProxyModel*)model);
}

void* qteQFileDialog_proxyModel(void* _obj) {
    return (void*)((QFileDialog*)_obj)->proxyModel();
}

void qteQFileDialog_setOption(void* _obj, int option, int on) {
    ((QFileDialog*)_obj)->setOption((QFileDialog::Option)option, (on != 0));
}

int qteQFileDialog_testOption(void* _obj, int option) {
    return ((QFileDialog*)_obj)->testOption((QFileDialog::Option)option) ? 1 : 0;
}

void qteQFileDialog_setOptions(void* _obj, int options) {
    ((QFileDialog*)_obj)->setOptions((QFileDialog::Options)options);
}

int qteQFileDialog_options(void* _obj) {
    return ((QFileDialog*)_obj)->options();
}

void* qteQFileDialog_getOpenFileName(void* /*_obj*/, void* parent, void* caption, void* dir, void* filter, void* selectedFilter, int options) {
    return new QString(QFileDialog::getOpenFileName((QWidget*)parent, *(QString*)caption, *(QString*)dir, *(QString*)filter, (QString*)selectedFilter, (QFileDialog::Options)options));
}

void* qteQFileDialog_getSaveFileName(void* /*_obj*/, void* parent, void* caption, void* dir, void* filter, void* selectedFilter, int options) {
    return new QString(QFileDialog::getSaveFileName((QWidget*)parent, *(QString*)caption, *(QString*)dir, *(QString*)filter, (QString*)selectedFilter, (QFileDialog::Options)options));
}

void* qteQFileDialog_getExistingDirectory(void* /*_obj*/, void* parent, void* caption, void* dir, int options) {
    return new QString(QFileDialog::getExistingDirectory((QWidget*)parent, *(QString*)caption, *(QString*)dir, (QFileDialog::Options)options));
}

// ── Event handler ────────────────────────────────────────────────────────────
void qteQFileDialog_setEventHandler(void* w, int id, void* cb, void* dthis) {
    eQFileDialog* obj = (eQFileDialog*)w;
    switch (id) {
        case  1: obj->cb_01 = cb; obj->dt_01 = dthis; break;  // mousePressEvent
        case  2: obj->cb_02 = cb; obj->dt_02 = dthis; break;  // mouseReleaseEvent
        case  3: obj->cb_03 = cb; obj->dt_03 = dthis; break;  // mouseDoubleClickEvent
        case  4: obj->cb_04 = cb; obj->dt_04 = dthis; break;  // mouseMoveEvent
        case  5: obj->cb_05 = cb; obj->dt_05 = dthis; break;  // keyPressEvent
        case  6: obj->cb_06 = cb; obj->dt_06 = dthis; break;  // keyReleaseEvent
        case  7: obj->cb_07 = cb; obj->dt_07 = dthis; break;  // resizeEvent
        case  8: obj->cb_08 = cb; obj->dt_08 = dthis; break;  // moveEvent
        case  9: obj->cb_09 = cb; obj->dt_09 = dthis; break;  // closeEvent
        case 10: obj->cb_10 = cb; obj->dt_10 = dthis; break;  // showEvent
        case 11: obj->cb_11 = cb; obj->dt_11 = dthis; break;  // hideEvent
        case 12: obj->cb_12 = cb; obj->dt_12 = dthis; break;  // enterEvent
        case 13: obj->cb_13 = cb; obj->dt_13 = dthis; break;  // leaveEvent
        case 14: obj->cb_14 = cb; obj->dt_14 = dthis; break;  // wheelEvent
        case 15: obj->cb_15 = cb; obj->dt_15 = dthis; break;  // focusInEvent
        case 16: obj->cb_16 = cb; obj->dt_16 = dthis; break;  // focusOutEvent
        case 17: obj->cb_17 = cb; obj->dt_17 = dthis; break;  // contextMenuEvent
        default: break;
    }
}

// ── QStringList helpers (sep=\x01) ───────────────────────────────────────────

static QStringList qsListFromSep1_fd(void* qs) {
    if (!qs) return QStringList();
    const QString& s = *(const QString*)qs;
    if (s.isEmpty()) return QStringList();
    return s.split(QChar(1));
}

void qteQFileDialog_setNameFilters(void* _obj, void* items_sep1) {
    ((QFileDialog*)_obj)->setNameFilters(qsListFromSep1_fd(items_sep1));
}

} // extern "C"
