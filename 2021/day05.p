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

    func loop_y(y : Int, count_y1 : Int, count_y2 : Int) uses IO -> (Int, Int) {
        func loop_x(x : Int, count_x1 : Int, count_x2 : Int) uses IO ->
            (Int, Int)
        {
            if x <= max_coord {
                var count_1, var count_2 = num_lines_crossing(x, y, lines)
                // For debugging
                // print!(if count == 0 then "." else int_to_string(count))
                return loop_x!(x + 1,
                    (if count_1 >= 2 then 1 else 0) + count_x1,
                    (if count_2 >= 2 then 1 else 0) + count_x2)
            } else {
                return count_x1, count_x2
            }
        }

        if y <= max_coord {
            var count_x1, var count_x2 = loop_x!(0, 0, 0)
            print!(int_to_string(y) ++ "/" ++ int_to_string(max_coord) ++ "\n")
            // print!("\n")
            return loop_y!(y + 1, count_y1 + count_x1, count_y2 + count_x2)
        } else {
            return count_y1, count_y2
        }
    }
    var part_1, var part_2 = loop_y!(0, 0, 0)
    print!("There are " ++ int_to_string(part_1) ++
        " places where straight vents cross\n")
    print!("There are " ++ int_to_string(part_2) ++
        " places where all vents cross\n")

    return 0
}

func num_lines_crossing(x : Int, y : Int, lines : List(Line)) -> (Int, Int) {
    func sum_line_cross(line : Line, c1 : Int, c2 : Int) -> (Int, Int) {
        return match (point_on_line(x, y, line)) {
            Straight  -> c1 + 1, c2 + 1
            Diag      -> c1,     c2 + 1
            NotOnLine -> c1,     c2
        }
    }
    return List.foldl2(sum_line_cross, lines, 0, 0)
}

type Point = Point(x : Int, y : Int)
type Line = Line(a : Point, b : Point)

func between(a : Int, x : Int, b : Int) -> Bool {
    return a <= b and a <= x and x <= b or
           b <  a and b <= x and x <= a
}

// If a point is on a line return the type of line.
type PointOnLine = Straight
                 | Diag
                 | NotOnLine

func point_on_line(x : Int, y : Int, l : Line) -> PointOnLine {
    Line(var a, var b) = l
    Point(var ax, var ay) = a
    Point(var bx, var by) = b

    // Only include vertical and horizontal lines
    if ax == bx {
        return if x == ax and between(ay, y, by)
            then Straight
            else NotOnLine
    } else if ay == by {
        return if y == ay and between(ax, x, bx)
            then Straight
            else NotOnLine
    } else {
        var r
        if (ax < bx) {
            if ax <= x and x <= bx {
                var diff = x - ax
                r = ay <= by and ay + diff == y or
                    by < ay and ay - diff == y
            } else {
                r = False
            }
        } else {
            if bx <= x and x <= ax {
                var diff = x - bx
                r = by < ay and by + diff == y or
                    ay <= by and by - diff == y
            } else {
                r = False
            }
        }
        return if r then Diag else NotOnLine
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

