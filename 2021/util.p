/*
 * vim: ft=plasma
 * This is free and unencumbered software released into the public domain.
 * See LICENSE
 */

/*
 * Functions required by several of the AOC problems.
 */
module Util

import List
import String

export
func readlines() uses IO -> List(String) {
    // Plasma doesn't support loops yet.
    func loop(xs : List(String)) uses IO -> List(String) {
        match (readline!()) {
            EOF -> {
                return xs
            }
            Ok(var line) -> {
                return loop!([line | xs])
            }
        }
    }

    return List.reverse(loop!([]))
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

export
func read_lines_until_blank() uses IO -> IOResult(List(String)) {
    func loop(acc : List(String)) uses IO -> IOResult(List(String)) {
        match (readline!()) {
            EOF -> {
                return match (acc) {
                    [] -> EOF
                    [_ | _] -> Ok(List.reverse(acc))
                }
            }
            Ok(var line) -> {
                return if (string_equals("", line))
                    then Ok(List.reverse(acc))
                    else loop!([line | acc])
            }
        }
    }
    return loop!([])
}

// list_range(1, 5) generates [1, 2, 3, 4, 5]
// XXX Unused
export
func list_range(min : Int, max : Int) -> List(Int) {
    func loop(n : Int, l : List(Int)) -> List(Int) {
        if (n == min) {
            return [n | l]
        } else {
            return loop(n - 1, [n | l])
        }
    }
    return loop(max, [])
}

export
func repeat(times : Int, thing : 't) -> List('t) {
    if (times > 0) {
        return [thing | repeat(times - 1, thing)]
    } else {
        return []
    }
}

export
func do(f : func('x) uses IO, l : List('x)) uses IO {
    match (l) {
        [] -> {}
        [var x | var xs] -> {
            f!(x)
            do!(f, xs)
        }
    }
}

export
func print_int(i : Int) uses IO {
    print!(int_to_string(i) ++ "\n")
}

func is_comma(cp : CodePoint) -> Bool {
    return string_equals(codepoint_to_string(cp), ",")
}
func not_curry(f : func('a) -> Bool) -> (func('a) -> Bool) {
    func not_f(x : 'a) -> Bool {
        return not f(x)
    }
    return not_f
}

func split_at(split : func(CodePoint) -> Bool, string : String) 
    -> List(String)
{
    func loop(pos0 : StringPos, acc : List(String)) -> List(String) {
        match (strpos_next(pos0)) {
            None -> {
                return List.reverse(acc)
            }
            Some(_) -> {
                var pos1 = String.advance_to(split, pos0)
                var str = string_substring(pos0, pos1)
                var pos2 = String.advance_to(not_curry(split), pos1)
                return loop(pos2, [str | acc])
            }
        }
    }

    return loop(string_begin(string), [])
}

export
func read_comma_list() uses IO -> List(String) {
    var string = String.concat_list(readlines!())
    return split_at(is_comma, string)
}

