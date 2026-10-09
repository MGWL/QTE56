// qte56_desktop.cpp — реализация C-обёрток для QDesktopWidget
#include "qte56_desktop.h"
#include <QApplication>
#include <QDesktopWidget>
#include <QRect>
#include <QPoint>
#include <QWidget>

// 20149
int qteQDesktopWidget_screenCount() {
    return QApplication::desktop()->screenCount();
}

// 20150
int qteQDesktopWidget_primaryScreen() {
    return QApplication::desktop()->primaryScreen();
}

// 20151
void qteQDesktopWidget_screenGeometry(int screen, int* x, int* y, int* w, int* h) {
    QRect r = QApplication::desktop()->screenGeometry(screen);
    *x = r.x(); *y = r.y(); *w = r.width(); *h = r.height();
}

// 20152
void qteQDesktopWidget_availableGeometry(int screen, int* x, int* y, int* w, int* h) {
    QRect r = QApplication::desktop()->availableGeometry(screen);
    *x = r.x(); *y = r.y(); *w = r.width(); *h = r.height();
}

// 20153
int qteQDesktopWidget_screenNumberAt(int x, int y) {
    return QApplication::desktop()->screenNumber(QPoint(x, y));
}

// 20154
int qteQDesktopWidget_screenNumberOf(void* widget) {
    return QApplication::desktop()->screenNumber((QWidget*)widget);
}
