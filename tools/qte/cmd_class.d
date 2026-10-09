/**
 * tools/qte/cmd_class.d — подкоманда `qte class <Name>`
 *
 * Собирает справочник по Qt-классу:
 *   - где определён (gen_*.d файл, диапазон строк)
 *   - какие методы (имя, return type, args, visibility, static)
 *   - какие индексы pFunQt связаны с модулем класса
 *   - где используется (test/, tools/qte_guide/snip/, doc)
 *   - какая DLL содержит реализацию
 *
 * Использование:
 *   qte class QPushButton
 *   qte class QSqlQuery --json
 *   qte class QTextCodec --no-usages       # пропустить scan use
 */
module cmd_class;

import std.stdio    : writeln, writefln, stderr;
import std.array    : appender, join, array;
import std.algorithm: filter, sort, map;
import std.conv     : to;
import std.path     : buildPath, baseName;
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

    string className = args[0];
    bool   noUsages  = ("no-usages" in cli.flags) !is null;

    // 1. Найти класс в gen_*.d
    string genDir = buildPath(projectRoot, "d", "gen");
    auto matches = findClass(genDir, className);

    if (matches.length == 0)
    {
        if (cli.hasJson)
            writefln(`{"error":"class not found","name":%s}`,
                     escapeJsonString(className));
        else
            stderr.writeln("Класс '", className, "' не найден в d/gen/");
        return 1;
    }

    // 2. Загрузить registry для индексов
    string csvPath = buildPath(projectRoot, "registry", "functions.csv");
    auto reg = loadRegistry(csvPath);

    // 3. Где использовать класс (без gen_*.d, чтобы не показывать само определение)
    Usage[] usages;
    if (!noUsages)
    {
        string[] searchDirs = [
            buildPath(projectRoot, "test"),
            buildPath(projectRoot, "tools", "qte_guide", "snip"),
        ].filter!(p => exists(p)).array;

        foreach (cd; matches)
            usages ~= findUsages(searchDirs, className, cd.filePath);
    }

    if (cli.hasJson)
        return outputJson(matches, reg, usages, projectRoot, cli);
    else
        return outputText(matches, reg, usages, projectRoot, cli);
}

void printHelp()
{
    writeln(
        "qte class <Name> -- справочник по Qt-классу\n" ~
        "\n" ~
        "ОПЦИИ:\n" ~
        "  --no-usages       Не сканировать test/ и snip/ для поиска использований\n" ~
        "  --json            Машинный вывод\n" ~
        "  -q, --quiet       Без шапок\n" ~
        "\n" ~
        "ПРИМЕРЫ:\n" ~
        "  qte class QPushButton\n" ~
        "  qte class QSqlQuery --no-usages\n" ~
        "  qte class QTextCodec --json\n");
}

int outputText(ClassDef[] matches, FuncEntry[] reg, Usage[] usages,
               string projectRoot, CliArgs cli)
{
    // Актуальный маппинг модуль → DLL из registerModule (колонка CSV устарела)
    auto dllMap = moduleDllMap(projectRoot);
    foreach (i, cd; matches)
    {
        if (i > 0) writeln();

        writefln("Class:      %s%s",
                 cd.name,
                 cd.attributes.length ? "  (" ~ cd.attributes.join(" ") ~ ")" : "");
        if (cd.baseClass.length)
            writefln("Inherits:   %s", cd.baseClass);
        writefln("File:       %s (lines %d-%d)", cd.filePath, cd.lineStart, cd.lineEnd);

        // Метаданные модуля и индексы — найти в gen-файле, потом в registry
        auto gm = parseGenModule(cd.filePath);
        if (gm.moduleName.length)
        {
            // DLL: из мапы registerModule; fallback — значение из самого файла
            string dll = gm.dllFile;
            if (auto p = gm.moduleName in dllMap) dll = *p;
            writefln("Module:     %s", gm.moduleName);
            writefln("DLL:        %s", dll);

            auto entries = entriesOfModule(reg, gm.moduleName);
            if (entries.length)
            {
                int minIdx = int.max, maxIdx = int.min;
                foreach (e; entries) {
                    if (e.index < minIdx) minIdx = e.index;
                    if (e.index > maxIdx) maxIdx = e.index;
                }
                writefln("Indexes:    %d functions (range %d-%d)",
                         entries.length, minIdx, maxIdx);
            }
        }

        // Методы
        if (cd.methods.length == 0)
        {
            writeln("Methods:    (none detected)");
        }
        else
        {
            writefln("Methods (%d):", cd.methods.length);
            foreach (m; cd.methods)
            {
                string flags;
                if (m.isStatic) flags ~= "static ";
                if (m.visibility.length) flags ~= m.visibility ~ " ";
                writefln("  L%-5d %s%s %s(%s)",
                         m.line,
                         flags,
                         m.returnType,
                         m.name,
                         m.args.length > 60 ? m.args[0 .. 57] ~ "..." : m.args);
            }
        }
    }

    // Использования
    if (usages.length)
    {
        writeln();
        writefln("Used in (%d locations):", usages.length);
        // Группируем по файлу
        string[] sortedFiles;
        Usage[][string] byFile;
        foreach (u; usages)
        {
            byFile[u.filePath] ~= u;
            if (sortedFiles.length == 0 || sortedFiles[$ - 1] != u.filePath)
                sortedFiles ~= u.filePath;
        }
        sort(sortedFiles);

        foreach (f; sortedFiles)
        {
            auto us = byFile[f];
            writefln("  %s (%d):", f, us.length);
            foreach (u; us[0 .. (us.length > 5 ? 5 : us.length)])
                writefln("    L%-5d  %s", u.line, u.snippet);
            if (us.length > 5)
                writefln("    ... ещё %d", us.length - 5);
        }
    }

    return 0;
}

int outputJson(ClassDef[] matches, FuncEntry[] reg, Usage[] usages,
               string projectRoot, CliArgs cli)
{
    auto dllMap = moduleDllMap(projectRoot);
    auto app = appender!string;
    app.put("{");

    // matches
    app.put(`"classes":[`);
    foreach (i, cd; matches)
    {
        if (i > 0) app.put(",");
        app.put("{");
        app.put(`"name":` ~ escapeJsonString(cd.name) ~ ",");
        app.put(`"baseClass":` ~ escapeJsonString(cd.baseClass) ~ ",");
        app.put(`"filePath":` ~ escapeJsonString(cd.filePath) ~ ",");
        app.put(`"lineStart":` ~ cd.lineStart.to!string ~ ",");
        app.put(`"lineEnd":` ~ cd.lineEnd.to!string ~ ",");
        app.put(`"attributes":[`);
        foreach (j, a; cd.attributes) {
            if (j > 0) app.put(",");
            app.put(escapeJsonString(a));
        }
        app.put("],");

        auto gm = parseGenModule(cd.filePath);
        string dll = gm.dllFile;
        if (auto p = gm.moduleName in dllMap) dll = *p;
        app.put(`"module":` ~ escapeJsonString(gm.moduleName) ~ ",");
        app.put(`"dll":` ~ escapeJsonString(dll) ~ ",");

        auto entries = entriesOfModule(reg, gm.moduleName);
        app.put(`"indexCount":` ~ entries.length.to!string ~ ",");

        app.put(`"methods":[`);
        foreach (j, m; cd.methods) {
            if (j > 0) app.put(",");
            app.put("{");
            app.put(`"name":` ~ escapeJsonString(m.name) ~ ",");
            app.put(`"returnType":` ~ escapeJsonString(m.returnType) ~ ",");
            app.put(`"args":` ~ escapeJsonString(m.args) ~ ",");
            app.put(`"line":` ~ m.line.to!string ~ ",");
            app.put(`"visibility":` ~ escapeJsonString(m.visibility) ~ ",");
            app.put(`"static":` ~ (m.isStatic ? "true" : "false"));
            app.put("}");
        }
        app.put("]");
        app.put("}");
    }
    app.put("],");

    // usages
    app.put(`"usages":[`);
    foreach (i, u; usages) {
        if (i > 0) app.put(",");
        app.put("{");
        app.put(`"file":` ~ escapeJsonString(u.filePath) ~ ",");
        app.put(`"line":` ~ u.line.to!string ~ ",");
        app.put(`"snippet":` ~ escapeJsonString(u.snippet));
        app.put("}");
    }
    app.put("]");

    app.put("}");
    writeln(app.data);
    return 0;
}

// ─────────────────────────────────────────────────────────────────────────────
// Юнит-тесты
// ─────────────────────────────────────────────────────────────────────────────

unittest
{
    // outputText / outputJson — интеграционные, проверим лишь что не падают
    // на пустых данных.
    CliArgs cli;
    auto rc = outputText([], [], [], "", cli);
    assert(rc == 0);

    cli.hasJson = true;
    auto rcJ = outputJson([], [], [], "", cli);
    assert(rcJ == 0);
}
