// qte56_desktop.cpp — реализация C-обёрток для QDesktopWidget (Qt6: QScreen)
#include "qte56_desktop.h"
#include <QApplication>
#include <QScreen>
#include <QRect>
#include <QPoint>
#include <QWidget>

// 20149
int qteQDesktopWidget_screenCount() {
    return QApplication::screens().count();
}

// 20150
int qteQDesktopWidget_primaryScreen() {
    int idx = 0;
    QScreen* primary = QApplication::primaryScreen();
    for (QScreen* s : QApplication::screens()) {
        if (s == primary) return idx;
        idx++;
    }
    return 0;
}

// 20151
void qteQDesktopWidget_screenGeometry(int screen, int* x, int* y, int* w, int* h) {
    QList<QScreen*> screens = QApplication::screens();
    if (screen >= 0 && screen < screens.count()) {
        QRect r = screens[screen]->geometry();
        *x = r.x(); *y = r.y(); *w = r.width(); *h = r.height();
    } else {
        *x = *y = *w = *h = 0;
    }
}

// 20152
void qteQDesktopWidget_availableGeometry(int screen, int* x, int* y, int* w, int* h) {
    QList<QScreen*> screens = QApplication::screens();
    if (screen >= 0 && screen < screens.count()) {
        QRect r = screens[screen]->availableGeometry();
        *x = r.x(); *y = r.y(); *w = r.width(); *h = r.height();
    } else {
        *x = *y = *w = *h = 0;
    }
}

// 20153
int qteQDesktopWidget_screenNumberAt(int x, int y) {
    QPoint p(x, y);
    int idx = 0;
    for (QScreen* s : QApplication::screens()) {
        if (s->geometry().contains(p)) return idx;
        idx++;
    }
    return -1;
}

// 20154
int qteQDesktopWidget_screenNumberOf(void* widget) {
    QScreen* scr = ((QWidget*)widget)->screen();
    int idx = 0;
    for (QScreen* s : QApplication::screens()) {
        if (s == scr) return idx;
        idx++;
    }
    return -1;
}
