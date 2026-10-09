// ===GENERATOR-INFO-START===
// generator: main.py 2.1.0-knowledge
// timestamp: 2026-07-25T22:55:54
// command: python main.py C:/Qt5_13_2/5.13.2/mingw73_32/include/QtCore/qrect.h --module QRectF --qt-mod core --cpp-out ../cpp/qt5/qte56_qrectf --d-out ../d/gen --index-start 21900
// header: C:/Qt5_13_2/5.13.2/mingw73_32/include/QtCore/qrect.h
// qt: 5.13.2
// module: QRectF
// dll: qte56_qrectf.dll
// d-parent: (root class)
// index-block: 21900 (--index-start)
// index-range: 21900-21948
// knowledge: qt_knowledge.json 2026-07-25T21:58:10
// methods: 47 wrapper(s), 0 signal(s), lifecycle=no
// skipped-unsupported: 6
//   void getRect(qreal*, qreal*, qreal*, qreal*) [method] — param type 'qreal*'
//   void getCoords(qreal*, qreal*, qreal*, qreal*) [method] — param type 'qreal*'
//   QSizeF size() [method] — return type 'QSizeF'
//   void setSize(const QSizeF&) [method] — param type 'const QSizeF&'
//   QRectF marginsAdded(const QMarginsF&) [method] — param type 'const QMarginsF&'
//   QRectF marginsRemoved(const QMarginsF&) [method] — param type 'const QMarginsF&'
// ===GENERATOR-INFO-END===
#pragma once

#ifdef _WIN32
  #ifdef QTE56_QRECTF_BUILD
    #define QRECTF_API __declspec(dllexport)
  #else
    #define QRECTF_API __declspec(dllimport)
  #endif
#else
  #define QRECTF_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QRECTF_API void* qteQRectF_create(void* parent);
QRECTF_API void  qteQRectF_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QRECTF_API int qteQRectF_isNull(void* _obj);
QRECTF_API int qteQRectF_isEmpty(void* _obj);
QRECTF_API int qteQRectF_isValid(void* _obj);
QRECTF_API void* qteQRectF_normalized(void* _obj);
QRECTF_API double qteQRectF_x(void* _obj);
QRECTF_API double qteQRectF_y(void* _obj);
QRECTF_API void qteQRectF_setLeft(void* _obj, double pos);
QRECTF_API void qteQRectF_setTop(void* _obj, double pos);
QRECTF_API void qteQRectF_setRight(void* _obj, double pos);
QRECTF_API void qteQRectF_setBottom(void* _obj, double pos);
QRECTF_API void* qteQRectF_center(void* _obj);
QRECTF_API void qteQRectF_setTopLeft(void* _obj, void* p);
QRECTF_API void qteQRectF_setBottomRight(void* _obj, void* p);
QRECTF_API void qteQRectF_setTopRight(void* _obj, void* p);
QRECTF_API void qteQRectF_setBottomLeft(void* _obj, void* p);
QRECTF_API void qteQRectF_moveLeft(void* _obj, double pos);
QRECTF_API void qteQRectF_moveTop(void* _obj, double pos);
QRECTF_API void qteQRectF_moveRight(void* _obj, double pos);
QRECTF_API void qteQRectF_moveBottom(void* _obj, double pos);
QRECTF_API void qteQRectF_moveTopLeft(void* _obj, void* p);
QRECTF_API void qteQRectF_moveBottomRight(void* _obj, void* p);
QRECTF_API void qteQRectF_moveTopRight(void* _obj, void* p);
QRECTF_API void qteQRectF_moveBottomLeft(void* _obj, void* p);
QRECTF_API void qteQRectF_moveCenter(void* _obj, void* p);
QRECTF_API void qteQRectF_translate_dd(void* _obj, double dx, double dy);
QRECTF_API void qteQRectF_translate_pf(void* _obj, void* p);
QRECTF_API void* qteQRectF_translated_dd(void* _obj, double dx, double dy);
QRECTF_API void* qteQRectF_translated_pf(void* _obj, void* p);
QRECTF_API void* qteQRectF_transposed(void* _obj);
QRECTF_API void qteQRectF_moveTo_dd(void* _obj, double x, double y);
QRECTF_API void qteQRectF_moveTo_pf(void* _obj, void* p);
QRECTF_API void qteQRectF_setRect(void* _obj, double x, double y, double w, double h);
QRECTF_API void qteQRectF_setCoords(void* _obj, double x1, double y1, double x2, double y2);
QRECTF_API void qteQRectF_adjust(void* _obj, double x1, double y1, double x2, double y2);
QRECTF_API void* qteQRectF_adjusted(void* _obj, double x1, double y1, double x2, double y2);
QRECTF_API double qteQRectF_width(void* _obj);
QRECTF_API double qteQRectF_height(void* _obj);
QRECTF_API void qteQRectF_setWidth(void* _obj, double w);
QRECTF_API void qteQRectF_setHeight(void* _obj, double h);
QRECTF_API int qteQRectF_contains_rf(void* _obj, void* r);
QRECTF_API int qteQRectF_contains_pf(void* _obj, void* p);
QRECTF_API int qteQRectF_contains_dd(void* _obj, double x, double y);
QRECTF_API void* qteQRectF_united(void* _obj, void* other);
QRECTF_API void* qteQRectF_intersected(void* _obj, void* other);
QRECTF_API int qteQRectF_intersects(void* _obj, void* r);
QRECTF_API void* qteQRectF_toRect(void* _obj);
QRECTF_API void* qteQRectF_toAlignedRect(void* _obj);

} // extern "C"
