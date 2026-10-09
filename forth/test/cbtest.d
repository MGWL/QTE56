module cbtest;
// АВТОГЕНЕРАЦИЯ gen_cbtest.py - не редактировать вручную

__gshared uint g_esp_before;
__gshared int  g_esp_diff;

pragma(mangle, "cbw0")
extern(Windows) uint cbw0(uint fn) {
    alias FP = extern(Windows) uint function();
    return (cast(FP) fn)();
}

pragma(mangle, "cbw1")
extern(Windows) uint cbw1(uint fn, uint a1) {
    alias FP = extern(Windows) uint function(uint);
    return (cast(FP) fn)(a1);
}

pragma(mangle, "cbw2")
extern(Windows) uint cbw2(uint fn, uint a1, uint a2) {
    alias FP = extern(Windows) uint function(uint, uint);
    return (cast(FP) fn)(a1, a2);
}

pragma(mangle, "cbw3")
extern(Windows) uint cbw3(uint fn, uint a1, uint a2, uint a3) {
    alias FP = extern(Windows) uint function(uint, uint, uint);
    return (cast(FP) fn)(a1, a2, a3);
}

pragma(mangle, "cbw4")
extern(Windows) uint cbw4(uint fn, uint a1, uint a2, uint a3, uint a4) {
    alias FP = extern(Windows) uint function(uint, uint, uint, uint);
    return (cast(FP) fn)(a1, a2, a3, a4);
}

pragma(mangle, "cbw8")
extern(Windows) uint cbw8(uint fn, uint a1, uint a2, uint a3, uint a4, uint a5, uint a6, uint a7, uint a8) {
    alias FP = extern(Windows) uint function(uint, uint, uint, uint, uint, uint, uint, uint);
    return (cast(FP) fn)(a1, a2, a3, a4, a5, a6, a7, a8);
}

pragma(mangle, "cbc0")
extern(Windows) uint cbc0(uint fn) {
    alias FP = extern(C) uint function();
    return (cast(FP) fn)();
}

pragma(mangle, "cbc1")
extern(Windows) uint cbc1(uint fn, uint a1) {
    alias FP = extern(C) uint function(uint);
    return (cast(FP) fn)(a1);
}

pragma(mangle, "cbc2")
extern(Windows) uint cbc2(uint fn, uint a1, uint a2) {
    alias FP = extern(C) uint function(uint, uint);
    return (cast(FP) fn)(a1, a2);
}

pragma(mangle, "cbc4")
extern(Windows) uint cbc4(uint fn, uint a1, uint a2, uint a3, uint a4) {
    alias FP = extern(C) uint function(uint, uint, uint, uint);
    return (cast(FP) fn)(a1, a2, a3, a4);
}

pragma(mangle, "cbw2_chk")
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
}
