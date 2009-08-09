open Eig
open Bigarray
open Format

module P = Pervasives

(* The graph we run FiarBets on is a directed graphs with positive integral edge weights *)

open Graph

module Vertex = struct
  type t = int
  let compare = P.compare
  let hash x = Hashtbl.hash x
  let equal x y = x=y
end

module G = Imperative.Digraph.Concrete (Vertex)

module C = Components.Make(G)

(* 
To run FairBets, we divide the graph into strongly connected components, then create an adjacency matrix for each SCC. The edge weights are made into floats, even though they are integral, since the domain of the eigenvector calculation is the reals. 

submats takes the adjacency matrix of the entire tournament/season, as well as its multidigraph, and returns an array in which each element represents a league. The representation of a league is a list of the team numbers followed by its adjacency matrix.
*)

let submats mat g =
  let h = C.scc_array g in
  let n = Array.length h in
  let ans = Array.make n ([], Array.make_matrix 0 0 0.0) in
    for i = 0 to n-1 do
      let alist = h.(i) in
      let m = List.length alist in
      let amat = Array.make_matrix m m 0.0 in
        for j = 0 to m-1 do
          for k = 0 to m-1 do
	    let lof x = List.nth alist x in
              amat.(j).(k) <- float mat.(lof j).(lof k)
          done
        done;
        ans.(i) <- (alist, amat)
    done;
    ans

(*
findMax returns a list of all the indices of a Bigarray where it achieves its maximum
*)
let findMax a =
  let n = Array1.dim a in
  let v = ref neg_infinity in
  let l = ref [] in
    for i = 1 to n do
      if a.{i} >= !v
      then 
	(if a.{i} > !v
	 then begin 
	   v := a.{i};
	   l := [i]
	 end
	 else l := i :: !l)
    done;
    !l

let rec findzeros' i l a =
  match l with
    | [] -> a
    | hd::tl ->
	if i.{hd} = 0.0
	then findzeros' i tl (hd::a)
	else findzeros' i tl a

(*
findzeros takes a Bigarray i and a list l, and returns a list of all of the values in l such that i.{l} = 0.0
*)
let findzeros i l =
  findzeros' i l []
	      
(*
unbig turns a Bigarray into a regular OCaml array
*)
let unbig x =
  let n = Array1.dim x in
  let ans = Array.make n 0.0 in
    for i = 1 to n do
      ans.(i-1) <- x.{i}
    done;
    ans

let transpose a =
  let n = Array.length a in
  let ans = Array.make_matrix n n 0 in
    for i = 0 to n-1 do
      for j = 0 to n-1 do
	ans.(i).(j) <- a.(j).(i) 
      done
    done;
    ans

(*
Following Slutzki and Vloj, (astar x).(j) is the number of losses for team j
*)
let astar x =
  let n = Array.length x in
  let ans = Array.make n 0.0 in
    for i = 0 to n-1 do
      for j = 0 to n-1 do
        ans.(j) <- ans.(j) +. x.(i).(j)
      done
    done;
    ans

(*
This is C_A^{-1}A from S & V
*)
let transRightInv a =
  let c = astar a in
  let n = Array.length a in
  let ans = Array.make_matrix n n 0.0 in
    for i = 0 to n-1 do
      for j = 0 to n-1 do
	(* If a team has no losses, it should not be in an SCC with any other teams, so c.(i) should never be 0. *)
	ans.(i).(j) <- a.(i).(j) /. c.(i)
      done
    done;
    ans

(*
For debugging 
*)
let print_mat x =
  let n = Array.length x in
    for i = 0 to n-1 do
      for j = 0 to n-1 do
	print_float x.(i).(j);
	print_string "\t"
      done;
      print_newline ()
    done;
    print_newline ()

(*
getBets performs the actual FB calculation. The return value is an array of the bets in order of the team place in the adjacency matrix of the league.
*)
let getBets mat = 
  let n = Array.length mat in
    if n = 1 (* If the league only has one team, there is no calculation to make *)
    then Array.make 1 1.0
    else 
  let real,imag,eigv = rightEigenColumns (transRightInv mat) in
  let maxs = findMax real in (* Find the eigenvalue with the maximum real component *)
  let zeros = findzeros imag maxs in (* Find one with no imaginary component *)
    if List.length zeros <> 1 (* If we do not find a unique radius, there is an error *)
    then begin 
      print_endline "Error: no unique spectral radius found";
      print_mat mat;
      assert false
    end
    else 
      (* If we find a unique radius, get the associated eigenvector *)
      let ans = unbig (Array2.slice_right eigv (List.hd zeros)) in
	if ans.(0) < 0.0 (* Since eigenvectors are only unique up to multiplication by a constant, make sure it is positive *)
	then Array.map (fun x -> -.x) ans
	else ans

let assocList_to_arr a =
  let m = List.fold_right (fun (i,_) o -> max i o) a 0 in
  let ans = Array.make (m+1) "" in
  let f (i,s) = ans.(i) <- s in
    List.iter f a;
    ans

let fairBets s =
  let noma = [|"A";"B";"C";"D";"E";"F"|] in
    (* An example from Russell Hanes *)
  let mat = 
    [|[|0;1;0;1;1;1|]; 
      [|0;0;1;0;1;1|]; 
      [|1;0;0;0;1;1|]; 
      [|0;1;1;0;0;1|];
      [|0;0;0;1;0;1|];
      [|0;0;0;0;0;0|]|] in
(*
  let mat = 
    [|[|0;1;1;1;1;0|]; 
      [|0;0;1;1;1;1|]; 
      [|0;0;0;1;1;1|]; 
      [|0;0;0;0;1;1|];
      [|0;0;0;0;0;1|];
      [|1;0;0;0;0;0|]|] in *)
  let g = G.create () in
    let n = Array.length mat in
      for i = 0 to n-1 do
	for j = 0 to n-1 do
	  if mat.(i).(j) > 0
	  then G.add_edge g i j
	done
      done;
      let subm = submats mat g in
      let ranks = Array.map (fun (n,m) -> (n,getBets m)) subm in
	noma,g,ranks


let printBets : (float * int * string) array array -> unit = fun a ->
  let n = Array.length a in
    for i = 0 to n-1 do
      print_endline "ratio   \tbounty/fee\tteam number\tteam name";
      let m = Array.length a.(i) in
	for j = 0 to m-1 do
	  let (v,ii,n) = a.(i).(j) in
	    if j <> m-1
	    then begin
	      let (v',_,_) = a.(i).(j+1) in
		printf "%f\t" (v /. v')
	    end
	    else begin printf "        \t" end;
	    printf "%f\t" v;
	    printf "%i          \t" ii;
	    printf "%s\n" n
	done;
	print_newline ()
    done

let sortBets : string array -> (int list * float array) array -> (float * int * string) array array = 
fun noma ranks ->
  let name l i v = v,List.nth l i,noma.(List.nth l i) in
  let each (n,m) = Array.mapi (name n) m in
  let unso = Array.map each ranks in
  let comp i j = -((P.compare i j)) in
    Array.iter (Array.sort comp) unso;
    unso

let () =
  let n,_,r = fairBets "DebateResults0809" in
    printBets (sortBets n r)
