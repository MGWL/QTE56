#ifndef QTE56_QCALENDARWIDGET_H
#define QTE56_QCALENDARWIDGET_H

#ifdef _WIN32
#  define CALENDAR_API __declspec(dllexport)
#else
#  define CALENDAR_API
#endif

extern "C" {

// lifecycle
CALENDAR_API void* qteQCalendarWidget_create(void* parent);
CALENDAR_API void  qteQCalendarWidget_destroy(void* obj);

// selectedDate
CALENDAR_API void qteQCalendarWidget_selectedDate(void* obj, int* y, int* mo, int* d);
CALENDAR_API void qteQCalendarWidget_setSelectedDate(void* obj, int y, int mo, int d);

// yearShown / monthShown
CALENDAR_API int  qteQCalendarWidget_yearShown(void* obj);
CALENDAR_API int  qteQCalendarWidget_monthShown(void* obj);

// minimumDate / maximumDate
CALENDAR_API void qteQCalendarWidget_minimumDate(void* obj, int* y, int* mo, int* d);
CALENDAR_API void qteQCalendarWidget_setMinimumDate(void* obj, int y, int mo, int d);
CALENDAR_API void qteQCalendarWidget_maximumDate(void* obj, int* y, int* mo, int* d);
CALENDAR_API void qteQCalendarWidget_setMaximumDate(void* obj, int y, int mo, int d);

// firstDayOfWeek
CALENDAR_API int  qteQCalendarWidget_firstDayOfWeek(void* obj);
CALENDAR_API void qteQCalendarWidget_setFirstDayOfWeek(void* obj, int dayOfWeek);

// navigationBarVisible / gridVisible
CALENDAR_API int  qteQCalendarWidget_isNavigationBarVisible(void* obj);
CALENDAR_API void qteQCalendarWidget_setNavigationBarVisible(void* obj, int v);
CALENDAR_API int  qteQCalendarWidget_isGridVisible(void* obj);
CALENDAR_API void qteQCalendarWidget_setGridVisible(void* obj, int v);

// selectionMode
CALENDAR_API int  qteQCalendarWidget_selectionMode(void* obj);
CALENDAR_API void qteQCalendarWidget_setSelectionMode(void* obj, int mode);

// horizontalHeaderFormat / verticalHeaderFormat
CALENDAR_API int  qteQCalendarWidget_horizontalHeaderFormat(void* obj);
CALENDAR_API void qteQCalendarWidget_setHorizontalHeaderFormat(void* obj, int fmt);
CALENDAR_API int  qteQCalendarWidget_verticalHeaderFormat(void* obj);
CALENDAR_API void qteQCalendarWidget_setVerticalHeaderFormat(void* obj, int fmt);

// dateEditEnabled / dateEditAcceptDelay
CALENDAR_API int  qteQCalendarWidget_isDateEditEnabled(void* obj);
CALENDAR_API void qteQCalendarWidget_setDateEditEnabled(void* obj, int v);
CALENDAR_API int  qteQCalendarWidget_dateEditAcceptDelay(void* obj);
CALENDAR_API void qteQCalendarWidget_setDateEditAcceptDelay(void* obj, int delay);

// navigation slots
CALENDAR_API void qteQCalendarWidget_setDateRange(void* obj, int y1, int mo1, int d1, int y2, int mo2, int d2);
CALENDAR_API void qteQCalendarWidget_setCurrentPage(void* obj, int year, int month);
CALENDAR_API void qteQCalendarWidget_showNextMonth(void* obj);
CALENDAR_API void qteQCalendarWidget_showPreviousMonth(void* obj);
CALENDAR_API void qteQCalendarWidget_showNextYear(void* obj);
CALENDAR_API void qteQCalendarWidget_showPreviousYear(void* obj);
CALENDAR_API void qteQCalendarWidget_showSelectedDate(void* obj);
CALENDAR_API void qteQCalendarWidget_showToday(void* obj);

// event handler
CALENDAR_API void qteQCalendarWidget_setEventHandler(void* w, int id, void* cb, void* dthis);

// signals
CALENDAR_API void qteQCalendarWidget_connect_selectionChanged(void* obj, void* cb, void* dthis);
CALENDAR_API void qteQCalendarWidget_connect_clicked(void* obj, void* cb, void* dthis);
CALENDAR_API void qteQCalendarWidget_connect_activated(void* obj, void* cb, void* dthis);
CALENDAR_API void qteQCalendarWidget_connect_currentPageChanged(void* obj, void* cb, void* dthis);

} // extern "C"

#endif // QTE56_QCALENDARWIDGET_H
