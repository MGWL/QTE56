/**
 * gen_qfilesystemwatcher.d — D-обёртка для QFileSystemWatcher.
 *
 * DLL: qte56_filewatcher.dll  |  Блок индексов: 20139–20148 (10 функций)
 *
 * $(H3 Назначение)
 *
 * QFileSystemWatcher подписывается на уведомления ОС об изменении файлов
 * и директорий. Не использует polling — нагрузка на CPU нулевая пока
 * файлы не изменяются.
 *
 * $(H3 Пример: hot reload скрипта)
 *
 * ---
 * import gen_qfilesystemwatcher;
 *
 * auto watcher = new QFileSystemWatcher();
 * watcher.addPath("script.wren");
 *
 * watcher.connect_fileChanged((string path) {
 *     // ОС уведомила мгновенно — без polling
 *     import std.file : exists;
 *     if (exists(path)) {
 *         watcher.addPath(path);   // переподписаться после vim-сохранения
 *         reloadScript(path);
 *     }
 * });
 * ---
 *
 * $(H3 Нюанс: vim/emacs стиль сохранения)
 *
 * Многие редакторы при сохранении удаляют файл и создают новый.
 * После удаления watcher снимает наблюдение — нужно переподписаться
 * в коллбэке `connect_fileChanged`. Пример выше показывает этот паттерн.
 *
 * $(H3 Нюанс: событие приходит асинхронно)
 *
 * Сигнал приходит через Qt event loop. Убедитесь что `app.exec()` запущен
 * или вызывайте `app.processEvents()` в цикле для консольных сценариев.
 *
 * See_Also: doc/qte56_d_reference.md §QFileSystemWatcher
 */
module gen_qfilesystemwatcher;

import std.utf   : toUTF16, toUTF8;
import std.string : split;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : t_qp__, t_v__qp, t_qp__qp, t_i__qp_qp_i, t_v__qp_qp_i,
                   t_v__qp_qp_qp, fromQString;

// ── Загрузка функций ──────────────────────────────────────────────────────────

/**
 * Загружает все функции QFileSystemWatcher из qte56_filewatcher.dll.
 * Вызывается автоматически через registerModule при первом import.
 */
void loadQFileSystemWatcher() {
    mixin(generateFunQt(20139, "qteQFileSystemWatcher_create",                "QFileSystemWatcher"));
    mixin(generateFunQt(20140, "qteQFileSystemWatcher_delete",                "QFileSystemWatcher"));
    mixin(generateFunQt(20141, "qteQFileSystemWatcher_addPath",               "QFileSystemWatcher"));
    mixin(generateFunQt(20142, "qteQFileSystemWatcher_addPaths",              "QFileSystemWatcher"));
    mixin(generateFunQt(20143, "qteQFileSystemWatcher_removePath",            "QFileSystemWatcher"));
    mixin(generateFunQt(20144, "qteQFileSystemWatcher_removePaths",           "QFileSystemWatcher"));
    mixin(generateFunQt(20145, "qteQFileSystemWatcher_files",                 "QFileSystemWatcher"));
    mixin(generateFunQt(20146, "qteQFileSystemWatcher_directories",           "QFileSystemWatcher"));
    mixin(generateFunQt(20147, "qteQFileSystemWatcher_connect_fileChanged",   "QFileSystemWatcher"));
    mixin(generateFunQt(20148, "qteQFileSystemWatcher_connect_directoryChanged", "QFileSystemWatcher"));
}

/// Авто-регистрация: вызывается при загрузке модуля.
static this() {
    registerModule("QFileSystemWatcher", "qte56_filewatcher.dll", &loadQFileSystemWatcher);
}

// ══════════════════════════════════════════════════════════════════════════════
// Вспомогательный тип для строковых коллбэков
// ══════════════════════════════════════════════════════════════════════════════

/**
 * FwClosure — GC-обёртка для `void delegate(string)` коллбэков watcher.
 *
 * Хранится в объекте QFileSystemWatcher чтобы GC не освободил делегат.
 */
private final class FwClosure {
    void delegate(string) dg; /// Захваченный D-делегат
    this(void delegate(string) d) { dg = d; }
}

/**
 * _fwTrampoline — extern(C) мост: C++ путь (wchar_t*) → D-делегат.
 *
 * Params:
 *   path = указатель на wchar_t данные пути.
 *   len  = длина строки в символах wchar_t.
 *   ctx  = указатель на FwClosure.
 */
extern(C) private static void _fwTrampoline(const(wchar)* path, int len, void* ctx) {
    try {
        import std.utf : toUTF8;
        string s = path[0 .. len].toUTF8;
        (cast(FwClosure)ctx).dg(s);
    } catch (Exception) {}
}

// ══════════════════════════════════════════════════════════════════════════════
// Вспомогательная: конвертировать string[] → wstring через \x01
// ══════════════════════════════════════════════════════════════════════════════

private wstring pathsToW(string[] paths) {
    import std.array : join;
    return paths.join("\x01").toUTF16;
}

// ══════════════════════════════════════════════════════════════════════════════
// Основной класс
// ══════════════════════════════════════════════════════════════════════════════

/**
 * QFileSystemWatcher — наблюдатель за изменениями файлов и директорий.
 *
 * Использует механизм уведомлений ОС (inotify на Linux,
 * ReadDirectoryChangesW на Windows) без polling.
 *
 * $(H3 Жизненный цикл)
 *
 * Watcher не привязан к виджету — необходимо вызвать `destroy(watcher)`
 * явно, или хранить как поле класса с явным деструктором.
 *
 * $(H3 Пример: слежение за конфигом)
 *
 * ---
 * auto w = new QFileSystemWatcher();
 * w.addPath("config.ini");
 * w.connect_fileChanged((string p) {
 *     reloadConfig(p);
 *     w.addPath(p);   // переподписаться если редактор пересоздал файл
 * });
 * ---
 */
@live class QFileSystemWatcher {
private:
    void*       _wh;        /// Указатель на C++ QFileSystemWatcher
    FwClosure[] _closures;  /// GC-якорь: все зарегистрированные коллбэки

public:

    /**
     * Создаёт пустой watcher без наблюдаемых путей.
     */
    this() {
        _wh = (cast(t_qp__)pFunQt[20139])();
    }

    /**
     * Удаляет watcher и освобождает ресурсы ОС.
     */
    ~this() {
        if (_wh) {
            (cast(t_v__qp)pFunQt[20140])(_wh);
            _wh = null;
        }
    }

    /**
     * Добавляет файл или директорию под наблюдение.
     *
     * Для директорий сигнал `directoryChanged` срабатывает при изменении
     * списка файлов в ней (появление/исчезновение), но не при изменении
     * содержимого файлов внутри.
     *
     * Params:
     *   path = абсолютный или относительный путь к файлу или директории.
     *
     * Returns:
     *   `true` если ОС успешно взяла путь под наблюдение.
     *   `false` если путь не существует, или уже наблюдается, или
     *   превышен системный лимит дескрипторов.
     */
    bool addPath(string path) {
        wstring wp = path.toUTF16;
        return (cast(t_i__qp_qp_i)pFunQt[20141])(
            _wh, cast(void*)wp.ptr, cast(int)wp.length) != 0;
    }

    /**
     * Добавляет несколько путей за один вызов.
     *
     * Params:
     *   paths = массив путей к файлам или директориям.
     */
    QFileSystemWatcher addPaths(string[] paths) {
        if (paths.length == 0) return null;
        wstring wp = pathsToW(paths);
        (cast(t_v__qp_qp_i)pFunQt[20142])(_wh, cast(void*)wp.ptr, cast(int)wp.length);
        return this;
    }

    /**
     * Убирает путь из наблюдения.
     *
     * Params:
     *   path = путь добавленный ранее через `addPath`.
     */
    QFileSystemWatcher removePath(string path) {
        wstring wp = path.toUTF16;
        (cast(t_v__qp_qp_i)pFunQt[20143])(_wh, cast(void*)wp.ptr, cast(int)wp.length);
        return this;
    }

    /**
     * Убирает несколько путей из наблюдения за один вызов.
     *
     * Params:
     *   paths = массив путей для удаления.
     */
    QFileSystemWatcher removePaths(string[] paths) {
        if (paths.length == 0) return null;
        wstring wp = pathsToW(paths);
        (cast(t_v__qp_qp_i)pFunQt[20144])(_wh, cast(void*)wp.ptr, cast(int)wp.length);
        return this;
    }

    /**
     * Возвращает список всех наблюдаемых файлов.
     *
     * Returns: массив путей, добавленных через `addPath` (только файлы).
     */
    string[] files() {
        void* qs = (cast(t_qp__qp)pFunQt[20145])(_wh);
        string s = fromQString(qs);
        (cast(t_v__qp)pFunQt[22])(qs);  // освобождаем временный QString
        if (s.length == 0) return [];
        return s.split('\x01');
    }

    /**
     * Возвращает список всех наблюдаемых директорий.
     *
     * Returns: массив путей, добавленных через `addPath` (только директории).
     */
    string[] directories() {
        void* qs = (cast(t_qp__qp)pFunQt[20146])(_wh);
        string s = fromQString(qs);
        (cast(t_v__qp)pFunQt[22])(qs);
        if (s.length == 0) return [];
        return s.split('\x01');
    }

    /**
     * Подключает коллбэк к сигналу `fileChanged(path)`.
     *
     * Сигнал срабатывает когда наблюдаемый файл изменён, переименован
     * или удалён. После удаления файла наблюдение снимается автоматически —
     * при необходимости вызовите `addPath(path)` повторно.
     *
     * Params:
     *   cb = делегат `void delegate(string path)`.
     *
     * Examples:
     * ---
     * w.connect_fileChanged((string path) {
     *     writeln("Изменён: ", path);
     *     if (std.file.exists(path)) w.addPath(path); // переподписка
     * });
     * ---
     */
    QFileSystemWatcher connect_fileChanged(void delegate(string) cb) {
        auto cl = new FwClosure(cb);
        _closures ~= cl;
        (cast(t_v__qp_qp_qp)pFunQt[20147])(
            _wh, cast(void*)&_fwTrampoline, cast(void*)cl);
        return this;
    }

    /**
     * Подключает коллбэк к сигналу `directoryChanged(path)`.
     *
     * Сигнал срабатывает когда в наблюдаемой директории появился,
     * исчез или переименован файл (но не при изменении содержимого файла).
     *
     * Params:
     *   cb = делегат `void delegate(string path)`.
     *
     * Examples:
     * ---
     * w.connect_directoryChanged((string dir) {
     *     writeln("Изменена директория: ", dir);
     *     rescanDir(dir);
     * });
     * ---
     */
    QFileSystemWatcher connect_directoryChanged(void delegate(string) cb) {
        auto cl = new FwClosure(cb);
        _closures ~= cl;
        (cast(t_v__qp_qp_qp)pFunQt[20148])(
            _wh, cast(void*)&_fwTrampoline, cast(void*)cl);
        return this;
    }

    /**
     * Возвращает: внутренний указатель C++ объекта.
     */
    void* getWH() { return _wh; }
}
