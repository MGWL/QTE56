/**
 * tools/qte/cmd_dll.d — подкоманда `qte dll [module]`
 *
 * Таблица модуль → DLL → группа (merged/standalone) на основе актуального
 * маппинга из registerModule() в d/gen/gen_*.d (moduleDllMap).
 *
 * Merged DLL (6): qte56_widgets, qte56_foundation, qte56_views, qte56_text,
 * qte56_dialogs, qte56_mainwin — остальные standalone.
 *
 * Использование:
 *   qte dll                       вся таблица
 *   qte dll QComboBox             только этот модуль
 *   qte dll --missing dll32       модули без DLL в dll/dll32
 *   qte dll --missing dll64       модули без DLL в dll/dll64
 *   qte dll --json                машинный вывод
 */
module cmd_dll;

import std.stdio    : writeln, writefln, stderr;
import std.array    : appender, array, join;
import std.algorithm: sort, filter;
import std.conv     : to;
import std.path     : buildPath;
import std.file     : exists;
import std.string   : chomp;

import qte_meta;
import qte_cli;

/// Имена merged-DLL проекта (без расширения).
immutable string[] MERGED_DLLS = [
    "qte56_widgets", "qte56_foundation", "qte56_views",
    "qte56_text", "qte56_dialogs", "qte56_mainwin",
];

/// Группа DLL: "merged" или "standalone".
string dllGroup(string dllFile)
{
    string base = dllFile.chomp(".dll");   // отрезать расширение
    foreach (m; MERGED_DLLS)
        if (base == m) return "merged";
    return "standalone";
}

int run(string[] args, string projectRoot, CliArgs cli)
{
    if (cli.hasHelp)
    {
        printHelp();
        return 0;
    }

    auto map_ = moduleDllMap(projectRoot);
    if (map_.length == 0)
    {
        stderr.writeln("qte dll: не найдены registerModule() в d/gen/");
        return 2;
    }

    // --missing dll32|dll64
    if (auto pm = "missing" in cli.opts)
        return cmdMissing(map_, projectRoot, *pm, cli);

    // Фильтр по модулю (позиционный аргумент)
    string only;
    if (args.length > 0) only = args[0];

    if (only.length && (only in map_) is null)
    {
        if (cli.hasJson)
            writefln(`{"error":"module not found","module":%s}`,
                     escapeJsonString(only));
        else
            stderr.writeln("Модуль '", only, "' не найден в d/gen/");
        return 1;
    }

    // Собираем строки: модуль → dll → группа (сортировка по DLL, потом модуль)
    struct Row { string module_; string dll; string group; }
    Row[] rows;
    foreach (m, d; map_)
    {
        if (only.length && m != only) continue;
        rows ~= Row(m, d, dllGroup(d));
    }
    sort!((a, b) => a.dll != b.dll ? a.dll < b.dll : a.module_ < b.module_)(rows);

    if (cli.hasJson)
    {
        auto app = appender!string;
        app.put("[");
        foreach (i, r; rows)
        {
            if (i > 0) app.put(",");
            app.put("{");
            app.put(`"module":` ~ escapeJsonString(r.module_) ~ ",");
            app.put(`"dll":`    ~ escapeJsonString(r.dll) ~ ",");
            app.put(`"group":`  ~ escapeJsonString(r.group));
            app.put("}");
        }
        app.put("]");
        writeln(app.data);
        return 0;
    }

    if (!cli.hasQuiet)
        writefln("Модулей: %d", rows.length);
    writefln("%-32s %-28s %s", "Module", "DLL", "Group");
    writefln("%-32s %-28s %s",
             repeat('-', 32), repeat('-', 28), repeat('-', 10));
    foreach (r; rows)
        writefln("%-32s %-28s %s", r.module_, r.dll, r.group);
    return 0;
}

/// Модули, чьи DLL отсутствуют в dll/<dir> (dll32 или dll64).
int cmdMissing(string[string] map_, string projectRoot, string arch, CliArgs cli)
{
    if (arch != "dll32" && arch != "dll64")
    {
        stderr.writeln("qte dll --missing: ожидается dll32 или dll64, получено '",
                       arch, "'");
        return 2;
    }
    string dllDir = buildPath(projectRoot, "dll", arch);

    // Уникальные DLL → модули
    string[][string] byDll;
    foreach (m, d; map_)
        byDll[d] ~= m;

    string[] missingDlls;
    foreach (d, mods; byDll)
    {
        if (!exists(buildPath(dllDir, d)))
        {
            missingDlls ~= d;
        }
    }
    sort(missingDlls);

    if (cli.hasJson)
    {
        auto app = appender!string;
        app.put("{");
        app.put(`"arch":` ~ escapeJsonString(arch) ~ ",");
        app.put(`"missing":[`);
        foreach (i, d; missingDlls)
        {
            if (i > 0) app.put(",");
            app.put("{");
            app.put(`"dll":` ~ escapeJsonString(d) ~ ",");
            app.put(`"modules":[`);
            auto mods = byDll[d];
            sort(mods);
            foreach (j, m; mods)
            {
                if (j > 0) app.put(",");
                app.put(escapeJsonString(m));
            }
            app.put("]}");
        }
        app.put("]}");
        writeln(app.data);
        return missingDlls.length ? 1 : 0;
    }

    if (missingDlls.length == 0)
    {
        if (!cli.hasQuiet)
            writefln("[OK] Все DLL присутствуют в dll/%s", arch);
        return 0;
    }
    writefln("[INFO] Отсутствуют в dll/%s: %d DLL", arch, missingDlls.length);
    foreach (d; missingDlls)
    {
        auto mods = byDll[d];
        sort(mods);
        writefln("  %-28s  (%s)", d, mods.join(", "));
    }
    return 1;
}

void printHelp()
{
    writeln(
        "qte dll [module] — таблица модуль → DLL → группа (merged/standalone)\n" ~
        "\n" ~
        "Источник — registerModule() в d/gen/gen_*.d (актуальный маппинг,\n" ~
        "в отличие от устаревшей колонки dll в registry/functions.csv).\n" ~
        "\n" ~
        "ОПЦИИ:\n" ~
        "  --missing dll32|dll64   Какие модули не имеют DLL в dll/dll32|dll64\n" ~
        "  --json                  Машинный вывод\n" ~
        "  -q, --quiet             Без шапок\n" ~
        "\n" ~
        "ПРИМЕРЫ:\n" ~
        "  qte dll                    вся таблица\n" ~
        "  qte dll QComboBox          только этот модуль\n" ~
        "  qte dll --missing dll64    чего не хватает в 64-битных DLL\n");
}

// ─────────────────────────────────────────────────────────────────────────────
// Юнит-тесты
// ─────────────────────────────────────────────────────────────────────────────

unittest
{
    // dllGroup
    assert(dllGroup("qte56_widgets.dll") == "merged");
    assert(dllGroup("qte56_foundation.dll") == "merged");
    assert(dllGroup("qte56_qcore.dll") == "standalone");
    assert(dllGroup("qte56_qpointf.dll") == "standalone");

    // argparse: --missing с значением
    auto c = parseArgs(["--missing", "dll64"]);
    assert(c.opts["missing"] == "dll64");

    auto c2 = parseArgs(["QComboBox"]);
    assert(c2.positional == ["QComboBox"]);
}
