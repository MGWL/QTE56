# qte56_qxlsx.pro - QXlsx obertka dlja QTE56

TARGET = qte56_qxlsx
TEMPLATE = lib
CONFIG += shared c++11

# QTE56 architecture selection
QTE56_ARCH = $$(QTE56_ARCH)
isEmpty(QTE56_ARCH) {
    QTE56_ARCH = win32_qt5
}

# Destination directory
contains(QTE56_ARCH, 64) {
    DESTDIR = ../../../dll/dll64
} else {
    DESTDIR = ../../../dll/dll32
}

# Qt modules
QT += core
QT += gui-private

# QXlsx paths
QXLSX_PARENTPATH = ../../../QXlsx/
QXLSX_HEADERPATH = ../../../QXlsx/header/
QXLSX_SOURCEPATH = ../../../QXlsx/source/
include(../../../QXlsx/QXlsx.pri)

# Export macro
DEFINES += QTE56_QXLSX_EXPORTS

# Headers
HEADERS += \
    qte56_qxlsx.h

# Sources
SOURCES += \
    qte56_qxlsx.cpp
