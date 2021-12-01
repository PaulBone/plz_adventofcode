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

