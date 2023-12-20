(** This file exists because extracting strings from atd variants isn't as
    straight forward as one might like. See:
    https://github.com/ahrefs/atd/issues/374 *)
type t =
  | Buy
  | Sell
  | Option_expired

let to_string = function
  | Buy -> "B"
  | Sell -> "S"
  | Option_expired -> "X"

let of_string = function
  | "B" -> Buy
  | "S" -> Sell
  | "X" -> Option_expired
[@@ocaml.warning "-partial-match"]
