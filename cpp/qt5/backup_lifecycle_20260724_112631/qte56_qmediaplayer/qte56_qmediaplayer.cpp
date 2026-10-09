#define QTE56_QMEDIAPLAYER_BUILD
#include "qte56_qmediaplayer.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include "../qte56_common/qte56_wstring.h"
#include <QMediaPlayer>
#include <QString>

extern "C" {

// ── Lifecycle ────────────────────────────────────────────────────────────
void* qteQMediaPlayer_create(void* parent) {
    return qte_createTracked(new QMediaPlayer((QObject*)parent);
}

void qteQMediaPlayer_delete(void* w) {
    delete (QMediaPlayer*)w;
}

// ── Methods ──────────────────────────────────────────────────────────────
int qteQMediaPlayer_hasSupport(void* _obj, const wchar_t* mimeType, int mimeType_len) {
    return ((QMediaPlayer*)_obj)->hasSupport(dWstringToQString(mimeType, mimeType_len));
}

void qteQMediaPlayer_setVideoOutput_vw(void* _obj, void* p0) {
    ((QMediaPlayer*)_obj)->setVideoOutput((QVideoWidget*)p0);
}

void qteQMediaPlayer_setVideoOutput_gi(void* _obj, void* p0) {
    ((QMediaPlayer*)_obj)->setVideoOutput((QGraphicsVideoItem*)p0);
}

void qteQMediaPlayer_setVideoOutput_vs(void* _obj, void* surface) {
    ((QMediaPlayer*)_obj)->setVideoOutput((QAbstractVideoSurface*)surface);
}

void* qteQMediaPlayer_media(void* _obj) {
    return (void*)new QMediaContent(((QMediaPlayer*)_obj)->media());
}

void* qteQMediaPlayer_mediaStream(void* _obj) {
    return (void*)((QMediaPlayer*)_obj)->mediaStream();
}

void* qteQMediaPlayer_playlist(void* _obj) {
    return (void*)((QMediaPlayer*)_obj)->playlist();
}

void* qteQMediaPlayer_currentMedia(void* _obj) {
    return (void*)new QMediaContent(((QMediaPlayer*)_obj)->currentMedia());
}

int qteQMediaPlayer_state(void* _obj) {
    return ((QMediaPlayer*)_obj)->state();
}

int qteQMediaPlayer_mediaStatus(void* _obj) {
    return ((QMediaPlayer*)_obj)->mediaStatus();
}

long long qteQMediaPlayer_duration(void* _obj) {
    return ((QMediaPlayer*)_obj)->duration();
}

long long qteQMediaPlayer_position(void* _obj) {
    return ((QMediaPlayer*)_obj)->position();
}

int qteQMediaPlayer_volume(void* _obj) {
    return ((QMediaPlayer*)_obj)->volume();
}

int qteQMediaPlayer_isMuted(void* _obj) {
    return ((QMediaPlayer*)_obj)->isMuted() ? 1 : 0;
}

int qteQMediaPlayer_isAudioAvailable(void* _obj) {
    return ((QMediaPlayer*)_obj)->isAudioAvailable() ? 1 : 0;
}

int qteQMediaPlayer_isVideoAvailable(void* _obj) {
    return ((QMediaPlayer*)_obj)->isVideoAvailable() ? 1 : 0;
}

int qteQMediaPlayer_bufferStatus(void* _obj) {
    return ((QMediaPlayer*)_obj)->bufferStatus();
}

int qteQMediaPlayer_isSeekable(void* _obj) {
    return ((QMediaPlayer*)_obj)->isSeekable() ? 1 : 0;
}

double qteQMediaPlayer_playbackRate(void* _obj) {
    return ((QMediaPlayer*)_obj)->playbackRate();
}

int qteQMediaPlayer_error(void* _obj) {
    return ((QMediaPlayer*)_obj)->error();
}

void* qteQMediaPlayer_errorString(void* _obj) {
    return new QString(((QMediaPlayer*)_obj)->errorString());
}

void* qteQMediaPlayer_currentNetworkConfiguration(void* _obj) {
    return (void*)new QNetworkConfiguration(((QMediaPlayer*)_obj)->currentNetworkConfiguration());
}

int qteQMediaPlayer_availability(void* _obj) {
    return ((QMediaPlayer*)_obj)->availability();
}

int qteQMediaPlayer_audioRole(void* _obj) {
    return ((QMediaPlayer*)_obj)->audioRole();
}

void qteQMediaPlayer_setAudioRole(void* _obj, int audioRole) {
    ((QMediaPlayer*)_obj)->setAudioRole((QAudio::Role)audioRole);
}

void* qteQMediaPlayer_customAudioRole(void* _obj) {
    return new QString(((QMediaPlayer*)_obj)->customAudioRole());
}

void qteQMediaPlayer_setCustomAudioRole(void* _obj, const wchar_t* audioRole, int audioRole_len) {
    ((QMediaPlayer*)_obj)->setCustomAudioRole(dWstringToQString(audioRole, audioRole_len));
}

void qteQMediaPlayer_play(void* _obj) {
    ((QMediaPlayer*)_obj)->play();
}

void qteQMediaPlayer_pause(void* _obj) {
    ((QMediaPlayer*)_obj)->pause();
}

void qteQMediaPlayer_stop(void* _obj) {
    ((QMediaPlayer*)_obj)->stop();
}

void qteQMediaPlayer_setPosition(void* _obj, long long position) {
    ((QMediaPlayer*)_obj)->setPosition(position);
}

void qteQMediaPlayer_setVolume(void* _obj, int volume) {
    ((QMediaPlayer*)_obj)->setVolume(volume);
}

void qteQMediaPlayer_setMuted(void* _obj, int muted) {
    ((QMediaPlayer*)_obj)->setMuted((muted != 0));
}

void qteQMediaPlayer_setPlaybackRate(void* _obj, double rate) {
    ((QMediaPlayer*)_obj)->setPlaybackRate(rate);
}

void qteQMediaPlayer_setMedia(void* _obj, void* media, void* stream) {
    ((QMediaPlayer*)_obj)->setMedia(*(QMediaContent*)media, (QIODevice*)stream);
}

void qteQMediaPlayer_setMediaFromFile(void* _obj, const wchar_t* filename, int filename_len) {
    QString path = dWstringToQString(filename, filename_len);
    QUrl url = QUrl::fromLocalFile(path);
    ((QMediaPlayer*)_obj)->setMedia(QMediaContent(url));
}

void qteQMediaPlayer_setPlaylist(void* _obj, void* playlist) {
    ((QMediaPlayer*)_obj)->setPlaylist((QMediaPlaylist*)playlist);
}

int qteQMediaPlayer_bind(void* _obj, void* p0) {
    return ((QMediaPlayer*)_obj)->bind((QObject*)p0) ? 1 : 0;
}

void qteQMediaPlayer_unbind(void* _obj, void* p0) {
    ((QMediaPlayer*)_obj)->unbind((QObject*)p0);
}

// ── Lambda-connect (Qt-pointer signals) ─────────────────────────────────────
// Signal: mediaChanged(const QMediaContent&)
void qteQMediaPlayer_connect_mediaChanged(void* w, void* cb, void* dthis) {
    QObject::connect((QMediaPlayer*)w, &QMediaPlayer::mediaChanged,
        [cb, dthis](const QMediaContent& p) {
            if (cb) ((void(*)(void*,int,void*))cb)(dthis, 0, (void*)&p);
        });
}

// Signal: currentMediaChanged(const QMediaContent&)
void qteQMediaPlayer_connect_currentMediaChanged(void* w, void* cb, void* dthis) {
    QObject::connect((QMediaPlayer*)w, &QMediaPlayer::currentMediaChanged,
        [cb, dthis](const QMediaContent& p) {
            if (cb) ((void(*)(void*,int,void*))cb)(dthis, 0, (void*)&p);
        });
}

// Signal: networkConfigurationChanged(const QNetworkConfiguration&)
void qteQMediaPlayer_connect_networkConfigurationChanged(void* w, void* cb, void* dthis) {
    QObject::connect((QMediaPlayer*)w, &QMediaPlayer::networkConfigurationChanged,
        [cb, dthis](const QNetworkConfiguration& p) {
            if (cb) ((void(*)(void*,int,void*))cb)(dthis, 0, (void*)&p);
        });
}

} // extern "C"
