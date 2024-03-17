import gleam/dict
import gleam/iterator
import gleam/int
import gleam/regex
import gleam/string
import gleam/list
import gleam/option.{None, Some}
import gleam/result.{try}
import util

pub fn run(lines: List(String)) {
  use winner_counts <- try(
    lines
    |> list.map(count_winners)
    |> result.all,
  )

  winner_counts
  |> list.index_fold(dict.new(), fn(card_copies, winner_count, i) {
    let copies =
      dict.get(card_copies, i)
      |> result.unwrap(1)

    let card_copies = dict.insert(card_copies, i, copies)

    case winner_count >= 1 {
      True ->
        iterator.range(i + 1, i + winner_count)
        |> iterator.fold(card_copies, fn(card_copies, k) {
          dict.update(card_copies, k, fn(x) {
            case x {
              Some(i) -> i
              None -> 1
            }
            + copies
          })
        })
      False -> card_copies
    }
  })
  |> dict.values
  |> list.fold(0, int.add)
  |> Ok
}

fn count_winners(line: String) {
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
  |> list.length
  |> Ok
}
