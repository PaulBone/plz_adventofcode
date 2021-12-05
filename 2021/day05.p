/*
 * vim: ft=plasma
 * This is free and unencumbered software released into the public domain.
 * See LICENSE
 */

module Day05

import List
import String

import Util

entrypoint
func main() uses IO -> Int {
    var lines0 = Util.readlines!()
    var lines = List.map(parse_line, lines0)

    var max_coord = List.foldl(max, List.map(max_in_line, lines), 0)

    func loop_y(y : Int, count_y : Int) uses IO -> Int {
        func loop_x(x : Int, count_x : Int) uses IO -> Int {
            if x <= max_coord {
                var count = num_lines_crossing(x, y, lines)
                return loop_x!(x + 1,
                    (if count >= 2 then 1 else 0) + count_x) 
            } else {
                return count_x
            }
        }

        if y <= max_coord {
            var count_x = loop_x!(0, 0)
            print!(int_to_string(y) ++ "/" ++ int_to_string(max_coord) ++ "\n")
            return loop_y!(y + 1, count_y + count_x)
        } else {
            return count_y
        }
    }
    var num_crosses = loop_y!(0, 0)
    print!("There are " ++ int_to_string(num_crosses) ++
        " places where vents cross\n")

    return 0
}

func num_lines_crossing(x : Int, y : Int, lines : List(Line)) -> Int {
    func sum_line_cross(line : Line, c : Int) -> Int {
        return c + (if does_line_cross(x, y, line) then 1 else 0)
    }
    return List.foldl(sum_line_cross, lines, 0)
}

type Point = Point(x : Int, y : Int)
type Line = Line(a : Point, b : Point)

func between(a : Int, x : Int, b : Int) -> Bool {
    return a <= b and a <= x and x <= b or
           b <  a and b <= x and x <= a
}

func does_line_cross(x : Int, y : Int, l : Line) -> Bool {
    Line(var a, var b) = l
    Point(var ax, var ay) = a
    Point(var bx, var by) = b

    // Only include vertical and horizontal lines
    if (ax == bx and x == ax) {
        return between(ay, y, by)
    } else if (ay == by and y == ay) {
        return between(ax, x, bx)
    } else {
        return False
    }
}

func parse_line(string : String) -> Line {
    var end_of_a = String.advance_to(Util.whitespace, string_begin(string))
    var start_of_b = String.advance_to(Util.not_whitespace, 
        String.advance_to(Util.whitespace, strpos_forward(end_of_a)))

    var a = string_substring(string_begin(string), end_of_a)
    var b = string_substring(start_of_b, string_end(string))

    return Line(parse_coord(a), parse_coord(b))
}

func is_comma(cp : CodePoint) -> Bool {
    return string_equals(",", codepoint_to_string(cp))
}

func parse_coord(string : String) -> Point {
    var end_of_x = String.advance_to(is_comma, string_begin(string))
    var start_of_y = strpos_forward(end_of_x)

    var x = string_substring(string_begin(string), end_of_x)
    var y = string_substring(start_of_y, string_end(string))

    return Point(String.string_to_int(x), String.string_to_int(y))
}

func max_in_line(l : Line) -> Int {
    Line(var a, var b) = l
    return max(max_in_point(a), max_in_point(b))
}

func max_in_point(p : Point) -> Int {
    Point(var x, var y) = p
    return max(x, y)
}

func max(a : Int, b : Int) -> Int {
    return if a > b then a else b
}

