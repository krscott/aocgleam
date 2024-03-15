import gleeunit
import gleeunit/should
import util.{read_lines, split_lines}
import day01p1
import day01p2

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
  |> day01p1.get_calibration
  |> should.equal(Ok(142))
}

pub fn day01p1_test() {
  let assert Ok(lines) = read_lines("./inputs/input01.txt")
  day01p1.get_calibration(lines)
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
  |> day01p2.get_calibration
  |> should.equal(Ok(281))
}

pub fn day01p2_test() {
  let assert Ok(lines) = read_lines("./inputs/input01.txt")
  day01p2.get_calibration(lines)
  |> should.equal(Ok(55_358))
}
