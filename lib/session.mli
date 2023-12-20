val status :
  ?timeout:float ->
  client:Client.t ->
  unit -> (Session_j.status, string) result Lwt.t
val validate :
  ?timeout:float ->
  client:Client.t ->
  unit -> (Session_j.validate, string) result Lwt.t
val reauthenticate :
  ?timeout:float ->
  client:Client.t ->
  unit -> (Session_j.reauthenticate, string) result Lwt.t
val tickle :
  ?timeout:float ->
  client:Client.t ->
  unit -> (Session_j.tickle, string) result Lwt.t
val logout :
  ?timeout:float ->
  client:Client.t ->
  unit -> (Session_j.logout, string) result Lwt.t
