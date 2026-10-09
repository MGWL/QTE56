// qte56_textcodec.cpp — реализация C-обёрток для QTextCodec.
//
// Используется для перекодировки legacy-кодировок (cp1251, cp866, koi8-r и пр.)
// на стыке D ↔ Qt: данные из ODBC/QSql/файлов/QProcess/сети, которые Qt
// иначе декодирует как UTF-8 и теряет.

#include "qte56_textcodec.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include <QTextCodec>
#include <QString>
#include <QByteArray>
#include <QStringList>

// Внутренний хелпер: ищет кодек по имени из C-буфера фиксированной длины.
// Возвращает nullptr если кодек не зарегистрирован.
static QTextCodec* findCodec(const char* name, int len) {
    if (!name || len <= 0) return nullptr;
    QByteArray nm(name, len);
    return QTextCodec::codecForName(nm);
}

// 20157
int qteQTextCodec_codecAvailable(const char* name, int len) {
    return findCodec(name, len) != nullptr ? 1 : 0;
}

// 20158 — байты → QString через указанный кодек.
void* qteQTextCodec_decodeBytes(const char* codecName, int codecLen,
                                const char* data,      int dataLen) {
    QTextCodec* codec = findCodec(codecName, codecLen);
    if (!codec) {
        // Кодек не найден — возвращаем пустую строку, чтобы D не получил мусор.
        // Проверять доступность кодека следует через codecAvailable() заранее.
        return new QString();
    }
    if (!data || dataLen <= 0) {
        return new QString();
    }
    return new QString(codec->toUnicode(data, dataLen));
}

// 20159 — QString → байты через указанный кодек.
void* qteQTextCodec_encodeText(const char* codecName, int codecLen,
                               void* qstring) {
    QTextCodec* codec = findCodec(codecName, codecLen);
    if (!codec || !qstring) {
        return new QByteArray();
    }
    const QString* qs = static_cast<const QString*>(qstring);
    return new QByteArray(codec->fromUnicode(*qs));
}

// 20160 — все доступные имена кодеков, склеенные через \x01.
//         Формат соответствует toQStringList в gen_qcore.d.
void* qteQTextCodec_availableCodecs() {
    QList<QByteArray> list = QTextCodec::availableCodecs();
    QStringList result;
    result.reserve(list.size());
    for (const QByteArray& nm : list) {
        result.append(QString::fromLatin1(nm));
    }
    return new QString(result.join(QChar(0x01)));
}

// 20161 — установить кодек локали по умолчанию.
void qteQTextCodec_setCodecForLocale(const char* name, int len) {
    QTextCodec* codec = findCodec(name, len);
    if (codec) {
        QTextCodec::setCodecForLocale(codec);
    }
}

// 20162 — имя текущего locale-кодека (для отладки/диагностики).
void* qteQTextCodec_codecForLocaleName() {
    QTextCodec* codec = QTextCodec::codecForLocale();
    if (!codec) return new QString();
    return new QString(QString::fromLatin1(codec->name()));
}
