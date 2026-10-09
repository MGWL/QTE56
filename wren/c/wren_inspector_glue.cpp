#include "wren_inspector_glue.h"
extern "C" {
#include "wren.h"
}

#include <QApplication>
#include <QWidget>
#include <QObject>
#include <QMetaObject>
#include <QMetaProperty>
#include <QMetaMethod>
#include <QVariant>
#include <QObjectList>
#include <QPlainTextEdit>
#include <QString>
#include <QVector>
#include <QMap>
#include <cstring>

// ─── Global panel widgets ─────────────────────────────────────────────────────

static void* g_monitorWidget  = nullptr;
static void* g_consoleWidget  = nullptr;

WINSP_API void winsp_setMonitorWidget(void* plainTextEdit) {
    g_monitorWidget = plainTextEdit;
}
WINSP_API void winsp_setConsoleWidget(void* plainTextEdit) {
    g_consoleWidget = plainTextEdit;
}

// ─── Check counters ───────────────────────────────────────────────────────────

static int g_check_passed = 0;
static int g_check_failed = 0;

// ─── HTML append helpers ──────────────────────────────────────────────────────

static void appendToWidget(void* widget, const QString& html) {
    if (!widget) return;
    ((QPlainTextEdit*)widget)->appendHtml(html);
}

// Build a colored HTML line: <span style="color:COLOR">PREFIX msg</span>
static QString colorLine(const char* color, const char* prefix, const QString& msg) {
    QString escaped = msg.toHtmlEscaped();
    QString line = QString("<span style=\"color:%1\">").arg(QString::fromUtf8(color));
    if (prefix && prefix[0] != '\0') {
        line += QString::fromUtf8(prefix);
        line += ' ';
    }
    line += escaped;
    line += "</span>";
    return line;
}

static void monitorAppend(const char* color, const char* prefix, const QString& msg) {
    appendToWidget(g_monitorWidget, colorLine(color, prefix, msg));
}

static void consoleAppend(const char* color, const char* prefix, const QString& msg) {
    appendToWidget(g_consoleWidget, colorLine(color, prefix, msg));
}

// ─── Module source strings ────────────────────────────────────────────────────

static const char* INSPECTOR_MODULE_SRC = R"WS(
foreign class QtObj {
    construct fromPtr_(n) {}
    foreign name
    foreign className
    foreign address
    foreign isNull
    foreign parent_
    parent {
        if (parent_ == 0) return QtObj.fromPtr_(0)
        return QtObj.fromPtr_(parent_)
    }
    foreign childCount
    foreign childAt_(n)
    childAt(n) { QtObj.fromPtr_(childAt_(n)) }
    children {
        var r = []
        var i = 0
        while (i < childCount) {
            r.add(childAt(i))
            i = i + 1
        }
        return r
    }
    foreign property(key)
    foreign setProperty(key, val)
    foreign invoke(method)
    foreign dump_()
    dump { dump_() }
    foreign propertyNames_
    propertyNames {
        var s = propertyNames_
        if (s.count == 0) return []
        return s.split("\n")
    }
    foreign methods_
    methods {
        var s = methods_
        if (s.count == 0) return []
        return s.split("\n")
    }
    foreign signalList_
    signals {
        var s = signalList_
        if (s.count == 0) return []
        return s.split("\n")
    }
    foreign slotList_
    slots {
        var s = slotList_
        if (s.count == 0) return []
        return s.split("\n")
    }
    foreign hexDump_(size)
    hexDump(size) { hexDump_(size) }
    hexDump { hexDump_(128) }
    foreign hexDumpStr_(size)
    hexDumpStr(size) { hexDumpStr_(size) }
    hexDumpStr { hexDumpStr_(128) }
    // Разыменовать: прочитать указатель по адресу объекта → Num
    derefPtr { Inspector.readPtr_(address) }
    // Разыменовать и сразу получить QtObj
    deref { Inspector.deref(address) }
    toString { "%(className)(%(name))" }
}

class Inspector {
    foreign static find_(name)
    static find(name) { QtObj.fromPtr_(find_(name)) }
    static atAddress(n) { QtObj.fromPtr_(n) }
    foreign static readPtr_(addr)
    foreign static readU8_(addr)
    foreign static readU16_(addr)
    foreign static readU32_(addr)
    foreign static readI8_(addr)
    foreign static readI16_(addr)
    foreign static readI32_(addr)
    foreign static readI64_(addr)
    foreign static readU64_(addr)
    foreign static readF32_(addr)
    foreign static readF64_(addr)
    static readPtr(addr)  { readPtr_(addr)  }
    static readU8(addr)   { readU8_(addr)   }
    static readU16(addr)  { readU16_(addr)  }
    static readU32(addr)  { readU32_(addr)  }
    static readI8(addr)   { readI8_(addr)   }
    static readI16(addr)  { readI16_(addr)  }
    static readI32(addr)  { readI32_(addr)  }
    static readI64(addr)  { readI64_(addr)  }
    static readU64(addr)  { readU64_(addr)  }
    static readF32(addr)  { readF32_(addr)  }
    static readF64(addr)  { readF64_(addr)  }
    static deref(addr) { QtObj.fromPtr_(readPtr_(addr)) }
    foreign static findByClassCount_(cls)
    foreign static findByClassAt_(n)
    static findByClass(cls) {
        var count = findByClassCount_(cls)
        var r = []
        var i = 0
        while (i < count) {
            r.add(QtObj.fromPtr_(findByClassAt_(i)))
            i = i + 1
        }
        return r
    }
    foreign static hexDump_(addr, size)
    static hexDump(addr, size) { hexDump_(addr, size) }
    static hexDump(addr) { hexDump_(addr, 128) }
    // Named pointer registry
    foreign static namedPtr_(name)
    foreign static namedPtrNames_
    static namedPtr(name) { namedPtr_(name) }
    static namedQtObj(name) { QtObj.fromPtr_(namedPtr_(name)) }
    static pointerNames {
        var s = namedPtrNames_
        if (s.count == 0) return []
        return s.split("\n")
    }
    foreign static allWidgetCount_
    foreign static widgetAt_(n)
    static allWidgets {
        var r = []
        var i = 0
        while (i < allWidgetCount_) {
            r.add(QtObj.fromPtr_(widgetAt_(i)))
            i = i + 1
        }
        return r
    }
    foreign static topWidgetCount_
    foreign static topWidgetAt_(n)
    static topWidgets {
        var r = []
        var i = 0
        while (i < topWidgetCount_) {
            r.add(QtObj.fromPtr_(topWidgetAt_(i)))
            i = i + 1
        }
        return r
    }
}
)WS";

static const char* LOG_MODULE_SRC = R"WS(
class Log {
    foreign static print_(msg)
    foreign static info_(msg)
    foreign static ok_(msg)
    foreign static warn_(msg)
    foreign static error_(msg)
    foreign static val_(label, value)
    foreign static sep_(text)
    foreign static clear()
    static print(msg)        { print_("%(msg)") }
    static info(msg)         { info_("%(msg)") }
    static ok(msg)           { ok_("%(msg)") }
    static warn(msg)         { warn_("%(msg)") }
    static error(msg)        { error_("%(msg)") }
    static val(label, value) { val_("%(label)", "%(value)") }
    static sep(text)         { sep_("%(text)") }
}
)WS";

static const char* OUT_MODULE_SRC = R"WS(
class Out {
    foreign static print_(msg)
    foreign static info_(msg)
    foreign static ok_(msg)
    foreign static warn_(msg)
    foreign static error_(msg)
    foreign static val_(label, value)
    foreign static sep_(text)
    foreign static clear()
    static print(msg)        { print_("%(msg)") }
    static info(msg)         { info_("%(msg)") }
    static ok(msg)           { ok_("%(msg)") }
    static warn(msg)         { warn_("%(msg)") }
    static error(msg)        { error_("%(msg)") }
    static val(label, value) { val_("%(label)", "%(value)") }
    static sep(text)         { sep_("%(text)") }
}
)WS";

static const char* CHECK_MODULE_SRC = R"WS(
class Check {
    foreign static that_(cond, msg)
    foreign static equal_(a, b, msg)
    foreign static notNull_(val, msg)
    foreign static report()
    foreign static reset()
    foreign static passed
    foreign static failed
    static that(c, msg)       { that_(c, "%(msg)") }
    static equal(a, b, msg)   { equal_("%(a)", "%(b)", "%(msg)") }
    static notNull(v, msg)    { notNull_(v is Num ? v : (v != null ? 1 : 0), "%(msg)") }
    static range(v, lo, hi, msg) { that_(v >= lo && v <= hi, "%(msg)") }
    static contains(s, sub, msg) { that_("%(s)".indexOf("%(sub)") != -1, "%(msg)") }
}
)WS";

// ─── Widget cache for allWidgets / topWidgets ─────────────────────────────────

static QVector<QWidget*> g_allWidgetsCache;
static QVector<QWidget*> g_topWidgetsCache;
static QVector<QWidget*> g_findByClassCache;

// ─── Named pointer registry ───────────────────────────────────────────────────

static QMap<QString, void*> g_namedPointers;

WINSP_API void winsp_registerPointer(const char* name, void* ptr) {
    g_namedPointers.insert(QString::fromUtf8(name), ptr);
}
WINSP_API void winsp_unregisterPointer(const char* name) {
    g_namedPointers.remove(QString::fromUtf8(name));
}
WINSP_API void winsp_clearPointers() {
    g_namedPointers.clear();
}

static void refreshWidgetCaches() {
    g_allWidgetsCache.clear();
    g_topWidgetsCache.clear();
    QWidgetList all = QApplication::allWidgets();
    for (QWidget* w : all) {
        g_allWidgetsCache.append(w);
    }
    QWidgetList top = QApplication::topLevelWidgets();
    for (QWidget* w : top) {
        g_topWidgetsCache.append(w);
    }
}

// ─── QtObj foreign methods ────────────────────────────────────────────────────

// construct fromPtr_(n) — allocate sizeof(void*) bytes, store pointer
static void wfn_qtobj_new(WrenVM* vm) {
    void** data = (void**)wrenSetSlotNewForeign(vm, 0, 0, sizeof(void*));
    double n = wrenGetSlotDouble(vm, 1);
    *data = (void*)(uintptr_t)n;
}

static void wfn_qtobj_finalize(void* /*data*/) {
    // QObject* is owned by Qt — do not delete here
}

// Helper: get QObject* from slot 0 foreign data
static QObject* qtobj_get(WrenVM* vm) {
    void** data = (void**)wrenGetSlotForeign(vm, 0);
    return (QObject*)*data;
}

static void wfn_qtobj_name(WrenVM* vm) {
    QObject* obj = qtobj_get(vm);
    if (!obj) { wrenSetSlotString(vm, 0, ""); return; }
    QByteArray ba = obj->objectName().toUtf8();
    wrenSetSlotString(vm, 0, ba.constData());
}

static void wfn_qtobj_className(WrenVM* vm) {
    QObject* obj = qtobj_get(vm);
    if (!obj) { wrenSetSlotString(vm, 0, ""); return; }
    wrenSetSlotString(vm, 0, obj->metaObject()->className());
}

static void wfn_qtobj_address(WrenVM* vm) {
    QObject* obj = qtobj_get(vm);
    wrenSetSlotDouble(vm, 0, (double)(uintptr_t)obj);
}

static void wfn_qtobj_isNull(WrenVM* vm) {
    QObject* obj = qtobj_get(vm);
    wrenSetSlotBool(vm, 0, obj == nullptr);
}

static void wfn_qtobj_parent_(WrenVM* vm) {
    QObject* obj = qtobj_get(vm);
    if (!obj) { wrenSetSlotDouble(vm, 0, 0.0); return; }
    QObject* p = obj->parent();
    wrenSetSlotDouble(vm, 0, (double)(uintptr_t)p);
}

static void wfn_qtobj_childCount(WrenVM* vm) {
    QObject* obj = qtobj_get(vm);
    if (!obj) { wrenSetSlotDouble(vm, 0, 0.0); return; }
    wrenSetSlotDouble(vm, 0, (double)obj->children().size());
}

static void wfn_qtobj_childAt_(WrenVM* vm) {
    QObject* obj = qtobj_get(vm);
    if (!obj) { wrenSetSlotDouble(vm, 0, 0.0); return; }
    int idx = (int)wrenGetSlotDouble(vm, 1);
    const QObjectList& kids = obj->children();
    if (idx < 0 || idx >= kids.size()) {
        wrenSetSlotDouble(vm, 0, 0.0);
        return;
    }
    wrenSetSlotDouble(vm, 0, (double)(uintptr_t)kids.at(idx));
}

static void wfn_qtobj_property(WrenVM* vm) {
    QObject* obj = qtobj_get(vm);
    if (!obj) { wrenSetSlotString(vm, 0, ""); return; }
    const char* key = wrenGetSlotString(vm, 1);
    QByteArray val = obj->property(key).toString().toUtf8();
    wrenSetSlotString(vm, 0, val.constData());
}

static void wfn_qtobj_setProperty(WrenVM* vm) {
    QObject* obj = qtobj_get(vm);
    if (!obj) { wrenSetSlotBool(vm, 0, false); return; }
    const char* key = wrenGetSlotString(vm, 1);
    const char* val = wrenGetSlotString(vm, 2);
    bool ok = obj->setProperty(key, QVariant(QString::fromUtf8(val)));
    wrenSetSlotBool(vm, 0, ok);
}

static void wfn_qtobj_invoke(WrenVM* vm) {
    QObject* obj = qtobj_get(vm);
    if (!obj) { wrenSetSlotBool(vm, 0, false); return; }
    const char* method = wrenGetSlotString(vm, 1);
    QByteArray m(method);
    bool ok = QMetaObject::invokeMethod(obj, m.constData(), Qt::DirectConnection);
    wrenSetSlotBool(vm, 0, ok);
}

static void wfn_qtobj_dump_(WrenVM* vm) {
    QObject* obj = qtobj_get(vm);
    if (!obj) {
        consoleAppend("#FF5555", "", "dump: null object");
        return;
    }
    const QMetaObject* meta = obj->metaObject();
    // Header
    QString header = QString("=== %1(%2) @ 0x%3 ===")
        .arg(meta->className())
        .arg(obj->objectName().isEmpty() ? QString("") : obj->objectName())
        .arg(QString::number((uintptr_t)obj, 16));
    appendToWidget(g_consoleWidget,
        QString("<span style=\"color:#AAAAFF\">%1</span>").arg(header.toHtmlEscaped()));
    // Qt meta-properties
    for (int i = 0; i < meta->propertyCount(); i++) {
        QMetaProperty prop = meta->property(i);
        QString val  = obj->property(prop.name()).toString();
        QString line = QString("  %1: %2")
            .arg(QString::fromUtf8(prop.name()))
            .arg(val);
        consoleAppend("#4488CC", "", line);
    }
    // Parent
    QObject* p = obj->parent();
    if (p) {
        QString pline = QString("  parent: %1(%2) @ 0x%3")
            .arg(p->metaObject()->className())
            .arg(p->objectName())
            .arg(QString::number((uintptr_t)p, 16));
        consoleAppend("#888888", "", pline);
    }
    // Children summary
    int nc = obj->children().size();
    if (nc > 0) {
        consoleAppend("#888888", "", QString("  children: %1").arg(nc));
    }
}

static void wfn_qtobj_methods_(WrenVM* vm) {
    QObject* obj = qtobj_get(vm);
    if (!obj) { wrenSetSlotString(vm, 0, ""); return; }
    const QMetaObject* meta = obj->metaObject();
    QStringList list;
    for (int i = 0; i < meta->methodCount(); i++)
        list << QString::fromUtf8(meta->method(i).methodSignature());
    wrenSetSlotString(vm, 0, list.join("\n").toUtf8().constData());
}

static void wfn_qtobj_signalList_(WrenVM* vm) {
    QObject* obj = qtobj_get(vm);
    if (!obj) { wrenSetSlotString(vm, 0, ""); return; }
    const QMetaObject* meta = obj->metaObject();
    QStringList list;
    for (int i = 0; i < meta->methodCount(); i++) {
        QMetaMethod m = meta->method(i);
        if (m.methodType() == QMetaMethod::Signal)
            list << QString::fromUtf8(m.methodSignature());
    }
    wrenSetSlotString(vm, 0, list.join("\n").toUtf8().constData());
}

static void wfn_qtobj_slotList_(WrenVM* vm) {
    QObject* obj = qtobj_get(vm);
    if (!obj) { wrenSetSlotString(vm, 0, ""); return; }
    const QMetaObject* meta = obj->metaObject();
    QStringList list;
    for (int i = 0; i < meta->methodCount(); i++) {
        QMetaMethod m = meta->method(i);
        if (m.methodType() == QMetaMethod::Slot)
            list << QString::fromUtf8(m.methodSignature());
    }
    wrenSetSlotString(vm, 0, list.join("\n").toUtf8().constData());
}

static void wfn_qtobj_propertyNames_(WrenVM* vm) {
    QObject* obj = qtobj_get(vm);
    if (!obj) { wrenSetSlotString(vm, 0, ""); return; }
    const QMetaObject* meta = obj->metaObject();
    QStringList names;
    for (int i = 0; i < meta->propertyCount(); i++)
        names << QString::fromUtf8(meta->property(i).name());
    QByteArray ba = names.join("\n").toUtf8();
    wrenSetSlotString(vm, 0, ba.constData());
}

// ─── Hex dump helper ──────────────────────────────────────────────────────────

// Build hex dump as a multi-line string (does NOT write to console)
static QString buildHexDump(const void* basePtr, int size) {
    const unsigned char* p = (const unsigned char*)basePtr;
    const int ROW = 16;
    QStringList lines;
    for (int off = 0; off < size; off += ROW) {
        QString line;
        line += QString("%1  ").arg(off, 4, 16, QChar('0'));
        for (int i = 0; i < ROW; i++) {
            if (off + i < size)
                line += QString("%1 ").arg(p[off + i], 2, 16, QChar('0'));
            else
                line += "   ";
            if (i == 7) line += " ";
        }
        line += " |";
        for (int i = 0; i < ROW && off + i < size; i++) {
            unsigned char c = p[off + i];
            line += (c >= 0x20 && c < 0x7F) ? QChar(c) : QChar('.');
        }
        line += "|";
        lines << line;
    }
    return lines.join("\n");
}

static void hexDumpToConsole(const void* basePtr, int size) {
    QString dump = buildHexDump(basePtr, size);
    QString html = QString("<pre style=\"color:#4488CC;margin:0;padding:0\">%1</pre>")
                   .arg(dump.toHtmlEscaped());
    appendToWidget(g_consoleWidget, html);
}

static void wfn_qtobj_hexDump_(WrenVM* vm) {
    QObject* obj = qtobj_get(vm);
    int size = (int)wrenGetSlotDouble(vm, 1);
    if (!obj) { consoleAppend("#FF5555", "", "hexDump: null object"); return; }
    if (size <= 0 || size > 4096) size = 128;
    QString header = QString("hexdump %1(%2) @0x%3  %4 bytes")
        .arg(obj->metaObject()->className())
        .arg(obj->objectName())
        .arg(QString::number((uintptr_t)obj, 16))
        .arg(size);
    QString dump = buildHexDump((const void*)obj, size);
    QString html = QString("<span style=\"color:#AAAAFF\">%1</span>"
                           "<pre style=\"color:#4488CC;margin:0;padding:0\">%2</pre>")
                   .arg(header.toHtmlEscaped())
                   .arg(dump.toHtmlEscaped());
    appendToWidget(g_consoleWidget, html);
}

static void wfn_qtobj_hexDumpStr_(WrenVM* vm) {
    QObject* obj = qtobj_get(vm);
    int size = (int)wrenGetSlotDouble(vm, 1);
    if (!obj) { wrenSetSlotString(vm, 0, ""); return; }
    if (size <= 0 || size > 4096) size = 128;
    QByteArray ba = buildHexDump((const void*)obj, size).toUtf8();
    wrenSetSlotString(vm, 0, ba.constData());
}

// ─── Memory read helpers ──────────────────────────────────────────────────────

static void wfn_inspector_findByClassCount_(WrenVM* vm) {
    const char* cls = wrenGetSlotString(vm, 1);
    QString clsName = QString::fromUtf8(cls);
    g_findByClassCache.clear();
    QWidgetList all = QApplication::allWidgets();
    for (QWidget* w : all)
        if (QString::fromUtf8(w->metaObject()->className()) == clsName)
            g_findByClassCache.append(w);
    wrenSetSlotDouble(vm, 0, (double)g_findByClassCache.size());
}

static void wfn_inspector_findByClassAt_(WrenVM* vm) {
    int idx = (int)wrenGetSlotDouble(vm, 1);
    if (idx < 0 || idx >= g_findByClassCache.size()) {
        wrenSetSlotDouble(vm, 0, 0.0); return;
    }
    wrenSetSlotDouble(vm, 0, (double)(uintptr_t)(QObject*)g_findByClassCache.at(idx));
}

// Макрос: читать тип T по адресу из слота 1, вернуть double в слот 0
#define READ_MEM(T) \
    uintptr_t addr = (uintptr_t)wrenGetSlotDouble(vm, 1); \
    if (!addr) { wrenSetSlotDouble(vm, 0, 0.0); return; } \
    T val = *(const T*)addr; \
    wrenSetSlotDouble(vm, 0, (double)val)

static void wfn_inspector_readPtr_(WrenVM* vm) { READ_MEM(uintptr_t); }
static void wfn_inspector_readU8_ (WrenVM* vm) { READ_MEM(uint8_t);   }
static void wfn_inspector_readU16_(WrenVM* vm) { READ_MEM(uint16_t);  }
static void wfn_inspector_readU32_(WrenVM* vm) { READ_MEM(uint32_t);  }
static void wfn_inspector_readI8_ (WrenVM* vm) { READ_MEM(int8_t);    }
static void wfn_inspector_readI16_(WrenVM* vm) { READ_MEM(int16_t);   }
static void wfn_inspector_readI32_(WrenVM* vm) { READ_MEM(int32_t);   }
static void wfn_inspector_readF32_(WrenVM* vm) { READ_MEM(float);     }
static void wfn_inspector_readF64_(WrenVM* vm) { READ_MEM(double);    }

// readI64/readU64 — Wren хранит double (53-бит мантисса), значения > 2^53 теряют точность
static void wfn_inspector_readI64_(WrenVM* vm) {
    uintptr_t addr = (uintptr_t)wrenGetSlotDouble(vm, 1);
    if (!addr) { wrenSetSlotDouble(vm, 0, 0.0); return; }
    int64_t val = *(const int64_t*)addr;
    wrenSetSlotDouble(vm, 0, (double)val);
}
static void wfn_inspector_readU64_(WrenVM* vm) {
    uintptr_t addr = (uintptr_t)wrenGetSlotDouble(vm, 1);
    if (!addr) { wrenSetSlotDouble(vm, 0, 0.0); return; }
    uint64_t val = *(const uint64_t*)addr;
    wrenSetSlotDouble(vm, 0, (double)val);
}

#undef READ_MEM

static void wfn_inspector_hexDump_(WrenVM* vm) {
    double addr = wrenGetSlotDouble(vm, 1);
    int    size = (int)wrenGetSlotDouble(vm, 2);
    if (addr == 0.0) { consoleAppend("#FF5555", "", "hexDump: address is 0"); return; }
    if (size <= 0 || size > 4096) size = 128;
    QString header = QString("hexdump @0x%1  %2 bytes")
        .arg(QString::number((uintptr_t)(uintptr_t)addr, 16))
        .arg(size);
    QString dump = buildHexDump((const void*)(uintptr_t)addr, size);
    QString html = QString("<span style=\"color:#AAAAFF\">%1</span>"
                           "<pre style=\"color:#4488CC;margin:0;padding:0\">%2</pre>")
                   .arg(header.toHtmlEscaped())
                   .arg(dump.toHtmlEscaped());
    appendToWidget(g_consoleWidget, html);
}

// ─── Named pointer Wren foreign methods ───────────────────────────────────────

// Inspector.namedPtr_("name") → Num (address), 0 if not found
static void wfn_inspector_namedPtr_(WrenVM* vm) {
    const char* name = wrenGetSlotString(vm, 1);
    auto it = g_namedPointers.find(QString::fromUtf8(name));
    if (it == g_namedPointers.end()) {
        wrenSetSlotDouble(vm, 0, 0.0);
    } else {
        wrenSetSlotDouble(vm, 0, (double)(uintptr_t)it.value());
    }
}

// Inspector.namedPtrNames_  → "\n"-joined list of registered names
static void wfn_inspector_namedPtrNames_(WrenVM* vm) {
    QStringList names = g_namedPointers.keys();
    QByteArray ba = names.join("\n").toUtf8();
    wrenSetSlotString(vm, 0, ba.constData());
}

// ─── Inspector static methods ─────────────────────────────────────────────────

static void wfn_inspector_find_(WrenVM* vm) {
    const char* nameUtf8 = wrenGetSlotString(vm, 1);
    QString name = QString::fromUtf8(nameUtf8);
    QWidgetList all = QApplication::allWidgets();
    for (QWidget* w : all) {
        if (w->objectName() == name) {
            wrenSetSlotDouble(vm, 0, (double)(uintptr_t)(QObject*)w);
            return;
        }
    }
    // Try non-widget QObjects via allWidgets parent traversal
    wrenSetSlotDouble(vm, 0, 0.0);
}

static void wfn_inspector_allWidgetCount_(WrenVM* vm) {
    refreshWidgetCaches();
    wrenSetSlotDouble(vm, 0, (double)g_allWidgetsCache.size());
}

static void wfn_inspector_widgetAt_(WrenVM* vm) {
    int idx = (int)wrenGetSlotDouble(vm, 1);
    if (idx < 0 || idx >= g_allWidgetsCache.size()) {
        wrenSetSlotDouble(vm, 0, 0.0);
        return;
    }
    wrenSetSlotDouble(vm, 0, (double)(uintptr_t)(QObject*)g_allWidgetsCache.at(idx));
}

static void wfn_inspector_topWidgetCount_(WrenVM* vm) {
    refreshWidgetCaches();
    wrenSetSlotDouble(vm, 0, (double)g_topWidgetsCache.size());
}

static void wfn_inspector_topWidgetAt_(WrenVM* vm) {
    int idx = (int)wrenGetSlotDouble(vm, 1);
    if (idx < 0 || idx >= g_topWidgetsCache.size()) {
        wrenSetSlotDouble(vm, 0, 0.0);
        return;
    }
    wrenSetSlotDouble(vm, 0, (double)(uintptr_t)(QObject*)g_topWidgetsCache.at(idx));
}

// ─── Log methods (monitor panel) ─────────────────────────────────────────────

static void wfn_log_print_(WrenVM* vm) {
    const char* msg = wrenGetSlotString(vm, 1);
    monitorAppend("#4488CC", "", QString::fromUtf8(msg));
}
static void wfn_log_info_(WrenVM* vm) {
    const char* msg = wrenGetSlotString(vm, 1);
    monitorAppend("#5599FF", "[INFO ]", QString::fromUtf8(msg));
}
static void wfn_log_ok_(WrenVM* vm) {
    const char* msg = wrenGetSlotString(vm, 1);
    monitorAppend("#55CC55", "[OK   ]", QString::fromUtf8(msg));
}
static void wfn_log_warn_(WrenVM* vm) {
    const char* msg = wrenGetSlotString(vm, 1);
    monitorAppend("#FFCC00", "[WARN ]", QString::fromUtf8(msg));
}
static void wfn_log_error_(WrenVM* vm) {
    const char* msg = wrenGetSlotString(vm, 1);
    monitorAppend("#FF5555", "[ERROR]", QString::fromUtf8(msg));
}
static void wfn_log_val_(WrenVM* vm) {
    const char* label = wrenGetSlotString(vm, 1);
    const char* value = wrenGetSlotString(vm, 2);
    QString msg = QString("[VAL  ] %1 = %2")
        .arg(QString::fromUtf8(label).toHtmlEscaped())
        .arg(QString::fromUtf8(value).toHtmlEscaped());
    appendToWidget(g_monitorWidget,
        QString("<span style=\"color:#00CCCC\">%1</span>").arg(msg));
}
static void wfn_log_sep_(WrenVM* vm) {
    const char* text = wrenGetSlotString(vm, 1);
    QString escaped = QString::fromUtf8(text).toHtmlEscaped();
    QString msg = QString("\u2500\u2500\u2500\u2500\u2500\u2500\u2500 %1 \u2500\u2500\u2500\u2500\u2500\u2500\u2500").arg(escaped);
    appendToWidget(g_monitorWidget,
        QString("<span style=\"color:#666666\">%1</span>").arg(msg));
}
static void wfn_log_clear(WrenVM* vm) {
    (void)vm;
    if (g_monitorWidget) ((QPlainTextEdit*)g_monitorWidget)->clear();
}

// ─── Out methods (console panel) ─────────────────────────────────────────────

static void wfn_out_print_(WrenVM* vm) {
    const char* msg = wrenGetSlotString(vm, 1);
    consoleAppend("#4488CC", "", QString::fromUtf8(msg));
}
static void wfn_out_info_(WrenVM* vm) {
    const char* msg = wrenGetSlotString(vm, 1);
    consoleAppend("#5599FF", "[INFO ]", QString::fromUtf8(msg));
}
static void wfn_out_ok_(WrenVM* vm) {
    const char* msg = wrenGetSlotString(vm, 1);
    consoleAppend("#55CC55", "[OK   ]", QString::fromUtf8(msg));
}
static void wfn_out_warn_(WrenVM* vm) {
    const char* msg = wrenGetSlotString(vm, 1);
    consoleAppend("#FFCC00", "[WARN ]", QString::fromUtf8(msg));
}
static void wfn_out_error_(WrenVM* vm) {
    const char* msg = wrenGetSlotString(vm, 1);
    consoleAppend("#FF5555", "[ERROR]", QString::fromUtf8(msg));
}
static void wfn_out_val_(WrenVM* vm) {
    const char* label = wrenGetSlotString(vm, 1);
    const char* value = wrenGetSlotString(vm, 2);
    QString msg = QString("[VAL  ] %1 = %2")
        .arg(QString::fromUtf8(label).toHtmlEscaped())
        .arg(QString::fromUtf8(value).toHtmlEscaped());
    appendToWidget(g_consoleWidget,
        QString("<span style=\"color:#00CCCC\">%1</span>").arg(msg));
}
static void wfn_out_sep_(WrenVM* vm) {
    const char* text = wrenGetSlotString(vm, 1);
    QString escaped = QString::fromUtf8(text).toHtmlEscaped();
    QString msg = QString("\u2500\u2500\u2500\u2500\u2500\u2500\u2500 %1 \u2500\u2500\u2500\u2500\u2500\u2500\u2500").arg(escaped);
    appendToWidget(g_consoleWidget,
        QString("<span style=\"color:#666666\">%1</span>").arg(msg));
}
static void wfn_out_clear(WrenVM* vm) {
    (void)vm;
    if (g_consoleWidget) ((QPlainTextEdit*)g_consoleWidget)->clear();
}

// ─── Check methods ────────────────────────────────────────────────────────────

static void wfn_check_that_(WrenVM* vm) {
    bool cond = wrenGetSlotBool(vm, 1);
    const char* msg = wrenGetSlotString(vm, 2);
    if (cond) {
        consoleAppend("#55CC55", "[OK   ]", QString::fromUtf8(msg));
        g_check_passed++;
    } else {
        consoleAppend("#FF5555", "[FAIL ]", QString::fromUtf8(msg));
        g_check_failed++;
    }
}

static void wfn_check_equal_(WrenVM* vm) {
    const char* a   = wrenGetSlotString(vm, 1);
    const char* b   = wrenGetSlotString(vm, 2);
    const char* msg = wrenGetSlotString(vm, 3);
    bool cond = (strcmp(a, b) == 0);
    QString detail = QString::fromUtf8(msg);
    if (!cond) {
        detail += QString(" (expected \"%1\", got \"%2\")")
            .arg(QString::fromUtf8(b).toHtmlEscaped())
            .arg(QString::fromUtf8(a).toHtmlEscaped());
    }
    if (cond) {
        consoleAppend("#55CC55", "[OK   ]", detail);
        g_check_passed++;
    } else {
        consoleAppend("#FF5555", "[FAIL ]", detail);
        g_check_failed++;
    }
}

static void wfn_check_notNull_(WrenVM* vm) {
    double val     = wrenGetSlotDouble(vm, 1);
    const char* msg = wrenGetSlotString(vm, 2);
    bool cond = (val != 0.0);
    if (cond) {
        consoleAppend("#55CC55", "[OK   ]", QString::fromUtf8(msg));
        g_check_passed++;
    } else {
        consoleAppend("#FF5555", "[FAIL ]", QString::fromUtf8(msg));
        g_check_failed++;
    }
}

static void wfn_check_report(WrenVM* vm) {
    (void)vm;
    QString msg = QString("%1 passed, %2 failed").arg(g_check_passed).arg(g_check_failed);
    consoleAppend("#5599FF", "[INFO ]", msg);
}

static void wfn_check_reset(WrenVM* vm) {
    (void)vm;
    g_check_passed = 0;
    g_check_failed = 0;
}

static void wfn_check_passed(WrenVM* vm) {
    wrenSetSlotDouble(vm, 0, (double)g_check_passed);
}

static void wfn_check_failed(WrenVM* vm) {
    wrenSetSlotDouble(vm, 0, (double)g_check_failed);
}

// ─── Registration functions ───────────────────────────────────────────────────

WrenForeignMethodFn winsp_bindForeignMethod(const char* module, const char* className,
                                             bool isStatic, const char* signature) {
    // ── inspector module ──────────────────────────────────────────────────────
    if (strcmp(module, "inspector") == 0) {
        if (strcmp(className, "QtObj") == 0 && !isStatic) {
            if (strcmp(signature, "name") == 0)              return wfn_qtobj_name;
            if (strcmp(signature, "className") == 0)         return wfn_qtobj_className;
            if (strcmp(signature, "address") == 0)           return wfn_qtobj_address;
            if (strcmp(signature, "isNull") == 0)            return wfn_qtobj_isNull;
            if (strcmp(signature, "parent_") == 0)           return wfn_qtobj_parent_;
            if (strcmp(signature, "childCount") == 0)        return wfn_qtobj_childCount;
            if (strcmp(signature, "childAt_(_)") == 0)       return wfn_qtobj_childAt_;
            if (strcmp(signature, "property(_)") == 0)       return wfn_qtobj_property;
            if (strcmp(signature, "setProperty(_,_)") == 0)  return wfn_qtobj_setProperty;
            if (strcmp(signature, "invoke(_)") == 0)         return wfn_qtobj_invoke;
            if (strcmp(signature, "dump_()") == 0)           return wfn_qtobj_dump_;
            if (strcmp(signature, "propertyNames_") == 0)    return wfn_qtobj_propertyNames_;
            if (strcmp(signature, "methods_") == 0)          return wfn_qtobj_methods_;
            if (strcmp(signature, "signalList_") == 0)       return wfn_qtobj_signalList_;
            if (strcmp(signature, "slotList_") == 0)         return wfn_qtobj_slotList_;
            if (strcmp(signature, "hexDump_(_)") == 0)       return wfn_qtobj_hexDump_;
            if (strcmp(signature, "hexDumpStr_(_)") == 0)    return wfn_qtobj_hexDumpStr_;
        }
        if (strcmp(className, "Inspector") == 0 && isStatic) {
            if (strcmp(signature, "find_(_)") == 0)          return wfn_inspector_find_;
            if (strcmp(signature, "findByClassCount_(_)") == 0) return wfn_inspector_findByClassCount_;
            if (strcmp(signature, "findByClassAt_(_)") == 0)    return wfn_inspector_findByClassAt_;
            if (strcmp(signature, "readPtr_(_)") == 0)  return wfn_inspector_readPtr_;
            if (strcmp(signature, "readU8_(_)") == 0)   return wfn_inspector_readU8_;
            if (strcmp(signature, "readU16_(_)") == 0)  return wfn_inspector_readU16_;
            if (strcmp(signature, "readU32_(_)") == 0)  return wfn_inspector_readU32_;
            if (strcmp(signature, "readI8_(_)") == 0)   return wfn_inspector_readI8_;
            if (strcmp(signature, "readI16_(_)") == 0)  return wfn_inspector_readI16_;
            if (strcmp(signature, "readI32_(_)") == 0)  return wfn_inspector_readI32_;
            if (strcmp(signature, "readI64_(_)") == 0)  return wfn_inspector_readI64_;
            if (strcmp(signature, "readU64_(_)") == 0)  return wfn_inspector_readU64_;
            if (strcmp(signature, "readF32_(_)") == 0)  return wfn_inspector_readF32_;
            if (strcmp(signature, "readF64_(_)") == 0)  return wfn_inspector_readF64_;
            if (strcmp(signature, "hexDump_(_,_)") == 0)     return wfn_inspector_hexDump_;
            if (strcmp(signature, "namedPtr_(_)") == 0)      return wfn_inspector_namedPtr_;
            if (strcmp(signature, "namedPtrNames_") == 0)    return wfn_inspector_namedPtrNames_;
            if (strcmp(signature, "allWidgetCount_") == 0)   return wfn_inspector_allWidgetCount_;
            if (strcmp(signature, "widgetAt_(_)") == 0)      return wfn_inspector_widgetAt_;
            if (strcmp(signature, "topWidgetCount_") == 0)   return wfn_inspector_topWidgetCount_;
            if (strcmp(signature, "topWidgetAt_(_)") == 0)   return wfn_inspector_topWidgetAt_;
        }
    }

    // ── log module ────────────────────────────────────────────────────────────
    if (strcmp(module, "log") == 0 && strcmp(className, "Log") == 0 && isStatic) {
        if (strcmp(signature, "print_(_)") == 0)     return wfn_log_print_;
        if (strcmp(signature, "info_(_)") == 0)      return wfn_log_info_;
        if (strcmp(signature, "ok_(_)") == 0)        return wfn_log_ok_;
        if (strcmp(signature, "warn_(_)") == 0)      return wfn_log_warn_;
        if (strcmp(signature, "error_(_)") == 0)     return wfn_log_error_;
        if (strcmp(signature, "val_(_,_)") == 0)     return wfn_log_val_;
        if (strcmp(signature, "sep_(_)") == 0)       return wfn_log_sep_;
        if (strcmp(signature, "clear()") == 0)       return wfn_log_clear;
    }

    // ── out module ────────────────────────────────────────────────────────────
    if (strcmp(module, "out") == 0 && strcmp(className, "Out") == 0 && isStatic) {
        if (strcmp(signature, "print_(_)") == 0)     return wfn_out_print_;
        if (strcmp(signature, "info_(_)") == 0)      return wfn_out_info_;
        if (strcmp(signature, "ok_(_)") == 0)        return wfn_out_ok_;
        if (strcmp(signature, "warn_(_)") == 0)      return wfn_out_warn_;
        if (strcmp(signature, "error_(_)") == 0)     return wfn_out_error_;
        if (strcmp(signature, "val_(_,_)") == 0)     return wfn_out_val_;
        if (strcmp(signature, "sep_(_)") == 0)       return wfn_out_sep_;
        if (strcmp(signature, "clear()") == 0)       return wfn_out_clear;
    }

    // ── check module ──────────────────────────────────────────────────────────
    if (strcmp(module, "check") == 0 && strcmp(className, "Check") == 0 && isStatic) {
        if (strcmp(signature, "that_(_,_)") == 0)    return wfn_check_that_;
        if (strcmp(signature, "equal_(_,_,_)") == 0) return wfn_check_equal_;
        if (strcmp(signature, "notNull_(_,_)") == 0) return wfn_check_notNull_;
        if (strcmp(signature, "report()") == 0)      return wfn_check_report;
        if (strcmp(signature, "reset()") == 0)       return wfn_check_reset;
        if (strcmp(signature, "passed") == 0)        return wfn_check_passed;
        if (strcmp(signature, "failed") == 0)        return wfn_check_failed;
    }

    return nullptr;
}

WrenForeignClassMethods winsp_bindForeignClass(const char* module, const char* className) {
    WrenForeignClassMethods m = {nullptr, nullptr};
    if (strcmp(module, "inspector") == 0 && strcmp(className, "QtObj") == 0) {
        m.allocate = wfn_qtobj_new;
        m.finalize = wfn_qtobj_finalize;
    }
    return m;
}

const char* winsp_getModuleSource(const char* name) {
    if (strcmp(name, "inspector") == 0) return INSPECTOR_MODULE_SRC;
    if (strcmp(name, "log") == 0)       return LOG_MODULE_SRC;
    if (strcmp(name, "out") == 0)       return OUT_MODULE_SRC;
    if (strcmp(name, "check") == 0)     return CHECK_MODULE_SRC;
    return nullptr;
}
