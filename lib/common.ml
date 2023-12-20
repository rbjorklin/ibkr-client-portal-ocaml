open Lwt.Infix
open Lwt.Syntax

let src =
  Logs.Src.create "ibkr.common" ~doc:"logs ibkr api calls and their response"

module Log = (val Logs.src_log src : Logs.LOG)

let race_to_timeout ~timeout ~f =
  Lwt.pick
    [
      (f () >|= fun v -> `Done v);
      (Lwt_unix.sleep timeout >|= fun () -> `Timeout timeout);
    ]

(** parser is the function used to parse a successful response *)
let call
    ?(caller = "ibkr.common.call")
    ?(timeout = 3.)
    ?(meth = `GET)
    ?(skip_verify = true)
    ?headers
    ?body
    ~parser
    uri =
  let () =
    if skip_verify then
      (* Skip certificate verification *)
      Ssl.set_verify Conduit_lwt_unix_ssl.Client.default_ctx [] None
    else ()
  in
  let match_timeout = function
    | `Timeout time ->
        ( Cohttp.Response.make ~status:(Cohttp.Code.status_of_code 504) (),
          Cohttp_lwt.Body.of_string
            (Printf.sprintf "Request timed out after %.1f seconds" time) )
    | `Done (rsp, rsp_body) -> (rsp, rsp_body)
  in
  let* response, body =
    match meth with
    | `GET | `DELETE | `POST ->
        let f () = Cohttp_lwt_unix.Client.call ?headers ?body meth uri in
        let+ t = race_to_timeout ~timeout ~f in
        match_timeout t
    | _ ->
        Lwt.return
          ( Cohttp_lwt.Response.make ~status:(Cohttp.Code.status_of_code 405) (),
            Cohttp_lwt.Body.empty )
  in
  let+ rsp_body_s = Cohttp_lwt.Body.to_string body in
  let msg () =
    Printf.sprintf "%s %s %s %s"
      (Cohttp.Code.string_of_status response.status)
      (Cohttp.Code.string_of_method meth)
      (Uri.to_string uri) rsp_body_s
  in
  Log.debug (fun m -> m "%s" (msg ()));
  match response.status with
  | `OK -> (
      try Ok (parser rsp_body_s)
      with e -> Error (Printf.sprintf "call: %s" (Printexc.to_string e)))
  | #Cohttp.Code.status_code -> Error (Printf.sprintf "%s: %s" caller (msg ()))

let make_ws_client ?(skip_verify = false) uri =
  Resolver_lwt.resolve_uri ~uri Resolver_lwt_unix.system >>= fun endp ->
  Conduit_lwt_unix.(
    endp_to_client ~ctx:(Lazy.force default_ctx) endp >>= fun client ->
    let () =
      if skip_verify then
        (* Skip certificate verification *)
        Ssl.set_verify Conduit_lwt_unix_ssl.Client.default_ctx [] None
      else ()
    in
    Websocket_lwt_unix.connect ~ctx:(Lazy.force default_ctx) client uri)
