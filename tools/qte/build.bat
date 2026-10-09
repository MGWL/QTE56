@echo off
REM tools/qte/build.bat - build qte.exe (CLI tool for QTE56 analysis).
REM
REM Usage:
REM   tools\qte\build.bat              ordinary build
REM   tools\qte\build.bat --unittest   build and run unit tests
REM   tools\qte\build.bat --release    release build (-O -release -inline)

setlocal enabledelayedexpansion

cd /d "%~dp0..\.."

if exist "%~dp0..\..\local.env.bat" call "%~dp0..\..\local.env.bat"
if not defined DMD set DMD=dmd

set EXTRA=
set MODE=build

if /i "%1" == "--unittest" set MODE=unittest
if /i "%1" == "--release"  set EXTRA=-O -release -inline

set SOURCES=tools\qte\main.d tools\qte\cmd_index.d tools\qte\cmd_class.d tools\qte\cmd_check.d tools\qte\cmd_signals.d tools\qte\cmd_trace.d tools\qte\cmd_dll.d tools\qte\cmd_deps.d tools\qte\cmd_scan.d tools\lib\qte_meta.d tools\lib\qte_cli.d
set OUT=tools\qte\qte.exe

if "%MODE%" == "unittest" (
    echo === Compiling qte unit tests ===
    %DMD% -unittest -main -of=tools\qte\qte_test.exe %SOURCES% -Itools\lib
    if !ERRORLEVEL! NEQ 0 ( echo BUILD FAILED & exit /b 1 )
    echo === Running tests ===
    tools\qte\qte_test.exe
    exit /b !ERRORLEVEL!
)

echo === Building qte.exe %EXTRA% ===
%DMD% %EXTRA% -of=%OUT% %SOURCES% -Itools\lib

if %ERRORLEVEL% NEQ 0 (
    echo BUILD FAILED
    exit /b 1
)

echo === BUILD OK -^> %OUT% ===
echo.
%OUT% --version
