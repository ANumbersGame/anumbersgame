open Graph
(*
module IntComp = struct 
  type t = int 
  let compare = compare 
  let hash = Hashtbl.hash 
  let equal = (=)
end
*)
open Graph.Pack.Digraph
(*
module G = Imperative.Digraph.Concrete(IntComp)
open G
*)

let vertices n = Array.mapi (fun i _ -> V.create i) (Array.make n ())

let fromMatrix n x =
  let g = create () in
  let v = vertices n in
    for i = 0 to n-1 do
      for j = 0 to n-1 do
        if x.(i).(j) > 0.0
        then begin
          add_vertex g v.(i);
          add_vertex g v.(j);
          add_edge g v.(i) v.(j)
        end
      done
    done;
    g
(*
module C = Components.Make(G)
open C

module P = Path.Check(G)
*)

open List
(*
let sccDag g = 
  let (n,find) = Components.scc g in
  let arls = Components.scc_array g in
  let ans = create ?size:(Some n) () in
  let p = PathCheck.create g in
  let v = vertices n in
    for i = 0 to n-1 do
      add_vertex ans v.(i)
    done;
    for i = 0 to n-1 do
      for j = 0 to n-1 do
	if i <> j
	then
          if PathCheck.check_path p (hd arls.(i)) (hd arls.(j))
          then add_edge ans v.(i) v.(j)
      done
    done;
    ans, arls, find
*)
module IntComp = struct 
  type t = int * int 
  let compare (x,_) (y,_) = compare x y
  let hash (x,_) = Hashtbl.hash x
  let equal (x,_) (y,_) = x = y
end

open Graph.Pack.Digraph

module S = Imperative.Digraph.Concrete(IntComp)

(*module C = Components.Make(S)*)

module P = Path.Check(S)


let sizedSccDag g = 
  let (n,find) = Components.scc g in
  let arls = Components.scc_array g in
  let ans = S.create ?size:(Some n) () in
  let v = Array.make n (0,0) in
    for i = 0 to n-1 do
      v.(i) <- (i,length arls.(i));
      S.add_vertex ans v.(i)
    done;
    let addmeta i j =
      let x = find i in
      let y = find j in
	if x <> y
        then S.add_edge ans v.(x) v.(y)
    in
      iter_edges addmeta g;
      ans, arls, find
(*
    for i = 0 to n-1 do
      for j = 0 to n-1 do
	if i <> j
	then
          if PathCheck.check_path p (hd arls.(i)) (hd arls.(j))
          then S.add_edge ans v.(i) v.(j)
      done
    done;
*)
