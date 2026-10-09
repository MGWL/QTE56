#pragma once
#include <QObject>
#include <QPoint>

// ─────────────────────────────────────────────────────────────────────────────
// Event-info структуры для расширенных event-callbacks (id 19..25).
//
// Старый API (cb_01..cb_18) передаёт разобранные параметры (например
// (dt,x,y,btn) для mouse). Новый API (cb_19..cb_25) передаёт указатель на
// info-структуру со ВСЕМИ полями события + return-кодом consumed.
//
// Сигнатура нового callback'а:
//   int cb(void* dthis, EventInfo* info)
//   return: 1 = обработано (Qt не вызывает default), 0 = passthrough.
//
// Если установлены ОБА callback'а (старый и Full), приоритет у Full.
// Если Full вернул 0 — событие проходит к default Qt-handler'у.
// ─────────────────────────────────────────────────────────────────────────────

extern "C" {

struct WheelEventInfo {
    int dx, dy;             // angleDelta() — обычно ±120 за щелчок мыши
    int pdx, pdy;           // pixelDelta() — для тачпада с inertia
    int x, y;               // position() — координаты в виджете
    int globalX, globalY;   // globalPosition() — координаты на экране
    int modifiers;          // Qt::KeyboardModifiers (Shift/Ctrl/Alt/Meta)
    int buttons;            // Qt::MouseButtons — какие кнопки зажаты
    int phase;              // Qt::ScrollPhase (NoScrollPhase / Begin / Update / End)
    int source;             // Qt::MouseEventSource (Mouse / Synthesized*)
    int inverted;           // 0/1 — natural-scrolling
};

struct MouseEventInfo {
    int x, y;               // position в виджете
    int globalX, globalY;   // на экране
    int button;             // Qt::MouseButton — кнопка вызвавшая event (None для Move)
    int buttons;            // Qt::MouseButtons — все зажатые кнопки
    int modifiers;          // Qt::KeyboardModifiers
};

struct KeyEventInfo {
    int  key;               // Qt::Key
    int  modifiers;         // Qt::KeyboardModifiers
    int  isAutoRepeat;      // 0/1 — повторное нажатие (зажата клавиша)
    int  count;             // raw-events свёрнутых в один (autorepeat)
    int  nativeScanCode;    // physical scan code (OS-specific, обычно не нужен)
    void* text;             // QString* — введённый Unicode-символ
                            //   (доступен через D-обёртку fromQString).
                            //   D НЕ должна освобождать — Qt владеет.
};

} // extern "C"


// ─────────────────────────────────────────────────────────────────────────────
// eSlot — универсальный Qt-объект-посредник: Qt signal → D callback.
//
// Жизненный цикл:
//   1. D создаёт QPointer<eSlot> через qteQPointer_new(1)
//   2. D создаёт eSlot через qteESlot_create(qptr, parent_widget)
//      parent = Qt-виджет, значит Qt удалит eSlot вместе с виджетом.
//   3. D записывает callback через qteESlot_set(slot, cb, dthis, n)
//   4. D соединяет сигнал через qteConnect(sender, "2signal()", slot, "1invoke_v()", 0)
//   5. При срабатывании сигнала Qt вызывает нужный invoke_*, тот вызывает D-функцию.
//   6. При удалении виджета Qt удаляет eSlot; QPointer обнуляется автоматически.
//   7. D в деструкторе удаляет только QPointer-обёртку (qteQPointer_delete(qptr, 1)).
//
// Сигнатуры D callback:
//   invoke_v()              → void cb(void* dthis, int n)
//   invoke_b(bool)          → void cb(void* dthis, int n, int val)
//   invoke_i(int)           → void cb(void* dthis, int n, int val)
//   invoke_ii(int,int)      → void cb(void* dthis, int n, int a, int b)
//   invoke_d(double)        → void cb(void* dthis, int n, double val)
//   invoke_s(QString)       → void cb(void* dthis, int n, void* qstring_ptr)
//   invoke_p(QPoint)        → void cb(void* dthis, int n, int x, int y)
// ─────────────────────────────────────────────────────────────────────────────

class eSlot : public QObject {
    Q_OBJECT
public:
    void* cb    = nullptr;   // адрес D callback функции
    void* dthis = nullptr;   // адрес D объекта (первый аргумент callback)
    int   n     = 0;         // тег сигнала (второй аргумент callback)

    explicit eSlot(QObject* parent = nullptr) : QObject(parent) {}

public slots:
    void invoke_v()
        { if (cb) ((void(*)(void*,int))cb)(dthis, n); }

    void invoke_b(bool v)
        { if (cb) ((void(*)(void*,int,int))cb)(dthis, n, (int)v); }

    void invoke_i(int v)
        { if (cb) ((void(*)(void*,int,int))cb)(dthis, n, v); }

    void invoke_ii(int a, int b)
        { if (cb) ((void(*)(void*,int,int,int))cb)(dthis, n, a, b); }

    void invoke_d(double v)
        { if (cb) ((void(*)(void*,int,double))cb)(dthis, n, v); }

    void invoke_s(const QString& s)
        { if (cb) ((void(*)(void*,int,void*))cb)(dthis, n, (void*)&s); }

    void invoke_p(const QPoint& p)
        { if (cb) ((void(*)(void*,int,int,int))cb)(dthis, n, p.x(), p.y()); }

    void invoke_qp(void* ptr)
        { if (cb) ((void(*)(void*,int,void*))cb)(dthis, n, ptr); }
};
