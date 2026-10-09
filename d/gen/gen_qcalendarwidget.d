/**
 * gen_qcalendarwidget.d — обёртка для QCalendarWidget.
 * DLL: qte56_widgets.dll  |  Индексы: 17300–17338
 *
 * QCalendarWidget : QWidget (прямое наследование).
 * QDate передаётся как целочисленные компоненты (DDate из qte56_core).
 *
 * Пропущены: headerTextFormat, weekdayTextFormat, dateTextFormat
 *            (QTextCharFormat — слишком сложный value type).
 *
 * Сигнальные прототипы:
 *   selectionChanged:   extern(C) void cb(void* dthis)
 *   clicked/activated:  extern(C) void cb(void* dthis, int n, int y, int mo, int d)
 *   currentPageChanged: extern(C) void cb(void* dthis, int year, int month)
 */
module gen_qcalendarwidget;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : t_i__qp, t_qp__, t_qp__qp, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_i_i_i, t_v__qp_i_i_i_i_i_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_qp;
import gen_qwidget : QWidget;
import gen_qdate   : QDate;

// ── Загрузка адресов функций ──────────────────────────────────────────────────

void loadQCalendarWidget() {
    mixin(generateFunQt(17300, "qteQCalendarWidget_create",                  "QCalendarWidget"));
    mixin(generateFunQt(17301, "qteQCalendarWidget_destroy",                 "QCalendarWidget"));
    mixin(generateFunQt(17302, "qteQCalendarWidget_selectedDate",            "QCalendarWidget"));
    mixin(generateFunQt(17303, "qteQCalendarWidget_setSelectedDate",         "QCalendarWidget"));
    mixin(generateFunQt(17304, "qteQCalendarWidget_yearShown",               "QCalendarWidget"));
    mixin(generateFunQt(17305, "qteQCalendarWidget_monthShown",              "QCalendarWidget"));
    mixin(generateFunQt(17306, "qteQCalendarWidget_minimumDate",             "QCalendarWidget"));
    mixin(generateFunQt(17307, "qteQCalendarWidget_setMinimumDate",          "QCalendarWidget"));
    mixin(generateFunQt(17308, "qteQCalendarWidget_maximumDate",             "QCalendarWidget"));
    mixin(generateFunQt(17309, "qteQCalendarWidget_setMaximumDate",          "QCalendarWidget"));
    mixin(generateFunQt(17310, "qteQCalendarWidget_firstDayOfWeek",          "QCalendarWidget"));
    mixin(generateFunQt(17311, "qteQCalendarWidget_setFirstDayOfWeek",       "QCalendarWidget"));
    mixin(generateFunQt(17312, "qteQCalendarWidget_isNavigationBarVisible",  "QCalendarWidget"));
    mixin(generateFunQt(17313, "qteQCalendarWidget_setNavigationBarVisible", "QCalendarWidget"));
    mixin(generateFunQt(17314, "qteQCalendarWidget_isGridVisible",           "QCalendarWidget"));
    mixin(generateFunQt(17315, "qteQCalendarWidget_setGridVisible",          "QCalendarWidget"));
    mixin(generateFunQt(17316, "qteQCalendarWidget_selectionMode",           "QCalendarWidget"));
    mixin(generateFunQt(17317, "qteQCalendarWidget_setSelectionMode",        "QCalendarWidget"));
    mixin(generateFunQt(17318, "qteQCalendarWidget_horizontalHeaderFormat",  "QCalendarWidget"));
    mixin(generateFunQt(17319, "qteQCalendarWidget_setHorizontalHeaderFormat","QCalendarWidget"));
    mixin(generateFunQt(17320, "qteQCalendarWidget_verticalHeaderFormat",    "QCalendarWidget"));
    mixin(generateFunQt(17321, "qteQCalendarWidget_setVerticalHeaderFormat", "QCalendarWidget"));
    mixin(generateFunQt(17322, "qteQCalendarWidget_isDateEditEnabled",       "QCalendarWidget"));
    mixin(generateFunQt(17323, "qteQCalendarWidget_setDateEditEnabled",      "QCalendarWidget"));
    mixin(generateFunQt(17324, "qteQCalendarWidget_dateEditAcceptDelay",     "QCalendarWidget"));
    mixin(generateFunQt(17325, "qteQCalendarWidget_setDateEditAcceptDelay",  "QCalendarWidget"));
    mixin(generateFunQt(17326, "qteQCalendarWidget_setDateRange",            "QCalendarWidget"));
    mixin(generateFunQt(17327, "qteQCalendarWidget_setCurrentPage",          "QCalendarWidget"));
    mixin(generateFunQt(17328, "qteQCalendarWidget_showNextMonth",           "QCalendarWidget"));
    mixin(generateFunQt(17329, "qteQCalendarWidget_showPreviousMonth",       "QCalendarWidget"));
    mixin(generateFunQt(17330, "qteQCalendarWidget_showNextYear",            "QCalendarWidget"));
    mixin(generateFunQt(17331, "qteQCalendarWidget_showPreviousYear",        "QCalendarWidget"));
    mixin(generateFunQt(17332, "qteQCalendarWidget_showSelectedDate",        "QCalendarWidget"));
    mixin(generateFunQt(17333, "qteQCalendarWidget_showToday",               "QCalendarWidget"));
    mixin(generateFunQt(17334, "qteQCalendarWidget_setEventHandler",         "QCalendarWidget"));
    mixin(generateFunQt(17335, "qteQCalendarWidget_connect_selectionChanged","QCalendarWidget"));
    mixin(generateFunQt(17336, "qteQCalendarWidget_connect_clicked",         "QCalendarWidget"));
    mixin(generateFunQt(17337, "qteQCalendarWidget_connect_activated",       "QCalendarWidget"));
    mixin(generateFunQt(17338, "qteQCalendarWidget_connect_currentPageChanged","QCalendarWidget"));
}

shared static this() {
    registerModule("QCalendarWidget", "qte56_widgets.dll", &loadQCalendarWidget);
}

// ─────────────────────────────────────────────────────────────────────────────
// QCalendarWidget
// ─────────────────────────────────────────────────────────────────────────────

@live class QCalendarWidget : QWidget {
public:
    this(void* parent = null) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[17300])(parent);
    }

    // ── selectedDate ──────────────────────────────────────────────────────────
    DDate selectedDate() {
        DDate r;
        (cast(t_v__qp_ip_ip_ip)pFunQt[17302])(_wh, &r.year, &r.month, &r.day);
        return r;
    }
    /// Returns selected date as a QDate value-type object (D-owned).
    QDate selectedQDate() { auto d = selectedDate(); return new QDate(d.year, d.month, d.day); }

    QCalendarWidget setSelectedDate(int y, int mo, int d) {
        (cast(t_v__qp_i_i_i)pFunQt[17303])(_wh, y, mo, d);
        return this;
    }
    QCalendarWidget setSelectedDate(DDate dt) { setSelectedDate(dt.year, dt.month, dt.day); return this; }
    QCalendarWidget setSelectedDate(QDate qd)  { setSelectedDate(qd.year(), qd.month(), qd.day()); return this; }

    // ── yearShown / monthShown ─────────────────────────────────────────────────
    int yearShown()  { return (cast(t_i__qp)pFunQt[17304])(_wh); }
    int monthShown() { return (cast(t_i__qp)pFunQt[17305])(_wh); }

    // ── minimumDate / maximumDate ──────────────────────────────────────────────
    DDate minimumDate() {
        DDate r;
        (cast(t_v__qp_ip_ip_ip)pFunQt[17306])(_wh, &r.year, &r.month, &r.day);
        return r;
    }
    QDate minimumQDate() { auto d = minimumDate(); return new QDate(d.year, d.month, d.day); }
    QCalendarWidget setMinimumDate(int y, int mo, int d) {
        (cast(t_v__qp_i_i_i)pFunQt[17307])(_wh, y, mo, d);
        return this;
    }
    QCalendarWidget setMinimumDate(QDate qd) { setMinimumDate(qd.year(), qd.month(), qd.day()); return this; }

    DDate maximumDate() {
        DDate r;
        (cast(t_v__qp_ip_ip_ip)pFunQt[17308])(_wh, &r.year, &r.month, &r.day);
        return r;
    }
    QDate maximumQDate() { auto d = maximumDate(); return new QDate(d.year, d.month, d.day); }
    QCalendarWidget setMaximumDate(int y, int mo, int d) {
        (cast(t_v__qp_i_i_i)pFunQt[17309])(_wh, y, mo, d);
        return this;
    }
    QCalendarWidget setMaximumDate(QDate qd) { setMaximumDate(qd.year(), qd.month(), qd.day()); return this; }

    QCalendarWidget setDateRange(int y1, int mo1, int d1, int y2, int mo2, int d2) {
        (cast(t_v__qp_i_i_i_i_i_i)pFunQt[17326])(_wh, y1, mo1, d1, y2, mo2, d2);
        return this;
    }
    QCalendarWidget setDateRange(QDate from, QDate to) {
        setDateRange(from.year(), from.month(), from.day(), to.year(), to.month(), to.day());
        return this;
    }

    // ── firstDayOfWeek ────────────────────────────────────────────────────────
    int  firstDayOfWeek()           { return (cast(t_i__qp)pFunQt[17310])(_wh); }
    QCalendarWidget setFirstDayOfWeek(int dow) { (cast(t_v__qp_i)pFunQt[17311])(_wh, dow); return this; }

    // ── navigation bar / grid ─────────────────────────────────────────────────
    bool isNavigationBarVisible()        { return (cast(t_i__qp)pFunQt[17312])(_wh) != 0; }
    QCalendarWidget setNavigationBarVisible(bool v) { (cast(t_v__qp_i)pFunQt[17313])(_wh, v ? 1 : 0); return this; }
    bool isGridVisible()                 { return (cast(t_i__qp)pFunQt[17314])(_wh) != 0; }
    QCalendarWidget setGridVisible(bool v)          { (cast(t_v__qp_i)pFunQt[17315])(_wh, v ? 1 : 0); return this; }

    // ── selectionMode ─────────────────────────────────────────────────────────
    // 0=NoSelection, 1=SingleSelection
    int  selectionMode()         { return (cast(t_i__qp)pFunQt[17316])(_wh); }
    QCalendarWidget setSelectionMode(int m) { (cast(t_v__qp_i)pFunQt[17317])(_wh, m); return this; }

    // ── horizontalHeaderFormat / verticalHeaderFormat ─────────────────────────
    // HorizontalHeaderFormat: 0=None, 1=SingleLetter, 2=Short, 3=Long
    // VerticalHeaderFormat: 0=None, 1=ISOWeekNumbers
    int  horizontalHeaderFormat()          { return (cast(t_i__qp)pFunQt[17318])(_wh); }
    QCalendarWidget setHorizontalHeaderFormat(int f)  { (cast(t_v__qp_i)pFunQt[17319])(_wh, f); return this; }
    int  verticalHeaderFormat()            { return (cast(t_i__qp)pFunQt[17320])(_wh); }
    QCalendarWidget setVerticalHeaderFormat(int f)    { (cast(t_v__qp_i)pFunQt[17321])(_wh, f); return this; }

    // ── dateEdit ──────────────────────────────────────────────────────────────
    bool isDateEditEnabled()             { return (cast(t_i__qp)pFunQt[17322])(_wh) != 0; }
    QCalendarWidget setDateEditEnabled(bool v)      { (cast(t_v__qp_i)pFunQt[17323])(_wh, v ? 1 : 0); return this; }
    int  dateEditAcceptDelay()           { return (cast(t_i__qp)pFunQt[17324])(_wh); }
    QCalendarWidget setDateEditAcceptDelay(int ms)  { (cast(t_v__qp_i)pFunQt[17325])(_wh, ms); return this; }

    // ── navigation slots ──────────────────────────────────────────────────────
    QCalendarWidget setCurrentPage(int year, int month) {
        (cast(t_v__qp_i_i)pFunQt[17327])(_wh, year, month);
        return this;
    }
    QCalendarWidget showNextMonth()     { (cast(t_v__qp)pFunQt[17328])(_wh); return this; }
    QCalendarWidget showPreviousMonth() { (cast(t_v__qp)pFunQt[17329])(_wh); return this; }
    QCalendarWidget showNextYear()      { (cast(t_v__qp)pFunQt[17330])(_wh); return this; }
    QCalendarWidget showPreviousYear()  { (cast(t_v__qp)pFunQt[17331])(_wh); return this; }
    QCalendarWidget showSelectedDate()  { (cast(t_v__qp)pFunQt[17332])(_wh); return this; }
    QCalendarWidget showToday()         { (cast(t_v__qp)pFunQt[17333])(_wh); return this; }

    // ── events ────────────────────────────────────────────────────────────────
    override QCalendarWidget setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[17334])(_wh, eventId, cb, dthis);
        return this;
    }

    // ── signals ───────────────────────────────────────────────────────────────

    /// selectionChanged — не несёт данных
    /// extern(C) void cb(void* dthis)
    QCalendarWidget connect_selectionChanged(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[17335])(_wh, cb, dthis);
        return this;
    }

    /// clicked / activated — дата клика
    /// extern(C) void cb(void* dthis, int n, int y, int mo, int d)
    QCalendarWidget connect_clicked(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[17336])(_wh, cb, dthis);
        return this;
    }
    QCalendarWidget connect_activated(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[17337])(_wh, cb, dthis);
        return this;
    }

    /// currentPageChanged — год и месяц текущей страницы
    /// extern(C) void cb(void* dthis, int year, int month)
    QCalendarWidget connect_currentPageChanged(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[17338])(_wh, cb, dthis);
        return this;
    }
}
