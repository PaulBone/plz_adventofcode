/*
 * vim: ft=plasma
 * This is free and unencumbered software released into the public domain.
 * See LICENSE
 */

module Day02

import List
import String 

import Util

entrypoint func main() uses IO -> Int {
    var lines = Util.readlines!()
    var commands = List.map(parse_line, lines)

    func part1() uses IO {
        print!("\nPart 1\n------\n\n")
        // if only Plasma already had loops.
        var x, var y = List.foldl2(follow_direction, commands, 0, 0)
        print!("The position is: " ++ int_to_string(x) ++ ", " ++
            int_to_string(y) ++ " whose product is: " ++
            int_to_string(x * y) ++ "\n")
        print!("\n")
    }
    part1!()

    func part2() uses IO {
        print!("\nPart 2\n------\n\n")
        var x, var y, var aim = 
            List.foldl3(follow_direction_2, commands, 0, 0, 0)
        print!("The position is: " ++ int_to_string(x) ++ ", " ++
            int_to_string(y) ++ " whose product is: " ++
            int_to_string(x * y) ++ "\n")
        print!("\n")
    }
    part2!()

    return 0
}

type Command = Command(c_dir : Direction, c_dist : Int)
type Direction = Forward
               | Down
               | Up

func follow_direction(c : Command, x : Int, y : Int) -> (Int, Int) {
    // I'm glad I added this feature!
    Command(var dir, var dist) = c

    return match (dir) {
        Forward -> x + dist, y
        Down    -> x,        y + dist
        Up      -> x,        y - dist
    }
}

// I wish Plasma had named out parameters and state variables.
func follow_direction_2(c : Command, x : Int, y : Int, aim : Int) ->
    (Int, Int, Int)
{
    // I'm glad I added this feature!
    Command(var dir, var dist) = c

    return match (dir) {
        Down    -> x,         y,               aim + dist
        Up      -> x,         y,               aim - dist
        Forward -> x + dist,  y + aim * dist,  aim
    }
}

func parse_line(line : String) -> Command {
    var begin = string_begin(line)
    var pos_ws = String.advance_to(Util.whitespace, begin)
    var dir_str = string_substring(begin, pos_ws)

    var dir
    if (string_equals("forward", dir_str)) {
        dir = Forward
    } else if (string_equals("down", dir_str)) {
        dir = Down
    } else if (string_equals("up", dir_str)) {
        dir = Up
    } else {
        Builtin.die("Unknown direction")
        dir = Up // XXX
    }

    var rest = string_substring(String.advance_to(Util.not_whitespace, pos_ws),
        string_end(line))
    var dist = String.string_to_int(rest)
    return Command(dir, dist)
}

