import gleeunit
import gleeunit/should
import util.{get_day_input, split_lines}
import day01p1
import day01p2
import day02p1
import day02p2
import day03p1
import day03p2
import day04p1

pub fn main() {
  gleeunit.main()
}

pub fn day01p1_example_test() {
  split_lines(
    "1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet",
  )
  |> day01p1.run
  |> should.equal(Ok(142))
}

pub fn day01p1_test() {
  get_day_input(1)
  |> day01p1.run
  |> should.equal(Ok(56_042))
}

pub fn day01p2_example_test() {
  split_lines(
    "two1nine
    eightwothree
    abcone2threexyz
    xtwone3four
    4nineeightseven2
    zoneight234
    7pqrstsixteen",
  )
  |> day01p2.run
  |> should.equal(Ok(281))
}

pub fn day01p2_test() {
  get_day_input(1)
  |> day01p2.run
  |> should.equal(Ok(55_358))
}

fn day02_example() {
  split_lines(
    "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green",
  )
}

pub fn day02p1_example_test() {
  day02_example()
  |> day02p1.run
  |> should.equal(Ok(8))
}

pub fn day02p1_test() {
  get_day_input(2)
  |> day02p1.run
  |> should.equal(Ok(3059))
}

pub fn day02p2_example_test() {
  day02_example()
  |> day02p2.run
  |> should.equal(Ok(2286))
}

pub fn day02p2_test() {
  get_day_input(2)
  |> day02p2.run
  |> should.equal(Ok(65_371))
}

fn day03_example() {
  split_lines(
    "467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..",
  )
}

pub fn day03p1_example_test() {
  day03_example()
  |> day03p1.run
  |> should.equal(Ok(4361))
}

pub fn day03p1_example2_test() {
  split_lines(
    "12.......*..
    +.........34
    .......-12..
    ..78........
    ..*....60...
    78.........9
    .5.....23..$
    8...90*12...
    ............
    2.2......12.
    .*.........*
    1.1..503+.56",
  )
  |> day03p1.run
  |> should.equal(Ok(925))
}

pub fn day03p1_test() {
  get_day_input(3)
  |> day03p1.run
  |> should.equal(Ok(556_367))
}

pub fn day03p2_example_test() {
  day03_example()
  |> day03p2.run
  |> should.equal(Ok(467_835))
}

pub fn day03p2_test() {
  get_day_input(3)
  |> day03p2.run
  |> should.equal(Ok(89_471_771))
}

fn day04_example() {
  split_lines(
    "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
    Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
    Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
    Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
    Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
    Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11",
  )
}

pub fn day04p1_example_test() {
  day04_example()
  |> day04p1.run
  |> should.equal(Ok(13))
}
