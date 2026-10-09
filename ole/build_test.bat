@echo off
REM Build and run OLE Automation test
REM Run from arch_new/ directory

echo === Building ole_helper.dll ===
pushd ole\c
call build.bat
if errorlevel 1 (
    popd
    echo FAILED: DLL build
    exit /b 1
)
popd

echo.
echo === Copying DLL ===
copy /Y ole\c\ole_helper.dll . >nul
echo OK: ole_helper.dll copied to arch_new\

echo.
echo === Compiling test_excel.d ===
dmd -m32 -of=test_excel.exe ole\d\test_excel.d ole\d\ole_automation.d ole\d\ole_excel.d
if errorlevel 1 (
    echo FAILED: D compilation
    exit /b 1
)
echo OK: test_excel.exe created

echo.
echo === Running test ===
test_excel.exe
