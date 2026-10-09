@echo off
set PATH=C:\Qt5_13_2\Tools\mingw730_32\bin;%PATH%

echo === Compiling qte56_qgraphicsscene.cpp ===
g++ -c -fno-keep-inline-dllexport -O2 -std=gnu++11 -Wall -W -Wextra -fexceptions -mthreads -DUNICODE -D_UNICODE -DWIN32 -DMINGW_HAS_SECURE_API=1 -DQTE56_QGRAPHICSSCENE_BUILD -DQT_NO_DEBUG -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_CORE_LIB -I. -IC:\Qt5_13_2\5.13.2\mingw73_32\include -IC:\Qt5_13_2\5.13.2\mingw73_32\include\QtWidgets -IC:\Qt5_13_2\5.13.2\mingw73_32\include\QtGui -IC:\Qt5_13_2\5.13.2\mingw73_32\include\QtANGLE -IC:\Qt5_13_2\5.13.2\mingw73_32\include\QtCore -I. -IC:\Qt5_13_2\5.13.2\mingw73_32\mkspecs\win32-g++ -o qte56_qgraphicsscene.o qte56_qgraphicsscene.cpp
if errorlevel 1 goto :error

echo === Linking DLL ===
g++ -Wl,-s -shared -Wl,-subsystem,windows -mthreads -Wl,--out-implib,..\..\dll\libqte56_qgraphicsscene.a -o ..\..\dll\qte56_qgraphicsscene.dll qte56_qgraphicsscene.o C:\Qt5_13_2\5.13.2\mingw73_32\lib\libQt5Widgets.a C:\Qt5_13_2\5.13.2\mingw73_32\lib\libQt5Gui.a C:\Qt5_13_2\5.13.2\mingw73_32\lib\libQt5Core.a
if errorlevel 1 goto :error

echo === Build successful ===
goto :end

:error
echo === Build FAILED ===
exit /b 1

:end
