/**
 * gen_qcore.d — СГЕНЕРИРОВАННЫЙ модуль для QCore.
 *
 * Содержит:
 *   - alias типов функций (compile-time)
 *   - блок mixin для LoadQt() — регистрация адресов функций
 *   - D struct для value-types
 *   - Класс QApplication
 *
 * Этот файл генерируется generator/main.py.
 * НЕ редактировать вручную.
 */
module gen_qcore;

import qte56_core;
import qte56_loader : loadFn, registerModule;

// ═══════════════════════════════════════════════════════════════════════════
// СЕКЦИЯ 1: Alias типов функций (compile-time, не зависят от DLL)
// ═══════════════════════════════════════════════════════════════════════════

// QPointer lifecycle
mixin(generateAlias("qp__i"));         // t_qp__i   : void* function(int)
mixin(generateAlias("v__qp_i"));       // t_v__qp_i : void function(void*, int)
mixin(generateAlias("b__qp_i"));       // t_b__qp_i : int  function(void*, int)

// qteConnect
alias t_qobj_connect = extern(C) @nogc void function(void*, const(char)*, void*, const(char)*, int);

// eSlot
mixin(generateAlias("qp__qp_qp"));     // t_qp__qp_qp     : void* function(void*, void*)
mixin(generateAlias("v__qp_qp_qp_i")); // t_v__qp_qp_qp_i : void function(void*, void*, void*, int)

// QString
mixin(generateAlias("qp__qp_i"));      // t_qp__qp_i : void* function(void*, int)
mixin(generateAlias("i__qp_qp_i"));    // t_i__qp_qp : int function(void*, void*, int)
mixin(generateAlias("v__qp"));         // t_v__qp    : void function(void*)

// Value types: pack (4 ints → void*)
mixin(generateAlias("qp__i_i_i_i"));   // t_qp__i_i_i_i
// Value types: unpack (void*, 4×int*)
mixin(generateAlias("v__qp_ip_ip_ip_ip")); // t_v__qp_ip_ip_ip_ip
// Value types: pack (2 ints → void*)
mixin(generateAlias("qp__i_i"));       // t_qp__i_i
// Value types: unpack (void*, 2×int*)
mixin(generateAlias("v__qp_ip_ip"));   // t_v__qp_ip_ip
// Value types: unpack (void*, 3×int*)
mixin(generateAlias("v__qp_ip_ip_ip")); // t_v__qp_ip_ip_ip

// Date/time in: 2/3/6 ints (used by QCalendarWidget, QDateTimeEdit, etc.)
mixin(generateAlias("v__qp_i_i"));       // t_v__qp_i_i
mixin(generateAlias("v__qp_i_i_i"));     // t_v__qp_i_i_i
mixin(generateAlias("v__qp_i_i_i_i_i_i")); // t_v__qp_i_i_i_i_i_i

// Common multi-pointer aliases (used by QWidget, QFont integration, lambda-connect, etc.)
mixin(generateAlias("v__qp_qp"));      // t_v__qp_qp   : void function(void*, void*)
mixin(generateAlias("v__qp_qp_qp"));   // t_v__qp_qp_qp: void function(void*, void*, void*)
// New post-simplification aliases (string params are now void* not wchar*+int)
mixin(generateAlias("v__qp_i_qp"));    // t_v__qp_i_qp   : void function(void*, int, void*)
mixin(generateAlias("i__qp_qp"));      // t_i__qp_qp     : int  function(void*, void*)
mixin(generateAlias("i__qp_qp_qp"));   // t_i__qp_qp_qp  : int  function(void*, void*, void*)
mixin(generateAlias("i__qp_i_qp"));    // t_i__qp_i_qp   : int  function(void*, int, void*)
mixin(generateAlias("i__qp_i_qp_qp")); // t_i__qp_i_qp_qp: int  function(void*, int, void*, void*)
mixin(generateAlias("v__qp_i_qp_i"));  // t_v__qp_i_qp_i : void function(void*, int, void*, int)
mixin(generateAlias("v__qp_qp_qp_qp")); // t_v__qp_qp_qp_qp
mixin(generateAlias("qp__qp_qp_i"));   // t_qp__qp_qp_i : void* function(void*, void*, int)

// QApplication
mixin(generateAlias("qp__qp"));        // t_qp__qp : void* function(void*)
mixin(generateAlias("i__qp"));         // t_i__qp  : int  function(void*)
mixin(generateAlias("v__qp_qp_i"));    // t_v__qp_qp_i : void function(void*, void*, int)

// setEventHandler: void function(void* w, int id, void* cb, void* dthis)
mixin(generateAlias("v__qp_i_qp_qp")); // t_v__qp_i_qp_qp

// No-arg getter: void* function() — for QApplication::clipboard() etc.
mixin(generateAlias("qp__"));          // t_qp__

// Буфер + длина: void* function(void*, int*) — readAll, readAllStdout/Stderr и т.п.
mixin(generateAlias("qp__qp_ip"));     // t_qp__qp_ip

// String + mode: void function(void*, const(char)*, int) — for clipboard::setText etc.
mixin(generateAlias("v__qp_cp_i"));    // t_v__qp_cp_i

// Double params: void function(void*, double) — for setScale, setRotation etc.
mixin(generateAlias("v__qp_d"));       // t_v__qp_d

// Double pair: void function(void*, double, double) — for setPos, scale etc.
mixin(generateAlias("v__qp_d_d"));     // t_v__qp_d_d

// Four doubles: void function(void*, double, double, double, double) — for setSceneRect, fitInView etc.
mixin(generateAlias("v__qp_d_d_d_d")); // t_v__qp_d_d_d_d

// Five params: void function(void*, double, double, double, double, int) — for fitInView
mixin(generateAlias("v__qp_d_d_d_d_i")); // t_v__qp_d_d_d_d_i

// D callback types — сигнатуры D-функций, вызываемых из eSlot
alias DSlot_v  = extern(C) void function(void* dthis, int n);
alias DSlot_i  = extern(C) void function(void* dthis, int n, int val);
alias DSlot_ii = extern(C) void function(void* dthis, int n, int a, int b);
alias DSlot_d  = extern(C) void function(void* dthis, int n, double val);
alias DSlot_s  = extern(C) void function(void* dthis, int n, void* qs);
alias DSlot_p   = extern(C) void function(void* dthis, int n, int x, int y);
// invoke_qp: Qt-объект передаётся как void* (QAction*, QMenu*, и т.д.)
alias DSlot_ptr = extern(C) void function(void* dthis, int n, void* ptr);

// ═══════════════════════════════════════════════════════════════════════════
// СЕКЦИЯ 2: D struct для value-types
// ═══════════════════════════════════════════════════════════════════════════

// ── DRect ──────────────────────────────────────────────────────────────────
// Прямоугольник: x,y — левый верхний угол; w,h — ширина и высота.
// Соответствует QRect из Qt (целочисленный).
struct DRect {
    int x, y, w, h;

    // ── Производные координаты ──────────────────────────────────────────────
    /// Правая граница включительно (x + w - 1), как в Qt
    @property int right()  pure nothrow { return x + w - 1; }
    /// Нижняя граница включительно (y + h - 1), как в Qt
    @property int bottom() pure nothrow { return y + h - 1; }
    /// Синоним w — ширина
    @property int width()  pure nothrow { return w; }
    /// Синоним h — высота
    @property int height() pure nothrow { return h; }

    // ── Угловые точки ───────────────────────────────────────────────────────
    DPoint topLeft()     pure nothrow { return DPoint(x,         y); }
    DPoint topRight()    pure nothrow { return DPoint(x + w - 1, y); }
    DPoint bottomLeft()  pure nothrow { return DPoint(x,         y + h - 1); }
    DPoint bottomRight() pure nothrow { return DPoint(x + w - 1, y + h - 1); }
    /// Центр прямоугольника
    DPoint center()      pure nothrow { return DPoint(x + w / 2, y + h / 2); }
    /// Размер как DSize
    DSize  size()        pure nothrow { return DSize(w, h); }

    // ── Состояние ────────────────────────────────────────────────────────────
    /// Пустой: w <= 0 или h <= 0 (нет площади)
    bool isEmpty() pure nothrow { return w <= 0 || h <= 0; }
    /// Нулевой: все поля равны нулю
    bool isNull()  pure nothrow { return x == 0 && y == 0 && w == 0 && h == 0; }
    /// Валидный: w > 0 и h > 0
    bool isValid() pure nothrow { return w > 0 && h > 0; }

    // ── Проверка вхождения ───────────────────────────────────────────────────
    /// Точка (px,py) внутри прямоугольника (левый/верхний край включён, правый/нижний — нет)
    bool contains(int px, int py) pure nothrow {
        return px >= x && px < x + w && py >= y && py < y + h;
    }
    /// Точка DPoint внутри прямоугольника
    bool contains(DPoint p) pure nothrow { return contains(p.x, p.y); }
    /// Прямоугольник r целиком внутри this (строгое вхождение)
    bool contains(DRect r) pure nothrow {
        return r.x >= x && r.y >= y && r.x + r.w <= x + w && r.y + r.h <= y + h;
    }
    /// Два прямоугольника пересекаются (не касаются по краю)
    bool intersects(DRect r) pure nothrow {
        return !(r.x >= x + w || r.x + r.w <= x || r.y >= y + h || r.y + r.h <= y);
    }

    // ── Операции над прямоугольниками ────────────────────────────────────────
    /// Пересечение двух прямоугольников. Если не пересекаются — isEmpty() == true
    DRect intersected(DRect r) pure nothrow {
        int x1 = x  > r.x  ? x  : r.x;
        int y1 = y  > r.y  ? y  : r.y;
        int x2 = (x + w) < (r.x + r.w) ? (x + w) : (r.x + r.w);
        int y2 = (y + h) < (r.y + r.h) ? (y + h) : (r.y + r.h);
        return DRect(x1, y1, x2 - x1, y2 - y1);
    }
    /// Объединение: минимальный прямоугольник, содержащий оба
    DRect united(DRect r) pure nothrow {
        int x1 = x  < r.x  ? x  : r.x;
        int y1 = y  < r.y  ? y  : r.y;
        int x2 = (x + w) > (r.x + r.w) ? (x + w) : (r.x + r.w);
        int y2 = (y + h) > (r.y + r.h) ? (y + h) : (r.y + r.h);
        return DRect(x1, y1, x2 - x1, y2 - y1);
    }
    /// Сдвиг на (dx, dy) — возвращает новый DRect
    DRect translated(int dx, int dy) pure nothrow { return DRect(x + dx, y + dy, w, h); }
    /// Корректировка краёв: dx1/dy1 добавляются к левому-верхнему, dx2/dy2 — к правому-нижнему
    DRect adjusted(int dx1, int dy1, int dx2, int dy2) pure nothrow {
        return DRect(x + dx1, y + dy1, w + dx2 - dx1, h + dy2 - dy1);
    }
    /// Добавить поля (margins) вокруг прямоугольника
    DRect marginsAdded(int ml, int mt, int mr, int mb) pure nothrow {
        return DRect(x - ml, y - mt, w + ml + mr, h + mt + mb);
    }

    // ── Отладка ──────────────────────────────────────────────────────────────
    string toString() const {
        import std.format : format;
        return format("DRect(%d,%d %dx%d)", x, y, w, h);
    }
}

// ── DPoint ─────────────────────────────────────────────────────────────────
// Точка на плоскости. Соответствует QPoint из Qt.
struct DPoint {
    int x, y;

    // ── Состояние ────────────────────────────────────────────────────────────
    /// Нулевая точка (0, 0)
    bool isNull() pure nothrow { return x == 0 && y == 0; }
    /// «Манхэттенская» длина: |x| + |y| — быстрое расстояние без sqrt
    int manhattanLength() pure nothrow {
        int ax = x < 0 ? -x : x;
        int ay = y < 0 ? -y : y;
        return ax + ay;
    }

    // ── Операции ─────────────────────────────────────────────────────────────
    /// Сдвиг точки на (dx, dy)
    DPoint translated(int dx, int dy) pure nothrow { return DPoint(x + dx, y + dy); }
    /// Сложение двух точек (как вектор)
    DPoint opBinary(string op)(DPoint p) pure nothrow if (op == "+") { return DPoint(x + p.x, y + p.y); }
    /// Вычитание двух точек
    DPoint opBinary(string op)(DPoint p) pure nothrow if (op == "-") { return DPoint(x - p.x, y - p.y); }
    /// Унарный минус — отражение относительно начала координат
    DPoint opUnary(string op)() pure nothrow if (op == "-") { return DPoint(-x, -y); }

    // ── Отладка ──────────────────────────────────────────────────────────────
    string toString() const {
        import std.format : format;
        return format("DPoint(%d,%d)", x, y);
    }
}

// ── DSize ──────────────────────────────────────────────────────────────────
// Размер (ширина × высота). Соответствует QSize из Qt.
struct DSize {
    int w, h;

    // ── Синонимы ─────────────────────────────────────────────────────────────
    @property int width()  pure nothrow { return w; }
    @property int height() pure nothrow { return h; }

    // ── Состояние ────────────────────────────────────────────────────────────
    /// Пустой: w <= 0 или h <= 0
    bool isEmpty() pure nothrow { return w <= 0 || h <= 0; }
    /// Нулевой: w == 0 и h == 0
    bool isNull()  pure nothrow { return w == 0 && h == 0; }
    /// Валидный: w >= 0 и h >= 0
    bool isValid() pure nothrow { return w >= 0 && h >= 0; }

    // ── Операции ─────────────────────────────────────────────────────────────
    /// Максимум по каждому измерению (наименьший размер, вмещающий оба)
    DSize expandedTo(DSize s) pure nothrow { return DSize(w > s.w ? w : s.w, h > s.h ? h : s.h); }
    /// Минимум по каждому измерению (наибольший размер, вмещающийся в оба)
    DSize boundedTo(DSize s)  pure nothrow { return DSize(w < s.w ? w : s.w, h < s.h ? h : s.h); }
    /// Поворот на 90°: ширина и высота меняются местами
    DSize transposed() pure nothrow { return DSize(h, w); }
    /// Масштабирование: просто задать новые значения (без сохранения пропорций)
    DSize scaled(int sw, int sh) pure nothrow { return DSize(sw, sh); }
    /// Масштабирование с сохранением пропорций (вписать в sw×sh)
    DSize scaledKeepAspect(int sw, int sh) pure nothrow {
        if (w == 0 || h == 0) return DSize(sw, sh);
        double rw = cast(double)sw / w;
        double rh = cast(double)sh / h;
        double r  = rw < rh ? rw : rh;
        return DSize(cast(int)(w * r), cast(int)(h * r));
    }
    /// Сложение размеров
    DSize opBinary(string op)(DSize s) pure nothrow if (op == "+") { return DSize(w + s.w, h + s.h); }
    /// Вычитание размеров
    DSize opBinary(string op)(DSize s) pure nothrow if (op == "-") { return DSize(w - s.w, h - s.h); }

    // ── Отладка ──────────────────────────────────────────────────────────────
    string toString() const {
        import std.format : format;
        return format("DSize(%dx%d)", w, h);
    }
}

// ═══════════════════════════════════════════════════════════════════════════
// СЕКЦИЯ 2.5: EventInfo-структуры для Full-event-callbacks (id 19..25)
//
// Используются расширенным API on*Full в QWidget/QPlainTextEdit/QTextEdit:
//   onWheelFull            (19) — WheelEventInfo
//   onMousePressFull       (20) — MouseEventInfo
//   onMouseReleaseFull     (21) — MouseEventInfo
//   onMouseMoveFull        (22) — MouseEventInfo
//   onMouseDoubleClickFull (23) — MouseEventInfo
//   onKeyPressFull         (24) — KeyEventInfo
//   onKeyReleaseFull       (25) — KeyEventInfo
//
// Сигнатура callback'а:
//   extern(C) int cb(void* dthis, EventInfo* info)
//   return: 1 = обработано (Qt не вызывает default), 0 = passthrough.
//
// Порядок и размеры полей ДОЛЖНЫ совпадать с C++-структурами в eslot.h.
// ═══════════════════════════════════════════════════════════════════════════

/// Полная информация о QWheelEvent для onWheelFull.
extern(C) struct WheelEventInfo {
    int dx, dy;             // angleDelta() — обычно ±120 за щелчок мыши
    int pdx, pdy;           // pixelDelta() — для тачпада (high-precision scroll)
    int x, y;               // позиция в виджете (pos)
    int globalX, globalY;   // позиция на экране (globalPos)
    int modifiers;          // Qt::KeyboardModifiers (Shift/Ctrl/Alt/Meta)
    int buttons;            // Qt::MouseButtons — какие кнопки зажаты
    int phase;              // Qt::ScrollPhase (NoScrollPhase/Begin/Update/End)
    int source;             // Qt::MouseEventSource (Mouse/Synthesized*)
    int inverted;           // 0/1 — natural-scrolling
}

/// Полная информация о QMouseEvent для onMouse*Full.
extern(C) struct MouseEventInfo {
    int x, y;               // позиция в виджете (pos)
    int globalX, globalY;   // позиция на экране (globalPos)
    int button;             // Qt::MouseButton — кнопка-источник event'а (0 для Move)
    int buttons;            // Qt::MouseButtons — все зажатые кнопки
    int modifiers;          // Qt::KeyboardModifiers
}

/// Полная информация о QKeyEvent для onKey*Full.
/// `text` — указатель на QString с введённым символом (Unicode);
/// читать через `QString.fromQString(info.text)`. D-сторона НЕ освобождает.
extern(C) struct KeyEventInfo {
    int  key;               // Qt::Key
    int  modifiers;         // Qt::KeyboardModifiers
    int  isAutoRepeat;      // 0/1 — повторное нажатие (зажата клавиша)
    int  count;             // raw-events свёрнутых в один (autorepeat)
    int  nativeScanCode;    // physical scan code (OS-specific, обычно не нужен)
    void* text;             // QString* — Unicode-символ (read-only, owned by Qt)
}

// ═══════════════════════════════════════════════════════════════════════════
// СЕКЦИЯ 3: Блок для вставки в LoadQt()
//
// Вставить внутрь LoadQt() в qte56_loader.d или вызвать как отдельную функцию:
//   loadQCore();
// ═══════════════════════════════════════════════════════════════════════════

static this() { registerModule("QCore", "qte56_qcore.dll", &loadQCore); }

void loadQCore() {
    // QPointer lifecycle
    mixin(generateFunQt( 1, "qteQPointer_new",    "QCore"));
    mixin(generateFunQt( 2, "qteQPointer_delete",  "QCore"));
    mixin(generateFunQt( 3, "qteQPointer_isNull",  "QCore"));
    // eSlot
    mixin(generateFunQt(10, "qteConnect",           "QCore"));
    mixin(generateFunQt(11, "qteESlot_create",      "QCore"));
    mixin(generateFunQt(12, "qteESlot_set",         "QCore"));
    // QString
    mixin(generateFunQt(20, "qteQString_fromWStr",  "QCore"));
    mixin(generateFunQt(21, "qteQString_toWStr",    "QCore"));
    mixin(generateFunQt(22, "qteQString_free",      "QCore"));
    // Value types
    mixin(generateFunQt(30, "qteQRect_pack",        "QCore"));
    mixin(generateFunQt(31, "qteQRect_unpack",      "QCore"));
    mixin(generateFunQt(32, "qteQRect_free",        "QCore"));
    mixin(generateFunQt(33, "qteQPoint_pack",       "QCore"));
    mixin(generateFunQt(34, "qteQPoint_unpack",     "QCore"));
    mixin(generateFunQt(35, "qteQPoint_free",       "QCore"));
    mixin(generateFunQt(36, "qteQSize_pack",        "QCore"));
    mixin(generateFunQt(37, "qteQSize_unpack",      "QCore"));
    mixin(generateFunQt(38, "qteQSize_free",        "QCore"));
    // QApplication
    mixin(generateFunQt(50, "qteQApplication_create",       "QCore"));
    mixin(generateFunQt(51, "qteQApplication_exec",         "QCore"));
    mixin(generateFunQt(52, "qteQApplication_quit",         "QCore"));
    mixin(generateFunQt(53, "qteQApplication_processEvents","QCore"));
    mixin(generateFunQt(54, "qteQApplication_appName",      "QCore"));
    mixin(generateFunQt(55, "qteQApplication_setAppName",   "QCore"));
    // QApplication extended (56-71)
    mixin(generateFunQt(56, "qteQApplication_setStyleSheet",        "QCore"));
    mixin(generateFunQt(57, "qteQApplication_styleSheet",           "QCore"));
    mixin(generateFunQt(58, "qteQApplication_setStyle",             "QCore"));
    mixin(generateFunQt(59, "qteQApplication_styleName",            "QCore"));
    mixin(generateFunQt(60, "qteQApplication_setWindowIcon",        "QCore"));
    mixin(generateFunQt(61, "qteQApplication_setOverrideCursor",    "QCore"));
    mixin(generateFunQt(62, "qteQApplication_restoreOverrideCursor","QCore"));
    mixin(generateFunQt(63, "qteQApplication_appDirPath",           "QCore"));
    mixin(generateFunQt(64, "qteQApplication_appVersion",           "QCore"));
    mixin(generateFunQt(65, "qteQApplication_setAppVersion",        "QCore"));
    mixin(generateFunQt(66, "qteQApplication_orgName",              "QCore"));
    mixin(generateFunQt(67, "qteQApplication_setOrgName",           "QCore"));
    mixin(generateFunQt(68, "qteQApplication_beep",                 "QCore"));
    mixin(generateFunQt(69, "qteQApplication_closeAllWindows",      "QCore"));
    mixin(generateFunQt(70, "qteQApplication_activeWindow",         "QCore"));
    mixin(generateFunQt(71, "qteQApplication_setFont",              "QCore"));
    mixin(generateFunQt(72, "qteQApplication_aboutQt",              "QCore"));
    mixin(generateFunQt(73, "qteQApplication_font",                 "QCore"));
    mixin(generateFunQt(74, "qteQApplication_orgDomain",            "QCore"));
    mixin(generateFunQt(75, "qteQApplication_setOrgDomain",         "QCore"));
    mixin(generateFunQt(76, "qteQApplication_appFilePath",          "QCore"));
    mixin(generateFunQt(77, "qteQApplication_keyboardModifiers",    "QCore"));
    // QCoreApplication (78-80) — консольная версия без GUI-зависимостей
    mixin(generateFunQt(78, "qteQCoreApplication_create", "QCore"));
    mixin(generateFunQt(79, "qteQCoreApplication_exec",   "QCore"));
    mixin(generateFunQt(80, "qteQCoreApplication_quit",   "QCore"));
}

// ═══════════════════════════════════════════════════════════════════════════
// СЕКЦИЯ 4: Вспомогательные функции для QString
// ═══════════════════════════════════════════════════════════════════════════

/// Конвертирует D string → heap-allocated Qt QString*
/// Освободить через qteQString_free или использовать строго временно.
/// NB: cast(int) for length is intentional — Qt uses int for string sizes (max 2GB).
void* toQString(string s) {
    import std.utf : toUTF16;
    wstring ws = s.toUTF16;
    return (cast(t_qp__qp_i)pFunQt[20])(cast(void*)ws.ptr, cast(int)ws.length);
}

/// Конвертирует массив D-строк в один void* (QString*) с разделителем \x01.
/// C++-сторона разбивает обратно через split(QChar(1)) → QStringList.
/// Пустой массив → null (C++ должен обработать null как пустой QStringList).
/// Освободить результат через pFunQt[22] (qteQString_free).
void* toQStringList(string[] items) {
    if (items.length == 0) return null;
    import std.array : join;
    return toQString(items.join("\x01"));
}

/// Освободить QString*, созданный через toQStringList.
/// Идентично pFunQt[22] — псевдоним для читаемости кода.
void freeQStringList(void* p) {
    if (p !is null) (cast(t_v__qp)pFunQt[22])(p);
}

/// Конвертирует Qt QString* → D string
/// Не освобождает qs — вызывающий код должен сам освободить через pFunQt[22].
string fromQString(void* qs) {
    if (qs is null) return "";
    // Быстрый путь: большинство строк короткие (заголовки, метки и т.д.)
    wchar[4096] small;
    int len = (cast(t_i__qp_qp_i)pFunQt[21])(qs, cast(void*)small.ptr, cast(int)small.length);
    if (len <= 0) return "";
    import std.utf : toUTF8;
    if (len < 4095) return small[0 .. len].toUTF8;
    // Строка была обрезана (>= 4095 символов) — выделяем динамически.
    // Удваиваем буфер пока не влезет (для текстов редактора, больших файлов).
    int cap = 65536;
    while (true) {
        auto big = new wchar[cap];
        len = (cast(t_i__qp_qp_i)pFunQt[21])(qs, cast(void*)big.ptr, cast(int)big.length);
        if (len < cap - 1) return big[0 .. len].toUTF8;
        cap *= 2;
    }
}

/// Парсит строку "ptr1|ptr2|..." (hex, uintptr_t) → массив void*.
/// Освобождает qs автоматически. Используется с subWindowList(), selectedItems(), actions() и т.д.
void*[] ptrListFromQStr(void* qs) {
    if (qs is null) return [];
    string s = fromQString(qs);
    (cast(t_v__qp)pFunQt[22])(qs);
    if (s.length == 0) return [];
    import std.string : split;
    import std.conv : to;
    auto parts = s.split('|');
    auto result = new void*[parts.length];
    foreach (i, p; parts)
        result[i] = cast(void*)p.to!size_t(16);
    return result;
}

/// Парсит строку "n1|n2|..." → массив int[].
/// Освобождает qs автоматически. Используется с QSplitter::sizes() и т.д.
int[] intListFromQStr(void* qs) {
    if (qs is null) return [];
    string s = fromQString(qs);
    (cast(t_v__qp)pFunQt[22])(qs);
    if (s.length == 0) return [];
    import std.string : split;
    import std.conv : to;
    auto parts = s.split('|');
    auto result = new int[parts.length];
    foreach (i, p; parts)
        result[i] = p.to!int;
    return result;
}

/// Кодирует int[] → heap-allocated QString* "n1|n2|...".
/// Освободить через pFunQt[22] после использования.
void* intListToQStr(int[] arr) {
    import std.conv : to;
    if (arr.length == 0) return toQString("");
    string s = arr[0].to!string;
    foreach (n; arr[1..$]) s ~= "|" ~ n.to!string;
    return toQString(s);
}

// ═══════════════════════════════════════════════════════════════════════════
// СЕКЦИЯ 5: Класс QApplication
// ═══════════════════════════════════════════════════════════════════════════

/// Обёртка над Qt классом QApplication
@live class QApplication {
private:
    void* _wh;   // указатель на C++ QApplication объект

public:
    /// Создать QApplication. appName — имя приложения (необязательно).
    /// GC.addRoot защищает объект от финализации до явного вызова deleteApp().
    this(string appName = "") {
        if (appName.length > 0) {
            import std.utf : toUTF16z;
            auto ws = appName.toUTF16z;
            _wh = (cast(t_qp__qp)pFunQt[50])(cast(void*)ws);
        } else {
            _wh = (cast(t_qp__qp)pFunQt[50])(null);
        }
        import core.memory : GC;
        GC.addRoot(cast(void*)this);   // запрет GC-финализации до deleteApp()

        // Lifecycle: установить глобальный event filter для отслеживания parent
        if (pFunQt[24102] !is null) {
            (cast(t_v__qp)pFunQt[24102])(_wh);
        }
    }

    ~this() {
        // GC-финализация: только если deleteApp() не вызван.
        // pFunQt[] уже обнулён после UnloadQt — C++ cleanup пропускаем.
    }

    /// Явное завершение: снять GC-защиту + обнулить pFunQt[].
    /// После этого GC-финализаторы D-обёрток безопасно пропустят C++ вызовы.
    QApplication deleteApp() {
        import core.memory : GC;
        GC.removeRoot(cast(void*)this);
        _wh = null;
        // Обнулить все указатели — GC-финализаторы проверяют pFunQt[X] !is null
        // и пропустят удаление C++ объектов. OS освободит память при завершении.
        pFunQt[] = null;
        return this;
    }

    /// Запустить Qt event loop. Блокирует до QApplication::quit().
    /// Возвращает код завершения.
    int exec() {
        return cast(int)(cast(t_i__qp)pFunQt[51])(_wh);
    }

    /// Завершить event loop.
    QApplication quit() {
        (cast(t_v__qp)pFunQt[52])(_wh);
        return this;
    }

    /// Обработать накопившиеся события без блокировки.
    QApplication processEvents() {
        (cast(t_v__qp)pFunQt[53])(_wh);
        return this;
    }

    /// Получить имя приложения.
    string appName() {
        void* qs = (cast(t_qp__qp)pFunQt[54])(_wh);
        string s = fromQString(qs);
        (cast(t_v__qp)pFunQt[22])(qs);  // qteQString_free
        return s;
    }

    /// Установить имя приложения.
    QApplication setAppName(string name) {
        auto ws = toQString(name);
        (cast(t_v__qp_qp)pFunQt[55])(_wh, ws);
        (cast(t_v__qp)pFunQt[22])(ws);
        return this;
    }

    // ── Extended methods (56-71) ───────────────────────────────────────────

    /// Устанавливает глобальный CSS-стиль приложения.
    QApplication setStyleSheet(string css) {
        auto ws = toQString(css);
        (cast(t_v__qp_qp)pFunQt[56])(_wh, ws);
        (cast(t_v__qp)pFunQt[22])(ws);
        return this;
    }

    /// Возвращает текущий CSS-стиль приложения.
    string styleSheet() {
        void* qs = (cast(t_qp__qp)pFunQt[57])(_wh);
        string s = fromQString(qs);
        (cast(t_v__qp)pFunQt[22])(qs);
        return s;
    }

    /// Устанавливает стиль виджетов по имени ("Fusion", "Windows" и т.д.).
    QApplication setStyle(string name) {
        auto ws = toQString(name);
        (cast(t_v__qp_qp)pFunQt[58])(_wh, ws);
        (cast(t_v__qp)pFunQt[22])(ws);
        return this;
    }

    /// Возвращает имя текущего стиля виджетов.
    string styleName() {
        void* qs = (cast(t_qp__qp)pFunQt[59])(_wh);
        string s = fromQString(qs);
        (cast(t_v__qp)pFunQt[22])(qs);
        return s;
    }

    /// Устанавливает иконку приложения.
    QApplication setWindowIcon(void* iconPtr) {
        (cast(t_v__qp_qp)pFunQt[60])(_wh, iconPtr);
        return this;
    }

    /// Устанавливает override cursor по номеру Qt::CursorShape.
    QApplication setOverrideCursor(int shape) {
        (cast(t_v__qp_i)pFunQt[61])(_wh, shape);
        return this;
    }

    /// Восстанавливает cursor после setOverrideCursor.
    QApplication restoreOverrideCursor() {
        (cast(t_v__qp)pFunQt[62])(_wh);
        return this;
    }

    /// Возвращает путь к директории приложения.
    string applicationDirPath() {
        void* qs = (cast(t_qp__qp)pFunQt[63])(_wh);
        string s = fromQString(qs);
        (cast(t_v__qp)pFunQt[22])(qs);
        return s;
    }

    /// Возвращает версию приложения.
    string applicationVersion() {
        void* qs = (cast(t_qp__qp)pFunQt[64])(_wh);
        string s = fromQString(qs);
        (cast(t_v__qp)pFunQt[22])(qs);
        return s;
    }

    /// Устанавливает версию приложения.
    QApplication setApplicationVersion(string ver) {
        auto ws = toQString(ver);
        (cast(t_v__qp_qp)pFunQt[65])(_wh, ws);
        (cast(t_v__qp)pFunQt[22])(ws);
        return this;
    }

    /// Возвращает имя организации.
    string organizationName() {
        void* qs = (cast(t_qp__qp)pFunQt[66])(_wh);
        string s = fromQString(qs);
        (cast(t_v__qp)pFunQt[22])(qs);
        return s;
    }

    /// Устанавливает имя организации.
    QApplication setOrganizationName(string name) {
        auto ws = toQString(name);
        (cast(t_v__qp_qp)pFunQt[67])(_wh, ws);
        (cast(t_v__qp)pFunQt[22])(ws);
        return this;
    }

    /// Системный звуковой сигнал.
    QApplication beep() {
        (cast(t_v__qp)pFunQt[68])(_wh);
        return this;
    }

    /// Закрывает все окна верхнего уровня.
    QApplication closeAllWindows() {
        (cast(t_v__qp)pFunQt[69])(_wh);
        return this;
    }

    /// Возвращает указатель на активное окно (QWidget*), или null.
    void* activeWindow() {
        return (cast(t_qp__qp)pFunQt[70])(_wh);
    }

    /// Устанавливает шрифт приложения по умолчанию.
    QApplication setFont(void* fontPtr) {
        (cast(t_v__qp_qp)pFunQt[71])(_wh, fontPtr);
        return this;
    }

    /// Показывает стандартный диалог "About Qt".
    QApplication aboutQt() {
        (cast(t_v__qp)pFunQt[72])(_wh);
        return this;
    }

    /// Возвращает шрифт приложения по умолчанию (D-owned, dtor удалит).
    void* font() {
        return (cast(t_qp__qp)pFunQt[73])(_wh);
    }

    /// Возвращает домен организации (используется QSettings).
    string organizationDomain() {
        void* qs = (cast(t_qp__qp)pFunQt[74])(_wh);
        string s = fromQString(qs);
        (cast(t_v__qp)pFunQt[22])(qs);
        return s;
    }

    /// Устанавливает домен организации (reversed DNS, напр. "com.example").
    QApplication setOrganizationDomain(string domain) {
        auto ws = toQString(domain);
        (cast(t_v__qp_qp)pFunQt[75])(_wh, ws);
        (cast(t_v__qp)pFunQt[22])(ws);
        return this;
    }

    /// Полный путь к исполняемому файлу приложения.
    string applicationFilePath() {
        void* qs = (cast(t_qp__qp)pFunQt[76])(_wh);
        string s = fromQString(qs);
        (cast(t_v__qp)pFunQt[22])(qs);
        return s;
    }

    /// Получить сырой указатель (для передачи в другие Qt-функции)
    void* getWH() { return _wh; }

    // ── Static helpers ──────────────────────────────────────────────────────

    /// Текущее состояние модификаторов клавиатуры (битовая маска).
    /// Биты Qt::KeyboardModifier (см. KeyboardModifier ниже).
    /// Полезно в callback'ах event-handler'ов которые сами не получают modifiers.
    static int keyboardModifiers() {
        alias FN = extern(C) @nogc int function();
        return (cast(FN)pFunQt[77])();
    }
}

// ═══════════════════════════════════════════════════════════════════════════
// СЕКЦИЯ 5b: Класс QCoreApplication (консольная версия без GUI-зависимостей)
// ═══════════════════════════════════════════════════════════════════════════

/// Обёртка над Qt классом QCoreApplication.
/// Не требует platform plugins, работает в чистом консольном окружении.
@live class QCoreApplication {
private:
    void* _wh;   // указатель на C++ QCoreApplication объект

public:
    /// Создать QCoreApplication. appName — имя приложения (необязательно).
    this(string appName = "") {
        if (appName.length > 0) {
            import std.utf : toUTF16z;
            auto ws = appName.toUTF16z;
            _wh = (cast(t_qp__qp)pFunQt[78])(cast(void*)ws);
        } else {
            _wh = (cast(t_qp__qp)pFunQt[78])(null);
        }
        import core.memory : GC;
        GC.addRoot(cast(void*)this);
    }

    ~this() {
        // GC-финализация: только если deleteApp() не вызван.
    }

    /// Явное завершение: снять GC-защиту.
    QCoreApplication deleteApp() {
        import core.memory : GC;
        GC.removeRoot(cast(void*)this);
        _wh = null;
        // НЕ обнуляем pFunQt[] — другие объекты могут его использовать
        return this;
    }

    /// Указатель на C++ объект.
    void* getWH() { return _wh; }

    /// Запустить Qt event loop. Блокирует до quit().
    int exec() {
        return cast(int)(cast(t_i__qp)pFunQt[79])(_wh);
    }

    /// Завершить event loop.
    QCoreApplication quit() {
        (cast(t_v__qp)pFunQt[80])(_wh);
        return this;
    }

    /// Обработать накопившиеся события без блокировки.
    /// Статический метод — работает даже без созданного объекта.
    static void processEvents() {
        (cast(t_v__qp)pFunQt[53])(null);
    }
}

/// Битовые значения Qt::KeyboardModifier для использования с keyboardModifiers().
enum KeyboardModifier : int {
    Shift   = 0x02000000,
    Control = 0x04000000,
    Alt     = 0x08000000,
    Meta    = 0x10000000,
    Keypad  = 0x20000000,
}

// ═══════════════════════════════════════════════════════════════════════════
// СЕКЦИЯ 6: ESlot — D-обёртка над eSlot (Qt signal → D callback)
// ═══════════════════════════════════════════════════════════════════════════

/// Управляет жизненным циклом eSlot.
/// parent — Qt-объект-владелец: при его удалении Qt удалит eSlot автоматически.
/// D удаляет только QPointer-обёртку в деструкторе.
class ESlot {
private:
    void* _qptr;  // QPointer<eSlot>*
    void* _raw;   // eSlot*

public:
    this(void* parent = null) {
        _qptr = (cast(t_qp__i)pFunQt[1])(1);
        _raw  = (cast(t_qp__qp_qp)pFunQt[11])(_qptr, parent);
    }

    ~this() {
        if (_qptr !is null && pFunQt[2] !is null) {
            (cast(t_v__qp_i)pFunQt[2])(_qptr, 1);
            _qptr = null;
        }
    }

    /// Записать D callback. cb — указатель на функцию, dthis — D-объект, n — тег.
    ESlot set(void* cb, void* dthis = null, int n = 0) {
        (cast(t_v__qp_qp_qp_i)pFunQt[12])(_raw, cb, dthis, n);
        return this;
    }

    /// Сырой указатель eSlot* (для qteConnect).
    void* raw() { return _raw; }
}

/// Соединяет Qt-сигнал с ESlot.
/// signal — сигнатура сигнала без префикса, напр. "destroyed()"
/// invoke — имя invoke-метода с параметрами, напр. "invoke_v()" или "invoke_s(const QString&)"
void connectQt(void* sender, string signal, ESlot slot, string invoke) {
    import std.string : toStringz;
    string sig = "2" ~ signal;
    string slt = "1" ~ invoke;
    (cast(t_qobj_connect)pFunQt[10])(sender, sig.toStringz, slot.raw, slt.toStringz, 0);
}
