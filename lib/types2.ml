type 'a ctx2 = {
  account_id : string;
  base_url : string;
  call :
    ?caller:string ->
    ?timeout:float ->
    ?meth:Cohttp.Code.meth ->
    ?skip_verify:bool ->
    ?headers:Cohttp.Header.t ->
    ?body:Cohttp_lwt.Body.t ->
    parser:(string -> 'a) ->
    Uri.t ->
    ('a, string) result Lwt.t;
}
