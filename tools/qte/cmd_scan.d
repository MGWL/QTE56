/**
 * tools/qte/cmd_scan.d — подкоманда `qte scan`
 *
 * Выгружает мета-информацию обо всех классах d/gen/gen_*.d одним JSON-документом
 * в stdout (для потребителей вроде tools/qte_guide — чтобы они не дублировали
 * регэксп-парсеры gen_*.d).
 *
 * Вывод ВСЕГДА JSON (флаг --json ни на что не влияет).
 *
 * Формат:
 *   {"classes":[{"name":"QComboBox","module":"gen_qcombobox",
 *                "dll":"qte56_widgets.dll","parent":"QWidget"|null,"live":true,
 *                "indices":[1400,...],"deps":["gen_qwidget",...],
 *                "signals":["connect_activated_i",...],
 *                "signalsDetail":[{"name":...,"params":["int value"],"qtSig":"activated(int)"}],
 *                "events":["onMousePress",...],
 *                "eventsDetail":[{"name":...,"params":["int x","int y","int button"]}],
 *                "methods":["addItem",...]}, ...]}
 *
 * signalsDetail/eventsDetail — расширение для qte_guide (параметры коллбэков);
 * signals/events — плоские списки имён (базовый контракт).
 */
module cmd_scan;

import std.stdio    : writeln, stderr;
import std.array    : appender, array;
import std.algorithm: sort, canFind;
import std.conv     : to;
import std.path     : buildPath, baseName, stripExtension;
import std.file     : exists, dirEntries, SpanMode, readText;
import std.regex    : ctRegex, matchFirst;
import std.string   : strip, split, splitLines, startsWith;

import qte_meta;
import qte_cli;

int run(string[] args, string projectRoot, CliArgs cli)
{
    if (cli.hasHelp)
    {
        writeln(
            "qte scan — JSON-выгрузка всех классов d/gen/gen_*.d\n" ~
            "\n" ~
            "Всегда печатает JSON в stdout (для tools/qte_guide и агентов).\n" ~
            "Поля класса: name, module, dll, parent, live, indices, deps,\n" ~
            "signals(+Detail), events(+Detail), methods.\n");
        return 0;
    }
    writeln(buildScanJson(projectRoot));
    return 0;
}

/// invoke_X → параметры коллбэка (та же таблица, что в qte_guide/scanner.d).
private string[] invokeToParams(string invoke)
{
    if (invoke.startsWith("invoke_v")) return [];
    if (invoke.startsWith("invoke_b")) return ["bool checked"];
    if (invoke.startsWith("invoke_d")) return ["double value"];
    if (invoke.startsWith("invoke_s")) return ["string text"];
    if (invoke.startsWith("invoke_ii")) return ["int row", "int col"];
    if (invoke.startsWith("invoke_i"))  return ["int value"];
    if (invoke.startsWith("invoke_p"))  return ["int x", "int y"];
    return [];
}

/// Одно событие on* с параметрами коллбэка.
private struct EvInfo { string name; string[] params; int line; }

/// Скан одного gen-файла: события on* (с /// cb: комментарием для параметров).
private EvInfo[] scanEvents(string[] lines)
{
    auto reCb  = ctRegex!(`^\s*///\s*cb:\s*extern\(C\)\s*void\s*function\(([^)]*)\)`);
    auto reOn  = ctRegex!(`^\s*(?:override\s+)?\w[\w\*]*\s+(on[A-Z]\w+)\s*\(void\*\s*cb`);
    EvInfo[] result;
    string pendingCb;
    foreach (i, line; lines)
    {
        auto mc = line.matchFirst(reCb);
        if (mc) { pendingCb = mc[1]; continue; }
        auto mo = line.matchFirst(reOn);
        if (mo)
        {
            EvInfo ev;
            ev.name = mo[1];
            ev.line = cast(int)i + 1;
            if (pendingCb.length)
                foreach (p; pendingCb.split(","))
                {
                    auto ps = p.strip;
                    if (ps.length && ps != "void* dthis") ev.params ~= ps;
                }
            result ~= ev;
            pendingCb = "";
        }
    }
    return result;
}

/// Построить JSON скана по корню проекта (вся работа — здесь, для unittest'ов).
string buildScanJson(string projectRoot)
{
    string genDir  = buildPath(projectRoot, "d", "gen");
    string csvPath = buildPath(projectRoot, "registry", "functions.csv");

    // Индексы из реестра: модуль (имя класса) → список индексов
    int[][string] idxByClass;
    if (exists(csvPath))
    {
        foreach (e; loadRegistry(csvPath))
            idxByClass[e.module_] ~= e.index;
        foreach (k, ref v; idxByClass) sort(v);
    }

    // Сигналы connect_* по классам (единый проход findSignals)
    SignalInfo[][string] sigByClass;
    foreach (si; findSignals(genDir))
        sigByClass[si.className] ~= si;

    auto app = appender!string;
    app.put(`{"classes":[`);
    bool firstClass = true;

    foreach (entry; dirEntries(genDir, "gen_*.d", SpanMode.depth))
    {
        string stem = baseName(entry.name).stripExtension;
        auto gm      = parseGenModule(entry.name);
        auto classes = parseClasses(entry.name);
        if (classes.length == 0) continue;
        auto deps    = findGenImports(entry.name);
        auto events  = scanEvents(readText(entry.name).splitLines);

        foreach (cd; classes)
        {
            if (!firstClass) app.put(",");
            firstClass = false;
            app.put("{");
            app.put(`"name":`   ~ escapeJsonString(cd.name) ~ ",");
            app.put(`"module":` ~ escapeJsonString(stem) ~ ",");
            app.put(`"dll":`    ~ escapeJsonString(gm.dllFile) ~ ",");
            app.put(`"parent":` ~
                (cd.baseClass.length ? escapeJsonString(cd.baseClass) : "null") ~ ",");
            app.put(`"live":` ~ (cd.attributes.canFind("@live") ? "true" : "false") ~ ",");

            // indices
            app.put(`"indices":[`);
            if (auto ip = cd.name in idxByClass)
                foreach (i, idx; *ip)
                {
                    if (i > 0) app.put(",");
                    app.put(idx.to!string);
                }
            app.put("],");

            // deps
            app.put(`"deps":[`);
            foreach (i, d; deps)
            {
                if (i > 0) app.put(",");
                app.put(escapeJsonString(d));
            }
            app.put("],");

            // signals (имена) + signalsDetail (params/qtSig)
            auto sigs = sigByClass.get(cd.name, null);
            app.put(`"signals":[`);
            foreach (i, s; sigs)
            {
                if (i > 0) app.put(",");
                app.put(escapeJsonString(s.connectName));
            }
            app.put(`],"signalsDetail":[`);
            foreach (i, s; sigs)
            {
                if (i > 0) app.put(",");
                app.put("{");
                app.put(`"name":` ~ escapeJsonString(s.connectName) ~ ",");
                app.put(`"params":[`);
                auto params = invokeToParams(s.invokeType);
                foreach (j, p; params)
                {
                    if (j > 0) app.put(",");
                    app.put(escapeJsonString(p));
                }
                app.put(`],"qtSig":` ~ escapeJsonString(
                    s.qtSignalArgs.length
                        ? s.qtSignalName ~ "(" ~ s.qtSignalArgs ~ ")"
                        : s.qtSignalName));
                app.put("}");
            }
            app.put("],");

            // events этого класса (по диапазону строк класса) + eventsDetail
            EvInfo[] myEvents;
            foreach (ev; events)
                if (ev.line >= cd.lineStart && ev.line <= cd.lineEnd)
                    myEvents ~= ev;
            app.put(`"events":[`);
            foreach (i, ev; myEvents)
            {
                if (i > 0) app.put(",");
                app.put(escapeJsonString(ev.name));
            }
            app.put(`],"eventsDetail":[`);
            foreach (i, ev; myEvents)
            {
                if (i > 0) app.put(",");
                app.put("{");
                app.put(`"name":` ~ escapeJsonString(ev.name) ~ `,"params":[`);
                foreach (j, p; ev.params)
                {
                    if (j > 0) app.put(",");
                    app.put(escapeJsonString(p));
                }
                app.put("]}");
            }
            app.put("],");

            // methods (публичные, без connect_/on*/служебных)
            static immutable skip = ["wrap", "getWH", "disown",
                                     "setEventHandler", "toString", "this"];
            app.put(`"methods":[`);
            bool firstM = true;
            foreach (m; cd.methods)
            {
                if (m.visibility == "private") continue;
                if (m.name.startsWith("connect_") || m.name.startsWith("on")) continue;
                if (skip.canFind(m.name)) continue;
                if (!firstM) app.put(",");
                firstM = false;
                app.put(escapeJsonString(m.name));
            }
            app.put("]");
            app.put("}");
        }
    }
    app.put("]}");
    return app.data;
}

// ─────────────────────────────────────────────────────────────────────────────
// Юнит-тесты
// ─────────────────────────────────────────────────────────────────────────────

unittest
{
    // Синтетическое дерево проекта: registry + d/gen с одним классом
    import std.file : tempDir, write, mkdirRecurse, rmdirRecurse;
    import std.path : buildPath;
    import std.exception : collectException;
    import std.json : parseJSON;

    string root = buildPath(tempDir, "qte_scan_test_root");
    scope(exit) collectException(rmdirRecurse(root));
    mkdirRecurse(buildPath(root, "registry"));
    mkdirRecurse(buildPath(root, "d", "gen"));

    write(buildPath(root, "registry", "functions.csv"),
          "# header\n" ~
          "100,qteQFoo_create,QFoo,qte56_foo.dll,ctor\n" ~
          "101,qteQFoo_setText,QFoo,qte56_foo.dll,method\n");

    write(buildPath(root, "d", "gen", "gen_qfoo.d"),
          "module gen_qfoo;\n" ~
          "import gen_qcore;\n" ~
          "import gen_qwidget : QWidget;\n" ~
          "static this() { registerModule(\"QFoo\", \"qte56_foo.dll\", &loadQFoo); }\n" ~
          "void loadQFoo() {\n" ~
          "    mixin(generateFunQt(100, \"qteQFoo_create\", \"QFoo\"));\n" ~
          "}\n" ~
          "@live class QFoo : QWidget {\n" ~
          "    void* _wh;\n" ~
          "    void setText(string s) {}\n" ~
          "    private void helper() {}\n" ~
          "    void connect_clicked(ESlot eslot) {\n" ~
          "        connectQt(_wh, \"clicked(bool)\", eslot, \"invoke_b(bool)\");\n" ~
          "    }\n" ~
          "    /// cb: extern(C) void function(void* dthis, int x, int y)\n" ~
          "    void onMousePress(void* cb) {}\n" ~
          "}\n");

    auto j = parseJSON(buildScanJson(root));
    auto cls = j["classes"].array;
    assert(cls.length == 1);
    auto c = cls[0];
    assert(c["name"].str == "QFoo");
    assert(c["module"].str == "gen_qfoo");
    assert(c["dll"].str == "qte56_foo.dll");
    assert(c["parent"].str == "QWidget");
    assert(c["live"].boolean == true);
    assert(c["indices"].array.length == 2);
    assert(c["indices"].array[0].integer == 100);
    assert(c["deps"].array.length == 2);
    assert(c["signals"].array[0].str == "connect_clicked");
    assert(c["signalsDetail"].array[0]["params"].array[0].str == "bool checked");
    assert(c["signalsDetail"].array[0]["qtSig"].str == "clicked(bool)");
    assert(c["events"].array[0].str == "onMousePress");
    assert(c["eventsDetail"].array[0]["params"].array.length == 2);
    // methods: setText есть, private helper и connect_/on* — нет
    assert(c["methods"].array.length == 1);
    assert(c["methods"].array[0].str == "setText");
}
