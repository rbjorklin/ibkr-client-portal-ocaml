val list_trades :
  ?timeout:float ->
  client:Client.t -> unit -> (Trades_j.trades, string) result Lwt.t
val trades_to_list : Trades_t.trades -> Trades_t.trade list
