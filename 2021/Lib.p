/*
 * vim: ft=plasma
 * This is free and unencumbered software released into the public domain.
 * See LICENSE
 */

/*
 * Functions used here that should be part of a standard library.
 */
module Lib

export
func reverse(list : List('x)) -> List('x) {
    func loop(acc : List('x), input : List('x)) -> List('x) {
        return match (input) {
            [] -> acc
            [var x | var xs] -> loop([x | acc], xs)
        }
    }
    return loop([], list)
}

export
func map(f : func('x) -> 'y, l : List('x)) -> List('y) {
    return match (l) {
        [] -> []
        [var x | var xs] -> [f(x) | map(f, xs)]
    }
}

export
func foldl2(f : func('x, 'a, 'b) -> ('a, 'b), l : List('x), a : 'a, b : 'b)
    -> ('a, 'b)
{
    match (l) {
        [] -> {
            return a, b
        }
        [var x | var xs] -> {
            var a1, var b1 = f(x, a, b)
            return foldl2(f, xs, a1, b1)
        }
    }
}

export
func foldl3(f : func('x, 'a, 'b, 'c) -> ('a, 'b, 'c), l : List('x),
    a : 'a, b : 'b, c : 'c) -> ('a, 'b, 'c)
{
    match (l) {
        [] -> {
            return a, b, c
        }
        [var x | var xs] -> {
            var a1, var b1, var c1 = f(x, a, b, c)
            return foldl3(f, xs, a1, b1, c1)
        }
    }
}

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

