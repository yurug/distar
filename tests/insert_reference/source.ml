(* Ocaml file from where we want to copy some code *)

let rec fac n = if n <= 0 then 1 else fac (n-1)*n

let fac_6 = fac 6
