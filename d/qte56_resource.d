/**
 * qte56_resource.d — Qt Resource System helpers for D.
 *
 * Позволяет работать с внешними бинарными архивами ресурсов (.rcc),
 * читать файлы по путям ":/..." и применять QSS из ресурсов.
 *
 * Типичный workflow:
 *   // 1. Скомпилируй ресурсы: rcc --binary -o myapp.rcc myapp.qrc
 *   // 2. Загрузи в рантайме:
 *   registerRcc("myapp.rcc");
 *
 *   // 3. Используй как обычно:
 *   applyQssRes(app, ":/styles/dark.qss");
 *   auto pxm = new QPixmap(":/images/icon.png");
 *
 *   // 4. Выгрузи при необходимости:
 *   unregisterRcc("myapp.rcc");
 *
 * Совместимость с qte56_style.d:
 *   После registerRcc() функции applyQss(app, ":/...") из qte56_style.d
 *   также работают с ресурсными путями.
 */
module qte56_resource;

import gen_qcore   : QApplication;
import gen_qwidget : QWidget;
import gen_qfile   : QFile;
import gen_qresource;

// ── Регистрация .rcc архивов ──────────────────────────────────────────────────

/**
 * Загрузить внешний бинарный архив ресурсов (.rcc).
 *
 * Params:
 *   path    = путь к .rcc файлу (абсолютный или относительный к рабочей директории)
 *   mapRoot = виртуальный корень в дереве ресурсов (обычно "/")
 *
 * Returns: true если архив загружен успешно.
 *
 * Example:
 *   registerRcc("app.rcc");
 *   // теперь ":/images/icon.png" доступен через QFile, QPixmap, ...
 */
bool registerRcc(string path, string mapRoot = "/") {
    return _resourceRegister(path, mapRoot) != 0;
}

/**
 * Выгрузить ранее загруженный архив ресурсов.
 *
 * Returns: true если архив был найден и выгружен.
 */
bool unregisterRcc(string path, string mapRoot = "/") {
    return _resourceUnregister(path, mapRoot) != 0;
}

// ── Чтение ресурсов ───────────────────────────────────────────────────────────

/**
 * Проверить существование ресурса по пути ":/...".
 * Работает для любых файлов в зарегистрированных архивах.
 */
bool resourceExists(string path) {
    return QFile.fileExists(path);
}

/**
 * Прочитать ресурс как строку UTF-8.
 * Подходит для .qss, .html, .txt, .json, .xml файлов.
 *
 * Returns: содержимое файла или null если ресурс не найден.
 */
string readResourceText(string path) {
    auto f = new QFile(path);
    if (!f.exists()) return null;
    if (!f.open(1 /*QIODevice::ReadOnly*/)) return null;
    string s = f.readAllText();
    f.close();
    return s.length > 0 ? s : null;
}

/**
 * Прочитать ресурс как массив байт.
 * Подходит для изображений, бинарных данных.
 *
 * Returns: байты файла или null если ресурс не найден.
 */
ubyte[] readResourceBytes(string path) {
    auto f = new QFile(path);
    if (!f.exists()) return null;
    if (!f.open(1 /*QIODevice::ReadOnly*/)) return null;
    ubyte[] data = f.readAll();
    f.close();
    return data;
}

/**
 * Получить размер ресурса в байтах (без чтения содержимого).
 * Returns: размер >= 0, или -1 если ресурс не найден.
 */
int resourceSize(string path) {
    auto f = new QFile(path);
    if (!f.exists()) return -1;
    if (!f.open(1)) return -1;
    int sz = f.size();
    f.close();
    return sz;
}

// ── QSS из ресурсов ───────────────────────────────────────────────────────────

/**
 * Загрузить .qss из ресурса и применить как глобальный стиль приложения.
 * Заменяет текущий stylesheet.
 *
 * Returns: true если ресурс найден и применён.
 */
bool applyQssRes(QApplication app, string path) {
    string css = readResourceText(path);
    if (css is null) return false;
    app.setStyleSheet(css);
    return true;
}

/**
 * Дописать .qss из ресурса поверх текущего глобального стиля.
 */
bool appendQssRes(QApplication app, string path) {
    string css = readResourceText(path);
    if (css is null) return false;
    string cur = app.styleSheet();
    app.setStyleSheet(cur.length > 0 ? cur ~ "\n" ~ css : css);
    return true;
}

/**
 * Загрузить несколько .qss из ресурсов, объединить и применить глобально.
 */
bool applyQssResFiles(QApplication app, string[] paths, bool skipMissing = true) {
    string combined;
    bool anyLoaded = false;
    foreach (p; paths) {
        string css = readResourceText(p);
        if (css is null) {
            if (!skipMissing) return false;
            continue;
        }
        if (combined.length > 0) combined ~= "\n";
        combined ~= css;
        anyLoaded = true;
    }
    if (!anyLoaded) return false;
    app.setStyleSheet(combined);
    return true;
}

/**
 * Применить .qss из ресурса к конкретному виджету.
 */
bool applyQssResWidget(QWidget widget, string path) {
    string css = readResourceText(path);
    if (css is null) return false;
    widget.setStyleSheet(css);
    return true;
}

// ── QssThemeRes — тема целиком из ресурсов ────────────────────────────────────

/**
 * Декларативная тема, файлы которой находятся в Qt-ресурсах.
 *
 * Example:
 *   registerRcc("themes.rcc");
 *   QssThemeRes dark = {
 *       style : "Fusion",
 *       files : [":/styles/base.qss", ":/styles/dark.qss"],
 *       css   : "QLabel { font-weight: bold; }",
 *   };
 *   dark.apply(app);
 */
struct QssThemeRes {
    /// Имя движка стиля. Пустая строка — не менять.
    string style;

    /// Пути к .qss файлам в ресурсах (":/...").
    string[] files;

    /// Дополнительный инлайн-CSS, добавляется последним.
    string css;

    /// Пропускать отсутствующие файлы (по умолчанию true).
    bool skipMissing = true;

    /// Применить тему к приложению.
    bool apply(QApplication app) {
        bool applied = false;
        if (style.length > 0) {
            app.setStyle(style);
            applied = true;
        }
        string combined;
        foreach (p; files) {
            string loaded = readResourceText(p);
            if (loaded is null) {
                if (!skipMissing) return false;
                continue;
            }
            if (combined.length > 0) combined ~= "\n";
            combined ~= loaded;
            applied = true;
        }
        if (css.length > 0) {
            if (combined.length > 0) combined ~= "\n";
            combined ~= css;
            applied = true;
        }
        if (combined.length > 0)
            app.setStyleSheet(combined);
        return applied;
    }

    /// Применить тему к конкретному виджету (движок стиля игнорируется).
    bool applyWidget(QWidget widget) {
        string combined;
        foreach (p; files) {
            string loaded = readResourceText(p);
            if (loaded is null) {
                if (!skipMissing) return false;
                continue;
            }
            if (combined.length > 0) combined ~= "\n";
            combined ~= loaded;
        }
        if (css.length > 0) {
            if (combined.length > 0) combined ~= "\n";
            combined ~= css;
        }
        if (combined.length > 0)
            widget.setStyleSheet(combined);
        return combined.length > 0;
    }
}
