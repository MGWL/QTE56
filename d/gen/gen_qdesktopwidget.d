/**
 * gen_qdesktopwidget.d — D-обёртка для QDesktopWidget.
 *
 * DLL: qte56_desktop.dll  |  Блок индексов: 20149–20154 (6 функций)
 *
 * $(H3 Назначение)
 *
 * Статические запросы о подключённых мониторах: количество, геометрия,
 * рабочая область (без taskbar), определение номера монитора по точке
 * или виджету.
 *
 * Все методы статические — объект QDesktopWidget не создаётся.
 *
 * $(H3 Пример: центрировать окно)
 *
 * ---
 * import gen_qdesktopwidget;
 *
 * auto scr = QDesktopWidget.screenGeometry(QDesktopWidget.primaryScreen());
 * win.move(scr.x + (scr.w - 800) / 2,
 *          scr.y + (scr.h - 600) / 2);
 * ---
 *
 * $(H3 Пример: открыть на втором мониторе)
 *
 * ---
 * if (QDesktopWidget.screenCount() >= 2) {
 *     auto scr = QDesktopWidget.screenGeometry(1);
 *     win.move(scr.x + 100, scr.y + 100);
 * }
 * ---
 *
 * $(H3 Пример: максимизировать на рабочем столе без taskbar)
 *
 * ---
 * auto avail = QDesktopWidget.availableGeometry(0);
 * win.move(avail.x, avail.y);
 * win.resize(avail.w, avail.h);
 * ---
 *
 * See_Also: doc/qte56_d_reference.md §QDesktopWidget
 */
module gen_qdesktopwidget;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : t_i__qp;

// ── Alias типов (нестандартные, не в gen_qcore) ───────────────────────────────

/// int function() — screenCount, primaryScreen
mixin(generateAlias("i__"));

/// void function(int, int*, int*, int*, int*) — screenGeometry, availableGeometry
mixin(generateAlias("v__i_ip_ip_ip_ip"));

/// int function(int, int) — screenNumberAt(x, y)
mixin(generateAlias("i__i_i"));

// ── Загрузка функций ──────────────────────────────────────────────────────────

/**
 * Загружает все функции QDesktopWidget из qte56_desktop.dll.
 * Вызывается автоматически через registerModule при первом import.
 */
void loadQDesktopWidget() {
    mixin(generateFunQt(20149, "qteQDesktopWidget_screenCount",        "QDesktopWidget"));
    mixin(generateFunQt(20150, "qteQDesktopWidget_primaryScreen",      "QDesktopWidget"));
    mixin(generateFunQt(20151, "qteQDesktopWidget_screenGeometry",     "QDesktopWidget"));
    mixin(generateFunQt(20152, "qteQDesktopWidget_availableGeometry",  "QDesktopWidget"));
    mixin(generateFunQt(20153, "qteQDesktopWidget_screenNumberAt",     "QDesktopWidget"));
    mixin(generateFunQt(20154, "qteQDesktopWidget_screenNumberOf",     "QDesktopWidget"));
}

/// Авто-регистрация: вызывается при загрузке модуля.
static this() {
    registerModule("QDesktopWidget", "qte56_desktop.dll", &loadQDesktopWidget);
}

// ══════════════════════════════════════════════════════════════════════════════
// Вспомогательная структура: прямоугольник экрана
// ══════════════════════════════════════════════════════════════════════════════

/**
 * ScreenRect — геометрия монитора (позиция + размер в пикселях).
 *
 * Возвращается методами `screenGeometry` и `availableGeometry`.
 *
 * Поля `x` и `y` — глобальные координаты левого верхнего угла монитора.
 * На основном мониторе обычно (0, 0); на дополнительных могут быть
 * отрицательными или большими числами.
 */
struct ScreenRect {
    int x; /// Глобальная X-координата левого края
    int y; /// Глобальная Y-координата верхнего края
    int w; /// Ширина в пикселях
    int h; /// Высота в пикселях

    /// Центр монитора по горизонтали
    int centerX() const { return x + w / 2; }
    /// Центр монитора по вертикали
    int centerY() const { return y + h / 2; }

    /// Вычислить X для центрирования объекта шириной `objW`
    int centeredX(int objW) const { return x + (w - objW) / 2; }
    /// Вычислить Y для центрирования объекта высотой `objH`
    int centeredY(int objH) const { return y + (h - objH) / 2; }
}

// ══════════════════════════════════════════════════════════════════════════════
// Основной класс (все методы статические)
// ══════════════════════════════════════════════════════════════════════════════

/**
 * QDesktopWidget — статические запросы о мониторах.
 *
 * Все методы вызываются без создания объекта:
 * ---
 * int n = QDesktopWidget.screenCount();
 * auto r = QDesktopWidget.screenGeometry(0);
 * ---
 *
 * $(H3 Нумерация экранов)
 *
 * Экраны нумеруются от 0. Основной экран — `primaryScreen()`,
 * обычно 0. Индексы остальных произвольны.
 *
 * $(H3 Координатная система)
 *
 * `screenGeometry` возвращает координаты в глобальной системе:
 * основной монитор, как правило, начинается в (0,0);
 * второй слева — в отрицательных X; второй справа — в (width_primary, 0).
 */
@live class QDesktopWidget {
    // Объект не создаётся — только статические методы

    /**
     * Возвращает: число подключённых мониторов.
     */
    static int screenCount() {
        return (cast(t_i__)pFunQt[20149])();
    }

    /**
     * Возвращает: индекс основного монитора (обычно 0).
     */
    static int primaryScreen() {
        return (cast(t_i__)pFunQt[20150])();
    }

    /**
     * Полная геометрия экрана, включая taskbar и dock.
     *
     * Params:
     *   screen = индекс монитора (0 .. screenCount()-1).
     *            По умолчанию — основной монитор.
     *
     * Returns: `ScreenRect` с полными координатами и размерами.
     *
     * Examples:
     * ---
     * auto r = QDesktopWidget.screenGeometry(0);
     * writeln(r.w, "x", r.h);  // например "1920x1080"
     * ---
     */
    static ScreenRect screenGeometry(int screen = -1) {
        if (screen < 0) screen = primaryScreen();
        ScreenRect r;
        (cast(t_v__i_ip_ip_ip_ip)pFunQt[20151])(screen, &r.x, &r.y, &r.w, &r.h);
        return r;
    }

    /**
     * Рабочая область экрана — без taskbar, dock, системных панелей.
     *
     * Params:
     *   screen = индекс монитора. По умолчанию — основной.
     *
     * Returns: `ScreenRect` только рабочей области.
     *
     * Examples:
     * ---
     * // Развернуть окно на весь рабочий стол (без перекрытия taskbar)
     * auto avail = QDesktopWidget.availableGeometry();
     * win.move(avail.x, avail.y);
     * win.resize(avail.w, avail.h);
     * ---
     */
    static ScreenRect availableGeometry(int screen = -1) {
        if (screen < 0) screen = primaryScreen();
        ScreenRect r;
        (cast(t_v__i_ip_ip_ip_ip)pFunQt[20152])(screen, &r.x, &r.y, &r.w, &r.h);
        return r;
    }

    /**
     * Определяет индекс монитора по глобальным координатам точки.
     *
     * Params:
     *   x = глобальная X-координата.
     *   y = глобальная Y-координата.
     *
     * Returns: индекс монитора, содержащего точку (x, y).
     *          Если точка вне всех мониторов — ближайший.
     */
    static int screenNumberAt(int x, int y) {
        return (cast(t_i__i_i)pFunQt[20153])(x, y);
    }

    /**
     * Определяет индекс монитора, на котором находится виджет.
     *
     * Params:
     *   widgetWH = указатель на C++ QWidget (из `widget.getWH()`).
     *
     * Returns: индекс монитора, содержащего центр виджета.
     */
    static int screenNumberOf(void* widgetWH) {
        return (cast(t_i__qp)pFunQt[20154])(widgetWH);
    }

    /**
     * Вычислить позицию для центрирования окна на указанном экране.
     *
     * Params:
     *   winW   = ширина окна.
     *   winH   = высота окна.
     *   screen = индекс монитора. По умолчанию — основной.
     *
     * Returns: кортеж `[x, y]` для вызова `win.move(x, y)`.
     *
     * Examples:
     * ---
     * auto pos = QDesktopWidget.centeredPos(800, 600);
     * win.move(pos[0], pos[1]);
     * ---
     */
    static int[2] centeredPos(int winW, int winH, int screen = -1) {
        auto r = screenGeometry(screen);
        return [r.centeredX(winW), r.centeredY(winH)];
    }
}
