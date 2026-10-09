#ifndef QTE56_QLINEEDIT_BUILD
#define QTE56_QLINEEDIT_BUILD
#endif
#include "qte56_qlineedit.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include <QLineEdit>
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
class eQLineEdit : public QLineEdit {
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

    explicit eQLineEdit(QWidget* parent = nullptr) : QLineEdit(parent) {}
    explicit eQLineEdit(const QString& text, QWidget* parent = nullptr) : QLineEdit(text, parent) {}

protected:
    void mousePressEvent(QMouseEvent* e) override {
        if (cb_01) ((void(*)(void*,int,int,int))cb_01)(dt_01, e->x(), e->y(), (int)e->button());
        else QLineEdit::mousePressEvent(e);
    }
    void mouseReleaseEvent(QMouseEvent* e) override {
        if (cb_02) ((void(*)(void*,int,int,int))cb_02)(dt_02, e->x(), e->y(), (int)e->button());
        else QLineEdit::mouseReleaseEvent(e);
    }
    void mouseDoubleClickEvent(QMouseEvent* e) override {
        if (cb_03) ((void(*)(void*,int,int,int))cb_03)(dt_03, e->x(), e->y(), (int)e->button());
        else QLineEdit::mouseDoubleClickEvent(e);
    }
    void mouseMoveEvent(QMouseEvent* e) override {
        if (cb_04) ((void(*)(void*,int,int))cb_04)(dt_04, e->x(), e->y());
        else QLineEdit::mouseMoveEvent(e);
    }
    void keyPressEvent(QKeyEvent* e) override {
        if (cb_05) ((void(*)(void*,int,int))cb_05)(dt_05, (int)e->key(), (int)e->modifiers());
        QLineEdit::keyPressEvent(e);
    }
    void keyReleaseEvent(QKeyEvent* e) override {
        if (cb_06) ((void(*)(void*,int,int))cb_06)(dt_06, (int)e->key(), (int)e->modifiers());
        else QLineEdit::keyReleaseEvent(e);
    }
    void resizeEvent(QResizeEvent* e) override {
        if (cb_07) ((void(*)(void*,int,int))cb_07)(dt_07, e->size().width(), e->size().height());
        else QLineEdit::resizeEvent(e);
    }
    void moveEvent(QMoveEvent* e) override {
        if (cb_08) ((void(*)(void*,int,int))cb_08)(dt_08, e->pos().x(), e->pos().y());
        else QLineEdit::moveEvent(e);
    }
    void closeEvent(QCloseEvent* e) override {
        if (cb_09) {
            int accept = 1;
            ((void(*)(void*,int*))cb_09)(dt_09, &accept);
            if (!accept) e->ignore();
        } else {
            QLineEdit::closeEvent(e);
        }
    }
    void showEvent(QShowEvent* e) override {
        if (cb_10) ((void(*)(void*))cb_10)(dt_10);
        else QLineEdit::showEvent(e);
    }
    void hideEvent(QHideEvent* e) override {
        if (cb_11) ((void(*)(void*))cb_11)(dt_11);
        else QLineEdit::hideEvent(e);
    }
    void enterEvent(QEvent* e) override {
        if (cb_12) ((void(*)(void*))cb_12)(dt_12);
        else QLineEdit::enterEvent(e);
    }
    void leaveEvent(QEvent* e) override {
        if (cb_13) ((void(*)(void*))cb_13)(dt_13);
        else QLineEdit::leaveEvent(e);
    }
    void wheelEvent(QWheelEvent* e) override {
        if (cb_14) ((void(*)(void*,int,int))cb_14)(dt_14, e->angleDelta().x(), e->angleDelta().y());
        else QLineEdit::wheelEvent(e);
    }
    void focusInEvent(QFocusEvent* e) override {
        if (cb_15) ((void(*)(void*,int))cb_15)(dt_15, (int)e->reason());
        else QLineEdit::focusInEvent(e);
    }
    void focusOutEvent(QFocusEvent* e) override {
        if (cb_16) ((void(*)(void*,int))cb_16)(dt_16, (int)e->reason());
        else QLineEdit::focusOutEvent(e);
    }
    void contextMenuEvent(QContextMenuEvent* e) override {
        if (cb_17) ((void(*)(void*,int,int,int))cb_17)(dt_17, e->x(), e->y(), (int)e->reason());
        else QLineEdit::contextMenuEvent(e);
    }
};

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQLineEdit_create(void* parent) {
    return qte_createTracked(new eQLineEdit((QWidget*)parent);
}

void qteQLineEdit_delete(void* w) {
    delete (eQLineEdit*)w;
}

void* qteQLineEdit_create_text(void* text, void* parent) {
    return qte_createTracked(new eQLineEdit(*(QString*)text, (QWidget*)parent);
}

// ── Methods ──────────────────────────────────────────────────────────────
void qteQLineEdit_show(void* _obj) {
    ((QLineEdit*)_obj)->show();
}

void qteQLineEdit_hide(void* _obj) {
    ((QLineEdit*)_obj)->hide();
}

void qteQLineEdit_update(void* _obj) {
    ((QLineEdit*)_obj)->update();
}

void* qteQLineEdit_text(void* _obj) {
    return new QString(((QLineEdit*)_obj)->text());
}

void* qteQLineEdit_displayText(void* _obj) {
    return new QString(((QLineEdit*)_obj)->displayText());
}

void* qteQLineEdit_placeholderText(void* _obj) {
    return new QString(((QLineEdit*)_obj)->placeholderText());
}

void qteQLineEdit_setPlaceholderText(void* _obj, void* p0) {
    ((QLineEdit*)_obj)->setPlaceholderText(*(QString*)p0);
}

int qteQLineEdit_maxLength(void* _obj) {
    return ((QLineEdit*)_obj)->maxLength();
}

void qteQLineEdit_setMaxLength(void* _obj, int p0) {
    ((QLineEdit*)_obj)->setMaxLength(p0);
}

void qteQLineEdit_setFrame(void* _obj, int p0) {
    ((QLineEdit*)_obj)->setFrame((p0 != 0));
}

int qteQLineEdit_hasFrame(void* _obj) {
    return ((QLineEdit*)_obj)->hasFrame() ? 1 : 0;
}

void qteQLineEdit_setClearButtonEnabled(void* _obj, int enable) {
    ((QLineEdit*)_obj)->setClearButtonEnabled((enable != 0));
}

int qteQLineEdit_isClearButtonEnabled(void* _obj) {
    return ((QLineEdit*)_obj)->isClearButtonEnabled() ? 1 : 0;
}

int qteQLineEdit_echoMode(void* _obj) {
    return ((QLineEdit*)_obj)->echoMode();
}

void qteQLineEdit_setEchoMode(void* _obj, int p0) {
    ((QLineEdit*)_obj)->setEchoMode((QLineEdit::EchoMode)p0);
}

int qteQLineEdit_isReadOnly(void* _obj) {
    return ((QLineEdit*)_obj)->isReadOnly() ? 1 : 0;
}

void qteQLineEdit_setReadOnly(void* _obj, int p0) {
    ((QLineEdit*)_obj)->setReadOnly((p0 != 0));
}

void qteQLineEdit_setValidator(void* _obj, void* p0) {
    ((QLineEdit*)_obj)->setValidator((const QValidator*)p0);
}

void* qteQLineEdit_validator(void* _obj) {
    return (void*)((QLineEdit*)_obj)->validator();
}

void qteQLineEdit_setCompleter(void* _obj, void* completer) {
    ((QLineEdit*)_obj)->setCompleter((QCompleter*)completer);
}

void* qteQLineEdit_sizeHint(void* _obj) {
    return new QSize(((QLineEdit*)_obj)->sizeHint());
}

void* qteQLineEdit_minimumSizeHint(void* _obj) {
    return new QSize(((QLineEdit*)_obj)->minimumSizeHint());
}

int qteQLineEdit_cursorPosition(void* _obj) {
    return ((QLineEdit*)_obj)->cursorPosition();
}

void qteQLineEdit_setCursorPosition(void* _obj, int p0) {
    ((QLineEdit*)_obj)->setCursorPosition(p0);
}

int qteQLineEdit_cursorPositionAt(void* _obj, void* pos) {
    return ((QLineEdit*)_obj)->cursorPositionAt(*(const QPoint*)pos);
}

void qteQLineEdit_setAlignment(void* _obj, int flag) {
    ((QLineEdit*)_obj)->setAlignment((Qt::Alignment)flag);
}

int qteQLineEdit_alignment(void* _obj) {
    return ((QLineEdit*)_obj)->alignment();
}

void qteQLineEdit_cursorForward(void* _obj, int mark, int steps) {
    ((QLineEdit*)_obj)->cursorForward((mark != 0), steps);
}

void qteQLineEdit_cursorBackward(void* _obj, int mark, int steps) {
    ((QLineEdit*)_obj)->cursorBackward((mark != 0), steps);
}

void qteQLineEdit_cursorWordForward(void* _obj, int mark) {
    ((QLineEdit*)_obj)->cursorWordForward((mark != 0));
}

void qteQLineEdit_cursorWordBackward(void* _obj, int mark) {
    ((QLineEdit*)_obj)->cursorWordBackward((mark != 0));
}

void qteQLineEdit_backspace(void* _obj) {
    ((QLineEdit*)_obj)->backspace();
}

void qteQLineEdit_del(void* _obj) {
    ((QLineEdit*)_obj)->del();
}

void qteQLineEdit_home(void* _obj, int mark) {
    ((QLineEdit*)_obj)->home((mark != 0));
}

void qteQLineEdit_end(void* _obj, int mark) {
    ((QLineEdit*)_obj)->end((mark != 0));
}

int qteQLineEdit_isModified(void* _obj) {
    return ((QLineEdit*)_obj)->isModified() ? 1 : 0;
}

void qteQLineEdit_setModified(void* _obj, int p0) {
    ((QLineEdit*)_obj)->setModified((p0 != 0));
}

void qteQLineEdit_setSelection(void* _obj, int p0, int p1) {
    ((QLineEdit*)_obj)->setSelection(p0, p1);
}

int qteQLineEdit_hasSelectedText(void* _obj) {
    return ((QLineEdit*)_obj)->hasSelectedText() ? 1 : 0;
}

void* qteQLineEdit_selectedText(void* _obj) {
    return new QString(((QLineEdit*)_obj)->selectedText());
}

int qteQLineEdit_selectionStart(void* _obj) {
    return ((QLineEdit*)_obj)->selectionStart();
}

int qteQLineEdit_selectionEnd(void* _obj) {
    return ((QLineEdit*)_obj)->selectionEnd();
}

int qteQLineEdit_selectionLength(void* _obj) {
    return ((QLineEdit*)_obj)->selectionLength();
}

int qteQLineEdit_isUndoAvailable(void* _obj) {
    return ((QLineEdit*)_obj)->isUndoAvailable() ? 1 : 0;
}

int qteQLineEdit_isRedoAvailable(void* _obj) {
    return ((QLineEdit*)_obj)->isRedoAvailable() ? 1 : 0;
}

void qteQLineEdit_setDragEnabled(void* _obj, int b) {
    ((QLineEdit*)_obj)->setDragEnabled((b != 0));
}

int qteQLineEdit_dragEnabled(void* _obj) {
    return ((QLineEdit*)_obj)->dragEnabled() ? 1 : 0;
}

void qteQLineEdit_setCursorMoveStyle(void* _obj, int style) {
    ((QLineEdit*)_obj)->setCursorMoveStyle((Qt::CursorMoveStyle)style);
}

int qteQLineEdit_cursorMoveStyle(void* _obj) {
    return ((QLineEdit*)_obj)->cursorMoveStyle();
}

void* qteQLineEdit_inputMask(void* _obj) {
    return new QString(((QLineEdit*)_obj)->inputMask());
}

void qteQLineEdit_setInputMask(void* _obj, void* inputMask) {
    ((QLineEdit*)_obj)->setInputMask(*(QString*)inputMask);
}

int qteQLineEdit_hasAcceptableInput(void* _obj) {
    return ((QLineEdit*)_obj)->hasAcceptableInput() ? 1 : 0;
}

void qteQLineEdit_setTextMargins(void* _obj, int left, int top, int right, int bottom) {
    ((QLineEdit*)_obj)->setTextMargins(left, top, right, bottom);
}

void qteQLineEdit_getTextMargins(void* _obj, void* left, void* top, void* right, void* bottom) {
    ((QLineEdit*)_obj)->getTextMargins((int*)left, (int*)top, (int*)right, (int*)bottom);
}

void qteQLineEdit_addAction(void* _obj, void* action, int position) {
    ((QLineEdit*)_obj)->addAction((QAction*)action, (QLineEdit::ActionPosition)position);
}

void qteQLineEdit_setText(void* _obj, void* p0) {
    ((QLineEdit*)_obj)->setText(*(QString*)p0);
}

void qteQLineEdit_clear(void* _obj) {
    ((QLineEdit*)_obj)->clear();
}

void qteQLineEdit_selectAll(void* _obj) {
    ((QLineEdit*)_obj)->selectAll();
}

void qteQLineEdit_undo(void* _obj) {
    ((QLineEdit*)_obj)->undo();
}

void qteQLineEdit_redo(void* _obj) {
    ((QLineEdit*)_obj)->redo();
}

void qteQLineEdit_cut(void* _obj) {
    ((QLineEdit*)_obj)->cut();
}

void qteQLineEdit_copy(void* _obj) {
    ((QLineEdit*)_obj)->copy();
}

void qteQLineEdit_paste(void* _obj) {
    ((QLineEdit*)_obj)->paste();
}

void qteQLineEdit_deselect(void* _obj) {
    ((QLineEdit*)_obj)->deselect();
}

void qteQLineEdit_insert(void* _obj, void* p0) {
    ((QLineEdit*)_obj)->insert(*(QString*)p0);
}

int qteQLineEdit_event(void* _obj, void* p0) {
    return ((QLineEdit*)_obj)->event((QEvent*)p0) ? 1 : 0;
}

// ── Event handler ────────────────────────────────────────────────────────────
void qteQLineEdit_setEventHandler(void* w, int id, void* cb, void* dthis) {
    eQLineEdit* obj = (eQLineEdit*)w;
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

} // extern "C"
