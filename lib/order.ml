open Client

type endpoints =
  | Cancel_order of string * int
  | Reply of string
  | Place_orders of string
  | Get_orders
  | Order_status of string

type filter =
  | Inactive
  | Pending_submit
  | Pre_submitted
  | Submitted
  | Filled
  | Pending_cancel
  | Cancelled
  | Warn_state
  | Sort_by_time

let filter_to_string = function
  | Inactive -> "inactive"
  | Pending_submit -> "pending_submit"
  | Pre_submitted -> "pre_submitted"
  | Submitted -> "submitted"
  | Filled -> "filled"
  | Pending_cancel -> "pending_cancel"
  | Cancelled -> "cancelled"
  | Warn_state -> "warn_state"
  | Sort_by_time -> "sort_by_time"

let filters_to_string_list filters =
  let rec loop acc = function
    | hd :: tl -> loop (filter_to_string hd :: acc) tl
    | [] -> acc
  in
  loop [] filters

let endpoint_to_uri ~base_url = function
  | Cancel_order (account_id, order_id) ->
      Uri.of_string
        (base_url
        ^ Printf.sprintf "/iserver/account/%s/order/%s" account_id
            (Int.to_string order_id))
  | Reply id -> Uri.of_string (base_url ^ Printf.sprintf "/iserver/reply/%s" id)
  | Place_orders account_id ->
      Uri.of_string
        (base_url ^ Printf.sprintf "/iserver/account/%s/orders" account_id)
  | Get_orders -> Uri.of_string (base_url ^ "/iserver/account/orders")
  | Order_status order_id ->
      Uri.of_string
        (base_url ^ Printf.sprintf "/iserver/account/order/status/%s" order_id)

let create_order ?(outside_rth = false) ?(use_adaptive = false)
    ?(listingExchange = "SMART") ?(price = None) ~client ~cOID ~conid
    ~order_type ~quantity ~side ~tif ~ticker () =
  Order_t.
    {
      acctId = client.account_id;
      conidex = Int.to_string conid;
      orderType = order_type;
      price;
      side;
      tif;
      trailingAmt = None;
      trailingType = None;
      quantity;
      useAdaptive = use_adaptive;
      outsideRTH = outside_rth;
      cOID;
      listingExchange;
      ticker;
    }

let place_order_reply ?(timeout = 3.) ~client ~(reply : bool) id =
  let uri = endpoint_to_uri ~base_url:client.base_url (Reply id) in
  let reply = Order_t.{ confirmed = reply } in
  let body_s = Order_j.string_of_place_order_reply reply in
  let headers = Cohttp.Header.init_with "Content-Type" "application/json" in
  let headers =
    Cohttp.Header.add headers "Content-Length"
      (Int.to_string (String.length body_s))
  in
  let body = Cohttp_lwt.Body.of_string body_s in
  Common.call ~caller:"place_order_reply" ~timeout ~meth:`POST ~headers ~body
    ~parser:Order_j.place_order_reply_responses_of_string uri

let create_orders = function [] -> None | orders -> Some { Order_j.orders }

let place_orders ?(timeout = 3.) ~client (orders : Order_j.orders) =
  let account_id = client.account_id in
  let uri =
    endpoint_to_uri ~base_url:client.base_url (Place_orders account_id)
  in
  let body_s = Order_j.string_of_orders orders in
  let headers = Cohttp.Header.init_with "Content-Type" "application/json" in
  let headers =
    Cohttp.Header.add headers "Content-Length"
      (Int.to_string (String.length body_s))
  in
  let body = Cohttp_lwt.Body.of_string body_s in
  Common.call ~caller:"place_orders" ~timeout ~meth:`POST ~headers ~body
    ~parser:Order_j.place_orders_responses_of_string uri

(** One must call 'get_accounts' before this. filters is an inclusive filter
    which only returns orders of the given type *)
let get_orders ?(timeout = 3.) ?(filters = []) ~client () =
  let s = filters_to_string_list filters in
  let uri =
    match s with
    | [] -> endpoint_to_uri ~base_url:client.base_url Get_orders
    | _ ->
        let t_uri = endpoint_to_uri ~base_url:client.base_url Get_orders in
        Uri.add_query_param t_uri ("filters", s)
  in
  Common.call ~caller:"get_orders" ~timeout
    ~parser:Order_j.live_orders_of_string uri

(** A call to 'get_accounts' is required before all(?) trade/order actions *)
let cancel_order ?(timeout = 3.) ~client order_id =
  let uri =
    endpoint_to_uri ~base_url:client.base_url
      (Cancel_order (client.account_id, order_id))
  in
  Common.call ~caller:"cancel_order" ~timeout ~meth:`DELETE
    ~parser:Order_j.cancel_order_of_string uri

let live_orders_to_list (live_orders : Order_j.live_orders) =
  live_orders.live_orders

let orders_to_list (orders : Order_j.orders) = orders.orders

let create_live_orders = function
  | [] -> None
  | live_orders -> Some { Order_j.live_orders }

let order_status ?(timeout = 3.) ~client order_id =
  let uri = endpoint_to_uri ~base_url:client.base_url (Order_status order_id) in
  Common.call ~caller:"order_status" ~timeout
    ~parser:Order_j.order_status_of_string uri

(* let order_status2
     ?(timeout = 3.)
     ~(client : Account_t.accounts Types2.ctx2)
     order_id =
   let uri = endpoint_to_uri ~base_url:client.base_url (Order_status order_id) in
   client.call ~caller:"order_status" ~timeout
     ~parser:Order_j.order_status_of_string uri *)
