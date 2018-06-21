(** Looklike allows you to find recurrent patterns in some lists *)

(** Module type which allows comparing elements *)
module type EqType = 
sig
  type t 
  val equal : t -> t -> bool
end


(** Module for looklike to find similarity between list *)
module Make (E : EqType) =
struct

  (** Type to get pattern and its position *)
  type index_string = {
    mutable depot : E.t list;
    pos_doc :int ;
    pos_src :int 
  }

  (** tell if [x] is in [tab] bounds *)
  let in_array_bound tab x =
    x >= 0 && x < (Array.length tab)

  (** give the value at position [i],[j] in [tab] *)
  let give_tab_value tab (i,j)=
    if (in_array_bound tab i) && (in_array_bound tab.(i) j)
    then tab.(i).(j)
    else 0

  (** update *)
  let update_value tab (i,j) plus =
    if plus then
      tab.(i).(j) <- 1 + give_tab_value tab (i-1,j-1)  
    else
      tab.(i).(j) <- 0

  (** Create tab with size [x] [y] *)
  let create_tab x y = 
    Array.make_matrix x y 0


  (** Create and fill the array with the match between 
      [doc] and [source] *)
  let fill_array doc sources =
    let table = create_tab (List.length doc) (List.length sources)
    in 
    List.iteri (fun i e1 -> (
          List.iteri (fun j e2 -> (
                E.equal e1 e2 |> update_value table (i,j))
            ) sources )
      ) doc ; table

  (** Iteration which catches common values in
      [doc] and [src] at [(i,j)] *)
  let rec iter_diagonal tab (i,j) doc src = 
    match (doc,src) with
    | ([], _) | (_, []) -> []
    | _ when give_tab_value tab (i,j) = 0 -> []
    | ( l1::t1, l2::t2 ) -> (
        update_value tab (i,j) false ; 
        l1::(iter_diagonal tab (i+1,j+1) t1 t2)
      )

  (* Print for debug *)
  let print_array tab = 
    Array.iter (function e -> (
          Array.iter (function e2 ->
              Format.printf "%d " e2
            ) e ; Format.printf "\n"
        )) tab

end

(** Module with string simplify with trim *)
module PureString = 
struct
  type t = string

  let equal str1 str2 = 
    (String.trim str1) = (String.trim str2)

end

(** Default module*)
include Make(PureString)

(* An exemple => *)
let () = fill_array ["Hello" ; "Bye" ; "End"] ["Hello" ; "End" ; "Bye"] |> print_array

