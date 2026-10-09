#!/usr/bin/env python3
# gen_cbtest.py - генератор cbtest.d: DLL-"вызыватели" callback'ов
# для теста моста cbBridge (MK-WINAPI-CB / MK-CDECL-CB из stdlib.f).
# Запуск:  py gen_cbtest.py   (пишет cbtest.d рядом, в UTF-8)
# Сборка:  dmd -m32 -shared -of=cbtest.dll cbtest.d
#
# Все экспорты - stdcall (extern(Windows)) с недекорированными именами
# (pragma(mangle, ...)), чтобы GetProcAddress находил их точно.
# Вызываемый callback (fn) вызывается как stdcall (cbwN) или cdecl (cbcN).
#
# Сюда же позже можно дописать матрицу cdecl_N/stdcall_N/pascal_N
# из плана call.md (тесты самого _-Call") - сейчас только вызыватели.

W_N = [0, 1, 2, 3, 4, 8]   # stdcall-вызыватели cbwN
C_N = [0, 1, 2, 4]         # cdecl-вызыватели cbcN

out = []


def params(n):      # параметры вызывателя: fn + n аргументов
    return ", ".join(["uint fn"] + ["uint a%d" % i for i in range(1, n + 1)])


def callargs(n):
    return ", ".join("a%d" % i for i in range(1, n + 1))


def fp(cc, n):      # тип указателя на callback
    inner = ", ".join(["uint"] * n)
    return "extern(%s) uint function(%s)" % (cc, inner)


def gen(name, cc, n):
    return ('pragma(mangle, "%s")\n'
            'extern(Windows) uint %s(%s) {\n'
            '    alias FP = %s;\n'
            '    return (cast(FP) fn)(%s);\n'
            '}' % (name, name, params(n), fp(cc, n), callargs(n)))


out.append("module cbtest;")
out.append("// АВТОГЕНЕРАЦИЯ gen_cbtest.py - не редактировать вручную")
out.append("")
out.append("__gshared uint g_esp_before;")
out.append("__gshared int  g_esp_diff;")
out.append("")
for n in W_N:
    out.append(gen("cbw%d" % n, "Windows", n))
    out.append("")
for n in C_N:
    out.append(gen("cbc%d" % n, "C", n))
    out.append("")

# Замер баланса машинного стека вокруг stdcall-вызова callback'а.
# Исправный stdcall-thunk (ret 8) => diff = 0.
out.append('''pragma(mangle, "cbw2_chk")
extern(Windows) uint cbw2_chk(uint fn, uint a1, uint a2) {
    alias FP = extern(Windows) uint function(uint, uint);
    asm { mov [g_esp_before], ESP; }
    uint r = (cast(FP) fn)(a1, a2);
    asm {
        mov EAX, ESP;
        sub EAX, [g_esp_before];
        mov [g_esp_diff], EAX;
    }
    return r;
}

pragma(mangle, "cb_esp_diff")
extern(Windows) int cb_esp_diff() { return g_esp_diff; }

// Серия вызовов: ловит утечки стеков на повторах
pragma(mangle, "cbw2_loop")
extern(Windows) uint cbw2_loop(uint fn, uint a, uint b, uint count) {
    alias FP = extern(Windows) uint function(uint, uint);
    uint sum = 0;
    for (uint i = 0; i < count; i++) sum += (cast(FP) fn)(a, b);
    return sum;
}''')

with open("cbtest.d", "w", encoding="utf-8", newline="\n") as f:
    f.write("\n".join(out) + "\n")
print("cbtest.d written")

# DEF-файл с явными именами экспортов: без него DMD не экспортирует
# функции без атрибута export, и GetProcAddress ничего не находит.
names = (["cbw%d" % n for n in W_N] + ["cbc%d" % n for n in C_N]
         + ["cbw2_chk", "cb_esp_diff", "cbw2_loop"])
with open("cbtest.def", "w", encoding="ascii", newline="\n") as f:
    f.write("LIBRARY cbtest\nEXPORTS\n")
    for nm in names:
        f.write("    " + nm + "\n")
print("cbtest.def written")
