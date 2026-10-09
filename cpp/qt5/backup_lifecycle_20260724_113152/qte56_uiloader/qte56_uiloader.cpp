#include "qte56_uiloader.h"
#include "../qte56_qobject/qte56_lifecycle.h"
#include <QUiLoader>
#include <QFile>
#include <QWidget>
#include <QAction>
#include <QString>

extern "C" {

// 19812
void* qteQUiLoader_create() {
    return qte_createTracked(new QUiLoader());
}

// 19813
void qteQUiLoader_delete(void* loader) {
    delete (QUiLoader*)loader;
}

// 19814 — открывает файл, загружает форму, возвращает root QWidget*
void* qteQUiLoader_load(
    void* loader,
    void* path,
    void* parent)
{
    QString qpath = *(QString*)path;
    QFile   file(qpath);
    if (!file.open(QFile::ReadOnly)) return nullptr;
    QWidget* w = ((QUiLoader*)loader)->load(&file, (QWidget*)parent);
    file.close();
    return w;
}

// 19815 — рекурсивный поиск дочернего виджета по objectName
void* qteQWidget_findChild(
    void* parent,
    void* name)
{
    QString qname = *(QString*)name;
    QWidget* w = (QWidget*)parent;
    return w->findChild<QWidget*>(qname);
}

// 20156 — рекурсивный поиск дочернего QAction по objectName.
// QAction наследуется от QObject, не от QWidget — поэтому findChild<QWidget*>
// его не находит. Используем явный шаблонный аргумент QAction*.
// Возвращает QAction* или nullptr.
void* qteQObject_findChildAction(
    void* parent,
    void* name)
{
    QString qname = *(QString*)name;
    QObject* obj  = (QObject*)parent;
    return obj->findChild<QAction*>(qname);
}

} // extern "C"
