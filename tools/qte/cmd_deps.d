/**
 * tools/qte/cmd_deps.d — подкоманда `qte deps <ClassName|path.d>`
 *
 * Транзитивное замыкание импортов gen_* (каждый gen_*.d импортирует другие
 * gen_*; граф строится по `^import\s+(gen_\w+)`).
 *
 * Режимы:
 *   qte deps QComboBox                класс → его gen-модуль → замыкание
 *   qte deps test/test_qtablewidget.d импорты gen_* из .d-файла → замыкание
 *
 * Вывод: список модулей в порядке сборки (зависимости раньше) + готовая
 * строка компиляции dmd.
 *
 * Опции:
 *   --json   машинный вывод
 */
module cmd_deps;

import std.stdio    : writeln, writefln, stderr;
import std.array    : appender, array, join;
import std.algorithm: sort;
import std.conv     : to;
import std.path     : buildPath, baseName, stripExtension;
import std.file     : exists;
import std.string   : endsWith;

import qte_meta;
import qte_cli;

int run(string[] args, string projectRoot, CliArgs cli)
{
    if (cli.hasHelp || args.length == 0)
    {
        printHelp();
        return args.length == 0 && !cli.hasHelp ? 2 : 0;
    }

    string target = args[0];
    string genDir = buildPath(projectRoot, "d", "gen");

    string[] roots;      // стартовые gen-модули (имена вида gen_qfoo)
    string   srcFile;    // исходный .d-файл (для строки dmd)

    if (target.endsWith(".d"))
    {
        // Режим файла: парсим его импорты gen_*
        if (!exists(target))
        {
            stderr.writeln("qte deps: файл '", target, "' не найден");
            return 1;
        }
        srcFile = target;
        roots = findGenImports(target);
        if (roots.length == 0)
        {
            stderr.writeln("qte deps: в '", target, "' нет импортов gen_*");
            return 1;
        }
    }
    else
    {
        // Режим класса: ищем класс в d/gen
        auto matches = findClass(genDir, target);
        if (matches.length == 0)
        {
            stderr.writeln("qte deps: класс '", target,
                           "' не найден в d/gen/ (и это не .d-файл)");
            return 1;
        }
        srcFile = matches[0].filePath;
        // Корень — сам gen-файл класса
        roots = [baseName(matches[0].filePath).stripExtension];
    }

    // Транзитивное замыкание (DFS, зависимости раньше зависимых)
    string[] order;
    bool[string] visited;
    void visit(string mod)
    {
        if (mod in visited) return;
        visited[mod] = true;
        string path = buildPath(genDir, mod ~ ".d");
        foreach (dep; findGenImports(path))
            visit(dep);
        order ~= mod;
    }
    foreach (r; roots) visit(r);

    // Готовая строка компиляции
    string ofName = baseName(srcFile).stripExtension ~ ".exe";
    string dmdLine = "dmd -m32 -i " ~ srcFile ~
        " -Id -Id/gen -L/DEFAULTLIB:user32 -of=" ~ ofName;

    if (cli.hasJson)
    {
        auto app = appender!string;
        app.put("{");
        app.put(`"target":` ~ escapeJsonString(target) ~ ",");
        app.put(`"modules":[`);
        foreach (i, m; order)
        {
            if (i > 0) app.put(",");
            app.put(escapeJsonString(m));
        }
        app.put("],");
        app.put(`"dmd":` ~ escapeJsonString(dmdLine));
        app.put("}");
        writeln(app.data);
        return 0;
    }

    if (!cli.hasQuiet)
        writefln("Замыкание gen_* для '%s': %d модулей (в порядке сборки)",
                 target, order.length);
    foreach (m; order)
        writeln("  ", m);
    writeln();
    writeln("Компиляция:");
    writeln("  ", dmdLine);
    return 0;
}

void printHelp()
{
    writeln(
        "qte deps <ClassName|path.d> — транзитивное замыкание импортов gen_*\n" ~
        "\n" ~
        "РЕЖИМЫ:\n" ~
        "  qte deps QComboBox                 класс → его gen-модуль → замыкание\n" ~
        "  qte deps test/test_qtablewidget.d  импорты gen_* из .d-файла\n" ~
        "\n" ~
        "ОПЦИИ:\n" ~
        "  --json    Машинный вывод\n" ~
        "  -q        Без шапок\n");
}

// ─────────────────────────────────────────────────────────────────────────────
// Юнит-тесты
// ─────────────────────────────────────────────────────────────────────────────

unittest
{
    // argparse-ветви
    CliArgs cli;
    auto rc = run([], ".", cli);
    assert(rc == 2, "Без аргументов → exit 2");
}
