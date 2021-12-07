/*
 * vim: ft=plasma
 * This is free and unencumbered software released into the public domain.
 * See LICENSE
 */

module Int

export
func min(a : Int, b : Int) -> Int {
    return if a < b then a else b
}

export
func max(a : Int, b : Int) -> Int {
    return if a > b then a else b
}

