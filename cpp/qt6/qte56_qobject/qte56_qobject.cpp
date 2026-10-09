#ifndef QTE56_QOBJECT_BUILD
#define QTE56_QOBJECT_BUILD
#endif
#include "qte56_qobject.h"

#include <QObject>
#include <QString>
#include <QThread>
#include <QEvent>

// ─────────────────────────────────────────────────────────────────────────────
// Lifecycle
// ─────────────────────────────────────────────────────────────────────────────

extern "C" QOBJECT_API void* qteQObject_create(void* parent) {
    return new QObject((QObject*)parent);
}

extern "C" QOBJECT_API void qteQObject_delete(void* _obj) {
    delete (QObject*)_obj;
}

// ─────────────────────────────────────────────────────────────────────────────
// Methods
// ─────────────────────────────────────────────────────────────────────────────

extern "C" QOBJECT_API void* qteQObject_objectName(void* _obj) {
    return new QString(((QObject*)_obj)->objectName());
}

extern "C" QOBJECT_API void qteQObject_setObjectName(void* _obj,
                                                      void* p0) {
    ((QObject*)_obj)->setObjectName(*(QString*)p0);
}

extern "C" QOBJECT_API void qteQObject_deleteLater(void* _obj) {
    ((QObject*)_obj)->deleteLater();
}

extern "C" QOBJECT_API int qteQObject_blockSignals(void* _obj, int block) {
    return ((QObject*)_obj)->blockSignals(block != 0) ? 1 : 0;
}

extern "C" QOBJECT_API int qteQObject_signalsBlocked(void* _obj) {
    return ((QObject*)_obj)->signalsBlocked() ? 1 : 0;
}

extern "C" QOBJECT_API void* qteQObject_parent(void* _obj) {
    return ((QObject*)_obj)->parent();
}

extern "C" QOBJECT_API int qteQObject_inherits(void* _obj, const char* className) {
    return ((QObject*)_obj)->inherits(className) ? 1 : 0;
}

// ── Thread affinity ─────────────────────────────────────────────────────────
// Возвращает QThread*, в котором живёт объект.
extern "C" QOBJECT_API void* qteQObject_thread(void* _obj) {
    return ((QObject*)_obj)->thread();
}

// Перемещает объект в указанный поток.
extern "C" QOBJECT_API void qteQObject_moveToThread(void* _obj, void* thread) {
    ((QObject*)_obj)->moveToThread(static_cast<QThread*>(thread));
}

// ── Timers ──────────────────────────────────────────────────────────────────
// Запускает таймер. timerType: 0=PreciseTimer, 1=CoarseTimer, 2=VeryCoarseTimer.
extern "C" QOBJECT_API int qteQObject_startTimer(void* _obj, int interval, int timerType) {
    return ((QObject*)_obj)->startTimer(interval, static_cast<Qt::TimerType>(timerType));
}

extern "C" QOBJECT_API void qteQObject_killTimer(void* _obj, int id) {
    ((QObject*)_obj)->killTimer(id);
}

// ── Object tree ─────────────────────────────────────────────────────────────
extern "C" QOBJECT_API void qteQObject_setParent(void* _obj, void* parent) {
    ((QObject*)_obj)->setParent(static_cast<QObject*>(parent));
}

extern "C" QOBJECT_API int qteQObject_isWidgetType(void* _obj) {
    return ((QObject*)_obj)->isWidgetType() ? 1 : 0;
}

extern "C" QOBJECT_API int qteQObject_isWindowType(void* _obj) {
    return ((QObject*)_obj)->isWindowType() ? 1 : 0;
}

extern "C" QOBJECT_API int qteQObject_childrenCount(void* _obj) {
    return ((QObject*)_obj)->children().size();
}

extern "C" QOBJECT_API void* qteQObject_childrenAt(void* _obj, int index) {
    const QObjectList& children = ((QObject*)_obj)->children();
    if (index < 0 || index >= children.size())
        return nullptr;
    return children.at(index);
}

// ── Event handling ──────────────────────────────────────────────────────────
// event и eventFilter принимают QEvent* как void*.
extern "C" QOBJECT_API int qteQObject_event(void* _obj, void* event) {
    return ((QObject*)_obj)->event(static_cast<QEvent*>(event)) ? 1 : 0;
}

extern "C" QOBJECT_API int qteQObject_eventFilter(void* _obj, void* watched, void* event) {
    return ((QObject*)_obj)->eventFilter(static_cast<QObject*>(watched),
                                         static_cast<QEvent*>(event)) ? 1 : 0;
}

extern "C" QOBJECT_API void qteQObject_installEventFilter(void* _obj, void* filterObj) {
    ((QObject*)_obj)->installEventFilter(static_cast<QObject*>(filterObj));
}

extern "C" QOBJECT_API void qteQObject_removeEventFilter(void* _obj, void* filterObj) {
    ((QObject*)_obj)->removeEventFilter(static_cast<QObject*>(filterObj));
}

// ── Debug/introspection ─────────────────────────────────────────────────────
extern "C" QOBJECT_API void qteQObject_dumpObjectTree(void* _obj) {
    ((QObject*)_obj)->dumpObjectTree();
}

extern "C" QOBJECT_API void qteQObject_dumpObjectInfo(void* _obj) {
    ((QObject*)_obj)->dumpObjectInfo();
}

// ── Signals ─────────────────────────────────────────────────────────────────
// destroyed(QObject*): используем functor-connect, так как параметр — Qt-указатель.
extern "C" QOBJECT_API void qteQObject_connect_destroyed(void* _obj, void* cb, void* dthis) {
    QObject::connect((QObject*)_obj, &QObject::destroyed,
        [cb, dthis](QObject* obj) {
            if (cb) ((void(*)(void*, int, void*))cb)(dthis, 0, (void*)obj);
        });
}
