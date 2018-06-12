open Cmdliner

let () = Term.(exit @@ eval Parser.cmd )
