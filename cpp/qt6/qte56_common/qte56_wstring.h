#pragma once

/*
 * qte56_wstring.h — Cross-platform wchar_t helpers for D ↔ Qt string conversion.
 *
 * Problem:
 *   D's `wstring` (wchar[]) is ALWAYS 2-byte UTF-16, regardless of platform.
 *   C++ `wchar_t` is 2 bytes on Windows (UTF-16) but 4 bytes on Linux/macOS
 *   (UTF-32). Therefore `QString::fromWCharArray()` breaks on Linux because it
 *   reads the D-side buffer as 4-byte units.
 *
 * Solution:
 *   Use `QString::fromUtf16()` when reading D data (2-byte units).
 *   Use `QString::utf16()` when writing Qt data back to D (2-byte units).
 *
 * Include this header in any C++ module that receives wchar_t* from D or
 * sends wchar_t* back to D.
 */

#include <QString>
#include <QStringList>

// ── D wstring (UTF-16) → QString ────────────────────────────────────────────

/**
 * Convert a D wstring buffer into a QString.
 *
 * D always sends UTF-16 data (2 bytes per code unit).  On Linux wchar_t is
 * 4 bytes, so a plain fromWCharArray() would interpret pairs of UTF-16 units
 * as single wchar_t values, producing garbage.  fromUtf16() with a
 * reinterpret_cast<const ushort*> works correctly on both Windows and Linux.
 */
static inline QString dWstringToQString(const wchar_t* w, int len)
{
    if (!w || len <= 0)
        return QString();
    return QString::fromUtf16(reinterpret_cast<const ushort*>(w), len);
}

// ── D wstring (UTF-16, joined) → QStringList ────────────────────────────────

/**
 * Convert a D wstring buffer containing items separated by QChar(1) into a
 * QStringList.  Empty parts are skipped (same behaviour as the old
 * SkipEmptyParts split).
 */
static inline QStringList dWstringToQStringList(const wchar_t* w, int len)
{
    if (!w || len <= 0)
        return QStringList();
    QString s = QString::fromUtf16(reinterpret_cast<const ushort*>(w), len);
    return s.split(QChar(1), Qt::SkipEmptyParts);
}

// ── QString → D wstring buffer ──────────────────────────────────────────────

/**
 * Copy a QString into a D-side wchar_t buffer as UTF-16.
 *
 * The caller must ensure `buf` is large enough (maxLen * sizeof(wchar_t) on
 * Windows, but note that on Linux `sizeof(wchar_t)` is 4 while the actual
 * written data is 2 bytes per code unit).  D treats the buffer as an array
 * of 2-byte wchar values, so the byte layout produced by utf16() is correct.
 *
 * Returns the number of UTF-16 code units written (not bytes).
 */
static inline int qstringToDWstringBuf(const QString& s, void* buf, int maxLen)
{
    if (!buf || maxLen <= 0)
        return 0;
    int n = qMin(s.length(), maxLen);
    memcpy(buf, s.utf16(), n * sizeof(char16_t));
    return n;
}

// ── QString → raw wchar_t* pointer for callbacks ────────────────────────────

/**
 * Return a pointer suitable for passing to D callbacks that expect
 * `const(wchar)*`.
 *
 * D's `wchar` is always 2 bytes.  On Windows `wchar_t` is already 2 bytes, so
 * a direct cast is safe.  On Linux `wchar_t` is 4 bytes, but because the D
 * side reads the pointer as a 2-byte wchar array, we must pass the UTF-16
 * data from utf16().  The cast keeps the ABI signature unchanged while
 * ensuring the data layout matches what D expects.
 */
static inline const wchar_t* qstringToDWstringPtr(const QString& s)
{
    return reinterpret_cast<const wchar_t*>(s.utf16());
}
