// ===GENERATOR-INFO-START===
// generator: main.py 2.1.0-knowledge
// timestamp: 2026-07-25T22:55:53
// command: python main.py C:/Qt5_13_2/5.13.2/mingw73_32/include/QtCore/qpoint.h --module QPointF --qt-mod core --cpp-out ../cpp/qt5/qte56_qpointf --d-out ../d/gen --index-start 21800
// header: C:/Qt5_13_2/5.13.2/mingw73_32/include/QtCore/qpoint.h
// qt: 5.13.2
// module: QPointF
// dll: qte56_qpointf.dll
// d-parent: (root class)
// index-block: 21800 (--index-start)
// index-range: 21800-21808
// knowledge: qt_knowledge.json 2026-07-25T21:58:10
// methods: 7 wrapper(s), 0 signal(s), lifecycle=no
// skipped-unsupported: 2
//   qreal & rx() [method] — return type 'qreal &'
//   qreal & ry() [method] — return type 'qreal &'
// ===GENERATOR-INFO-END===
#pragma once

#ifdef _WIN32
  #ifdef QTE56_QPOINTF_BUILD
    #define QPOINTF_API __declspec(dllexport)
  #else
    #define QPOINTF_API __declspec(dllimport)
  #endif
#else
  #define QPOINTF_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
QPOINTF_API void* qteQPointF_create(void* parent);
QPOINTF_API void  qteQPointF_delete(void* w);

// ── Methods ──────────────────────────────────────────────────────────────
QPOINTF_API double qteQPointF_manhattanLength(void* _obj);
QPOINTF_API int qteQPointF_isNull(void* _obj);
QPOINTF_API double qteQPointF_x(void* _obj);
QPOINTF_API double qteQPointF_y(void* _obj);
QPOINTF_API void qteQPointF_setX(void* _obj, double x);
QPOINTF_API void qteQPointF_setY(void* _obj, double y);
QPOINTF_API void* qteQPointF_toPoint(void* _obj);

} // extern "C"
