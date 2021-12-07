/*
 * vim: ft=plasma
 * Copyright (C) 2021 Paul Bone
 * Distributed under the terms of the MIT License see LICENSE
 */

/*
 * Functions used here that should be part of a standard library.
 */

module List

export
func length(list : List('x)) -> Int {
    func loop(l0 : List('x), a : Int) -> Int {
        return match (l0) {
            [] -> a
            [_ | var l] -> loop(l, a + 1)
        }
    }
    return loop(list, 0)
}

export
func append(a : List('x), b : List('x)) -> List('x) {
    return reverse_acc(reverse(a), b)
}

func reverse_acc(input : List('x), acc : List('x)) -> List('x) {
    return match (input) {
        [] -> acc
        [var x | var xs] -> reverse_acc(xs, [x | acc])
    }
}

export
func reverse(list : List('x)) -> List('x) {
    return reverse_acc(list, [])
}

export
func map(f : func('x) -> 'y, l : List('x)) -> List('y) {
    return match (l) {
        [] -> []
        [var x | var xs] -> [f(x) | map(f, xs)]
    }
}

export
func map_fold(f : func('x, 'a) -> ('y, 'a), l : List('x), a : 'a)
    -> (List('y), 'a)
{
    match (l) {
        [] -> {
            return [], a
        }
        [var x | var xs] -> {
            var y, var a1 = f(x, a)
            var ys, var a2 = map_fold(f, xs, a1)
            return [y | ys], a2
        }
    }
}

export
func foldl(f : func('x, 'a) -> ('a), l : List('x), a : 'a) -> 'a {
    match (l) {
        [] -> {
            return a
        }
        [var x | var xs] -> {
            var a1 = f(x, a)
            return foldl(f, xs, a1)
        }
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
func filter(p : func('t) -> Bool, list : List('t)) -> List('t) {
    match (list) {
        [] -> {
            return []
        }
        [var x | var xs] -> {
            var rest = filter(p, xs)
            if (p(x)) {
                return [x | rest]
            } else {
                return rest
            }
        }
    }
}

export
func replicate(item : 't, num : Int) -> List('t) {
    return if num == 0
        then []
        else [item | replicate(item, num - 1)] 
}

