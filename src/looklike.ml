(* tell if [x] is in [tab] bounds *)
let in_array_bound tab x =
  x >= 0 && x < (Array.length tab)

(* give the value at position [i],[j] in [tab] *)
let give_tab_value tab (i,j)=
  if (in_array_bound tab i) && (in_array_bound tab.(i) j)
  then tab.(i).(j)
  else 0

(* update *)
let update_value tab (i,j) plus =
  if plus then
    tab.(i).(j) <- 1+ give_tab_value tab (i-1,j-1)  
  else
    tab.(i).(j)<- 0

(* Create tab with size [x] [y] *)
let create_tab x y = 
  Array.make_matrix x y 0

(* Compare two lines *)
let compare_strings doc_line source_line =
  (String.trim doc_line) = (String.trim source_line)


let fill_array doc sources = 
  let match_tab = create_tab (List.length doc) (List.length sources)
  in  
  let rec compare_and_fill (i,j) compare = function
    | [] -> ()
    | line::lines -> (
        compare_strings compare line |> update_value match_tab (i,j);
        compare_and_fill (i,j+1) compare lines
      )
  in 
  let rec scroll_array i sources = function
    | [] -> match_tab
    | line::lines -> (
        compare_and_fill (i,0) line sources ;
        scroll_array (i+1) sources lines
      )
  in scroll_array 0 sources doc

