#include "qte56_qcore.h"
#include "eslot.h"

#include <QApplication>
#include <QCursor>
#include <QFont>
#include <QIcon>
#include <QObject>
#include <QPointer>
#include <QPoint>
#include <QRect>
#include <QSize>
#include <QString>
#include <QStyle>
#include <cstring>

// ─────────────────────────────────────────────────────────────────────────────
// QPointer lifecycle
// tp=1 : QPointer<eSlot>
// ─────────────────────────────────────────────────────────────────────────────

extern "C" QCORE_API void* qteQPointer_new(int tp) {
    if (tp == 1) return new QPointer<eSlot>();
    return nullptr;
}

extern "C" QCORE_API void qteQPointer_delete(void* qptr, int tp) {
    if (tp == 1) delete (QPointer<eSlot>*)qptr;
}

extern "C" QCORE_API bool qteQPointer_isNull(void* qptr, int tp) {
    if (tp == 1) return ((QPointer<eSlot>*)qptr)->isNull();
    return true;
}

// ─────────────────────────────────────────────────────────────────────────────
// eSlot
// ─────────────────────────────────────────────────────────────────────────────

extern "C" QCORE_API void qteConnect(void* sender, const char* signal,
                                      void* receiver, const char* slot, int conn_type) {
    QObject::connect(
        (QObject*)sender, signal,
        (QObject*)receiver, slot,
        (Qt::ConnectionType)conn_type
    );
}

extern "C" QCORE_API void* qteESlot_create(void* qptr, void* parent) {
    eSlot* slot = new eSlot((QObject*)parent);
    *((QPointer<eSlot>*)qptr) = slot;
    return (void*)slot;
}

extern "C" QCORE_API void qteESlot_set(void* slot, void* cb, void* dthis, int n) {
    eSlot* s = (eSlot*)slot;
    s->cb    = cb;
    s->dthis = dthis;
    s->n     = n;
}

// ─────────────────────────────────────────────────────────────────────────────
// QString
// ─────────────────────────────────────────────────────────────────────────────

extern "C" QCORE_API void* qteQString_fromWStr(void* s, int len) {
    // char16_t = 2 байта (UTF-16) на всех платформах, как wchar в D
    return new QString(reinterpret_cast<const QChar*>(s), len);
}

extern "C" QCORE_API int qteQString_toWStr(void* qs, char16_t* buf, int maxlen) {
    QString* s = (QString*)qs;
    int len = s->size();
    if (len > maxlen - 1) len = maxlen - 1;
    // utf16() возвращает const ushort* (2 байта) — корректно на всех платформах
    memcpy(buf, s->utf16(), len * sizeof(char16_t));
    buf[len] = u'\0';
    return len;
}

extern "C" QCORE_API void qteQString_free(void* qs) {
    delete (QString*)qs;
}

// ─────────────────────────────────────────────────────────────────────────────
// Value types
// ─────────────────────────────────────────────────────────────────────────────

extern "C" QCORE_API void* qteQRect_pack(int x, int y, int w, int h) {
    return new QRect(x, y, w, h);
}
extern "C" QCORE_API void qteQRect_unpack(void* r, int* x, int* y, int* w, int* h) {
    QRect* rect = (QRect*)r;
    *x = rect->x();  *y = rect->y();
    *w = rect->width(); *h = rect->height();
    delete rect;
}
extern "C" QCORE_API void qteQRect_free(void* r) { delete (QRect*)r; }

extern "C" QCORE_API void* qteQPoint_pack(int x, int y) {
    return new QPoint(x, y);
}
extern "C" QCORE_API void qteQPoint_unpack(void* p, int* x, int* y) {
    QPoint* pt = (QPoint*)p;
    *x = pt->x(); *y = pt->y();
    delete pt;
}
extern "C" QCORE_API void qteQPoint_free(void* p) { delete (QPoint*)p; }

extern "C" QCORE_API void* qteQSize_pack(int w, int h) {
    return new QSize(w, h);
}
extern "C" QCORE_API void qteQSize_unpack(void* s, int* w, int* h) {
    QSize* sz = (QSize*)s;
    *w = sz->width(); *h = sz->height();
    delete sz;
}
extern "C" QCORE_API void qteQSize_free(void* s) { delete (QSize*)s; }

// ─────────────────────────────────────────────────────────────────────────────
// QApplication
//
// Qt требует, чтобы argc и argv[0] жили всё время работы программы.
// Используем статические переменные.
// ─────────────────────────────────────────────────────────────────────────────

static int   _app_argc     = 1;
static char  _app_name[256] = "qte56app";
static char* _app_argv[2]  = { _app_name, nullptr };

extern "C" QCORE_API void* qteQApplication_create(void* appName) {
    if (appName) {
        // Конвертируем char16_t в char для argv[0]
        QString tmp = QString(reinterpret_cast<const QChar*>(appName));
        QByteArray ba = tmp.toLocal8Bit();
        strncpy(_app_name, ba.constData(), sizeof(_app_name) - 1);
        _app_name[sizeof(_app_name) - 1] = '\0';
    }
    return new QApplication(_app_argc, _app_argv);
}

// ─────────────────────────────────────────────────────────────────────────────
// QCoreApplication
//
// Лёгкая версия без GUI-зависимостей. Не требует platform plugins.
// ─────────────────────────────────────────────────────────────────────────────

extern "C" QCORE_API void* qteQCoreApplication_create(void* appName) {
    if (appName) {
        QString tmp = QString(reinterpret_cast<const QChar*>(appName));
        QByteArray ba = tmp.toLocal8Bit();
        strncpy(_app_name, ba.constData(), sizeof(_app_name) - 1);
        _app_name[sizeof(_app_name) - 1] = '\0';
    }
    return new QCoreApplication(_app_argc, _app_argv);
}

extern "C" QCORE_API int qteQCoreApplication_exec(void* app) {
    return ((QCoreApplication*)app)->exec();
}

extern "C" QCORE_API void qteQCoreApplication_quit(void* app) {
    ((QCoreApplication*)app)->quit();
}

extern "C" QCORE_API int qteQApplication_exec(void* app) {
    return ((QApplication*)app)->exec();
}

extern "C" QCORE_API void qteQApplication_quit(void* app) {
    ((QApplication*)app)->quit();
}

extern "C" QCORE_API void qteQApplication_processEvents(void* app) {
    (void)app;  // QApplication::processEvents — статический метод
    QApplication::processEvents();
}

extern "C" QCORE_API void* qteQApplication_appName(void* app) {
    (void)app;
    return new QString(QApplication::applicationName());
}

extern "C" QCORE_API void qteQApplication_setAppName(void* app,
                                                       void* name) {
    (void)app;
    QApplication::setApplicationName(*(QString*)name);
}

// ─────────────────────────────────────────────────────────────────────────────
// QApplication extended (56-71)
// ─────────────────────────────────────────────────────────────────────────────

extern "C" QCORE_API void qteQApplication_setStyleSheet(void* app,
                                                          void* css) {
    ((QApplication*)app)->setStyleSheet(*(QString*)css);
}

extern "C" QCORE_API void* qteQApplication_styleSheet(void* app) {
    return new QString(((QApplication*)app)->styleSheet());
}

extern "C" QCORE_API void qteQApplication_setStyle(void* app,
                                                      void* name) {
    (void)app;
    QApplication::setStyle(*(QString*)name);
}

extern "C" QCORE_API void* qteQApplication_styleName(void* app) {
    (void)app;
    QStyle* st = QApplication::style();
    if (!st) return new QString();
    return new QString(st->objectName());
}

extern "C" QCORE_API void qteQApplication_setWindowIcon(void* app, void* icon) {
    (void)app;
    QApplication::setWindowIcon(*(QIcon*)icon);
}

extern "C" QCORE_API void qteQApplication_setOverrideCursor(void* app, int shape) {
    (void)app;
    QApplication::setOverrideCursor(QCursor((Qt::CursorShape)shape));
}

extern "C" QCORE_API void qteQApplication_restoreOverrideCursor(void* app) {
    (void)app;
    QApplication::restoreOverrideCursor();
}

extern "C" QCORE_API void* qteQApplication_appDirPath(void* app) {
    (void)app;
    return new QString(QApplication::applicationDirPath());
}

extern "C" QCORE_API void* qteQApplication_appVersion(void* app) {
    (void)app;
    return new QString(QApplication::applicationVersion());
}

extern "C" QCORE_API void qteQApplication_setAppVersion(void* app,
                                                           void* ver) {
    (void)app;
    QApplication::setApplicationVersion(*(QString*)ver);
}

extern "C" QCORE_API void* qteQApplication_orgName(void* app) {
    (void)app;
    return new QString(QApplication::organizationName());
}

extern "C" QCORE_API void qteQApplication_setOrgName(void* app,
                                                        void* name) {
    (void)app;
    QApplication::setOrganizationName(*(QString*)name);
}

extern "C" QCORE_API void qteQApplication_beep(void* app) {
    (void)app;
    QApplication::beep();
}

extern "C" QCORE_API void qteQApplication_closeAllWindows(void* app) {
    (void)app;
    QApplication::closeAllWindows();
}

extern "C" QCORE_API void* qteQApplication_activeWindow(void* app) {
    (void)app;
    return (void*)QApplication::activeWindow();
}

extern "C" QCORE_API void qteQApplication_setFont(void* app, void* font) {
    (void)app;
    QApplication::setFont(*(QFont*)font);
}

extern "C" QCORE_API void qteQApplication_aboutQt(void* app) {
    (void)app;
    QApplication::aboutQt();
}

extern "C" QCORE_API void* qteQApplication_font(void* app) {
    (void)app;
    return new QFont(QApplication::font());
}

extern "C" QCORE_API void* qteQApplication_orgDomain(void* app) {
    (void)app;
    return new QString(QCoreApplication::organizationDomain());
}

extern "C" QCORE_API void qteQApplication_setOrgDomain(void* app, void* domain) {
    (void)app;
    QCoreApplication::setOrganizationDomain(*(const QString*)domain);
}

extern "C" QCORE_API void* qteQApplication_appFilePath(void* app) {
    (void)app;
    return new QString(QCoreApplication::applicationFilePath());
}

// Qt::KeyboardModifiers как int. Битовые значения:
//   Qt::ShiftModifier   = 0x02000000
//   Qt::ControlModifier = 0x04000000
//   Qt::AltModifier     = 0x08000000
//   Qt::MetaModifier    = 0x10000000
extern "C" QCORE_API int qteQApplication_keyboardModifiers() {
    return (int)QApplication::keyboardModifiers();
}
