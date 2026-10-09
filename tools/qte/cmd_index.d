/**
 * tools/qte/cmd_index.d — подкоманда `qte index ...`
 *
 * Анализ pFunQt-таблицы: реестр, коллизии, дыры, поиск, ассоциации с gen_*.d.
 *
 * Подкоманды:
 *   qte index list                     # сводка по DLL/модулям
 *   qte index find NAME                # найти запись по имени функции (substring)
 *   qte index next [from]              # следующий свободный индекс
 *   qte index gaps [--min N]           # дыры в нумерации (минимум N подряд)
 *   qte index check                    # коллизии + name mismatches + orphans
 *   qte index module NAME              # все индексы модуля (отсортировано)
 *   qte index orphans                  # CSV/gen orphans (требует scan d/gen)
 */
module cmd_index;

import std.stdio    : writeln, writefln, stderr;
import std.array    : appender, join, array;
import std.algorithm: filter, sort, map, count;
import std.conv     : to;
import std.path     : buildPath;
import std.string   : indexOf;
import std.range    : empty;

import qte_meta;
import qte_cli;

// ─────────────────────────────────────────────────────────────────────────────
// Точка входа подкоманды
// ─────────────────────────────────────────────────────────────────────────────

int run(string[] args, string projectRoot, CliArgs cli)
{
    if (cli.hasHelp || args.length == 0)
    {
        printHelp();
        return 0;
    }

    string subcmd = args[0];
    string[] rest = args[1 .. $];

    string csvPath = buildPath(projectRoot, "registry", "functions.csv");
    auto reg = loadRegistry(csvPath);

    switch (subcmd)
    {
        case "list":     return cmdList(reg, projectRoot, cli);
        case "find":     return cmdFind(reg, rest, cli);
        case "next":     return cmdNext(reg, rest, cli);
        case "gaps":     return cmdGaps(reg, cli);
        case "check":    return cmdCheck(reg, projectRoot, cli);
        case "module":   return cmdModule(reg, projectRoot, rest, cli);
        case "orphans":  return cmdOrphans(reg, projectRoot, cli);
        default:
            stderr.writeln("qte index: неизвестная подкоманда '", subcmd, "'");
            printHelp();
            return 2;
    }
}

void printHelp()
{
    writeln(
        "qte index — анализ таблицы pFunQt\n" ~
        "\n" ~
        "ПОДКОМАНДЫ:\n" ~
        "  list                        Сводка: модули и количество функций\n" ~
        "  find <substring>            Найти функции по подстроке (case-insensitive)\n" ~
        "                              Ищет в имени C-функции и в имени модуля.\n" ~
        "                              Для D-классов используйте `qte class <Name>`\n" ~
        "  next [from]                 Следующий свободный индекс (по умолч. с 1)\n" ~
        "  gaps [--min N]              Дыры в нумерации (мин. ширина N, по умолч. 50)\n" ~
        "  gaps --plan N               Дыры ширины >= N, по убыванию ширины\n" ~
        "                              (выбор блока под новый класс генератором)\n" ~
        "  check                       Коллизии и mismatches с gen_*.d\n" ~
        "  module <Name>               Все записи модуля Name\n" ~
        "  orphans                     CSV vs gen_*.d: что есть только с одной стороны\n" ~
        "                              (исторический долг проекта, не баг)\n" ~
        "\n" ~
        "ОПЦИИ:\n" ~
        "  --json                      Вывод в JSON\n" ~
        "  -q, --quiet                 Без шапок и итоговых сообщений\n" ~
        "  --case                      Чувствительный к регистру поиск в `find`\n");
}

// ─────────────────────────────────────────────────────────────────────────────
// list
// ─────────────────────────────────────────────────────────────────────────────

int cmdList(FuncEntry[] reg, string projectRoot, CliArgs cli)
{
    auto modules = listModules(reg);
    // Актуальный маппинг модуль → DLL из registerModule (CSV-колонка устарела)
    auto dllMap = moduleDllMap(projectRoot);
    string resolveDll(string m, string csvDll)
    {
        if (auto p = m in dllMap) return *p;
        return csvDll;   // fallback на CSV, если модуль не найден в gen_*.d
    }
    if (cli.hasJson)
    {
        auto app = appender!string;
        app.put("[");
        bool first = true;
        foreach (m; modules)
        {
            if (!first) app.put(",");
            first = false;
            auto entries = entriesOfModule(reg, m);
            string dll = entries.length ? resolveDll(m, entries[0].dll) : "";
            int minIdx = int.max, maxIdx = int.min;
            foreach (e; entries) {
                if (e.index < minIdx) minIdx = e.index;
                if (e.index > maxIdx) maxIdx = e.index;
            }
            app.put("{");
            app.put(`"module":` ~ escapeJsonString(m) ~ ",");
            app.put(`"dll":`    ~ escapeJsonString(dll) ~ ",");
            app.put(`"count":`  ~ entries.length.to!string ~ ",");
            app.put(`"min":`    ~ minIdx.to!string ~ ",");
            app.put(`"max":`    ~ maxIdx.to!string);
            app.put("}");
        }
        app.put("]");
        writeln(app.data);
        return 0;
    }

    if (!cli.hasQuiet)
        writefln("Модулей: %d, функций всего: %d", modules.length, reg.length);

    writefln("%-32s %-30s %6s %12s",
             "Module", "DLL", "Count", "Range");
    writefln("%-32s %-30s %6s %12s",
             repeat('-', 32), repeat('-', 30), repeat('-', 6), repeat('-', 12));

    foreach (m; modules)
    {
        auto entries = entriesOfModule(reg, m);
        if (entries.length == 0) continue;
        string dll = resolveDll(m, entries[0].dll);
        int minIdx = int.max, maxIdx = int.min;
        foreach (e; entries) {
            if (e.index < minIdx) minIdx = e.index;
            if (e.index > maxIdx) maxIdx = e.index;
        }
        writefln("%-32s %-30s %6d %5d-%-5d",
                 m, dll, entries.length, minIdx, maxIdx);
    }
    return 0;
}

// ─────────────────────────────────────────────────────────────────────────────
// find
// ─────────────────────────────────────────────────────────────────────────────

int cmdFind(FuncEntry[] reg, string[] rest, CliArgs cli)
{
    if (rest.length == 0)
    {
        stderr.writeln("qte index find: нужна подстрока для поиска");
        return 2;
    }
    string needle = rest[0];
    bool   caseSensitive = ("case" in cli.flags) !is null;

    import std.string : toLower;
    string nLow = caseSensitive ? needle : needle.toLower;

    auto matches = reg.filter!((e) {
        if (caseSensitive)
            return e.funcName.indexOf(needle) >= 0 ||
                   e.module_.indexOf(needle) >= 0;
        return e.funcName.toLower.indexOf(nLow) >= 0 ||
               e.module_.toLower.indexOf(nLow) >= 0;
    })().array;

    if (cli.hasJson)
    {
        auto app = appender!string;
        app.put("[");
        bool first = true;
        foreach (e; matches)
        {
            if (!first) app.put(",");
            first = false;
            app.put("{");
            app.put(`"index":` ~ e.index.to!string ~ ",");
            app.put(`"name":`  ~ escapeJsonString(e.funcName) ~ ",");
            app.put(`"module":`~ escapeJsonString(e.module_) ~ ",");
            app.put(`"dll":`   ~ escapeJsonString(e.dll) ~ ",");
            app.put(`"category":` ~ escapeJsonString(e.category));
            app.put("}");
        }
        app.put("]");
        writeln(app.data);
        return matches.length ? 0 : 1;
    }

    if (matches.length == 0)
    {
        if (!cli.hasQuiet) {
            writeln("Ничего не найдено для '", needle, "'.");
            // Подсказка: если первая буква заглавная и начинается с Q — это
            // вероятно имя D-класса (а не C-функции).
            if (needle.length > 1 && needle[0] == 'Q'
                && needle[1] >= 'A' && needle[1] <= 'Z')
            {
                writeln("Подсказка: '", needle,
                        "' похож на D-класс. Попробуйте: qte class ",
                        needle);
            }
        }
        return 1;
    }
    foreach (e; matches)
        writefln("%5d  %-50s  %-20s  %s",
                 e.index, e.funcName, e.module_, e.dll);
    if (!cli.hasQuiet) writefln("Найдено: %d", matches.length);
    return 0;
}

// ─────────────────────────────────────────────────────────────────────────────
// next
// ─────────────────────────────────────────────────────────────────────────────

int cmdNext(FuncEntry[] reg, string[] rest, CliArgs cli)
{
    int from = 1;
    if (rest.length > 0) {
        try from = rest[0].to!int;
        catch (Exception) {
            stderr.writeln("qte index next: 'from' должно быть числом");
            return 2;
        }
    }
    int next = nextFreeIndex(reg, from);
    if (next < 0) {
        stderr.writeln("Свободных индексов >= ", from, " не найдено");
        return 1;
    }
    if (cli.hasJson)
        writefln(`{"next":%d,"from":%d}`, next, from);
    else
        writeln(next);
    return 0;
}

// ─────────────────────────────────────────────────────────────────────────────
// gaps
// ─────────────────────────────────────────────────────────────────────────────

int cmdGaps(FuncEntry[] reg, CliArgs cli)
{
    int minWidth = 50;
    // --plan N: дыры ширины >= N, по убыванию ширины (для выбора блока генератором)
    bool planMode = false;
    if (auto pp = "plan" in cli.opts) {
        planMode = true;
        try minWidth = (*pp).to!int;
        catch (Exception) {
            stderr.writeln("qte index gaps: --plan должен быть числом");
            return 2;
        }
    }
    else if (auto p = "min" in cli.opts) {
        try minWidth = (*p).to!int;
        catch (Exception) {
            stderr.writeln("qte index gaps: --min должен быть числом");
            return 2;
        }
    }
    auto gaps = findGaps(reg, minWidth);
    if (planMode)
        sort!((a, b) => a.width > b.width)(gaps);

    if (cli.hasJson)
    {
        auto app = appender!string;
        app.put("[");
        bool first = true;
        foreach (g; gaps) {
            if (!first) app.put(",");
            first = false;
            app.put("{");
            app.put(`"start":` ~ g.start.to!string ~ ",");
            app.put(`"end":`   ~ g.end.to!string ~ ",");
            app.put(`"width":` ~ g.width.to!string);
            app.put("}");
        }
        app.put("]");
        writeln(app.data);
        return 0;
    }

    if (!cli.hasQuiet) writefln("Дыры >= %d:", minWidth);
    foreach (g; gaps)
    {
        if (planMode)
            writefln("  %d-%d (ширина %d)", g.start, g.end, g.width);
        else
            writefln("  %5d - %5d  (ширина %d)", g.start, g.end, g.width);
    }
    if (!cli.hasQuiet) writefln("Всего дыр: %d", gaps.length);
    return 0;
}

// ─────────────────────────────────────────────────────────────────────────────
// check (только то, что можно проверить по реестру; кросс-проверки в qte check)
// ─────────────────────────────────────────────────────────────────────────────

int cmdCheck(FuncEntry[] reg, string projectRoot, CliArgs cli)
{
    int errCount = 0;

    // Коллизии индексов
    auto dups = findDuplicateIndexes(reg);
    if (dups.length)
    {
        if (!cli.hasJson)
            writeln("[ERROR] Коллизии индексов: ", dups.length);
        foreach (idx; dups)
        {
            auto entries = reg.filter!(e => e.index == idx).array;
            if (cli.hasJson)
            {
                writefln(`{"severity":"error","code":"DUP_INDEX","index":%d,"count":%d}`,
                         idx, entries.length);
            }
            else
            {
                writefln("  index %d (%d записей):", idx, entries.length);
                foreach (e; entries)
                    writefln("    %s in %s (%s)", e.funcName, e.module_, e.dll);
            }
        }
        errCount += dups.length;
    }
    else if (!cli.hasJson && !cli.hasQuiet)
        writeln("[OK] Коллизий индексов нет");

    // Кросс-проверка с gen_*.d
    string genDir = buildPath(projectRoot, "d", "gen");
    auto gens = scanGenModules(genDir);

    auto regOrph = registryOrphans(reg, gens);
    auto genOrph = genOrphans(reg, gens);
    auto mis = findNameMismatches(reg, gens);

    if (!cli.hasJson)
    {
        // Orphans — исторический долг проекта, не баг. Помечаем INFO.
        writefln("[%s] CSV orphans (есть в registry, нет в gen_*.d): %d",
                 regOrph.length ? "INFO" : "OK", regOrph.length);
        writefln("[%s] gen_*.d orphans (есть в gen, нет в registry): %d",
                 genOrph.length ? "INFO" : "OK", genOrph.length);
        if (regOrph.length || genOrph.length)
            writeln("       (для деталей: qte index orphans)");
        writefln("[%s] Name mismatches (CSV != gen_*.d): %d",
                 mis.length ? "ERROR" : "OK", mis.length);

        if (mis.length)
        {
            foreach (m; mis)
                writefln("  index=%d  csv='%s'  gen='%s'  at %s:%d",
                         m.index, m.registryName, m.genName, m.genFile, m.genLine);
        }
    }
    else
    {
        writefln(`{"dups":%d,"csv_orphans":%d,"gen_orphans":%d,"mismatches":%d}`,
                 dups.length, regOrph.length, genOrph.length, mis.length);
    }

    errCount += mis.length;
    return errCount > 0 ? 1 : 0;
}

// ─────────────────────────────────────────────────────────────────────────────
// module
// ─────────────────────────────────────────────────────────────────────────────

int cmdModule(FuncEntry[] reg, string projectRoot, string[] rest, CliArgs cli)
{
    if (rest.length == 0) {
        stderr.writeln("qte index module: нужно имя модуля");
        return 2;
    }
    string mod = rest[0];
    auto entries = entriesOfModule(reg, mod);
    if (entries.length == 0) {
        if (!cli.hasQuiet)
            stderr.writeln("Модуль '", mod, "' не найден");
        return 1;
    }
    sort!((a, b) => a.index < b.index)(entries);

    // Актуальная DLL из registerModule; fallback — CSV-колонка
    auto dllMap = moduleDllMap(projectRoot);
    string dll = entries[0].dll;
    if (auto p = mod in dllMap) dll = *p;

    if (cli.hasJson)
    {
        auto app = appender!string;
        app.put("[");
        bool first = true;
        foreach (e; entries)
        {
            if (!first) app.put(",");
            first = false;
            app.put("{");
            app.put(`"index":` ~ e.index.to!string ~ ",");
            app.put(`"name":`  ~ escapeJsonString(e.funcName) ~ ",");
            app.put(`"category":` ~ escapeJsonString(e.category));
            app.put("}");
        }
        app.put("]");
        writeln(app.data);
        return 0;
    }

    if (!cli.hasQuiet)
        writefln("Модуль %s: %d функций (DLL %s)",
                 mod, entries.length, dll);
    foreach (e; entries)
        writefln("  %5d  %-50s  %s", e.index, e.funcName, e.category);
    return 0;
}

// ─────────────────────────────────────────────────────────────────────────────
// orphans (более подробный вывод чем в check)
// ─────────────────────────────────────────────────────────────────────────────

int cmdOrphans(FuncEntry[] reg, string projectRoot, CliArgs cli)
{
    string genDir = buildPath(projectRoot, "d", "gen");
    auto gens = scanGenModules(genDir);

    auto regOrph = registryOrphans(reg, gens);
    auto genOrph = genOrphans(reg, gens);

    if (cli.hasJson)
    {
        writefln(`{"csv_orphans":%d,"gen_orphans":%d}`,
                 regOrph.length, genOrph.length);
        return 0;
    }

    if (!cli.hasQuiet)
        writefln("CSV orphans (есть в registry, нет в gen_*.d): %d", regOrph.length);
    foreach (e; regOrph)
        writefln("  %5d  %-50s  %s", e.index, e.funcName, e.module_);

    if (!cli.hasQuiet)
        writefln("\ngen_*.d orphans (есть в gen, нет в registry): %d", genOrph.length);
    foreach (f; genOrph)
        writefln("  %5d  %-50s  in %s:%d", f.index, f.funcName, f.module_, f.line);

    return (regOrph.length || genOrph.length) ? 1 : 0;
}

// ─────────────────────────────────────────────────────────────────────────────
// Юнит-тесты (только командные функции; парсеры тестируются в qte_meta)
// ─────────────────────────────────────────────────────────────────────────────

unittest
{
    // Минимальный реестр для тестов
    auto reg = [
        FuncEntry(100, "qteFoo_create",  "QFoo", "qte56_foo.dll", "ctor"),
        FuncEntry(101, "qteFoo_delete",  "QFoo", "qte56_foo.dll", "dtor"),
        FuncEntry(200, "qteBar_method",  "QBar", "qte56_bar.dll", "method"),
    ];

    // ── nextFreeIndex через cmdNext-логику ───────────────────────────────────
    assert(reg.nextFreeIndex(99)  == 99);
    assert(reg.nextFreeIndex(100) == 102);
    assert(reg.nextFreeIndex(200) == 201);

    // ── filter find substring ────────────────────────────────────────────────
    auto found = reg.filter!(e => e.funcName.indexOf("Foo") >= 0).array;
    assert(found.length == 2);

    // ── module ────────────────────────────────────────────────────────────────
    auto qfoo = reg.entriesOfModule("QFoo");
    assert(qfoo.length == 2);
    assert(reg.entriesOfModule("QNone").length == 0);

    // ── duplicates: добавляем коллизию ───────────────────────────────────────
    auto reg2 = reg ~ FuncEntry(100, "qteFooConflict", "QOther", "qte56_other.dll", "method");
    assert(reg2.findDuplicateIndexes == [100]);

    // ── gaps ───────────────────────────────────────────────────────────────────
    auto gaps = reg.findGaps(50);
    // 1..99 (99), 102..199 (98), 201..21999 (21799). Все ≥ 50.
    assert(gaps.length == 3);
    assert(gaps[0].start == 1   && gaps[0].end == 99);
    assert(gaps[1].start == 102 && gaps[1].end == 199);
    assert(gaps[2].start == 201);

    // ── findGaps с большим minWidth ──────────────────────────────────────────
    auto bigGaps = reg.findGaps(1000);
    // Только последняя: 201..21999 = ширина 21799
    assert(bigGaps.length == 1);
    assert(bigGaps[0].width >= 1000);
}
