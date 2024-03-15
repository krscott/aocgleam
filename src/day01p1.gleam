import gleam/io
import gleam/int
import gleam/string
import gleam/list
import gleam/result.{try}
import util.{read_lines, split_lines}

pub fn run() -> Nil {
  let assert Ok(lines) = read_lines("./inputs/input01.txt")
  let assert Ok(cal) = get_calibration(lines)
  cal
  |> int.to_string
  |> io.println
}

pub fn get_calibration(lines: List(String)) {
  use cals <- try(
    lines
    |> list.map(get_cal_line)
    |> result.all,
  )

  list.fold(cals, 0, int.add)
  |> Ok
}

fn get_cal_line(line: String) -> Result(Int, _) {
  let chars = string.to_graphemes(line)

  use first <- try(list.find_map(chars, int.parse))
  use last <- try(
    list.reverse(chars)
    |> list.find_map(int.parse),
  )

  first * 10 + last
  |> Ok
}
