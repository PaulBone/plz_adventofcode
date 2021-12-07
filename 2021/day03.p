/*
 * vim: ft=plasma
 * This is free and unencumbered software released into the public domain.
 * See LICENSE
 */

module Day03

import Util
import Lib

entrypoint
func main() uses IO -> Int {
    var lines = Util.readlines!()

    match (lines) {
        [] -> {
            print!("No input\n")
            return 1
        }
        [var first_line | _] -> {
            var num_digits = Lib.string_length(first_line)
            var numbers = Lib.map(Lib.string_to_binary, lines)
            var num_entries = Lib.length(lines)

            part1!(num_entries, numbers, num_digits)

            return 0
        }
    }
}

func part1(num_entries : Int, numbers : List(Int), num_bits : Int) uses IO {
    var counts = Lib.foldl(count_bits, numbers,
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
    var most_common = Lib.map(is_common, counts)
    
    // The bits are actually in LSB order because that's the direction of
    // the loop in count_bits.
    func gamma_bit(bit : Int, shift : Int, acc : Int) -> (Int, Int) {
        return shift + 1, acc + Builtin.int_lshift(bit, shift)
    }
    _, var gamma = Lib.foldl2(gamma_bit, most_common, 0, 0)
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
    var counts, _ = Lib.map_fold(count_bit, counts0, 0)
    return counts
}

