import gleam/int
import gleam/string
import gleam/list
import gleam/result.{try}

pub fn run(input: List(String)) -> Result(Int, String) {
  use games <- try(
    input
    |> list.map(parse_game)
    |> result.all,
  )

  games
  |> list.filter(is_possible)
  |> list.map(fn(game: Game) { game.id })
  |> list.fold(0, int.add)
  |> Ok
}

type Subset {
  Subset(reds: Int, greens: Int, blues: Int)
}

type Game {
  Game(id: Int, subsets: List(Subset))
}

fn parse_game(line: String) -> Result(Game, String) {
  use #(head, rest) <- try(
    line
    |> string.split_once(": ")
    |> result.replace_error("Missing ': '"),
  )

  use id <- try(
    head
    |> string.replace("Game ", "")
    |> int.parse
    |> result.replace_error("Could not parse game id"),
  )

  use subsets <- try(
    rest
    |> string.split("; ")
    |> list.map(parse_subset)
    |> result.all,
  )

  Ok(Game(id, subsets))
}

fn parse_subset(text: String) -> Result(Subset, String) {
  text
  |> string.split(", ")
  |> list.fold(Ok(Subset(0, 0, 0)), fn(prev, s: String) {
    use subset <- try(prev)
    use #(n, color) <- try(
      s
      |> string.split_once(" ")
      |> result.replace_error("Expected 'number color'"),
    )
    use n <- try(
      n
      |> int.parse
      |> result.replace_error("Could not parse color count"),
    )
    case color {
      "red" -> Ok(Subset(n, subset.greens, subset.blues))
      "green" -> Ok(Subset(subset.reds, n, subset.blues))
      "blue" -> Ok(Subset(subset.reds, subset.greens, n))
      color -> Error(string.append("Unexpected color: ", color))
    }
  })
}

fn is_possible(game: Game) -> Bool {
  game.subsets
  |> list.find(fn(subset: Subset) {
    subset.reds > 12 || subset.greens > 13 || subset.blues > 14
  })
  |> result.is_error
}
