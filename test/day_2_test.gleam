import day_2
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn sol_test() {
  let test_string =
    "48 46 47 49 51 54 56
1 1 2 3 4 5
1 2 3 4 5 5
5 1 2 3 4 5
1 4 3 2 1
1 6 7 8 9
1 2 3 4 3
9 8 7 6 7
7 10 8 10 11
29 28 27 25 26 25 22 20"
  day_2.sol(is_file: False, content: test_string)
  |> should.equal(#(0, 9))
}
