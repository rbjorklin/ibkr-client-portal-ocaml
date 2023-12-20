val availability_is :
  [< `Book of string
   | `Consolidated of string
   | `Delayed of string
   | `Frozen of string
   | `Frozen_Delayed of string
   | `Not_Subscribed of string
   | `RealTime of string
   | `Snapshot of string ] ->
  bool
val marketdata_history :
  ?timeout:float ->
  ?exchange:string ->
  ?outsideRth:bool ->
  client:Client.t ->
  conid:int ->
  period:[> `d of int
          | `h of int
          | `m of int
          | `min of int
          | `w of int
          | `y of int ] ->
  bar:[> `d of int | `h of int | `m of int | `min of int | `w of int ] ->
  unit -> (Marketdata_j.history, string) result Lwt.t
