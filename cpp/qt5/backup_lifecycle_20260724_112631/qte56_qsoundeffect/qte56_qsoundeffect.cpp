#define QTE56_QSOUNDEFFECT_BUILD
#include "qte56_qsoundeffect.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include "../qte56_common/qte56_wstring.h"
#include <QSoundEffect>
#include <QString>
#include <QUrl>

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQSoundEffect_create(void* parent) {
    return qte_createTracked(new QSoundEffect((QObject*)parent);
}

void qteQSoundEffect_delete(void* w) {
    delete (QSoundEffect*)w;
}

// ── Methods ──────────────────────────────────────────────────────────────
void* qteQSoundEffect_source(void* _obj) {
    return (void*)new QUrl(((QSoundEffect*)_obj)->source());
}

void qteQSoundEffect_setSource(void* _obj, void* url) {
    ((QSoundEffect*)_obj)->setSource(*(QUrl*)url);
}

void qteQSoundEffect_setSourceFromLocalFile(void* _obj, const char* path) {
    ((QSoundEffect*)_obj)->setSource(QUrl::fromLocalFile(QString::fromUtf8(path)));
}

int qteQSoundEffect_loopCount(void* _obj) {
    return ((QSoundEffect*)_obj)->loopCount();
}

int qteQSoundEffect_loopsRemaining(void* _obj) {
    return ((QSoundEffect*)_obj)->loopsRemaining();
}

void qteQSoundEffect_setLoopCount(void* _obj, int loopCount) {
    ((QSoundEffect*)_obj)->setLoopCount(loopCount);
}

double qteQSoundEffect_volume(void* _obj) {
    return ((QSoundEffect*)_obj)->volume();
}

void qteQSoundEffect_setVolume(void* _obj, double volume) {
    ((QSoundEffect*)_obj)->setVolume(volume);
}

int qteQSoundEffect_isMuted(void* _obj) {
    return ((QSoundEffect*)_obj)->isMuted() ? 1 : 0;
}

void qteQSoundEffect_setMuted(void* _obj, int muted) {
    ((QSoundEffect*)_obj)->setMuted((muted != 0));
}

int qteQSoundEffect_isLoaded(void* _obj) {
    return ((QSoundEffect*)_obj)->isLoaded() ? 1 : 0;
}

int qteQSoundEffect_isPlaying(void* _obj) {
    return ((QSoundEffect*)_obj)->isPlaying() ? 1 : 0;
}

int qteQSoundEffect_status(void* _obj) {
    return ((QSoundEffect*)_obj)->status();
}

void* qteQSoundEffect_category(void* _obj) {
    return new QString(((QSoundEffect*)_obj)->category());
}

void qteQSoundEffect_setCategory(void* _obj, const wchar_t* category, int category_len) {
    ((QSoundEffect*)_obj)->setCategory(dWstringToQString(category, category_len));
}

void qteQSoundEffect_play(void* _obj) {
    ((QSoundEffect*)_obj)->play();
}

void qteQSoundEffect_stop(void* _obj) {
    ((QSoundEffect*)_obj)->stop();
}

} // extern "C"
