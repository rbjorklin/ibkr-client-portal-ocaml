open Client

type endpoints =
  | Status
  | Validate
  | Reauth
  | Tickle
  | Logout

let endpoint_to_uri ~base_url = function
  | Status -> Uri.of_string (base_url ^ "/iserver/auth/status")
  | Validate -> Uri.of_string (base_url ^ "sso/validate")
  | Reauth -> Uri.of_string (base_url ^ "/iserver/reauthenticate")
  | Tickle -> Uri.of_string (base_url ^ "/tickle")
  | Logout -> Uri.of_string (base_url ^ "/logout")

let status ?(timeout = 3.) ~client () =
  let uri = endpoint_to_uri ~base_url:client.base_url Status in
  Common.call ~caller:"status" ~timeout ~parser:Session_j.status_of_string uri

let validate ?(timeout = 3.) ~client () =
  let uri = endpoint_to_uri ~base_url:client.base_url Validate in
  Common.call ~caller:"validate" ~timeout ~parser:Session_j.validate_of_string
    uri

(** call reauthenticate if "authenticated" = false *)
let reauthenticate ?(timeout = 3.) ~client () =
  let uri = endpoint_to_uri ~base_url:client.base_url Reauth in
  Common.call ~caller:"reauthenticate" ~timeout
    ~parser:Session_j.reauthenticate_of_string uri

let tickle ?(timeout = 3.) ~client () =
  let uri = endpoint_to_uri ~base_url:client.base_url Tickle in
  Common.call ~caller:"tickle" ~timeout ~parser:Session_j.tickle_of_string uri

let logout ?(timeout = 3.) ~client () =
  let uri = endpoint_to_uri ~base_url:client.base_url Logout in
  let headers = Cohttp.Header.init_with "Content-Length" "0" in
  Common.call ~caller:"logout" ~timeout ~meth:`POST ~headers
    ~parser:Session_j.logout_of_string uri
