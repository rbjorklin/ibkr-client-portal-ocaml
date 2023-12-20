open Client

type endpoints =
  | Position_by_conid of string * int
  | Positions of string
  | Accounts
  | Account_summary of string

let endpoint_to_uri ~base_url = function
  | Position_by_conid (account, conid) ->
      Uri.of_string
        (base_url ^ Printf.sprintf "/portfolio/%s/position/%d" account conid)
  | Positions account ->
      Uri.of_string
        (base_url ^ Printf.sprintf "/portfolio/%s/positions/0" account)
  | Accounts -> Uri.of_string (base_url ^ "/portfolio/accounts")
  | Account_summary account ->
      Uri.of_string (Printf.sprintf "%s/portfolio/%s/summary" base_url account)

let position_by_conid ?(timeout = 3.) ~client conid =
  let uri =
    endpoint_to_uri ~base_url:client.base_url
      (Position_by_conid (client.account_id, conid))
  in
  Common.call ~caller:"position_by_conid" ~timeout
    ~parser:Portfolio_j.positions_of_string uri

let positions ?(timeout = 3.) ~client () =
  let uri =
    endpoint_to_uri ~base_url:client.base_url (Positions client.account_id)
  in
  Common.call ~caller:"positions" ~timeout
    ~parser:Portfolio_j.positions_of_string uri

let accounts ?(timeout = 3.) ~client () =
  let uri = endpoint_to_uri ~base_url:client.base_url Accounts in
  Common.call ~caller:"accounts" ~timeout ~parser:Portfolio_j.accounts_of_string
    uri

(** A property is suffixed with '-s` if it provides security value *)
let account_summary ?(timeout = 3.) ~client () =
  let uri =
    endpoint_to_uri ~base_url:client.base_url
      (Account_summary client.account_id)
  in
  Common.call ~caller:"account_summary" ~timeout
    ~parser:Portfolio_j.account_summary_of_string uri
