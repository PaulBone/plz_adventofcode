/*
 * vim: ft=plasma
 * This is free and unencumbered software released into the public domain.
 * See LICENSE
 */

module Day07

import Int
import Util
import List
import String

entrypoint
func main() uses IO -> Int {
    var numbers = List.map(String.string_to_int, Util.read_comma_list!())

    var total = List.length(numbers)
    print!("Crabs: " ++ int_to_string(total) ++ "\n")
    var average = List.foldl(Builtin.int_add, numbers, 0) /
        total
    print!("Average position: " ++ int_to_string(average) ++ "\n")
    func loop(min : Int, max : Int) uses IO -> Int {
        if (min == max) {
            return min
        } else if max - min <= 3 {
            // Search the range exhaustively.
            var min_fuel = calculate_fuel(numbers, min)
            var mid1_fuel = calculate_fuel(numbers, min + 1)
            var mid2_fuel = calculate_fuel(numbers, min + 2)
            var max_fuel = calculate_fuel(numbers, max)
            print!("Range is " ++ String.join(" - ",
                List.map(int_to_string, [min, max])) ++ "\n")
            print!("Fuel is " ++ String.join(", ",
                List.map(int_to_string,
                         [min_fuel, mid1_fuel, mid2_fuel, max_fuel]))
                ++ "\n")

            var best1
            var best1_fuel
            if (min_fuel < mid1_fuel) {
                best1 = min
                best1_fuel = min_fuel
            } else {
                best1 = min + 1
                best1_fuel = mid1_fuel
            }

            var best2
            var best2_fuel
            if (mid2_fuel < max_fuel) {
                best2 = min + 2
                best2_fuel = mid2_fuel
            } else {
                best2 = max
                best2_fuel = max_fuel
            }

            if (best1_fuel < best2_fuel) {
                return best1
            } else {
                return best2
            }
        } else {
            // Divide the search space into thirds and compare the two
            // centre points.
            var third = (max - min) / 3
            var mid1 = min + third
            var mid2 = mid1 + third
            var mid1_fuel = calculate_fuel(numbers, mid1)
            var mid2_fuel = calculate_fuel(numbers, mid2)
            print!("Range is " ++ String.join(", ",
                List.map(int_to_string, [min, mid1, mid2, max])) ++ "\n")
            print!("Fuel for midpoints is " ++ int_to_string(mid1_fuel) ++
                ", " ++ int_to_string(mid2_fuel) ++ "\n")

            // Depending on the fuel at the two midpoints we choose which
            // 2/3rds of the range to explore next
            if mid1_fuel == mid2_fuel {
                return loop!(mid1, mid2)
            } else if mid1_fuel < mid2_fuel {
                return loop!(min, mid2)
            } else {
                return loop!(mid1, max)
            }
        }
    }
    var initial_min = List.foldl(Int.min, numbers, 0)
    var initial_max = List.foldl(Int.max, numbers, 0)
    var answer = loop!(initial_min, initial_max)

    print!("Most optimal position is " ++ int_to_string(answer) ++ 
        " for " ++ int_to_string(calculate_fuel(numbers, answer)) ++ " fuel\n")

    return 0
}

func calculate_fuel(numbers : List(Int), pos : Int) -> Int {
    func abs_dist(x : Int) -> Int {
        var dist = x - pos
        return if dist < 0 then -dist else dist 
    }

    return List.foldl(Builtin.int_add, List.map(abs_dist, numbers), 0)
}

