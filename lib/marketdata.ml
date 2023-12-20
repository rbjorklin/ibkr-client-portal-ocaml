open Client

type endpoints = Marketdata_history

let endpoint_to_uri ~base_url = function
  | Marketdata_history ->
      Uri.of_string (base_url ^ "/iserver/marketdata/history")

(** field 6509 *)
let availability_is = function
  | `RealTime s -> String.contains s 'R'
  (* Data is relayed back in real time without delay, market data
     subscription(s) are required. *)
  | `Delayed s -> String.contains s 'D'
  (* Data is relayed back 15-20 min delayed. *)
  | `Frozen s -> String.contains s 'Z'
  (* Last recorded data at market close, relayed back in real time. *)
  | `Frozen_Delayed s -> String.contains s 'Y'
  (* Last recorded data at market close, relayed back delayed. *)
  | `Not_Subscribed s -> String.contains s 'N'
  (* User does not have the required market data subscription(s) to relay back
     either real time or delayed data. *)
  | `Snapshot s -> String.contains s 'P'
  (* Snapshot request is available for contract. *)
  | `Consolidated s -> String.contains s 'p'
  (* Market data is aggregated across multiple exchanges or venues. *)
  | `Book s -> String.contains s 'B'
(* Top of the book data is available for contract. *)
[@@ocaml.warning "-unused-value-declaration"]

let marketdata_history
    ?(timeout = 3.)
    ?(exchange = "")
    ?(outsideRth = false)
    ~client
    ~conid
    ~period
    ~bar
    () =
  let uri = endpoint_to_uri ~base_url:client.base_url Marketdata_history in
  let bar =
    match bar with
    | `min x when List.exists (fun e -> x = e) [ 1; 2; 3; 5; 10; 15; 30 ] ->
        Printf.sprintf "%dmin" x
    | `h x when List.exists (fun e -> x = e) [ 1; 2; 3; 4; 8 ] ->
        Printf.sprintf "%dh" x
    | `d x when x = 1 -> Printf.sprintf "%dd" x
    | `w x when x = 1 -> Printf.sprintf "%dw" x
    | `m x when x = 1 -> Printf.sprintf "%dm" x
    | _ -> "not a supported bar size"
  in
  let period =
    match period with
    | `min x when x >= 1 && x <= 30 -> Printf.sprintf "%dmin" x
    | `h x when x >= 1 && x <= 8 -> Printf.sprintf "%dh" x
    | `d x when x >= 1 && x <= 1000 -> Printf.sprintf "%dd" x
    | `w x when x >= 1 && x <= 792 -> Printf.sprintf "%dw" x
    | `m x when x >= 1 && x <= 182 -> Printf.sprintf "%dm" x
    | `y x when x >= 1 && x <= 15 -> Printf.sprintf "%dy" x
    | _ -> "not a\n   supported period"
  in
  let uri =
    Uri.add_query_params' uri
      [
        ("exchange", exchange);
        ("outsideRth", Bool.to_string outsideRth);
        ("conid", Int.to_string conid);
        ("bar", bar);
        ("period", period);
      ]
  in
  Common.call ~caller:"marketdata_history" ~timeout
    ~parser:Marketdata_j.history_of_string uri
