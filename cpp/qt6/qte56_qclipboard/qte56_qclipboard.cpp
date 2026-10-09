#include "qte56_qclipboard.h"
#include <QApplication>
#include <QClipboard>
#include <QString>

void* qteQClipboard_get() {
    return QApplication::clipboard();
}

void* qteQClipboard_text(void* cb, int mode) {
    QString s = ((QClipboard*)cb)->text((QClipboard::Mode)mode);
    return new QString(s);
}

void qteQClipboard_setText(void* cb, const char* s, int mode) {
    ((QClipboard*)cb)->setText(QString::fromUtf8(s), (QClipboard::Mode)mode);
}

void qteQClipboard_clear(void* cb, int mode) {
    ((QClipboard*)cb)->clear((QClipboard::Mode)mode);
}

int qteQClipboard_supportsSelection(void* cb) {
    return ((QClipboard*)cb)->supportsSelection() ? 1 : 0;
}

int qteQClipboard_ownsClipboard(void* cb) {
    return ((QClipboard*)cb)->ownsClipboard() ? 1 : 0;
}

int qteQClipboard_ownsSelection(void* cb) {
    return ((QClipboard*)cb)->ownsSelection() ? 1 : 0;
}

void qteQClipboard_connect_dataChanged(void* cb, void* callback, void* dthis) {
    typedef void(*Cb)(void*);
    auto cbf = (Cb)callback;
    QObject::connect((QClipboard*)cb, &QClipboard::dataChanged,
        [=]() { cbf(dthis); });
}

void qteQClipboard_connect_changed(void* cb, void* callback, void* dthis) {
    typedef void(*Cb)(void*, int);
    auto cbf = (Cb)callback;
    QObject::connect((QClipboard*)cb, &QClipboard::changed,
        [=](QClipboard::Mode mode) { cbf(dthis, (int)mode); });
}
