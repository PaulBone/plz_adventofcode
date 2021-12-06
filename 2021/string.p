/*
 * vim: ft=plasma
 * This is free and unencumbered software released into the public domain.
 * See LICENSE
 */

/*
 * Functions used here that should be part of a standard library.
 */
module String 

export
func string_to_int(s : String) -> Int {
    func loop(pos : StringPos, num : Int) -> Int {
        var maybe_cp = strpos_next(pos)
        match (maybe_cp) {
            None -> {
                // End of input.
                return num
            }
            Some(var cp) -> {
                var maybe_digit = codepoint_to_digit(cp)
                match (maybe_digit) {
                    Some(var digit) -> {
                        return loop(strpos_forward(pos), num * 10 + digit)
                    }
                    None -> {
                        // Could make this function return a maybe.
                        Builtin.die("Bad number")
                        return 0
                    }
                }
            }
        }
    }
    return loop(string_begin(s), 0)
}

func codepoint_to_digit(cp : CodePoint) -> Maybe(Int) {
    var s = codepoint_to_string(cp)
    // This isn't efficient.
    if (string_equals(s, "0")) {
        return Some(0)
    } else if (string_equals(s, "1")) {
        return Some(1)
    } else if (string_equals(s, "2")) {
        return Some(2)
    } else if (string_equals(s, "3")) {
        return Some(3)
    } else if (string_equals(s, "4")) {
        return Some(4)
    } else if (string_equals(s, "5")) {
        return Some(5)
    } else if (string_equals(s, "6")) {
        return Some(6)
    } else if (string_equals(s, "7")) {
        return Some(7)
    } else if (string_equals(s, "8")) {
        return Some(8)
    } else if (string_equals(s, "9")) {
        return Some(9)
    } else {
        return None
    }
}

export
func advance_to(check : func(CodePoint) -> Bool, p : StringPos) -> StringPos {
    // Advance until there's whitespace.
    var next = strpos_next(p)
    match (next) {
        None -> {
            // It's the end of the first token, because there's nothing
            // left in the string.
            return p
        }
        Some(var cp) -> {
            if (check(cp)) {
                // It's the end of the first token, we found a space.
                return p
            } else {
                return advance_to(check, strpos_forward(p))
            }
        }
    }
}

export
func concat_list(l : List(String)) -> String {
    return match (l) {
        [] -> ""
        [var x | var xs] -> x ++ concat_list(xs)
    }
}

