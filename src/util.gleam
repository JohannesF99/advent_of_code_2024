import gleam/int
import gleam/list
import gleam/string
import simplifile

pub fn read_file(
  is_file is_file: Bool,
  content content: String,
) -> List(List(Int)) {
  case is_file {
    True ->
      case simplifile.read(content) {
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
    False ->
      content
      |> string.split("\n")
      |> list.filter(fn(line: String) { !string.is_empty(line) })
      |> list.map(fn(line: String) {
        let assert Ok(numbers) =
          string.split(line, " ") |> list.try_map(int.parse)
        numbers
      })
  }
}
