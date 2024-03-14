import gleam/io
import argv
import day01

pub fn main() {
  case argv.load().arguments {
    ["1"] -> day01.run()
    _ -> io.println("Usage: aocgleam <day>")
  }
}
