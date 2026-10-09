#include "qte56_resource.h"
#include <QResource>
#include <QString>

extern "C" {

// 19810
int qteQResource_registerResource(
    void* path,
    void* mapRoot)
{
    QString qpath   = *(QString*)path;
    QString qroot   = (mapRoot != nullptr)
                    ? *(QString*)mapRoot
                    : QString("/");
    return QResource::registerResource(qpath, qroot) ? 1 : 0;
}

// 19811
int qteQResource_unregisterResource(
    void* path,
    void* mapRoot)
{
    QString qpath   = *(QString*)path;
    QString qroot   = (mapRoot != nullptr)
                    ? *(QString*)mapRoot
                    : QString("/");
    return QResource::unregisterResource(qpath, qroot) ? 1 : 0;
}

} // extern "C"
