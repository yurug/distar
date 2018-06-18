(* get a string list corresponding to the [file]
   content *)
let lines_from file =
  let f_in = open_in file in
  let rec get_lines lines =
    try
      lines@[input_line f_in] |> get_lines 
    with End_of_file -> close_in f_in ; lines
  in
  get_lines []


(* search [expr] in [content] string list and
   add [new_line] above [expr] *)
let search_and_add expr new_line content  =
  let rec search_aux acc = function
    | [] -> acc
    | line::lines ->
      if line = expr then
        search_aux (acc @ [new_line] @ [line]) lines
      else
        search_aux (acc @ [line]) lines
  in
  search_aux [] content
    

(* write the [new_content] in the [file] *)
let write_in file new_content =
  let f_out = open_out file
  in
  List.iter (
    function line ->
      output_string f_out line ;
      output_char f_out '\n';
  ) new_content


(* Change the [content] list with a pair list of 
   expressions and new lines *)
let rec update_list_with content = function
  | [] -> content
  | (expr, new_line)::t
    -> update_list_with (search_and_add expr new_line content) t

(* update the [file] with [addition] which are pairs of 
   expressions and new lines *)
let update_file addition file =
  let content = lines_from file in
  update_list_with content addition |> write_in file


