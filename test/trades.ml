open Ibkr_cp

let test description f = Alcotest.test_case description `Quick (f description)

(* Path relative to test module: <project dir>/_build/default/test *)
let rel_resource_base = "../../../test/resource"

let test_parse_trade description () =
  let fname = Printf.sprintf "%s/trades.json" rel_resource_base in
  let json =
    In_channel.(
      with_open_text fname (fun ic -> input_all ic |> Trades_j.trades_of_string))
  in
  let trade_literal =
    Ibkr_cp.Trades_t.
      {
        execution_id = "00000a00.0000adbc.00.00";
        symbol = "IOT";
        side = Trade_side.Buy;
        order_description = "Bot 255 @ 23.25 on IEX";
        trade_time = "20231019-19:56:01";
        trade_time_r = 1697745361000;
        size = 255.0;
        price = "23.25";
        order_ref = Some "bb_short-SHORT-CLOSE-BUY-IOT-ExitRule-2023_10_19";
        exchange = "IEX";
        net_amount = 5928.75;
        account = "DU9999999";
        accountCode = "DU9999999";
        company_name = "SAMSARA INC-CL A";
        contract_description_1 = "IOT";
        sec_type = "STK";
        conid = 532274461;
        conidEx = "532274461";
        clearing_id = "IB";
        clearing_name = "IB";
        liquidation_trade = "0";
        commission = "1.27";
      }
  in
  let trade = List.nth json 0 in
  let expected = Trades_j.string_of_trade trade_literal in
  let result = Trades_j.string_of_trade trade in
  Alcotest.(check string) description expected result

let () =
  Alcotest.run "Trades"
    [
      ( "Trades_j.trades_of_string",
        [ test "json blob parses into Trades literal" test_parse_trade ] );
    ]
