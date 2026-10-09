// regex.wren — Regular expressions via VBScript.RegExp (COM)
// Usage: import "regex" for Regex, Match

import "ole" for OleObject

class Match {
    construct new(value, index, length) {
        _value = value
        _index = index
        _length = length
    }

    value  { _value }
    index  { _index }
    length { _length }

    toString { _value }
}

class Regex {
    // Create a regex pattern
    // Options: "i" = ignoreCase, "g" = global, "m" = multiline
    construct new(pattern) { init_(pattern, "") }
    construct new(pattern, options) { init_(pattern, options) }

    init_(pattern, options) {
        _re = OleObject.create("VBScript.RegExp")
        if (_re.isNull) Fiber.abort("Cannot create VBScript.RegExp: %(OleObject.lastError)")
        _re.set("Pattern", pattern)
        _re.set("Global", true)
        if (options.contains("i")) _re.set("IgnoreCase", true)
        if (options.contains("m")) _re.set("Multiline", true)
        if (options.contains("g")) {
            _re.set("Global", true)
        }
    }

    // Test if string matches pattern
    test(str) { _re.call("Test", str) }

    // Find all matches, return list of Match objects
    execute(str) {
        var matches = _re.call("Execute", str)
        var results = []
        var count = matches.get("Count")
        var i = 0
        while (i < count) {
            var m = matches.call("Item", i)
            var val = m.get("Value")
            var idx = m.get("FirstIndex")
            var len = m.get("Length")
            m.release()
            results.add(Match.new(val, idx, len))
            i = i + 1
        }
        matches.release()
        return results
    }

    // Find all match strings (convenience)
    findAll(str) {
        var matches = execute(str)
        var result = []
        for (m in matches) {
            result.add(m.value)
        }
        return result
    }

    // Replace matches with replacement string
    replace(str, replacement) {
        return _re.call("Replace", str, replacement)
    }

    // Static convenience: test pattern against string
    static test(pattern, str) {
        var re = Regex.new(pattern)
        var result = re.test(str)
        re.release()
        return result
    }

    // Static convenience: find all matches
    static findAll(pattern, str) {
        var re = Regex.new(pattern)
        var result = re.findAll(str)
        re.release()
        return result
    }

    // Static convenience: replace
    static replace(pattern, str, replacement) {
        var re = Regex.new(pattern)
        var result = re.replace(str, replacement)
        re.release()
        return result
    }

    release() {
        if (!_re.isNull) _re.release()
    }
}
