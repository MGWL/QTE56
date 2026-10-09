#pragma once

#ifdef _WIN32
  #ifdef QTE56_QDATETIME_BUILD
    #define QDATETIME_API __declspec(dllexport)
  #else
    #define QDATETIME_API __declspec(dllimport)
  #endif
#else
  #define QDATETIME_API __attribute__((visibility("default")))
#endif

extern "C" {

// QDate
QDATETIME_API void* qteQDate_create();
QDATETIME_API void* qteQDate_createYMD(int y, int m, int d);
QDATETIME_API void  qteQDate_delete(void* p);
QDATETIME_API void* qteQDate_copy(void* p);
QDATETIME_API int   qteQDate_year (void* p);
QDATETIME_API int   qteQDate_month(void* p);
QDATETIME_API int   qteQDate_day  (void* p);
QDATETIME_API int   qteQDate_setDate(void* p, int y, int m, int d);
QDATETIME_API int   qteQDate_isValid(void* p);
QDATETIME_API int   qteQDate_isNull (void* p);
QDATETIME_API void* qteQDate_toString(void* p, void* fmt);
QDATETIME_API void* qteQDate_toStringISO(void* p);
QDATETIME_API void* qteQDate_currentDate();
QDATETIME_API void* qteQDate_fromString(void* str, void* fmt);
QDATETIME_API void* qteQDate_fromJulianDay(int jd);
QDATETIME_API int   qteQDate_isLeapYear(int year);
QDATETIME_API void* qteQDate_addDays  (void* p, int n);
QDATETIME_API void* qteQDate_addMonths(void* p, int n);
QDATETIME_API void* qteQDate_addYears (void* p, int n);
QDATETIME_API int   qteQDate_daysTo      (void* p, void* other);
QDATETIME_API int   qteQDate_dayOfWeek   (void* p);
QDATETIME_API int   qteQDate_dayOfYear   (void* p);
QDATETIME_API int   qteQDate_daysInMonth (void* p);
QDATETIME_API int   qteQDate_daysInYear  (void* p);
QDATETIME_API int   qteQDate_toJulianDay (void* p);
QDATETIME_API int   qteQDate_equal  (void* a, void* b);
QDATETIME_API int   qteQDate_less   (void* a, void* b);

// QTime
QDATETIME_API void* qteQTime_create();
QDATETIME_API void* qteQTime_createHMS(int h, int m, int s, int ms);
QDATETIME_API void  qteQTime_delete(void* p);
QDATETIME_API void* qteQTime_copy(void* p);
QDATETIME_API int   qteQTime_hour  (void* p);
QDATETIME_API int   qteQTime_minute(void* p);
QDATETIME_API int   qteQTime_second(void* p);
QDATETIME_API int   qteQTime_msec  (void* p);
QDATETIME_API int   qteQTime_setHMS(void* p, int h, int m, int s, int ms);
QDATETIME_API int   qteQTime_isValid(void* p);
QDATETIME_API int   qteQTime_isNull (void* p);
QDATETIME_API void* qteQTime_toString(void* p, void* fmt);
QDATETIME_API void* qteQTime_toStringISO(void* p);
QDATETIME_API void* qteQTime_currentTime();
QDATETIME_API void* qteQTime_fromString(void* str, void* fmt);
QDATETIME_API void* qteQTime_addSecs (void* p, int n);
QDATETIME_API void* qteQTime_addMSecs(void* p, int n);
QDATETIME_API int   qteQTime_secsTo (void* p, void* other);
QDATETIME_API int   qteQTime_msecsTo(void* p, void* other);
QDATETIME_API int   qteQTime_msecsSinceStartOfDay(void* p);
QDATETIME_API int   qteQTime_equal(void* a, void* b);
QDATETIME_API int   qteQTime_less (void* a, void* b);

// QDateTime
QDATETIME_API void* qteQDateTime_create();
QDATETIME_API void* qteQDateTime_createDT(void* date, void* time);
QDATETIME_API void  qteQDateTime_delete(void* p);
QDATETIME_API void* qteQDateTime_copy(void* p);
QDATETIME_API void* qteQDateTime_date(void* p);
QDATETIME_API void* qteQDateTime_time(void* p);
QDATETIME_API int   qteQDateTime_year  (void* p);
QDATETIME_API int   qteQDateTime_month (void* p);
QDATETIME_API int   qteQDateTime_day   (void* p);
QDATETIME_API int   qteQDateTime_hour  (void* p);
QDATETIME_API int   qteQDateTime_minute(void* p);
QDATETIME_API int   qteQDateTime_second(void* p);
QDATETIME_API int   qteQDateTime_msec  (void* p);
QDATETIME_API void  qteQDateTime_setDate(void* p, void* date);
QDATETIME_API void  qteQDateTime_setTime(void* p, void* time);
QDATETIME_API int   qteQDateTime_isValid(void* p);
QDATETIME_API int   qteQDateTime_isNull (void* p);
QDATETIME_API void* qteQDateTime_toString(void* p, void* fmt);
QDATETIME_API void* qteQDateTime_toStringISO(void* p);
QDATETIME_API void* qteQDateTime_currentDateTime();
QDATETIME_API void* qteQDateTime_currentDateTimeUtc();
QDATETIME_API void* qteQDateTime_fromString(void* str, void* fmt);
QDATETIME_API void* qteQDateTime_fromSecsSinceEpoch(double secs);
QDATETIME_API void* qteQDateTime_fromMSecsSinceEpoch(double ms);
QDATETIME_API void* qteQDateTime_addDays  (void* p, int n);
QDATETIME_API void* qteQDateTime_addMonths(void* p, int n);
QDATETIME_API void* qteQDateTime_addYears (void* p, int n);
QDATETIME_API void* qteQDateTime_addSecs  (void* p, int n);
QDATETIME_API void* qteQDateTime_addMSecs (void* p, int n);
QDATETIME_API int    qteQDateTime_daysTo            (void* p, void* other);
QDATETIME_API double qteQDateTime_secsTo            (void* p, void* other);
QDATETIME_API double qteQDateTime_toSecsSinceEpoch  (void* p);
QDATETIME_API double qteQDateTime_toMSecsSinceEpoch (void* p);
QDATETIME_API int   qteQDateTime_equal(void* a, void* b);
QDATETIME_API int   qteQDateTime_less (void* a, void* b);

} // extern "C"
