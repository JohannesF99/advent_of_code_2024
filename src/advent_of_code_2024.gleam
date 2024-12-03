import day_1
import day_2
import day_3
import gleam/io

pub fn main() {
  io.debug(day_1.sol())
  io.debug(day_2.sol(True, "resources/day_2.txt"))
  io.debug(day_3.sol())
}
