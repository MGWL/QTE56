#pragma once
// qte56_textcodec.h — C-обёртки для QTextCodec
//                     (перекодировка байт ↔ QString для legacy-кодировок:
//                      cp1251, cp866, koi8-r, iso-8859-5, MacCyrillic и пр.)
// Индексы pFunQt: 20157–20162 (6 функций)
//
// Назначение: дать D-стороне возможность правильно декодировать байты,
// пришедшие из ODBC/QSql/файлов/QProcess/сети в национальной кодировке.
// QTextCodec удалён в Qt 6 → заменить на QStringConverter при миграции.

#ifdef _WIN32
#  ifdef QTE56_TEXTCODEC_BUILD
#    define TEXTCODEC_API extern "C" __declspec(dllexport)
#  else
#    define TEXTCODEC_API extern "C" __declspec(dllimport)
#  endif
#else
#  define TEXTCODEC_API extern "C"
#endif

// 20157 — проверить, доступен ли кодек по имени.
//         Возвращает 1 если QTextCodec::codecForName(name) != nullptr, иначе 0.
//         name — байты ASCII-имени кодека ("Windows-1251", "IBM866", ...).
//         len  — длина name в байтах (без \0).
TEXTCODEC_API int qteQTextCodec_codecAvailable(const char* name, int len);

// 20158 — декодировать байты в QString указанным кодеком.
//         Возвращает new QString*; вызывающий освобождает через pFunQt[22].
//         Если кодек не найден — возвращает new QString() (пустой).
//         data может быть NULL если dataLen == 0.
TEXTCODEC_API void* qteQTextCodec_decodeBytes(
    const char* codecName, int codecLen,
    const char* data,      int dataLen);

// 20159 — закодировать QString в байты указанным кодеком.
//         Возвращает new QByteArray*; вызывающий освобождает через
//         qteQByteArray_delete (pFunQt[19971]).
//         Если кодек не найден — возвращает пустой QByteArray.
//         Символы, не представимые в целевой кодировке, заменяются на '?'.
TEXTCODEC_API void* qteQTextCodec_encodeText(
    const char* codecName, int codecLen,
    void*       qstring);

// 20160 — список всех доступных кодеков (Windows-1251, IBM866, ...).
//         Возвращает new QString*, склеенный через \x01 (как toQStringList).
//         D-сторона разделяет по \x01 → string[].
//         Освобождать через pFunQt[22].
TEXTCODEC_API void* qteQTextCodec_availableCodecs();

// 20161 — установить кодек по умолчанию для QTextCodec::codecForLocale().
//         Влияет на интерпретацию байт по умолчанию в QString::fromLocal8Bit
//         и обратно. Используется как глобальная подстраховка.
TEXTCODEC_API void qteQTextCodec_setCodecForLocale(const char* name, int len);

// 20162 — имя текущего locale-кодека (для отладки).
//         Возвращает new QString*; освобождать через pFunQt[22].
TEXTCODEC_API void* qteQTextCodec_codecForLocaleName();
