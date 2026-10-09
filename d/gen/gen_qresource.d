/**
 * gen_qresource.d — D bindings for Qt resource system (QResource).
 *
 * Wraps the two static QResource methods needed to load/unload
 * external .rcc binary files at runtime:
 *
 *   registerRcc("myapp.rcc");           // load binary resource archive
 *   // now ":/images/icon.png" etc. are accessible via QFile, QPixmap, ...
 *   unregisterRcc("myapp.rcc");         // release
 *
 * Indices: 19810–19811 (qte56_resource.dll)
 */
module gen_qresource;

import qte56_core;
import qte56_loader : loadFn, registerModule;
import gen_qcore : t_i__qp_qp, t_v__qp, toQString;

// ── Alias: int function(void*, int, void*, int) ───────────────────────────────

// ── Load ─────────────────────────────────────────────────────────────────────

void loadQResource() {
    mixin(generateFunQt(19810, "qteQResource_registerResource",   "QResource"));
    mixin(generateFunQt(19811, "qteQResource_unregisterResource", "QResource"));
}

static this() {
    registerModule("QResource", "qte56_resource.dll", &loadQResource);
}

// ── Helpers used by qte56_resource.d ─────────────────────────────────────────

/// Low-level: register a binary .rcc file.
/// mapRoot — virtual prefix in resource tree, usually "/".
int _resourceRegister(string path, string mapRoot) {
    auto wp = toQString(path);
    auto wr = mapRoot.length > 0 ? toQString(mapRoot) : null;
    auto result = cast(int)(cast(t_i__qp_qp)pFunQt[19810])(wp, wr);
    (cast(t_v__qp)pFunQt[22])(wp);
    if (wr !is null) (cast(t_v__qp)pFunQt[22])(wr);
    return result;
}

/// Low-level: unregister a binary .rcc file.
int _resourceUnregister(string path, string mapRoot) {
    auto wp = toQString(path);
    auto wr = mapRoot.length > 0 ? toQString(mapRoot) : null;
    auto result = cast(int)(cast(t_i__qp_qp)pFunQt[19811])(wp, wr);
    (cast(t_v__qp)pFunQt[22])(wp);
    if (wr !is null) (cast(t_v__qp)pFunQt[22])(wr);
    return result;
}
