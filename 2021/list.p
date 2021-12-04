/*
 * vim: ft=plasma
 * This is free and unencumbered software released into the public domain.
 * See LICENSE
 */

/*
 * Functions used here that should be part of a standard library.
 */

module List

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

