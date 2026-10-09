# -*- coding: utf-8 -*-
"""
knowledge_access.py — ленивый singleton-доступ к базе знаний Qt.

get_knowledge() -> QtKnowledge | None
  - при первом вызове пытается загрузить knowledge/qt_knowledge.json;
  - файл отсутствует или битый -> возвращает None (генератор работает
    на прежних эвристиках, без падений);
  - результат кешируется (включая None — повторных попыток чтения нет).
"""

_CACHE = {"loaded": False, "kb": None}


def get_knowledge():
    """Возвращает QtKnowledge или None, если база знаний недоступна."""
    if _CACHE["loaded"]:
        return _CACHE["kb"]
    _CACHE["loaded"] = True
    try:
        # Ленивый импорт: qt_knowledge тянет qt_parser и не нужен,
        # когда JSON отсутствует.
        from qt_knowledge import load_knowledge
        _CACHE["kb"] = load_knowledge()
    except FileNotFoundError:
        _CACHE["kb"] = None
    except Exception:
        # Битый JSON / несовместимая версия — не роняем генератор.
        _CACHE["kb"] = None
    return _CACHE["kb"]


def reset_knowledge_cache():
    """Сброс кеша (для тестов)."""
    _CACHE["loaded"] = False
    _CACHE["kb"] = None
