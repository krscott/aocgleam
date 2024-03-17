import gleam/int
import gleam/regex
import gleam/string
import gleam/list
import gleam/result.{try}
import util

pub fn run(lines: List(String)) {
  use lines <- try(
    lines
    |> list.map(parse_line)
    |> result.all,
  )

  lines
  |> list.fold(0, int.add)
  |> Ok
}

fn parse_line(line: String) {
  use #(_card, data) <- try(
    string.split_once(line, ":")
    |> result.replace_error("Expected ':'"),
  )
  use #(winning, yours) <- try(
    string.split_once(data, "|")
    |> result.replace_error("Expected '|'"),
  )

  let assert Ok(re_spaces) = regex.from_string("\\s+")
  use winning <- try(
    winning
    |> string.trim
    |> regex.split(re_spaces, _)
    |> list.map(util.parse_int)
    |> util.map_error_lineno
    |> result.all,
  )
  use yours <- try(
    yours
    |> string.trim
    |> regex.split(re_spaces, _)
    |> list.map(util.parse_int)
    |> util.map_error_lineno
    |> result.all,
  )

  yours
  |> list.filter(fn(n) { list.contains(winning, n) })
  |> list.fold(0, fn(acc, _) {
    case acc {
      0 -> 1
      n -> n * 2
    }
  })
  |> Ok
}
