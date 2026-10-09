@echo off
cd /d "%~dp0..\.."

echo === Compiling wren demo ===
dmd -m32 -i ^
    wren\test\demo.d ^
    wren\d\wren_vm.d ^
    d\qte56_core.d ^
    d\qte56_loader.d ^
    d\qte56_enums.d ^
    d\gen\gen_qcore.d ^
    d\gen\gen_qobject.d ^
    d\gen\gen_qfont.d ^
    d\gen\gen_qwidget.d ^
    d\gen\gen_qframe.d ^
    d\gen\gen_qlayout.d ^
    d\gen\gen_qlabel.d ^
    d\gen\gen_qpushbutton.d ^
    d\gen\gen_qlineedit.d ^
    d\gen\gen_qcheckbox.d ^
    d\gen\gen_qcombobox.d ^
    d\gen\gen_qspinbox.d ^
    d\gen\gen_qgroupbox.d ^
    d\gen\gen_qabstractbutton.d ^
    d\gen\gen_qabstractspinbox.d ^
    d\gen\gen_qabstractscrollarea.d ^
    d\gen\gen_qabstractitemview.d ^
    d\gen\gen_qlistwidget.d ^
    d\gen\gen_qabstractslider.d ^
    d\gen\gen_qplaintextedit.d ^
    -Id -Id\gen -Iwren\d ^
    -of=wren\test\demo.exe

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: D compilation failed!
    pause & exit /b 1
)

echo.
echo === Running ===
set PATH=%~dp0..\..\dll\dll32;C:\Qt5_13_2\5.13.2\mingw73_32\bin;%PATH%
wren\test\demo.exe

pause
