import gleam/int
import gleam/string
import gleam/list
import gleam/result.{try}
import util

pub fn run(lines: List(String)) {
  use cals <- try(
    lines
    |> list.map(get_cal_line)
    |> util.map_error_lineno
    |> result.all,
  )

  cals
  |> list.fold(0, int.add)
  |> Ok
}

fn get_cal_line(line: String) -> Result(Int, String) {
  let chars = string.to_graphemes(line)

  use first <- try(
    list.find_map(chars, int.parse)
    |> result.replace_error("could not find first digit"),
  )
  use last <- try(
    list.reverse(chars)
    |> list.find_map(int.parse)
    |> result.replace_error("could not find last digit"),
  )

  first * 10 + last
  |> Ok
}
