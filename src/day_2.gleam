import gleam/int
import gleam/list
import gleam/string
import simplifile

type Movement {
  Increase
  Decrease
}

pub fn sol() -> #(Int, Int) {
  let n = read_file()

  let part_1 =
    n
    |> list.filter(fn(line: List(Int)) {
      let movement: Movement = get_movement(line)
      is_safe(line, movement)
    })
    |> list.length

  let part_2 =
    n
    |> list.filter(fn(line: List(Int)) {
      let movement: Movement = get_movement(line)
      let false_size =
        check_safe(line, movement)
        |> list.filter(fn(x: Bool) { !x })
        |> list.length
        |> fn(len: Int) { len == 0 }
      case false_size {
        True -> True
        False -> {
          line
          |> list.combinations(list.length(line) - 1)
          |> list.filter(is_safe(_, movement))
          |> list.length
          |> fn(len: Int) { len > 0 }
        }
      }
    })
    |> list.length

  #(part_1, part_2)
}

fn is_safe(combination: List(Int), movement: Movement) -> Bool {
  check_safe(combination, movement)
  |> list.all(fn(x: Bool) { x })
}

fn check_safe(line: List(Int), movement: Movement) -> List(Bool) {
  case line {
    [a, b] -> {
      let res = case movement {
        Increase -> a < b && b - a > 0 && b - a <= 3
        Decrease -> a > b && a - b > 0 && a - b <= 3
      }
      case res {
        True -> [True]
        False -> [True, False]
      }
    }
    [a, b, ..rest] ->
      check_safe([a, b], movement)
      |> list.append(check_safe([b, ..rest], movement))
    _ -> [True]
  }
}

fn get_movement(a: List(Int)) -> Movement {
  let assert Ok(first) = list.first(a)
  let assert Ok(last) = list.last(a)
  case first > last {
    True -> Decrease
    False -> Increase
  }
}

fn read_file() -> List(List(Int)) {
  case simplifile.read("resources/day_2.txt") {
    Ok(content) ->
      content
      |> string.split("\n")
      |> list.filter(fn(line: String) { !string.is_empty(line) })
      |> list.map(fn(line: String) {
        let assert Ok(numbers) =
          string.split(line, " ") |> list.try_map(int.parse)
        numbers
      })
    Error(_) -> panic as "Could not read input file"
  }
}
