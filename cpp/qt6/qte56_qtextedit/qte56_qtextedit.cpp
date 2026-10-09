#ifndef QTE56_QTEXTEDIT_BUILD
#define QTE56_QTEXTEDIT_BUILD
#endif
#include "qte56_qtextedit.h"
#include "../qte56_qcore/eslot.h"   // WheelEventInfo / MouseEventInfo / KeyEventInfo
#include <QTextEdit>
#include <QTextCursor>
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
class eQTextEdit : public QTextEdit {
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
    // ── Расширенные Full-callback'и (id 19..25) — см. eslot.h ───────────────
    void* cb_19 = nullptr;  void* dt_19 = nullptr;  // 19: wheel  Full
    void* cb_20 = nullptr;  void* dt_20 = nullptr;  // 20: mousePress      Full
    void* cb_21 = nullptr;  void* dt_21 = nullptr;  // 21: mouseRelease    Full
    void* cb_22 = nullptr;  void* dt_22 = nullptr;  // 22: mouseMove       Full
    void* cb_23 = nullptr;  void* dt_23 = nullptr;  // 23: mouseDoubleClick Full
    void* cb_24 = nullptr;  void* dt_24 = nullptr;  // 24: keyPress   Full
    void* cb_25 = nullptr;  void* dt_25 = nullptr;  // 25: keyRelease Full

    explicit eQTextEdit(QWidget* parent = nullptr) : QTextEdit(parent) {}
    explicit eQTextEdit(const QString& text, QWidget* parent = nullptr) : QTextEdit(text, parent) {}

protected:
    static void fillMouse(MouseEventInfo* info, QMouseEvent* e) {
        info->x = e->x(); info->y = e->y();
        info->globalX = e->globalX(); info->globalY = e->globalY();
        info->button = (int)e->button();
        info->buttons = (int)e->buttons();
        info->modifiers = (int)e->modifiers();
    }
    static void fillKey(KeyEventInfo* info, QKeyEvent* e, QString* textBuf) {
        info->key = (int)e->key();
        info->modifiers = (int)e->modifiers();
        info->isAutoRepeat = e->isAutoRepeat() ? 1 : 0;
        info->count = e->count();
        info->nativeScanCode = (int)e->nativeScanCode();
        *textBuf = e->text();
        info->text = (void*)textBuf;
    }

    void mousePressEvent(QMouseEvent* e) override {
        if (cb_20) {
            MouseEventInfo info; fillMouse(&info, e);
            int consumed = ((int(*)(void*, MouseEventInfo*))cb_20)(dt_20, &info);
            if (consumed) return;
        }
        if (cb_01) ((void(*)(void*,int,int,int))cb_01)(dt_01, e->x(), e->y(), (int)e->button());
        else QTextEdit::mousePressEvent(e);
    }
    void mouseReleaseEvent(QMouseEvent* e) override {
        if (cb_21) {
            MouseEventInfo info; fillMouse(&info, e);
            int consumed = ((int(*)(void*, MouseEventInfo*))cb_21)(dt_21, &info);
            if (consumed) return;
        }
        if (cb_02) ((void(*)(void*,int,int,int))cb_02)(dt_02, e->x(), e->y(), (int)e->button());
        else QTextEdit::mouseReleaseEvent(e);
    }
    void mouseDoubleClickEvent(QMouseEvent* e) override {
        if (cb_23) {
            MouseEventInfo info; fillMouse(&info, e);
            int consumed = ((int(*)(void*, MouseEventInfo*))cb_23)(dt_23, &info);
            if (consumed) return;
        }
        if (cb_03) ((void(*)(void*,int,int,int))cb_03)(dt_03, e->x(), e->y(), (int)e->button());
        else QTextEdit::mouseDoubleClickEvent(e);
    }
    void mouseMoveEvent(QMouseEvent* e) override {
        if (cb_22) {
            MouseEventInfo info; fillMouse(&info, e);
            int consumed = ((int(*)(void*, MouseEventInfo*))cb_22)(dt_22, &info);
            if (consumed) return;
        }
        if (cb_04) ((void(*)(void*,int,int))cb_04)(dt_04, e->x(), e->y());
        else QTextEdit::mouseMoveEvent(e);
    }
    void keyPressEvent(QKeyEvent* e) override {
        if (cb_24) {
            KeyEventInfo info; QString tb; fillKey(&info, e, &tb);
            int consumed = ((int(*)(void*, KeyEventInfo*))cb_24)(dt_24, &info);
            if (consumed) return;
        }
        if (cb_05) ((void(*)(void*,int,int))cb_05)(dt_05, (int)e->key(), (int)e->modifiers());
        else QTextEdit::keyPressEvent(e);
    }
    void keyReleaseEvent(QKeyEvent* e) override {
        if (cb_25) {
            KeyEventInfo info; QString tb; fillKey(&info, e, &tb);
            int consumed = ((int(*)(void*, KeyEventInfo*))cb_25)(dt_25, &info);
            if (consumed) return;
        }
        if (cb_06) ((void(*)(void*,int,int))cb_06)(dt_06, (int)e->key(), (int)e->modifiers());
        else QTextEdit::keyReleaseEvent(e);
    }
    void resizeEvent(QResizeEvent* e) override {
        if (cb_07) ((void(*)(void*,int,int))cb_07)(dt_07, e->size().width(), e->size().height());
        else QTextEdit::resizeEvent(e);
    }
    void moveEvent(QMoveEvent* e) override {
        if (cb_08) ((void(*)(void*,int,int))cb_08)(dt_08, e->pos().x(), e->pos().y());
        else QTextEdit::moveEvent(e);
    }
    void closeEvent(QCloseEvent* e) override {
        if (cb_09) {
            int accept = 1;
            ((void(*)(void*,int*))cb_09)(dt_09, &accept);
            if (!accept) e->ignore();
        } else {
            QTextEdit::closeEvent(e);
        }
    }
    void showEvent(QShowEvent* e) override {
        if (cb_10) ((void(*)(void*))cb_10)(dt_10);
        else QTextEdit::showEvent(e);
    }
    void hideEvent(QHideEvent* e) override {
        if (cb_11) ((void(*)(void*))cb_11)(dt_11);
        else QTextEdit::hideEvent(e);
    }
    void enterEvent(QEnterEvent* e) override {
        if (cb_12) ((void(*)(void*))cb_12)(dt_12);
        else QTextEdit::enterEvent(e);
    }
    void leaveEvent(QEvent* e) override {
        if (cb_13) ((void(*)(void*))cb_13)(dt_13);
        else QTextEdit::leaveEvent(e);
    }
    void wheelEvent(QWheelEvent* e) override {
        if (cb_19) {
            WheelEventInfo info;
            info.dx = e->angleDelta().x();  info.dy = e->angleDelta().y();
            info.pdx = e->pixelDelta().x(); info.pdy = e->pixelDelta().y();
            QPoint p = e->position().toPoint();
            info.x = p.x(); info.y = p.y();
            QPoint gp = e->globalPosition().toPoint();
            info.globalX = gp.x(); info.globalY = gp.y();
            info.modifiers = (int)e->modifiers();
            info.buttons = (int)e->buttons();
            info.phase = (int)e->phase();
            info.source = (int)e->source();
            info.inverted = e->inverted() ? 1 : 0;
            int consumed = ((int(*)(void*, WheelEventInfo*))cb_19)(dt_19, &info);
            if (consumed) return;
        }
        if (cb_14) ((void(*)(void*,int,int))cb_14)(dt_14, e->angleDelta().x(), e->angleDelta().y());
        else QTextEdit::wheelEvent(e);
    }
    void focusInEvent(QFocusEvent* e) override {
        if (cb_15) ((void(*)(void*,int))cb_15)(dt_15, (int)e->reason());
        else QTextEdit::focusInEvent(e);
    }
    void focusOutEvent(QFocusEvent* e) override {
        if (cb_16) ((void(*)(void*,int))cb_16)(dt_16, (int)e->reason());
        else QTextEdit::focusOutEvent(e);
    }
    void contextMenuEvent(QContextMenuEvent* e) override {
        if (cb_17) ((void(*)(void*,int,int,int))cb_17)(dt_17, e->x(), e->y(), (int)e->reason());
        else QTextEdit::contextMenuEvent(e);
    }
};

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQTextEdit_create(void* parent) {
    return new eQTextEdit((QWidget*)parent);
}

void qteQTextEdit_delete(void* w) {
    delete (eQTextEdit*)w;
}

void* qteQTextEdit_create_text(void* text, void* parent) {
    return new eQTextEdit(*(QString*)text, (QWidget*)parent);
}

// ── Methods ──────────────────────────────────────────────────────────────
void qteQTextEdit_setDocument(void* _obj, void* document) {
    ((QTextEdit*)_obj)->setDocument((QTextDocument*)document);
}

void* qteQTextEdit_document(void* _obj) {
    return (void*)((QTextEdit*)_obj)->document();
}

void qteQTextEdit_setPlaceholderText(void* _obj, void* placeholderText) {
    ((QTextEdit*)_obj)->setPlaceholderText(*(QString*)placeholderText);
}

void* qteQTextEdit_placeholderText(void* _obj) {
    return new QString(((QTextEdit*)_obj)->placeholderText());
}

int qteQTextEdit_isReadOnly(void* _obj) {
    return ((QTextEdit*)_obj)->isReadOnly() ? 1 : 0;
}

void qteQTextEdit_setReadOnly(void* _obj, int ro) {
    ((QTextEdit*)_obj)->setReadOnly((ro != 0));
}

void qteQTextEdit_setTextInteractionFlags(void* _obj, int flags) {
    ((QTextEdit*)_obj)->setTextInteractionFlags((Qt::TextInteractionFlags)flags);
}

int qteQTextEdit_textInteractionFlags(void* _obj) {
    return ((QTextEdit*)_obj)->textInteractionFlags();
}

double qteQTextEdit_fontPointSize(void* _obj) {
    return ((QTextEdit*)_obj)->fontPointSize();
}

void* qteQTextEdit_fontFamily(void* _obj) {
    return new QString(((QTextEdit*)_obj)->fontFamily());
}

int qteQTextEdit_fontWeight(void* _obj) {
    return ((QTextEdit*)_obj)->fontWeight();
}

int qteQTextEdit_fontUnderline(void* _obj) {
    return ((QTextEdit*)_obj)->fontUnderline() ? 1 : 0;
}

int qteQTextEdit_fontItalic(void* _obj) {
    return ((QTextEdit*)_obj)->fontItalic() ? 1 : 0;
}

int qteQTextEdit_alignment(void* _obj) {
    return ((QTextEdit*)_obj)->alignment();
}

int qteQTextEdit_autoFormatting(void* _obj) {
    return ((QTextEdit*)_obj)->autoFormatting();
}

void qteQTextEdit_setAutoFormatting(void* _obj, int features) {
    ((QTextEdit*)_obj)->setAutoFormatting((QTextEdit::AutoFormatting)features);
}

int qteQTextEdit_tabChangesFocus(void* _obj) {
    return ((QTextEdit*)_obj)->tabChangesFocus() ? 1 : 0;
}

void qteQTextEdit_setTabChangesFocus(void* _obj, int b) {
    ((QTextEdit*)_obj)->setTabChangesFocus((b != 0));
}

int qteQTextEdit_lineWrapMode(void* _obj) {
    return ((QTextEdit*)_obj)->lineWrapMode();
}

void qteQTextEdit_setLineWrapMode(void* _obj, int mode) {
    ((QTextEdit*)_obj)->setLineWrapMode((QTextEdit::LineWrapMode)mode);
}

int qteQTextEdit_lineWrapColumnOrWidth(void* _obj) {
    return ((QTextEdit*)_obj)->lineWrapColumnOrWidth();
}

void qteQTextEdit_setLineWrapColumnOrWidth(void* _obj, int w) {
    ((QTextEdit*)_obj)->setLineWrapColumnOrWidth(w);
}

int qteQTextEdit_wordWrapMode(void* _obj) {
    return ((QTextEdit*)_obj)->wordWrapMode();
}

void qteQTextEdit_setWordWrapMode(void* _obj, int policy) {
    ((QTextEdit*)_obj)->setWordWrapMode((QTextOption::WrapMode)policy);
}

int qteQTextEdit_find(void* _obj, void* exp, int options) {
    return ((QTextEdit*)_obj)->find(*(QString*)exp, (QTextDocument::FindFlags)options) ? 1 : 0;
}

void* qteQTextEdit_toPlainText(void* _obj) {
    return new QString(((QTextEdit*)_obj)->toPlainText());
}

void* qteQTextEdit_toHtml(void* _obj) {
    return new QString(((QTextEdit*)_obj)->toHtml());
}

void qteQTextEdit_ensureCursorVisible(void* _obj) {
    ((QTextEdit*)_obj)->ensureCursorVisible();
}

void* qteQTextEdit_createStandardContextMenu_v(void* _obj) {
    return (void*)((QTextEdit*)_obj)->createStandardContextMenu();
}

void* qteQTextEdit_createStandardContextMenu_p(void* _obj, void* position) {
    return (void*)((QTextEdit*)_obj)->createStandardContextMenu(*(const QPoint*)position);
}

void* qteQTextEdit_cursorRect(void* _obj) {
    return new QRect(((QTextEdit*)_obj)->cursorRect());
}

void* qteQTextEdit_anchorAt(void* _obj, void* pos) {
    return new QString(((QTextEdit*)_obj)->anchorAt(*(const QPoint*)pos));
}

int qteQTextEdit_overwriteMode(void* _obj) {
    return ((QTextEdit*)_obj)->overwriteMode() ? 1 : 0;
}

void qteQTextEdit_setOverwriteMode(void* _obj, int overwrite) {
    ((QTextEdit*)_obj)->setOverwriteMode((overwrite != 0));
}

double qteQTextEdit_tabStopDistance(void* _obj) {
    return ((QTextEdit*)_obj)->tabStopDistance();
}

void qteQTextEdit_setTabStopDistance(void* _obj, double distance) {
    ((QTextEdit*)_obj)->setTabStopDistance(distance);
}

int qteQTextEdit_cursorWidth(void* _obj) {
    return ((QTextEdit*)_obj)->cursorWidth();
}

void qteQTextEdit_setCursorWidth(void* _obj, int width) {
    ((QTextEdit*)_obj)->setCursorWidth(width);
}

int qteQTextEdit_acceptRichText(void* _obj) {
    return ((QTextEdit*)_obj)->acceptRichText() ? 1 : 0;
}

void qteQTextEdit_setAcceptRichText(void* _obj, int accept) {
    ((QTextEdit*)_obj)->setAcceptRichText((accept != 0));
}

void qteQTextEdit_moveCursor(void* _obj, int operation, int mode) {
    ((QTextEdit*)_obj)->moveCursor((QTextCursor::MoveOperation)operation, (QTextCursor::MoveMode)mode);
}

int qteQTextEdit_canPaste(void* _obj) {
    return ((QTextEdit*)_obj)->canPaste() ? 1 : 0;
}

void qteQTextEdit_print(void* _obj, void* printer) {
    ((QTextEdit*)_obj)->print((QPagedPaintDevice*)printer);
}

void qteQTextEdit_setFontPointSize(void* _obj, double s) {
    ((QTextEdit*)_obj)->setFontPointSize(s);
}

void qteQTextEdit_setFontFamily(void* _obj, void* fontFamily) {
    ((QTextEdit*)_obj)->setFontFamily(*(QString*)fontFamily);
}

void qteQTextEdit_setFontWeight(void* _obj, int w) {
    ((QTextEdit*)_obj)->setFontWeight(w);
}

void qteQTextEdit_setFontUnderline(void* _obj, int b) {
    ((QTextEdit*)_obj)->setFontUnderline((b != 0));
}

void qteQTextEdit_setFontItalic(void* _obj, int b) {
    ((QTextEdit*)_obj)->setFontItalic((b != 0));
}

void qteQTextEdit_setAlignment(void* _obj, int a) {
    ((QTextEdit*)_obj)->setAlignment((Qt::Alignment)a);
}

void qteQTextEdit_setPlainText(void* _obj, void* text) {
    ((QTextEdit*)_obj)->setPlainText(*(QString*)text);
}

void qteQTextEdit_setHtml(void* _obj, void* text) {
    ((QTextEdit*)_obj)->setHtml(*(QString*)text);
}

void qteQTextEdit_setText(void* _obj, void* text) {
    ((QTextEdit*)_obj)->setText(*(QString*)text);
}

void qteQTextEdit_cut(void* _obj) {
    ((QTextEdit*)_obj)->cut();
}

void qteQTextEdit_copy(void* _obj) {
    ((QTextEdit*)_obj)->copy();
}

void qteQTextEdit_paste(void* _obj) {
    ((QTextEdit*)_obj)->paste();
}

void qteQTextEdit_undo(void* _obj) {
    ((QTextEdit*)_obj)->undo();
}

void qteQTextEdit_redo(void* _obj) {
    ((QTextEdit*)_obj)->redo();
}

void qteQTextEdit_clear(void* _obj) {
    ((QTextEdit*)_obj)->clear();
}

void qteQTextEdit_selectAll(void* _obj) {
    ((QTextEdit*)_obj)->selectAll();
}

void qteQTextEdit_insertPlainText(void* _obj, void* text) {
    ((QTextEdit*)_obj)->insertPlainText(*(QString*)text);
}

void qteQTextEdit_insertHtml(void* _obj, void* text) {
    ((QTextEdit*)_obj)->insertHtml(*(QString*)text);
}

void qteQTextEdit_append(void* _obj, void* text) {
    ((QTextEdit*)_obj)->append(*(QString*)text);
}

void qteQTextEdit_scrollToAnchor(void* _obj, void* name) {
    ((QTextEdit*)_obj)->scrollToAnchor(*(QString*)name);
}

void qteQTextEdit_zoomIn(void* _obj, int range) {
    ((QTextEdit*)_obj)->zoomIn(range);
}

void qteQTextEdit_zoomOut(void* _obj, int range) {
    ((QTextEdit*)_obj)->zoomOut(range);
}

// ── TextCursor ───────────────────────────────────────────────────────────────
void* qteQTextEdit_textCursor(void* _obj) {
    return new QTextCursor(((QTextEdit*)_obj)->textCursor());
}

void qteQTextEdit_setTextCursor(void* _obj, void* cursor) {
    ((QTextEdit*)_obj)->setTextCursor(*(QTextCursor*)cursor);
}

// ── Event handler ────────────────────────────────────────────────────────────
void qteQTextEdit_setEventHandler(void* w, int id, void* cb, void* dthis) {
    eQTextEdit* obj = (eQTextEdit*)w;
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
        // ── Full-event callbacks (extended API) ─────────────────────────────
        case 19: obj->cb_19 = cb; obj->dt_19 = dthis; break;  // wheel Full
        case 20: obj->cb_20 = cb; obj->dt_20 = dthis; break;  // mousePress Full
        case 21: obj->cb_21 = cb; obj->dt_21 = dthis; break;  // mouseRelease Full
        case 22: obj->cb_22 = cb; obj->dt_22 = dthis; break;  // mouseMove Full
        case 23: obj->cb_23 = cb; obj->dt_23 = dthis; break;  // mouseDoubleClick Full
        case 24: obj->cb_24 = cb; obj->dt_24 = dthis; break;  // keyPress Full
        case 25: obj->cb_25 = cb; obj->dt_25 = dthis; break;  // keyRelease Full
        default: break;
    }
}

} // extern "C"
