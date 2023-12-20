(** This file exists because extracting strings from atd variants isn't as
    straight forward as one might like. See:
    https://github.com/ahrefs/atd/issues/374 *)
type t =
  | Lmt
  | Mkt
  | Stp
  | Stop_limit
  | Midprice
  | Trail
  | Traillmt

let to_string = function
  | Lmt -> "LMT"
  | Mkt -> "MKT"
  | Stp -> "STP"
  | Stop_limit -> "STOP_LIMIT"
  | Midprice -> "MIDPRICE"
  | Trail -> "TRAIL"
  | Traillmt -> "TRAILLMT"

let of_string = function
  | "LMT" -> Lmt
  | "MKT" -> Mkt
  | "STP" -> Stp
  | "STOP_LIMIT" -> Stop_limit
  | "MIDPRICE" -> Midprice
  | "TRAIL" -> Trail
  | "TRAILLMT" -> Traillmt
[@@ocaml.warning "-partial-match"]
