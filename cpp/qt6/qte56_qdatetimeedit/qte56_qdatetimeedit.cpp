#ifndef QTE56_QDATETIMEEDIT_BUILD
#define QTE56_QDATETIMEEDIT_BUILD
#endif
#include "qte56_qdatetimeedit.h"
#include <QDateTimeEdit>
#include <QDateEdit>
#include <QTimeEdit>
#include <QDateTime>
#include <QDate>
#include <QTime>
#include <QString>
#include <QWidget>
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
#include <QObject>

// ─── Event proxy template ─────────────────────────────────────────────────────
// Единый шаблон для всех трёх классов. Base = QDateTimeEdit/QDateEdit/QTimeEdit
template<class Base>
class EventProxy : public Base {
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

    explicit EventProxy(QWidget* parent = nullptr) : Base(parent) {}

protected:
    void mousePressEvent(QMouseEvent* e) override {
        if (cb_01) ((void(*)(void*,int,int,int))cb_01)(dt_01, e->x(), e->y(), (int)e->button());
        else Base::mousePressEvent(e);
    }
    void mouseReleaseEvent(QMouseEvent* e) override {
        if (cb_02) ((void(*)(void*,int,int,int))cb_02)(dt_02, e->x(), e->y(), (int)e->button());
        else Base::mouseReleaseEvent(e);
    }
    void mouseDoubleClickEvent(QMouseEvent* e) override {
        if (cb_03) ((void(*)(void*,int,int,int))cb_03)(dt_03, e->x(), e->y(), (int)e->button());
        else Base::mouseDoubleClickEvent(e);
    }
    void mouseMoveEvent(QMouseEvent* e) override {
        if (cb_04) ((void(*)(void*,int,int))cb_04)(dt_04, e->x(), e->y());
        else Base::mouseMoveEvent(e);
    }
    void keyPressEvent(QKeyEvent* e) override {
        if (cb_05) ((void(*)(void*,int,int))cb_05)(dt_05, (int)e->key(), (int)e->modifiers());
        else Base::keyPressEvent(e);
    }
    void keyReleaseEvent(QKeyEvent* e) override {
        if (cb_06) ((void(*)(void*,int,int))cb_06)(dt_06, (int)e->key(), (int)e->modifiers());
        else Base::keyReleaseEvent(e);
    }
    void resizeEvent(QResizeEvent* e) override {
        if (cb_07) ((void(*)(void*,int,int))cb_07)(dt_07, e->size().width(), e->size().height());
        else Base::resizeEvent(e);
    }
    void moveEvent(QMoveEvent* e) override {
        if (cb_08) ((void(*)(void*,int,int))cb_08)(dt_08, e->pos().x(), e->pos().y());
        else Base::moveEvent(e);
    }
    void closeEvent(QCloseEvent* e) override {
        if (cb_09) {
            int accept = 1;
            ((void(*)(void*,int*))cb_09)(dt_09, &accept);
            if (!accept) e->ignore();
        } else {
            Base::closeEvent(e);
        }
    }
    void showEvent(QShowEvent* e) override {
        if (cb_10) ((void(*)(void*))cb_10)(dt_10);
        else Base::showEvent(e);
    }
    void hideEvent(QHideEvent* e) override {
        if (cb_11) ((void(*)(void*))cb_11)(dt_11);
        else Base::hideEvent(e);
    }
    void enterEvent(QEnterEvent* e) override {
        if (cb_12) ((void(*)(void*))cb_12)(dt_12);
        else Base::enterEvent(e);
    }
    void leaveEvent(QEvent* e) override {
        if (cb_13) ((void(*)(void*))cb_13)(dt_13);
        else Base::leaveEvent(e);
    }
    void wheelEvent(QWheelEvent* e) override {
        if (cb_14) ((void(*)(void*,int,int))cb_14)(dt_14, e->angleDelta().x(), e->angleDelta().y());
        else Base::wheelEvent(e);
    }
    void focusInEvent(QFocusEvent* e) override {
        if (cb_15) ((void(*)(void*,int))cb_15)(dt_15, (int)e->reason());
        else Base::focusInEvent(e);
    }
    void focusOutEvent(QFocusEvent* e) override {
        if (cb_16) ((void(*)(void*,int))cb_16)(dt_16, (int)e->reason());
        else Base::focusOutEvent(e);
    }
    void contextMenuEvent(QContextMenuEvent* e) override {
        if (cb_17) ((void(*)(void*,int,int,int))cb_17)(dt_17, e->x(), e->y(), (int)e->reason());
        else Base::contextMenuEvent(e);
    }
};

using eQDateTimeEdit = EventProxy<QDateTimeEdit>;
using eQDateEdit     = EventProxy<QDateEdit>;
using eQTimeEdit     = EventProxy<QTimeEdit>;

// ─── setEventHandler шаблон ───────────────────────────────────────────────────
template<class T>
static void setEventHandlerImpl(void* w, int id, void* cb, void* dthis) {
    T* obj = (T*)w;
    switch (id) {
        case  1: obj->cb_01 = cb; obj->dt_01 = dthis; break;
        case  2: obj->cb_02 = cb; obj->dt_02 = dthis; break;
        case  3: obj->cb_03 = cb; obj->dt_03 = dthis; break;
        case  4: obj->cb_04 = cb; obj->dt_04 = dthis; break;
        case  5: obj->cb_05 = cb; obj->dt_05 = dthis; break;
        case  6: obj->cb_06 = cb; obj->dt_06 = dthis; break;
        case  7: obj->cb_07 = cb; obj->dt_07 = dthis; break;
        case  8: obj->cb_08 = cb; obj->dt_08 = dthis; break;
        case  9: obj->cb_09 = cb; obj->dt_09 = dthis; break;
        case 10: obj->cb_10 = cb; obj->dt_10 = dthis; break;
        case 11: obj->cb_11 = cb; obj->dt_11 = dthis; break;
        case 12: obj->cb_12 = cb; obj->dt_12 = dthis; break;
        case 13: obj->cb_13 = cb; obj->dt_13 = dthis; break;
        case 14: obj->cb_14 = cb; obj->dt_14 = dthis; break;
        case 15: obj->cb_15 = cb; obj->dt_15 = dthis; break;
        case 16: obj->cb_16 = cb; obj->dt_16 = dthis; break;
        case 17: obj->cb_17 = cb; obj->dt_17 = dthis; break;
        default: break;
    }
}

// ─── Вспомогательные инлайны для QDate/QTime ──────────────────────────────────
static inline void unpackDate(const QDate& d, int* y, int* mo, int* dd)
    { *y = d.year(); *mo = d.month(); *dd = d.day(); }

static inline void unpackTime(const QTime& t, int* h, int* mi, int* s, int* ms)
    { *h = t.hour(); *mi = t.minute(); *s = t.second(); *ms = t.msec(); }

static inline void unpackDT(const QDateTime& dt,
    int* y, int* mo, int* d, int* h, int* mi, int* s, int* ms) {
    unpackDate(dt.date(), y, mo, d);
    unpackTime(dt.time(), h, mi, s, ms);
}

extern "C" {

// ─────────────────────────────────────────────────────────────────────────────
// QDateTimeEdit
// ─────────────────────────────────────────────────────────────────────────────

void* qteQDateTimeEdit_create(void* parent) {
    return new eQDateTimeEdit((QWidget*)parent);
}
void qteQDateTimeEdit_delete(void* w) { delete (eQDateTimeEdit*)w; }
void qteQDateTimeEdit_show(void* obj)   { ((QDateTimeEdit*)obj)->show(); }
void qteQDateTimeEdit_hide(void* obj)   { ((QDateTimeEdit*)obj)->hide(); }
void qteQDateTimeEdit_update(void* obj) { ((QDateTimeEdit*)obj)->update(); }

// ── getters ──────────────────────────────────────────────────────────────────
void qteQDateTimeEdit_date(void* obj, int* y, int* mo, int* d) {
    unpackDate(((QDateTimeEdit*)obj)->date(), y, mo, d);
}
void qteQDateTimeEdit_time(void* obj, int* h, int* mi, int* s, int* ms) {
    unpackTime(((QDateTimeEdit*)obj)->time(), h, mi, s, ms);
}
void qteQDateTimeEdit_dateTime(void* obj, int* y, int* mo, int* d, int* h, int* mi, int* s, int* ms) {
    unpackDT(((QDateTimeEdit*)obj)->dateTime(), y, mo, d, h, mi, s, ms);
}

// ── setters ──────────────────────────────────────────────────────────────────
void qteQDateTimeEdit_setDate(void* obj, int y, int mo, int d) {
    ((QDateTimeEdit*)obj)->setDate(QDate(y, mo, d));
}
void qteQDateTimeEdit_setTime(void* obj, int h, int mi, int s, int ms) {
    ((QDateTimeEdit*)obj)->setTime(QTime(h, mi, s, ms));
}
void qteQDateTimeEdit_setDateTime(void* obj, int y, int mo, int d, int h, int mi, int s, int ms) {
    ((QDateTimeEdit*)obj)->setDateTime(QDateTime(QDate(y, mo, d), QTime(h, mi, s, ms)));
}

// ── min/max date ─────────────────────────────────────────────────────────────
void qteQDateTimeEdit_minimumDate(void* obj, int* y, int* mo, int* d) {
    unpackDate(((QDateTimeEdit*)obj)->minimumDate(), y, mo, d);
}
void qteQDateTimeEdit_setMinimumDate(void* obj, int y, int mo, int d) {
    ((QDateTimeEdit*)obj)->setMinimumDate(QDate(y, mo, d));
}
void qteQDateTimeEdit_clearMinimumDate(void* obj) {
    ((QDateTimeEdit*)obj)->clearMinimumDate();
}
void qteQDateTimeEdit_maximumDate(void* obj, int* y, int* mo, int* d) {
    unpackDate(((QDateTimeEdit*)obj)->maximumDate(), y, mo, d);
}
void qteQDateTimeEdit_setMaximumDate(void* obj, int y, int mo, int d) {
    ((QDateTimeEdit*)obj)->setMaximumDate(QDate(y, mo, d));
}
void qteQDateTimeEdit_clearMaximumDate(void* obj) {
    ((QDateTimeEdit*)obj)->clearMaximumDate();
}
void qteQDateTimeEdit_setDateRange(void* obj, int y1, int mo1, int d1, int y2, int mo2, int d2) {
    ((QDateTimeEdit*)obj)->setDateRange(QDate(y1, mo1, d1), QDate(y2, mo2, d2));
}

// ── min/max time ─────────────────────────────────────────────────────────────
void qteQDateTimeEdit_minimumTime(void* obj, int* h, int* mi, int* s, int* ms) {
    unpackTime(((QDateTimeEdit*)obj)->minimumTime(), h, mi, s, ms);
}
void qteQDateTimeEdit_setMinimumTime(void* obj, int h, int mi, int s, int ms) {
    ((QDateTimeEdit*)obj)->setMinimumTime(QTime(h, mi, s, ms));
}
void qteQDateTimeEdit_clearMinimumTime(void* obj) {
    ((QDateTimeEdit*)obj)->clearMinimumTime();
}
void qteQDateTimeEdit_maximumTime(void* obj, int* h, int* mi, int* s, int* ms) {
    unpackTime(((QDateTimeEdit*)obj)->maximumTime(), h, mi, s, ms);
}
void qteQDateTimeEdit_setMaximumTime(void* obj, int h, int mi, int s, int ms) {
    ((QDateTimeEdit*)obj)->setMaximumTime(QTime(h, mi, s, ms));
}
void qteQDateTimeEdit_clearMaximumTime(void* obj) {
    ((QDateTimeEdit*)obj)->clearMaximumTime();
}

// ── min/max dateTime ──────────────────────────────────────────────────────────
void qteQDateTimeEdit_minimumDateTime(void* obj, int* y, int* mo, int* d, int* h, int* mi, int* s, int* ms) {
    unpackDT(((QDateTimeEdit*)obj)->minimumDateTime(), y, mo, d, h, mi, s, ms);
}
void qteQDateTimeEdit_setMinimumDateTime(void* obj, int y, int mo, int d, int h, int mi, int s, int ms) {
    ((QDateTimeEdit*)obj)->setMinimumDateTime(QDateTime(QDate(y, mo, d), QTime(h, mi, s, ms)));
}
void qteQDateTimeEdit_clearMinimumDateTime(void* obj) {
    ((QDateTimeEdit*)obj)->clearMinimumDateTime();
}
void qteQDateTimeEdit_maximumDateTime(void* obj, int* y, int* mo, int* d, int* h, int* mi, int* s, int* ms) {
    unpackDT(((QDateTimeEdit*)obj)->maximumDateTime(), y, mo, d, h, mi, s, ms);
}
void qteQDateTimeEdit_setMaximumDateTime(void* obj, int y, int mo, int d, int h, int mi, int s, int ms) {
    ((QDateTimeEdit*)obj)->setMaximumDateTime(QDateTime(QDate(y, mo, d), QTime(h, mi, s, ms)));
}
void qteQDateTimeEdit_clearMaximumDateTime(void* obj) {
    ((QDateTimeEdit*)obj)->clearMaximumDateTime();
}

// ── display format / popup / section ─────────────────────────────────────────
void* qteQDateTimeEdit_displayFormat(void* obj) {
    return new QString(((QDateTimeEdit*)obj)->displayFormat());
}
void qteQDateTimeEdit_setDisplayFormat(void* obj, void* fmt) {
    ((QDateTimeEdit*)obj)->setDisplayFormat(*(QString*)fmt);
}
int  qteQDateTimeEdit_calendarPopup(void* obj) {
    return ((QDateTimeEdit*)obj)->calendarPopup() ? 1 : 0;
}
void qteQDateTimeEdit_setCalendarPopup(void* obj, int enable) {
    ((QDateTimeEdit*)obj)->setCalendarPopup(enable != 0);
}
int  qteQDateTimeEdit_currentSection(void* obj) {
    return (int)((QDateTimeEdit*)obj)->currentSection();
}
void qteQDateTimeEdit_setCurrentSection(void* obj, int section) {
    ((QDateTimeEdit*)obj)->setCurrentSection((QDateTimeEdit::Section)section);
}
int  qteQDateTimeEdit_currentSectionIndex(void* obj) {
    return ((QDateTimeEdit*)obj)->currentSectionIndex();
}
void qteQDateTimeEdit_setCurrentSectionIndex(void* obj, int index) {
    ((QDateTimeEdit*)obj)->setCurrentSectionIndex(index);
}
int  qteQDateTimeEdit_sectionCount(void* obj) {
    return ((QDateTimeEdit*)obj)->sectionCount();
}
void* qteQDateTimeEdit_sectionText(void* obj, int section) {
    return new QString(((QDateTimeEdit*)obj)->sectionText((QDateTimeEdit::Section)section));
}
int  qteQDateTimeEdit_sectionAt(void* obj, int index) {
    return (int)((QDateTimeEdit*)obj)->sectionAt(index);
}
int  qteQDateTimeEdit_timeSpec(void* obj) {
    return (int)((QDateTimeEdit*)obj)->timeSpec();
}
void qteQDateTimeEdit_setTimeSpec(void* obj, int spec) {
    ((QDateTimeEdit*)obj)->setTimeSpec((Qt::TimeSpec)spec);
}

// ── event handler ──────────────────────────────────────────────────────────
void qteQDateTimeEdit_setEventHandler(void* w, int id, void* cb, void* dthis) {
    setEventHandlerImpl<eQDateTimeEdit>(w, id, cb, dthis);
}

// ── сигналы ────────────────────────────────────────────────────────────────
void qteQDateTimeEdit_connect_dateTimeChanged(void* obj, void* cb, void* dthis) {
    if (!cb) return;
    typedef void(*Cb)(void*, int, int, int, int, int, int, int, int);
    auto cbf = (Cb)cb;
    QObject::connect((QDateTimeEdit*)obj, &QDateTimeEdit::dateTimeChanged,
        [=](const QDateTime& dt) {
            cbf(dthis, 0, dt.date().year(), dt.date().month(), dt.date().day(),
                dt.time().hour(), dt.time().minute(), dt.time().second(), dt.time().msec());
        });
}
void qteQDateTimeEdit_connect_timeChanged(void* obj, void* cb, void* dthis) {
    if (!cb) return;
    typedef void(*Cb)(void*, int, int, int, int, int);
    auto cbf = (Cb)cb;
    QObject::connect((QDateTimeEdit*)obj, &QDateTimeEdit::timeChanged,
        [=](const QTime& t) {
            cbf(dthis, 0, t.hour(), t.minute(), t.second(), t.msec());
        });
}
void qteQDateTimeEdit_connect_dateChanged(void* obj, void* cb, void* dthis) {
    if (!cb) return;
    typedef void(*Cb)(void*, int, int, int, int);
    auto cbf = (Cb)cb;
    QObject::connect((QDateTimeEdit*)obj, &QDateTimeEdit::dateChanged,
        [=](const QDate& d) {
            cbf(dthis, 0, d.year(), d.month(), d.day());
        });
}

// ─────────────────────────────────────────────────────────────────────────────
// QDateEdit
// ─────────────────────────────────────────────────────────────────────────────

void* qteQDateEdit_create(void* parent) {
    return new eQDateEdit((QWidget*)parent);
}
void qteQDateEdit_delete(void* w)   { delete (eQDateEdit*)w; }
void qteQDateEdit_show(void* obj)   { ((QDateEdit*)obj)->show(); }
void qteQDateEdit_hide(void* obj)   { ((QDateEdit*)obj)->hide(); }
void qteQDateEdit_update(void* obj) { ((QDateEdit*)obj)->update(); }

void qteQDateEdit_setEventHandler(void* w, int id, void* cb, void* dthis) {
    setEventHandlerImpl<eQDateEdit>(w, id, cb, dthis);
}
void qteQDateEdit_connect_userDateChanged(void* obj, void* cb, void* dthis) {
    if (!cb) return;
    typedef void(*Cb)(void*, int, int, int, int);
    auto cbf = (Cb)cb;
    QObject::connect((QDateEdit*)obj, &QDateEdit::userDateChanged,
        [=](const QDate& d) {
            cbf(dthis, 0, d.year(), d.month(), d.day());
        });
}

// ─────────────────────────────────────────────────────────────────────────────
// QTimeEdit
// ─────────────────────────────────────────────────────────────────────────────

void* qteQTimeEdit_create(void* parent) {
    return new eQTimeEdit((QWidget*)parent);
}
void qteQTimeEdit_delete(void* w)   { delete (eQTimeEdit*)w; }
void qteQTimeEdit_show(void* obj)   { ((QTimeEdit*)obj)->show(); }
void qteQTimeEdit_hide(void* obj)   { ((QTimeEdit*)obj)->hide(); }
void qteQTimeEdit_update(void* obj) { ((QTimeEdit*)obj)->update(); }

void qteQTimeEdit_setEventHandler(void* w, int id, void* cb, void* dthis) {
    setEventHandlerImpl<eQTimeEdit>(w, id, cb, dthis);
}
void qteQTimeEdit_connect_userTimeChanged(void* obj, void* cb, void* dthis) {
    if (!cb) return;
    typedef void(*Cb)(void*, int, int, int, int, int);
    auto cbf = (Cb)cb;
    QObject::connect((QTimeEdit*)obj, &QTimeEdit::userTimeChanged,
        [=](const QTime& t) {
            cbf(dthis, 0, t.hour(), t.minute(), t.second(), t.msec());
        });
}

} // extern "C"
