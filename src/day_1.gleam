import gleam/int
import gleam/list
import gleam/string
import simplifile

pub fn sol() -> #(Int, Int) {
  let n = case simplifile.read("resources/day_1.txt") {
    Ok(content) ->
      content
      |> string.split("\n")
      |> list.filter(fn(line: String) { !string.is_empty(line) })
      |> list.map(fn(line: String) {
        let numbers = string.split(line, "   ") |> list.try_map(int.parse)
        case numbers {
          Ok(numbers) -> {
            let a = case list.first(numbers) {
              Ok(a) -> a
              Error(_) -> panic as "Could not parse input"
            }
            let b = case list.last(numbers) {
              Ok(b) -> b
              Error(_) -> panic as "Could not parse input"
            }
            #(a, b)
          }
          Error(_) -> panic as "Could not parse input"
        }
      })
    Error(_) -> panic as "Could not read input file"
  }
  let first =
    n
    |> list.map(fn(tuple: #(Int, Int)) { tuple.0 })
    |> list.sort(int.compare)

  let second =
    n
    |> list.map(fn(tuple: #(Int, Int)) { tuple.1 })
    |> list.sort(int.compare)

  let part_1 =
    list.zip(first, second)
    |> list.map(fn(tuple: #(Int, Int)) { int.absolute_value(tuple.0 - tuple.1) })
    |> int.sum

  let part_2 =
    first
    |> list.map(fn(a: Int) { similiarity_score(a, second) })
    |> int.sum

  #(part_1, part_2)
}

fn similiarity_score(a: Int, b: List(Int)) -> Int {
  let counts =
    b
    |> list.filter(fn(x: Int) { a == x })
    |> list.length

  a * counts
}
