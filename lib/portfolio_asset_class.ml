type t =
  | Stk
  | Opt
  | Fut
  | Cfd
  | War
  | Swp
  | Fnd
  | Bnd
  | Ics

let to_string = function
  | Stk -> "STK"
  | Opt -> "OPT"
  | Fut -> "FUT"
  | Cfd -> "CFD"
  | War -> "WAR"
  | Swp -> "SWP"
  | Fnd -> "FND"
  | Bnd -> "BND"
  | Ics -> "ICS"

let of_string = function
  | "STK" -> Stk
  | "OPT" -> Opt
  | "FUT" -> Fut
  | "CFD" -> Cfd
  | "WAR" -> War
  | "SWP" -> Swp
  | "FND" -> Fnd
  | "BND" -> Bnd
  | "ICS" -> Ics
[@@ocaml.warning "-partial-match"]
