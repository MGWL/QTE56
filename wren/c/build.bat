@echo off
cd /d "%~dp0"
set QTDIR=C:\Qt5_13_2\5.13.2\mingw73_32
set PATH=%QTDIR%\bin;C:\Qt5_13_2\Tools\mingw730_32\bin;%PATH%

echo === qmake ===
qmake wren_bridge.pro -spec win32-g++ "CONFIG+=release"
if %ERRORLEVEL% NEQ 0 (echo qmake FAILED & pause & exit /b 1)

echo === make ===
mingw32-make -j4 2>&1
if %ERRORLEVEL% NEQ 0 (echo make FAILED & pause & exit /b 1)

echo.
echo === wren_bridge.dll built → ../../dll/ ===
pause
