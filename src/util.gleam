import gleam/string
import gleam/list
import gleam/result
import simplifile.{read}

pub fn read_lines(filename: String) {
  read(filename)
  |> result.map(string.trim)
  |> result.map(split_lines)
}

pub fn split_lines(text: String) {
  string.split(text, on: "\n")
  |> list.map(string.trim)
}
