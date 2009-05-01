open WinsGraph
open ReadWinMatrix
open Graph

let wins = fillWins ()

let district1qual2009bad () = Array.map (Array.map float)
  [|[|0;1;0;0;1;1;1;1;0;0;0;1|]; (*Cal beat everyone they debated*)
    [|0;0;1;0;0;0;0;0;0;0;0;0|]; (*Chico only beat Fullerton RS*)
    [|0;0;0;0;0;0;0;0;0;1;1;0|]; (*Fullerton RS only beat SF GS and UCLA*)
    [|0;0;0;0;1;0;0;1;0;1;0;1|];
    [|0;0;1;0;0;0;0;0;0;1;1;0|];
    [|0;1;1;1;0;0;0;0;0;0;0;0|]; (*SLO only beat Chico and the Fullertons *)
    [|0;0;0;0;0;0;0;1;1;1;1;0|]; (*Redlands beat both SFs, Sac, and UCLA*)
    [|0;1;1;0;0;0;0;0;0;1;0;0|];
    [|0;0;0;1;1;1;0;0;0;0;1;0|];
    [|0;0;0;0;0;0;0;0;0;0;1;0|]; (* SFSU GS only beat UCLA *)
    [|0;1;0;0;0;0;0;0;0;0;0;0|]; (* UCLA only beat Chico *)
    [|0;1;0;0;0;1;1;0;1;0;0;0|]|]

(*let wins = district1qual2009bad ()*)

open Graph.Pack.Digraph

(*module A = Graphviz.DotAttributes*)

let int_to_char x = 
  let bigA = int_of_char 'A' in
    char_of_int (bigA + x)

let int_to_name x =
  let one = int_to_char (x mod 26) in
  let two = int_to_char ((x/26) mod 26) in
    String.make 1 one ^ String.make 1 two

module Sized = 
  struct 
    module S = Imperative.Digraph.Concrete(IntComp)
    include S
    let vertex_attributes (_,s) = 
      let t = ((float s) /. 2.0) in
      let golden = 1.69 in
      let small = (4.0 /. 3.14) *. (sqrt t) /. golden in
      let large = (sqrt t) *. golden in
	[`Fixedsize true; `Width large; `Height small; `Shape `Ellipse]

    let graph_attributes _ = []
    let default_vertex_attributes _ = []
    let vertex_name (a,s) = (string_of_int a) ^ "a" ^ (string_of_int s)
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
