(** This file exists because extracting strings from atd variants isn't as
    straight forward as one might like. See:
    https://github.com/ahrefs/atd/issues/374 *)
type t =
  | Gtc
  | Opg
  | Day
  | Ioc

let to_string = function
  | Gtc -> "GTC"
  | Opg -> "OPG"
  | Day -> "DAY"
  | Ioc -> "IOC"

let of_string = function
  | "GTC" -> Gtc
  | "OPG" -> Opg
  | "DAY" -> Day
  | "IOC" -> Ioc
[@@ocaml.warning "-partial-match"]
