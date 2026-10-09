#ifndef QTE56_QPLAINTEXTEDIT_BUILD
#define QTE56_QPLAINTEXTEDIT_BUILD
#endif
#include "qte56_qplaintextedit.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include "../qte56_qcore/eslot.h"   // WheelEventInfo / MouseEventInfo / KeyEventInfo
#include <QPlainTextEdit>
#include <QTextCursor>
#include <QTextBlock>
#include <QString>
#include <QMargins>
#include <QPointF>
#include <QRectF>
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
class eQPlainTextEdit : public QPlainTextEdit {
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
    // ── Расширенные Full-callback'и (id 19..25) ─────────────────────────────
    // Все возвращают int consumed: 1 = обработан, 0 = передать default Qt.
    // При установленном Full-callback приоритет у него; если вернул 0,
    // событие проходит к старому cb_xx или к default-handler'у.
    void* cb_19 = nullptr;  void* dt_19 = nullptr;  // 19: wheel  (WheelEventInfo*)
    void* cb_20 = nullptr;  void* dt_20 = nullptr;  // 20: mousePress      (MouseEventInfo*)
    void* cb_21 = nullptr;  void* dt_21 = nullptr;  // 21: mouseRelease    (MouseEventInfo*)
    void* cb_22 = nullptr;  void* dt_22 = nullptr;  // 22: mouseMove       (MouseEventInfo*)
    void* cb_23 = nullptr;  void* dt_23 = nullptr;  // 23: mouseDoubleClick(MouseEventInfo*)
    void* cb_24 = nullptr;  void* dt_24 = nullptr;  // 24: keyPress   (KeyEventInfo*)
    void* cb_25 = nullptr;  void* dt_25 = nullptr;  // 25: keyRelease (KeyEventInfo*)

    explicit eQPlainTextEdit(QWidget* parent = nullptr) : QPlainTextEdit(parent) {}
    explicit eQPlainTextEdit(const QString& text, QWidget* parent = nullptr) : QPlainTextEdit(text, parent) {}

    // ─── Расширение видимости protected-методов QAbstractScrollArea / QPlainTextEdit
    // для C-API (нужно для line-number area, sync-scrolled редакторов и т.п.).
    using QPlainTextEdit::setViewportMargins;       // l, t, r, b
    using QPlainTextEdit::viewportMargins;          // QMargins (для геттера)
    using QPlainTextEdit::scrollContentsBy;         // dx, dy
    using QPlainTextEdit::firstVisibleBlock;        // QTextBlock первого видимого
    using QPlainTextEdit::blockBoundingGeometry;    // QRectF блока в координатах документа
    using QPlainTextEdit::contentOffset;            // QPointF смещения относительно viewport

protected:
    // ── Helpers: заполнить Info-структуры из Qt event ────────────────────────
    static void fillMouse(MouseEventInfo* info, QMouseEvent* e) {
        info->x = e->x(); info->y = e->y();
        info->globalX = e->globalX(); info->globalY = e->globalY();
        info->button = (int)e->button();
        info->buttons = (int)e->buttons();
        info->modifiers = (int)e->modifiers();
    }
    // text-хранилище: QString должен жить пока выполняется callback.
    // Заполняется in-place (внутри fillKey), callback читает синхронно,
    // после возврата стэк освобождается.
    static void fillKey(KeyEventInfo* info, QKeyEvent* e, QString* textBuf) {
        info->key = (int)e->key();
        info->modifiers = (int)e->modifiers();
        info->isAutoRepeat = e->isAutoRepeat() ? 1 : 0;
        info->count = e->count();
        info->nativeScanCode = (int)e->nativeScanCode();
        *textBuf = e->text();   // копия QString живёт пока есть locals
        info->text = (void*)textBuf;
    }

    void mousePressEvent(QMouseEvent* e) override {
        if (cb_20) {
            MouseEventInfo info; fillMouse(&info, e);
            int consumed = ((int(*)(void*, MouseEventInfo*))cb_20)(dt_20, &info);
            if (consumed) return;
        }
        if (cb_01) ((void(*)(void*,int,int,int))cb_01)(dt_01, e->x(), e->y(), (int)e->button());
        else QPlainTextEdit::mousePressEvent(e);
    }
    void mouseReleaseEvent(QMouseEvent* e) override {
        if (cb_21) {
            MouseEventInfo info; fillMouse(&info, e);
            int consumed = ((int(*)(void*, MouseEventInfo*))cb_21)(dt_21, &info);
            if (consumed) return;
        }
        if (cb_02) ((void(*)(void*,int,int,int))cb_02)(dt_02, e->x(), e->y(), (int)e->button());
        else QPlainTextEdit::mouseReleaseEvent(e);
    }
    void mouseDoubleClickEvent(QMouseEvent* e) override {
        if (cb_23) {
            MouseEventInfo info; fillMouse(&info, e);
            int consumed = ((int(*)(void*, MouseEventInfo*))cb_23)(dt_23, &info);
            if (consumed) return;
        }
        if (cb_03) ((void(*)(void*,int,int,int))cb_03)(dt_03, e->x(), e->y(), (int)e->button());
        else QPlainTextEdit::mouseDoubleClickEvent(e);
    }
    void mouseMoveEvent(QMouseEvent* e) override {
        if (cb_22) {
            MouseEventInfo info; fillMouse(&info, e);
            int consumed = ((int(*)(void*, MouseEventInfo*))cb_22)(dt_22, &info);
            if (consumed) return;
        }
        if (cb_04) ((void(*)(void*,int,int))cb_04)(dt_04, e->x(), e->y());
        else QPlainTextEdit::mouseMoveEvent(e);
    }
    void keyPressEvent(QKeyEvent* e) override {
        if (cb_24) {
            KeyEventInfo info; QString tb; fillKey(&info, e, &tb);
            int consumed = ((int(*)(void*, KeyEventInfo*))cb_24)(dt_24, &info);
            if (consumed) return;
        }
        if (cb_05) {
            int consumed = ((int(*)(void*,int,int))cb_05)(dt_05, (int)e->key(), (int)e->modifiers());
            if (consumed) return;
        }
        QPlainTextEdit::keyPressEvent(e);
    }
    void keyReleaseEvent(QKeyEvent* e) override {
        if (cb_25) {
            KeyEventInfo info; QString tb; fillKey(&info, e, &tb);
            int consumed = ((int(*)(void*, KeyEventInfo*))cb_25)(dt_25, &info);
            if (consumed) return;
        }
        if (cb_06) ((void(*)(void*,int,int))cb_06)(dt_06, (int)e->key(), (int)e->modifiers());
        else QPlainTextEdit::keyReleaseEvent(e);
    }
    void resizeEvent(QResizeEvent* e) override {
        if (cb_07) ((void(*)(void*,int,int))cb_07)(dt_07, e->size().width(), e->size().height());
        else QPlainTextEdit::resizeEvent(e);
    }
    void moveEvent(QMoveEvent* e) override {
        if (cb_08) ((void(*)(void*,int,int))cb_08)(dt_08, e->pos().x(), e->pos().y());
        else QPlainTextEdit::moveEvent(e);
    }
    void closeEvent(QCloseEvent* e) override {
        if (cb_09) {
            int accept = 1;
            ((void(*)(void*,int*))cb_09)(dt_09, &accept);
            if (!accept) e->ignore();
        } else {
            QPlainTextEdit::closeEvent(e);
        }
    }
    void showEvent(QShowEvent* e) override {
        if (cb_10) ((void(*)(void*))cb_10)(dt_10);
        else QPlainTextEdit::showEvent(e);
    }
    void hideEvent(QHideEvent* e) override {
        if (cb_11) ((void(*)(void*))cb_11)(dt_11);
        else QPlainTextEdit::hideEvent(e);
    }
    void enterEvent(QEvent* e) override {
        if (cb_12) ((void(*)(void*))cb_12)(dt_12);
        else QPlainTextEdit::enterEvent(e);
    }
    void leaveEvent(QEvent* e) override {
        if (cb_13) ((void(*)(void*))cb_13)(dt_13);
        else QPlainTextEdit::leaveEvent(e);
    }
    void wheelEvent(QWheelEvent* e) override {
        if (cb_19) {
            WheelEventInfo info;
            info.dx = e->angleDelta().x();
            info.dy = e->angleDelta().y();
            info.pdx = e->pixelDelta().x();
            info.pdy = e->pixelDelta().y();
            // Qt 5.13: pos()/globalPos() возвращают QPoint (int), не QPointF.
            QPoint p = e->pos();
            info.x = p.x(); info.y = p.y();
            QPoint gp = e->globalPos();
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
        else QPlainTextEdit::wheelEvent(e);
    }
    void focusInEvent(QFocusEvent* e) override {
        if (cb_15) ((void(*)(void*,int))cb_15)(dt_15, (int)e->reason());
        else QPlainTextEdit::focusInEvent(e);
    }
    void focusOutEvent(QFocusEvent* e) override {
        if (cb_16) ((void(*)(void*,int))cb_16)(dt_16, (int)e->reason());
        else QPlainTextEdit::focusOutEvent(e);
    }
    void contextMenuEvent(QContextMenuEvent* e) override {
        if (cb_17) ((void(*)(void*,int,int,int))cb_17)(dt_17, e->x(), e->y(), (int)e->reason());
        else QPlainTextEdit::contextMenuEvent(e);
    }
};

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQPlainTextEdit_create(void* parent) {
    return qte_createTracked(new eQPlainTextEdit((QWidget*)parent);
}

void qteQPlainTextEdit_delete(void* w) {
    delete (eQPlainTextEdit*)w;
}

void* qteQPlainTextEdit_create_text(void* text, void* parent) {
    return qte_createTracked(new eQPlainTextEdit(*(QString*)text, (QWidget*)parent);
}

// ── Methods ──────────────────────────────────────────────────────────────
void qteQPlainTextEdit_setDocument(void* _obj, void* document) {
    ((QPlainTextEdit*)_obj)->setDocument((QTextDocument*)document);
}

void* qteQPlainTextEdit_document(void* _obj) {
    return (void*)((QPlainTextEdit*)_obj)->document();
}

void qteQPlainTextEdit_setPlaceholderText(void* _obj, void* placeholderText) {
    ((QPlainTextEdit*)_obj)->setPlaceholderText(*(QString*)placeholderText);
}

void* qteQPlainTextEdit_placeholderText(void* _obj) {
    return new QString(((QPlainTextEdit*)_obj)->placeholderText());
}

int qteQPlainTextEdit_isReadOnly(void* _obj) {
    return ((QPlainTextEdit*)_obj)->isReadOnly() ? 1 : 0;
}

void qteQPlainTextEdit_setReadOnly(void* _obj, int ro) {
    ((QPlainTextEdit*)_obj)->setReadOnly((ro != 0));
}

void qteQPlainTextEdit_setTextInteractionFlags(void* _obj, int flags) {
    ((QPlainTextEdit*)_obj)->setTextInteractionFlags((Qt::TextInteractionFlags)flags);
}

int qteQPlainTextEdit_textInteractionFlags(void* _obj) {
    return ((QPlainTextEdit*)_obj)->textInteractionFlags();
}

int qteQPlainTextEdit_tabChangesFocus(void* _obj) {
    return ((QPlainTextEdit*)_obj)->tabChangesFocus() ? 1 : 0;
}

void qteQPlainTextEdit_setTabChangesFocus(void* _obj, int b) {
    ((QPlainTextEdit*)_obj)->setTabChangesFocus((b != 0));
}

int qteQPlainTextEdit_lineWrapMode(void* _obj) {
    return ((QPlainTextEdit*)_obj)->lineWrapMode();
}

void qteQPlainTextEdit_setLineWrapMode(void* _obj, int mode) {
    ((QPlainTextEdit*)_obj)->setLineWrapMode((QPlainTextEdit::LineWrapMode)mode);
}

int qteQPlainTextEdit_wordWrapMode(void* _obj) {
    return ((QPlainTextEdit*)_obj)->wordWrapMode();
}

void qteQPlainTextEdit_setWordWrapMode(void* _obj, int policy) {
    ((QPlainTextEdit*)_obj)->setWordWrapMode((QTextOption::WrapMode)policy);
}

void qteQPlainTextEdit_setBackgroundVisible(void* _obj, int visible) {
    ((QPlainTextEdit*)_obj)->setBackgroundVisible((visible != 0));
}

int qteQPlainTextEdit_backgroundVisible(void* _obj) {
    return ((QPlainTextEdit*)_obj)->backgroundVisible() ? 1 : 0;
}

void qteQPlainTextEdit_setCenterOnScroll(void* _obj, int enabled) {
    ((QPlainTextEdit*)_obj)->setCenterOnScroll((enabled != 0));
}

int qteQPlainTextEdit_centerOnScroll(void* _obj) {
    return ((QPlainTextEdit*)_obj)->centerOnScroll() ? 1 : 0;
}

int qteQPlainTextEdit_find(void* _obj, void* exp, int options) {
    return ((QPlainTextEdit*)_obj)->find(*(QString*)exp, (QTextDocument::FindFlags)options) ? 1 : 0;
}

void qteQPlainTextEdit_ensureCursorVisible(void* _obj) {
    ((QPlainTextEdit*)_obj)->ensureCursorVisible();
}

void* qteQPlainTextEdit_createStandardContextMenu_v(void* _obj) {
    return (void*)((QPlainTextEdit*)_obj)->createStandardContextMenu();
}

void* qteQPlainTextEdit_createStandardContextMenu_p(void* _obj, void* position) {
    return (void*)((QPlainTextEdit*)_obj)->createStandardContextMenu(*(const QPoint*)position);
}

void* qteQPlainTextEdit_cursorRect(void* _obj) {
    return new QRect(((QPlainTextEdit*)_obj)->cursorRect());
}

void* qteQPlainTextEdit_anchorAt(void* _obj, void* pos) {
    return new QString(((QPlainTextEdit*)_obj)->anchorAt(*(const QPoint*)pos));
}

int qteQPlainTextEdit_overwriteMode(void* _obj) {
    return ((QPlainTextEdit*)_obj)->overwriteMode() ? 1 : 0;
}

void qteQPlainTextEdit_setOverwriteMode(void* _obj, int overwrite) {
    ((QPlainTextEdit*)_obj)->setOverwriteMode((overwrite != 0));
}

double qteQPlainTextEdit_tabStopDistance(void* _obj) {
    return ((QPlainTextEdit*)_obj)->tabStopDistance();
}

void qteQPlainTextEdit_setTabStopDistance(void* _obj, double distance) {
    ((QPlainTextEdit*)_obj)->setTabStopDistance(distance);
}

int qteQPlainTextEdit_cursorWidth(void* _obj) {
    return ((QPlainTextEdit*)_obj)->cursorWidth();
}

void qteQPlainTextEdit_setCursorWidth(void* _obj, int width) {
    ((QPlainTextEdit*)_obj)->setCursorWidth(width);
}

void qteQPlainTextEdit_moveCursor(void* _obj, int operation, int mode) {
    ((QPlainTextEdit*)_obj)->moveCursor((QTextCursor::MoveOperation)operation, (QTextCursor::MoveMode)mode);
}

int qteQPlainTextEdit_canPaste(void* _obj) {
    return ((QPlainTextEdit*)_obj)->canPaste() ? 1 : 0;
}

void qteQPlainTextEdit_print(void* _obj, void* printer) {
    ((QPlainTextEdit*)_obj)->print((QPagedPaintDevice*)printer);
}

int qteQPlainTextEdit_blockCount(void* _obj) {
    return ((QPlainTextEdit*)_obj)->blockCount();
}

void qteQPlainTextEdit_setPlainText(void* _obj, void* text) {
    ((QPlainTextEdit*)_obj)->setPlainText(*(QString*)text);
}

void qteQPlainTextEdit_cut(void* _obj) {
    ((QPlainTextEdit*)_obj)->cut();
}

void qteQPlainTextEdit_copy(void* _obj) {
    ((QPlainTextEdit*)_obj)->copy();
}

void qteQPlainTextEdit_paste(void* _obj) {
    ((QPlainTextEdit*)_obj)->paste();
}

void qteQPlainTextEdit_undo(void* _obj) {
    ((QPlainTextEdit*)_obj)->undo();
}

void qteQPlainTextEdit_redo(void* _obj) {
    ((QPlainTextEdit*)_obj)->redo();
}

void qteQPlainTextEdit_clear(void* _obj) {
    ((QPlainTextEdit*)_obj)->clear();
}

void qteQPlainTextEdit_selectAll(void* _obj) {
    ((QPlainTextEdit*)_obj)->selectAll();
}

void qteQPlainTextEdit_insertPlainText(void* _obj, void* text) {
    ((QPlainTextEdit*)_obj)->insertPlainText(*(QString*)text);
}

void qteQPlainTextEdit_appendPlainText(void* _obj, void* text) {
    ((QPlainTextEdit*)_obj)->appendPlainText(*(QString*)text);
}

void qteQPlainTextEdit_appendHtml(void* _obj, void* html) {
    ((QPlainTextEdit*)_obj)->appendHtml(*(QString*)html);
}

void qteQPlainTextEdit_centerCursor(void* _obj) {
    ((QPlainTextEdit*)_obj)->centerCursor();
}

void qteQPlainTextEdit_zoomIn(void* _obj, int range) {
    ((QPlainTextEdit*)_obj)->zoomIn(range);
}

void qteQPlainTextEdit_zoomOut(void* _obj, int range) {
    ((QPlainTextEdit*)_obj)->zoomOut(range);
}

// ── TextCursor ───────────────────────────────────────────────────────────────
void* qteQPlainTextEdit_textCursor(void* _obj) {
    return new QTextCursor(((QPlainTextEdit*)_obj)->textCursor());
}

void qteQPlainTextEdit_setTextCursor(void* _obj, void* cursor) {
    ((QPlainTextEdit*)_obj)->setTextCursor(*(QTextCursor*)cursor);
}

// ── Protected viewport / scroll API (через subclass eQPlainTextEdit) ─────────
// setViewportMargins/viewportMargins/scrollContentsBy в Qt 5 объявлены как
// protected. Для использования в C-API повышаем видимость через `using` в
// eQPlainTextEdit и castим объект к нему. На рантайме это безопасно: все
// QPlainTextEdit, созданные через qteQPlainTextEdit_create*, на самом деле
// являются экземплярами eQPlainTextEdit.

void qteQPlainTextEdit_setViewportMargins(
    void* _obj, int left, int top, int right, int bottom) {
    ((eQPlainTextEdit*)_obj)->setViewportMargins(left, top, right, bottom);
}

void qteQPlainTextEdit_getViewportMargins(
    void* _obj, int* left, int* top, int* right, int* bottom) {
    QMargins m = ((eQPlainTextEdit*)_obj)->viewportMargins();
    if (left)   *left   = m.left();
    if (top)    *top    = m.top();
    if (right)  *right  = m.right();
    if (bottom) *bottom = m.bottom();
}

void qteQPlainTextEdit_scrollContentsBy(void* _obj, int dx, int dy) {
    ((eQPlainTextEdit*)_obj)->scrollContentsBy(dx, dy);
}

// ── Public API для line-number area ──────────────────────────────────────────

void* qteQPlainTextEdit_firstVisibleBlock(void* _obj) {
    QTextBlock b = ((eQPlainTextEdit*)_obj)->firstVisibleBlock();
    return new QTextBlock(b);   // heap copy — D-сторона должна освободить
}

// Возвращает y-координату блока в координатах viewport + его высоту.
// Применяется для расчёта позиции номера строки в line-number area.
void qteQPlainTextEdit_blockBoundingGeometry(
    void* _obj, int blockNumber, int* y, int* height)
{
    eQPlainTextEdit* edit = (eQPlainTextEdit*)_obj;
    QTextBlock b = edit->document()->findBlockByNumber(blockNumber);
    QRectF r = edit->blockBoundingGeometry(b).translated(edit->contentOffset());
    if (y)      *y      = (int)r.top();
    if (height) *height = (int)r.height();
}

// Смещение содержимого относительно viewport (нужно при программной отрисовке).
void qteQPlainTextEdit_contentOffset(void* _obj, int* x, int* y) {
    QPointF p = ((eQPlainTextEdit*)_obj)->contentOffset();
    if (x) *x = (int)p.x();
    if (y) *y = (int)p.y();
}

// Сигнал updateRequest(QRect rect, int dy) — Qt вызывает когда часть viewport
// должна быть перерисована (скролл, изменения текста). Подключаем через ESlot
// invoke_v (D-сторона просто триггерит lineNumberArea.update()).
#include "../qte56_qcore/eslot.h"
void qteQPlainTextEdit_connect_updateRequest(void* _obj, void* eslot) {
    eSlot* sl = (eSlot*)eslot;
    QObject::connect(
        (QPlainTextEdit*)_obj,
        QOverload<const QRect&, int>::of(&QPlainTextEdit::updateRequest),
        sl,
        [sl](const QRect&, int) { sl->invoke_v(); });
}

// ── Event handler ────────────────────────────────────────────────────────────
void qteQPlainTextEdit_setEventHandler(void* w, int id, void* cb, void* dthis) {
    eQPlainTextEdit* obj = (eQPlainTextEdit*)w;
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
        case 25: obj->cb_25 = cb; obj->dt_25 = dthis; break;       // keyRelease Full
        default: break;
    }
}

} // extern "C"
