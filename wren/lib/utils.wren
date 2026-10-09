// utils.wren — utility classes for Wren scripts
// Usage: import "utils" for StringUtil, MathUtil, ListUtil

class StringUtil {
    static repeat(s, n) {
        var result = ""
        for (i in 0...n) result = result + s
        return result
    }

    static padLeft(s, width, ch) {
        var str = "%(s)"
        if (str.count >= width) return str
        return repeat(ch, width - str.count) + str
    }

    static padRight(s, width, ch) {
        var str = "%(s)"
        if (str.count >= width) return str
        return str + repeat(ch, width - str.count)
    }

    static startsWith(s, prefix) {
        if (s.count < prefix.count) return false
        return s[0...prefix.count] == prefix
    }

    static endsWith(s, suffix) {
        if (s.count < suffix.count) return false
        return s[s.count - suffix.count...s.count] == suffix
    }

    static contains(s, sub) {
        return s.indexOf(sub) != -1
    }

    static split(s, sep) {
        var parts = []
        var start = 0
        while (true) {
            var idx = s.indexOf(sep, start)
            if (idx == -1) {
                parts.add(s[start...s.count])
                break
            }
            parts.add(s[start...idx])
            start = idx + sep.count
        }
        return parts
    }

    static join(list, sep) {
        var result = ""
        for (i in 0...list.count) {
            if (i > 0) result = result + sep
            result = result + "%(list[i])"
        }
        return result
    }

    // Лексикографическое сравнение строк по UTF-8 байтам (a < b).
    // Используется как компаратор для ListUtil.sortBy, т.к. Wren String не реализует '<'.
    // Результат идентичен сравнению строк в D.
    static less(a, b) {
        var ba = a.bytes
        var bb = b.bytes
        var len = a.count < b.count ? a.count : b.count
        var i = 0
        while (i < len) {
            if (ba[i] != bb[i]) return ba[i] < bb[i]
            i = i + 1
        }
        return a.count < b.count
    }
}

// Операции над списками: сортировка и дедупликация.
//
// ListUtil.sort(list)          — quicksort на месте; числа через <, строки через StringUtil.less
// ListUtil.sortBy(list, cmp)   — quicksort с компаратором: cmp.call(a,b) → true если a раньше b
// ListUtil.dedup(list)         — новый список без дублей (порядок первого вхождения)
// ListUtil.sortedUniq(list)    — dedup + sort за один вызов
class ListUtil {
    static sort(list)        { qsCmp_(list, 0, list.count - 1, Fn.new {|a, b| (a is String) ? StringUtil.less(a, b) : a < b}) }
    static sortBy(list, cmp) { qsCmp_(list, 0, list.count - 1, cmp) }

    // Убрать дубли, сохраняя порядок первого вхождения. O(n).
    static dedup(list) {
        var seen = {}
        var result = []
        for (item in list) {
            var key = "%(item)"
            if (!seen.containsKey(key)) {
                seen[key] = true
                result.add(item)
            }
        }
        return result
    }

    // Удобный комбо: сначала dedup, затем sort.
    static sortedUniq(list) {
        var u = dedup(list)
        sort(u)
        return u
    }

    // ── Внутренние методы (суффикс _ = приватные по соглашению) ──────────

    static swap_(list, a, b) {
        var t = list[a]
        list[a] = list[b]
        list[b] = t
    }

    // Quicksort Ломуто с опорным по середине — O(n log n) в среднем,
    // защита от вырожденного O(n²) на уже упорядоченных данных.
    static qsCmp_(list, lo, hi, cmp) {
        if (lo >= hi) return
        var mid = ((lo + hi) / 2).floor
        swap_(list, mid, hi)
        var pivot = list[hi]
        var i = lo
        for (j in lo..hi) {
            if (cmp.call(list[j], pivot)) {
                swap_(list, i, j)
                i = i + 1
            }
        }
        swap_(list, i, hi)
        qsCmp_(list, lo, i - 1, cmp)
        qsCmp_(list, i + 1, hi, cmp)
    }
}

class MathUtil {
    static clamp(val, lo, hi) {
        if (val < lo) return lo
        if (val > hi) return hi
        return val
    }

    static lerp(a, b, t) { a + (b - a) * t }

    static map(val, inLo, inHi, outLo, outHi) {
        var t = (val - inLo) / (inHi - inLo)
        return lerp(outLo, outHi, t)
    }
}
