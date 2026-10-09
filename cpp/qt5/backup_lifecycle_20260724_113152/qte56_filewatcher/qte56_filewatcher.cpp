// qte56_filewatcher.cpp — реализация C-обёрток для QFileSystemWatcher
#include "qte56_filewatcher.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include "../qte56_common/qte56_wstring.h"
#include <QFileSystemWatcher>
#include <QString>
#include <QStringList>

// 20139
void* qteQFileSystemWatcher_create() {
    return qte_createTracked(new QFileSystemWatcher());
}

// 20140
void qteQFileSystemWatcher_delete(void* w) {
    delete (QFileSystemWatcher*)w;
}

// 20141
int qteQFileSystemWatcher_addPath(void* w, const wchar_t* path, int len) {
    QString p = dWstringToQString(path, len);
    return ((QFileSystemWatcher*)w)->addPath(p) ? 1 : 0;
}

// 20142
void qteQFileSystemWatcher_addPaths(void* w, const wchar_t* paths, int len) {
    ((QFileSystemWatcher*)w)->addPaths(dWstringToQStringList(paths, len));
}

// 20143
void qteQFileSystemWatcher_removePath(void* w, const wchar_t* path, int len) {
    QString p = dWstringToQString(path, len);
    ((QFileSystemWatcher*)w)->removePath(p);
}

// 20144
void qteQFileSystemWatcher_removePaths(void* w, const wchar_t* paths, int len) {
    ((QFileSystemWatcher*)w)->removePaths(dWstringToQStringList(paths, len));
}

// 20145 — возвращает new QString (caller освобождает через qteQString_delete)
void* qteQFileSystemWatcher_files(void* w) {
    QStringList lst = ((QFileSystemWatcher*)w)->files();
    return new QString(lst.join(QChar(1)));
}

// 20146
void* qteQFileSystemWatcher_directories(void* w) {
    QStringList lst = ((QFileSystemWatcher*)w)->directories();
    return new QString(lst.join(QChar(1)));
}

// 20147
void qteQFileSystemWatcher_connect_fileChanged(void* w,
        void (*cb)(const wchar_t*, int, void*), void* userdata) {
    QObject::connect((QFileSystemWatcher*)w, &QFileSystemWatcher::fileChanged,
        [cb, userdata](const QString& path) {
            cb(qstringToDWstringPtr(path), path.length(), userdata);
        });
}

// 20148
void qteQFileSystemWatcher_connect_directoryChanged(void* w,
        void (*cb)(const wchar_t*, int, void*), void* userdata) {
    QObject::connect((QFileSystemWatcher*)w, &QFileSystemWatcher::directoryChanged,
        [cb, userdata](const QString& path) {
            cb(qstringToDWstringPtr(path), path.length(), userdata);
        });
}
