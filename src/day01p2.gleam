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
  [
    #(1, "one"),
    #(2, "two"),
    #(3, "three"),
    #(4, "four"),
    #(5, "five"),
    #(6, "six"),
    #(7, "seven"),
    #(8, "eight"),
    #(9, "nine"),
  ]
  |> list.fold(Error(Nil), fn(prev, args) {
    let #(digit, word_str) = args
    use _ <- result.try_recover(prev)
    case
      string.ends_with(s, int.to_string(digit))
      || string.ends_with(s, word_str)
    {
      True -> Ok(digit)
      False -> Error(Nil)
    }
  })
}
