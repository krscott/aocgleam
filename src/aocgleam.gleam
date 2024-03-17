import gleam/io
import argv
import util
import day01p1
import day01p2
import day02p1
import day02p2
import day03p1
import day03p2

pub fn main() {
  case argv.load().arguments {
    ["1", "1"] -> run(1, day01p1.run)
    ["1", "2"] -> run(1, day01p2.run)
    ["2", "1"] -> run(2, day02p1.run)
    ["2", "2"] -> run(2, day02p2.run)
    ["3", "1"] -> run(3, day03p1.run)
    ["3", "2"] -> run(3, day03p2.run)
    _ -> io.println("Usage: aocgleam <day> <part>")
  }
}

pub fn run(day: Int, func: fn(List(String)) -> Result(Int, String)) -> Nil {
  util.get_day_input(day)
  |> func
  |> util.print_result
}
