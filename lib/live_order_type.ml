(** This file exists because extracting strings from atd variants isn't as
    straight forward as one might like. See:
    https://github.com/ahrefs/atd/issues/374 *)
type t =
  | Limit
  | Market
  | Stop
  | Stop_limit
  | Midprice
  | Trail
  | Traillmt

let to_string = function
  | Limit -> "Limit"
  | Market -> "Market"
  | Stop -> "Stop"
  | Stop_limit -> "Stop_limit"
  | Midprice -> "Midprice"
  | Trail -> "Trail"
  | Traillmt -> "Traillmt"

let of_string = function
  | "Limit" -> Limit
  | "Market" -> Market
  | "Stop" -> Stop
  | "Stop_limit" -> Stop_limit
  | "Midprice" -> Midprice
  | "Trail" -> Trail
  | "Traillmt" -> Traillmt
[@@ocaml.warning "-partial-match"]
