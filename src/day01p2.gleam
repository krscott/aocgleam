import gleam/int
import gleam/string
import gleam/list
import gleam/result.{try}
import util

pub fn run(lines: List(String)) -> Result(Int, String) {
  use cals <- try(
    lines
    |> list.map(parse_line)
    |> util.map_error_lineno
    |> result.all,
  )

  cals
  |> list.fold(0, int.add)
  |> Ok
}

fn parse_line(line: String) -> Result(Int, String) {
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

  use first <- try(
    list.first(out)
    |> result.replace_error("could not find first digit"),
  )
  use last <- try(
    list.last(out)
    |> result.replace_error("could not find last digit"),
  )

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
