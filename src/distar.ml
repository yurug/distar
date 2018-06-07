(**************************************************************************)
(*  Copyright (C) 2018 Yann Régis-Gianas, Étienne Marais                  *)
(*                                                                        *)
(*  This is free software: you can redistribute it and/or modify it       *)
(*  under the terms of the GNU General Public License, version 3.         *)
(**************************************************************************)

open Cmdliner

let () = Term.(exit @@ eval Parser.cmd )
