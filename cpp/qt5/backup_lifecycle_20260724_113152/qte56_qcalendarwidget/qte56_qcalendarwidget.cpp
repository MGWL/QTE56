#include "qte56_qcalendarwidget.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include <QCalendarWidget>
#include <QDate>
#include <QMouseEvent>
#include <QKeyEvent>
#include <QResizeEvent>
#include <QMoveEvent>
#include <QCloseEvent>
#include <QShowEvent>
#include <QHideEvent>
#include <QWheelEvent>
#include <QFocusEvent>
#include <QContextMenuEvent>

// ─── EventProxy ───────────────────────────────────────────────────────────────
class eQCalendarWidget : public QCalendarWidget {
public:
    void* cb_01 = nullptr; void* dt_01 = nullptr;  // mousePress
    void* cb_02 = nullptr; void* dt_02 = nullptr;  // mouseRelease
    void* cb_03 = nullptr; void* dt_03 = nullptr;  // mouseDoubleClick
    void* cb_04 = nullptr; void* dt_04 = nullptr;  // mouseMove
    void* cb_05 = nullptr; void* dt_05 = nullptr;  // keyPress
    void* cb_06 = nullptr; void* dt_06 = nullptr;  // keyRelease
    void* cb_07 = nullptr; void* dt_07 = nullptr;  // resize
    void* cb_08 = nullptr; void* dt_08 = nullptr;  // move
    void* cb_09 = nullptr; void* dt_09 = nullptr;  // close
    void* cb_10 = nullptr; void* dt_10 = nullptr;  // show
    void* cb_11 = nullptr; void* dt_11 = nullptr;  // hide
    void* cb_12 = nullptr; void* dt_12 = nullptr;  // enter
    void* cb_13 = nullptr; void* dt_13 = nullptr;  // leave
    void* cb_14 = nullptr; void* dt_14 = nullptr;  // wheel
    void* cb_15 = nullptr; void* dt_15 = nullptr;  // focusIn
    void* cb_16 = nullptr; void* dt_16 = nullptr;  // focusOut
    void* cb_17 = nullptr; void* dt_17 = nullptr;  // contextMenu

    explicit eQCalendarWidget(QWidget* parent = nullptr) : QCalendarWidget(parent) {}

protected:
    void mousePressEvent(QMouseEvent* e) override {
        if (cb_01) ((void(*)(void*,int,int,int))cb_01)(dt_01, e->x(), e->y(), (int)e->button());
        else QCalendarWidget::mousePressEvent(e);
    }
    void mouseReleaseEvent(QMouseEvent* e) override {
        if (cb_02) ((void(*)(void*,int,int,int))cb_02)(dt_02, e->x(), e->y(), (int)e->button());
        else QCalendarWidget::mouseReleaseEvent(e);
    }
    void mouseDoubleClickEvent(QMouseEvent* e) override {
        if (cb_03) ((void(*)(void*,int,int,int))cb_03)(dt_03, e->x(), e->y(), (int)e->button());
        else QCalendarWidget::mouseDoubleClickEvent(e);
    }
    void mouseMoveEvent(QMouseEvent* e) override {
        if (cb_04) ((void(*)(void*,int,int,int))cb_04)(dt_04, e->x(), e->y(), (int)e->button());
        else QCalendarWidget::mouseMoveEvent(e);
    }
    void keyPressEvent(QKeyEvent* e) override {
        if (cb_05) ((void(*)(void*,int,int))cb_05)(dt_05, (int)e->key(), (int)e->modifiers());
        else QCalendarWidget::keyPressEvent(e);
    }
    void keyReleaseEvent(QKeyEvent* e) override {
        if (cb_06) ((void(*)(void*,int,int))cb_06)(dt_06, (int)e->key(), (int)e->modifiers());
        else QCalendarWidget::keyReleaseEvent(e);
    }
    void resizeEvent(QResizeEvent* e) override {
        if (cb_07) ((void(*)(void*,int,int))cb_07)(dt_07, e->size().width(), e->size().height());
        QCalendarWidget::resizeEvent(e);
    }
    void moveEvent(QMoveEvent* e) override {
        if (cb_08) ((void(*)(void*,int,int))cb_08)(dt_08, e->pos().x(), e->pos().y());
        QCalendarWidget::moveEvent(e);
    }
    void closeEvent(QCloseEvent* e) override {
        if (cb_09) {
            int a = 1;
            ((void(*)(void*,int*))cb_09)(dt_09, &a);
            if (!a) e->ignore(); else e->accept();
        } else {
            QCalendarWidget::closeEvent(e);
        }
    }
    void showEvent(QShowEvent* e) override {
        if (cb_10) ((void(*)(void*))cb_10)(dt_10);
        QCalendarWidget::showEvent(e);
    }
    void hideEvent(QHideEvent* e) override {
        if (cb_11) ((void(*)(void*))cb_11)(dt_11);
        QCalendarWidget::hideEvent(e);
    }
    void enterEvent(QEvent* e) override {
        if (cb_12) ((void(*)(void*))cb_12)(dt_12);
        QCalendarWidget::enterEvent(e);
    }
    void leaveEvent(QEvent* e) override {
        if (cb_13) ((void(*)(void*))cb_13)(dt_13);
        QCalendarWidget::leaveEvent(e);
    }
    void wheelEvent(QWheelEvent* e) override {
        if (cb_14) ((void(*)(void*,int,int))cb_14)(dt_14, e->delta(), (int)e->modifiers());
        else QCalendarWidget::wheelEvent(e);
    }
    void focusInEvent(QFocusEvent* e) override {
        if (cb_15) ((void(*)(void*,int))cb_15)(dt_15, (int)e->reason());
        QCalendarWidget::focusInEvent(e);
    }
    void focusOutEvent(QFocusEvent* e) override {
        if (cb_16) ((void(*)(void*,int))cb_16)(dt_16, (int)e->reason());
        QCalendarWidget::focusOutEvent(e);
    }
    void contextMenuEvent(QContextMenuEvent* e) override {
        if (cb_17) ((void(*)(void*,int,int))cb_17)(dt_17, e->pos().x(), e->pos().y());
        else QCalendarWidget::contextMenuEvent(e);
    }
};

// ─── lifecycle ────────────────────────────────────────────────────────────────
void* qteQCalendarWidget_create(void* parent) {
    return qte_createTracked(new eQCalendarWidget((QWidget*)parent));
}
void qteQCalendarWidget_destroy(void* obj) {
    delete (eQCalendarWidget*)obj;
}

// ─── selectedDate ─────────────────────────────────────────────────────────────
void qteQCalendarWidget_selectedDate(void* obj, int* y, int* mo, int* d) {
    QDate dt = ((QCalendarWidget*)obj)->selectedDate();
    *y = dt.year(); *mo = dt.month(); *d = dt.day();
}
void qteQCalendarWidget_setSelectedDate(void* obj, int y, int mo, int d) {
    ((QCalendarWidget*)obj)->setSelectedDate(QDate(y, mo, d));
}

// ─── yearShown / monthShown ───────────────────────────────────────────────────
int qteQCalendarWidget_yearShown(void* obj) {
    return ((QCalendarWidget*)obj)->yearShown();
}
int qteQCalendarWidget_monthShown(void* obj) {
    return ((QCalendarWidget*)obj)->monthShown();
}

// ─── minimumDate / maximumDate ────────────────────────────────────────────────
void qteQCalendarWidget_minimumDate(void* obj, int* y, int* mo, int* d) {
    QDate dt = ((QCalendarWidget*)obj)->minimumDate();
    *y = dt.year(); *mo = dt.month(); *d = dt.day();
}
void qteQCalendarWidget_setMinimumDate(void* obj, int y, int mo, int d) {
    ((QCalendarWidget*)obj)->setMinimumDate(QDate(y, mo, d));
}
void qteQCalendarWidget_maximumDate(void* obj, int* y, int* mo, int* d) {
    QDate dt = ((QCalendarWidget*)obj)->maximumDate();
    *y = dt.year(); *mo = dt.month(); *d = dt.day();
}
void qteQCalendarWidget_setMaximumDate(void* obj, int y, int mo, int d) {
    ((QCalendarWidget*)obj)->setMaximumDate(QDate(y, mo, d));
}

// ─── firstDayOfWeek ───────────────────────────────────────────────────────────
int qteQCalendarWidget_firstDayOfWeek(void* obj) {
    return (int)((QCalendarWidget*)obj)->firstDayOfWeek();
}
void qteQCalendarWidget_setFirstDayOfWeek(void* obj, int dayOfWeek) {
    ((QCalendarWidget*)obj)->setFirstDayOfWeek((Qt::DayOfWeek)dayOfWeek);
}

// ─── navigationBarVisible / gridVisible ──────────────────────────────────────
int qteQCalendarWidget_isNavigationBarVisible(void* obj) {
    return ((QCalendarWidget*)obj)->isNavigationBarVisible() ? 1 : 0;
}
void qteQCalendarWidget_setNavigationBarVisible(void* obj, int v) {
    ((QCalendarWidget*)obj)->setNavigationBarVisible(v != 0);
}
int qteQCalendarWidget_isGridVisible(void* obj) {
    return ((QCalendarWidget*)obj)->isGridVisible() ? 1 : 0;
}
void qteQCalendarWidget_setGridVisible(void* obj, int v) {
    ((QCalendarWidget*)obj)->setGridVisible(v != 0);
}

// ─── selectionMode ────────────────────────────────────────────────────────────
int qteQCalendarWidget_selectionMode(void* obj) {
    return (int)((QCalendarWidget*)obj)->selectionMode();
}
void qteQCalendarWidget_setSelectionMode(void* obj, int mode) {
    ((QCalendarWidget*)obj)->setSelectionMode((QCalendarWidget::SelectionMode)mode);
}

// ─── horizontalHeaderFormat / verticalHeaderFormat ───────────────────────────
int qteQCalendarWidget_horizontalHeaderFormat(void* obj) {
    return (int)((QCalendarWidget*)obj)->horizontalHeaderFormat();
}
void qteQCalendarWidget_setHorizontalHeaderFormat(void* obj, int fmt) {
    ((QCalendarWidget*)obj)->setHorizontalHeaderFormat((QCalendarWidget::HorizontalHeaderFormat)fmt);
}
int qteQCalendarWidget_verticalHeaderFormat(void* obj) {
    return (int)((QCalendarWidget*)obj)->verticalHeaderFormat();
}
void qteQCalendarWidget_setVerticalHeaderFormat(void* obj, int fmt) {
    ((QCalendarWidget*)obj)->setVerticalHeaderFormat((QCalendarWidget::VerticalHeaderFormat)fmt);
}

// ─── dateEditEnabled / dateEditAcceptDelay ───────────────────────────────────
int qteQCalendarWidget_isDateEditEnabled(void* obj) {
    return ((QCalendarWidget*)obj)->isDateEditEnabled() ? 1 : 0;
}
void qteQCalendarWidget_setDateEditEnabled(void* obj, int v) {
    ((QCalendarWidget*)obj)->setDateEditEnabled(v != 0);
}
int qteQCalendarWidget_dateEditAcceptDelay(void* obj) {
    return ((QCalendarWidget*)obj)->dateEditAcceptDelay();
}
void qteQCalendarWidget_setDateEditAcceptDelay(void* obj, int delay) {
    ((QCalendarWidget*)obj)->setDateEditAcceptDelay(delay);
}

// ─── navigation slots ─────────────────────────────────────────────────────────
void qteQCalendarWidget_setDateRange(void* obj, int y1, int mo1, int d1, int y2, int mo2, int d2) {
    ((QCalendarWidget*)obj)->setDateRange(QDate(y1,mo1,d1), QDate(y2,mo2,d2));
}
void qteQCalendarWidget_setCurrentPage(void* obj, int year, int month) {
    ((QCalendarWidget*)obj)->setCurrentPage(year, month);
}
void qteQCalendarWidget_showNextMonth(void* obj)     { ((QCalendarWidget*)obj)->showNextMonth(); }
void qteQCalendarWidget_showPreviousMonth(void* obj) { ((QCalendarWidget*)obj)->showPreviousMonth(); }
void qteQCalendarWidget_showNextYear(void* obj)      { ((QCalendarWidget*)obj)->showNextYear(); }
void qteQCalendarWidget_showPreviousYear(void* obj)  { ((QCalendarWidget*)obj)->showPreviousYear(); }
void qteQCalendarWidget_showSelectedDate(void* obj)  { ((QCalendarWidget*)obj)->showSelectedDate(); }
void qteQCalendarWidget_showToday(void* obj)         { ((QCalendarWidget*)obj)->showToday(); }

// ─── setEventHandler ──────────────────────────────────────────────────────────
void qteQCalendarWidget_setEventHandler(void* w, int id, void* cb, void* dthis) {
    eQCalendarWidget* obj = (eQCalendarWidget*)w;
    switch (id) {
        case  1: obj->cb_01=cb; obj->dt_01=dthis; break;
        case  2: obj->cb_02=cb; obj->dt_02=dthis; break;
        case  3: obj->cb_03=cb; obj->dt_03=dthis; break;
        case  4: obj->cb_04=cb; obj->dt_04=dthis; break;
        case  5: obj->cb_05=cb; obj->dt_05=dthis; break;
        case  6: obj->cb_06=cb; obj->dt_06=dthis; break;
        case  7: obj->cb_07=cb; obj->dt_07=dthis; break;
        case  8: obj->cb_08=cb; obj->dt_08=dthis; break;
        case  9: obj->cb_09=cb; obj->dt_09=dthis; break;
        case 10: obj->cb_10=cb; obj->dt_10=dthis; break;
        case 11: obj->cb_11=cb; obj->dt_11=dthis; break;
        case 12: obj->cb_12=cb; obj->dt_12=dthis; break;
        case 13: obj->cb_13=cb; obj->dt_13=dthis; break;
        case 14: obj->cb_14=cb; obj->dt_14=dthis; break;
        case 15: obj->cb_15=cb; obj->dt_15=dthis; break;
        case 16: obj->cb_16=cb; obj->dt_16=dthis; break;
        case 17: obj->cb_17=cb; obj->dt_17=dthis; break;
    }
}

// ─── signals ──────────────────────────────────────────────────────────────────
void qteQCalendarWidget_connect_selectionChanged(void* obj, void* cb, void* dthis) {
    typedef void(*Cb)(void*);
    auto cbf = (Cb)cb;
    QObject::connect((QCalendarWidget*)obj, &QCalendarWidget::selectionChanged,
        [=]() { cbf(dthis); });
}
void qteQCalendarWidget_connect_clicked(void* obj, void* cb, void* dthis) {
    typedef void(*Cb)(void*, int, int, int, int);
    auto cbf = (Cb)cb;
    QObject::connect((QCalendarWidget*)obj, &QCalendarWidget::clicked,
        [=](const QDate& d) { cbf(dthis, 0, d.year(), d.month(), d.day()); });
}
void qteQCalendarWidget_connect_activated(void* obj, void* cb, void* dthis) {
    typedef void(*Cb)(void*, int, int, int, int);
    auto cbf = (Cb)cb;
    QObject::connect((QCalendarWidget*)obj, &QCalendarWidget::activated,
        [=](const QDate& d) { cbf(dthis, 0, d.year(), d.month(), d.day()); });
}
void qteQCalendarWidget_connect_currentPageChanged(void* obj, void* cb, void* dthis) {
    typedef void(*Cb)(void*, int, int);
    auto cbf = (Cb)cb;
    QObject::connect((QCalendarWidget*)obj, &QCalendarWidget::currentPageChanged,
        [=](int year, int month) { cbf(dthis, year, month); });
}
