import gleam/io
import gleam/int
import gleam/string
import gleam/list
import gleam/result.{try}
import util.{read_lines}

pub fn run() -> Nil {
  let assert Ok(lines) = read_lines("./inputs/input01.txt")
  let assert Ok(cal) = get_calibration(lines)
  cal
  |> int.to_string
  |> io.println
}

pub fn get_calibration(lines: List(String)) -> Result(Int, _) {
  use cals <- try(
    lines
    |> list.map(parse_line)
    |> result.all,
  )

  list.fold(cals, 0, int.add)
  |> Ok
}

fn parse_line(line: String) -> Result(Int, _) {
  let #(_, out) =
    line
    |> string.to_graphemes
    |> list.fold(#("", []), fn(acc, char) {
      let #(partial, digits) = acc
      let partial = string.append(partial, char)
      case get_digit(partial) {
        Ok(d) -> #(partial, list.append(digits, [d]))
        _ -> #(partial, digits)
      }
    })

  use first <- try(list.first(out))
  use last <- try(list.last(out))

  first * 10 + last
  |> Ok
}

fn get_digit(s: String) -> Result(Int, Nil) {
  Error(Nil)
  |> result.try_recover(fn(e) {
    case string.ends_with(s, "1") || string.ends_with(s, "one") {
      True -> Ok(1)
      False -> Error(e)
    }
  })
  |> result.try_recover(fn(e) {
    case string.ends_with(s, "2") || string.ends_with(s, "two") {
      True -> Ok(2)
      False -> Error(e)
    }
  })
  |> result.try_recover(fn(e) {
    case string.ends_with(s, "3") || string.ends_with(s, "three") {
      True -> Ok(3)
      False -> Error(e)
    }
  })
  |> result.try_recover(fn(e) {
    case string.ends_with(s, "4") || string.ends_with(s, "four") {
      True -> Ok(4)
      False -> Error(e)
    }
  })
  |> result.try_recover(fn(e) {
    case string.ends_with(s, "5") || string.ends_with(s, "five") {
      True -> Ok(5)
      False -> Error(e)
    }
  })
  |> result.try_recover(fn(e) {
    case string.ends_with(s, "6") || string.ends_with(s, "six") {
      True -> Ok(6)
      False -> Error(e)
    }
  })
  |> result.try_recover(fn(e) {
    case string.ends_with(s, "7") || string.ends_with(s, "seven") {
      True -> Ok(7)
      False -> Error(e)
    }
  })
  |> result.try_recover(fn(e) {
    case string.ends_with(s, "8") || string.ends_with(s, "eight") {
      True -> Ok(8)
      False -> Error(e)
    }
  })
  |> result.try_recover(fn(e) {
    case string.ends_with(s, "9") || string.ends_with(s, "nine") {
      True -> Ok(9)
      False -> Error(e)
    }
  })
}
