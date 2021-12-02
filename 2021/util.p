/*
 * vim: ft=plasma
 * This is free and unencumbered software released into the public domain.
 * See LICENSE
 */

/*
 * Functions required by several of the AOC problems.
 */
module Util

import Lib

export
func readlines() uses IO -> List(String) {
    // Plasma doesn't support loops yet.
    func loop(xs : List(String)) uses IO -> List(String) {
        var line = readline!()
        // Plasma can't use == for string equality yet.
        if (string_equals("", line)) {
            return xs
        } else {
            return loop!([line | xs])
        }
    }

    return Lib.reverse(loop!([]))
}

export
func whitespace(cp : CodePoint) -> Bool {
    // TODO: Plasma should have a faster way to do this that doesn't
    // allocate a new string.
    return string_equals(codepoint_to_string(cp), " ")
}

export
func not_whitespace(cp : CodePoint) -> Bool {
    return not whitespace(cp)
}

