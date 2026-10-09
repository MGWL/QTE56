#define QTE56_QSOUND_BUILD
#include "qte56_qsound.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include "../qte56_common/qte56_wstring.h"
#include <QSound>
#include <QString>

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQSound_create(void* parent) {
    return qte_createTracked(new QSound(QString(), (QObject*)parent));
}

void qteQSound_delete(void* w) {
    delete (QSound*)w;
}

void* qteQSound_create_text(const wchar_t* text, int len, void* parent) {
    return qte_createTracked(new QSound(dWstringToQString(text, len), (QObject*)parent));
}

// ── Methods ──────────────────────────────────────────────────────────────
void qteQSound_play_s(void* _obj, const wchar_t* filename, int filename_len) {
    ((QSound*)_obj)->play(dWstringToQString(filename, filename_len));
}

int qteQSound_loops(void* _obj) {
    return ((QSound*)_obj)->loops();
}

int qteQSound_loopsRemaining(void* _obj) {
    return ((QSound*)_obj)->loopsRemaining();
}

void qteQSound_setLoops(void* _obj, int p0) {
    ((QSound*)_obj)->setLoops(p0);
}

void* qteQSound_fileName(void* _obj) {
    return new QString(((QSound*)_obj)->fileName());
}

int qteQSound_isFinished(void* _obj) {
    return ((QSound*)_obj)->isFinished() ? 1 : 0;
}

void qteQSound_play_v(void* _obj) {
    ((QSound*)_obj)->play();
}

void qteQSound_stop(void* _obj) {
    ((QSound*)_obj)->stop();
}

} // extern "C"
