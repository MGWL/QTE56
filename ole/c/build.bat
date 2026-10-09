@echo off
REM Build ole_helper.dll with MinGW (32-bit)
REM Run from arch_new/ole/c/

echo Building ole_helper.dll ...
gcc -shared -m32 -o ole_helper.dll ole_helper.c -lole32 -loleaut32 -luuid -Wl,--kill-at
if errorlevel 1 (
    echo FAILED to build ole_helper.dll
    exit /b 1
)
echo OK: ole_helper.dll created
echo.
echo Exported symbols:
objdump -p ole_helper.dll | findstr "ole_"
