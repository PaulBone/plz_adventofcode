/*
 * vim: ft=plasma
 * Copyright (C) 2021 Paul Bone
 * Distributed under the terms of the MIT License see LICENSE
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

    func do_part(label : String,
                 calc_type : CalcType)
        uses IO
    {
        var answer = search!(calc_type, numbers)
        print!(label ++ " most optimal position is " ++
            int_to_string(answer) ++ " for " ++ 
            int_to_string(calculate_fuel(calc_type, numbers, answer)) ++ 
            " fuel\n")
    }
    do_part!("Part 1", Part1)
    do_part!("Part 2", Part2)

    return 0
}

type CalcType = Part1
              | Part2

func calculate_fuel(ct : CalcType, numbers : List(Int), pos : Int) -> Int {
    func part2_dist(steps : Int, fuel : Int) -> Int {
        if (steps > 0) {
            return part2_dist(steps - 1, fuel + 1) + fuel
        } else {
            return 0
        }
    }

    func abs_dist(x : Int) -> Int {
        var dist = x - pos
        return if dist < 0 then -dist else dist 
    }
    
    func part_dist(x : Int) -> Int {
        var dist = abs_dist(x)
        return match (ct) {
            Part1 -> dist
            Part2 -> part2_dist(dist, 1)
        }
    }

    return List.foldl(Builtin.int_add, List.map(part_dist, numbers), 0)
}

// Normally I'd pass a calculation type function in, but it seems that
// between Plasma's function-at-a-type type checking and how it fills in
// resources later that leads to floundering of the type checker.
func search(ct : CalcType, numbers : List(Int)) uses IO -> Int
{
    var debug = False

    func loop(min : Int, max : Int) uses IO -> Int {
        if (min == max) {
            return min
        } else if max - min <= 3 {
            // Search the range exhaustively.
            var min_fuel = calculate_fuel(ct, numbers, min)
            var mid1_fuel = calculate_fuel(ct, numbers, min + 1)
            var mid2_fuel = calculate_fuel(ct, numbers, min + 2)
            var max_fuel = calculate_fuel(ct, numbers, max)
            if debug {
                print!("Range is " ++ String.join(" - ",
                    List.map(int_to_string, [min, max])) ++ "\n")
                print!("Fuel is " ++ String.join(", ",
                    List.map(int_to_string,
                             [min_fuel, mid1_fuel, mid2_fuel, max_fuel]))
                    ++ "\n")
            } else {}

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
            var mid1_fuel = calculate_fuel(ct, numbers, mid1)
            var mid2_fuel = calculate_fuel(ct, numbers, mid2)
            if debug {
                print!("Range is " ++ String.join(", ",
                    List.map(int_to_string, [min, mid1, mid2, max])) ++ "\n")
                print!("Fuel for midpoints is " ++ int_to_string(mid1_fuel) ++
                    ", " ++ int_to_string(mid2_fuel) ++ "\n")
            } else {}

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
    return loop!(initial_min, initial_max)
}

