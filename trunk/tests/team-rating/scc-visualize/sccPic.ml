open WinsGraph
open ReadWinMatrix
open Graph
open ClearLosers

let noms,wins = fillWins ()

open Graph.Pack.Digraph

(*module A = Graphviz.DotAttributes*)
(*
let int_to_char x = 
  let bigA = int_of_char 'A' in
    char_of_int (bigA + x)

let int_to_name x =
  let one = int_to_char (x mod 26) in
  let two = int_to_char ((x/26) mod 26) in
    String.make 1 one ^ String.make 1 two
*)

let rgb v =
  let i = truncate (v *. 383.999) in
    if i <= 255
    then 
	255*256*256 + i*256
    else
       (255-(i-256))*256*256 + 255*256

let rgbRYG i =
  if i <= 127
  then 
    255*256*256 + 2*i*256
  else let i = i-128 in
    if i <= 63
    then (255-2*i)*256*256 + 255*256
    else let i = i-64 in
      (127-i)*256*256 + (255-i)*256

let rgb v =
  let i = truncate (v *. (512.0 -. 0.001 -. 128.0)) in
    if i <= 63
    then 
	(255-(63-i))*256*256 + (63-i)
    else rgbRYG (i-64)
		

let between_int x y r =
  let d = y-x in
  let r' = truncate (r *. (float d))
  in x + r'

let between_rgb (r,g,b) (r',g',b') x =
  (between_int r r' x,
   between_int g g' x,
   between_int b b' x)


let between_array _ = ()

let rec between_list n fst snd tl x =
  let t = x *. (1.0 +. (float n)) in
    if t = 1.0 
    then snd
    else 
      let t = truncate t in
	match t with
	  | 0 -> between_rgb fst snd x
	  | _ -> 
		let x' = x -. (1.0 /. (1.0 +. (float n))) in
		  between_list n snd (List.hd tl) (List.tl tl) x'

let rgb x =
  let (r,g,b) = between_list 7 (128,0,0) (205,0,0)
    [(242,101,0);(255,162,0);(255,239,97);(200,255,0);(0,255,0);(33,184,0);(18,130,0)] x
  in b + 256*g + 256*256*r


module Sized = 
  struct 
    module S = Imperative.Digraph.Concrete(IntComp)
    include S
    let vertex_attributes (a,winPercent,s) = 
      let t = ((4.0 /. 3.14) *. (float (List.length s))) in
      let golden = 1.69 in
      let small = (sqrt t) /. golden in
      let large = (sqrt t) *. golden in
      let label =  
	let rowSum j = 
	  let ans = ref 0 in
	    for i = 0 to Array.length wins -1 do
	      ans := !ans + if wins.(j).(i) > 0.0 then 1 else 0
	    done; !ans 
	in match s with
	  | [only] -> 
	      let num = Graph.Pack.Digraph.V.label only in
		noms.(num) ^ ": " ^ string_of_int (rowSum num)
	  | _ -> 
	      let winsEach = (List.map rowSum (List.map Graph.Pack.Digraph.V.label s)) in
	      let top = List.fold_left max 0 winsEach in
	      let bot = List.fold_left min 100000 winsEach in
		(string_of_int (List.length s)) ^ " teams: " ^ string_of_int bot ^ (if top = bot then " each" else " to " ^ string_of_int top)
      in
	[`Fixedsize true; `Width large; `Height small; (*`Shape `Ellipse; *)`Fontsize (truncate (10.0 *. (sqrt t)))
	; `Fillcolor (rgb winPercent); `Style `Filled; `Label label]

    let graph_attributes _ = [`Label "replace.tournament.name.with.shorter.string.anumbersgame.net";`Fontsize 40]
    let default_vertex_attributes _ = []
    let vertex_name (a,sd,s) = string_of_int a
    let get_subgraph _ = None
    let default_edge_attributes _ = []
    let edge_attributes _ = []

  end



(*
let g,_,_ = sccDag (fromMatrix (Array.length wins) wins)
*)
let h,_,_ = sizedSccDag (fromMatrix (Array.length wins) wins)

open Graph.Pack.Digraph

module GV = Graphviz.Dot(Sized)

(*let () = dot_output g "whyisthisparam"*)

let () = GV.output_graph stdout h
