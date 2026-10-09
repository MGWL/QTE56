#ifndef QTE56_QWIDGET_BUILD
#define QTE56_QWIDGET_BUILD
#endif
#include "qte56_qwidget.h"
#include "../qte56_qcore/eslot.h"   // WheelEventInfo / MouseEventInfo / KeyEventInfo
#include <QWidget>
#include <QByteArray>
#include <cstdint>
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
class eQWidget : public QWidget {
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
    void* cb_18 = nullptr;  void* dt_18 = nullptr;  // 18: paintEvent
    // ── Расширенные Full-callback'и (id 19..25) — см. eslot.h ───────────────
    void* cb_19 = nullptr;  void* dt_19 = nullptr;  // 19: wheel  Full
    void* cb_20 = nullptr;  void* dt_20 = nullptr;  // 20: mousePress      Full
    void* cb_21 = nullptr;  void* dt_21 = nullptr;  // 21: mouseRelease    Full
    void* cb_22 = nullptr;  void* dt_22 = nullptr;  // 22: mouseMove       Full
    void* cb_23 = nullptr;  void* dt_23 = nullptr;  // 23: mouseDoubleClick Full
    void* cb_24 = nullptr;  void* dt_24 = nullptr;  // 24: keyPress   Full
    void* cb_25 = nullptr;  void* dt_25 = nullptr;  // 25: keyRelease Full

    explicit eQWidget(QWidget* parent = nullptr) : QWidget(parent) {}

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
        else QWidget::mousePressEvent(e);
    }
    void mouseReleaseEvent(QMouseEvent* e) override {
        if (cb_21) {
            MouseEventInfo info; fillMouse(&info, e);
            int consumed = ((int(*)(void*, MouseEventInfo*))cb_21)(dt_21, &info);
            if (consumed) return;
        }
        if (cb_02) ((void(*)(void*,int,int,int))cb_02)(dt_02, e->x(), e->y(), (int)e->button());
        else QWidget::mouseReleaseEvent(e);
    }
    void mouseDoubleClickEvent(QMouseEvent* e) override {
        if (cb_23) {
            MouseEventInfo info; fillMouse(&info, e);
            int consumed = ((int(*)(void*, MouseEventInfo*))cb_23)(dt_23, &info);
            if (consumed) return;
        }
        if (cb_03) ((void(*)(void*,int,int,int))cb_03)(dt_03, e->x(), e->y(), (int)e->button());
        else QWidget::mouseDoubleClickEvent(e);
    }
    void mouseMoveEvent(QMouseEvent* e) override {
        if (cb_22) {
            MouseEventInfo info; fillMouse(&info, e);
            int consumed = ((int(*)(void*, MouseEventInfo*))cb_22)(dt_22, &info);
            if (consumed) return;
        }
        if (cb_04) ((void(*)(void*,int,int))cb_04)(dt_04, e->x(), e->y());
        else QWidget::mouseMoveEvent(e);
    }
    void keyPressEvent(QKeyEvent* e) override {
        if (cb_24) {
            KeyEventInfo info; QString tb; fillKey(&info, e, &tb);
            int consumed = ((int(*)(void*, KeyEventInfo*))cb_24)(dt_24, &info);
            if (consumed) return;
        }
        if (cb_05) ((void(*)(void*,int,int))cb_05)(dt_05, (int)e->key(), (int)e->modifiers());
        else QWidget::keyPressEvent(e);
    }
    void keyReleaseEvent(QKeyEvent* e) override {
        if (cb_25) {
            KeyEventInfo info; QString tb; fillKey(&info, e, &tb);
            int consumed = ((int(*)(void*, KeyEventInfo*))cb_25)(dt_25, &info);
            if (consumed) return;
        }
        if (cb_06) ((void(*)(void*,int,int))cb_06)(dt_06, (int)e->key(), (int)e->modifiers());
        else QWidget::keyReleaseEvent(e);
    }
    void resizeEvent(QResizeEvent* e) override {
        if (cb_07) ((void(*)(void*,int,int))cb_07)(dt_07, e->size().width(), e->size().height());
        else QWidget::resizeEvent(e);
    }
    void moveEvent(QMoveEvent* e) override {
        if (cb_08) ((void(*)(void*,int,int))cb_08)(dt_08, e->pos().x(), e->pos().y());
        else QWidget::moveEvent(e);
    }
    void closeEvent(QCloseEvent* e) override {
        if (cb_09) {
            int accept = 1;
            ((void(*)(void*,int*))cb_09)(dt_09, &accept);
            if (!accept) e->ignore();
        } else {
            QWidget::closeEvent(e);
        }
    }
    void showEvent(QShowEvent* e) override {
        if (cb_10) ((void(*)(void*))cb_10)(dt_10);
        else QWidget::showEvent(e);
    }
    void hideEvent(QHideEvent* e) override {
        if (cb_11) ((void(*)(void*))cb_11)(dt_11);
        else QWidget::hideEvent(e);
    }
    void enterEvent(QEnterEvent* e) override {
        if (cb_12) ((void(*)(void*))cb_12)(dt_12);
        else QWidget::enterEvent(e);
    }
    void leaveEvent(QEvent* e) override {
        if (cb_13) ((void(*)(void*))cb_13)(dt_13);
        else QWidget::leaveEvent(e);
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
        else QWidget::wheelEvent(e);
    }
    void focusInEvent(QFocusEvent* e) override {
        if (cb_15) ((void(*)(void*,int))cb_15)(dt_15, (int)e->reason());
        else QWidget::focusInEvent(e);
    }
    void focusOutEvent(QFocusEvent* e) override {
        if (cb_16) ((void(*)(void*,int))cb_16)(dt_16, (int)e->reason());
        else QWidget::focusOutEvent(e);
    }
    void contextMenuEvent(QContextMenuEvent* e) override {
        if (cb_17) ((void(*)(void*,int,int,int))cb_17)(dt_17, e->x(), e->y(), (int)e->reason());
        else QWidget::contextMenuEvent(e);
    }
    void paintEvent(QPaintEvent* e) override {
        if (cb_18) ((void(*)(void*, void*))cb_18)(dt_18, static_cast<QPaintDevice*>(this));
        else QWidget::paintEvent(e);
    }
};

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQWidget_create(void* parent) {
    return new eQWidget((QWidget*)parent);
}

void qteQWidget_delete(void* w) {
    delete (eQWidget*)w;
}

// ── Methods ──────────────────────────────────────────────────────────────
int qteQWidget_devType(void* _obj) {
    return ((QWidget*)_obj)->devType();
}

intptr_t qteQWidget_winId(void* _obj) {
    return (intptr_t)((QWidget*)_obj)->winId();
}

void qteQWidget_createWinId(void* _obj) {
    ((QWidget*)_obj)->createWinId();
}

intptr_t qteQWidget_effectiveWinId(void* _obj) {
    return (intptr_t)((QWidget*)_obj)->effectiveWinId();
}

void qteQWidget_setStyle(void* _obj, void* p0) {
    ((QWidget*)_obj)->setStyle((QStyle*)p0);
}

int qteQWidget_isTopLevel(void* _obj) {
    return ((QWidget*)_obj)->isWindow() ? 1 : 0;
}

int qteQWidget_isWindow(void* _obj) {
    return ((QWidget*)_obj)->isWindow() ? 1 : 0;
}

int qteQWidget_isModal(void* _obj) {
    return ((QWidget*)_obj)->isModal() ? 1 : 0;
}

int qteQWidget_windowModality(void* _obj) {
    return ((QWidget*)_obj)->windowModality();
}

void qteQWidget_setWindowModality(void* _obj, int windowModality) {
    ((QWidget*)_obj)->setWindowModality((Qt::WindowModality)windowModality);
}

int qteQWidget_isEnabled(void* _obj) {
    return ((QWidget*)_obj)->isEnabled() ? 1 : 0;
}

int qteQWidget_isEnabledTo(void* _obj, void* p0) {
    return ((QWidget*)_obj)->isEnabledTo((const QWidget*)p0) ? 1 : 0;
}

int qteQWidget_isEnabledToTLW(void* _obj) {
    // isEnabledToTLW() renamed to isEnabledTo() in Qt6
    return ((QWidget*)_obj)->isEnabledTo(nullptr) ? 1 : 0;
}

void qteQWidget_setEnabled(void* _obj, int p0) {
    ((QWidget*)_obj)->setEnabled((p0 != 0));
}

void qteQWidget_setDisabled(void* _obj, int p0) {
    ((QWidget*)_obj)->setDisabled((p0 != 0));
}

void qteQWidget_setWindowModified(void* _obj, int p0) {
    ((QWidget*)_obj)->setWindowModified((p0 != 0));
}

void* qteQWidget_frameGeometry(void* _obj) {
    return new QRect(((QWidget*)_obj)->frameGeometry());
}

void* qteQWidget_normalGeometry(void* _obj) {
    return new QRect(((QWidget*)_obj)->normalGeometry());
}

int qteQWidget_x(void* _obj) {
    return ((QWidget*)_obj)->x();
}

int qteQWidget_y(void* _obj) {
    return ((QWidget*)_obj)->y();
}

void* qteQWidget_pos(void* _obj) {
    return new QPoint(((QWidget*)_obj)->pos());
}

void* qteQWidget_frameSize(void* _obj) {
    return new QSize(((QWidget*)_obj)->frameSize());
}

void* qteQWidget_size(void* _obj) {
    return new QSize(((QWidget*)_obj)->size());
}

int qteQWidget_width(void* _obj) {
    return ((QWidget*)_obj)->width();
}

int qteQWidget_height(void* _obj) {
    return ((QWidget*)_obj)->height();
}

void* qteQWidget_rect(void* _obj) {
    return new QRect(((QWidget*)_obj)->rect());
}

void* qteQWidget_childrenRect(void* _obj) {
    return new QRect(((QWidget*)_obj)->childrenRect());
}

void* qteQWidget_minimumSize(void* _obj) {
    return new QSize(((QWidget*)_obj)->minimumSize());
}

void* qteQWidget_maximumSize(void* _obj) {
    return new QSize(((QWidget*)_obj)->maximumSize());
}

int qteQWidget_minimumWidth(void* _obj) {
    return ((QWidget*)_obj)->minimumWidth();
}

int qteQWidget_minimumHeight(void* _obj) {
    return ((QWidget*)_obj)->minimumHeight();
}

int qteQWidget_maximumWidth(void* _obj) {
    return ((QWidget*)_obj)->maximumWidth();
}

int qteQWidget_maximumHeight(void* _obj) {
    return ((QWidget*)_obj)->maximumHeight();
}

void qteQWidget_setMinimumSize_p(void* _obj, void* p0) {
    ((QWidget*)_obj)->setMinimumSize(*(const QSize*)p0);
}

void qteQWidget_setMinimumSize_ii(void* _obj, int minw, int minh) {
    ((QWidget*)_obj)->setMinimumSize(minw, minh);
}

void qteQWidget_setMaximumSize_p(void* _obj, void* p0) {
    ((QWidget*)_obj)->setMaximumSize(*(const QSize*)p0);
}

void qteQWidget_setMaximumSize_ii(void* _obj, int maxw, int maxh) {
    ((QWidget*)_obj)->setMaximumSize(maxw, maxh);
}

void qteQWidget_setMinimumWidth(void* _obj, int minw) {
    ((QWidget*)_obj)->setMinimumWidth(minw);
}

void qteQWidget_setMinimumHeight(void* _obj, int minh) {
    ((QWidget*)_obj)->setMinimumHeight(minh);
}

void qteQWidget_setMaximumWidth(void* _obj, int maxw) {
    ((QWidget*)_obj)->setMaximumWidth(maxw);
}

void qteQWidget_setMaximumHeight(void* _obj, int maxh) {
    ((QWidget*)_obj)->setMaximumHeight(maxh);
}

void* qteQWidget_sizeIncrement(void* _obj) {
    return new QSize(((QWidget*)_obj)->sizeIncrement());
}

void qteQWidget_setSizeIncrement_p(void* _obj, void* p0) {
    ((QWidget*)_obj)->setSizeIncrement(*(const QSize*)p0);
}

void qteQWidget_setSizeIncrement_ii(void* _obj, int w, int h) {
    ((QWidget*)_obj)->setSizeIncrement(w, h);
}

void* qteQWidget_baseSize(void* _obj) {
    return new QSize(((QWidget*)_obj)->baseSize());
}

void qteQWidget_setBaseSize_p(void* _obj, void* p0) {
    ((QWidget*)_obj)->setBaseSize(*(const QSize*)p0);
}

void qteQWidget_setBaseSize_ii(void* _obj, int basew, int baseh) {
    ((QWidget*)_obj)->setBaseSize(basew, baseh);
}

void qteQWidget_setFixedSize_p(void* _obj, void* p0) {
    ((QWidget*)_obj)->setFixedSize(*(const QSize*)p0);
}

void qteQWidget_setFixedSize_ii(void* _obj, int w, int h) {
    ((QWidget*)_obj)->setFixedSize(w, h);
}

void qteQWidget_setFixedWidth(void* _obj, int w) {
    ((QWidget*)_obj)->setFixedWidth(w);
}

void qteQWidget_setFixedHeight(void* _obj, int h) {
    ((QWidget*)_obj)->setFixedHeight(h);
}

void* qteQWidget_mapToGlobal(void* _obj, void* p0) {
    return new QPoint(((QWidget*)_obj)->mapToGlobal(*(const QPoint*)p0));
}

void* qteQWidget_mapFromGlobal(void* _obj, void* p0) {
    return new QPoint(((QWidget*)_obj)->mapFromGlobal(*(const QPoint*)p0));
}

void* qteQWidget_mapToParent(void* _obj, void* p0) {
    return new QPoint(((QWidget*)_obj)->mapToParent(*(const QPoint*)p0));
}

void* qteQWidget_mapFromParent(void* _obj, void* p0) {
    return new QPoint(((QWidget*)_obj)->mapFromParent(*(const QPoint*)p0));
}

void* qteQWidget_mapTo(void* _obj, void* p0, void* p1) {
    return new QPoint(((QWidget*)_obj)->mapTo((const QWidget*)p0, *(const QPoint*)p1));
}

void* qteQWidget_mapFrom(void* _obj, void* p0, void* p1) {
    return new QPoint(((QWidget*)_obj)->mapFrom((const QWidget*)p0, *(const QPoint*)p1));
}

void qteQWidget_setBackgroundRole(void* _obj, int p0) {
    ((QWidget*)_obj)->setBackgroundRole((QPalette::ColorRole)p0);
}

int qteQWidget_backgroundRole(void* _obj) {
    return ((QWidget*)_obj)->backgroundRole();
}

void qteQWidget_setForegroundRole(void* _obj, int p0) {
    ((QWidget*)_obj)->setForegroundRole((QPalette::ColorRole)p0);
}

int qteQWidget_foregroundRole(void* _obj) {
    return ((QWidget*)_obj)->foregroundRole();
}

void qteQWidget_unsetCursor(void* _obj) {
    ((QWidget*)_obj)->unsetCursor();
}

void qteQWidget_setMouseTracking(void* _obj, int enable) {
    ((QWidget*)_obj)->setMouseTracking((enable != 0));
}

int qteQWidget_hasMouseTracking(void* _obj) {
    return ((QWidget*)_obj)->hasMouseTracking() ? 1 : 0;
}

int qteQWidget_underMouse(void* _obj) {
    return ((QWidget*)_obj)->underMouse() ? 1 : 0;
}

void qteQWidget_setTabletTracking(void* _obj, int enable) {
    ((QWidget*)_obj)->setTabletTracking((enable != 0));
}

int qteQWidget_hasTabletTracking(void* _obj) {
    return ((QWidget*)_obj)->hasTabletTracking() ? 1 : 0;
}

void qteQWidget_clearMask(void* _obj) {
    ((QWidget*)_obj)->clearMask();
}

void qteQWidget_setGraphicsEffect(void* _obj, void* effect) {
    ((QWidget*)_obj)->setGraphicsEffect((QGraphicsEffect*)effect);
}

void qteQWidget_ungrabGesture(void* _obj, int type) {
    ((QWidget*)_obj)->ungrabGesture((Qt::GestureType)type);
}

void qteQWidget_setWindowTitle(void* _obj, void* p0) {
    ((QWidget*)_obj)->setWindowTitle(*(QString*)p0);
}

void qteQWidget_setStyleSheet(void* _obj, void* styleSheet) {
    ((QWidget*)_obj)->setStyleSheet(*(QString*)styleSheet);
}

void* qteQWidget_styleSheet(void* _obj) {
    return new QString(((QWidget*)_obj)->styleSheet());
}

void* qteQWidget_windowTitle(void* _obj) {
    return new QString(((QWidget*)_obj)->windowTitle());
}

void qteQWidget_setWindowIconText(void* _obj, void* p0) {
    ((QWidget*)_obj)->setWindowIconText(*(QString*)p0);
}

void* qteQWidget_windowIconText(void* _obj) {
    return new QString(((QWidget*)_obj)->windowIconText());
}

void qteQWidget_setWindowRole(void* _obj, void* p0) {
    ((QWidget*)_obj)->setWindowRole(*(QString*)p0);
}

void* qteQWidget_windowRole(void* _obj) {
    return new QString(((QWidget*)_obj)->windowRole());
}

void qteQWidget_setWindowFilePath(void* _obj, void* filePath) {
    ((QWidget*)_obj)->setWindowFilePath(*(QString*)filePath);
}

void* qteQWidget_windowFilePath(void* _obj) {
    return new QString(((QWidget*)_obj)->windowFilePath());
}

void qteQWidget_setWindowOpacity(void* _obj, double level) {
    ((QWidget*)_obj)->setWindowOpacity(level);
}

double qteQWidget_windowOpacity(void* _obj) {
    return ((QWidget*)_obj)->windowOpacity();
}

int qteQWidget_isWindowModified(void* _obj) {
    return ((QWidget*)_obj)->isWindowModified() ? 1 : 0;
}

void qteQWidget_setToolTip(void* _obj, void* p0) {
    ((QWidget*)_obj)->setToolTip(*(QString*)p0);
}

void* qteQWidget_toolTip(void* _obj) {
    return new QString(((QWidget*)_obj)->toolTip());
}

void qteQWidget_setToolTipDuration(void* _obj, int msec) {
    ((QWidget*)_obj)->setToolTipDuration(msec);
}

int qteQWidget_toolTipDuration(void* _obj) {
    return ((QWidget*)_obj)->toolTipDuration();
}

void qteQWidget_setStatusTip(void* _obj, void* p0) {
    ((QWidget*)_obj)->setStatusTip(*(QString*)p0);
}

void* qteQWidget_statusTip(void* _obj) {
    return new QString(((QWidget*)_obj)->statusTip());
}

void qteQWidget_setWhatsThis(void* _obj, void* p0) {
    ((QWidget*)_obj)->setWhatsThis(*(QString*)p0);
}

void* qteQWidget_whatsThis(void* _obj) {
    return new QString(((QWidget*)_obj)->whatsThis());
}

void* qteQWidget_accessibleName(void* _obj) {
    return new QString(((QWidget*)_obj)->accessibleName());
}

void qteQWidget_setAccessibleName(void* _obj, void* name) {
    ((QWidget*)_obj)->setAccessibleName(*(QString*)name);
}

void* qteQWidget_accessibleDescription(void* _obj) {
    return new QString(((QWidget*)_obj)->accessibleDescription());
}

void qteQWidget_setAccessibleDescription(void* _obj, void* description) {
    ((QWidget*)_obj)->setAccessibleDescription(*(QString*)description);
}

void qteQWidget_setLayoutDirection(void* _obj, int direction) {
    ((QWidget*)_obj)->setLayoutDirection((Qt::LayoutDirection)direction);
}

int qteQWidget_layoutDirection(void* _obj) {
    return ((QWidget*)_obj)->layoutDirection();
}

void qteQWidget_unsetLayoutDirection(void* _obj) {
    ((QWidget*)_obj)->unsetLayoutDirection();
}

void qteQWidget_unsetLocale(void* _obj) {
    ((QWidget*)_obj)->unsetLocale();
}

int qteQWidget_isActiveWindow(void* _obj) {
    return ((QWidget*)_obj)->isActiveWindow() ? 1 : 0;
}

void qteQWidget_activateWindow(void* _obj) {
    ((QWidget*)_obj)->activateWindow();
}

void qteQWidget_clearFocus(void* _obj) {
    ((QWidget*)_obj)->clearFocus();
}

void qteQWidget_setFocus(void* _obj, int reason) {
    ((QWidget*)_obj)->setFocus((Qt::FocusReason)reason);
}

int qteQWidget_focusPolicy(void* _obj) {
    return ((QWidget*)_obj)->focusPolicy();
}

void qteQWidget_setFocusPolicy(void* _obj, int policy) {
    ((QWidget*)_obj)->setFocusPolicy((Qt::FocusPolicy)policy);
}

int qteQWidget_hasFocus(void* _obj) {
    return ((QWidget*)_obj)->hasFocus() ? 1 : 0;
}

void qteQWidget_setTabOrder(void* _obj, void* p0, void* p1) {
    ((QWidget*)_obj)->setTabOrder((QWidget*)p0, (QWidget*)p1);
}

void qteQWidget_setFocusProxy(void* _obj, void* p0) {
    ((QWidget*)_obj)->setFocusProxy((QWidget*)p0);
}

int qteQWidget_contextMenuPolicy(void* _obj) {
    return ((QWidget*)_obj)->contextMenuPolicy();
}

void qteQWidget_setContextMenuPolicy(void* _obj, int policy) {
    ((QWidget*)_obj)->setContextMenuPolicy((Qt::ContextMenuPolicy)policy);
}

void qteQWidget_grabMouse(void* _obj) {
    ((QWidget*)_obj)->grabMouse();
}

void qteQWidget_releaseMouse(void* _obj) {
    ((QWidget*)_obj)->releaseMouse();
}

void qteQWidget_grabKeyboard(void* _obj) {
    ((QWidget*)_obj)->grabKeyboard();
}

void qteQWidget_releaseKeyboard(void* _obj) {
    ((QWidget*)_obj)->releaseKeyboard();
}

void qteQWidget_releaseShortcut(void* _obj, int id) {
    ((QWidget*)_obj)->releaseShortcut(id);
}

void qteQWidget_setShortcutEnabled(void* _obj, int id, int enable) {
    ((QWidget*)_obj)->setShortcutEnabled(id, (enable != 0));
}

void qteQWidget_setShortcutAutoRepeat(void* _obj, int id, int enable) {
    ((QWidget*)_obj)->setShortcutAutoRepeat(id, (enable != 0));
}

int qteQWidget_updatesEnabled(void* _obj) {
    return ((QWidget*)_obj)->updatesEnabled() ? 1 : 0;
}

void qteQWidget_setUpdatesEnabled(void* _obj, int enable) {
    ((QWidget*)_obj)->setUpdatesEnabled((enable != 0));
}

void qteQWidget_update_v(void* _obj) {
    ((QWidget*)_obj)->update();
}

void qteQWidget_repaint_v(void* _obj) {
    ((QWidget*)_obj)->repaint();
}

void qteQWidget_update_iiii(void* _obj, int x, int y, int w, int h) {
    ((QWidget*)_obj)->update(x, y, w, h);
}

void qteQWidget_repaint_iiii(void* _obj, int x, int y, int w, int h) {
    ((QWidget*)_obj)->repaint(x, y, w, h);
}

void qteQWidget_repaint_p(void* _obj, void* p0) {
    ((QWidget*)_obj)->repaint(*(const QRect*)p0);
}

void qteQWidget_setVisible(void* _obj, int visible) {
    ((QWidget*)_obj)->setVisible((visible != 0));
}

void qteQWidget_setHidden(void* _obj, int hidden) {
    ((QWidget*)_obj)->setHidden((hidden != 0));
}

void qteQWidget_show(void* _obj) {
    ((QWidget*)_obj)->show();
}

void qteQWidget_hide(void* _obj) {
    ((QWidget*)_obj)->hide();
}

void qteQWidget_showMinimized(void* _obj) {
    ((QWidget*)_obj)->showMinimized();
}

void qteQWidget_showMaximized(void* _obj) {
    ((QWidget*)_obj)->showMaximized();
}

void qteQWidget_showFullScreen(void* _obj) {
    ((QWidget*)_obj)->showFullScreen();
}

void qteQWidget_showNormal(void* _obj) {
    ((QWidget*)_obj)->showNormal();
}

int qteQWidget_close(void* _obj) {
    return ((QWidget*)_obj)->close() ? 1 : 0;
}

void qteQWidget_raise(void* _obj) {
    ((QWidget*)_obj)->raise();
}

void qteQWidget_lower(void* _obj) {
    ((QWidget*)_obj)->lower();
}

void qteQWidget_stackUnder(void* _obj, void* p0) {
    ((QWidget*)_obj)->stackUnder((QWidget*)p0);
}

void qteQWidget_move_ii(void* _obj, int x, int y) {
    ((QWidget*)_obj)->move(x, y);
}

void qteQWidget_move_p(void* _obj, void* p0) {
    ((QWidget*)_obj)->move(*(const QPoint*)p0);
}

void qteQWidget_resize_ii(void* _obj, int w, int h) {
    ((QWidget*)_obj)->resize(w, h);
}

void qteQWidget_resize_p(void* _obj, void* p0) {
    ((QWidget*)_obj)->resize(*(const QSize*)p0);
}

void qteQWidget_setGeometry_iiii(void* _obj, int x, int y, int w, int h) {
    ((QWidget*)_obj)->setGeometry(x, y, w, h);
}

void qteQWidget_setGeometry_p(void* _obj, void* p0) {
    ((QWidget*)_obj)->setGeometry(*(const QRect*)p0);
}

void qteQWidget_adjustSize(void* _obj) {
    ((QWidget*)_obj)->adjustSize();
}

int qteQWidget_isVisible(void* _obj) {
    return ((QWidget*)_obj)->isVisible() ? 1 : 0;
}

int qteQWidget_isVisibleTo(void* _obj, void* p0) {
    return ((QWidget*)_obj)->isVisibleTo((const QWidget*)p0) ? 1 : 0;
}

int qteQWidget_isHidden(void* _obj) {
    return ((QWidget*)_obj)->isHidden() ? 1 : 0;
}

int qteQWidget_isMinimized(void* _obj) {
    return ((QWidget*)_obj)->isMinimized() ? 1 : 0;
}

int qteQWidget_isMaximized(void* _obj) {
    return ((QWidget*)_obj)->isMaximized() ? 1 : 0;
}

int qteQWidget_isFullScreen(void* _obj) {
    return ((QWidget*)_obj)->isFullScreen() ? 1 : 0;
}

int qteQWidget_windowState(void* _obj) {
    return ((QWidget*)_obj)->windowState();
}

void qteQWidget_setWindowState(void* _obj, int state) {
    ((QWidget*)_obj)->setWindowState((Qt::WindowStates)state);
}

void qteQWidget_overrideWindowState(void* _obj, int state) {
    ((QWidget*)_obj)->overrideWindowState((Qt::WindowStates)state);
}

void* qteQWidget_sizeHint(void* _obj) {
    return new QSize(((QWidget*)_obj)->sizeHint());
}

void* qteQWidget_minimumSizeHint(void* _obj) {
    return new QSize(((QWidget*)_obj)->minimumSizeHint());
}

void qteQWidget_setSizePolicy(void* _obj, int horizontal, int vertical) {
    ((QWidget*)_obj)->setSizePolicy((QSizePolicy::Policy)horizontal, (QSizePolicy::Policy)vertical);
}

int qteQWidget_heightForWidth(void* _obj, int p0) {
    return ((QWidget*)_obj)->heightForWidth(p0);
}

int qteQWidget_hasHeightForWidth(void* _obj) {
    return ((QWidget*)_obj)->hasHeightForWidth() ? 1 : 0;
}

void qteQWidget_setContentsMargins(void* _obj, int left, int top, int right, int bottom) {
    ((QWidget*)_obj)->setContentsMargins(left, top, right, bottom);
}

void qteQWidget_getContentsMargins(void* _obj, void* left, void* top, void* right, void* bottom) {
    // getContentsMargins() replaced by contentsMargins() in Qt6
    QMargins m = ((QWidget*)_obj)->contentsMargins();
    *(int*)left = m.left();
    *(int*)top = m.top();
    *(int*)right = m.right();
    *(int*)bottom = m.bottom();
}

void* qteQWidget_contentsRect(void* _obj) {
    return new QRect(((QWidget*)_obj)->contentsRect());
}

void qteQWidget_setLayout(void* _obj, void* p0) {
    ((QWidget*)_obj)->setLayout((QLayout*)p0);
}

void qteQWidget_updateGeometry(void* _obj) {
    ((QWidget*)_obj)->updateGeometry();
}

void qteQWidget_setParent_w(void* _obj, void* parent) {
    ((QWidget*)_obj)->setParent((QWidget*)parent);
}

void qteQWidget_setParent_wp(void* _obj, void* parent, int f) {
    ((QWidget*)_obj)->setParent((QWidget*)parent, (Qt::WindowFlags)f);
}

void qteQWidget_scroll(void* _obj, int dx, int dy) {
    ((QWidget*)_obj)->scroll(dx, dy);
}

int qteQWidget_acceptDrops(void* _obj) {
    return ((QWidget*)_obj)->acceptDrops() ? 1 : 0;
}

void qteQWidget_setAcceptDrops(void* _obj, int on) {
    ((QWidget*)_obj)->setAcceptDrops((on != 0));
}

void qteQWidget_addAction(void* _obj, void* action) {
    ((QWidget*)_obj)->addAction((QAction*)action);
}

void qteQWidget_insertAction(void* _obj, void* before, void* action) {
    ((QWidget*)_obj)->insertAction((QAction*)before, (QAction*)action);
}

void qteQWidget_removeAction(void* _obj, void* action) {
    ((QWidget*)_obj)->removeAction((QAction*)action);
}

void qteQWidget_setWindowFlags(void* _obj, int type) {
    ((QWidget*)_obj)->setWindowFlags((Qt::WindowFlags)type);
}

int qteQWidget_windowFlags(void* _obj) {
    return ((QWidget*)_obj)->windowFlags();
}

void qteQWidget_setWindowFlag(void* _obj, int p0, int on) {
    ((QWidget*)_obj)->setWindowFlag((Qt::WindowType)p0, (on != 0));
}

void qteQWidget_overrideWindowFlags(void* _obj, int type) {
    ((QWidget*)_obj)->overrideWindowFlags((Qt::WindowFlags)type);
}

int qteQWidget_windowType(void* _obj) {
    return ((QWidget*)_obj)->windowType();
}

void qteQWidget_setAttribute(void* _obj, int p0, int on) {
    ((QWidget*)_obj)->setAttribute((Qt::WidgetAttribute)p0, (on != 0));
}

int qteQWidget_testAttribute(void* _obj, int p0) {
    return ((QWidget*)_obj)->testAttribute((Qt::WidgetAttribute)p0) ? 1 : 0;
}

void qteQWidget_ensurePolished(void* _obj) {
    ((QWidget*)_obj)->ensurePolished();
}

int qteQWidget_isAncestorOf(void* _obj, void* child) {
    return ((QWidget*)_obj)->isAncestorOf((const QWidget*)child) ? 1 : 0;
}

int qteQWidget_autoFillBackground(void* _obj) {
    return ((QWidget*)_obj)->autoFillBackground() ? 1 : 0;
}

void qteQWidget_setAutoFillBackground(void* _obj, int enabled) {
    ((QWidget*)_obj)->setAutoFillBackground((enabled != 0));
}

int qteQWidget_inputMethodHints(void* _obj) {
    return ((QWidget*)_obj)->inputMethodHints();
}

void qteQWidget_setInputMethodHints(void* _obj, int hints) {
    ((QWidget*)_obj)->setInputMethodHints((Qt::InputMethodHints)hints);
}

// ── Event handler ────────────────────────────────────────────────────────────
void qteQWidget_setEventHandler(void* w, int id, void* cb, void* dthis) {
    eQWidget* obj = (eQWidget*)w;
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
        case 18: obj->cb_18 = cb; obj->dt_18 = dthis; break;  // paintEvent
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


// ── Geometry persistence ──────────────────────────────────────────────────────

void* qteQWidget_saveGeometry(void* w) {
    return new QByteArray(((QWidget*)w)->saveGeometry());
}

int qteQWidget_restoreGeometry(void* w, const void* data, int len) {
    QByteArray ba((const char*)data, len);
    return ((QWidget*)w)->restoreGeometry(ba) ? 1 : 0;
}

} // extern "C"
