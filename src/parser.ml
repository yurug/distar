open Cmdliner

(* Print argument values *)
let print_files sources target =
  Format.printf "distar\n\
                 |-source(s): %s\n\
                 |-target: %s\n"
    (String.concat " / " sources) target

(* Print wrong target error with cmdliner style *)
let target_error target =
  "DEST... arguments: no `"^target^"' file or directory\n"

(* Describe distar usages *)
let usage () = 
  "\rUsage: distar [OPTION]... SOURCE... DEST\n\
   \rTry `distar --help' for more information.\n"
    
(* Print the value of the arguments passed through the command line
   with [sources] and [target] *)
let distar prompt sources target =
  if not (Sys.file_exists target) then
    `Error (false, (target_error target)^(usage ()))
  else if prompt then
    `Ok  (print_files sources target)
  else
    `Ok (Format.printf "Ok\n")

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


(* Create man, specify arguments and normalize command for cmdliner with const *)
let cmd =
  let doc = "Track modification in code and update it in documentation" in
  let man =
    [
      `S Manpage.s_bugs;
      `P "Email them to <yann.regis-gianas@irif.fr> <etiennemarais@protonmail.com>";]
  in
  Term.(ret (const distar $ verbose $ sources $ target)),
  Term.info "distar" ~version:"v0.1" ~doc ~exits:Term.default_exits ~man
