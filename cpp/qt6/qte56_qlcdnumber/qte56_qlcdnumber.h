#pragma once

#ifdef _WIN32
  #ifdef QTE56_QLCDNUMBER_BUILD
    #define QLCDNUMBER_API __declspec(dllexport)
  #else
    #define QLCDNUMBER_API __declspec(dllimport)
  #endif
#else
  #define QLCDNUMBER_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QLCDNUMBER_API void* qteQLCDNumber_create(void* parent);
QLCDNUMBER_API void  qteQLCDNumber_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QLCDNUMBER_API int qteQLCDNumber_smallDecimalPoint(void* _obj);
QLCDNUMBER_API int qteQLCDNumber_digitCount(void* _obj);
QLCDNUMBER_API void qteQLCDNumber_setDigitCount(void* _obj, int nDigits);
QLCDNUMBER_API int qteQLCDNumber_checkOverflow_d(void* _obj, double num);
QLCDNUMBER_API int qteQLCDNumber_checkOverflow_i(void* _obj, int num);
QLCDNUMBER_API int qteQLCDNumber_mode(void* _obj);
QLCDNUMBER_API void qteQLCDNumber_setMode(void* _obj, int p0);
QLCDNUMBER_API int qteQLCDNumber_segmentStyle(void* _obj);
QLCDNUMBER_API void qteQLCDNumber_setSegmentStyle(void* _obj, int p0);
QLCDNUMBER_API double qteQLCDNumber_value(void* _obj);
QLCDNUMBER_API int qteQLCDNumber_intValue(void* _obj);
QLCDNUMBER_API void qteQLCDNumber_display_s(void* _obj, void* str);
QLCDNUMBER_API void qteQLCDNumber_display_i(void* _obj, int num);
QLCDNUMBER_API void qteQLCDNumber_display_d(void* _obj, double num);
QLCDNUMBER_API void qteQLCDNumber_setHexMode(void* _obj);
QLCDNUMBER_API void qteQLCDNumber_setDecMode(void* _obj);
QLCDNUMBER_API void qteQLCDNumber_setOctMode(void* _obj);
QLCDNUMBER_API void qteQLCDNumber_setBinMode(void* _obj);
QLCDNUMBER_API void qteQLCDNumber_setSmallDecimalPoint(void* _obj, int p0);

// ── Event handler ────────────────────────────────────────────────────────────
QLCDNUMBER_API void qteQLCDNumber_setEventHandler(void* w, int id, void* cb, void* dthis);

} // extern "C"
