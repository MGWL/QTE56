#ifndef QTE56_QDATETIME_BUILD
#define QTE56_QDATETIME_BUILD
#endif
#include "qte56_qdatetime.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include <QDate>
#include <QTime>
#include <QDateTime>
#include <QString>

extern "C" {

// ═══════════════════════════════════════════════════════════════════════
// QDate  (value type — heap-allocated, D owns and deletes)
// ═══════════════════════════════════════════════════════════════════════

// ── Lifecycle ────────────────────────────────────────────────────────
void* qteQDate_create() {
    return new QDate();
}
void* qteQDate_createYMD(int y, int m, int d) {
    return new QDate(y, m, d);
}
void  qteQDate_delete(void* p) {
    delete (QDate*)p;
}
void* qteQDate_copy(void* p) {
    return new QDate(*(QDate*)p);
}

// ── Fields ───────────────────────────────────────────────────────────
int  qteQDate_year (void* p) { return ((QDate*)p)->year();  }
int  qteQDate_month(void* p) { return ((QDate*)p)->month(); }
int  qteQDate_day  (void* p) { return ((QDate*)p)->day();   }

// ── Setters ──────────────────────────────────────────────────────────
int  qteQDate_setDate(void* p, int y, int m, int d) {
    return ((QDate*)p)->setDate(y, m, d) ? 1 : 0;
}

// ── Validity ─────────────────────────────────────────────────────────
int  qteQDate_isValid(void* p) { return ((QDate*)p)->isValid() ? 1 : 0; }
int  qteQDate_isNull (void* p) { return ((QDate*)p)->isNull()  ? 1 : 0; }

// ── Formatting ───────────────────────────────────────────────────────
// toString(custom format string)
void* qteQDate_toString(void* p, void* fmt) {
    return new QString(((QDate*)p)->toString(*(QString*)fmt));
}
// toString() — ISO date: "yyyy-MM-dd"
void* qteQDate_toStringISO(void* p) {
    return new QString(((QDate*)p)->toString(Qt::ISODate));
}

// ── Static constructors ──────────────────────────────────────────────
void* qteQDate_currentDate() {
    return new QDate(QDate::currentDate());
}
void* qteQDate_fromString(void* str, void* fmt) {
    return new QDate(QDate::fromString(*(QString*)str, *(QString*)fmt));
}
void* qteQDate_fromJulianDay(int jd) {
    return new QDate(QDate::fromJulianDay(jd));
}
int   qteQDate_isLeapYear(int year) {
    return QDate::isLeapYear(year) ? 1 : 0;
}

// ── Arithmetic ───────────────────────────────────────────────────────
void* qteQDate_addDays  (void* p, int n) { return new QDate(((QDate*)p)->addDays(n));   }
void* qteQDate_addMonths(void* p, int n) { return new QDate(((QDate*)p)->addMonths(n)); }
void* qteQDate_addYears (void* p, int n) { return new QDate(((QDate*)p)->addYears(n));  }

// ── Queries ──────────────────────────────────────────────────────────
int   qteQDate_daysTo      (void* p, void* other) { return (int)((QDate*)p)->daysTo(*(QDate*)other); }
int   qteQDate_dayOfWeek   (void* p) { return ((QDate*)p)->dayOfWeek();    }
int   qteQDate_dayOfYear   (void* p) { return ((QDate*)p)->dayOfYear();    }
int   qteQDate_daysInMonth (void* p) { return ((QDate*)p)->daysInMonth();  }
int   qteQDate_daysInYear  (void* p) { return ((QDate*)p)->daysInYear();   }
int   qteQDate_toJulianDay (void* p) { return (int)((QDate*)p)->toJulianDay(); }

// ── Comparison ───────────────────────────────────────────────────────
int   qteQDate_equal  (void* a, void* b) { return (*(QDate*)a == *(QDate*)b) ? 1 : 0; }
int   qteQDate_less   (void* a, void* b) { return (*(QDate*)a <  *(QDate*)b) ? 1 : 0; }

// ═══════════════════════════════════════════════════════════════════════
// QTime  (value type)
// ═══════════════════════════════════════════════════════════════════════

// ── Lifecycle ────────────────────────────────────────────────────────
void* qteQTime_create() {
    return new QTime();
}
void* qteQTime_createHMS(int h, int m, int s, int ms) {
    return new QTime(h, m, s, ms);
}
void  qteQTime_delete(void* p) {
    delete (QTime*)p;
}
void* qteQTime_copy(void* p) {
    return new QTime(*(QTime*)p);
}

// ── Fields ───────────────────────────────────────────────────────────
int  qteQTime_hour  (void* p) { return ((QTime*)p)->hour();   }
int  qteQTime_minute(void* p) { return ((QTime*)p)->minute(); }
int  qteQTime_second(void* p) { return ((QTime*)p)->second(); }
int  qteQTime_msec  (void* p) { return ((QTime*)p)->msec();   }

// ── Setters ──────────────────────────────────────────────────────────
int  qteQTime_setHMS(void* p, int h, int m, int s, int ms) {
    return ((QTime*)p)->setHMS(h, m, s, ms) ? 1 : 0;
}

// ── Validity ─────────────────────────────────────────────────────────
int  qteQTime_isValid(void* p) { return ((QTime*)p)->isValid() ? 1 : 0; }
int  qteQTime_isNull (void* p) { return ((QTime*)p)->isNull()  ? 1 : 0; }

// ── Formatting ───────────────────────────────────────────────────────
void* qteQTime_toString(void* p, void* fmt) {
    return new QString(((QTime*)p)->toString(*(QString*)fmt));
}
void* qteQTime_toStringISO(void* p) {
    return new QString(((QTime*)p)->toString(Qt::ISODate));
}

// ── Static constructors ──────────────────────────────────────────────
void* qteQTime_currentTime() {
    return new QTime(QTime::currentTime());
}
void* qteQTime_fromString(void* str, void* fmt) {
    return new QTime(QTime::fromString(*(QString*)str, *(QString*)fmt));
}

// ── Arithmetic ───────────────────────────────────────────────────────
void* qteQTime_addSecs (void* p, int n) { return new QTime(((QTime*)p)->addSecs(n));  }
void* qteQTime_addMSecs(void* p, int n) { return new QTime(((QTime*)p)->addMSecs(n)); }

// ── Queries ──────────────────────────────────────────────────────────
int  qteQTime_secsTo (void* p, void* other) { return ((QTime*)p)->secsTo(*(QTime*)other);  }
int  qteQTime_msecsTo(void* p, void* other) { return ((QTime*)p)->msecsTo(*(QTime*)other); }
int  qteQTime_msecsSinceStartOfDay(void* p) { return ((QTime*)p)->msecsSinceStartOfDay();  }

// ── Comparison ───────────────────────────────────────────────────────
int  qteQTime_equal(void* a, void* b) { return (*(QTime*)a == *(QTime*)b) ? 1 : 0; }
int  qteQTime_less (void* a, void* b) { return (*(QTime*)a <  *(QTime*)b) ? 1 : 0; }

// ═══════════════════════════════════════════════════════════════════════
// QDateTime  (value type)
// ═══════════════════════════════════════════════════════════════════════

// ── Lifecycle ────────────────────────────────────────────────────────
void* qteQDateTime_create() {
    return new QDateTime();
}
void* qteQDateTime_createDT(void* date, void* time) {
    return new QDateTime(*(QDate*)date, *(QTime*)time);
}
void  qteQDateTime_delete(void* p) {
    delete (QDateTime*)p;
}
void* qteQDateTime_copy(void* p) {
    return new QDateTime(*(QDateTime*)p);
}

// ── Decompose ────────────────────────────────────────────────────────
void* qteQDateTime_date(void* p) { return new QDate(((QDateTime*)p)->date()); }
void* qteQDateTime_time(void* p) { return new QTime(((QDateTime*)p)->time()); }

// ── Quick accessors ──────────────────────────────────────────────────
int qteQDateTime_year  (void* p) { return ((QDateTime*)p)->date().year();   }
int qteQDateTime_month (void* p) { return ((QDateTime*)p)->date().month();  }
int qteQDateTime_day   (void* p) { return ((QDateTime*)p)->date().day();    }
int qteQDateTime_hour  (void* p) { return ((QDateTime*)p)->time().hour();   }
int qteQDateTime_minute(void* p) { return ((QDateTime*)p)->time().minute(); }
int qteQDateTime_second(void* p) { return ((QDateTime*)p)->time().second(); }
int qteQDateTime_msec  (void* p) { return ((QDateTime*)p)->time().msec();   }

// ── Setters ──────────────────────────────────────────────────────────
void qteQDateTime_setDate(void* p, void* date) {
    ((QDateTime*)p)->setDate(*(QDate*)date);
}
void qteQDateTime_setTime(void* p, void* time) {
    ((QDateTime*)p)->setTime(*(QTime*)time);
}

// ── Validity ─────────────────────────────────────────────────────────
int qteQDateTime_isValid(void* p) { return ((QDateTime*)p)->isValid() ? 1 : 0; }
int qteQDateTime_isNull (void* p) { return ((QDateTime*)p)->isNull()  ? 1 : 0; }

// ── Formatting ───────────────────────────────────────────────────────
void* qteQDateTime_toString(void* p, void* fmt) {
    return new QString(((QDateTime*)p)->toString(*(QString*)fmt));
}
void* qteQDateTime_toStringISO(void* p) {
    return new QString(((QDateTime*)p)->toString(Qt::ISODate));
}

// ── Static constructors ──────────────────────────────────────────────
void* qteQDateTime_currentDateTime() {
    return new QDateTime(QDateTime::currentDateTime());
}
void* qteQDateTime_currentDateTimeUtc() {
    return new QDateTime(QDateTime::currentDateTimeUtc());
}
void* qteQDateTime_fromString(void* str, void* fmt) {
    return new QDateTime(QDateTime::fromString(*(QString*)str, *(QString*)fmt));
}
// fromSecsSinceEpoch — epoch seconds as double (avoids int overflow)
void* qteQDateTime_fromSecsSinceEpoch(double secs) {
    return new QDateTime(QDateTime::fromSecsSinceEpoch((qint64)secs));
}
void* qteQDateTime_fromMSecsSinceEpoch(double ms) {
    return new QDateTime(QDateTime::fromMSecsSinceEpoch((qint64)ms));
}

// ── Arithmetic ───────────────────────────────────────────────────────
void* qteQDateTime_addDays  (void* p, int n) { return new QDateTime(((QDateTime*)p)->addDays(n));   }
void* qteQDateTime_addMonths(void* p, int n) { return new QDateTime(((QDateTime*)p)->addMonths(n)); }
void* qteQDateTime_addYears (void* p, int n) { return new QDateTime(((QDateTime*)p)->addYears(n));  }
void* qteQDateTime_addSecs  (void* p, int n) { return new QDateTime(((QDateTime*)p)->addSecs(n));   }
void* qteQDateTime_addMSecs (void* p, int n) { return new QDateTime(((QDateTime*)p)->addMSecs(n));  }

// ── Queries ──────────────────────────────────────────────────────────
int    qteQDateTime_daysTo            (void* p, void* other) { return (int)((QDateTime*)p)->daysTo(*(QDateTime*)other); }
double qteQDateTime_secsTo            (void* p, void* other) { return (double)((QDateTime*)p)->secsTo(*(QDateTime*)other); }
double qteQDateTime_toSecsSinceEpoch  (void* p) { return (double)((QDateTime*)p)->toSecsSinceEpoch();   }
double qteQDateTime_toMSecsSinceEpoch (void* p) { return (double)((QDateTime*)p)->toMSecsSinceEpoch();  }

// ── Comparison ───────────────────────────────────────────────────────
int qteQDateTime_equal(void* a, void* b) { return (*(QDateTime*)a == *(QDateTime*)b) ? 1 : 0; }
int qteQDateTime_less (void* a, void* b) { return (*(QDateTime*)a <  *(QDateTime*)b) ? 1 : 0; }

} // extern "C"
