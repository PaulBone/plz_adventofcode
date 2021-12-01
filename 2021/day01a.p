/*
 * vim: ft=plasma
 * This is free and unencumbered software released into the public domain.
 * See LICENSE
 */

module Day01a

entrypoint func main() uses IO -> Int {
    var lines = readlines!()

    var depths = map(string_to_int, lines)

    func count_increases(ds0 : List(Int), last : Int, count0 : Int) -> Int {
        match (ds0) {
            [] -> {
                return count0
            }
            [var d | var ds] -> {
                var count
                if d > last {
                    count = count0 + 1
                } else {
                    count = count0
                }
                return count_increases(ds, d, count)
            }
        }
    }
    match (depths) {
        [] -> {
            print!("No depths\m")
        }
        [var first_depth | var other_depths0] -> {
            var count = count_increases(other_depths0, first_depth, 0)
            print!("There were " ++ int_to_string(count) ++
                " increases in depth\n")
            // Nested pattern matching is unsupported
            match (other_depths0) {
                [] -> {
                    print!("Only one depth\n")
                }
                [var second_depth | var other_depths1] -> {
                    match (other_depths1) {
                        [] -> {
                            print!("Only two depths\n")
                        }
                        [var third_depth | var other_depths2] -> {
                            var first_sum = first_depth + second_depth +
                                third_depth
                            var other_sums = make_sums(other_depths2,
                                second_depth, third_depth)
                            var sum_count = count_increases(other_sums,
                                first_sum, 0)
                            print!("there were " ++ int_to_string(sum_count) ++ 
                                " increases using sliding window method\n")
                        }
                    }
                }
            }
        }
    }

    return 0
}

func make_sums(l : List(Int), a : Int, b : Int) -> List(Int) {
    return match (l) {
        [] -> []
        [var x | var xs] -> [a + b + x | make_sums(xs, b, x)]
    }
}

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

    return reverse(loop!([]))
}

func reverse(list : List('x)) -> List('x) {
    func loop(acc : List('x), input : List('x)) -> List('x) {
        return match (input) {
            [] -> acc
            [var x | var xs] -> loop([x | acc], xs)
        }
    }
    return loop([], list)
}

func map(f : func('x) -> 'y, l : List('x)) -> List('y) {
    return match (l) {
        [] -> []
        [var x | var xs] -> [f(x) | map(f, xs)]
    }
}

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
    // This isn't exposed as a normal function?
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

