import gleam/int
import gleam/string
import gleam/list

type Number {
  Number(r: Int, c: Int, len: Int, value: Int)
}

type Gear {
  Gear(r: Int, c: Int)
}

pub fn run(lines: List(String)) {
  let numbers =
    lines
    |> list.index_map(get_numbers)
    |> list.flatten

  lines
  |> list.index_map(get_gears)
  |> list.flatten
  |> list.filter_map(fn(gear) {
    let nums =
      surrounding_coords(gear.r, gear.c)
      |> list.filter_map(get_number_at(numbers, _))
      |> list.unique

    case nums {
      [a, b] -> Ok(a.value * b.value)
      _ -> Error(Nil)
    }
  })
  |> list.fold(0, int.add)
  |> Ok
}

fn get_number_at(numbers: List(Number), rc: #(Int, Int)) -> Result(Number, Nil) {
  let #(r, c) = rc
  numbers
  |> list.find(fn(num) { num.r == r && num.c <= c && num.c + num.len > c })
}

fn surrounding_coords(r: Int, c: Int) {
  [
    #(r - 1, c - 1),
    #(r - 1, c),
    #(r - 1, c + 1),
    #(r, c - 1),
    #(r, c + 1),
    #(r + 1, c - 1),
    #(r + 1, c),
    #(r + 1, c + 1),
  ]
}

fn get_gears(line: String, r: Int) -> List(Gear) {
  line
  |> string.to_graphemes
  |> list.index_map(fn(gr, c) {
    case gr == "*" {
      True -> [Gear(r, c)]
      False -> []
    }
  })
  |> list.flatten
}

fn get_numbers(line: String, r: Int) -> List(Number) {
  line
  |> string.to_graphemes
  |> list.index_fold([], fn(acc, gr, c) {
    case int.parse(gr), acc {
      Error(_), acc -> acc
      Ok(d), [] -> [Number(r, c, 1, d)]
      Ok(d), [head, ..tail] ->
        case head.r == r && head.c + head.len == c {
          True -> [
            Number(head.r, head.c, head.len + 1, head.value * 10 + d),
            ..tail
          ]
          False -> [Number(r, c, 1, d), head, ..tail]
        }
    }
  })
}
