(** This file exists because extracting strings from atd variants isn't as
    straight forward as one might like. See:
    https://github.com/ahrefs/atd/issues/374 *)
type t =
  | Buy
  | Sell
  | Option_assignment
  | Option_exercise

let to_string = function
  | Buy -> "BUY"
  | Sell -> "SELL"
  | Option_assignment -> "ASSN"
  | Option_exercise -> "EXER"

let of_string = function
  | "BUY" -> Buy
  | "SELL" -> Sell
  | "ASSN" -> Option_assignment
  | "EXER" -> Option_exercise
[@@ocaml.warning "-partial-match"]
