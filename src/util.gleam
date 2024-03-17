import gleam/io
import gleam/int
import gleam/string
import gleam/list
import gleam/result.{try}
import simplifile.{read}

pub fn trim_prefix(input: String, prefix: String) -> Result(String, Nil) {
  case string.starts_with(input, prefix) {
    False -> Error(Nil)
    True -> Ok(string.drop_left(input, string.length(prefix)))
  }
}

pub fn pop_first(input: List(a)) -> Result(#(a, List(a)), Nil) {
  use first <- try(list.first(input))
  use rest <- try(list.rest(input))
  Ok(#(first, rest))
}

pub fn parse_int(s: String) -> Result(Int, String) {
  case int.parse(s) {
    Ok(i) -> Ok(i)
    Error(_) -> Error("Could not parse int: " <> s)
  }
}

pub fn tap_inspect(input: a) -> a {
  io.println(string.inspect(input))
  input
}

pub fn tap(input: List(a), func: fn(a) -> b) -> List(a) {
  input
  |> list.each(func)
  input
}

pub fn index_tap(input: List(a), func: fn(a, Int) -> b) -> List(a) {
  let _ =
    input
    |> list.index_map(func)
  input
}

pub fn unwrap_assert(result: Result(a, b)) -> a {
  case result {
    Ok(x) -> x
    err -> {
      let assert Ok(_) = err
      panic
    }
  }
}

pub fn map_error_lineno(
  input: List(Result(a, String)),
) -> List(Result(a, String)) {
  input
  |> list.index_map(fn(res, i) {
    case res {
      Error(msg) ->
        Error(string.concat(["Input line ", int.to_string(i + 1), ": ", msg]))
      Ok(val) -> Ok(val)
    }
  })
}

pub fn print_result(res: Result(Int, String)) -> Nil {
  res
  |> result.map(int.to_string)
  |> result.unwrap_both
  |> io.println
}

pub fn get_day_input(day: Int) -> List(String) {
  let day = string.pad_left(int.to_string(day), 2, "0")
  let assert Ok(lines) =
    read_lines(string.concat(["./inputs/input", day, ".txt"]))
  lines
}

pub fn read_lines(filename: String) {
  read(filename)
  |> result.map(string.trim)
  |> result.map(split_lines)
}

pub fn split_lines(text: String) {
  string.split(text, on: "\n")
  |> list.map(string.trim)
}
