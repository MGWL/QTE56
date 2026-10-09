@echo off
chcp 65001

cd /d "%~dp0"

echo === Building qte56_qxlsx.dll ===

:: Determine architecture
set "ARCH_CHECK=%QTE56_ARCH: =%"
if "%ARCH_CHECK%"=="64" (
    set QMAKE_SPEC=win32-g++
    set DLL_DIR=..\..\dll\dll64
) else (
    set QMAKE_SPEC=win32-g++
    set DLL_DIR=..\..\dll\dll32
)

:: Find qmake
set QMAKE=C:\Qt5_13_2\5.13.2\mingw73_32\bin\qmake.exe

"%QMAKE%" qte56_qxlsx.pro -spec %QMAKE_SPEC%

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: qmake failed!
    pause & exit /b 1
)

mingw32-make

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: build failed!
    pause & exit /b 1
)

echo === Build OK ===
pause
