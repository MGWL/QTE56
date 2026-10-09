@echo off
rem run_cb.bat - сборка и прогон теста callback-моста (cb_test.f)
cd /d %~dp0
echo === Генерация cbtest.d ===
py gen_cbtest.py || goto :error
echo === Сборка cbtest.dll (с общим DllMain из ..\dll.d) ===
dmd -m32 -shared cbtest.d ..\dll.d cbtest.def -of=cbtest.dll || goto :error
echo === Сборка консоли forthD ===
dmd -m32 ..\forth.d ..\console_forth.d -Luser32.lib -of=..\console_forth.exe || goto :error
echo === Прогон cb_test.f ===
cd ..
echo BYE | console_forth.exe heap.f strings.f console.f wincon.f test\cb_test.f
goto :eof
:error
echo BUILD FAILED
exit /b 1
