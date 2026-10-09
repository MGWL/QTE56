#pragma once

#ifdef _WIN32
  #ifdef QTE56_QDATETIMEEDIT_BUILD
    #define DATETIMEEDIT_API __declspec(dllexport)
  #else
    #define DATETIMEEDIT_API __declspec(dllimport)
  #endif
#else
  #define DATETIMEEDIT_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── QDateTimeEdit ─────────────────────────────────────────────────────────────
DATETIMEEDIT_API void* qteQDateTimeEdit_create(void* parent);
DATETIMEEDIT_API void  qteQDateTimeEdit_delete(void* w);
DATETIMEEDIT_API void  qteQDateTimeEdit_show(void* obj);
DATETIMEEDIT_API void  qteQDateTimeEdit_hide(void* obj);
DATETIMEEDIT_API void  qteQDateTimeEdit_update(void* obj);

// date / time / dateTime getters (output params)
DATETIMEEDIT_API void qteQDateTimeEdit_date(void* obj, int* y, int* mo, int* d);
DATETIMEEDIT_API void qteQDateTimeEdit_setDate(void* obj, int y, int mo, int d);
DATETIMEEDIT_API void qteQDateTimeEdit_time(void* obj, int* h, int* mi, int* s, int* ms);
DATETIMEEDIT_API void qteQDateTimeEdit_setTime(void* obj, int h, int mi, int s, int ms);
DATETIMEEDIT_API void qteQDateTimeEdit_dateTime(void* obj, int* y, int* mo, int* d, int* h, int* mi, int* s, int* ms);
DATETIMEEDIT_API void qteQDateTimeEdit_setDateTime(void* obj, int y, int mo, int d, int h, int mi, int s, int ms);

// min/max date
DATETIMEEDIT_API void qteQDateTimeEdit_minimumDate(void* obj, int* y, int* mo, int* d);
DATETIMEEDIT_API void qteQDateTimeEdit_setMinimumDate(void* obj, int y, int mo, int d);
DATETIMEEDIT_API void qteQDateTimeEdit_clearMinimumDate(void* obj);
DATETIMEEDIT_API void qteQDateTimeEdit_maximumDate(void* obj, int* y, int* mo, int* d);
DATETIMEEDIT_API void qteQDateTimeEdit_setMaximumDate(void* obj, int y, int mo, int d);
DATETIMEEDIT_API void qteQDateTimeEdit_clearMaximumDate(void* obj);
DATETIMEEDIT_API void qteQDateTimeEdit_setDateRange(void* obj, int y1, int mo1, int d1, int y2, int mo2, int d2);

// min/max time
DATETIMEEDIT_API void qteQDateTimeEdit_minimumTime(void* obj, int* h, int* mi, int* s, int* ms);
DATETIMEEDIT_API void qteQDateTimeEdit_setMinimumTime(void* obj, int h, int mi, int s, int ms);
DATETIMEEDIT_API void qteQDateTimeEdit_clearMinimumTime(void* obj);
DATETIMEEDIT_API void qteQDateTimeEdit_maximumTime(void* obj, int* h, int* mi, int* s, int* ms);
DATETIMEEDIT_API void qteQDateTimeEdit_setMaximumTime(void* obj, int h, int mi, int s, int ms);
DATETIMEEDIT_API void qteQDateTimeEdit_clearMaximumTime(void* obj);

// min/max dateTime
DATETIMEEDIT_API void qteQDateTimeEdit_minimumDateTime(void* obj, int* y, int* mo, int* d, int* h, int* mi, int* s, int* ms);
DATETIMEEDIT_API void qteQDateTimeEdit_setMinimumDateTime(void* obj, int y, int mo, int d, int h, int mi, int s, int ms);
DATETIMEEDIT_API void qteQDateTimeEdit_clearMinimumDateTime(void* obj);
DATETIMEEDIT_API void qteQDateTimeEdit_maximumDateTime(void* obj, int* y, int* mo, int* d, int* h, int* mi, int* s, int* ms);
DATETIMEEDIT_API void qteQDateTimeEdit_setMaximumDateTime(void* obj, int y, int mo, int d, int h, int mi, int s, int ms);
DATETIMEEDIT_API void qteQDateTimeEdit_clearMaximumDateTime(void* obj);

// display / popup / section
DATETIMEEDIT_API void* qteQDateTimeEdit_displayFormat(void* obj);
DATETIMEEDIT_API void  qteQDateTimeEdit_setDisplayFormat(void* obj, void* fmt);
DATETIMEEDIT_API int   qteQDateTimeEdit_calendarPopup(void* obj);
DATETIMEEDIT_API void  qteQDateTimeEdit_setCalendarPopup(void* obj, int enable);
DATETIMEEDIT_API int   qteQDateTimeEdit_currentSection(void* obj);
DATETIMEEDIT_API void  qteQDateTimeEdit_setCurrentSection(void* obj, int section);
DATETIMEEDIT_API int   qteQDateTimeEdit_currentSectionIndex(void* obj);
DATETIMEEDIT_API void  qteQDateTimeEdit_setCurrentSectionIndex(void* obj, int index);
DATETIMEEDIT_API int   qteQDateTimeEdit_sectionCount(void* obj);
DATETIMEEDIT_API void* qteQDateTimeEdit_sectionText(void* obj, int section);
DATETIMEEDIT_API int   qteQDateTimeEdit_sectionAt(void* obj, int index);
DATETIMEEDIT_API int   qteQDateTimeEdit_timeSpec(void* obj);
DATETIMEEDIT_API void  qteQDateTimeEdit_setTimeSpec(void* obj, int spec);

// event handler + signals
DATETIMEEDIT_API void qteQDateTimeEdit_setEventHandler(void* w, int id, void* cb, void* dthis);
DATETIMEEDIT_API void qteQDateTimeEdit_connect_dateTimeChanged(void* obj, void* cb, void* dthis);
DATETIMEEDIT_API void qteQDateTimeEdit_connect_timeChanged(void* obj, void* cb, void* dthis);
DATETIMEEDIT_API void qteQDateTimeEdit_connect_dateChanged(void* obj, void* cb, void* dthis);

// ── QDateEdit ─────────────────────────────────────────────────────────────────
DATETIMEEDIT_API void* qteQDateEdit_create(void* parent);
DATETIMEEDIT_API void  qteQDateEdit_delete(void* w);
DATETIMEEDIT_API void  qteQDateEdit_show(void* obj);
DATETIMEEDIT_API void  qteQDateEdit_hide(void* obj);
DATETIMEEDIT_API void  qteQDateEdit_update(void* obj);
DATETIMEEDIT_API void  qteQDateEdit_setEventHandler(void* w, int id, void* cb, void* dthis);
DATETIMEEDIT_API void  qteQDateEdit_connect_userDateChanged(void* obj, void* cb, void* dthis);

// ── QTimeEdit ─────────────────────────────────────────────────────────────────
DATETIMEEDIT_API void* qteQTimeEdit_create(void* parent);
DATETIMEEDIT_API void  qteQTimeEdit_delete(void* w);
DATETIMEEDIT_API void  qteQTimeEdit_show(void* obj);
DATETIMEEDIT_API void  qteQTimeEdit_hide(void* obj);
DATETIMEEDIT_API void  qteQTimeEdit_update(void* obj);
DATETIMEEDIT_API void  qteQTimeEdit_setEventHandler(void* w, int id, void* cb, void* dthis);
DATETIMEEDIT_API void  qteQTimeEdit_connect_userTimeChanged(void* obj, void* cb, void* dthis);

} // extern "C"
