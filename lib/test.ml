let my_ctx =
  Types2.{ account_id = "arst"; base_url = "barst"; call = Common.call }

let acc = Account.get_accounts2 ~client:my_ctx ()
(* let ord = Order.order_status2 ~client:my_ctx () *)
