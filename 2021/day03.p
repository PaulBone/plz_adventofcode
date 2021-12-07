/*
 * vim: ft=plasma
 * Copyright (C) 2021 Paul Bone
 * Distributed under the terms of the MIT License see LICENSE
 */

module Day03

import Util
import List
import String

entrypoint
func main() uses IO -> Int {
    var lines = Util.readlines!()

    match (lines) {
        [] -> {
            print!("No input\n")
            return 1
        }
        [var first_line | _] -> {
            var num_digits = String.string_length(first_line)
            var numbers = List.map(String.string_to_binary, lines)
            var num_entries = List.length(lines)

            part1!(num_entries, numbers, num_digits)
            part2!(numbers, num_digits)

            return 0
        }
    }
}

func part1(num_entries : Int, numbers : List(Int), num_bits : Int) uses IO {
    var counts = List.foldl(count_bits, numbers,
        Util.repeat(num_bits, 0))

    func is_common(num_ones : Int) -> Int {
        var num_zeros = num_entries - num_ones
        // Ties?!
        if num_ones >= num_zeros {
            return 1
        } else {
            return 0
        }
    }
    var most_common = List.map(is_common, counts)
    
    // The bits are actually in LSB order because that's the direction of
    // the loop in count_bits.
    func gamma_bit(bit : Int, shift : Int, acc : Int) -> (Int, Int) {
        return shift + 1, acc + Builtin.int_lshift(bit, shift)
    }
    _, var gamma = List.foldl2(gamma_bit, most_common, 0, 0)
    print!("gamma: " ++ int_to_string(gamma) ++ "\n")

    // Epsilon is the 1's compliement masked down.
    var epsilon = Builtin.int_and(
        Builtin.int_comp(gamma),
        Builtin.int_lshift(1, num_bits) - 1
    )
    print!("epsilon: " ++ int_to_string(epsilon) ++ "\n")
    print!("product: " ++ int_to_string(gamma * epsilon) ++ "\n")
}

func count_bits(num : Int, counts0 : List(Int)) -> List(Int) {
    func count_bit(count : Int, bit : Int) -> (Int, Int) {
        // Later these will be in an Int module.
        var this_bit =
            Builtin.int_rshift(Builtin.int_and(num, Builtin.int_lshift(1, bit)),
            bit)
        return count + this_bit, bit + 1
    }
    var counts, _ = List.map_fold(count_bit, counts0, 0)
    return counts
}

func part2(numbers0 : List(Int), num_bits : Int) uses IO {
    func find_rating(rating : Rating, numbers : List(Int), bit : Int) uses IO
        -> Int
    {
        match (numbers) {
          [] -> {
            Builtin.die("Unexpected")
            return 0
          }
          [var n | var ns] -> {
            match (ns) {
              [] -> {
                // There's exactly one number left.
                return n
              }
              [_ | _] -> {
                // Continue the filtering.
                var critera = make_critera!(rating, numbers, bit)
                return find_rating!(rating, List.filter(critera, numbers),
                    bit-1)
              }
            }
          }
        }
    }

    var oxygen = find_rating!(Oxygen, numbers0, num_bits)
    print!("Oxygen rating: " ++ int_to_string(oxygen) ++ "\n")
    var co2 = find_rating!(CO2, numbers0, num_bits)
    print!("CO2 rating: " ++ int_to_string(co2) ++ "\n")
    print!("Product: " ++ int_to_string(oxygen * co2) ++ "\n")
}

type Rating = Oxygen
            | CO2

func make_critera(rating : Rating, numbers : List(Int), bit : Int) uses IO
        -> (func(Int) -> Bool)
{
    var num_entries = List.length(numbers)

    func count_bit(num : Int, c : Int) -> Int {
        var this_bit = Builtin.int_rshift(
                Builtin.int_and(num, Builtin.int_lshift(1, bit - 1)),
                bit - 1)
        return c + this_bit
    }
    var num_ones = List.foldl(count_bit, numbers, 0)
    var num_zeros = num_entries - num_ones
    var mask = Builtin.int_lshift(1, bit - 1)
    var test = match (rating) {
        Oxygen -> if num_ones >= num_zeros then mask else 0
        CO2 -> if num_ones < num_zeros then mask else 0
    }

    func pred(num : Int) -> Bool {
        return test == Builtin.int_and(num, mask)
    }
    return pred
}

