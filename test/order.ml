open Ibkr_cp

let test description f = Alcotest.test_case description `Quick (f description)

(* Path relative to test module: <project dir>/_build/default/test *)
let rel_resource_base = "../../../test/resource"

let test_create_mkt_order description () =
  let fname =
    Printf.sprintf "%s/order_place_order_mkt.json" rel_resource_base
  in
  let json =
    In_channel.(
      with_open_text fname (fun ic -> input_all ic |> Order_j.order_of_string))
  in
  let literal =
    Order_t.
      {
        acctId = "DU9999999";
        conidex = "532274461";
        cOID = "bb_short-SHORT-CLOSE-BUY-IOT-ExitRule-2023_10_17";
        orderType = Mkt;
        listingExchange = "SMART";
        outsideRTH = false;
        price = None;
        side = Buy;
        ticker = "IOT";
        tif = Day;
        quantity = 768;
        useAdaptive = false;
        trailingAmt = None;
        trailingType = None;
      }
  in
  let expected = 0 in
  let result = Stdlib.compare literal json in
  Alcotest.(check int) description expected result

let test_round_trip_lmt_order description () =
  let fname =
    Printf.sprintf "%s/order_place_order_lmt.json" rel_resource_base
  in
  let expected =
    In_channel.(with_open_text fname (fun ic -> input_all ic |> String.trim))
  in
  let literal =
    Order_t.
      {
        acctId = "DU9999999";
        conidex = "101694297";
        cOID = "bb_short-SHORT-OPEN-SELL-MTDR-REASON-2023_10_17";
        orderType = Lmt;
        listingExchange = "SMART";
        outsideRTH = false;
        price = Some (Bigdecimal.of_string "65.26");
        side = Sell;
        ticker = "MTDR";
        tif = Day;
        quantity = 18;
        useAdaptive = false;
        trailingAmt = None;
        trailingType = None;
      }
  in
  let result = Order_j.string_of_order literal in
  Alcotest.(check string) description expected result

let () =
  Alcotest.run "Order"
    [
      ( "Order_j.order_of_string mkt",
        [ test "json blob parses into Order literal" test_create_mkt_order ] );
      ( "Order_j.order_of_string lmt",
        [ test "json blob parses into Order literal" test_round_trip_lmt_order ]
      );
    ]
