/**
 * d/csv.d — минимальный CSV writer (без RFC 4180 escaping).
 *
 * $(H3 Назначение)
 *
 * Простая запись массива строк в CSV-файл с произвольным разделителем.
 * Не использует Qt — pure D, можно в headless-режиме.
 *
 * $(B Особенности:)
 * $(UL
 *   $(LI В значениях NE экранирует кавычки/разделитель — используется в кейсах,
 *        где гарантировано отсутствие проблемных символов в данных
 *        (например, выгрузка с фиксированной структурой полей).)
 *   $(LI Заменяет в значениях `\r`, `\n`, `\t` на пробел — страховка от
 *        многострочных полей вроде `Доп_информация`, которые иначе
 *        ломают парсер на принимающей стороне.)
 *   $(LI Запись в UTF-8 (D string = UTF-8 by definition).)
 *   $(LI Перенос строки настраивается ("\r\n" по умолчанию для Windows-получателя).)
 *   $(LI Опциональный BOM (3 байта 0xEF 0xBB 0xBF) — нужен Excel'ю.)
 * )
 *
 * $(H3 Минимальный пример)
 *
 * ---
 * import csv;
 *
 * string[][] rows;
 * rows ~= ["Иванов", "Иван", "1990", "Москва"];
 * rows ~= ["Petrov", "Petr",  "1985", "St.Petersburg"];
 *
 * writeCsvFile("out.csv", rows);                    // ; CRLF UTF-8 без BOM
 * writeCsvFile("excel.csv", rows, ';', "\r\n", true); // c BOM (для Excel)
 * ---
 */
module csv;

import std.array  : appender;
import std.file   : write;

/**
 * Собирает одну CSV-строку из массива полей.
 *
 * Params:
 *   fields = значения полей (D string = UTF-8).
 *   sep    = символ-разделитель (по умолчанию `;`).
 *
 * Returns: D-строка без терминатора. Каждое поле очищается от `\r`/`\n`/`\t`
 *          (заменяются на пробел) — страховка для многострочных значений.
 *
 * Example:
 * ---
 * string s = csvLine(["Иванов", "Иван", "1990"]);
 * assert(s == "Иванов;Иван;1990");
 * ---
 */
string csvLine(scope const(string)[] fields, char sep = ';') {
    auto app = appender!string;
    foreach (i, f; fields) {
        if (i > 0) app.put(sep);
        // Простая страховка: заменяем переносы строк и табы на пробел,
        // чтобы CSV не сломался у получателя.
        foreach (char c; f) {
            if (c == '\r' || c == '\n' || c == '\t') app.put(' ');
            else                                     app.put(c);
        }
    }
    return app.data;
}

/**
 * Сериализует массив строк в один большой буфер (UTF-8 байты).
 *
 * Params:
 *   rows       = массив строк (каждая = массив полей).
 *   sep        = разделитель полей (`;` по умолчанию).
 *   lineEnding = терминатор строки (`"\r\n"` для Windows-стиля).
 *   withBom    = добавить UTF-8 BOM в начало (нужен Excel'ю).
 *
 * Returns: байты файла; можно сразу записать через `std.file.write`.
 */
ubyte[] csvSerialize(in string[][] rows,
                     char   sep        = ';',
                     string lineEnding  = "\r\n",
                     bool   withBom     = false)
{
    auto app = appender!(ubyte[]);
    if (withBom) app.put(cast(ubyte[])[0xEF, 0xBB, 0xBF]);
    foreach (row; rows) {
        app.put(cast(const(ubyte)[])csvLine(row, sep));
        app.put(cast(const(ubyte)[])lineEnding);
    }
    return app.data;
}

/**
 * Записывает массив строк в CSV-файл.
 *
 * Params:
 *   path       = путь к создаваемому файлу.
 *   rows       = массив строк.
 *   sep        = разделитель (`;`).
 *   lineEnding = терминатор (`"\r\n"`).
 *   withBom    = добавить UTF-8 BOM.
 *
 * Note: файл перезаписывается полностью. Никакой проверки на существование
 *       или backup — это задача вызывающего кода.
 */
void writeCsvFile(string path,
                  in string[][] rows,
                  char   sep        = ';',
                  string lineEnding  = "\r\n",
                  bool   withBom     = false)
{
    write(path, csvSerialize(rows, sep, lineEnding, withBom));
}

// ─────────────────────────────────────────────────────────────────────────────
// Юнит-тесты
// ─────────────────────────────────────────────────────────────────────────────

unittest
{
    // ── csvLine: базовая склейка ─────────────────────────────────────────────
    assert(csvLine(["a", "b", "c"])              == "a;b;c");
    assert(csvLine(["a", "b", "c"], ',')         == "a,b,c");
    assert(csvLine([])                            == "");
    assert(csvLine(["only"])                      == "only");

    // ── Замена переносов и табов на пробел ───────────────────────────────────
    assert(csvLine(["multi\r\nline", "x"])        == "multi  line;x");
    assert(csvLine(["with\ttab"])                  == "with tab");

    // ── Кириллица сохраняется (UTF-8 byte-by-byte) ───────────────────────────
    assert(csvLine(["Иванов", "Иван"])             == "Иванов;Иван");

    // ── csvSerialize: BOM ────────────────────────────────────────────────────
    auto bytes1 = csvSerialize([["a","b"]], ';', "\r\n", false);
    assert(bytes1 == cast(ubyte[])"a;b\r\n");

    auto bytes2 = csvSerialize([["a","b"]], ';', "\r\n", true);
    assert(bytes2[0..3] == cast(ubyte[])[0xEF, 0xBB, 0xBF]);
    assert(bytes2[3..$] == cast(ubyte[])"a;b\r\n");

    // ── Несколько строк ──────────────────────────────────────────────────────
    string[][] rows = [
        ["1", "Ivanov",  "1990"],
        ["2", "Петров",  "1985"]
    ];
    auto out_ = csvSerialize(rows);
    assert(out_ == cast(ubyte[])"1;Ivanov;1990\r\n2;Петров;1985\r\n");
}
