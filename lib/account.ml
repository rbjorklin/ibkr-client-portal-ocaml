open Client

type endpoints = Accounts

let endpoint_to_uri ~base_url = function
  | Accounts -> Uri.of_string (base_url ^ "/iserver/accounts")

(** NOTE: this endpoint must be called before interacting with orders, trades or
    positions. *)
let get_accounts ?(timeout = 3.) ~client () =
  let uri = endpoint_to_uri ~base_url:client.base_url Accounts in
  Common.call ~caller:"get_accounts" ~timeout
    ~parser:Account_j.accounts_of_string uri

let get_accounts2 ?(timeout = 3.) ~(client : Account_t.accounts Types2.ctx2) ()
    =
  let uri = endpoint_to_uri ~base_url:client.base_url Accounts in
  client.call ~caller:"get_accounts" ~timeout
    ~parser:Account_j.accounts_of_string uri
[@@ocaml.warning "-unused-value-declaration"]
