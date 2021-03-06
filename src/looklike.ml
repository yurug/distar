(** Looklike allows you to find recurrent patterns in some lists *)



(** Module type to compare objects
    [t] is the generic type
    [equal] returns true if objects are equals
    [nil] is the neutral element. For instance 0 or "" *)
module type Equal = sig
  type t
  val equal : t -> t -> bool
  val nil : t
end 


(** OCaml type to get pattern and its position.
    [content] is a list of object matched in documentation and source 
    [pos_doc] is the position in documentation where the match begins 
    [pos_src] is the position in source where the match begins *)
type 'a index_string = {
  content : 'a list;
  pos_doc : int ;
  pos_src : int 
}



(** Module for looklike to find similarity between lists *)
module Make (E : Equal) =
struct
  (** tell if [x] is in [tab] bounds *)
  let in_array_bound tab x =
    x >= 0 && x < (Array.length tab)


  (** Give the value at position [i],[j] in [tab].
      If position is out-of-bounds return 0 *)
  let give_tab_value tab (i,j)=
    if (in_array_bound tab i) && (in_array_bound tab.(i) j)
    then tab.(i).(j)
    else 0


  (** Update [tab] value at position [i][j]. If
      [update] is false, it resets the value *)
  let update_value tab (i,j) update =
    if update then
      tab.(i).(j) <- 1 + give_tab_value tab (i-1,j-1)  
    else
      tab.(i).(j) <- 0


  (** Create an array with size [x] [y] *)
  let create_tab x y = 
    Array.make_matrix x y 0


  (** Create and fill the array with the match between 
      [doc] and [source] *)
  let fill_array doc sources =
    let table = create_tab (List.length doc) (List.length sources)
    in 
    List.iteri (fun i e1 -> (
          List.iteri (fun j e2 -> (
                E.equal e1 e2 
                |> update_value table (i,j))
            ) sources )
      ) doc ; table


  (** Iteration which catches common values in
      [doc] and [src] at position (i,j) *)
  let rec iter_diagonal tab (i,j) (doc:E.t list) (src:E.t list) = 
    match (doc,src) with
    | ([], _) | (_, []) -> []
    | _ when give_tab_value tab (i,j) = 0 -> []
    | ( l1::t1, _::t2 ) -> (
        update_value tab (i,j) false ; 
        l1::(iter_diagonal tab (i+1,j+1) t1 t2)
      )


  (** Add a value to an index_string list *)
  let create_index index (i,j) (add:E.t list) = 
    {content = add ; pos_doc = i ; pos_src = j }::index


  (** Find the match between strings in [docs] and [sources],
      and store them *)
  let find_all_matches docs sources =
    let tab = fill_array docs sources in
    let rec travel doc src (i,j) index = 
      match doc with
      | [] -> index
      | _::doc_r-> (
          match src with
          (* When it arrives at the end of the line, it relaunches the algorithm
             at the beginning of the next line *)
          | [] -> travel doc_r sources (i+1,0) index 
          | he::src_r -> (
              if (give_tab_value tab (i,j) != 0 ) && not (E.equal he E.nil) then
                iter_diagonal tab (i,j) doc src 
                |> create_index index (i,j) 
              else index 
            ) |> travel doc src_r (i,j+1)  
        ) in travel docs sources (0,0) [] |> List.rev

  (** Show which [source] matches with [target] and where. *)
  let show_ref doc line source line_source size = 
    Format.printf "%s:%d, reference %s:%d#%d \n" doc line source line_source size


  (** Create a tuple to insert into the documentation [doc].
      If [verbose], it shows reference(s) added *)
  let create_ref verbose doc src size index = 
    if verbose then show_ref doc (index.pos_doc+1) src (index.pos_src+1) size ;
    (
      index.pos_doc ,
      Format.sprintf "<!-- distar:%s:%d:%d -->" src (index.pos_src + 1) size
    )


  (** Create all the references needed to be add
      to the documentation. If [verbose], it shows reference(s) added *)
  let prepare_ref  verbose doc src list =
    if verbose then Format.printf "Reference(s)\n" ;
    let rec prepare_aux src list acc =
      match list with 
      | [] -> acc
      | head::tail -> (create_ref verbose doc src (List.length head.content) head)::acc
                      |> prepare_aux src tail 
    in prepare_aux src list []


end


(** Module for using string simplify with trim *)
module TrimString  = 
struct
  type t = string

  let equal str1 str2 = 
    (String.trim str1) = (String.trim str2)

  let nil = ""

end


(** Default module *)
include Make(TrimString)
