# qte56_foundation.pro — merged DLL
# Modules: qobject, qfont, qicon, qcolor, qpixmap, qtimer, qsettings, qclipboard, qbuttongroup,
#          qfile, qpainter, qimage, qimagereader, qimagewriter, qpicture, qdatetime, qbytearray

QT       += core gui widgets
TARGET    = qte56_foundation
TEMPLATE  = lib
CONFIG   += shared c++11
CONFIG   -= debug_and_release

DEFINES  += \
    QTE56_QOBJECT_BUILD \
    QTE56_QFONT_BUILD \
    QTE56_QICON_BUILD \
    QTE56_QCOLOR_BUILD \
    QTE56_QPIXMAP_BUILD \
    QTE56_QTIMER_BUILD \
    QTE56_QSETTINGS_BUILD \
    QTE56_QCLIPBOARD_BUILD \
    QTE56_QBUTTONGROUP_BUILD \
    QTE56_QFILE_BUILD \
    QTE56_QPAINTER_BUILD \
    QTE56_QIMAGE_BUILD \
    QTE56_QIMAGEREADER_BUILD \
    QTE56_QIMAGEWRITER_BUILD \
    QTE56_QPICTURE_BUILD \
    QTE56_QDATETIME_BUILD \
    QTE56_QBYTEARRAY_BUILD

INCLUDEPATH += \
    ../../qte56_qobject \
    ../../qte56_qfont \
    ../../qte56_qicon \
    ../../qte56_qcolor \
    ../../qte56_qpixmap \
    ../../qte56_qtimer \
    ../../qte56_qsettings \
    ../../qte56_qclipboard \
    ../../qte56_qbuttongroup \
    ../../qte56_qfile \
    ../../qte56_qpainter \
    ../../qte56_qimage \
    ../../qte56_qimagereader \
    ../../qte56_qimagewriter \
    ../../qte56_qpicture \
    ../../qte56_qdatetime \
    ../../qte56_qbytearray

SOURCES  += \
    ../../qte56_qobject/qte56_qobject.cpp \
    ../../qte56_qfont/qte56_qfont.cpp \
    ../../qte56_qicon/qte56_qicon.cpp \
    ../../qte56_qcolor/qte56_qcolor.cpp \
    ../../qte56_qpixmap/qte56_qpixmap.cpp \
    ../../qte56_qtimer/qte56_qtimer.cpp \
    ../../qte56_qsettings/qte56_qsettings.cpp \
    ../../qte56_qclipboard/qte56_qclipboard.cpp \
    ../../qte56_qbuttongroup/qte56_qbuttongroup.cpp \
    ../../qte56_qfile/qte56_qfile.cpp \
    ../../qte56_qpainter/qte56_qpainter.cpp \
    ../../qte56_qimage/qte56_qimage.cpp \
    ../../qte56_qimagereader/qte56_qimagereader.cpp \
    ../../qte56_qimagewriter/qte56_qimagewriter.cpp \
    ../../qte56_qpicture/qte56_qpicture.cpp \
    ../../qte56_qdatetime/qte56_qdatetime.cpp \
    ../../qte56_qbytearray/qte56_qbytearray.cpp

HEADERS  += \
    ../../qte56_qobject/qte56_qobject.h \
    ../../qte56_qfont/qte56_qfont.h \
    ../../qte56_qicon/qte56_qicon.h \
    ../../qte56_qcolor/qte56_qcolor.h \
    ../../qte56_qpixmap/qte56_qpixmap.h \
    ../../qte56_qtimer/qte56_qtimer.h \
    ../../qte56_qsettings/qte56_qsettings.h \
    ../../qte56_qclipboard/qte56_qclipboard.h \
    ../../qte56_qbuttongroup/qte56_qbuttongroup.h \
    ../../qte56_qfile/qte56_qfile.h \
    ../../qte56_qpainter/qte56_qpainter.h \
    ../../qte56_qimage/qte56_qimage.h \
    ../../qte56_qimagereader/qte56_qimagereader.h \
    ../../qte56_qimagewriter/qte56_qimagewriter.h \
    ../../qte56_qpicture/qte56_qpicture.h \
    ../../qte56_qdatetime/qte56_qdatetime.h \
    ../../qte56_qbytearray/qte56_qbytearray.h

# Выбор папки назначения по QTE56_ARCH (32 или 64)
# Настройка компилятора через PATH (a.cmd)
QTE56_ARCH = $$(QTE56_ARCH)
isEmpty(QTE56_ARCH) {
    QTE56_ARCH = 32
}

equals(QTE56_ARCH, 64) {
    DESTDIR = ../../../../dll/dll64
} else {
    DESTDIR = ../../../../dll/dll32
}

unix: DESTDIR = ../../../../lib

macx {
    QMAKE_CXXFLAGS += -fvisibility=default
    QMAKE_CFLAGS   += -fvisibility=default
}
