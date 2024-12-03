import gleam/int
import gleam/io
import gleam/list
import gleam/option.{Some}
import gleam/regexp.{type Match, type Regexp, Options}
import gleam/string
import simplifile

type Segment {
  Segment(pre_action: String, action_activating: Bool, post_action: String)
}

const part_1_regex = "(mul\\()([\\d]+)(,)([\\d]+)(\\))"

pub fn sol() {
  let assert Ok(file) = simplifile.read("resources/day_3.txt")
  let assert Ok(re) = regexp.compile(part_1_regex, Options(True, False))
  let part_1 =
    file
    |> string.split("\n")
    |> list.filter(fn(line) { !string.is_empty(line) })
    |> list.map(get_value(_, re))
    |> list.map(fn(sol: List(#(Int, Int))) {
      list.map(sol, fn(x) { x.1 * x.0 })
    })
    |> list.flatten()
    |> int.sum()

  let segment = Segment("", True, file)
  let part_2 =
    analyse_segment(segment)
    |> list.map(fn(x) { x.1 * x.0 })
    |> int.sum()

  #(part_1, part_2)
}

fn analyse_segment(segment: Segment) -> List(#(Int, Int)) {
  case segment.action_activating {
    True -> {
      let assert Ok(re1) = regexp.compile(part_1_regex, Options(True, False))
      let splits = string.split(segment.post_action, "don't()")
      // split remainder in do and don't
      case splits {
        [a] -> {
          io.debug(a)
          get_value(segment.post_action, re1)
        }
        [a, ..rest] -> {
          let segment = Segment(a, False, string.join(rest, "don't()"))
          analyse_segment(segment)
        }
        _ -> []
      }
    }
    False -> {
      let assert Ok(re1) = regexp.compile(part_1_regex, Options(True, False))
      let sol = get_value(segment.pre_action, re1)
      let splits = string.split(segment.post_action, "do()")
      case splits {
        [_] -> sol
        [_, ..rest] -> {
          let segment = Segment("", True, string.join(rest, "do()"))
          list.append(sol, analyse_segment(segment))
        }
        _ -> []
      }
    }
  }
}

fn get_value(line: String, re: Regexp) -> List(#(Int, Int)) {
  regexp.scan(re, line)
  |> list.map(fn(match: Match) {
    case match.submatches {
      [_, Some(a), _, Some(b), _] -> {
        let assert Ok(a) = int.parse(a)
        let assert Ok(b) = int.parse(b)
        #(a, b)
      }
      _ -> panic as "Could not parse line"
    }
  })
}
