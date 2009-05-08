open Graph
open Graph.Pack.Digraph

let vertices n = Array.mapi (fun i _ -> V.create i) (Array.make n ())

let fromMatrix n x =
  let g = create () in
  let v = vertices n in
    for i = 0 to n-1 do
      for j = 0 to n-1 do
        if x.(i).(j) > 0.0
        then begin
          add_edge g v.(i) v.(j)
        end
      done
    done;
    let wl = Array.make n (0.0,0.0) in
      for i = 0 to n-1 do
	for j = 0 to n-1 do
	  let (w,l) = wl.(i) in
	    wl.(i) <- (w +. x.(i).(j),l);
	    let (w,l) = wl.(j) in
	      wl.(j) <- (w, l +. x.(i).(j))
	done
      done;
      wl,g
(*
module C = Components.Make(G)
open C

module P = Path.Check(G)
*)

open List
open Graph.Pack.Digraph

module IntComp = struct 
  type t = int * float * V.t list
  let compare (x,_,_) (y,_,_) = compare x y
  let hash (x,_,_) = Hashtbl.hash x
  let equal (x,_,_) (y,_,_) = x = y
end



module S = Imperative.Digraph.Concrete(IntComp)

type sccRecord = SccRecord of S.t * (float * float) array

(*module C = Components.Make(S)*)

module P = Path.Check(S)


let sizedSccDag (wl,g) = 
  let (n,find) = Components.scc g in
  let arls = Components.scc_array g in
  let ans = S.create ?size:(Some n) () in
  let v = Array.make n (0,0.0,[]) in
    for i = 0 to n-1 do
      let m = float (List.length arls.(i)) in
      let ratio (x,y) = x /. (x +. y) in
      let records = List.map (fun i -> ratio wl.(V.label i)) arls.(i) in
      let listSum x = List.fold_left (+.) 0.0 x in
      let mean = listSum records /. m in
      let square x = x *. x in
      let devSum = listSum (List.map (fun v -> square (v -. mean)) records) in
      let _ = sqrt devSum /. m in
	v.(i) <- (i,mean,arls.(i));
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
