/**
 * qte56_loader.d — загрузка Qt DLL по зарегистрированным модулям.
 *
 * Использование:
 *   import gen_qlabel;        // static this() регистрирует QLabel + QCore транзитивно
 *   LoadQt("./dll");          // грузит только зарегистрированные DLL, вызывает loadXxx()
 *   UnloadQt();               // FreeLibrary + обнуляет pFunQt[]
 *
 * Каждый gen_*.d регистрирует свой модуль через registerModule() в static this().
 * D транзитивно инициализирует импортируемые модули, поэтому зависимости
 * (например QCore для QLabel) подтягиваются автоматически.
 */
module qte56_loader;

import qte56_core : pFunQt, PFUNQT_SIZE;
import std.conv : to;

version(Windows) {
    import core.sys.windows.windows :
        LoadLibraryA, GetProcAddress, FreeLibrary, HMODULE, GetLastError;
} else {
    import core.sys.posix.dlfcn : dlopen, dlsym, dlclose, RTLD_NOW, RTLD_GLOBAL;
}

// ─────────────────────────────────────────────────────────────────────────────
// Логирование в файл на базовых C-функциях
// ─────────────────────────────────────────────────────────────────────────────

extern(C) {
    FILE* fopen(const(char)* filename, const(char)* mode);
    int   fputs(const(char)* str, FILE* stream);
    int   fclose(FILE* stream);
    int   fflush(FILE* stream);
    struct FILE;
}

/**
 * Добавляет строку в лог-файл.
 * Логирование включается только если задана переменная окружения QTE56LOG.
 * Работает на базовых C-функциях — без зависимостей от D-runtime.
 *
 * Параметры:
 *   strLog — строка для записи
 */
void addStrInLog(string strLog) {
    import std.process : environment;
    import std.string : toStringz;

    string logFile = environment.get("QTE56LOG", "");
    if (logFile.length == 0) return;  // Логирование отключено
    
    FILE* fp = fopen(toStringz(logFile), toStringz("a"));
    if (fp is null) return;
    
    fputs(toStringz(strLog), fp);
    fputs(toStringz("\n"), fp);
    fflush(fp);
    fclose(fp);
}

/**
 * Записывает имя DLL в файл деплоя.
 * Используется утилитой deploy_qte56 для сбора зависимостей.
 * Включается переменной окружения QTE56DEPLOY (путь к файлу).
 *
 * Формат: одно имя DLL на строку, без путей.
 * Пример:
 *   qte56_core.dll
 *   qte56_widgets.dll
 *   Qt5Core.dll
 *
 * Параметры:
 *   dllName — имя DLL файла (только имя, без пути)
 */
void addDllForDeploy(string dllName) {
    import std.process : environment;
    import std.string : toStringz;

    string deployFile = environment.get("QTE56DEPLOY", "");
    if (deployFile.length == 0) return;  // Деплой-лог отключен
    
    FILE* fp = fopen(toStringz(deployFile), toStringz("a"));
    if (fp is null) return;
    
    fputs(toStringz(dllName), fp);
    fputs(toStringz("\n"), fp);
    fflush(fp);
    fclose(fp);
}

// ─────────────────────────────────────────────────────────────────────────────
// Определение папки DLL из QTE56_ARCH
// ─────────────────────────────────────────────────────────────────────────────

/**
 * Возвращает папку с DLL на основе переменной окружения QTE56_ARCH.
 *
 * Поддерживаемые конфигурации:
 *   win32_qt5   → dll/dll32
 *   win64_qt6   → dll/dll64
 *   linux64_qt5 → lib
 *   linux64_qt6 → lib
 *
 * Если переменная не задана — возвращается "./dll".
 */
string getDllDirFromArch() {
    import std.process : environment;

    string arch = environment.get("QTE56_ARCH", "");
    if (arch == "win32_qt5")   return "dll/dll32";
    if (arch == "win64_qt6")   return "dll/dll64";
    if (arch == "linux64_qt5") return "lib";
    if (arch == "linux64_qt6") return "lib";
    return "./dll";  // По умолчанию
}

// ─────────────────────────────────────────────────────────────────────────────
// Внутреннее состояние
// ─────────────────────────────────────────────────────────────────────────────

/// Карта: имя_модуля → HMODULE
private __gshared void*[string] _dll_handles;

/// Запись о зарегистрированном модуле
private struct ModuleReg {
    string moduleName;   // "QCore", "QLabel", ...
    string dllFile;      // "qte56_qcore.dll", ...
    void function() loader; // &loadQCore, &loadQLabel, ...
}

/// Список зарегистрированных модулей (заполняется через static this() в gen_*.d)
private __gshared ModuleReg[] _modules;

// ─────────────────────────────────────────────────────────────────────────────
// soName — преобразует имя DLL для текущей платформы
// ─────────────────────────────────────────────────────────────────────────────

/// "qte56_widgets.dll" → Windows: "qte56_widgets.dll"
///                     → Linux:   "libqte56_widgets.so"
///                     → macOS:   "libqte56_widgets.dylib"
private string soName(string dllFile) {
    version(Windows) {
        return dllFile;
    } else version(OSX) {
        // macOS: foo.dll → libfoo.dylib
        string base = dllFile;
        if (base.length > 4 && base[$-4..$] == ".dll")
            base = base[0 .. $-4];
        return "lib" ~ base ~ ".dylib";
    } else {
        // Linux и другие POSIX: foo.dll → libfoo.so
        string base = dllFile;
        if (base.length > 4 && base[$-4..$] == ".dll")
            base = base[0 .. $-4];
        return "lib" ~ base ~ ".so";
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// registerModule — вызывается из static this() каждого gen_*.d
// ─────────────────────────────────────────────────────────────────────────────

/**
 * Регистрирует модуль: имя, DLL файл, функция загрузки адресов.
 * Повторная регистрация одного модуля игнорируется.
 */
void registerModule(string moduleName, string dllFile, void function() loader) {
    foreach (ref m; _modules)
        if (m.moduleName == moduleName) return;  // уже зарегистрирован
    _modules ~= ModuleReg(moduleName, dllFile, loader);
}

// ─────────────────────────────────────────────────────────────────────────────
// loadFn — используется из mixin(generateFunQt(...))
// ─────────────────────────────────────────────────────────────────────────────

/// Ищет адрес функции func_name в DLL модуля module_name.
void* loadFn(string module_name, string func_name) {
    auto h = module_name in _dll_handles;
    if (h is null) return null;

    version(Windows) {
        return GetProcAddress(cast(HMODULE)*h, func_name.ptr);
    } else {
        return dlsym(*h, func_name.ptr);
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// LoadQt — главная точка входа
// ─────────────────────────────────────────────────────────────────────────────

/**
 * Загружает Qt DLL для всех зарегистрированных модулей.
 *
 * dllDir — папка где лежат DLL (по умолчанию "./dll").
 *
 * Алгоритм:
 *   1. Для каждого зарегистрированного модуля: LoadLibrary(dllDir/dllFile).
 *      Windows fallback: LoadLibrary(dllFile) (поиск по PATH), затем развёрнутый
 *      runtime C:\Users\Public\QTE56\dll\dll32|dll64 (AGENTS.md §3).
 *      NB: qte56_*.dll зависят от qte56_foundation.dll — она грузится первой.
 *   2. Для каждого модуля: вызвать loader() → заполняет pFunQt[].
 *
 * Какие модули загружаются — определяется импортами в пользовательском коде.
 * import gen_qlabel → static this() регистрирует QLabel и (транзитивно) QCore.
 */
void LoadQt(string dllDir = null) {
    import std.string : toStringz;
    import std.file : exists, isDir;

    // Если dllDir не задан — определяем из QTE56_ARCH
    if (dllDir is null || dllDir.length == 0) {
        dllDir = getDllDirFromArch();
    }

    addStrInLog("=== LoadQt started ===");
    addStrInLog("dllDir=" ~ dllDir);

    // На Linux/macOS: если указанная папка не существует — пробуем "./lib" как fallback.
    // Если пользователь явно указал существующий путь — используем его как есть.
    version(Posix) {
        if (!exists(dllDir) || !isDir(dllDir)) {
            if (exists("./lib") && isDir("./lib"))
                dllDir = "./lib";
        }
    }

    // Windows: каталог qte56-DLL добавляем в путь поиска зависимостей процесса —
    // иначе не резолвятся соседние DLL (qscintilla2_qt5.dll для qte56_qscintilla.dll,
    // qte56_foundation.dll для остальных). Сами переменные окружения не трогаем.
    version(Windows) {
        import std.utf : toUTF16;
        import core.sys.windows.windows : SetDllDirectoryW;
        if (exists(dllDir) && isDir(dllDir)) {
            import std.path : absolutePath;
            SetDllDirectoryW((absolutePath(dllDir) ~ "\0").toUTF16.ptr);
            addStrInLog("SetDllDirectory: " ~ dllDir);
        }
    }

    // 1. Загружаем DLL для каждого зарегистрированного модуля.
    //    qte56_foundation.dll грузим первой: от неё зависят остальные qte56 DLL
    //    (lifecycle-трекинг, линковка MinGW).
    addStrInLog("Modules to load: " ~ to!string(_modules.length));
    foreach (ref m; _modules) {
        addStrInLog("  registered: " ~ m.moduleName ~ " -> " ~ m.dllFile);
    }

    // Разделяем foundation и остальные
    ModuleReg[] foundationMods;
    ModuleReg[] otherMods;
    foreach (ref m; _modules) {
        if (m.dllFile == "qte56_foundation.dll")
            foundationMods ~= m;
        else
            otherMods ~= m;
    }

    foreach (ref m; foundationMods ~ otherMods) {
        if (m.moduleName in _dll_handles) continue;  // уже загружена

        string path = dllDir ~ "/" ~ soName(m.dllFile);
        auto cpath = toStringz(path);
        addStrInLog("Module=" ~ m.moduleName ~ " File=" ~ m.dllFile);
        addStrInLog("Loading: " ~ path);

        version(Windows) {
            HMODULE h = LoadLibraryA(cpath);
            if (h is null) {
                // Fallback 1: поиск по PATH (голое имя → стандартный порядок поиска Windows).
                h = LoadLibraryA(toStringz(soName(m.dllFile)));
                if (h !is null)
                    addStrInLog("OK (via PATH): " ~ soName(m.dllFile));
            }
            if (h is null) {
                // Fallback 2: развёрнутый runtime QTE56 (AGENTS.md §3).
                // Неверная разрядность даёт ошибку 193 — безопасно пробуем обе папки.
                enum string[2] deployed = [
                    `C:\Users\Public\QTE56\dll\dll32\`,
                    `C:\Users\Public\QTE56\dll\dll64\`,
                ];
                foreach (dir; deployed) {
                    h = LoadLibraryA(toStringz(dir ~ soName(m.dllFile)));
                    if (h !is null) {
                        addStrInLog("OK (deployed): " ~ dir ~ soName(m.dllFile));
                        // соседние DLL (foundation, qscintilla2_qt5) — из того же каталога
                        import std.utf : toUTF16;
                        import core.sys.windows.windows : SetDllDirectoryW;
                        SetDllDirectoryW((dir[0 .. $-1] ~ "\0").toUTF16.ptr);
                        break;
                    }
                }
            }
            if (h is null) {
                auto err = GetLastError();
                string msg = "[qte56] Failed to load: " ~ path ~ " (error=" ~ to!string(err) ~ ")";
                addStrInLog(msg);
                continue;
            }
            _dll_handles[m.moduleName] = cast(void*)h;
            addStrInLog("OK: " ~ path);
        } else {
            void* h = dlopen(cpath, RTLD_NOW | RTLD_GLOBAL);
            if (h is null) {
                addStrInLog("Failed: " ~ path);
                continue;
            }
            _dll_handles[m.moduleName] = h;
            addStrInLog("OK: " ~ path);
        }

        // Записываем имя DLL для утилиты деплоя
        addDllForDeploy(m.dllFile);

        addStrInLog("[qte56] Loaded: " ~ path ~ " (module=" ~ m.moduleName ~ ")");
    }

    // 2. Заполняем pFunQt[] через load-функции каждого модуля
    addStrInLog("Filling pFunQt...");
    foreach (ref m; _modules) {
        addStrInLog("  loader: " ~ m.moduleName);
        m.loader();
    }

    addStrInLog("=== LoadQt complete ===");
}

// ─────────────────────────────────────────────────────────────────────────────
// UnloadQt — освобождает все загруженные DLL
// ─────────────────────────────────────────────────────────────────────────────

void UnloadQt() {
    foreach (mod, handle; _dll_handles) {
        version(Windows) { FreeLibrary(cast(HMODULE)handle); }
        else              { dlclose(handle); }
    }
    _dll_handles.clear();
    pFunQt[] = null;
}

// ─────────────────────────────────────────────────────────────────────────────
// Диагностические функции для Inspector / отладки
// ─────────────────────────────────────────────────────────────────────────────

/**
 * Возвращает строку с информацией о зарегистрированных и загруженных модулях.
 * Формат: "ModuleName -> dllFile [LOADED|NOT LOADED]".
 */
string dumpModuleInfo() {
    import std.conv : to;

    string result = "Registered modules: " ~ to!string(_modules.length) ~ "\n";
    foreach (ref m; _modules) {
        bool loaded = (m.moduleName in _dll_handles) !is null;
        result ~= "  " ~ m.moduleName ~ " -> " ~ m.dllFile;
        result ~= loaded ? " [LOADED]\n" : " [NOT LOADED]\n";
    }
    return result;
}

/**
 * Считает количество незаполненных (null) слотов в pFunQt.
 * Используется для выявления "дыр" в реестре функций.
 */
int countNullSlots(int from = 1, int to_ = PFUNQT_SIZE - 1) {
    int count = 0;
    if (from < 1) from = 1;
    if (to_ >= PFUNQT_SIZE) to_ = PFUNQT_SIZE - 1;
    for (int i = from; i <= to_; i++) {
        if (pFunQt[i] is null) count++;
    }
    return count;
}

/**
 * Возвращает строку со статистикой pFunQt.
 */
string dumpPFunQtStats() {
    import std.conv : to;

    int nullTotal = 0;
    int usedTotal = 0;
    for (int i = 1; i < PFUNQT_SIZE; i++) {
        if (pFunQt[i] is null) nullTotal++;
        else usedTotal++;
    }
    return "pFunQt stats:\n" ~
           "  total slots: " ~ to!string(PFUNQT_SIZE) ~ "\n" ~
           "  used:        " ~ to!string(usedTotal) ~ "\n" ~
           "  null:        " ~ to!string(nullTotal) ~ "\n";
}
