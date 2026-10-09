"""
geninfo.py — блок GENERATOR-INFO: рабочая информация генератора
в генерируемых файлах.

Позволяет восстановить, как именно генерировался класс (ключи, источник
d_parent, версия knowledge) и что было пропущено (очередь задач для type_map).
"""

import os
import re
import sys

from qt_parser import QtClass

GENERATOR_VERSION = "2.1.0-knowledge"

INFO_START = "===GENERATOR-INFO-START==="
INFO_END   = "===GENERATOR-INFO-END==="


def _build_gen_info(cls_name: str, header: str, args, d_parent: str,
                    d_parent_source: str, qt_class: QtClass,
                    specs: list, signals: list, indices: list,
                    tracked: bool) -> dict:
    """Собирает рабочую информацию запуска генератора."""
    import datetime
    info = {}
    info["generator"] = f"main.py {GENERATOR_VERSION}"
    info["timestamp"] = datetime.datetime.now().isoformat(timespec="seconds")
    info["command"]   = "python " + " ".join(sys.argv)
    info["header"]    = header
    m = re.search(r"[\\/]([56]\.\d+\.\d+)[\\/]", header)
    info["qt"]        = m.group(1) if m else "unknown"
    info["module"]    = args.module or cls_name
    info["dll"]       = args.dll or f"qte56_{cls_name.lower()}.dll"
    info["d_parent"]  = (f"{d_parent} ({d_parent_source})" if d_parent
                         else "(root class)")
    if args.index_start is not None:
        info["index_block"] = f"{args.index_start} (--index-start)"
    elif indices:
        info["index_block"] = f"{min(indices)} (auto)"
    if indices:
        info["index_range"] = f"{min(indices)}-{max(indices)}"
    # Версия базы знаний
    from knowledge_access import get_knowledge
    kb = get_knowledge()
    if kb is not None:
        try:
            kb_json = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                   "knowledge", "qt_knowledge.json")
            mt = datetime.datetime.fromtimestamp(os.path.getmtime(kb_json))
            info["knowledge"] = f"qt_knowledge.json {mt.isoformat(timespec='seconds')}"
        except OSError:
            info["knowledge"] = "loaded"
    else:
        info["knowledge"] = "NONE (fallback heuristics)"
    info["methods"]   = (f"{len(specs)} wrapper(s), {len(signals)} signal(s), "
                         f"lifecycle={'tracked' if tracked else 'no'}")
    # Пропущенные публичные методы/сигналы с причинами (очередь для type_map)
    skipped = []
    for mth in qt_class.methods:
        if mth.is_supported or mth.is_protected:
            continue
        if not mth.unsupported_reason:
            continue
        kind = "signal" if mth.is_signal else "method"
        params = ", ".join(p.cpp_type for p in mth.params)
        skipped.append(f"{mth.ret_type} {mth.name}({params}) [{kind}]"
                       f" — {mth.unsupported_reason}")
    info["skipped"] = skipped
    return info


def _render_info_block(info: dict, comment: str = "//") -> str:
    """Рендерит блок GENERATOR-INFO строками с префиксом комментария."""
    lines = [f"{comment} {INFO_START}"]
    for key in ("generator", "timestamp", "command", "header", "qt",
                "module", "dll", "d_parent", "index_block", "index_range",
                "knowledge", "methods"):
        if key in info:
            lines.append(f"{comment} {key.replace('_', '-')}: {info[key]}")
    skipped = info.get("skipped") or []
    lines.append(f"{comment} skipped-unsupported: {len(skipped)}")
    for s in skipped[:60]:  # не раздуваем файл без меры
        lines.append(f"{comment}   {s}")
    if len(skipped) > 60:
        lines.append(f"{comment}   ... +{len(skipped) - 60} more")
    lines.append(f"{comment} {INFO_END}")
    return "\n".join(lines)
