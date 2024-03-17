import gleam/int
import gleam/string
import gleam/list
import gleam/result.{replace_error, try}
import util

pub fn run(lines: List(String)) -> Result(Int, String) {
  use #(seeds, lines) <- try(
    lines
    |> util.pop_first
    |> replace_error("Expected seeds line"),
  )

  use seeds <- try(
    seeds
    |> util.trim_prefix("seeds: ")
    |> replace_error("Expected 'seeds: '"),
  )
  use seeds <- try(
    seeds
    |> string.split(" ")
    |> list.map(util.parse_int)
    |> result.all,
  )

  translate(seeds, lines)
  |> list.reduce(int.min)
  |> replace_error("Too few seeds")
}

fn translate(seeds: List(Int), lines: List(String)) -> List(Int) {
  let #(section, lines) =
    list.split_while(lines, fn(line) { !string.is_empty(line) })

  let lines = list.drop(lines, 1)

  let maps = list.filter_map(section, parse_map_entry)
  let seeds = list.map(seeds, translate_seed(_, maps))

  case list.is_empty(lines) {
    False -> translate(seeds, lines)
    True -> seeds
  }
}

fn translate_seed(seed: Int, maps: List(#(Int, Int, Int))) -> Int {
  maps
  |> list.find_map(fn(map) {
    let #(dest, src, len) = map
    case src <= seed && seed < src + len {
      False -> Error(Nil)
      True -> Ok(seed - src + dest)
    }
  })
  |> result.unwrap(seed)
}

fn parse_map_entry(line: String) -> Result(#(Int, Int, Int), Nil) {
  use ints <- try(
    line
    |> string.split(" ")
    |> list.map(int.parse)
    |> result.all,
  )
  case ints {
    [dest, src, len] -> Ok(#(dest, src, len))
    _ -> Error(Nil)
  }
}
