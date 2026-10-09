#ifndef QTE56_QOBJECT_BUILD
#define QTE56_QOBJECT_BUILD
#endif

#include "qte56_lifecycle.h"

#include <QObject>
#include <QSet>
#include <QChildEvent>
#include <QApplication>

// ─── Singleton-трекер ──────────────────────────────────────────────────────────

class Qte56Lifecycle : public QObject {
public:
    static Qte56Lifecycle* instance() {
        static Qte56Lifecycle* inst = new Qte56Lifecycle();
        return inst;
    }

    QSet<QObject*> destroyed;
    QSet<QObject*> hasParent;

    void trackObject(QObject* obj) {
        if (!obj) return;
        QObject::connect(obj, &QObject::destroyed, [this](QObject* o) {
            destroyed.insert(o);
            hasParent.remove(o);
        });
    }

protected:
    bool eventFilter(QObject* obj, QEvent* ev) override {
        if (ev->type() == QEvent::ChildAdded) {
            auto ce = static_cast<QChildEvent*>(ev);
            if (ce->child()) {
                hasParent.insert(ce->child());
            }
        } else if (ev->type() == QEvent::ChildRemoved) {
            auto ce = static_cast<QChildEvent*>(ev);
            if (ce->child()) {
                hasParent.remove(ce->child());
            }
        }
        return false;
    }

private:
    explicit Qte56Lifecycle(QObject* parent = nullptr) : QObject(parent) {}
};

// ─── C API ─────────────────────────────────────────────────────────────────────

extern "C" {

int qte_lifecycle_shouldDelete(void* obj) {
    if (!obj) return 0;
    auto inst = Qte56Lifecycle::instance();
    if (inst->destroyed.contains(static_cast<QObject*>(obj))) return 0;
    if (inst->hasParent.contains(static_cast<QObject*>(obj))) return 0;
    return 1;
}

int qte_lifecycle_isValid(void* obj) {
    if (!obj) return 0;
    return Qte56Lifecycle::instance()->destroyed.contains(static_cast<QObject*>(obj)) ? 0 : 1;
}

void qte_lifecycle_installAppFilter(void* app) {
    if (app) {
        static_cast<QApplication*>(app)->installEventFilter(Qte56Lifecycle::instance());
    }
}

void qte_lifecycle_track(void* obj) {
    Qte56Lifecycle::instance()->trackObject(static_cast<QObject*>(obj));
}

} // extern "C"
