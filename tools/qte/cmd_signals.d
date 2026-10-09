/**
 * tools/qte/cmd_signals.d — подкоманда `qte signals ...`
 *
 * Справочник по Qt-сигналам, парсит реальные gen_*.d:
 *   1. Находит все методы `void connect_NAME(...)` внутри классов
 *   2. Из тела извлекает Qt-сигнал и invoke-тип (или direct-cb через pFunQt)
 *   3. Группирует по виджету / invoke-типу
 *
 * Подкоманды:
 *   qte signals                      общая статистика по invoke-типам
 *   qte signals <Widget>             все connect_* у этого виджета
 *   qte signals invoke_b             все сигналы с этой сигнатурой
 *   qte signals --used connect_clicked  где используется в test/, snip/
 */
module cmd_signals;

import std.stdio    : writeln, writefln, stderr;
import std.array    : appender, array, join;
import std.algorithm: filter, sort, count, uniq, map;
import std.conv     : to;
import std.path     : buildPath;
import std.string   : indexOf, startsWith;
import std.file     : exists;

import qte_meta;
import qte_cli;

int run(string[] args, string projectRoot, CliArgs cli)
{
    if (cli.hasHelp)
    {
        printHelp();
        return 0;
    }

    string genDir = buildPath(projectRoot, "d", "gen");
    auto sigs = findSignals(genDir);

    // --used connect_NAME — поиск использований в test/, snip/
    if (auto p = "used" in cli.opts)
        return cmdUsed(sigs, *p, projectRoot, cli);

    if (args.length == 0)
        return cmdStat(sigs, cli);

    string arg = args[0];

    // По имени invoke-типа (invoke_b / invoke_i / ...)
    if (arg.startsWith("invoke_"))
        return cmdByInvoke(sigs, arg, cli);

    // По имени Qt-сигнала (clicked / valueChanged / textChanged / ...)
    // эвристика: маленькая буква в начале и нет префикса 'Q'
    if (arg.length > 0 && arg[0] >= 'a' && arg[0] <= 'z')
        return cmdByQtSignal(sigs, arg, cli);

    // Иначе — имя класса (QPushButton, QSlider, ...)
    return cmdByClass(sigs, arg, genDir, cli);
}

void printHelp()
{
    writeln(
        "qte signals -- справочник Qt-сигналов из gen_*.d\n" ~
        "\n" ~
        "ИСПОЛЬЗОВАНИЕ:\n" ~
        "  qte signals                       статистика по invoke-типам\n" ~
        "  qte signals <Widget>              все connect_* у виджета\n" ~
        "  qte signals invoke_b              все сигналы данной сигнатуры\n" ~
        "  qte signals <name>                все сигналы с таким Qt-именем\n" ~
        "  qte signals --used connect_clicked  где используется в test/snip\n" ~
        "\n" ~
        "ОПЦИИ:\n" ~
        "  --json     Машинный вывод\n" ~
        "  -q         Минимальный вывод\n" ~
        "\n" ~
        "ПРИМЕРЫ:\n" ~
        "  qte signals QPushButton            6 connect_* у кнопки\n" ~
        "  qte signals invoke_i               все сигналы с (int)\n" ~
        "  qte signals valueChanged           все виджеты со value-changed\n");
}

// ─────────────────────────────────────────────────────────────────────────────
// stat — общая статистика по invoke-типам
// ─────────────────────────────────────────────────────────────────────────────

int cmdStat(SignalInfo[] sigs, CliArgs cli)
{
    int[string] byInvoke;
    int[string] byClass;
    int directCount;
    foreach (s; sigs)
    {
        byInvoke[s.invokeType.length ? s.invokeType : "(direct)"]++;
        byClass[s.className]++;
        if (s.callbackKind == "direct") directCount++;
    }

    if (cli.hasJson)
    {
        auto app = appender!string;
        app.put(`{"total":` ~ sigs.length.to!string ~ `,"direct":` ~
                directCount.to!string ~ `,"byInvoke":[`);
        bool first = true;
        foreach (k, v; byInvoke) {
            if (!first) app.put(",");
            first = false;
            app.put(`{"invoke":` ~ escapeJsonString(k) ~ `,"count":` ~
                    v.to!string ~ "}");
        }
        app.put(`],"byClass":[`);
        first = true;
        foreach (k, v; byClass) {
            if (!first) app.put(",");
            first = false;
            app.put(`{"class":` ~ escapeJsonString(k) ~ `,"count":` ~
                    v.to!string ~ "}");
        }
        app.put("]}");
        writeln(app.data);
        return 0;
    }

    if (!cli.hasQuiet) writeln("== qte signals: общая статистика ==");
    writefln("Всего connect_* методов: %d", sigs.length);
    writefln("Из них direct-callback:   %d", directCount);
    writefln("Классов с сигналами:      %d", byClass.length);
    writeln();
    writeln("По invoke-типам:");
    auto invokeKeys = byInvoke.keys.array;
    sort(invokeKeys);
    foreach (k; invokeKeys)
        writefln("  %4d  %s", byInvoke[k], k);

    if (!cli.hasQuiet)
    {
        writeln();
        writeln("Топ-15 классов по числу сигналов:");
        auto classKeys = byClass.keys.array;
        sort!((a, b) => byClass[a] > byClass[b])(classKeys);
        size_t lim = classKeys.length < 15 ? classKeys.length : 15;
        foreach (k; classKeys[0 .. lim])
            writefln("  %4d  %s", byClass[k], k);
    }
    return 0;
}

// ─────────────────────────────────────────────────────────────────────────────
// by class
// ─────────────────────────────────────────────────────────────────────────────

int cmdByClass(SignalInfo[] sigs, string className, string genDir, CliArgs cli)
{
    auto found = sigs.filter!(s => s.className == className).array;

    // Если своих сигналов нет — попробуем найти через цепочку наследования
    string[] inheritChain;
    if (found.length == 0 && genDir.length)
    {
        string current = className;
        for (int hop = 0; hop < 5 && found.length == 0; hop++)
        {
            auto cls = findClass(genDir, current);
            if (cls.length == 0 || cls[0].baseClass.length == 0) break;
            inheritChain ~= cls[0].baseClass;
            current = cls[0].baseClass;
            found = sigs.filter!(s => s.className == current).array;
        }
    }

    if (found.length == 0)
    {
        if (cli.hasJson)
            writefln(`{"class":%s,"signals":[]}`, escapeJsonString(className));
        else
            stderr.writeln("Сигналы класса '", className, "' не найдены ",
                           "(в т.ч. через цепочку наследования)");
        return 1;
    }
    sort!((a, b) => a.connectName < b.connectName)(found);

    if (cli.hasJson)
        return outputSigsJson(className, found, "class");

    if (!cli.hasQuiet)
    {
        if (inheritChain.length)
        {
            string from = inheritChain.length ? inheritChain[$ - 1] : className;
            writefln("== %s -> %s: %d сигналов (через наследование %s) ==",
                     className, from, found.length,
                     inheritChain.join(" -> "));
        }
        else
            writefln("== %s: %d сигналов ==", className, found.length);
    }
    writefln("%-32s %-30s %-12s %s",
             "connect_*", "Qt signal", "invoke", "kind");
    writefln("%-32s %-30s %-12s %s",
             repeat('-', 32), repeat('-', 30), repeat('-', 12), repeat('-', 8));
    foreach (s; found)
    {
        string sigStr = s.qtSignalName ~
                        (s.qtSignalArgs.length ? "(" ~ s.qtSignalArgs ~ ")" : "()");
        writefln("%-32s %-30s %-12s %s",
                 s.connectName,
                 sigStr,
                 s.invokeType.length ? s.invokeType : "-",
                 s.callbackKind);
    }
    return 0;
}

// ─────────────────────────────────────────────────────────────────────────────
// by invoke type
// ─────────────────────────────────────────────────────────────────────────────

int cmdByInvoke(SignalInfo[] sigs, string invokeType, CliArgs cli)
{
    auto found = sigs.filter!(s => s.invokeType == invokeType).array;
    if (found.length == 0)
    {
        if (cli.hasJson)
            writefln(`{"invoke":%s,"signals":[]}`, escapeJsonString(invokeType));
        else
            stderr.writeln("Сигналов с invoke-типом '", invokeType, "' не найдено");
        return 1;
    }
    sort!((a, b) {
        if (a.className != b.className) return a.className < b.className;
        return a.connectName < b.connectName;
    })(found);

    if (cli.hasJson)
        return outputSigsJson(invokeType, found, "invoke");

    if (!cli.hasQuiet)
        writefln("== %s: %d сигналов ==", invokeType, found.length);
    writefln("%-25s %-30s %s",
             "Class", "connect_*", "Qt signal");
    writefln("%-25s %-30s %s",
             repeat('-', 25), repeat('-', 30), repeat('-', 30));
    foreach (s; found)
    {
        string sigStr = s.qtSignalName ~
                        (s.qtSignalArgs.length ? "(" ~ s.qtSignalArgs ~ ")" : "()");
        writefln("%-25s %-30s %s",
                 s.className, s.connectName, sigStr);
    }
    return 0;
}

// ─────────────────────────────────────────────────────────────────────────────
// by Qt signal name
// ─────────────────────────────────────────────────────────────────────────────

int cmdByQtSignal(SignalInfo[] sigs, string qtSignalName, CliArgs cli)
{
    auto found = sigs.filter!(s => s.qtSignalName == qtSignalName).array;
    if (found.length == 0)
    {
        // подсказка: возможно, имеется в виду подстрока?
        auto sub = sigs.filter!(s => s.qtSignalName.indexOf(qtSignalName) >= 0).array;
        if (sub.length > 0 && !cli.hasJson)
        {
            stderr.writeln("Точного совпадения по сигналу '",
                           qtSignalName, "' нет.\n",
                           "Похожие (всего ", sub.length, "):");
            foreach (s; sub[0 .. (sub.length > 5 ? 5 : sub.length)])
                stderr.writefln("  %s.%s", s.className, s.connectName);
            return 1;
        }
        if (cli.hasJson)
            writefln(`{"qtSignal":%s,"signals":[]}`,
                     escapeJsonString(qtSignalName));
        else
            stderr.writeln("Сигнал '", qtSignalName, "' не найден");
        return 1;
    }
    sort!((a, b) => a.className < b.className)(found);

    if (cli.hasJson)
        return outputSigsJson(qtSignalName, found, "qtSignal");

    if (!cli.hasQuiet)
        writefln("== Qt signal '%s': %d виджетов ==", qtSignalName, found.length);
    writefln("%-25s %-30s %-12s %s",
             "Class", "connect_*", "invoke", "args");
    writefln("%-25s %-30s %-12s %s",
             repeat('-', 25), repeat('-', 30), repeat('-', 12), repeat('-', 20));
    foreach (s; found)
        writefln("%-25s %-30s %-12s (%s)",
                 s.className, s.connectName,
                 s.invokeType.length ? s.invokeType : "-",
                 s.qtSignalArgs);
    return 0;
}

// ─────────────────────────────────────────────────────────────────────────────
// --used connect_NAME
// ─────────────────────────────────────────────────────────────────────────────

int cmdUsed(SignalInfo[] sigs, string connectName, string projectRoot, CliArgs cli)
{
    string[] dirs = [
        buildPath(projectRoot, "test"),
        buildPath(projectRoot, "tools", "qte_guide", "snip"),
    ].filter!(p => exists(p)).array;

    auto uses = findUsages(dirs, connectName);

    if (cli.hasJson)
    {
        auto app = appender!string;
        app.put(`{"connect":` ~ escapeJsonString(connectName) ~
                `,"usages":[`);
        foreach (i, u; uses) {
            if (i > 0) app.put(",");
            app.put("{");
            app.put(`"file":` ~ escapeJsonString(u.filePath) ~ ",");
            app.put(`"line":` ~ u.line.to!string ~ ",");
            app.put(`"snippet":` ~ escapeJsonString(u.snippet));
            app.put("}");
        }
        app.put("]}");
        writeln(app.data);
        return uses.length ? 0 : 1;
    }

    if (uses.length == 0)
    {
        if (!cli.hasQuiet)
            writeln("Использований '", connectName, "' не найдено");
        return 1;
    }

    if (!cli.hasQuiet)
        writefln("== %s: %d использований ==", connectName, uses.length);
    foreach (u; uses)
        writefln("  %s:%d  %s", u.filePath, u.line, u.snippet);
    return 0;
}

// ─────────────────────────────────────────────────────────────────────────────
// JSON helper
// ─────────────────────────────────────────────────────────────────────────────

int outputSigsJson(string keyValue, SignalInfo[] sigs, string keyKind)
{
    auto app = appender!string;
    app.put("{");
    app.put(`"` ~ keyKind ~ `":` ~ escapeJsonString(keyValue) ~ ",");
    app.put(`"signals":[`);
    foreach (i, s; sigs) {
        if (i > 0) app.put(",");
        app.put("{");
        app.put(`"class":` ~ escapeJsonString(s.className) ~ ",");
        app.put(`"connectName":` ~ escapeJsonString(s.connectName) ~ ",");
        app.put(`"qtSignalName":` ~ escapeJsonString(s.qtSignalName) ~ ",");
        app.put(`"qtSignalArgs":` ~ escapeJsonString(s.qtSignalArgs) ~ ",");
        app.put(`"invokeType":` ~ escapeJsonString(s.invokeType) ~ ",");
        app.put(`"callbackKind":` ~ escapeJsonString(s.callbackKind) ~ ",");
        app.put(`"file":` ~ escapeJsonString(s.filePath) ~ ",");
        app.put(`"line":` ~ s.line.to!string);
        app.put("}");
    }
    app.put("]}");
    writeln(app.data);
    return 0;
}

// ─────────────────────────────────────────────────────────────────────────────
// Юнит-тесты (логика, без файлов проекта)
// ─────────────────────────────────────────────────────────────────────────────

unittest
{
    SignalInfo[] sigs = [
        SignalInfo("QPushButton", "f.d", 10, "connect_clicked",
                   "clicked", "bool", "invoke_b", "eslot"),
        SignalInfo("QPushButton", "f.d", 14, "connect_toggled",
                   "toggled", "bool", "invoke_b", "eslot"),
        SignalInfo("QSlider", "g.d", 20, "connect_valueChanged",
                   "valueChanged", "int", "invoke_i", "eslot"),
        SignalInfo("QButtonGroup", "h.d", 30, "connect_buttonClicked",
                   "buttonClicked", "QAbstractButton*", "", "direct"),
    ];

    CliArgs cli;
    cli.hasJson = true;

    // cmdStat не должна падать
    auto rc1 = cmdStat(sigs, cli);
    assert(rc1 == 0);

    // cmdByClass: QPushButton — 2 сигнала
    auto rc2 = cmdByClass(sigs, "QPushButton", "", cli);
    assert(rc2 == 0);

    auto rc3 = cmdByClass(sigs, "QNothing", "", cli);
    assert(rc3 == 1, "несуществующий класс → exit 1");

    // cmdByInvoke
    auto rc4 = cmdByInvoke(sigs, "invoke_b", cli);
    assert(rc4 == 0);

    auto rc5 = cmdByInvoke(sigs, "invoke_xx", cli);
    assert(rc5 == 1);

    // cmdByQtSignal
    auto rc6 = cmdByQtSignal(sigs, "clicked", cli);
    assert(rc6 == 0);
}
