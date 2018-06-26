(* Tell if two strings are equals *)
let equal str1 str2 = 
  (String.trim str1) = (String.trim str2)


(* get a string list corresponding to the [file]
   content *)
let lines_from file =
  let f_in = open_in file in
  let rec get_lines lines =
    try
      lines@[input_line f_in] 
      |> get_lines 
    with End_of_file -> close_in f_in ; lines
  in
  get_lines []


(* Insert [to_insert] reference(s) into [content] *)
let search_and_add content to_insert =
  let rec search_aux no = function
    | [] -> []
    | line::lines -> (
        match List.find_opt (fun (i,str) -> i = no) to_insert with
        | None -> line:: (search_aux (no+1) lines)
        | Some (_,new_line) -> new_line::line::search_aux (no+1) lines
      )
  in search_aux 0 content


(* write the [new_content] in the [file] *)
let write_in file new_content =
  let f_out = open_out file
  in
  List.iter (
    fun line ->
      output_string f_out line ;
      output_char f_out '\n';
  ) new_content ; close_out f_out


(* update the [file] with [addition] which are pairs of 
   expressions and new lines *)
let update_file addition file =
  let content = lines_from file in
  search_and_add content addition |> write_in file