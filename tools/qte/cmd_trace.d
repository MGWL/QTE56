/**
 * tools/qte/cmd_trace.d — подкоманда `qte trace <index>`
 *
 * Обратная трассировка одного pFunQt-слота:
 *   1. REGISTRY    — запись в registry/functions.csv
 *   2. C++ EXPORT  — declaration (.h) и implementation (.cpp)
 *   3. D-LOADER    — где вызывается mixin(generateFunQt(N, ...))
 *   4. D-CALLERS   — где используется pFunQt[N] (исключая регистрацию)
 *
 * v1: четыре секции, без анализа D-метода-обёртки.
 * v2 (опционально): добавить wrapper-метод и его потребителей в test/snip.
 *
 * Использование:
 *   qte trace 19134            обычный вывод
 *   qte trace 19134 --json     машинный вывод
 *   qte trace 99999            индекс не найден (exit 1)
 */
module cmd_trace;

import std.stdio    : writeln, writefln, stderr;
import std.array    : appender, array, join;
import std.algorithm: filter, sort, count, group;
import std.conv     : to, ConvException;
import std.path     : buildPath;
import std.file     : exists;

import qte_meta;
import qte_cli;

int run(string[] args, string projectRoot, CliArgs cli)
{
    if (cli.hasHelp || args.length == 0)
    {
        printHelp();
        return 0;
    }

    int idx;
    try idx = args[0].to!int;
    catch (ConvException)
    {
        stderr.writeln("qte trace: индекс должен быть числом, получено '",
                       args[0], "'");
        return 2;
    }

    if (idx <= 0 || idx >= 22000)
    {
        stderr.writeln("qte trace: индекс ", idx, " вне диапазона [1, 22000)");
        return 2;
    }

    // Загружаем все источники
    string csvPath = buildPath(projectRoot, "registry", "functions.csv");
    auto reg = loadRegistry(csvPath);

    string genDir = buildPath(projectRoot, "d", "gen");
    string cppDir = cppRoot(projectRoot);   // cpp/qt5 если есть, иначе cpp

    // 1. Registry
    FuncEntry regEntry;
    bool inRegistry = false;
    foreach (e; reg)
    {
        if (e.index == idx)
        {
            // Если несколько — берём первое, но запомним остальные для warning
            if (!inRegistry) { regEntry = e; inRegistry = true; }
        }
    }
    auto regAll = reg.filter!(e => e.index == idx).array;

    // 2. C++ exports — ищем по имени из registry; если в registry нет —
    //    пропускаем (без имени не за что зацепиться)
    CppHit[] cppHits;
    if (inRegistry)
        cppHits = findCppExports(cppDir, regEntry.funcName);

    // 3. D-loader — generateFunQt(N, ...) в gen_*.d
    auto gens = scanGenModules(genDir);
    GenFunc[] dLoader;
    string    dLoaderFile;
    foreach (g; gens)
    {
        foreach (f; g.funcs)
        {
            if (f.index == idx)
            {
                dLoader ~= f;
                if (dLoaderFile.length == 0) dLoaderFile = g.filePath;
            }
        }
    }

    // 4. D-callers — pFunQt[N] в gen_*.d (исключая регистрацию)
    auto callers = findPFunQtCallers(genDir, idx);

    if (cli.hasJson)
        return outputJson(idx, inRegistry, regEntry, regAll, cppHits, dLoader, gens, callers);
    else
        return outputText(idx, inRegistry, regEntry, regAll, cppHits, dLoader, gens, callers, cli);
}

void printHelp()
{
    writeln(
        "qte trace <index> -- обратная трассировка pFunQt-слота\n" ~
        "\n" ~
        "Показывает 4 секции:\n" ~
        "  REGISTRY    запись в registry/functions.csv\n" ~
        "  C++ EXPORT  declaration (.h) и implementation (.cpp)\n" ~
        "  D-LOADER    mixin(generateFunQt(N, ...))\n" ~
        "  D-CALLERS   использования pFunQt[N] в gen_*.d\n" ~
        "\n" ~
        "ОПЦИИ:\n" ~
        "  --json   машинный вывод\n" ~
        "  -q       минимальный\n" ~
        "\n" ~
        "ПРИМЕРЫ:\n" ~
        "  qte trace 19134           qteQSql_qBindBytes\n" ~
        "  qte trace 20157           QTextCodec.codecAvailable\n");
}

// ─────────────────────────────────────────────────────────────────────────────
// Text output
// ─────────────────────────────────────────────────────────────────────────────

int outputText(int idx, bool inRegistry, FuncEntry regEntry, FuncEntry[] regAll,
               CppHit[] cppHits, GenFunc[] dLoader, GenModule[] gens,
               PFunQtCaller[] callers, CliArgs cli)
{
    if (!cli.hasQuiet)
        writefln("=== pFunQt[%d] ===", idx);
    writeln();

    // 1. Registry
    writeln("REGISTRY (registry/functions.csv):");
    if (!inRegistry)
        writeln("  [WARN] Индекс не найден в registry");
    else
    {
        writefln("  %5d  %-50s %-25s %s",
                 regEntry.index, regEntry.funcName, regEntry.module_,
                 regEntry.dll ~ "  (" ~ regEntry.category ~ ")");
        if (regAll.length > 1)
        {
            writefln("  [WARN] Коллизия! Индекс %d зарегистрирован %d раз:",
                     idx, regAll.length);
            foreach (e; regAll[1 .. $])
                writefln("        %s in %s (%s)", e.funcName, e.module_, e.dll);
        }
    }
    writeln();

    // 2. C++
    writeln("C++ EXPORT:");
    if (!inRegistry)
        writeln("  (нет имени в registry — поиск пропущен)");
    else if (cppHits.length == 0)
        writefln("  [WARN] Имя '%s' не найдено в cpp/qte56_*", regEntry.funcName);
    else
    {
        // Группируем по файлу
        string[] files;
        CppHit[][string] byFile;
        foreach (h; cppHits)
        {
            byFile[h.filePath] ~= h;
            if (files.length == 0 || files[$ - 1] != h.filePath)
                files ~= h.filePath;
        }
        sort(files);
        foreach (f; files)
        {
            auto hits = byFile[f];
            string kind = hits[0].kind == ".h" ? "declaration" : "implementation";
            // Несколько вхождений в одном файле — указываем все строки
            int[] lines;
            foreach (h; hits) lines ~= h.line;
            sort(lines);
            string lineStr;
            foreach (i, l; lines)
            {
                if (i > 0) lineStr ~= ",";
                lineStr ~= l.to!string;
            }
            writefln("  %s:%s   %s", f, lineStr, kind);
            // Покажем сниппет первой строки
            writefln("    %s", hits[0].snippet);
        }
    }
    writeln();

    // 3. D-loader
    writeln("D-LOADER (gen_*.d с generateFunQt):");
    if (dLoader.length == 0)
        writefln("  [WARN] Не найдено generateFunQt(%d, ...) в gen_*.d", idx);
    else foreach (f; dLoader)
    {
        // Найдём модуль для красивого вывода
        string modName, dllName;
        foreach (g; gens)
        {
            foreach (gf; g.funcs)
            {
                if (gf.index == idx)
                {
                    modName = g.moduleName;
                    dllName = g.dllFile;
                    break;
                }
            }
        }
        // f.module_ имеет имя модуля как в registry/MD
        // dLoaderFile уже найдено
        // Найдём gen-файл этого индекса
        string genFile;
        foreach (g; gens)
        {
            foreach (gf; g.funcs)
            {
                if (gf.index == idx) { genFile = g.filePath; break; }
            }
        }
        writefln("  %s:%d", genFile.length ? genFile : "?", f.line);
        writefln("    mixin(generateFunQt(%d, \"%s\", \"%s\"));",
                 f.index, f.funcName, f.module_);
    }
    writeln();

    // 4. D-callers
    writefln("D-CALLERS (использования pFunQt[%d]):", idx);
    if (callers.length == 0)
        writeln("  [INFO] Не используется (только регистрация)");
    else foreach (c; callers)
    {
        writefln("  %s:%d", c.filePath, c.line);
        writefln("    %s", c.snippet);
    }

    // Возвращаем код успеха/ошибки в зависимости от результата
    if (!inRegistry || dLoader.length == 0) return 1;
    return 0;
}

// ─────────────────────────────────────────────────────────────────────────────
// JSON output
// ─────────────────────────────────────────────────────────────────────────────

int outputJson(int idx, bool inRegistry, FuncEntry regEntry, FuncEntry[] regAll,
               CppHit[] cppHits, GenFunc[] dLoader, GenModule[] gens,
               PFunQtCaller[] callers)
{
    auto app = appender!string;
    app.put("{");
    app.put(`"index":` ~ idx.to!string ~ ",");

    // registry
    app.put(`"registry":`);
    if (!inRegistry) app.put("null");
    else {
        app.put("{");
        app.put(`"index":` ~ regEntry.index.to!string ~ ",");
        app.put(`"name":` ~ escapeJsonString(regEntry.funcName) ~ ",");
        app.put(`"module":` ~ escapeJsonString(regEntry.module_) ~ ",");
        app.put(`"dll":` ~ escapeJsonString(regEntry.dll) ~ ",");
        app.put(`"category":` ~ escapeJsonString(regEntry.category) ~ ",");
        app.put(`"duplicates":` ~ (regAll.length > 1 ?
            (regAll.length - 1).to!string : "0"));
        app.put("}");
    }
    app.put(",");

    // cpp
    app.put(`"cpp":[`);
    foreach (i, h; cppHits) {
        if (i > 0) app.put(",");
        app.put("{");
        app.put(`"file":` ~ escapeJsonString(h.filePath) ~ ",");
        app.put(`"line":` ~ h.line.to!string ~ ",");
        app.put(`"kind":` ~ escapeJsonString(h.kind) ~ ",");
        app.put(`"snippet":` ~ escapeJsonString(h.snippet));
        app.put("}");
    }
    app.put("],");

    // d-loader
    app.put(`"dLoader":[`);
    foreach (i, f; dLoader) {
        if (i > 0) app.put(",");
        // Находим файл этого f
        string genFile;
        foreach (g; gens)
            foreach (gf; g.funcs)
                if (gf.index == idx) genFile = g.filePath;
        app.put("{");
        app.put(`"file":` ~ escapeJsonString(genFile) ~ ",");
        app.put(`"line":` ~ f.line.to!string ~ ",");
        app.put(`"name":` ~ escapeJsonString(f.funcName) ~ ",");
        app.put(`"module":` ~ escapeJsonString(f.module_));
        app.put("}");
    }
    app.put("],");

    // d-callers
    app.put(`"dCallers":[`);
    foreach (i, c; callers) {
        if (i > 0) app.put(",");
        app.put("{");
        app.put(`"file":` ~ escapeJsonString(c.filePath) ~ ",");
        app.put(`"line":` ~ c.line.to!string ~ ",");
        app.put(`"snippet":` ~ escapeJsonString(c.snippet));
        app.put("}");
    }
    app.put("]");
    app.put("}");
    writeln(app.data);

    return (!inRegistry || dLoader.length == 0) ? 1 : 0;
}

// ─────────────────────────────────────────────────────────────────────────────
// Юнит-тесты (только argparse-логика; интеграция требует реальных файлов)
// ─────────────────────────────────────────────────────────────────────────────

unittest
{
    CliArgs cli;
    cli.hasJson = true;

    // Невалидный аргумент → exit 2
    auto rc1 = run([], "/tmp/nonex", cli);
    assert(rc1 == 0, "Без аргументов — должен показать help, exit 0");

    auto rc2 = run(["abc"], "/tmp/nonex", cli);
    assert(rc2 == 2, "Не-число → exit 2");

    auto rc3 = run(["-1"], "/tmp/nonex", cli);
    assert(rc3 == 2, "Отрицательный → exit 2");

    auto rc4 = run(["99999"], "/tmp/nonex", cli);
    assert(rc4 == 2, "Вне диапазона → exit 2");
}
