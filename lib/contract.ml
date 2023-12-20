open Client

type endpoints =
  | Search
  | Details of int

let endpoint_to_uri ~base_url = function
  | Search -> Uri.of_string (base_url ^ "/iserver/secdef/search")
  | Details conid ->
      Uri.of_string
        (base_url ^ "/iserver/contract/" ^ Int.to_string conid ^ "/info")

let search ?(timeout = 3.) ~client symbol =
  let uri = endpoint_to_uri ~base_url:client.base_url Search in
  let body_s =
    Contract_t.{ symbol; name = false; secType = "STK" }
    |> Contract_j.string_of_search_query
  in
  let headers = Cohttp.Header.init_with "Content-Type" "application/json" in
  let headers =
    Cohttp.Header.add headers "Content-Length"
      (Int.to_string (String.length body_s))
  in
  let body = Cohttp_lwt.Body.of_string body_s in
  Common.call ~caller:"search" ~timeout ~meth:`POST ~headers ~body
    ~parser:Contract_j.search_of_string uri

(** https://www.interactivebrokers.com/api/doc.html#tag/Contract/paths/~1iserver~1contract~1%7Bconid%7D~1info/get *)
let details ?(timeout = 3.) ~client conid =
  let uri = endpoint_to_uri ~base_url:client.base_url (Details conid) in
  let headers = Cohttp.Header.init_with "Accept" "application/json" in
  Common.call ~caller:"details" ~timeout ~headers
    ~parser:Contract_j.details_of_string uri
