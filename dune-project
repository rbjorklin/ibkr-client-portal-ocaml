(lang dune 3.12)

(name ibkr_cp)

(generate_opam_files true)

(source
 (github rbjorklin/ibkr-client-portal-ocaml))

(authors "Robin Björklin")

(maintainers "Robin Björklin")

(license "Apache-2.0 WITH LLVM-exception")

(documentation https://rbjorklin.github.io/ibkr-client-portal-ocaml/)

(package
 (name ibkr_cp)
 (synopsis "Thin wrapper for IBKR Client Portal API")
 (description "Thin wrapper for IBKR Client Portal API")
 (depends
  (alcotest
   (and :with-test (>= 1.2.3)))
  (atdgen-runtime
   (>= 2.10.0))
  (bigdecimal
   (>= v0.16.0))
  (bisect_ppx
   (and :with-test (>= 2.8.3)))
  (cohttp-lwt-unix
   (>= 5.0.0))
  (dune
   (>= 3.12.1))
  (lwt
   (>= 5.6.1))
   ocaml
  (uri
   (>= 4.4.0))
  (websocket-lwt-unix
   (>= 2.15))
  yojson)
 (tags (interactive brokers client portal)))
