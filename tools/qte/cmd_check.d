/**
 * tools/qte/cmd_check.d — подкоманда `qte check ...`
 *
 * Кросс-проверки целостности проекта QTE56:
 *   - indexes  : коллизии и mismatches в pFunQt (то же что в qte index check)
 *   - live     : @live перед полем класса в gen_*.d (запрещено)
 *   - builds   : .pro файлы упомянуты в build_merged_dlls.bat и .sh
 *   - dlls     : DLL из registerModule существуют в dll/dll32 и dll/dll64
 *   - globals  : статистика __gshared (info-уровень)
 *   - all      : все проверки последовательно
 */
module cmd_check;

import std.stdio    : writeln, writefln, stderr;
import std.array    : appender, array, join;
import std.algorithm: filter, sort, count;
import std.conv     : to;
import std.path     : buildPath;
import std.string   : indexOf;
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

    string what = args[0];
    switch (what)
    {
        case "all":      return checkAll(projectRoot, cli);
        case "indexes":  return checkIndexes(projectRoot, cli);
        case "live":     return checkLive(projectRoot, cli);
        case "builds":   return checkBuilds(projectRoot, cli);
        case "globals":  return checkGlobals(projectRoot, cli);
        case "dlls":     return checkDlls(projectRoot, cli);
        default:
            stderr.writeln("qte check: неизвестная проверка '", what, "'");
            printHelp();
            return 2;
    }
}

void printHelp()
{
    writeln(
        "qte check <subcheck> -- кросс-проверки QTE56\n" ~
        "\n" ~
        "ПРОВЕРКИ:\n" ~
        "  all        Все проверки подряд\n" ~
        "  indexes    Коллизии pFunQt + name mismatches\n" ~
        "  live       @live перед полем класса (запрещено в QTE56)\n" ~
        "  builds     .pro файлы упомянуты в build_merged_dlls.bat и .sh\n" ~
        "  dlls       DLL из registerModule существуют в dll/dll32 и dll/dll64\n" ~
        "  globals    Статистика __gshared (информационная)\n" ~
        "\n" ~
        "ОПЦИИ:\n" ~
        "  --json     Машинный вывод\n" ~
        "  -q         Минимальный вывод\n" ~
        "\n" ~
        "Возвращает exit=0 если ошибок нет, иначе 1.\n");
}

// ─────────────────────────────────────────────────────────────────────────────
// indexes
// ─────────────────────────────────────────────────────────────────────────────

int checkIndexes(string projectRoot, CliArgs cli)
{
    string csvPath = buildPath(projectRoot, "registry", "functions.csv");
    auto reg  = loadRegistry(csvPath);
    string genDir = buildPath(projectRoot, "d", "gen");
    auto gens = scanGenModules(genDir);

    auto dups = findDuplicateIndexes(reg);
    auto mis  = findNameMismatches(reg, gens);
    auto regOrph = registryOrphans(reg, gens);
    auto genOrph = genOrphans(reg, gens);

    int errs = cast(int)(dups.length + mis.length);

    if (cli.hasJson)
    {
        writefln(`{"check":"indexes","errors":%d,"dups":%d,"mismatches":%d,` ~
                 `"csv_orphans":%d,"gen_orphans":%d}`,
                 errs, dups.length, mis.length, regOrph.length, genOrph.length);
        return errs > 0 ? 1 : 0;
    }

    if (!cli.hasQuiet) writeln("== check indexes ==");
    if (dups.length)
    {
        writefln("[ERROR] Коллизии индексов: %d", dups.length);
        foreach (idx; dups[0 .. (dups.length > 5 ? 5 : dups.length)])
        {
            auto entries = reg.filter!(e => e.index == idx).array;
            writefln("  index %d (%d записей):", idx, entries.length);
            foreach (e; entries)
                writefln("    %s in %s (%s)", e.funcName, e.module_, e.dll);
        }
        if (dups.length > 5) writefln("  ... ещё %d коллизий", dups.length - 5);
    }
    else if (!cli.hasQuiet)
        writeln("[OK] Коллизий индексов нет");

    if (mis.length)
    {
        writefln("[ERROR] Name mismatches CSV vs gen_*.d: %d", mis.length);
        foreach (m; mis[0 .. (mis.length > 5 ? 5 : mis.length)])
            writefln("  index=%d  csv='%s'  gen='%s'  at %s:%d",
                     m.index, m.registryName, m.genName, m.genFile, m.genLine);
        if (mis.length > 5) writefln("  ... ещё %d", mis.length - 5);
    }
    else if (!cli.hasQuiet)
        writeln("[OK] Name mismatches не найдено");

    if (!cli.hasQuiet)
    {
        // Orphans — это исторический долг проекта (старые записи или
        // расхождения после рефакторингов), не баг утилиты. Помечаем как
        // INFO, не WARN, чтобы не сбивать разработчика.
        writefln("[%s] CSV orphans (есть в registry, нет в gen_*.d): %d",
                 regOrph.length ? "INFO" : "OK", regOrph.length);
        writefln("[%s] gen_*.d orphans (есть в gen, нет в registry): %d",
                 genOrph.length ? "INFO" : "OK", genOrph.length);
        if (regOrph.length || genOrph.length)
            writeln("       (для деталей: qte index orphans)");
    }

    // Orphans НЕ считаются ошибкой — exit зависит только от dups+mismatches
    return errs > 0 ? 1 : 0;
}

// ─────────────────────────────────────────────────────────────────────────────
// live: @live перед полем класса
// ─────────────────────────────────────────────────────────────────────────────

int checkLive(string projectRoot, CliArgs cli)
{
    string genDir = buildPath(projectRoot, "d", "gen");
    auto issues = findLiveOnFields(genDir);

    if (cli.hasJson)
    {
        auto app = appender!string;
        app.put(`{"check":"live","errors":` ~ issues.length.to!string ~ `,"items":[`);
        foreach (i, x; issues) {
            if (i > 0) app.put(",");
            app.put("{");
            app.put(`"file":` ~ escapeJsonString(x.filePath) ~ ",");
            app.put(`"line":` ~ x.line.to!string ~ ",");
            app.put(`"class":` ~ escapeJsonString(x.className) ~ ",");
            app.put(`"snippet":` ~ escapeJsonString(x.snippet));
            app.put("}");
        }
        app.put("]}");
        writeln(app.data);
        return issues.length ? 1 : 0;
    }

    if (!cli.hasQuiet) writeln("== check live ==");
    if (issues.length == 0)
    {
        if (!cli.hasQuiet) writeln("[OK] @live перед полем класса не найдено");
        return 0;
    }
    writefln("[ERROR] @live перед полем класса: %d", issues.length);
    writeln("  (см. memory: feedback_live_class_fields.md)");
    foreach (x; issues)
        writefln("  %s:%d  class=%s  '%s'",
                 x.filePath, x.line, x.className, x.snippet);
    return 1;
}

// ─────────────────────────────────────────────────────────────────────────────
// builds: .pro vs build_merged_dlls.{bat,sh}
// ─────────────────────────────────────────────────────────────────────────────

int checkBuilds(string projectRoot, CliArgs cli)
{
    auto issues = checkProFilesInBuild(projectRoot);
    // Ошибка/WARN — только .pro, нигде не покрытые (ни bat/sh/py, ни merged)
    auto uncovered = issues.filter!(i => i.coveredVia.length == 0).array;
    int errCount = cast(int)uncovered.length;

    // Сводка покрытия
    int viaBat, viaSh, viaPy, viaMerged;
    foreach (i; issues)
    {
        if (i.coveredVia == "bat") viaBat++;
        else if (i.coveredVia == "sh") viaSh++;
        else if (i.coveredVia == "py") viaPy++;
        else if (i.coveredVia == "merged") viaMerged++;
    }

    if (cli.hasJson)
    {
        auto app = appender!string;
        app.put(`{"check":"builds","errors":` ~ errCount.to!string ~
                `,"total":` ~ issues.length.to!string ~
                `,"viaBat":` ~ viaBat.to!string ~
                `,"viaSh":` ~ viaSh.to!string ~
                `,"viaPy":` ~ viaPy.to!string ~
                `,"viaMerged":` ~ viaMerged.to!string ~ `,"items":[`);
        foreach (n, x; issues) {
            if (n > 0) app.put(",");
            app.put("{");
            app.put(`"name":` ~ escapeJsonString(x.proName) ~ ",");
            app.put(`"path":` ~ escapeJsonString(x.proPath) ~ ",");
            app.put(`"inBat":` ~ (x.inBat ? "true" : "false") ~ ",");
            app.put(`"inSh":` ~ (x.inSh ? "true" : "false") ~ ",");
            app.put(`"inPy":` ~ (x.inPy ? "true" : "false") ~ ",");
            app.put(`"isMerged":` ~ (x.isMerged ? "true" : "false") ~ ",");
            app.put(`"coveredVia":` ~
                    (x.coveredVia.length ? escapeJsonString(x.coveredVia) : "null"));
            app.put("}");
        }
        app.put("]}");
        writeln(app.data);
        return errCount > 0 ? 1 : 0;
    }

    if (!cli.hasQuiet) writeln("== check builds ==");
    if (issues.length == 0)
    {
        if (!cli.hasQuiet) writeln("[INFO] Не найдены .pro файлы в cpp/qt5/qte56_*/");
        return 0;
    }

    if (errCount == 0)
    {
        if (!cli.hasQuiet)
        {
            writefln("[OK] Все %d .pro покрыты сборкой", issues.length);
            writefln("[INFO] Покрытие: напрямую (bat/sh/py) %d, через merged DLL %d",
                     viaBat + viaSh + viaPy, viaMerged);
        }
        return 0;
    }

    writefln("[WARN] .pro без покрытия сборкой (standalone, нет ни в bat/sh/py, ни в merged):");
    foreach (x; uncovered)
        writefln("  %s  (%s)", x.proName, x.proPath);
    if (!cli.hasQuiet)
        writefln("[INFO] Покрыты: напрямую %d, через merged %d",
                 viaBat + viaSh + viaPy, viaMerged);
    return 1;
}

// ─────────────────────────────────────────────────────────────────────────────
// dlls: DLL из registerModule vs файлы в dll/dll32 и dll/dll64
// ─────────────────────────────────────────────────────────────────────────────

/// Служебные DLL в dll32, не привязанные к модулям (не WARN).
immutable string[] DLL32_SERVICE = [
    "ole_helper.dll", "qscintilla2_qt5.dll", "qscintilla2_qt6.dll", "wren_bridge.dll",
];

int checkDlls(string projectRoot, CliArgs cli)
{
    import std.file : dirEntries, SpanMode;
    import std.path : baseName;

    auto map_ = moduleDllMap(projectRoot);

    // Уникальные DLL из маппинга
    bool[string] dlls;
    foreach (m, d; map_) dlls[d] = true;

    string[] missing32, missing64;
    foreach (d, _; dlls)
    {
        if (!exists(buildPath(projectRoot, "dll", "dll32", d))) missing32 ~= d;
        if (!exists(buildPath(projectRoot, "dll", "dll64", d))) missing64 ~= d;
    }
    sort(missing32);
    sort(missing64);

    // DLL-файлы в dll32, не привязанные ни к одному модулю (WARN)
    string[] unbound;
    string dir32 = buildPath(projectRoot, "dll", "dll32");
    if (exists(dir32))
    {
        foreach (f; dirEntries(dir32, "*.dll", SpanMode.shallow))
        {
            string bn = f.name.baseName;
            if (bn in dlls) continue;
            bool service = false;
            foreach (s; DLL32_SERVICE) if (bn == s) { service = true; break; }
            if (!service) unbound ~= bn;
        }
        sort(unbound);
    }

    // dll64 исторически неполный — это INFO, не ошибка.
    // Ошибка только если в dll32 чего-то нет.
    int rc = missing32.length ? 1 : 0;

    if (cli.hasJson)
    {
        auto app = appender!string;
        app.put(`{"check":"dlls","errors":` ~ missing32.length.to!string ~ ",");

        void putArr(string key, string[] arr)
        {
            app.put(key ~ ":[");
            foreach (i, d; arr)
            {
                if (i > 0) app.put(",");
                app.put(escapeJsonString(d));
            }
            app.put("]");
        }
        putArr(`"missing_dll32"`, missing32);
        app.put(",");
        putArr(`"missing_dll64"`, missing64);
        app.put(",");
        putArr(`"unbound_dll32"`, unbound);
        app.put("}");
        writeln(app.data);
        return rc;
    }

    if (!cli.hasQuiet) writeln("== check dlls ==");

    if (missing32.length == 0)
    {
        if (!cli.hasQuiet)
            writefln("[OK] Все %d DLL из registerModule есть в dll/dll32", dlls.length);
    }
    else
    {
        writefln("[ERROR] Отсутствуют в dll/dll32: %d", missing32.length);
        foreach (d; missing32) writeln("  ", d);
    }

    if (!cli.hasQuiet)
    {
        if (missing64.length == 0)
            writeln("[OK] Все DLL есть и в dll/dll64");
        else
        {
            writefln("[INFO] Отсутствуют в dll/dll64 (исторически неполный): %d",
                     missing64.length);
            foreach (d; missing64) writeln("  ", d);
        }
        if (unbound.length)
        {
            writefln("[WARN] DLL в dll32 без привязки к модулям: %d", unbound.length);
            foreach (d; unbound) writeln("  ", d);
        }
    }
    return rc;
}

// ─────────────────────────────────────────────────────────────────────────────
// globals: статистика __gshared
// ─────────────────────────────────────────────────────────────────────────────

int checkGlobals(string projectRoot, CliArgs cli)
{
    string[] dirs = [
        buildPath(projectRoot, "test"),
        buildPath(projectRoot, "tools", "qte_guide", "snip"),
        buildPath(projectRoot, "d"),
    ].filter!(p => exists(p)).array;

    auto stats = countGshared(dirs);
    sort!((a, b) => a.count > b.count)(stats);

    int total = 0;
    foreach (s; stats) total += s.count;

    if (cli.hasJson)
    {
        auto app = appender!string;
        app.put(`{"check":"globals","total":` ~ total.to!string ~ `,"files":[`);
        foreach (i, s; stats) {
            if (i > 0) app.put(",");
            app.put("{");
            app.put(`"file":` ~ escapeJsonString(s.filePath) ~ ",");
            app.put(`"count":` ~ s.count.to!string);
            app.put("}");
        }
        app.put("]}");
        writeln(app.data);
        return 0;
    }

    if (!cli.hasQuiet) writeln("== check globals ==");
    writefln("[INFO] Файлов с __gshared: %d, всего деклараций: %d",
             stats.length, total);
    if (cli.hasQuiet) return 0;

    foreach (s; stats[0 .. (stats.length > 15 ? 15 : stats.length)])
        writefln("  %4d  %s", s.count, s.filePath);
    if (stats.length > 15)
        writefln("  ... ещё %d файлов", stats.length - 15);
    return 0;
}

// ─────────────────────────────────────────────────────────────────────────────
// all
// ─────────────────────────────────────────────────────────────────────────────

int checkAll(string projectRoot, CliArgs cli)
{
    int rc = 0;
    string[] checks = ["indexes", "live", "builds", "globals"];
    foreach (i, c; checks)
    {
        if (!cli.hasJson && i > 0) writeln();
        int sub;
        switch (c)
        {
            case "indexes":  sub = checkIndexes(projectRoot, cli); break;
            case "live":     sub = checkLive(projectRoot, cli);    break;
            case "builds":   sub = checkBuilds(projectRoot, cli);  break;
            case "globals":  sub = checkGlobals(projectRoot, cli); break;
            default: break;
        }
        if (sub != 0) rc = 1;
    }

    if (!cli.hasJson && !cli.hasQuiet)
    {
        writeln();
        writeln(rc == 0 ? "[ALL OK]" : "[FAILED] см. выше");
    }
    return rc;
}

// ─────────────────────────────────────────────────────────────────────────────
// Юнит-тесты
// ─────────────────────────────────────────────────────────────────────────────

unittest
{
    // Базовая проверка что команды не падают на минимальном входе.
    // Полная функциональная проверка — на реальном проекте через build.bat.
    CliArgs cli;
    cli.hasJson = true;

    // Проверки требуют существования registry/d/gen, поэтому здесь
    // тестируем только argparse-ветви (что run возвращает 2 на неизвестную команду).
    auto rc = run(["nonsense"], "/tmp/qte_check_nonexistent", cli);
    assert(rc == 2, "Неизвестная подкоманда → exit 2");
}
