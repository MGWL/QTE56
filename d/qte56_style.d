/**
 * qte56_style.d — helpers for QSS stylesheet management.
 *
 * Чистый D-модуль поверх уже существующих QApplication.setStyleSheet()
 * и QWidget.setStyleSheet(). Нового C++ не требует.
 *
 * Типичное использование:
 *
 *   // Применить одну тему
 *   applyQss(app, "themes/dark.qss");
 *
 *   // Наслоить несколько файлов
 *   applyQssFiles(app, ["base.qss", "dark.qss"]);
 *
 *   // Дописать поверх (не заменяет текущий стиль)
 *   appendQss(app, "overrides.qss");
 *
 *   // Применить к конкретному виджету
 *   applyQssWidget(panel, "sidebar.qss");
 *
 *   // Работа через структуру темы
 *   QssTheme theme = { style: "Fusion", files: ["dark.qss"] };
 *   theme.apply(app);
 */
module qte56_style;

import gen_qcore   : QApplication;
import gen_qwidget : QWidget;

// ── Ошибки ───────────────────────────────────────────────────────────────────

/// Исключение при работе с QSS-файлами. Не бросается по умолчанию —
/// функции возвращают bool. Брось сам если хочешь жёсткое поведение.
class QssException : Exception {
    this(string msg, string file = __FILE__, size_t line = __LINE__) {
        super(msg, file, line);
    }
}

// ── Загрузка .qss файлов ─────────────────────────────────────────────────────

/**
 * Загрузить .qss файл и применить как глобальный стиль приложения.
 * Заменяет текущий stylesheet полностью.
 *
 * Returns: true если файл найден и прочитан, false если нет.
 */
bool applyQss(QApplication app, string path) {
    string css = _readQss(path);
    if (css is null) return false;
    app.setStyleSheet(css);
    return true;
}

/**
 * Загрузить .qss файл и дописать поверх текущего глобального стиля.
 * Существующие правила не затрагиваются.
 *
 * Returns: true если файл найден и прочитан.
 */
bool appendQss(QApplication app, string path) {
    string css = _readQss(path);
    if (css is null) return false;
    _appendTo(app, css);
    return true;
}

/**
 * Загрузить несколько .qss файлов, объединить и применить глобально.
 * Заменяет текущий stylesheet.
 *
 * Params:
 *   skipMissing = если true (по умолчанию) — пропускает отсутствующие файлы.
 *                 если false — возвращает false при первом отсутствующем.
 *
 * Returns: true если хотя бы один файл применён.
 */
bool applyQssFiles(QApplication app, string[] paths, bool skipMissing = true) {
    string combined;
    bool anyLoaded = false;
    foreach (p; paths) {
        string css = _readQss(p);
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
 * Загрузить .qss файл и применить только к конкретному виджету и его потомкам.
 * Не влияет на глобальный стиль.
 *
 * Returns: true если файл найден и прочитан.
 */
bool applyQssWidget(QWidget widget, string path) {
    string css = _readQss(path);
    if (css is null) return false;
    widget.setStyleSheet(css);
    return true;
}

/**
 * Загрузить несколько .qss файлов, объединить и применить к виджету.
 */
bool applyQssFilesWidget(QWidget widget, string[] paths, bool skipMissing = true) {
    string combined;
    bool anyLoaded = false;
    foreach (p; paths) {
        string css = _readQss(p);
        if (css is null) {
            if (!skipMissing) return false;
            continue;
        }
        if (combined.length > 0) combined ~= "\n";
        combined ~= css;
        anyLoaded = true;
    }
    if (!anyLoaded) return false;
    widget.setStyleSheet(combined);
    return true;
}

// ── Управление текущим стилем ─────────────────────────────────────────────────

/**
 * Дописать CSS-строку поверх текущего глобального стиля.
 * Используй когда CSS уже в памяти (не в файле).
 */
void appendStyleSheet(QApplication app, string css) {
    _appendTo(app, css);
}

/**
 * Дописать CSS-строку поверх стиля виджета.
 */
void appendStyleSheet(QWidget widget, string css) {
    string current = widget.styleSheet();
    widget.setStyleSheet(current.length > 0 ? current ~ "\n" ~ css : css);
}

/**
 * Очистить глобальный stylesheet (сброс к системному виду).
 */
void clearStyleSheet(QApplication app) {
    app.setStyleSheet("");
}

/**
 * Очистить stylesheet виджета (наследует стиль родителя или системный).
 */
void clearStyleSheet(QWidget widget) {
    widget.setStyleSheet("");
}

// ── Информация о движках стилей ───────────────────────────────────────────────

/**
 * Список имён стилевых движков, гарантированно доступных в Qt 5.13 на Windows.
 * Передавай в app.setStyle(name). setStyle() принимает имена без учёта регистра.
 *
 * Важно: app.styleName() / currentStyle() возвращают имена в нижнем регистре
 * ("fusion", "windows", "windowsvista"), даже если setStyle() вызван с заглавными.
 *
 * Примечание: QStyleFactory.keys() не обёрнут в C++ — используй этот список
 * как ориентир. app.setStyle() молча игнорирует неизвестные имена.
 */
string[] knownStyles() {
    // Fusion и Windows встроены в Qt и доступны всегда.
    // WindowsVista доступен на Vista+ если скомпилирован (обычно да в 5.13).
    return ["Fusion", "Windows", "WindowsVista"];
}

/**
 * Вернуть текущее имя стилевого движка.
 * Эквивалентно app.styleName(), предоставлен для симметрии.
 */
string currentStyle(QApplication app) {
    return app.styleName();
}

// ── QssTheme — декларативное описание темы ────────────────────────────────────

/**
 * Структура темы: комбинирует движок стиля, список .qss файлов и
 * дополнительный инлайн-CSS.
 *
 * Пример:
 *   QssTheme dark = {
 *       style : "Fusion",
 *       files : ["themes/base.qss", "themes/dark.qss"],
 *       css   : "QLabel { color: #eee; }",
 *   };
 *   dark.apply(app);
 *
 *   // Из файла INI/JSON (читай сам, передавай поля):
 *   QssTheme theme;
 *   theme.style = settings.getString("style");
 *   theme.files = [settings.getString("qss_file")];
 *   theme.apply(app);
 */
struct QssTheme {
    /// Имя движка стиля ("Fusion", "Windows", "WindowsVista", "").
    /// Пустая строка — не менять текущий движок.
    string style;

    /// Список .qss файлов. Объединяются в порядке перечисления.
    string[] files;

    /// Дополнительный инлайн-CSS, добавляется после файлов.
    string css;

    /// Пропускать отсутствующие файлы из списка files (по умолчанию true).
    bool skipMissing = true;

    /**
     * Применить тему к приложению.
     * Returns: true если хотя бы что-то применено (движок или CSS).
     */
    bool apply(QApplication app) {
        bool applied = false;

        if (style.length > 0) {
            app.setStyle(style);
            applied = true;
        }

        string combined;
        foreach (p; files) {
            string loaded = _readQss(p);
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

    /**
     * Применить тему к конкретному виджету (без смены движка стиля).
     */
    bool applyWidget(QWidget widget) {
        string combined;
        foreach (p; files) {
            string loaded = _readQss(p);
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

// ── Внутренние утилиты ────────────────────────────────────────────────────────

/// Читает файл. Поддерживает файловую систему и ":/..." ресурсные пути Qt.
/// Возвращает null если файл не существует или не читается.
private string _readQss(string path) {
    import std.algorithm.searching : startsWith;
    if (path.startsWith(":/"))
        return _readQssFromQFile(path);
    import std.file : readText, exists, FileException;
    if (!exists(path)) return null;
    try {
        return readText(path);
    } catch (FileException) {
        return null;
    }
}

/// Читает ":/..." путь через QFile (поддерживает Qt-ресурсы).
/// Возвращает null если QFile не загружен или ресурс не найден.
private string _readQssFromQFile(string path) {
    import qte56_core : pFunQt;
    if (pFunQt[18501] is null) return null;   // QFile не загружен
    import gen_qfile : QFile;
    auto f = new QFile(path);
    if (!f.exists()) return null;
    if (!f.open(1 /*QIODevice::ReadOnly*/)) return null;
    string s = f.readAllText();
    f.close();
    return s.length > 0 ? s : null;
}

/// Дописывает css к текущему глобальному stylesheet.
private void _appendTo(QApplication app, string css) {
    string current = app.styleSheet();
    app.setStyleSheet(current.length > 0 ? current ~ "\n" ~ css : css);
}
