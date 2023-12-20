let test description f = Alcotest.test_case description `Quick (f description)

(* Path relative to test module: <project dir>/_build/default/test *)
let rel_resource_base = "../../../test/resource"

let test_parse_auth_success description () =
  let fname =
    Printf.sprintf "%s/iserver_auth_status_success.json" rel_resource_base
  in
  let json =
    In_channel.(
      with_open_text fname (fun ic ->
          input_all ic |> Ibkr_cp.Session_j.status_of_string))
  in
  let serverInfo =
    Some
      Ibkr_cp.Session_t.
        {
          serverName = Some "JisfN9032";
          serverVersion = Some "Build 10.25.0a, Aug 29, 2023 4:29:57 PM";
        }
  in
  let literal =
    Ibkr_cp.Session_t.
      {
        authenticated = true;
        competing = false;
        connected = true;
        message = Some "";
        mac = "98:F2:B3:23:BF:A0";
        serverInfo;
      }
  in
  let expected = 0 in
  let result = compare literal json in
  Alcotest.(check int) description expected result

let () =
  Alcotest.run "Session"
    [
      ( "Session_j.status_of_string",
        [ test "json blob parses into Session literal" test_parse_auth_success ]
      );
    ]
