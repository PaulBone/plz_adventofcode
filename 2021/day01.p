/*
 * vim: ft=plasma
 * This is free and unencumbered software released into the public domain.
 * See LICENSE
 */

module Day01

import List
import String
import Util

entrypoint func main() uses IO -> Int {
    var lines = Util.readlines!()

    var depths = List.map(String.string_to_int, lines)

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

