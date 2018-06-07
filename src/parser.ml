(**************************************************************************)
(*  Copyright (C) 2018 Yann Régis-Gianas, Étienne Marais                  *)
(*                                                                        *)
(*  This is free software: you can redistribute it and/or modify it       *)
(*  under the terms of the GNU General Public License, version 3.         *)
(*                                                                        *)
(*  Additional terms apply, due to the reproduction of portions of        *)
(*  the POSIX standard. Please refer to the file COPYING for details.     *)
(**************************************************************************)



open Cmdliner


(* print the value of the arguments passed through the command line
   with [sources] and [target] *)
let distar prompt sources target =
  if not (Sys.file_exists target)
  then
    `Error (false, "You are using wrong source(s)")
  else
  if prompt
  then
    `Ok  (Printf.printf "distar\n\
                         |-source(s): %s\n\
                         |-target: %s\n"
            (String.concat " / " sources) target)
  else
    `Ok (Printf.printf "Ok\n")

(* Describe how sources must be read from the command line *)
let sources =
  let doc = "Source(s) used by distar to match code." in
  Arg.(non_empty & pos_left ~rev:true 0 file [] & info [] ~docv:"SOURCE" ~doc)


(* Describe how target argument must be read from command line *)
let target =
  let doc = "Target file where the documentation is written" in
  Arg.(required & pos ~rev:true 0 (some string) None & info [] ~docv:"DEST" ~doc)

(* Flag that tells if distar print cmd content or not *)
let verbose =
  let doc = "Show tracked and documentation files." in
  Arg.(value & flag & info ["v"; "verbose"]  ~doc)


(* Create man, specify args and normalize command for cmdliner with const *)
let cmd =
  let doc = "Track modification in code and update it in documentation" in
  let man =
    [
      `S Manpage.s_bugs;
      `P "Email them to <yann.regis-gianas@irif.fr> <etiennemarais@protonmail.com>";]
  in
  Term.(ret (const distar $ verbose $ sources $ target)),
  Term.info "distar" ~version:"v0.1" ~doc ~exits:Term.default_exits ~man
