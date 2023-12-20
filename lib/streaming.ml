type subscription =
  | Trades
  | Orders
  | Marketdata of int * string list

let subscription_to_string = function
  | Trades -> "str+{}"
  | Orders -> "sor+{}"
  | Marketdata (conid, fields) ->
      Printf.sprintf {|smd+%i+{"fields":[%s]}|} conid (String.concat "," fields)

type msg =
  | Status (* sts *)
  | Notification (* ntf *)
  | Bulletin (* blt *)
  | System (* system *)
  | Marketdata (* smd/umd *)
  | Trades (* str/utr *)
