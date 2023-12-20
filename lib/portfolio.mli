val position_by_conid :
  ?timeout:float ->
  client:Client.t ->
  int ->
  (Portfolio_j.positions, string) result Lwt.t

val positions :
  ?timeout:float ->
  client:Client.t ->
  unit ->
  (Portfolio_j.positions, string) result Lwt.t

val accounts :
  ?timeout:float ->
  client:Client.t ->
  unit ->
  (Portfolio_j.accounts, string) result Lwt.t

val account_summary :
  ?timeout:float ->
  client:Client.t ->
  unit ->
  (Portfolio_j.account_summary, string) result Lwt.t
