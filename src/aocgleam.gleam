import gleam/io
import argv
import day01p1
import day01p2

pub fn main() {
  case argv.load().arguments {
    ["1", "1"] -> day01p1.run()
    ["1", "2"] -> day01p2.run()
    _ -> io.println("Usage: aocgleam <day> <part>")
  }
}
