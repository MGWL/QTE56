/**
 * tools/qte/main.d — единая утилита qte с подкомандами для анализа QTE56.
 *
 * Подкоманды:
 *   qte index ...         анализ pFunQt-таблицы
 *   qte class <Name>      справочник по Qt-классу
 *   qte check ...         кросс-консистентность
 *   qte signals ...       справочник Qt-сигналов
 *   qte trace <index>     обратная трассировка pFunQt-слота
 *   qte dll [module]      таблица модуль → DLL → merged/standalone
 *   qte deps <Class|file> транзитивное замыкание импортов gen_*
 *
 * Глобальные опции:
 *   -h, --help            справка по подкоманде или по утилите
 *   --json                машинный вывод (для агентов)
 *   -q, --quiet           минимальный вывод (только результат)
 *   --root <PATH>         путь к корню проекта (по умолчанию — auto-detect)
 *   --version             версия утилиты
 *
 * Сборка:
 *   dmd -of=qte.exe tools\qte\*.d tools\lib\*.d -Itools\lib
 */
module qte;

import std.stdio  : writeln, writefln, stderr;
import std.file   : exists;
import std.path   : buildPath;

import qte_cli;
import cmd_index;
import cmd_class;
import cmd_check;
import cmd_signals;
import cmd_trace;
import cmd_dll;
import cmd_deps;
import cmd_scan;

alias VERSION = QTE_VERSION;   // версия — в qte_cli.d (единый источник)

void printRootHelp()
{
    writeln(
        "qte v" ~ VERSION ~ " — CLI-утилита для анализа QTE56\n" ~
        "\n" ~
        "ИСПОЛЬЗОВАНИЕ:\n" ~
        "  qte <subcommand> [options]\n" ~
        "\n" ~
        "ПОДКОМАНДЫ:\n" ~
        "  index    Анализ pFunQt-таблицы (registry, коллизии, дыры, поиск)\n" ~
        "  class    Справочник по Qt-классу: где, какие методы, кто использует\n" ~
        "  check    Кросс-проверки: indexes/live/builds/globals/all\n" ~
        "  signals  Справочник Qt-сигналов из реальных gen_*.d\n" ~
        "  trace    Обратная трассировка одного pFunQt-индекса\n" ~
        "  dll      Таблица модуль → DLL → merged/standalone\n" ~
        "  deps     Транзитивное замыкание импортов gen_* + строка dmd\n" ~
        "  scan     JSON-выгрузка всех классов gen_*.d (для qte_guide)\n" ~
        "\n" ~
        "ГЛОБАЛЬНЫЕ ОПЦИИ:\n" ~
        "  -h, --help        справка\n" ~
        "  --json            машинный вывод\n" ~
        "  -q, --quiet       минимальный вывод\n" ~
        "  --root <PATH>     корень проекта (по умолч. auto-detect)\n" ~
        "  --version         версия утилиты\n" ~
        "\n" ~
        "ПРИМЕРЫ:\n" ~
        "  qte index list                сводка по модулям\n" ~
        "  qte index find QSql           найти все QSql-функции\n" ~
        "  qte index next 20163          следующий свободный с 20163\n" ~
        "  qte index module QTextCodec   все методы QTextCodec\n" ~
        "  qte index check               коллизии и mismatches\n" ~
        "  qte --json index list         JSON-вывод для агентов\n");
}

int main(string[] argv)
{
    if (argv.length < 2)
    {
        printRootHelp();
        return 0;
    }

    // Сначала вытащим --version
    foreach (a; argv[1 .. $])
    {
        if (a == "--version") {
            writeln(VERSION);
            return 0;
        }
    }

    // Вытаскиваем глобальные флаги ДО подкоманды:
    //   --root <PATH>  --json  -q/--quiet
    // Эти флаги могут стоять в любом месте — переносим их в subArgs тоже.
    string rootOverride;
    bool   globalJson;
    bool   globalQuiet;
    string[] filtered;
    for (size_t i = 1; i < argv.length; i++)
    {
        if (argv[i] == "--root" && i + 1 < argv.length) {
            rootOverride = argv[i + 1];
            i++;
            continue;
        }
        if (argv[i] == "--json")               { globalJson  = true; continue; }
        if (argv[i] == "-q" || argv[i] == "--quiet") { globalQuiet = true; continue; }
        filtered ~= argv[i];
    }

    if (filtered.length == 0)
    {
        printRootHelp();
        return 0;
    }

    // Корень проекта
    string root = rootOverride.length ? rootOverride : findProjectRoot();
    if (root.length == 0)
    {
        stderr.writeln(
            "Не найден корень проекта QTE56 (нет registry/functions.csv).\n" ~
            "Запустите из папки проекта или укажите --root <PATH>.");
        return 2;
    }
    if (!exists(buildPath(root, "registry", "functions.csv")))
    {
        stderr.writeln("В корне '", root, "' нет registry/functions.csv");
        return 2;
    }

    // Первый аргумент — подкоманда
    string subcmd = filtered[0];
    string[] subArgs = filtered[1 .. $];

    // Глобальные флаги распарсим из subArgs (--json/-q/-h)
    auto cli = parseArgs(subArgs);
    // Если --json/--quiet были до подкоманды — поднимем флаг и здесь
    if (globalJson)  cli.hasJson = true;
    if (globalQuiet) cli.hasQuiet = true;

    switch (subcmd)
    {
        case "-h":
        case "--help":
            printRootHelp();
            return 0;

        case "index":
            return cmd_index.run(cli.positional, root, cli);

        case "class":
            return cmd_class.run(cli.positional, root, cli);

        case "check":
            return cmd_check.run(cli.positional, root, cli);

        case "signals":
            return cmd_signals.run(cli.positional, root, cli);

        case "trace":
            return cmd_trace.run(cli.positional, root, cli);

        case "dll":
            return cmd_dll.run(cli.positional, root, cli);

        case "deps":
            return cmd_deps.run(cli.positional, root, cli);

        case "scan":
            return cmd_scan.run(cli.positional, root, cli);

        default:
            stderr.writeln("Неизвестная подкоманда: '", subcmd, "'");
            printRootHelp();
            return 2;
    }
}
