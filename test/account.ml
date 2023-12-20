let test description f = Alcotest.test_case description `Quick (f description)

(* Path relative to test module: <project dir>/_build/default/test *)
let rel_resource_base = "../../../test/resource"

let test_parse_account description () =
  let fname =
    Printf.sprintf "%s/iserver_accounts_success.json" rel_resource_base
  in
  let json =
    In_channel.(
      with_open_text fname (fun ic ->
          input_all ic |> Ibkr_cp.Account_j.accounts_of_string))
  in
  let literal =
    Ibkr_cp.Account_t.
      { accounts = [ "DU9999999" ]; selectedAccount = "DU9999999" }
  in
  let expected = 0 in
  let result = compare literal json in
  Alcotest.(check int) description expected result

let () =
  Alcotest.run "Account"
    [
      ( "Account_j.accounts_of_string",
        [ test "json blob parses into Account literal" test_parse_account ] );
    ]
