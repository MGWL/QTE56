#include "qte56_systray.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include <QSplashScreen>
#include <QSystemTrayIcon>
#include <QWidget>
#include <QPixmap>
#include <QIcon>
#include <QMenu>
#include <QRect>
#include <QString>
#include <QColor>

// ── QSplashScreen ─────────────────────────────────────────────────────────────

extern "C" SYSTRAY_API void* qteQSplashScreen_create(void* pixmap) {
    return qte_createTracked(new QSplashScreen(*(const QPixmap*)pixmap));
}

extern "C" SYSTRAY_API void qteQSplashScreen_delete(void* ss) {
    delete (QSplashScreen*)ss;
}

extern "C" SYSTRAY_API void qteQSplashScreen_show(void* ss) {
    ((QSplashScreen*)ss)->show();
}

extern "C" SYSTRAY_API void qteQSplashScreen_close(void* ss) {
    ((QSplashScreen*)ss)->close();
}

extern "C" SYSTRAY_API void qteQSplashScreen_showMessage(void* ss,
        void* msg, int alignment, unsigned int rgba) {
    ((QSplashScreen*)ss)->showMessage(
        *(QString*)msg,
        (Qt::Alignment)alignment,
        QColor::fromRgba((QRgb)rgba));
}

extern "C" SYSTRAY_API void qteQSplashScreen_clearMessage(void* ss) {
    ((QSplashScreen*)ss)->clearMessage();
}

extern "C" SYSTRAY_API void qteQSplashScreen_finish(void* ss, void* main_window) {
    ((QSplashScreen*)ss)->finish((QWidget*)main_window);
}

extern "C" SYSTRAY_API void qteQSplashScreen_repaint(void* ss) {
    ((QSplashScreen*)ss)->repaint();
}

extern "C" SYSTRAY_API void qteQSplashScreen_setPixmap(void* ss, void* pixmap) {
    ((QSplashScreen*)ss)->setPixmap(*(const QPixmap*)pixmap);
}

// ── QSystemTrayIcon ───────────────────────────────────────────────────────────

extern "C" SYSTRAY_API void* qteQSystemTrayIcon_create() {
    return qte_createTracked(new QSystemTrayIcon());
}

extern "C" SYSTRAY_API void qteQSystemTrayIcon_delete(void* tray) {
    delete (QSystemTrayIcon*)tray;
}

extern "C" SYSTRAY_API void qteQSystemTrayIcon_setIcon(void* tray, void* icon) {
    ((QSystemTrayIcon*)tray)->setIcon(*(const QIcon*)icon);
}

extern "C" SYSTRAY_API void qteQSystemTrayIcon_setToolTip(void* tray,
        void* tip) {
    ((QSystemTrayIcon*)tray)->setToolTip(*(QString*)tip);
}

extern "C" SYSTRAY_API void qteQSystemTrayIcon_show(void* tray) {
    ((QSystemTrayIcon*)tray)->show();
}

extern "C" SYSTRAY_API void qteQSystemTrayIcon_hide(void* tray) {
    ((QSystemTrayIcon*)tray)->hide();
}

extern "C" SYSTRAY_API int qteQSystemTrayIcon_isVisible(void* tray) {
    return ((QSystemTrayIcon*)tray)->isVisible() ? 1 : 0;
}

extern "C" SYSTRAY_API void qteQSystemTrayIcon_showMessage(void* tray,
        void* title,
        void* msg,
        int icon, int msec) {
    ((QSystemTrayIcon*)tray)->showMessage(
        *(QString*)title,
        *(QString*)msg,
        (QSystemTrayIcon::MessageIcon)icon,
        msec);
}

extern "C" SYSTRAY_API void qteQSystemTrayIcon_setContextMenu(void* tray, void* menu) {
    ((QSystemTrayIcon*)tray)->setContextMenu((QMenu*)menu);
}

extern "C" SYSTRAY_API void qteQSystemTrayIcon_connect_activated(void* tray,
        void (*cb)(int)) {
    QObject::connect((QSystemTrayIcon*)tray, &QSystemTrayIcon::activated,
        [cb](QSystemTrayIcon::ActivationReason r){ cb((int)r); });
}

extern "C" SYSTRAY_API void qteQSystemTrayIcon_connect_messageClicked(void* tray,
        void (*cb)()) {
    QObject::connect((QSystemTrayIcon*)tray, &QSystemTrayIcon::messageClicked,
        [cb](){ cb(); });
}

extern "C" SYSTRAY_API void qteQSystemTrayIcon_geometry(void* tray,
        int* x, int* y, int* w, int* h) {
    QRect r = ((QSystemTrayIcon*)tray)->geometry();
    *x = r.x(); *y = r.y(); *w = r.width(); *h = r.height();
}

extern "C" SYSTRAY_API int qteQSystemTrayIcon_supportsMessages() {
    return QSystemTrayIcon::supportsMessages() ? 1 : 0;
}
