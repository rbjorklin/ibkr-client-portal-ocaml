open Client

type endpoints = List_trades

let endpoint_to_uri ~base_url = function
  | List_trades -> Uri.of_string (base_url ^ "/iserver/account/trades")

(** IBKR requires a call to /accounts before this endpoint *)
let list_trades ?(timeout = 3.) ~client () =
  let uri = endpoint_to_uri ~base_url:client.base_url List_trades in
  Common.call ~caller:"list_trades" ~timeout ~parser:Trades_j.trades_of_string
    uri

let trades_to_list (t : Trades_t.trades) : Trades_t.trade list = t
