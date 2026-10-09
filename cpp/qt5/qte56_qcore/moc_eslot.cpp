/****************************************************************************
** Meta object code from reading C++ file 'eslot.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.13.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <memory>
#include "eslot.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'eslot.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.13.2. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_eSlot_t {
    QByteArrayData data[16];
    char stringdata0[95];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_eSlot_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_eSlot_t qt_meta_stringdata_eSlot = {
    {
QT_MOC_LITERAL(0, 0, 5), // "eSlot"
QT_MOC_LITERAL(1, 6, 8), // "invoke_v"
QT_MOC_LITERAL(2, 15, 0), // ""
QT_MOC_LITERAL(3, 16, 8), // "invoke_b"
QT_MOC_LITERAL(4, 25, 1), // "v"
QT_MOC_LITERAL(5, 27, 8), // "invoke_i"
QT_MOC_LITERAL(6, 36, 9), // "invoke_ii"
QT_MOC_LITERAL(7, 46, 1), // "a"
QT_MOC_LITERAL(8, 48, 1), // "b"
QT_MOC_LITERAL(9, 50, 8), // "invoke_d"
QT_MOC_LITERAL(10, 59, 8), // "invoke_s"
QT_MOC_LITERAL(11, 68, 1), // "s"
QT_MOC_LITERAL(12, 70, 8), // "invoke_p"
QT_MOC_LITERAL(13, 79, 1), // "p"
QT_MOC_LITERAL(14, 81, 9), // "invoke_qp"
QT_MOC_LITERAL(15, 91, 3) // "ptr"

    },
    "eSlot\0invoke_v\0\0invoke_b\0v\0invoke_i\0"
    "invoke_ii\0a\0b\0invoke_d\0invoke_s\0s\0"
    "invoke_p\0p\0invoke_qp\0ptr"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_eSlot[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
       8,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: name, argc, parameters, tag, flags
       1,    0,   54,    2, 0x0a /* Public */,
       3,    1,   55,    2, 0x0a /* Public */,
       5,    1,   58,    2, 0x0a /* Public */,
       6,    2,   61,    2, 0x0a /* Public */,
       9,    1,   66,    2, 0x0a /* Public */,
      10,    1,   69,    2, 0x0a /* Public */,
      12,    1,   72,    2, 0x0a /* Public */,
      14,    1,   75,    2, 0x0a /* Public */,

 // slots: parameters
    QMetaType::Void,
    QMetaType::Void, QMetaType::Bool,    4,
    QMetaType::Void, QMetaType::Int,    4,
    QMetaType::Void, QMetaType::Int, QMetaType::Int,    7,    8,
    QMetaType::Void, QMetaType::Double,    4,
    QMetaType::Void, QMetaType::QString,   11,
    QMetaType::Void, QMetaType::QPoint,   13,
    QMetaType::Void, QMetaType::VoidStar,   15,

       0        // eod
};

void eSlot::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<eSlot *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->invoke_v(); break;
        case 1: _t->invoke_b((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 2: _t->invoke_i((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 3: _t->invoke_ii((*reinterpret_cast< int(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2]))); break;
        case 4: _t->invoke_d((*reinterpret_cast< double(*)>(_a[1]))); break;
        case 5: _t->invoke_s((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 6: _t->invoke_p((*reinterpret_cast< const QPoint(*)>(_a[1]))); break;
        case 7: _t->invoke_qp((*reinterpret_cast< void*(*)>(_a[1]))); break;
        default: ;
        }
    }
}

QT_INIT_METAOBJECT const QMetaObject eSlot::staticMetaObject = { {
    &QObject::staticMetaObject,
    qt_meta_stringdata_eSlot.data,
    qt_meta_data_eSlot,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *eSlot::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *eSlot::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_eSlot.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int eSlot::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 8)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 8;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 8)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 8;
    }
    return _id;
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
