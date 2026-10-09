/**
 * gen_qdatetimeedit.d — обёртка для QDateTimeEdit / QDateEdit / QTimeEdit.
 * DLL: qte56_widgets.dll  |  Индексы: 17000–17046 / 17100–17106 / 17200–17206
 *
 * QDateTime/QDate/QTime передаются как целочисленные компоненты (без heap-объектов).
 * Сигналы используют lambda-connect: колбэк получает разложенные поля.
 *
 * Сигнальные прототипы:
 *   dateTimeChanged: extern(C) void cb(void* dthis, int n, int y, mo, d, h, mi, s, ms)
 *   timeChanged:     extern(C) void cb(void* dthis, int n, int h, mi, s, ms)
 *   dateChanged:     extern(C) void cb(void* dthis, int n, int year, month, day)
 *   userDateChanged: extern(C) void cb(void* dthis, int n, int year, month, day)
 *   userTimeChanged: extern(C) void cb(void* dthis, int n, int h, mi, s, ms)
 */
module gen_qdatetimeedit;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : ESlot, fromQString, t_i__qp, t_qp__, t_qp__qp, t_qp__qp_i, t_v__qp, t_v__qp_i, t_v__qp_i_i, t_v__qp_i_i_i, t_v__qp_i_i_i_i_i_i, t_v__qp_i_qp, t_v__qp_i_qp_qp, t_v__qp_ip_ip, t_v__qp_ip_ip_ip, t_v__qp_ip_ip_ip_ip, t_v__qp_qp, t_v__qp_qp_qp, toQString;
import gen_qwidget    : QWidget;
import gen_qframe     : QFrame;
import gen_qabstractspinbox : QAbstractSpinBox;
import gen_qdate      : QDate, QTime, QDateTime;

// ── Новые алиасы (t_v__qp_ip_ip_ip / t_v__qp_i_i_i / t_v__qp_i_i_i_i_i_i — в gen_qcore) ──
mixin(generateAlias("v__qp_i_i_i_i"));            // 4 int in  (setTime)
mixin(generateAlias("v__qp_ip_ip_ip_ip_ip_ip_ip")); // 7 int* out (dateTime)
mixin(generateAlias("v__qp_i_i_i_i_i_i_i"));     // 7 int in  (setDateTime)
mixin(generateAlias("i__qp_i"));                  // int result (sectionAt)

// DDate/DTime/DDateTime определены в qte56_core.d (доступны через import qte56_core)

// ====================================================================
// Загрузка адресов функций
// ====================================================================

void loadQDateTimeEdit() {
    // QDateTimeEdit
    mixin(generateFunQt(17000, "qteQDateTimeEdit_create",              "QDateTimeEdit"));
    mixin(generateFunQt(17001, "qteQDateTimeEdit_delete",              "QDateTimeEdit"));
    mixin(generateFunQt(17002, "qteQDateTimeEdit_show",                "QDateTimeEdit"));
    mixin(generateFunQt(17003, "qteQDateTimeEdit_hide",                "QDateTimeEdit"));
    mixin(generateFunQt(17004, "qteQDateTimeEdit_update",              "QDateTimeEdit"));
    mixin(generateFunQt(17005, "qteQDateTimeEdit_date",                "QDateTimeEdit"));
    mixin(generateFunQt(17006, "qteQDateTimeEdit_setDate",             "QDateTimeEdit"));
    mixin(generateFunQt(17007, "qteQDateTimeEdit_time",                "QDateTimeEdit"));
    mixin(generateFunQt(17008, "qteQDateTimeEdit_setTime",             "QDateTimeEdit"));
    mixin(generateFunQt(17009, "qteQDateTimeEdit_dateTime",            "QDateTimeEdit"));
    mixin(generateFunQt(17010, "qteQDateTimeEdit_setDateTime",         "QDateTimeEdit"));
    mixin(generateFunQt(17011, "qteQDateTimeEdit_minimumDate",         "QDateTimeEdit"));
    mixin(generateFunQt(17012, "qteQDateTimeEdit_setMinimumDate",      "QDateTimeEdit"));
    mixin(generateFunQt(17013, "qteQDateTimeEdit_clearMinimumDate",    "QDateTimeEdit"));
    mixin(generateFunQt(17014, "qteQDateTimeEdit_maximumDate",         "QDateTimeEdit"));
    mixin(generateFunQt(17015, "qteQDateTimeEdit_setMaximumDate",      "QDateTimeEdit"));
    mixin(generateFunQt(17016, "qteQDateTimeEdit_clearMaximumDate",    "QDateTimeEdit"));
    mixin(generateFunQt(17017, "qteQDateTimeEdit_setDateRange",        "QDateTimeEdit"));
    mixin(generateFunQt(17018, "qteQDateTimeEdit_minimumTime",         "QDateTimeEdit"));
    mixin(generateFunQt(17019, "qteQDateTimeEdit_setMinimumTime",      "QDateTimeEdit"));
    mixin(generateFunQt(17020, "qteQDateTimeEdit_clearMinimumTime",    "QDateTimeEdit"));
    mixin(generateFunQt(17021, "qteQDateTimeEdit_maximumTime",         "QDateTimeEdit"));
    mixin(generateFunQt(17022, "qteQDateTimeEdit_setMaximumTime",      "QDateTimeEdit"));
    mixin(generateFunQt(17023, "qteQDateTimeEdit_clearMaximumTime",    "QDateTimeEdit"));
    mixin(generateFunQt(17024, "qteQDateTimeEdit_minimumDateTime",     "QDateTimeEdit"));
    mixin(generateFunQt(17025, "qteQDateTimeEdit_setMinimumDateTime",  "QDateTimeEdit"));
    mixin(generateFunQt(17026, "qteQDateTimeEdit_clearMinimumDateTime","QDateTimeEdit"));
    mixin(generateFunQt(17027, "qteQDateTimeEdit_maximumDateTime",     "QDateTimeEdit"));
    mixin(generateFunQt(17028, "qteQDateTimeEdit_setMaximumDateTime",  "QDateTimeEdit"));
    mixin(generateFunQt(17029, "qteQDateTimeEdit_clearMaximumDateTime","QDateTimeEdit"));
    mixin(generateFunQt(17030, "qteQDateTimeEdit_displayFormat",       "QDateTimeEdit"));
    mixin(generateFunQt(17031, "qteQDateTimeEdit_setDisplayFormat",    "QDateTimeEdit"));
    mixin(generateFunQt(17032, "qteQDateTimeEdit_calendarPopup",       "QDateTimeEdit"));
    mixin(generateFunQt(17033, "qteQDateTimeEdit_setCalendarPopup",    "QDateTimeEdit"));
    mixin(generateFunQt(17034, "qteQDateTimeEdit_currentSection",      "QDateTimeEdit"));
    mixin(generateFunQt(17035, "qteQDateTimeEdit_setCurrentSection",   "QDateTimeEdit"));
    mixin(generateFunQt(17036, "qteQDateTimeEdit_currentSectionIndex", "QDateTimeEdit"));
    mixin(generateFunQt(17037, "qteQDateTimeEdit_setCurrentSectionIndex","QDateTimeEdit"));
    mixin(generateFunQt(17038, "qteQDateTimeEdit_sectionCount",        "QDateTimeEdit"));
    mixin(generateFunQt(17039, "qteQDateTimeEdit_sectionText",         "QDateTimeEdit"));
    mixin(generateFunQt(17040, "qteQDateTimeEdit_sectionAt",           "QDateTimeEdit"));
    mixin(generateFunQt(17041, "qteQDateTimeEdit_timeSpec",            "QDateTimeEdit"));
    mixin(generateFunQt(17042, "qteQDateTimeEdit_setTimeSpec",         "QDateTimeEdit"));
    mixin(generateFunQt(17043, "qteQDateTimeEdit_setEventHandler",     "QDateTimeEdit"));
    mixin(generateFunQt(17044, "qteQDateTimeEdit_connect_dateTimeChanged","QDateTimeEdit"));
    mixin(generateFunQt(17045, "qteQDateTimeEdit_connect_timeChanged", "QDateTimeEdit"));
    mixin(generateFunQt(17046, "qteQDateTimeEdit_connect_dateChanged", "QDateTimeEdit"));
    // QDateEdit — та же DLL, что и QDateTimeEdit
    mixin(generateFunQt(17100, "qteQDateEdit_create",                  "QDateTimeEdit"));
    mixin(generateFunQt(17101, "qteQDateEdit_delete",                  "QDateTimeEdit"));
    mixin(generateFunQt(17102, "qteQDateEdit_show",                    "QDateTimeEdit"));
    mixin(generateFunQt(17103, "qteQDateEdit_hide",                    "QDateTimeEdit"));
    mixin(generateFunQt(17104, "qteQDateEdit_update",                  "QDateTimeEdit"));
    mixin(generateFunQt(17105, "qteQDateEdit_setEventHandler",         "QDateTimeEdit"));
    mixin(generateFunQt(17106, "qteQDateEdit_connect_userDateChanged", "QDateTimeEdit"));
    // QTimeEdit — та же DLL
    mixin(generateFunQt(17200, "qteQTimeEdit_create",                  "QDateTimeEdit"));
    mixin(generateFunQt(17201, "qteQTimeEdit_delete",                  "QDateTimeEdit"));
    mixin(generateFunQt(17202, "qteQTimeEdit_show",                    "QDateTimeEdit"));
    mixin(generateFunQt(17203, "qteQTimeEdit_hide",                    "QDateTimeEdit"));
    mixin(generateFunQt(17204, "qteQTimeEdit_update",                  "QDateTimeEdit"));
    mixin(generateFunQt(17205, "qteQTimeEdit_setEventHandler",         "QDateTimeEdit"));
    mixin(generateFunQt(17206, "qteQTimeEdit_connect_userTimeChanged", "QDateTimeEdit"));
}

static this() {
    registerModule("QDateTimeEdit", "qte56_widgets.dll", &loadQDateTimeEdit);
}

// ====================================================================
// QDateTimeEdit — класс-обёртка
// ====================================================================

/// D wrapper for QDateTimeEdit. d_parent = QAbstractSpinBox.
@live class QDateTimeEdit : QAbstractSpinBox {
protected:
    protected this(bool _noOp) { super(_noOp); }  // no-op для wrap() и super(true)

public:
    this(void* parent = null) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[17000])(parent);
    }

    // ── date ────────────────────────────────────────────────────────────────
    DDate date() {
        DDate r;
        (cast(t_v__qp_ip_ip_ip)pFunQt[17005])(_wh, &r.year, &r.month, &r.day);
        return r;
    }
    /// Returns the current date as a QDate value-type object (D-owned).
    QDate qdate() { auto d = date(); return new QDate(d.year, d.month, d.day); }

    QDateTimeEdit setDate(int year, int month, int day) {
        (cast(t_v__qp_i_i_i)pFunQt[17006])(_wh, year, month, day);
        return this;
    }
    QDateTimeEdit setDate(DDate d) { setDate(d.year, d.month, d.day); return this; }
    QDateTimeEdit setDate(QDate d) { setDate(d.year(), d.month(), d.day()); return this; }

    // ── time ────────────────────────────────────────────────────────────────
    DTime time() {
        DTime r;
        (cast(t_v__qp_ip_ip_ip_ip)pFunQt[17007])(_wh, &r.hour, &r.minute, &r.second, &r.msec);
        return r;
    }
    /// Returns the current time as a QTime value-type object (D-owned).
    QTime qtime() { auto t = time(); return new QTime(t.hour, t.minute, t.second, t.msec); }

    QDateTimeEdit setTime(int hour, int minute, int second, int msec = 0) {
        (cast(t_v__qp_i_i_i_i)pFunQt[17008])(_wh, hour, minute, second, msec);
        return this;
    }
    QDateTimeEdit setTime(DTime t) { setTime(t.hour, t.minute, t.second, t.msec); return this; }
    QDateTimeEdit setTime(QTime t) { setTime(t.hour(), t.minute(), t.second(), t.msec()); return this; }

    // ── dateTime ─────────────────────────────────────────────────────────────
    DDateTime dateTime() {
        DDateTime r;
        (cast(t_v__qp_ip_ip_ip_ip_ip_ip_ip)pFunQt[17009])(
            _wh, &r.year, &r.month, &r.day, &r.hour, &r.minute, &r.second, &r.msec);
        return r;
    }
    /// Returns the current datetime as a QDateTime value-type object (D-owned).
    QDateTime qdateTime() {
        auto dt = dateTime();
        return new QDateTime(new QDate(dt.year, dt.month, dt.day),
                             new QTime(dt.hour, dt.minute, dt.second, dt.msec));
    }
    QDateTimeEdit setDateTime(int year, int month, int day, int hour, int minute, int second, int msec = 0) {
        (cast(t_v__qp_i_i_i_i_i_i_i)pFunQt[17010])(_wh, year, month, day, hour, minute, second, msec);
        return this;
    }
    QDateTimeEdit setDateTime(DDateTime dt) {
        setDateTime(dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second, dt.msec);
        return this;
    }
    QDateTimeEdit setDateTime(QDateTime dt) {
        setDateTime(dt.year(), dt.month(), dt.day(), dt.hour(), dt.minute(), dt.second(), dt.msec());
        return this;
    }

    // ── minimumDate / maximumDate ────────────────────────────────────────────
    DDate minimumDate() {
        DDate r;
        (cast(t_v__qp_ip_ip_ip)pFunQt[17011])(_wh, &r.year, &r.month, &r.day);
        return r;
    }
    QDate minimumQDate() { auto d = minimumDate(); return new QDate(d.year, d.month, d.day); }
    QDateTimeEdit setMinimumDate(int y, int mo, int d) {
        (cast(t_v__qp_i_i_i)pFunQt[17012])(_wh, y, mo, d);
        return this;
    }
    QDateTimeEdit setMinimumDate(DDate d) { setMinimumDate(d.year, d.month, d.day); return this; }
    QDateTimeEdit setMinimumDate(QDate d) { setMinimumDate(d.year(), d.month(), d.day()); return this; }
    QDateTimeEdit clearMinimumDate() { (cast(t_v__qp)pFunQt[17013])(_wh); return this; }

    DDate maximumDate() {
        DDate r;
        (cast(t_v__qp_ip_ip_ip)pFunQt[17014])(_wh, &r.year, &r.month, &r.day);
        return r;
    }
    QDate maximumQDate() { auto d = maximumDate(); return new QDate(d.year, d.month, d.day); }
    QDateTimeEdit setMaximumDate(int y, int mo, int d) {
        (cast(t_v__qp_i_i_i)pFunQt[17015])(_wh, y, mo, d);
        return this;
    }
    QDateTimeEdit setMaximumDate(DDate d) { setMaximumDate(d.year, d.month, d.day); return this; }
    QDateTimeEdit setMaximumDate(QDate d) { setMaximumDate(d.year(), d.month(), d.day()); return this; }
    QDateTimeEdit clearMaximumDate() { (cast(t_v__qp)pFunQt[17016])(_wh); return this; }

    QDateTimeEdit setDateRange(int y1, int mo1, int d1, int y2, int mo2, int d2) {
        (cast(t_v__qp_i_i_i_i_i_i)pFunQt[17017])(_wh, y1, mo1, d1, y2, mo2, d2);
        return this;
    }
    QDateTimeEdit setDateRange(QDate from, QDate to) {
        setDateRange(from.year(), from.month(), from.day(), to.year(), to.month(), to.day());
        return this;
    }

    // ── minimumTime / maximumTime ────────────────────────────────────────────
    DTime minimumTime() {
        DTime r;
        (cast(t_v__qp_ip_ip_ip_ip)pFunQt[17018])(_wh, &r.hour, &r.minute, &r.second, &r.msec);
        return r;
    }
    QTime minimumQTime() { auto t = minimumTime(); return new QTime(t.hour, t.minute, t.second, t.msec); }
    QDateTimeEdit setMinimumTime(int h, int mi, int s, int ms = 0) {
        (cast(t_v__qp_i_i_i_i)pFunQt[17019])(_wh, h, mi, s, ms);
        return this;
    }
    QDateTimeEdit setMinimumTime(DTime t) { setMinimumTime(t.hour, t.minute, t.second, t.msec); return this; }
    QDateTimeEdit setMinimumTime(QTime t) { setMinimumTime(t.hour(), t.minute(), t.second(), t.msec()); return this; }
    QDateTimeEdit clearMinimumTime() { (cast(t_v__qp)pFunQt[17020])(_wh); return this; }

    DTime maximumTime() {
        DTime r;
        (cast(t_v__qp_ip_ip_ip_ip)pFunQt[17021])(_wh, &r.hour, &r.minute, &r.second, &r.msec);
        return r;
    }
    QTime maximumQTime() { auto t = maximumTime(); return new QTime(t.hour, t.minute, t.second, t.msec); }
    QDateTimeEdit setMaximumTime(int h, int mi, int s, int ms = 0) {
        (cast(t_v__qp_i_i_i_i)pFunQt[17022])(_wh, h, mi, s, ms);
        return this;
    }
    QDateTimeEdit setMaximumTime(DTime t) { setMaximumTime(t.hour, t.minute, t.second, t.msec); return this; }
    QDateTimeEdit setMaximumTime(QTime t) { setMaximumTime(t.hour(), t.minute(), t.second(), t.msec()); return this; }
    QDateTimeEdit clearMaximumTime() { (cast(t_v__qp)pFunQt[17023])(_wh); return this; }

    // ── minimumDateTime / maximumDateTime ────────────────────────────────────
    DDateTime minimumDateTime() {
        DDateTime r;
        (cast(t_v__qp_ip_ip_ip_ip_ip_ip_ip)pFunQt[17024])(
            _wh, &r.year, &r.month, &r.day, &r.hour, &r.minute, &r.second, &r.msec);
        return r;
    }
    QDateTime minimumQDateTime() {
        auto dt = minimumDateTime();
        return new QDateTime(new QDate(dt.year, dt.month, dt.day),
                             new QTime(dt.hour, dt.minute, dt.second, dt.msec));
    }
    QDateTimeEdit setMinimumDateTime(int y, int mo, int d, int h, int mi, int s, int ms = 0) {
        (cast(t_v__qp_i_i_i_i_i_i_i)pFunQt[17025])(_wh, y, mo, d, h, mi, s, ms);
        return this;
    }
    QDateTimeEdit setMinimumDateTime(DDateTime dt) {
        setMinimumDateTime(dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second, dt.msec);
        return this;
    }
    QDateTimeEdit setMinimumDateTime(QDateTime dt) {
        setMinimumDateTime(dt.year(), dt.month(), dt.day(), dt.hour(), dt.minute(), dt.second(), dt.msec());
        return this;
    }
    QDateTimeEdit clearMinimumDateTime() { (cast(t_v__qp)pFunQt[17026])(_wh); return this; }

    DDateTime maximumDateTime() {
        DDateTime r;
        (cast(t_v__qp_ip_ip_ip_ip_ip_ip_ip)pFunQt[17027])(
            _wh, &r.year, &r.month, &r.day, &r.hour, &r.minute, &r.second, &r.msec);
        return r;
    }
    QDateTime maximumQDateTime() {
        auto dt = maximumDateTime();
        return new QDateTime(new QDate(dt.year, dt.month, dt.day),
                             new QTime(dt.hour, dt.minute, dt.second, dt.msec));
    }
    QDateTimeEdit setMaximumDateTime(int y, int mo, int d, int h, int mi, int s, int ms = 0) {
        (cast(t_v__qp_i_i_i_i_i_i_i)pFunQt[17028])(_wh, y, mo, d, h, mi, s, ms);
        return this;
    }
    QDateTimeEdit setMaximumDateTime(DDateTime dt) {
        setMaximumDateTime(dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second, dt.msec);
        return this;
    }
    QDateTimeEdit setMaximumDateTime(QDateTime dt) {
        setMaximumDateTime(dt.year(), dt.month(), dt.day(), dt.hour(), dt.minute(), dt.second(), dt.msec());
        return this;
    }
    QDateTimeEdit clearMaximumDateTime() { (cast(t_v__qp)pFunQt[17029])(_wh); return this; }

    // ── displayFormat ────────────────────────────────────────────────────────
    string displayFormat() {
        void* _qs = (cast(t_qp__qp)pFunQt[17030])(_wh);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }
    QDateTimeEdit setDisplayFormat(string fmt) {
        auto _ws = toQString(fmt);
        (cast(t_v__qp_qp)pFunQt[17031])(_wh, _ws);
        (cast(t_v__qp)pFunQt[22])(_ws);
        return this;
    }

    // ── calendarPopup ────────────────────────────────────────────────────────
    bool calendarPopup() { return cast(bool)(cast(t_i__qp)pFunQt[17032])(_wh); }
    QDateTimeEdit setCalendarPopup(bool enable) {
        (cast(t_v__qp_i)pFunQt[17033])(_wh, enable ? 1 : 0);
        return this;
    }

    // ── section ──────────────────────────────────────────────────────────────
    int currentSection() { return (cast(t_i__qp)pFunQt[17034])(_wh); }
    QDateTimeEdit setCurrentSection(int section) { (cast(t_v__qp_i)pFunQt[17035])(_wh, section); return this; }
    int currentSectionIndex() { return (cast(t_i__qp)pFunQt[17036])(_wh); }
    QDateTimeEdit setCurrentSectionIndex(int index) { (cast(t_v__qp_i)pFunQt[17037])(_wh, index); return this; }
    int sectionCount() { return (cast(t_i__qp)pFunQt[17038])(_wh); }
    string sectionText(int section) {
        void* _qs = (cast(t_qp__qp_i)pFunQt[17039])(_wh, section);
        string _r = fromQString(_qs);
        (cast(t_v__qp)pFunQt[22])(_qs);
        return _r;
    }
    int sectionAt(int index) { return (cast(t_i__qp_i)pFunQt[17040])(_wh, index); }

    // ── timeSpec ─────────────────────────────────────────────────────────────
    int timeSpec() { return (cast(t_i__qp)pFunQt[17041])(_wh); }
    QDateTimeEdit setTimeSpec(int spec) { (cast(t_v__qp_i)pFunQt[17042])(_wh, spec); return this; }

    // ── event handler ────────────────────────────────────────────────────────
    override QDateTimeEdit setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[17043])(_wh, eventId, cb, dthis);
        return this;
    }
    override QDateTimeEdit onMousePress(void* cb, void* dthis = null)       { setEventHandler(1,  cb, dthis); return this; }
    override QDateTimeEdit onMouseRelease(void* cb, void* dthis = null)     { setEventHandler(2,  cb, dthis); return this; }
    override QDateTimeEdit onMouseDoubleClick(void* cb, void* dthis = null) { setEventHandler(3,  cb, dthis); return this; }
    override QDateTimeEdit onMouseMove(void* cb, void* dthis = null)        { setEventHandler(4,  cb, dthis); return this; }
    override QDateTimeEdit onKeyPress(void* cb, void* dthis = null)         { setEventHandler(5,  cb, dthis); return this; }
    override QDateTimeEdit onKeyRelease(void* cb, void* dthis = null)       { setEventHandler(6,  cb, dthis); return this; }
    override QDateTimeEdit onResize(void* cb, void* dthis = null)           { setEventHandler(7,  cb, dthis); return this; }
    override QDateTimeEdit onMove(void* cb, void* dthis = null)             { setEventHandler(8,  cb, dthis); return this; }
    override QDateTimeEdit onClose(void* cb, void* dthis = null)            { setEventHandler(9,  cb, dthis); return this; }
    override QDateTimeEdit onShow(void* cb, void* dthis = null)             { setEventHandler(10, cb, dthis); return this; }
    override QDateTimeEdit onHide(void* cb, void* dthis = null)             { setEventHandler(11, cb, dthis); return this; }
    override QDateTimeEdit onEnter(void* cb, void* dthis = null)            { setEventHandler(12, cb, dthis); return this; }
    override QDateTimeEdit onLeave(void* cb, void* dthis = null)            { setEventHandler(13, cb, dthis); return this; }
    override QDateTimeEdit onWheel(void* cb, void* dthis = null)            { setEventHandler(14, cb, dthis); return this; }
    override QDateTimeEdit onFocusIn(void* cb, void* dthis = null)          { setEventHandler(15, cb, dthis); return this; }
    override QDateTimeEdit onFocusOut(void* cb, void* dthis = null)         { setEventHandler(16, cb, dthis); return this; }
    override QDateTimeEdit onContextMenu(void* cb, void* dthis = null)      { setEventHandler(17, cb, dthis); return this; }

    // ── сигналы ──────────────────────────────────────────────────────────────
    /// cb: extern(C) void function(void* dthis, int n, int y, int mo, int d, int h, int mi, int s, int ms)
    QDateTimeEdit connect_dateTimeChanged(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[17044])(_wh, cb, dthis);
        return this;
    }
    /// cb: extern(C) void function(void* dthis, int n, int h, int mi, int s, int ms)
    QDateTimeEdit connect_timeChanged(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[17045])(_wh, cb, dthis);
        return this;
    }
    /// cb: extern(C) void function(void* dthis, int n, int year, int month, int day)
    QDateTimeEdit connect_dateChanged(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[17046])(_wh, cb, dthis);
        return this;
    }

} // class QDateTimeEdit

// ====================================================================
// QDateEdit — inherits QDateTimeEdit
// ====================================================================

/// D wrapper for QDateEdit. d_parent = QDateTimeEdit.
@live class QDateEdit : QDateTimeEdit {
protected:
    this(bool _noOp) { super(_noOp); }  // no-op для wrap() и super(true)

public:
    this(void* parent = null) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[17100])(parent);
    }

    override QDateEdit setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[17105])(_wh, eventId, cb, dthis);
        return this;
    }

    /// cb: extern(C) void function(void* dthis, int n, int year, int month, int day)
    QDateEdit connect_userDateChanged(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[17106])(_wh, cb, dthis);
        return this;
    }

} // class QDateEdit

// ====================================================================
// QTimeEdit — inherits QDateTimeEdit
// ====================================================================

/// D wrapper for QTimeEdit. d_parent = QDateTimeEdit.
@live class QTimeEdit : QDateTimeEdit {
protected:
    this(bool _noOp) { super(_noOp); }  // no-op для wrap() и super(true)

public:
    this(void* parent = null) {
        super(true);
        _qt_owned = (parent !is null);
        _wh = (cast(t_qp__qp)pFunQt[17200])(parent);
    }

    override QTimeEdit setEventHandler(int eventId, void* cb, void* dthis = null) {
        (cast(t_v__qp_i_qp_qp)pFunQt[17205])(_wh, eventId, cb, dthis);
        return this;
    }

    /// cb: extern(C) void function(void* dthis, int n, int h, int mi, int s, int ms)
    QTimeEdit connect_userTimeChanged(void* cb, void* dthis = null) {
        (cast(t_v__qp_qp_qp)pFunQt[17206])(_wh, cb, dthis);
        return this;
    }

} // class QTimeEdit
