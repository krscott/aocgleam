import gleam/io
import gleam/int
import gleam/string
import gleam/list
import gleam/result.{try}
import util

pub fn run(lines: List(String)) {
  let grid: Grid =
    lines
    |> list.map(parse_grid_row)

  grid
  |> list.index_map(fn(row, i) {
    let line =
      list.at(lines, i)
      |> result.replace_error("?")
      |> result.unwrap_both
    io.print(line)
    let out =
      grid_row_part_numbers(grid, row, i)
      |> util.tap(fn(x) { io.print(" " <> int.to_string(x)) })
      |> list.fold(0, int.add)
    io.println("")
    out
  })
  // |> util.index_tap(fn(x, i) {
  //   let line =
  //     list.at(lines, i)
  //     |> result.replace_error("?")
  //     |> result.unwrap_both
  //   io.println(int.to_string(x) <> " " <> line)
  // })
  |> list.fold(0, int.add)
  |> Ok
}

type Grid =
  List(List(Cell))

type Cell {
  Dot
  Symbol
  Digit(Int)
}

fn grid_row_part_numbers(grid: Grid, row: List(Cell), row_idx: Int) -> List(Int) {
  let add_partial = fn(out: List(Int), partial: Int, is_part: Bool) {
    case is_part {
      True -> #([partial, ..out], 0, False)
      False -> #(out, 0, False)
    }
  }

  let #(out, partial, is_part) =
    row
    |> list.index_fold(
      #([], 0, False),
      fn(acc: #(List(Int), Int, Bool), cell, col_idx) {
        let #(out, partial, is_part) = acc
        case cell {
          Dot | Symbol -> add_partial(out, partial, is_part)
          Digit(d) -> #(
            out,
            partial * 10 + d,
            is_part || grid_cell_is_part(grid, #(row_idx, col_idx)),
          )
        }
      },
    )
  let #(out, _, _) = add_partial(out, partial, is_part)
  out
}

fn grid_cell_is_part(grid: Grid, rc: #(Int, Int)) -> Bool {
  let #(r, c) = rc
  let out =
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
    |> list.filter_map(grid_at(grid, _))
    |> list.find(cell_is_symbol)
    |> result.is_ok
  io.print(
    "("
    <> int.to_string(r)
    <> ","
    <> int.to_string(c)
    <> ","
    <> string.inspect(out)
    <> ")",
  )
  out
}

fn cell_is_symbol(cell: Cell) -> Bool {
  case cell {
    Dot -> False
    Symbol -> True
    Digit(_) -> False
  }
}

fn grid_at(grid: Grid, rc: #(Int, Int)) -> Result(Cell, Nil) {
  let #(r, c) = rc
  use row <- try(list.at(grid, r))
  use cell <- try(list.at(row, c))
  Ok(cell)
}

fn parse_grid_row(line: String) -> List(Cell) {
  line
  |> string.to_graphemes
  |> list.map(parse_cell)
}

fn parse_cell(c: String) -> Cell {
  case c {
    "." -> Dot
    c ->
      int.parse(c)
      |> result.map(Digit)
      |> result.replace_error(Symbol)
      |> result.unwrap_both
  }
}
