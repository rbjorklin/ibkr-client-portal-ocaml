val search :
  ?timeout:float ->
  client:Client.t ->
  string -> (Contract_j.search, string) result Lwt.t
val details :
  ?timeout:float ->
  client:Client.t ->
  int -> (Contract_j.details, string) result Lwt.t
